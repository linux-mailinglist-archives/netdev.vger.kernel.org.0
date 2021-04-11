Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F3435B471
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 15:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbhDKNAq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Apr 2021 09:00:46 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:37265 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235578AbhDKNAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 09:00:46 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-tUYpn0ukPfa7w1c4ph0ueg-1; Sun, 11 Apr 2021 09:00:24 -0400
X-MC-Unique: tUYpn0ukPfa7w1c4ph0ueg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62457107ACCD;
        Sun, 11 Apr 2021 13:00:22 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD4F1101E24A;
        Sun, 11 Apr 2021 13:00:19 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCHv3 bpf-next 1/5] bpf: Allow trampoline re-attach for tracing and lsm programs
Date:   Sun, 11 Apr 2021 15:00:06 +0200
Message-Id: <20210411130010.1337650-2-jolsa@kernel.org>
In-Reply-To: <20210411130010.1337650-1-jolsa@kernel.org>
References: <20210411130010.1337650-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we don't allow re-attaching of trampolines. Once
it's detached, it can't be re-attach even when the program
is still loaded.

Adding the possibility to re-attach the loaded tracing and
lsm programs.

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/syscall.c    | 23 +++++++++++++++++------
 kernel/bpf/trampoline.c |  2 +-
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6428634da57e..f416735b20b3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2645,14 +2645,25 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	 *   target_btf_id using the link_create API.
 	 *
 	 * - if tgt_prog == NULL when this function was called using the old
-         *   raw_tracepoint_open API, and we need a target from prog->aux
-         *
-         * The combination of no saved target in prog->aux, and no target
-         * specified on load is illegal, and we reject that here.
+	 *   raw_tracepoint_open API, and we need a target from prog->aux
+	 *
+	 * - if prog->aux->dst_trampoline and tgt_prog is NULL, the program
+	 *   was detached and is going for re-attachment.
 	 */
 	if (!prog->aux->dst_trampoline && !tgt_prog) {
-		err = -ENOENT;
-		goto out_unlock;
+		/*
+		 * Allow re-attach for TRACING and LSM programs. If it's
+		 * currently linked, bpf_trampoline_link_prog will fail.
+		 * EXT programs need to specify tgt_prog_fd, so they
+		 * re-attach in separate code path.
+		 */
+		if (prog->type != BPF_PROG_TYPE_TRACING &&
+		    prog->type != BPF_PROG_TYPE_LSM) {
+			err = -EINVAL;
+			goto out_put_prog;
+		}
+		btf_id = prog->aux->attach_btf_id;
+		key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf, btf_id);
 	}
 
 	if (!prog->aux->dst_trampoline ||
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 1f3a4be4b175..48b8b9916aa2 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -437,7 +437,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 		tr->extension_prog = NULL;
 		goto out;
 	}
-	hlist_del(&prog->aux->tramp_hlist);
+	hlist_del_init(&prog->aux->tramp_hlist);
 	tr->progs_cnt[kind]--;
 	err = bpf_trampoline_update(tr);
 out:
-- 
2.30.2


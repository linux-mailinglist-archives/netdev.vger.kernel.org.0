Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4852134BC2C
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 13:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhC1L1I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 28 Mar 2021 07:27:08 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:40833 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230526AbhC1L0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 07:26:48 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-JzK_RUyqOJ2QtYWoe_YUBQ-1; Sun, 28 Mar 2021 07:26:41 -0400
X-MC-Unique: JzK_RUyqOJ2QtYWoe_YUBQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F41D4107ACCA;
        Sun, 28 Mar 2021 11:26:39 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D7BD19C66;
        Sun, 28 Mar 2021 11:26:37 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC PATCH bpf-next 1/4] bpf: Allow trampoline re-attach
Date:   Sun, 28 Mar 2021 13:26:26 +0200
Message-Id: <20210328112629.339266-2-jolsa@kernel.org>
In-Reply-To: <20210328112629.339266-1-jolsa@kernel.org>
References: <20210328112629.339266-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we don't allow re-attaching of trampolines. Once
it's detached, it can't be re-attach even when the program
is still loaded.

Adding the possibility to re-attach the loaded tracing
kernel program.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/syscall.c    | 25 +++++++++++++++++++------
 kernel/bpf/trampoline.c |  2 +-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9603de81811a..e14926b2e95a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2645,14 +2645,27 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	 *   target_btf_id using the link_create API.
 	 *
 	 * - if tgt_prog == NULL when this function was called using the old
-         *   raw_tracepoint_open API, and we need a target from prog->aux
-         *
-         * The combination of no saved target in prog->aux, and no target
-         * specified on load is illegal, and we reject that here.
+	 *   raw_tracepoint_open API, and we need a target from prog->aux
+	 *
+	 * The combination of no saved target in prog->aux, and no target
+	 * specified on is legal only for tracing programs re-attach, rest
+	 * is illegal, and we reject that here.
 	 */
 	if (!prog->aux->dst_trampoline && !tgt_prog) {
-		err = -ENOENT;
-		goto out_unlock;
+		/*
+		 * Allow re-attach for tracing programs, if it's currently
+		 * linked, bpf_trampoline_link_prog will fail.
+		 */
+		if (prog->type != BPF_PROG_TYPE_TRACING) {
+			err = -ENOENT;
+			goto out_unlock;
+		}
+		if (!prog->aux->attach_btf) {
+			err = -EINVAL;
+			goto out_unlock;
+		}
+		btf_id = prog->aux->attach_btf_id;
+		key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf, btf_id);
 	}
 
 	if (!prog->aux->dst_trampoline ||
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 4aa8b52adf25..0d937c63fc22 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -467,7 +467,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
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


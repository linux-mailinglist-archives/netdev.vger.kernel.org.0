Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240ED35CC3A
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244685AbhDLQ1v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Apr 2021 12:27:51 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:30878 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244351AbhDLQZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 12:25:47 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-5_KodHdIPwqJMn63vxAroA-1; Mon, 12 Apr 2021 12:25:21 -0400
X-MC-Unique: 5_KodHdIPwqJMn63vxAroA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8052587A82A;
        Mon, 12 Apr 2021 16:25:19 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.195.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A35160DCC;
        Mon, 12 Apr 2021 16:25:15 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     kernel test robot <lkp@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCHv4 bpf-next 1/5] bpf: Allow trampoline re-attach for tracing and lsm programs
Date:   Mon, 12 Apr 2021 18:24:58 +0200
Message-Id: <20210412162502.1417018-2-jolsa@kernel.org>
In-Reply-To: <20210412162502.1417018-1-jolsa@kernel.org>
References: <20210412162502.1417018-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

Fixing missing unlock with proper cleanup goto jump reported
by Julia.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/syscall.c    | 23 +++++++++++++++++------
 kernel/bpf/trampoline.c |  2 +-
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6428634da57e..f02c6a871b4f 100644
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
+			goto out_unlock;
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EBF36E9C3
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 13:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhD2LsM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Apr 2021 07:48:12 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:29068 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230148AbhD2LsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 07:48:09 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-wVxnK3JiPwKa6tlGaQMkOw-1; Thu, 29 Apr 2021 07:47:16 -0400
X-MC-Unique: wVxnK3JiPwKa6tlGaQMkOw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C3461006C81;
        Thu, 29 Apr 2021 11:47:15 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.195.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01D3B6F921;
        Thu, 29 Apr 2021 11:47:12 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCHv2] bpf: Add deny list of btf ids check for tracing programs
Date:   Thu, 29 Apr 2021 13:47:12 +0200
Message-Id: <20210429114712.43783-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recursion check in __bpf_prog_enter and __bpf_prog_exit
leaves some (not inlined) functions unprotected:

In __bpf_prog_enter:
  - migrate_disable is called before prog->active is checked

In __bpf_prog_exit:
  - migrate_enable,rcu_read_unlock_strict are called after
    prog->active is decreased

When attaching trampoline to them we get panic like:

  traps: PANIC: double fault, error_code: 0x0
  double fault: 0000 [#1] SMP PTI
  RIP: 0010:__bpf_prog_enter+0x4/0x50
  ...
  Call Trace:
   <IRQ>
   bpf_trampoline_6442466513_0+0x18/0x1000
   migrate_disable+0x5/0x50
   __bpf_prog_enter+0x9/0x50
   bpf_trampoline_6442466513_0+0x18/0x1000
   migrate_disable+0x5/0x50
   __bpf_prog_enter+0x9/0x50
   bpf_trampoline_6442466513_0+0x18/0x1000
   migrate_disable+0x5/0x50
   __bpf_prog_enter+0x9/0x50
   bpf_trampoline_6442466513_0+0x18/0x1000
   migrate_disable+0x5/0x50
   ...

Fixing this by adding deny list of btf ids for tracing
programs and checking btf id during program verification.
Adding above functions to this list.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
v2 changes:
  - drop check for EXT programs [Andrii]

 kernel/bpf/verifier.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2579f6fbb5c3..42311e51ac71 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13112,6 +13112,17 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 	return 0;
 }
 
+BTF_SET_START(btf_id_deny)
+BTF_ID_UNUSED
+#ifdef CONFIG_SMP
+BTF_ID(func, migrate_disable)
+BTF_ID(func, migrate_enable)
+#endif
+#if !defined CONFIG_PREEMPT_RCU && !defined CONFIG_TINY_RCU
+BTF_ID(func, rcu_read_unlock_strict)
+#endif
+BTF_SET_END(btf_id_deny)
+
 static int check_attach_btf_id(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
@@ -13171,6 +13182,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		ret = bpf_lsm_verify_prog(&env->log, prog);
 		if (ret < 0)
 			return ret;
+	} else if (prog->type == BPF_PROG_TYPE_TRACING &&
+		   btf_id_set_contains(&btf_id_deny, btf_id)) {
+		return -EINVAL;
 	}
 
 	key = bpf_trampoline_compute_key(tgt_prog, prog->aux->attach_btf, btf_id);
-- 
2.30.2


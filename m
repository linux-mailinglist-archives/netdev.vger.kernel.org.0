Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A0239A6D3
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhFCRJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230440AbhFCRJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6373613F6;
        Thu,  3 Jun 2021 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740069;
        bh=v/AaDmzeHOSL0uOmSUHpel8pKwq22kdyTmBRv3iwZAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t81L8bFVh65NdauCnJNO0PwijmYtSdI03VR4C+77nKjlHo7jzyyilV3fWLTmKOANm
         ZGoqx9dssKv/r6xipGaKdDo9iyZen+f5A4TSefVT59Ui7pNTaQj2WNJK1vRhl32PMN
         m5Imm4mybkKuFZK+S9Eg3lR2Zd5qJC66O+1FQo8fHciJ8S0hevrplZgNn29XtcHPOd
         Fh57Tx1H4dkM2D9faXJUYUED3fghWA/5pS8FyrxxwkTa5MoNFVhrYkLVNzWiy1hjf4
         iLJE6mXWyQgmVdtvlxVLW2Osq1LW5H5cjsc2EybkZvtpb0a/69gzbI2NVsFASAgVlG
         +T8OsjpVWdsSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 12/43] bpf: Add deny list of btf ids check for tracing programs
Date:   Thu,  3 Jun 2021 13:07:02 -0400
Message-Id: <20210603170734.3168284-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 35e3815fa8102fab4dee75f3547472c66581125d ]

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
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210429114712.43783-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 21247e49fe82..99d13c29af7f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12556,6 +12556,17 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
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
@@ -12615,6 +12626,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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


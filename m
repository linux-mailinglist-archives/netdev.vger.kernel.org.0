Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A9239A73E
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhFCRKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231960AbhFCRKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAAA961415;
        Thu,  3 Jun 2021 17:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740122;
        bh=SIe8eXwGuF5EDOSgod+gWAcNuDXLWMY0C1lPE6cQhkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cubLjI7BFMPwpRpN7dLYpez4/BWgtr6A7YPeYUnraDQ5xtFfPEupA6Ny1ncPjasfS
         wfLd24LxqSbJrHlQ+XCvXITGGU1Yxi9azpbeAXFNxqUJWP7snkmDlxAXo373DRV2Mx
         rfb/bb21C7+L/z0Rgay08UKrI9VtOw4i0GSo19xmUM7DtcOqcYsG4VT1tNSg5Zl9Rj
         ODK7X+i1KPgtpyEtVD1LKYFl2vAzA2Hjrfqb8WuT1Gem9AhpB/JleKlmCJ8tG9LdvA
         6BBag5AXYqQKO17S5/4NZwhX5E1Zyw/P00W4782vgGEXMpa0PMGa8rxBQzGHLieYRL
         9drYnh7BrIBzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/39] bpf: Add deny list of btf ids check for tracing programs
Date:   Thu,  3 Jun 2021 13:08:00 -0400
Message-Id: <20210603170829.3168708-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
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
index 364b9760d1a7..553e09b404be 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12206,6 +12206,17 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
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
@@ -12265,6 +12276,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		ret = bpf_lsm_verify_prog(&env->log, prog);
 		if (ret < 0)
 			return ret;
+	} else if (prog->type == BPF_PROG_TYPE_TRACING &&
+		   btf_id_set_contains(&btf_id_deny, btf_id)) {
+		return -EINVAL;
 	}
 
 	key = bpf_trampoline_compute_key(tgt_prog, btf_id);
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD53B28DC25
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 10:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgJNI4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 04:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgJNI4u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 04:56:50 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1338720725;
        Wed, 14 Oct 2020 08:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602665808;
        bh=Qc8dZfRYkcKX4pYqtu+HcTnKeAqRo/t0fMc78b3K9OA=;
        h=From:To:Cc:Subject:Date:From;
        b=gCR6i0LSw1rw+mgssiWVqN8slUTRh6miyp/j5JwkD7dWzHZ6FT3PbiKVP5gO9H8DZ
         FoMyqQ8FM7ej/Rd/HTbVSWuXH5opDM6/resMerN0dJfJvvIWSyWa5Cctvp7HX3yTKH
         eXQxziX28K7Bqto616yUViJ2F86LQZs3mQH35gmk=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net] net: sched: Fix suspicious RCU usage while accessing tcf_tunnel_info
Date:   Wed, 14 Oct 2020 11:56:42 +0300
Message-Id: <20201014085642.21167-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The access of tcf_tunnel_info() produces the following splat, so fix it
by dereferencing the tcf_tunnel_key_params pointer with marker that
internal tcfa_liock is held.

 =============================
 WARNING: suspicious RCU usage
 5.9.0+ #1 Not tainted
 -----------------------------
 include/net/tc_act/tc_tunnel_key.h:59 suspicious rcu_dereference_protected() usage!
 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by tc/34839:
  #0: ffff88828572c2a0 (&p->tcfa_lock){+...}-{2:2}, at: tc_setup_flow_action+0xb3/0x48b5
 stack backtrace:
 CPU: 1 PID: 34839 Comm: tc Not tainted 5.9.0+ #1
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
 Call Trace:
  dump_stack+0x9a/0xd0
  tc_setup_flow_action+0x14cb/0x48b5
  fl_hw_replace_filter+0x347/0x690 [cls_flower]
  fl_change+0x2bad/0x4875 [cls_flower]
  tc_new_tfilter+0xf6f/0x1ba0
  rtnetlink_rcv_msg+0x5f2/0x870
  netlink_rcv_skb+0x124/0x350
  netlink_unicast+0x433/0x700
  netlink_sendmsg+0x6f1/0xbd0
  sock_sendmsg+0xb0/0xe0
  ____sys_sendmsg+0x4fa/0x6d0
  ___sys_sendmsg+0x12e/0x1b0
  __sys_sendmsg+0xa4/0x120
  do_syscall_64+0x2d/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7f1f8cd4fe57
 Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
 RSP: 002b:00007ffdc1e193b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f1f8cd4fe57
 RDX: 0000000000000000 RSI: 00007ffdc1e19420 RDI: 0000000000000003
 RBP: 000000005f85aafa R08: 0000000000000001 R09: 00007ffdc1e1936c
 R10: 000000000040522d R11: 0000000000000246 R12: 0000000000000001
 R13: 0000000000000000 R14: 00007ffdc1e1d6f0 R15: 0000000000482420

Fixes: 3ebaf6da0716 ("net: sched: Do not assume RTNL is held in tunnel key action helpers")
Fixes: 7a47281439ba ("net: sched: lock action when translating it to flow_action infra")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/tc_act/tc_tunnel_key.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/tc_act/tc_tunnel_key.h b/include/net/tc_act/tc_tunnel_key.h
index e1057b255f69..879fe8cff581 100644
--- a/include/net/tc_act/tc_tunnel_key.h
+++ b/include/net/tc_act/tc_tunnel_key.h
@@ -56,7 +56,10 @@ static inline struct ip_tunnel_info *tcf_tunnel_info(const struct tc_action *a)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	struct tcf_tunnel_key *t = to_tunnel_key(a);
-	struct tcf_tunnel_key_params *params = rtnl_dereference(t->params);
+	struct tcf_tunnel_key_params *params;
+
+	params = rcu_dereference_protected(t->params,
+					   lockdep_is_held(&a->tcfa_lock));

 	return &params->tcft_enc_metadata->u.tun_info;
 #else
--
2.26.2


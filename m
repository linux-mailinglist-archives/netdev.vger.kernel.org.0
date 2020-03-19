Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA9E018B260
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 12:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCSLdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 07:33:45 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35565 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727045AbgCSLdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 07:33:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 795AA5C0176;
        Thu, 19 Mar 2020 07:33:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 19 Mar 2020 07:33:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mBquizU4BFTc/EBFD
        bhSQcCGpvypE5LMo9eCObarFmA=; b=j0nTTcBMYDAO6vA1mCttC0uz2fJkhT9Gi
        uQ3eG4V0RnTK+JNXnM7FgrtyeIY0tmueNZ/w8CAv4DgriB1TdiF361pyhtEurCzr
        h5QOcw1b7nOBIyzgk17nxd0QZCyfylyORm/rqwy8cbtg8BGTZTH108WFrGUgtD2P
        QbFh8vvxV3V65AftRFr2M47gUIKpSmPjlOl97RcR8308sZSr8x/0kMqD0OrlKGB3
        3/Z4CrdjBUkSh3rM+1vhrz64sswBJxGAdpjMAErRwBnUDF8CI3m75bbsDjUtvnJM
        fnIsKr5ZucNeOFIgxpxce6aeHQ4BDNZCkrPwdPOLpBlK+vHta6sUw==
X-ME-Sender: <xms:l1hzXtSC9MHf1kaTn_EF5NxbdZdT5_wYCxRVzKD9W-5CCvkrBXW_sA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefledgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudekfedrkedrudekudenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdho
    rhhg
X-ME-Proxy: <xmx:l1hzXgl0gSlt9UNyJV6AQl1o26Fxg0cOfm_1VIEsTPv6pSu2mjgFAA>
    <xmx:l1hzXhppU8YSRmxgo98tyEn1KUE6s0vygQ6PLZlHhT0fCZzAnPngIA>
    <xmx:l1hzXgZGTnCGiGTaXQg7Y5Rqvdw80OlQhRDzatv2I48MzyaxNWl9Pg>
    <xmx:l1hzXnLXy7U-d6BZtJrS79uB9q1LThPiJRA_TY-0rLE7HBMlz6K1bw>
Received: from splinter.mtl.com (bzq-79-183-8-181.red.bezeqint.net [79.183.8.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 900363280063;
        Thu, 19 Mar 2020 07:33:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, vladbu@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next] net: sched: Do not assume RTNL is held in tunnel key action helpers
Date:   Thu, 19 Mar 2020 13:33:10 +0200
Message-Id: <20200319113310.1031149-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The cited commit removed RTNL from tc_setup_flow_action(), but the
function calls two tunnel key action helpers that use rtnl_dereference()
to fetch the action's parameters. This leads to "suspicious RCU usage"
warnings [1][2].

Change the helpers to use rcu_dereference_protected() while requiring
the action's lock to be held. This is safe because the two helpers are
only called from tc_setup_flow_action() which acquires the lock.

[1]
[  156.950855] =============================
[  156.955463] WARNING: suspicious RCU usage
[  156.960085] 5.6.0-rc5-custom-47426-gdfe43878d573 #2409 Not tainted
[  156.967116] -----------------------------
[  156.971728] include/net/tc_act/tc_tunnel_key.h:31 suspicious rcu_dereference_protected() usage!
[  156.981583]
[  156.981583] other info that might help us debug this:
[  156.981583]
[  156.990675]
[  156.990675] rcu_scheduler_active = 2, debug_locks = 1
[  156.998205] 1 lock held by tc/877:
[  157.002187]  #0: ffff8881cbf7bea0 (&(&p->tcfa_lock)->rlock){+...}, at: tc_setup_flow_action+0xbe/0x4f78
[  157.012866]
[  157.012866] stack backtrace:
[  157.017886] CPU: 2 PID: 877 Comm: tc Not tainted 5.6.0-rc5-custom-47426-gdfe43878d573 #2409
[  157.027253] Hardware name: Mellanox Technologies Ltd. MSN2100-CB2FO/SA001017, BIOS 5.6.5 06/07/2016
[  157.037389] Call Trace:
[  157.040170]  dump_stack+0xfd/0x178
[  157.044034]  lockdep_rcu_suspicious+0x14a/0x153
[  157.049157]  tc_setup_flow_action+0x89f/0x4f78
[  157.054227]  fl_hw_replace_filter+0x375/0x640
[  157.064348]  fl_change+0x28ec/0x4f6b
[  157.088843]  tc_new_tfilter+0x15e2/0x2260
[  157.176801]  rtnetlink_rcv_msg+0x8d6/0xb60
[  157.190915]  netlink_rcv_skb+0x177/0x460
[  157.208884]  rtnetlink_rcv+0x21/0x30
[  157.212925]  netlink_unicast+0x5d0/0x7f0
[  157.227728]  netlink_sendmsg+0x981/0xe90
[  157.245416]  ____sys_sendmsg+0x76d/0x8f0
[  157.255348]  ___sys_sendmsg+0x10f/0x190
[  157.320308]  __sys_sendmsg+0x115/0x1f0
[  157.342553]  __x64_sys_sendmsg+0x7d/0xc0
[  157.346987]  do_syscall_64+0xc1/0x600
[  157.351142]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

[2]
[  157.432346] =============================
[  157.436937] WARNING: suspicious RCU usage
[  157.441537] 5.6.0-rc5-custom-47426-gdfe43878d573 #2409 Not tainted
[  157.448559] -----------------------------
[  157.453204] include/net/tc_act/tc_tunnel_key.h:43 suspicious rcu_dereference_protected() usage!
[  157.463042]
[  157.463042] other info that might help us debug this:
[  157.463042]
[  157.472112]
[  157.472112] rcu_scheduler_active = 2, debug_locks = 1
[  157.479529] 1 lock held by tc/877:
[  157.483442]  #0: ffff8881cbf7bea0 (&(&p->tcfa_lock)->rlock){+...}, at: tc_setup_flow_action+0xbe/0x4f78
[  157.494119]
[  157.494119] stack backtrace:
[  157.499114] CPU: 2 PID: 877 Comm: tc Not tainted 5.6.0-rc5-custom-47426-gdfe43878d573 #2409
[  157.508485] Hardware name: Mellanox Technologies Ltd. MSN2100-CB2FO/SA001017, BIOS 5.6.5 06/07/2016
[  157.518628] Call Trace:
[  157.521416]  dump_stack+0xfd/0x178
[  157.525293]  lockdep_rcu_suspicious+0x14a/0x153
[  157.530425]  tc_setup_flow_action+0x993/0x4f78
[  157.535505]  fl_hw_replace_filter+0x375/0x640
[  157.545650]  fl_change+0x28ec/0x4f6b
[  157.570204]  tc_new_tfilter+0x15e2/0x2260
[  157.658199]  rtnetlink_rcv_msg+0x8d6/0xb60
[  157.672315]  netlink_rcv_skb+0x177/0x460
[  157.690278]  rtnetlink_rcv+0x21/0x30
[  157.694320]  netlink_unicast+0x5d0/0x7f0
[  157.709129]  netlink_sendmsg+0x981/0xe90
[  157.726813]  ____sys_sendmsg+0x76d/0x8f0
[  157.736725]  ___sys_sendmsg+0x10f/0x190
[  157.801721]  __sys_sendmsg+0x115/0x1f0
[  157.823967]  __x64_sys_sendmsg+0x7d/0xc0
[  157.828403]  do_syscall_64+0xc1/0x600
[  157.832558]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: b15e7a6e8d31 ("net: sched: don't take rtnl lock during flow_action setup")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
---
 include/net/tc_act/tc_tunnel_key.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/tc_act/tc_tunnel_key.h b/include/net/tc_act/tc_tunnel_key.h
index 2b3df076e5b6..e1057b255f69 100644
--- a/include/net/tc_act/tc_tunnel_key.h
+++ b/include/net/tc_act/tc_tunnel_key.h
@@ -28,8 +28,10 @@ static inline bool is_tcf_tunnel_set(const struct tc_action *a)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	struct tcf_tunnel_key *t = to_tunnel_key(a);
-	struct tcf_tunnel_key_params *params = rtnl_dereference(t->params);
+	struct tcf_tunnel_key_params *params;
 
+	params = rcu_dereference_protected(t->params,
+					   lockdep_is_held(&a->tcfa_lock));
 	if (a->ops && a->ops->id == TCA_ID_TUNNEL_KEY)
 		return params->tcft_action == TCA_TUNNEL_KEY_ACT_SET;
 #endif
@@ -40,8 +42,10 @@ static inline bool is_tcf_tunnel_release(const struct tc_action *a)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	struct tcf_tunnel_key *t = to_tunnel_key(a);
-	struct tcf_tunnel_key_params *params = rtnl_dereference(t->params);
+	struct tcf_tunnel_key_params *params;
 
+	params = rcu_dereference_protected(t->params,
+					   lockdep_is_held(&a->tcfa_lock));
 	if (a->ops && a->ops->id == TCA_ID_TUNNEL_KEY)
 		return params->tcft_action == TCA_TUNNEL_KEY_ACT_RELEASE;
 #endif
-- 
2.24.1


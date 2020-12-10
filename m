Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EE22D6B1C
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404201AbgLJWb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 17:31:27 -0500
Received: from mga04.intel.com ([192.55.52.120]:9222 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405151AbgLJW3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 17:29:46 -0500
IronPort-SDR: bpxhDUNwVt8rZ+R/ABIvZek/qGWyzDTMIBZmjKDlMUECYKhFz38I+YdplK20mrohAlVRmLgxFH
 n3gva2oD116w==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="171776480"
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="171776480"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:14 -0800
IronPort-SDR: hEvdBZlx0+hKSEwKrpMUrTRiVI/RpqC0Q+TZOwENpn/pMZyNqPyI/atMLxrMFeLjbShaIGFRA+
 ro4pcZ1n4NYg==
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="338703751"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.112.51])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:13 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/9] mptcp: remove address when netlink flushes addrs
Date:   Thu, 10 Dec 2020 14:24:59 -0800
Message-Id: <20201210222506.222251-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
References: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

When the PM netlink flushes the addresses, invoke the remove address
function mptcp_nl_remove_subflow_and_signal_addr to remove the addresses
and the subflows. Since this function should not be invoked under lock,
move __flush_addrs out of the pernet->lock.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 5151cfcd6962..9cc4eefaf080 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -867,13 +867,14 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
-static void __flush_addrs(struct pm_nl_pernet *pernet)
+static void __flush_addrs(struct net *net, struct list_head *list)
 {
-	while (!list_empty(&pernet->local_addr_list)) {
+	while (!list_empty(list)) {
 		struct mptcp_pm_addr_entry *cur;
 
-		cur = list_entry(pernet->local_addr_list.next,
+		cur = list_entry(list->next,
 				 struct mptcp_pm_addr_entry, list);
+		mptcp_nl_remove_subflow_and_signal_addr(net, &cur->addr);
 		list_del_rcu(&cur->list);
 		kfree_rcu(cur, rcu);
 	}
@@ -890,11 +891,13 @@ static void __reset_counters(struct pm_nl_pernet *pernet)
 static int mptcp_nl_cmd_flush_addrs(struct sk_buff *skb, struct genl_info *info)
 {
 	struct pm_nl_pernet *pernet = genl_info_pm_nl(info);
+	LIST_HEAD(free_list);
 
 	spin_lock_bh(&pernet->lock);
-	__flush_addrs(pernet);
+	list_splice_init(&pernet->local_addr_list, &free_list);
 	__reset_counters(pernet);
 	spin_unlock_bh(&pernet->lock);
+	__flush_addrs(sock_net(skb->sk), &free_list);
 	return 0;
 }
 
@@ -1156,10 +1159,12 @@ static void __net_exit pm_nl_exit_net(struct list_head *net_list)
 	struct net *net;
 
 	list_for_each_entry(net, net_list, exit_list) {
+		struct pm_nl_pernet *pernet = net_generic(net, pm_nl_pernet_id);
+
 		/* net is removed from namespace list, can't race with
 		 * other modifiers
 		 */
-		__flush_addrs(net_generic(net, pm_nl_pernet_id));
+		__flush_addrs(net, &pernet->local_addr_list);
 	}
 }
 
-- 
2.29.2


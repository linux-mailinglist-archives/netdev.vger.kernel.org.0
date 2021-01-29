Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6C2308311
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhA2BN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:13:28 -0500
Received: from mga07.intel.com ([134.134.136.100]:6700 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231806AbhA2BNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:13:09 -0500
IronPort-SDR: lgpWVRiK71WEI+JduQIXF/c1fuxXV1t/kHaWlc6qr3oAYtAc6TZX14PYwERGvOp6YiOzMuIlhf
 wBw5isJ5qGCg==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430166"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430166"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:22 -0800
IronPort-SDR: buAhFM+rPs8O/beBcP5UQjqicaxte5GgFPQmSPtOB5UQ8Ot6NDZ2ZNVBN2m9fr2xNo3qfJzRfc
 nhb0ypO7nFjA==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538324"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:22 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 01/16] mptcp: use WRITE_ONCE/READ_ONCE for the pernet *_max
Date:   Thu, 28 Jan 2021 17:11:00 -0800
Message-Id: <20210129011115.133953-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch uses WRITE_ONCE() and READ_ONCE for all the pernet
add_addr_signal_max, add_addr_accept_max, local_addr_max and
subflows_max fields in struct pm_nl_pernet to avoid concurrency
issues.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 83976b9ee99b..7d6081d9a1db 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -572,6 +572,7 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 					     struct mptcp_pm_addr_entry *entry)
 {
 	struct mptcp_pm_addr_entry *cur;
+	unsigned int addr_max;
 	int ret = -EINVAL;
 
 	spin_lock_bh(&pernet->lock);
@@ -614,10 +615,14 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	if (entry->addr.id > pernet->next_id)
 		pernet->next_id = entry->addr.id;
 
-	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)
-		pernet->add_addr_signal_max++;
-	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW)
-		pernet->local_addr_max++;
+	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL) {
+		addr_max = READ_ONCE(pernet->add_addr_signal_max);
+		WRITE_ONCE(pernet->add_addr_signal_max, addr_max + 1);
+	}
+	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW) {
+		addr_max = READ_ONCE(pernet->local_addr_max);
+		WRITE_ONCE(pernet->local_addr_max, addr_max + 1);
+	}
 
 	pernet->addrs++;
 	list_add_tail_rcu(&entry->list, &pernet->local_addr_list);
@@ -912,6 +917,7 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
 	struct pm_nl_pernet *pernet = genl_info_pm_nl(info);
 	struct mptcp_pm_addr_entry addr, *entry;
+	unsigned int addr_max;
 	int ret;
 
 	ret = mptcp_pm_parse_addr(attr, info, false, &addr);
@@ -925,10 +931,14 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 		spin_unlock_bh(&pernet->lock);
 		return -EINVAL;
 	}
-	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)
-		pernet->add_addr_signal_max--;
-	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW)
-		pernet->local_addr_max--;
+	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL) {
+		addr_max = READ_ONCE(pernet->add_addr_signal_max);
+		WRITE_ONCE(pernet->add_addr_signal_max, addr_max - 1);
+	}
+	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW) {
+		addr_max = READ_ONCE(pernet->local_addr_max);
+		WRITE_ONCE(pernet->local_addr_max, addr_max - 1);
+	}
 
 	pernet->addrs--;
 	list_del_rcu(&entry->list);
@@ -956,9 +966,9 @@ static void __flush_addrs(struct net *net, struct list_head *list)
 
 static void __reset_counters(struct pm_nl_pernet *pernet)
 {
-	pernet->add_addr_signal_max = 0;
-	pernet->add_addr_accept_max = 0;
-	pernet->local_addr_max = 0;
+	WRITE_ONCE(pernet->add_addr_signal_max, 0);
+	WRITE_ONCE(pernet->add_addr_accept_max, 0);
+	WRITE_ONCE(pernet->local_addr_max, 0);
 	pernet->addrs = 0;
 }
 
@@ -1130,12 +1140,12 @@ mptcp_nl_cmd_set_limits(struct sk_buff *skb, struct genl_info *info)
 	int ret;
 
 	spin_lock_bh(&pernet->lock);
-	rcv_addrs = pernet->add_addr_accept_max;
+	rcv_addrs = READ_ONCE(pernet->add_addr_accept_max);
 	ret = parse_limit(info, MPTCP_PM_ATTR_RCV_ADD_ADDRS, &rcv_addrs);
 	if (ret)
 		goto unlock;
 
-	subflows = pernet->subflows_max;
+	subflows = READ_ONCE(pernet->subflows_max);
 	ret = parse_limit(info, MPTCP_PM_ATTR_SUBFLOWS, &subflows);
 	if (ret)
 		goto unlock;
-- 
2.30.0


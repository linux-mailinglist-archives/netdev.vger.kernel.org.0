Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFBE30B327
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 00:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBAXLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 18:11:14 -0500
Received: from mga12.intel.com ([192.55.52.136]:51849 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhBAXLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 18:11:12 -0500
IronPort-SDR: 6R+pwjCocQjJAwBD2wp14/TT5tZf8159HtJCEpSnUwUtbcS2YcULqtBl0GkiUDYi21omGrMe7d
 jp3bPNP3WjFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="159934335"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="159934335"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:26 -0800
IronPort-SDR: hSQufMC24Gym1dIWr9ZEILmXqCDNx+tu8Oee4XTH934UcpP92mgByarEfi0BbwTb0UMneo1Pdj
 uTLd5UpTpTjg==
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="391188462"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.7.131])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:26 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 01/15] mptcp: use WRITE_ONCE for the pernet *_max
Date:   Mon,  1 Feb 2021 15:09:06 -0800
Message-Id: <20210201230920.66027-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
References: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch uses WRITE_ONCE() for all the pernet add_addr_signal_max,
add_addr_accept_max, local_addr_max and subflows_max fields in struct
pm_nl_pernet to avoid concurrency issues.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 83976b9ee99b..c429bd82313e 100644
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
+		addr_max = pernet->add_addr_signal_max;
+		WRITE_ONCE(pernet->add_addr_signal_max, addr_max + 1);
+	}
+	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW) {
+		addr_max = pernet->local_addr_max;
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
+		addr_max = pernet->add_addr_signal_max;
+		WRITE_ONCE(pernet->add_addr_signal_max, addr_max - 1);
+	}
+	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW) {
+		addr_max = pernet->local_addr_max;
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
 
-- 
2.30.0


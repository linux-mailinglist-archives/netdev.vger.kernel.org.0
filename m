Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B83467FF6
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 23:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383428AbhLCWjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 17:39:18 -0500
Received: from mga18.intel.com ([134.134.136.126]:46471 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383426AbhLCWjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 17:39:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="223940934"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="223940934"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:47 -0800
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="460185309"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.18.88])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:47 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 05/10] mptcp: allow changing the "backup" bit by endpoint id
Date:   Fri,  3 Dec 2021 14:35:36 -0800
Message-Id: <20211203223541.69364-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

a non-zero 'id' is sufficient to identify MPTCP endpoints: allow changing
the value of 'backup' bit by simply specifying the endpoint id.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/158
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 7b96be1e9f14..4ff8d55cbe82 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1702,22 +1702,28 @@ static int mptcp_nl_addr_backup(struct net *net,
 
 static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 {
+	struct mptcp_pm_addr_entry addr = { .addr = { .family = AF_UNSPEC }, }, *entry;
 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
 	struct pm_nl_pernet *pernet = genl_info_pm_nl(info);
-	struct mptcp_pm_addr_entry addr, *entry;
 	struct net *net = sock_net(skb->sk);
-	u8 bkup = 0;
+	u8 bkup = 0, lookup_by_id = 0;
 	int ret;
 
-	ret = mptcp_pm_parse_addr(attr, info, true, &addr);
+	ret = mptcp_pm_parse_addr(attr, info, false, &addr);
 	if (ret < 0)
 		return ret;
 
 	if (addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
 		bkup = 1;
+	if (addr.addr.family == AF_UNSPEC) {
+		lookup_by_id = 1;
+		if (!addr.addr.id)
+			return -EOPNOTSUPP;
+	}
 
 	list_for_each_entry(entry, &pernet->local_addr_list, list) {
-		if (addresses_equal(&entry->addr, &addr.addr, true)) {
+		if ((!lookup_by_id && addresses_equal(&entry->addr, &addr.addr, true)) ||
+		    (lookup_by_id && entry->addr.id == addr.addr.id)) {
 			mptcp_nl_addr_backup(net, &entry->addr, bkup);
 
 			if (bkup)
-- 
2.34.1


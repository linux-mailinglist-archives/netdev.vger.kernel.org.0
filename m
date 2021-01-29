Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA7B308323
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhA2BTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:19:00 -0500
Received: from mga07.intel.com ([134.134.136.100]:6700 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231643AbhA2BSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:18:54 -0500
IronPort-SDR: JXb1xUBYsTz5kxZU44xlue2vlQ2e3PAdHFhbj3WCIWgyH4N98vvlhN9uFGwsLTcDQcq1vN157l
 WRjST/iG6DyA==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430177"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430177"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
IronPort-SDR: YJ6HkjOTt5KqvbNFM7OK6ZwCmiOYeoVmEvUE54AM0cQAdDtdO/AUJAZSCeho4NJcZKF26tIiVZ
 7oo51g82vmYw==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538338"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 11/16] mptcp: enable use_port when invoke addresses_equal
Date:   Thu, 28 Jan 2021 17:11:10 -0800
Message-Id: <20210129011115.133953-12-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

When dealing with the addresses list local_addr_list or anno_list, we
should enable the function addresses_equal's parameter use_port. And
enable it in address_zero too.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index d6e23e079fb0..5b045023fe15 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -91,7 +91,7 @@ static bool address_zero(const struct mptcp_addr_info *addr)
 	memset(&zero, 0, sizeof(zero));
 	zero.family = addr->family;
 
-	return addresses_equal(addr, &zero, false);
+	return addresses_equal(addr, &zero, true);
 }
 
 static void local_address(const struct sock_common *skc,
@@ -131,7 +131,7 @@ static bool lookup_subflow_by_saddr(const struct list_head *list,
 		skc = (struct sock_common *)mptcp_subflow_tcp_sock(subflow);
 
 		local_address(skc, &cur);
-		if (addresses_equal(&cur, saddr, false))
+		if (addresses_equal(&cur, saddr, saddr->port))
 			return true;
 	}
 
@@ -247,7 +247,7 @@ lookup_anno_list_by_saddr(struct mptcp_sock *msk,
 	struct mptcp_pm_add_entry *entry;
 
 	list_for_each_entry(entry, &msk->pm.anno_list, list) {
-		if (addresses_equal(&entry->addr, addr, false))
+		if (addresses_equal(&entry->addr, addr, true))
 			return entry;
 	}
 
@@ -773,7 +773,7 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
-		if (addresses_equal(&entry->addr, &skc_local, false)) {
+		if (addresses_equal(&entry->addr, &skc_local, entry->addr.port)) {
 			ret = entry->addr.id;
 			break;
 		}
-- 
2.30.0


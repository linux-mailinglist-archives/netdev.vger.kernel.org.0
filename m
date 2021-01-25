Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC7A30490E
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387462AbhAZF3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:29:43 -0500
Received: from mga05.intel.com ([192.55.52.43]:23609 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731463AbhAYTC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 14:02:57 -0500
IronPort-SDR: u6oamzVoyNKvg+yDVmwKFBnnmtdD21y+0JKp8N8ytJVTaQKFPW0+tXpWkMcdnQdMMO052tE+b1
 vCX09Z3J4JdA==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="264604207"
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="264604207"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 10:59:26 -0800
IronPort-SDR: B08H21B+zFrlqvm69jqBhPFBCdbYjWjq9u6HWQbIgrV/0M6Eahoj53uXI6vmmCacr5jwpPLR2h
 PK/UiaVK9dJw==
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="361637472"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.126.22])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 10:59:26 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH net-next 2/5] mptcp: pm nl: support IPv4 mapped in v6 addresses
Date:   Mon, 25 Jan 2021 10:59:01 -0800
Message-Id: <20210125185904.6997-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125185904.6997-1-mathew.j.martineau@linux.intel.com>
References: <20210125185904.6997-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

On one side, we can allow the creation of subflows between v4 mapped in
v6 and v4 addresses. For that we look for v4mapped addresses between the
local address we want to select and the remote one.

On the other side, we also properly deal with received v4mapped
addresses, either announced ones or set via Netlink.

Fixes: 01cacb00b35c ("mptcp: add netlink-based PM")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/122
Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Co-developed-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 9b1f6298bbdb..f0afff6ba015 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -60,15 +60,20 @@ static bool addresses_equal(const struct mptcp_addr_info *a,
 {
 	bool addr_equals = false;
 
-	if (a->family != b->family)
-		return false;
-
-	if (a->family == AF_INET)
-		addr_equals = a->addr.s_addr == b->addr.s_addr;
+	if (a->family == b->family) {
+		if (a->family == AF_INET)
+			addr_equals = a->addr.s_addr == b->addr.s_addr;
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	else
-		addr_equals = !ipv6_addr_cmp(&a->addr6, &b->addr6);
+		else
+			addr_equals = !ipv6_addr_cmp(&a->addr6, &b->addr6);
+	} else if (a->family == AF_INET) {
+		if (ipv6_addr_v4mapped(&b->addr6))
+			addr_equals = a->addr.s_addr == b->addr6.s6_addr32[3];
+	} else if (b->family == AF_INET) {
+		if (ipv6_addr_v4mapped(&a->addr6))
+			addr_equals = a->addr6.s6_addr32[3] == b->addr.s_addr;
 #endif
+	}
 
 	if (!addr_equals)
 		return false;
@@ -137,6 +142,7 @@ select_local_address(const struct pm_nl_pernet *pernet,
 		     struct mptcp_sock *msk)
 {
 	struct mptcp_pm_addr_entry *entry, *ret = NULL;
+	struct sock *sk = (struct sock *)msk;
 
 	rcu_read_lock();
 	__mptcp_flush_join_list(msk);
@@ -144,11 +150,20 @@ select_local_address(const struct pm_nl_pernet *pernet,
 		if (!(entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW))
 			continue;
 
+		if (entry->addr.family != sk->sk_family) {
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+			if ((entry->addr.family == AF_INET &&
+			     !ipv6_addr_v4mapped(&sk->sk_v6_daddr)) ||
+			    (sk->sk_family == AF_INET &&
+			     !ipv6_addr_v4mapped(&entry->addr.addr6)))
+#endif
+				continue;
+		}
+
 		/* avoid any address already in use by subflows and
 		 * pending join
 		 */
-		if (entry->addr.family == ((struct sock *)msk)->sk_family &&
-		    !lookup_subflow_by_saddr(&msk->conn_list, &entry->addr)) {
+		if (!lookup_subflow_by_saddr(&msk->conn_list, &entry->addr)) {
 			ret = entry;
 			break;
 		}
-- 
2.30.0


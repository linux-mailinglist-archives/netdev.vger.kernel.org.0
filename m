Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AAF2D6B42
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731914AbgLJW6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 17:58:12 -0500
Received: from mga04.intel.com ([192.55.52.120]:9293 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732965AbgLJWce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 17:32:34 -0500
IronPort-SDR: bhqlqKNjr/wFAl0bnH1JnUNZXF8uFGRQIec/TjoXAG0ClDXf362EH7rBQcLmwki7gnu/hogMAJ
 CAC/rLwUoV9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="171776494"
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="171776494"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:15 -0800
IronPort-SDR: lr3569W6LPbsWeYDEb6VZfRBNiEH5F3MCfh00FDjJj0LXhK+2BDAeqW/QlpRUo0bjqVM2NgDLf
 avLCA5CDFqRA==
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="338703760"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.112.51])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 8/9] mptcp: pm: simplify select_local_address()
Date:   Thu, 10 Dec 2020 14:25:05 -0800
Message-Id: <20201210222506.222251-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
References: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

There is no need to unconditionally acquire the join list
lock, we can simply splice the join list into the subflow
list and traverse only the latter.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 9cc4eefaf080..a6d983d80576 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -135,7 +135,7 @@ select_local_address(const struct pm_nl_pernet *pernet,
 	struct mptcp_pm_addr_entry *entry, *ret = NULL;
 
 	rcu_read_lock();
-	spin_lock_bh(&msk->join_list_lock);
+	__mptcp_flush_join_list(msk);
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
 		if (!(entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW))
 			continue;
@@ -144,13 +144,11 @@ select_local_address(const struct pm_nl_pernet *pernet,
 		 * pending join
 		 */
 		if (entry->addr.family == ((struct sock *)msk)->sk_family &&
-		    !lookup_subflow_by_saddr(&msk->conn_list, &entry->addr) &&
-		    !lookup_subflow_by_saddr(&msk->join_list, &entry->addr)) {
+		    !lookup_subflow_by_saddr(&msk->conn_list, &entry->addr)) {
 			ret = entry;
 			break;
 		}
 	}
-	spin_unlock_bh(&msk->join_list_lock);
 	rcu_read_unlock();
 	return ret;
 }
-- 
2.29.2


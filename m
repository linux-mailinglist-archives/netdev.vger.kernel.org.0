Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC1F495769
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 01:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378422AbiAUAfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 19:35:38 -0500
Received: from mga17.intel.com ([192.55.52.151]:65249 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378419AbiAUAfh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 19:35:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642725337; x=1674261337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0BGbOTx/lurssaXCoUHuwmVPIkh6j2wbdvVsR1sRXc0=;
  b=CBRdvi/AfzJN1HgdkrEZw4Ro/VvGBGCTh0oMor6x9LFxwHaX4Fdh1A8p
   437U+E1Wakk+w+6bMpiRb94x5Z1uGT2t3brLg5oVaOZgbT+s9pljmupW1
   JNW3DfY9cY6cGJalFK+s9Ix1t+TtljXM2h0bADSNwIbiNnKQXwTO3TRvf
   0G75LM6M+QHGnITMCFRKCMMZN3n00TOhJKV+SBeU9E9UXK0YGduT16AEE
   ShoUkrkcHCmHvLmLrQQ5EXDjw7w1092zuyu/7UJco73EC3m2xh7nDoJe8
   cQqtZ8FteM0EiStrl8PXFfzocbNi89209E/uW07s/ZALJ3CdT1ovMSwuF
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="226200818"
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="226200818"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 16:35:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="531215215"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.220.167])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 16:35:37 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        geliang.tang@suse.com, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/3] mptcp: fix msk traversal in mptcp_nl_cmd_set_flags()
Date:   Thu, 20 Jan 2022 16:35:27 -0800
Message-Id: <20220121003529.54930-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220121003529.54930-1-mathew.j.martineau@linux.intel.com>
References: <20220121003529.54930-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The MPTCP endpoint list is under RCU protection, guarded by the
pernet spinlock. mptcp_nl_cmd_set_flags() traverses the list
without acquiring the spin-lock nor under the RCU critical section.

This change addresses the issue performing the lookup and the endpoint
update under the pernet spinlock.

Fixes: 0f9f696a502e ("mptcp: add set_flags command in PM netlink")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 75af1f701e1d..f17a09f7fbf9 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -478,6 +478,20 @@ __lookup_addr_by_id(struct pm_nl_pernet *pernet, unsigned int id)
 	return NULL;
 }
 
+static struct mptcp_pm_addr_entry *
+__lookup_addr(struct pm_nl_pernet *pernet, const struct mptcp_addr_info *info,
+	      bool lookup_by_id)
+{
+	struct mptcp_pm_addr_entry *entry;
+
+	list_for_each_entry(entry, &pernet->local_addr_list, list) {
+		if ((!lookup_by_id && addresses_equal(&entry->addr, info, true)) ||
+		    (lookup_by_id && entry->addr.id == info->id))
+			return entry;
+	}
+	return NULL;
+}
+
 static int
 lookup_id_by_addr(struct pm_nl_pernet *pernet, const struct mptcp_addr_info *addr)
 {
@@ -1763,18 +1777,21 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 			return -EOPNOTSUPP;
 	}
 
-	list_for_each_entry(entry, &pernet->local_addr_list, list) {
-		if ((!lookup_by_id && addresses_equal(&entry->addr, &addr.addr, true)) ||
-		    (lookup_by_id && entry->addr.id == addr.addr.id)) {
-			mptcp_nl_addr_backup(net, &entry->addr, bkup);
-
-			if (bkup)
-				entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
-			else
-				entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
-		}
+	spin_lock_bh(&pernet->lock);
+	entry = __lookup_addr(pernet, &addr.addr, lookup_by_id);
+	if (!entry) {
+		spin_unlock_bh(&pernet->lock);
+		return -EINVAL;
 	}
 
+	if (bkup)
+		entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
+	else
+		entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
+	addr = *entry;
+	spin_unlock_bh(&pernet->lock);
+
+	mptcp_nl_addr_backup(net, &addr.addr, bkup);
 	return 0;
 }
 
-- 
2.34.1


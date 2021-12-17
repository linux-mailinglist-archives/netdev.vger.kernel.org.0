Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28758479794
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 00:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhLQXhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 18:37:09 -0500
Received: from mga05.intel.com ([192.55.52.43]:5665 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229914AbhLQXhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 18:37:08 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="326146291"
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="326146291"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 15:37:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="683556056"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.7.225])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 15:37:07 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Jean Sacren <sakiwit@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/3] mptcp: clean up harmless false expressions
Date:   Fri, 17 Dec 2021 15:37:02 -0800
Message-Id: <20211217233702.299461-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217233702.299461-1-mathew.j.martineau@linux.intel.com>
References: <20211217233702.299461-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

entry->addr.id is u8 with a range from 0 to 255 and MAX_ADDR_ID is 255.
We should drop both false expressions of (entry->addr.id > MAX_ADDR_ID).

We should also remove the obsolete parentheses in the first if branch.

Use U8_MAX for MAX_ADDR_ID and add a comment to show the link to
mptcp_addr_info.id as suggested by Mr. Matthieu Baerts.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jean Sacren <sakiwit@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 3186d33b5208..6cde58c259a8 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -38,7 +38,8 @@ struct mptcp_pm_add_entry {
 	u8			retrans_times;
 };
 
-#define MAX_ADDR_ID		255
+/* max value of mptcp_addr_info.id */
+#define MAX_ADDR_ID		U8_MAX
 #define BITMAP_SZ DIV_ROUND_UP(MAX_ADDR_ID + 1, BITS_PER_LONG)
 
 struct pm_nl_pernet {
@@ -825,14 +826,13 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 		entry->addr.id = find_next_zero_bit(pernet->id_bitmap,
 						    MAX_ADDR_ID + 1,
 						    pernet->next_id);
-		if ((!entry->addr.id || entry->addr.id > MAX_ADDR_ID) &&
-		    pernet->next_id != 1) {
+		if (!entry->addr.id && pernet->next_id != 1) {
 			pernet->next_id = 1;
 			goto find_next;
 		}
 	}
 
-	if (!entry->addr.id || entry->addr.id > MAX_ADDR_ID)
+	if (!entry->addr.id)
 		goto out;
 
 	__set_bit(entry->addr.id, pernet->id_bitmap);
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7AC4AE34E
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386947AbiBHWVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387058AbiBHVv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 16:51:29 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB7DC061266
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 13:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644357089; x=1675893089;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=13OfbbTP7UVGdN89DQDBokUhFmy2m43+zdGrlXAi450=;
  b=VoAPPiwwsEI5os4dr0docH/auc57Aq9WAQCBEsnBLmuK486rF/Z06Te6
   30fJMnJilYGKvA9TQzz90nWloHNKac2XeNwD+kS7qMw1gLKtipEmcoUIL
   xAUlO8NgsdjoBhw4q7qmx7/thlQ3AeU3y3PDoGgg6W2ZzONikZAzE7hOH
   K90sXlcleuUjKpCl140mZvqNQhR/3PTs4Gax96NOymF3Or/qFLmZXulKX
   n/Ad0CdTTFNWRRxxsDLh737BQd4PtDQt2WgL1y7FA4V3bKjal3KsBiYyx
   OGGTeNtCHExTEgeu25w1MMJLkOn5VfkEjd/+/fhIMH4jA//BCCRGQxkp1
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="249008208"
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="249008208"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 13:51:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="622047965"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Feb 2022 13:51:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 5/5] i40e: Add a stat for tracking busy rx pages
Date:   Tue,  8 Feb 2022 13:51:17 -0800
Message-Id: <20220208215117.1733822-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220208215117.1733822-1-anthony.l.nguyen@intel.com>
References: <20220208215117.1733822-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Damato <jdamato@fastly.com>

In some cases, pages cannot be reused by i40e because the page is busy. Add
a counter for this event.

Busy page count is accessible via ethtool.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h         |  1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c    |  5 ++++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    | 12 ++++++++----
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    |  1 +
 5 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index d2e71db65fb4..55c6bce5da61 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -857,6 +857,7 @@ struct i40e_vsi {
 	u64 rx_page_reuse;
 	u64 rx_page_alloc;
 	u64 rx_page_waive;
+	u64 rx_page_busy;
 
 	/* These are containers of ring pointers, allocated at run-time */
 	struct i40e_ring **rx_rings;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 7e76cd0e7d55..e48499624d22 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -298,6 +298,7 @@ static const struct i40e_stats i40e_gstrings_misc_stats[] = {
 	I40E_VSI_STAT("rx_cache_reuse", rx_page_reuse),
 	I40E_VSI_STAT("rx_cache_alloc", rx_page_alloc),
 	I40E_VSI_STAT("rx_cache_waive", rx_page_waive),
+	I40E_VSI_STAT("rx_cache_busy", rx_page_busy),
 };
 
 /* These PF_STATs might look like duplicates of some NETDEV_STATs,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 385b241abf06..9b7ce6d9a92b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -773,7 +773,7 @@ void i40e_update_veb_stats(struct i40e_veb *veb)
  **/
 static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 {
-	u64 rx_page, rx_buf, rx_reuse, rx_alloc, rx_waive;
+	u64 rx_page, rx_buf, rx_reuse, rx_alloc, rx_waive, rx_busy;
 	struct i40e_pf *pf = vsi->back;
 	struct rtnl_link_stats64 *ons;
 	struct rtnl_link_stats64 *ns;   /* netdev stats */
@@ -809,6 +809,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	rx_reuse = 0;
 	rx_alloc = 0;
 	rx_waive = 0;
+	rx_busy = 0;
 	rcu_read_lock();
 	for (q = 0; q < vsi->num_queue_pairs; q++) {
 		/* locate Tx ring */
@@ -845,6 +846,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 		rx_reuse += p->rx_stats.page_reuse_count;
 		rx_alloc += p->rx_stats.page_alloc_count;
 		rx_waive += p->rx_stats.page_waive_count;
+		rx_busy += p->rx_stats.page_busy_count;
 
 		if (i40e_enabled_xdp_vsi(vsi)) {
 			/* locate XDP ring */
@@ -875,6 +877,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	vsi->rx_page_reuse = rx_reuse;
 	vsi->rx_page_alloc = rx_alloc;
 	vsi->rx_page_waive = rx_waive;
+	vsi->rx_page_busy = rx_busy;
 
 	ns->rx_packets = rx_p;
 	ns->rx_bytes = rx_b;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 3d91b1655aec..a628f4b43fe8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1990,8 +1990,8 @@ static bool i40e_cleanup_headers(struct i40e_ring *rx_ring, struct sk_buff *skb,
  * pointing to; otherwise, the DMA mapping needs to be destroyed and
  * page freed.
  *
- * rx_stats will be updated to indicate if the page was waived because it was
- * not reusable.
+ * rx_stats will be updated to indicate whether the page was waived
+ * or busy if it could not be reused.
  */
 static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
 				   struct i40e_rx_queue_stats *rx_stats,
@@ -2008,13 +2008,17 @@ static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((rx_buffer_pgcnt - pagecnt_bias) > 1))
+	if (unlikely((rx_buffer_pgcnt - pagecnt_bias) > 1)) {
+		rx_stats->page_busy_count++;
 		return false;
+	}
 #else
 #define I40E_LAST_OFFSET \
 	(SKB_WITH_OVERHEAD(PAGE_SIZE) - I40E_RXBUFFER_2048)
-	if (rx_buffer->page_offset > I40E_LAST_OFFSET)
+	if (rx_buffer->page_offset > I40E_LAST_OFFSET) {
+		rx_stats->page_busy_count++;
 		return false;
+	}
 #endif
 
 	/* If we have drained the page fragment pool we need to update
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index b1955d3f4718..324699ec930b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -300,6 +300,7 @@ struct i40e_rx_queue_stats {
 	u64 page_reuse_count;
 	u64 page_alloc_count;
 	u64 page_waive_count;
+	u64 page_busy_count;
 };
 
 enum i40e_ring_state_t {
-- 
2.31.1


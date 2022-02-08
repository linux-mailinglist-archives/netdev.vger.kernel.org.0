Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5E84AE369
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387296AbiBHWVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387055AbiBHVv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 16:51:29 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F51C0612BF
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 13:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644357088; x=1675893088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PdFMMGHhGKuCmKLWTJ26gqEqBAviBjkLcLYxtgKGZV8=;
  b=OaA4+3ixzCCbjtY7Oi6sr6zBy8jWyM7N7xmDsnFGCVZEZdSsw1D3RqE6
   GWqKFK7or5uSVHIYTlF3Obf4YnTOGODW2IEdpCijHT61YY55Q9LvBKtS0
   bPoRwJtY1gcsO8TLR/yGKD3tNvDAJwtuMixVnpZCMFQYxUlk9jehf8oaK
   u2KvMwjCFyoFj7c+vJUn1qtcCwSFT1JCO1R1yuZjzAIG7Fk0NfOBjYCcv
   +EwR0BnxpliOaIVK7e/aQDbymV1FNu1Y9k6kIuHrzpbKJE+fsFV3Pykdy
   oRz+I3qcPaAMrYl6CGHZSnF0KfYt8DD6W5CbA9DapQIURoNHkH+g+cikd
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="249008207"
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="249008207"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 13:51:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="622047959"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Feb 2022 13:51:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 4/5] i40e: Add a stat for tracking pages waived
Date:   Tue,  8 Feb 2022 13:51:16 -0800
Message-Id: <20220208215117.1733822-5-anthony.l.nguyen@intel.com>
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

In some cases, pages can not be reused because they are not associated with
the correct NUMA zone. Knowing how often pages are waived helps users to
understand the interaction between the driver's memory usage and their
system.

Pass rx_stats through to i40e_can_reuse_rx_page to allow tracking when
pages are waived.

The page waive count is accessible via ethtool.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h         |  1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c    |  5 ++++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    | 13 ++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    |  1 +
 5 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index ea8021d9739c..d2e71db65fb4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -856,6 +856,7 @@ struct i40e_vsi {
 	u64 rx_page_failed;
 	u64 rx_page_reuse;
 	u64 rx_page_alloc;
+	u64 rx_page_waive;
 
 	/* These are containers of ring pointers, allocated at run-time */
 	struct i40e_ring **rx_rings;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 17a16b4e4405..7e76cd0e7d55 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -297,6 +297,7 @@ static const struct i40e_stats i40e_gstrings_misc_stats[] = {
 	I40E_VSI_STAT("rx_pg_alloc_fail", rx_page_failed),
 	I40E_VSI_STAT("rx_cache_reuse", rx_page_reuse),
 	I40E_VSI_STAT("rx_cache_alloc", rx_page_alloc),
+	I40E_VSI_STAT("rx_cache_waive", rx_page_waive),
 };
 
 /* These PF_STATs might look like duplicates of some NETDEV_STATs,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 9d62f5875c30..385b241abf06 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -773,7 +773,7 @@ void i40e_update_veb_stats(struct i40e_veb *veb)
  **/
 static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 {
-	u64 rx_page, rx_buf, rx_reuse, rx_alloc;
+	u64 rx_page, rx_buf, rx_reuse, rx_alloc, rx_waive;
 	struct i40e_pf *pf = vsi->back;
 	struct rtnl_link_stats64 *ons;
 	struct rtnl_link_stats64 *ns;   /* netdev stats */
@@ -808,6 +808,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	rx_buf = 0;
 	rx_reuse = 0;
 	rx_alloc = 0;
+	rx_waive = 0;
 	rcu_read_lock();
 	for (q = 0; q < vsi->num_queue_pairs; q++) {
 		/* locate Tx ring */
@@ -843,6 +844,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 		rx_page += p->rx_stats.alloc_page_failed;
 		rx_reuse += p->rx_stats.page_reuse_count;
 		rx_alloc += p->rx_stats.page_alloc_count;
+		rx_waive += p->rx_stats.page_waive_count;
 
 		if (i40e_enabled_xdp_vsi(vsi)) {
 			/* locate XDP ring */
@@ -872,6 +874,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	vsi->rx_buf_failed = rx_buf;
 	vsi->rx_page_reuse = rx_reuse;
 	vsi->rx_page_alloc = rx_alloc;
+	vsi->rx_page_waive = rx_waive;
 
 	ns->rx_packets = rx_p;
 	ns->rx_bytes = rx_b;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 54fd497f6535..3d91b1655aec 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1982,22 +1982,29 @@ static bool i40e_cleanup_headers(struct i40e_ring *rx_ring, struct sk_buff *skb,
 /**
  * i40e_can_reuse_rx_page - Determine if page can be reused for another Rx
  * @rx_buffer: buffer containing the page
+ * @rx_stats: rx stats structure for the rx ring
  * @rx_buffer_pgcnt: buffer page refcount pre xdp_do_redirect() call
  *
  * If page is reusable, we have a green light for calling i40e_reuse_rx_page,
  * which will assign the current buffer to the buffer that next_to_alloc is
  * pointing to; otherwise, the DMA mapping needs to be destroyed and
- * page freed
+ * page freed.
+ *
+ * rx_stats will be updated to indicate if the page was waived because it was
+ * not reusable.
  */
 static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
+				   struct i40e_rx_queue_stats *rx_stats,
 				   int rx_buffer_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
 	struct page *page = rx_buffer->page;
 
 	/* Is any reuse possible? */
-	if (!dev_page_is_reusable(page))
+	if (!dev_page_is_reusable(page)) {
+		rx_stats->page_waive_count++;
 		return false;
+	}
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
@@ -2237,7 +2244,7 @@ static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
 			       struct i40e_rx_buffer *rx_buffer,
 			       int rx_buffer_pgcnt)
 {
-	if (i40e_can_reuse_rx_page(rx_buffer, rx_buffer_pgcnt)) {
+	if (i40e_can_reuse_rx_page(rx_buffer, &rx_ring->rx_stats, rx_buffer_pgcnt)) {
 		/* hand second half of page back to the ring */
 		i40e_reuse_rx_page(rx_ring, rx_buffer);
 	} else {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 13188dcf4e8e..b1955d3f4718 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -299,6 +299,7 @@ struct i40e_rx_queue_stats {
 	u64 alloc_buff_failed;
 	u64 page_reuse_count;
 	u64 page_alloc_count;
+	u64 page_waive_count;
 };
 
 enum i40e_ring_state_t {
-- 
2.31.1


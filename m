Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9ED04AE34D
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386495AbiBHWVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387054AbiBHVv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 16:51:29 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6027DC0612B8
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 13:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644357088; x=1675893088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q5973E/EBbPXt0j7FkGR8yK4zoAR40j3PowaoRmMGwE=;
  b=GaBeMbBdg/TRGcDXELu/cYvplFpzjwrZplzO/ZmYBOa60JQ1GbOHUabv
   Hb3r0SPjk23709gwrVKhEp5lU1xfoXvsWOV0NHdno42kC8c87lQagRULz
   I8pJz69fOfUAlaPCRbsUKXvxTTrcMoPDC57SDBsBbyQkDp+4ALZmVKPuN
   1Lc7Ahq0+Z8rtCx5aGuH7M0hOJ56TG5rS25FMSLrEJvAN3mjOh7AKd77h
   rn4ydOSXK1YD3CwW3CuMEj+i8Ae/SQYNaSCS+IRUWjONOgbmnis4fcbPB
   L7yIfLVpa4Rwlhn5o1w8tZY9qUnOCYm2nLBzGLaKUoxvsj/WHO3QmlwnL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="249008206"
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="249008206"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 13:51:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="622047955"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Feb 2022 13:51:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 3/5] i40e: Add a stat tracking new RX page allocations
Date:   Tue,  8 Feb 2022 13:51:15 -0800
Message-Id: <20220208215117.1733822-4-anthony.l.nguyen@intel.com>
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

Add a counter for new page allocations in the i40e RX path. This stat is
accessible with ethtool.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h         | 1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c    | 5 ++++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    | 2 ++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    | 1 +
 5 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index ee8516543ea6..ea8021d9739c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -855,6 +855,7 @@ struct i40e_vsi {
 	u64 rx_buf_failed;
 	u64 rx_page_failed;
 	u64 rx_page_reuse;
+	u64 rx_page_alloc;
 
 	/* These are containers of ring pointers, allocated at run-time */
 	struct i40e_ring **rx_rings;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 9317b2d31c9e..17a16b4e4405 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -296,6 +296,7 @@ static const struct i40e_stats i40e_gstrings_misc_stats[] = {
 	I40E_VSI_STAT("rx_alloc_fail", rx_buf_failed),
 	I40E_VSI_STAT("rx_pg_alloc_fail", rx_page_failed),
 	I40E_VSI_STAT("rx_cache_reuse", rx_page_reuse),
+	I40E_VSI_STAT("rx_cache_alloc", rx_page_alloc),
 };
 
 /* These PF_STATs might look like duplicates of some NETDEV_STATs,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index c22e7b1a960b..9d62f5875c30 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -773,8 +773,8 @@ void i40e_update_veb_stats(struct i40e_veb *veb)
  **/
 static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 {
+	u64 rx_page, rx_buf, rx_reuse, rx_alloc;
 	struct i40e_pf *pf = vsi->back;
-	u64 rx_page, rx_buf, rx_reuse;
 	struct rtnl_link_stats64 *ons;
 	struct rtnl_link_stats64 *ns;   /* netdev stats */
 	struct i40e_eth_stats *oes;
@@ -807,6 +807,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	rx_page = 0;
 	rx_buf = 0;
 	rx_reuse = 0;
+	rx_alloc = 0;
 	rcu_read_lock();
 	for (q = 0; q < vsi->num_queue_pairs; q++) {
 		/* locate Tx ring */
@@ -841,6 +842,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 		rx_buf += p->rx_stats.alloc_buff_failed;
 		rx_page += p->rx_stats.alloc_page_failed;
 		rx_reuse += p->rx_stats.page_reuse_count;
+		rx_alloc += p->rx_stats.page_alloc_count;
 
 		if (i40e_enabled_xdp_vsi(vsi)) {
 			/* locate XDP ring */
@@ -869,6 +871,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	vsi->rx_page_failed = rx_page;
 	vsi->rx_buf_failed = rx_buf;
 	vsi->rx_page_reuse = rx_reuse;
+	vsi->rx_page_alloc = rx_alloc;
 
 	ns->rx_packets = rx_p;
 	ns->rx_bytes = rx_b;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index da4929ece778..54fd497f6535 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1673,6 +1673,8 @@ static bool i40e_alloc_mapped_page(struct i40e_ring *rx_ring,
 		return false;
 	}
 
+	rx_ring->rx_stats.page_alloc_count++;
+
 	/* map page for use */
 	dma = dma_map_page_attrs(rx_ring->dev, page, 0,
 				 i40e_rx_pg_size(rx_ring),
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 88387a644cc3..13188dcf4e8e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -298,6 +298,7 @@ struct i40e_rx_queue_stats {
 	u64 alloc_page_failed;
 	u64 alloc_buff_failed;
 	u64 page_reuse_count;
+	u64 page_alloc_count;
 };
 
 enum i40e_ring_state_t {
-- 
2.31.1


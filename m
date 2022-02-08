Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4964AE338
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386519AbiBHWVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387053AbiBHVv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 16:51:28 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89EBC0612BE
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 13:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644357087; x=1675893087;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DotYDirzrQ9wjr13QzUdAeukwANbdCiC81Mwb1rHE5I=;
  b=VecN+doR6iJ+YLgni4xPWbOPjuz3OoJnk8vUhHRf+R3YZBXI0fw3a2fS
   XOyzDUe3fuNqZ4wwvQUIU98HYUFp/yI+5Ea0Kgorf1bshnGhYmCLUvnaF
   X/qF695+4/hcKA1V7uNEWwZAB60/H4H7h0qHAsdoKTQHBBHt/+6lCM/bo
   lpqKvsFIZoxhCt+oiHPBHFUx34n680Kdk5izrPfHbOs8u1qwJq8QiUqvG
   41bRv6aCVE/KnUWIHgjI0su7Bbqks2UVmkdaIVHTEU3KbJxHrSD1zPlen
   Jk4Hdeg20BUJAYNuszhxJIHA6kGqZYAhMBtPx3IsBGiJttVSaAiM4h9VA
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="249008205"
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="249008205"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 13:51:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="622047952"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Feb 2022 13:51:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 2/5] i40e: Aggregate and export RX page reuse stat
Date:   Tue,  8 Feb 2022 13:51:14 -0800
Message-Id: <20220208215117.1733822-3-anthony.l.nguyen@intel.com>
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

rx page reuse was already being tracked by the i40e driver per RX ring.
Aggregate the counts and make them accessible via ethtool.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h         | 1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c    | 5 ++++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 80c5cecaf2b5..ee8516543ea6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -854,6 +854,7 @@ struct i40e_vsi {
 	u64 tx_force_wb;
 	u64 rx_buf_failed;
 	u64 rx_page_failed;
+	u64 rx_page_reuse;
 
 	/* These are containers of ring pointers, allocated at run-time */
 	struct i40e_ring **rx_rings;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 091f36adbbe1..9317b2d31c9e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -295,6 +295,7 @@ static const struct i40e_stats i40e_gstrings_misc_stats[] = {
 	I40E_VSI_STAT("tx_busy", tx_busy),
 	I40E_VSI_STAT("rx_alloc_fail", rx_buf_failed),
 	I40E_VSI_STAT("rx_pg_alloc_fail", rx_page_failed),
+	I40E_VSI_STAT("rx_cache_reuse", rx_page_reuse),
 };
 
 /* These PF_STATs might look like duplicates of some NETDEV_STATs,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index a95609d847ca..c22e7b1a960b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -774,13 +774,13 @@ void i40e_update_veb_stats(struct i40e_veb *veb)
 static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 {
 	struct i40e_pf *pf = vsi->back;
+	u64 rx_page, rx_buf, rx_reuse;
 	struct rtnl_link_stats64 *ons;
 	struct rtnl_link_stats64 *ns;   /* netdev stats */
 	struct i40e_eth_stats *oes;
 	struct i40e_eth_stats *es;     /* device's eth stats */
 	u64 tx_restart, tx_busy;
 	struct i40e_ring *p;
-	u64 rx_page, rx_buf;
 	u64 bytes, packets;
 	unsigned int start;
 	u64 tx_linearize;
@@ -806,6 +806,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	tx_restart = tx_busy = tx_linearize = tx_force_wb = 0;
 	rx_page = 0;
 	rx_buf = 0;
+	rx_reuse = 0;
 	rcu_read_lock();
 	for (q = 0; q < vsi->num_queue_pairs; q++) {
 		/* locate Tx ring */
@@ -839,6 +840,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 		rx_p += packets;
 		rx_buf += p->rx_stats.alloc_buff_failed;
 		rx_page += p->rx_stats.alloc_page_failed;
+		rx_reuse += p->rx_stats.page_reuse_count;
 
 		if (i40e_enabled_xdp_vsi(vsi)) {
 			/* locate XDP ring */
@@ -866,6 +868,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	vsi->tx_force_wb = tx_force_wb;
 	vsi->rx_page_failed = rx_page;
 	vsi->rx_buf_failed = rx_buf;
+	vsi->rx_page_reuse = rx_reuse;
 
 	ns->rx_packets = rx_p;
 	ns->rx_bytes = rx_b;
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC754CE5E
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349273AbiFOQP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352897AbiFOQNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:13:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C38138181;
        Wed, 15 Jun 2022 09:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655309593; x=1686845593;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qc0EJDXHu0ex2slVkMhHu14r3oQJuW0ES/zvc9A2dwE=;
  b=MTcE2cyExPHip/zSwp4KIyHSa7ogfJ138rf0RsFYQrvcdWPLr2zlVY3c
   h0lQMaGNSacxC5e/InhiIDGirySPib8vhhnVTBa+jsO9nPUTxk0AjYmp5
   nkwh8Z5SxRTr/AzSaZWS1BMlgKDt/d9YHBZ4cdSPANdEpl1jthsRoAbBU
   rta3lRNfZZLSsEedZFfAp+chhBaSkxVRvIwfvTSIlpk9lsf15v72X6+8m
   CfylZmGkCO2NPcowoaXKqvfNF3xYXayHkjGZFZGjqqQOp53hu9ywUK2Jf
   GhE5bd88+LqsferIHrTDAk6CXCF90cAmjNFJ4T8iuI8hbbY0Qlw2/w9bi
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="280050126"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="280050126"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 09:11:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="713005280"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 15 Jun 2022 09:11:03 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexandr Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH v3 bpf-next 02/11] ice: allow toggling loopback mode via ndo_set_features callback
Date:   Wed, 15 Jun 2022 18:10:32 +0200
Message-Id: <20220615161041.902916-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220615161041.902916-1-maciej.fijalkowski@intel.com>
References: <20220615161041.902916-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for NETIF_F_LOOPBACK. This feature can be set via:
$ ethtool -K eth0 loopback <on|off>

Feature can be useful for local data path tests.

CC: Alexandr Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 24 +++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 23d1b1fc39fb..85d956517b2e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3358,6 +3358,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	netdev->features |= netdev->hw_features;
 
 	netdev->hw_features |= NETIF_F_HW_TC;
+	netdev->hw_features |= NETIF_F_LOOPBACK;
 
 	/* encap and VLAN devices inherit default, csumo and tso features */
 	netdev->hw_enc_features |= dflt_features | csumo_features |
@@ -5902,6 +5903,25 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 	return 0;
 }
 
+/**
+ * ice_set_loopback - turn on/off loopback mode on underlying PF
+ * @hw: ptr to ice_hw struct needed for AQ command
+ * @netdev: ptr to the netdev being adjusted
+ * @ena: flag to indicate the on/off setting
+ */
+static void
+ice_set_loopback(struct ice_hw *hw, struct net_device *netdev, bool ena)
+{
+	bool if_running = netif_running(netdev);
+
+	if (if_running)
+		ice_stop(netdev);
+	if (ice_aq_set_mac_loopback(hw, ena, NULL))
+		netdev_err(netdev, "Failed to toggle loopback state\n");
+	if (if_running)
+		ice_open(netdev);
+}
+
 /**
  * ice_set_features - set the netdev feature flags
  * @netdev: ptr to the netdev being adjusted
@@ -5960,6 +5980,10 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 		      clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
 	}
 
+	if (changed & NETIF_F_LOOPBACK)
+		ice_set_loopback(&pf->hw, netdev,
+				 !!(features & NETIF_F_LOOPBACK));
+
 	return 0;
 }
 
-- 
2.27.0


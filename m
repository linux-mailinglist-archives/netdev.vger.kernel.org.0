Return-Path: <netdev+bounces-9323-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AA397286E4
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA0E6281782
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD1D20695;
	Thu,  8 Jun 2023 18:05:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDC62068C
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 18:05:10 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1BC19AC
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686247508; x=1717783508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fCymMh11BDM0sIUq78o1Kso+F0PGaNZuR5UarBdn8Jc=;
  b=UnK4dXA04n6Ev8P5L9kMq4AamPrSAdY0f3+KWHZd+0sS271wyVIJGVg/
   TIqByqq4AzI0aDAR6Jpg1/a8kXNa1BQb8uzci+6vtuj7K1uWvyIKvV1nF
   vQjCh9m8Ws2pPBBS1AK1kHWQ7sWBrAT+SUIeypL+92/qKW4p7aFIrcT2z
   XHiQO4SvAzBPQsRBiQx7Ak8V/rBfZ5VtjYSWKAz7LfeVjadfeg9/eMQ5H
   lw96mA7oMkHd+2yfhQLCbUaegF64Zrd1D35R53DalmigfiJHfcw6uUWZb
   I/+uAqFLPXvVyZYNepwUP5AP0qpzcWyfzrnevqUiIY7WXPFKwVL5lUrBi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="385738759"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="385738759"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 11:04:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="775187938"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="775187938"
Received: from dmert-dev.jf.intel.com ([10.166.241.14])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 11:04:38 -0700
From: Dave Ertman <david.m.ertman@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	daniel.machon@microchip.com
Subject: [PATCH iwl-next v3 09/10] ice: enforce no DCB config changing when in bond
Date: Thu,  8 Jun 2023 11:06:17 -0700
Message-Id: <20230608180618.574171-10-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608180618.574171-1-david.m.ertman@intel.com>
References: <20230608180618.574171-1-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

To support SRIOV LAG, the driver cannot allow changes to an interface's DCB
configuration when in a bond.  This would break the ability to modify
interfaces Tx scheduling for fail-over interfaces.

Block kernel generated DCB config events when in a bond.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c | 50 +++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index 3eb01731e496..e1fbc6de452d 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -70,6 +70,11 @@ static int ice_dcbnl_setets(struct net_device *netdev, struct ieee_ets *ets)
 	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_IEEE))
 		return -EINVAL;
 
+	if (pf->lag && pf->lag->bonded) {
+		netdev_err(netdev, "DCB changes not allowed when in a bond\n");
+		return -EINVAL;
+	}
+
 	new_cfg = &pf->hw.port_info->qos_cfg.desired_dcbx_cfg;
 
 	mutex_lock(&pf->tc_mutex);
@@ -170,6 +175,11 @@ static u8 ice_dcbnl_setdcbx(struct net_device *netdev, u8 mode)
 	if (mode == pf->dcbx_cap)
 		return ICE_DCB_NO_HW_CHG;
 
+	if (pf->lag && pf->lag->bonded) {
+		netdev_err(netdev, "DCB changes not allowed when in a bond\n");
+		return ICE_DCB_NO_HW_CHG;
+	}
+
 	qos_cfg = &pf->hw.port_info->qos_cfg;
 
 	/* DSCP configuration is not DCBx negotiated */
@@ -261,6 +271,11 @@ static int ice_dcbnl_setpfc(struct net_device *netdev, struct ieee_pfc *pfc)
 	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_IEEE))
 		return -EINVAL;
 
+	if (pf->lag && pf->lag->bonded) {
+		netdev_err(netdev, "DCB changes not allowed when in a bond\n");
+		return -EINVAL;
+	}
+
 	mutex_lock(&pf->tc_mutex);
 
 	new_cfg = &pf->hw.port_info->qos_cfg.desired_dcbx_cfg;
@@ -323,6 +338,11 @@ static void ice_dcbnl_set_pfc_cfg(struct net_device *netdev, int prio, u8 set)
 	if (prio >= ICE_MAX_USER_PRIORITY)
 		return;
 
+	if (pf->lag && pf->lag->bonded) {
+		netdev_err(netdev, "DCB changes not allowed when in a bond\n");
+		return;
+	}
+
 	new_cfg = &pf->hw.port_info->qos_cfg.desired_dcbx_cfg;
 
 	new_cfg->pfc.pfccap = pf->hw.func_caps.common_cap.maxtc;
@@ -379,6 +399,11 @@ static u8 ice_dcbnl_setstate(struct net_device *netdev, u8 state)
 	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_CEE))
 		return ICE_DCB_NO_HW_CHG;
 
+	if (pf->lag && pf->lag->bonded) {
+		netdev_err(netdev, "DCB changes not allowed when in a bond\n");
+		return ICE_DCB_NO_HW_CHG;
+	}
+
 	/* Nothing to do */
 	if (!!state == test_bit(ICE_FLAG_DCB_ENA, pf->flags))
 		return ICE_DCB_NO_HW_CHG;
@@ -451,6 +476,11 @@ ice_dcbnl_set_pg_tc_cfg_tx(struct net_device *netdev, int tc,
 	if (tc >= ICE_MAX_TRAFFIC_CLASS)
 		return;
 
+	if (pf->lag && pf->lag->bonded) {
+		netdev_err(netdev, "DCB changes not allowed when in a bond\n");
+		return;
+	}
+
 	new_cfg = &pf->hw.port_info->qos_cfg.desired_dcbx_cfg;
 
 	/* prio_type, bwg_id and bw_pct per UP are not supported */
@@ -505,6 +535,11 @@ ice_dcbnl_set_pg_bwg_cfg_tx(struct net_device *netdev, int pgid, u8 bw_pct)
 	if (pgid >= ICE_MAX_TRAFFIC_CLASS)
 		return;
 
+	if (pf->lag && pf->lag->bonded) {
+		netdev_err(netdev, "DCB changes not allowed when in a bond\n");
+		return;
+	}
+
 	new_cfg = &pf->hw.port_info->qos_cfg.desired_dcbx_cfg;
 
 	new_cfg->etscfg.tcbwtable[pgid] = bw_pct;
@@ -725,6 +760,11 @@ static int ice_dcbnl_setapp(struct net_device *netdev, struct dcb_app *app)
 		return -EINVAL;
 	}
 
+	if (pf->lag && pf->lag->bonded) {
+		netdev_err(netdev, "DCB changes not allowed when in a bond\n");
+		return -EINVAL;
+	}
+
 	max_tc = pf->hw.func_caps.common_cap.maxtc;
 	if (app->priority >= max_tc) {
 		netdev_err(netdev, "TC %d out of range, max TC %d\n",
@@ -836,6 +876,11 @@ static int ice_dcbnl_delapp(struct net_device *netdev, struct dcb_app *app)
 		return -EINVAL;
 	}
 
+	if (pf->lag && pf->lag->bonded) {
+		netdev_err(netdev, "DCB changes not allowed when in a bond\n");
+		return -EINVAL;
+	}
+
 	mutex_lock(&pf->tc_mutex);
 	old_cfg = &pf->hw.port_info->qos_cfg.local_dcbx_cfg;
 
@@ -937,6 +982,11 @@ static u8 ice_dcbnl_cee_set_all(struct net_device *netdev)
 	    !(pf->dcbx_cap & DCB_CAP_DCBX_VER_CEE))
 		return ICE_DCB_NO_HW_CHG;
 
+	if (pf->lag && pf->lag->bonded) {
+		netdev_err(netdev, "DCB changes not allowed when in a bond\n");
+		return ICE_DCB_NO_HW_CHG;
+	}
+
 	new_cfg = &pf->hw.port_info->qos_cfg.desired_dcbx_cfg;
 
 	mutex_lock(&pf->tc_mutex);
-- 
2.40.1



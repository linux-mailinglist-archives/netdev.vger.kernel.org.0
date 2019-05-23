Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1B2427ECD
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 15:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbfEWNwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 09:52:23 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:50785 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730323AbfEWNwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 09:52:23 -0400
Received: from v4.blr.asicdesigners.com (v4.blr.asicdesigners.com [10.193.186.237])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x4NDq7Nd006401;
        Thu, 23 May 2019 06:52:08 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com, rajur@chelsio.com
Subject: [PATCH net-next] cxgb4: use firmware API for validating filter spec
Date:   Thu, 23 May 2019 19:21:21 +0530
Message-Id: <20190523135121.16045-1-rajur@chelsio.com>
X-Mailer: git-send-email 2.9.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds support for validating hardware filter spec configured in firmware
before offloading exact match flows.

Use the new fw api FW_PARAM_DEV_FILTER_MODE_MASK to read the filter mode
and mask from firmware. If the api isn't supported, then fall-back to
older way of reading just the mode from indirect register.

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h        |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c |  3 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c        | 47 ++++++++++++++++++++---
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h     | 23 +++++++++++
 4 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index a707a65f491b..7c06e2aebc9e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -280,6 +280,7 @@ struct tp_params {
 	unsigned short tx_modq[NCHAN];	/* channel to modulation queue map */
 
 	u32 vlan_pri_map;               /* cached TP_VLAN_PRI_MAP */
+	u32 filter_mask;
 	u32 ingress_config;             /* cached TP_INGRESS_CONFIG */
 
 	/* cached TP_OUT_CONFIG compressed error vector
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 0f0b3f4a039d..6232236d7abc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -248,8 +248,9 @@ static int validate_filter(struct net_device *dev,
 	u32 fconf, iconf;
 
 	/* Check for unconfigured fields being used. */
-	fconf = adapter->params.tp.vlan_pri_map;
 	iconf = adapter->params.tp.ingress_config;
+	fconf = fs->hash ? adapter->params.tp.filter_mask :
+			   adapter->params.tp.vlan_pri_map;
 
 	if (unsupported(fconf, FCOE_F, fs->val.fcoe, fs->mask.fcoe) ||
 	    unsupported(fconf, PORT_F, fs->val.iport, fs->mask.iport) ||
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 866ee31a1da5..8c17d1c75e84 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -9388,8 +9388,9 @@ int t4_init_sge_params(struct adapter *adapter)
  */
 int t4_init_tp_params(struct adapter *adap, bool sleep_ok)
 {
-	int chan;
-	u32 v;
+	u32 param, val, v;
+	int chan, ret;
+
 
 	v = t4_read_reg(adap, TP_TIMER_RESOLUTION_A);
 	adap->params.tp.tre = TIMERRESOLUTION_G(v);
@@ -9399,11 +9400,47 @@ int t4_init_tp_params(struct adapter *adap, bool sleep_ok)
 	for (chan = 0; chan < NCHAN; chan++)
 		adap->params.tp.tx_modq[chan] = chan;
 
-	/* Cache the adapter's Compressed Filter Mode and global Incress
+	/* Cache the adapter's Compressed Filter Mode/Mask and global Ingress
 	 * Configuration.
 	 */
-	t4_tp_pio_read(adap, &adap->params.tp.vlan_pri_map, 1,
-		       TP_VLAN_PRI_MAP_A, sleep_ok);
+	param = (FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_DEV) |
+		 FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_FILTER) |
+		 FW_PARAMS_PARAM_Y_V(FW_PARAM_DEV_FILTER_MODE_MASK));
+
+	/* Read current value */
+	ret = t4_query_params(adap, adap->mbox, adap->pf, 0, 1,
+			      &param, &val);
+	if (ret == 0) {
+		dev_info(adap->pdev_dev,
+			 "Current filter mode/mask 0x%x:0x%x\n",
+			 FW_PARAMS_PARAM_FILTER_MODE_G(val),
+			 FW_PARAMS_PARAM_FILTER_MASK_G(val));
+		adap->params.tp.vlan_pri_map =
+			FW_PARAMS_PARAM_FILTER_MODE_G(val);
+		adap->params.tp.filter_mask =
+			FW_PARAMS_PARAM_FILTER_MASK_G(val);
+	} else {
+		dev_info(adap->pdev_dev,
+			 "Failed to read filter mode/mask via fw api, using indirect-reg-read\n");
+
+		/* Incase of older-fw (which doesn't expose the api
+		 * FW_PARAM_DEV_FILTER_MODE_MASK) and newer-driver (which uses
+		 * the fw api) combination, fall-back to older method of reading
+		 * the filter mode from indirect-register
+		 */
+		t4_tp_pio_read(adap, &adap->params.tp.vlan_pri_map, 1,
+			       TP_VLAN_PRI_MAP_A, sleep_ok);
+
+		/* With the older-fw and newer-driver combination we might run
+		 * into an issue when user wants to use hash filter region but
+		 * the filter_mask is zero, in this case filter_mask validation
+		 * is tough. To avoid that we set the filter_mask same as filter
+		 * mode, which will behave exactly as the older way of ignoring
+		 * the filter mask validation.
+		 */
+		adap->params.tp.filter_mask = adap->params.tp.vlan_pri_map;
+	}
+
 	t4_tp_pio_read(adap, &adap->params.tp.ingress_config, 1,
 		       TP_INGRESS_CONFIG_A, sleep_ok);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index 6a10e953fc40..0be4ce520352 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -1221,6 +1221,23 @@ enum fw_params_mnem {
 /*
  * device parameters
  */
+
+#define FW_PARAMS_PARAM_FILTER_MODE_S 16
+#define FW_PARAMS_PARAM_FILTER_MODE_M 0xffff
+#define FW_PARAMS_PARAM_FILTER_MODE_V(x)          \
+	((x) << FW_PARAMS_PARAM_FILTER_MODE_S)
+#define FW_PARAMS_PARAM_FILTER_MODE_G(x)          \
+	(((x) >> FW_PARAMS_PARAM_FILTER_MODE_S) & \
+	FW_PARAMS_PARAM_FILTER_MODE_M)
+
+#define FW_PARAMS_PARAM_FILTER_MASK_S 0
+#define FW_PARAMS_PARAM_FILTER_MASK_M 0xffff
+#define FW_PARAMS_PARAM_FILTER_MASK_V(x)          \
+	((x) << FW_PARAMS_PARAM_FILTER_MASK_S)
+#define FW_PARAMS_PARAM_FILTER_MASK_G(x)          \
+	(((x) >> FW_PARAMS_PARAM_FILTER_MASK_S) & \
+	FW_PARAMS_PARAM_FILTER_MASK_M)
+
 enum fw_params_param_dev {
 	FW_PARAMS_PARAM_DEV_CCLK	= 0x00, /* chip core clock in khz */
 	FW_PARAMS_PARAM_DEV_PORTVEC	= 0x01, /* the port vector */
@@ -1258,6 +1275,7 @@ enum fw_params_param_dev {
 	FW_PARAMS_PARAM_DEV_HASHFILTER_WITH_OFLD = 0x28,
 	FW_PARAMS_PARAM_DEV_DBQ_TIMER	= 0x29,
 	FW_PARAMS_PARAM_DEV_DBQ_TIMERTICK = 0x2A,
+	FW_PARAMS_PARAM_DEV_FILTER = 0x2E,
 };
 
 /*
@@ -1349,6 +1367,11 @@ enum fw_params_param_dev_diag {
 	FW_PARAM_DEV_DIAG_MAXTMPTHRESH	= 0x02,
 };
 
+enum fw_params_param_dev_filter {
+	FW_PARAM_DEV_FILTER_VNIC_MODE   = 0x00,
+	FW_PARAM_DEV_FILTER_MODE_MASK   = 0x01,
+};
+
 enum fw_params_param_dev_fwcache {
 	FW_PARAM_DEV_FWCACHE_FLUSH      = 0x00,
 	FW_PARAM_DEV_FWCACHE_FLUSHINV   = 0x01,
-- 
2.9.5


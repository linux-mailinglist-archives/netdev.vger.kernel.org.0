Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955D9623746
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiKIXKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbiKIXJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:09:57 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3881D300
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 15:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668035395; x=1699571395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jPXwQksNwg+ulctwJ6MlI3YOaaIPeOJZj5BxqFv51cI=;
  b=cJlFHTAqftgcFetHfi3OPGnhkNwL6dPpKm7yCzXB/1xDlvk634wWvvSd
   oZ0eyY7TOSHuv83r2mY9xVheaAwgpAbrH62YhdqdjiAgLYb89VZsJfIpr
   dEBt5rI3KBRI4ev+Jkv5T6IPMMSZTgzUl5WQ/4BHfjcox3bfm9W7yCvU3
   /A3Ps8Ydxe8NE+8Q6EitxtoVZRJMyVCDDhQgyPzQnjaHlkwqL9vbsAkGv
   YbTbwQDhwi917N5a3r2UCqJoFTdksViLV0f9pg147/zaddp8nN9hr7Ffg
   WnudO9aOvDqZ7vZ6RtSbSjTshZBJdXvLT+v/u8xAQsj4wv1ZPRcn/KsJG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="290867574"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="290867574"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="636930563"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="636930563"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:53 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 8/9] ptp: convert remaining drivers to adjfine interface
Date:   Wed,  9 Nov 2022 15:09:44 -0800
Message-Id: <20221109230945.545440-9-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda05763
In-Reply-To: <20221109230945.545440-1-jacob.e.keller@intel.com>
References: <20221109230945.545440-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert all remaining drivers that still use .adjfreq to the newer .adjfine
implementation. These drivers are not straightforward, as they use
non-standard methods of programming their hardware. They are all converted
to use scaled_ppm_to_ppb to get the parts per billion value that their
logic depends on.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Ariel Elior <aelior@marvell.com>
Cc: Sudarsana Kalluru <skalluru@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
Cc: Derek Chickles <dchickles@marvell.com>
Cc: Satanand Burla <sburla@marvell.com>
Cc: Felix Manlunas <fmanlunas@marvell.com>
Cc: Raju Rangoju <rajur@chelsio.com>
Cc: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |  9 +++++----
 drivers/net/ethernet/cavium/liquidio/lio_main.c  | 11 +++++++----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c   | 13 ++++++++-----
 drivers/net/ethernet/freescale/fec_ptp.c         | 13 ++++++++-----
 drivers/net/ethernet/qlogic/qede/qede_ptp.c      | 13 ++++++++-----
 drivers/net/ethernet/sfc/ptp.c                   |  7 ++++---
 drivers/net/ethernet/sfc/siena/ptp.c             |  7 ++++---
 drivers/net/ethernet/ti/am65-cpts.c              |  5 +++--
 drivers/ptp/ptp_dte.c                            |  5 +++--
 9 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 51b1690fd045..5d1e4fe335aa 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13671,19 +13671,20 @@ static int bnx2x_send_update_drift_ramrod(struct bnx2x *bp, int drift_dir,
 	return bnx2x_func_state_change(bp, &func_params);
 }
 
-static int bnx2x_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int bnx2x_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct bnx2x *bp = container_of(ptp, struct bnx2x, ptp_clock_info);
 	int rc;
 	int drift_dir = 1;
 	int val, period, period1, period2, dif, dif1, dif2;
 	int best_dif = BNX2X_MAX_PHC_DRIFT, best_period = 0, best_val = 0;
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 
-	DP(BNX2X_MSG_PTP, "PTP adjfreq called, ppb = %d\n", ppb);
+	DP(BNX2X_MSG_PTP, "PTP adjfine called, ppb = %d\n", ppb);
 
 	if (!netif_running(bp->dev)) {
 		DP(BNX2X_MSG_PTP,
-		   "PTP adjfreq called while the interface is down\n");
+		   "PTP adjfine called while the interface is down\n");
 		return -ENETDOWN;
 	}
 
@@ -13818,7 +13819,7 @@ void bnx2x_register_phc(struct bnx2x *bp)
 	bp->ptp_clock_info.n_ext_ts = 0;
 	bp->ptp_clock_info.n_per_out = 0;
 	bp->ptp_clock_info.pps = 0;
-	bp->ptp_clock_info.adjfreq = bnx2x_ptp_adjfreq;
+	bp->ptp_clock_info.adjfine = bnx2x_ptp_adjfine;
 	bp->ptp_clock_info.adjtime = bnx2x_ptp_adjtime;
 	bp->ptp_clock_info.gettime64 = bnx2x_ptp_gettime;
 	bp->ptp_clock_info.settime64 = bnx2x_ptp_settime;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index d312bd594935..cc88e743d963 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1512,14 +1512,17 @@ static void free_netsgbuf_with_resp(void *buf)
 }
 
 /**
- * liquidio_ptp_adjfreq - Adjust ptp frequency
+ * liquidio_ptp_adjfine - Adjust ptp frequency
  * @ptp: PTP clock info
- * @ppb: how much to adjust by, in parts-per-billion
+ * @scaled_ppm: how much to adjust by, in scaled parts-per-million
+ *
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  */
-static int liquidio_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int liquidio_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct lio *lio = container_of(ptp, struct lio, ptp_info);
 	struct octeon_device *oct = (struct octeon_device *)lio->oct_dev;
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	u64 comp, delta;
 	unsigned long flags;
 	bool neg_adj = false;
@@ -1643,7 +1646,7 @@ static void oct_ptp_open(struct net_device *netdev)
 	lio->ptp_info.n_ext_ts = 0;
 	lio->ptp_info.n_per_out = 0;
 	lio->ptp_info.pps = 0;
-	lio->ptp_info.adjfreq = liquidio_ptp_adjfreq;
+	lio->ptp_info.adjfine = liquidio_ptp_adjfine;
 	lio->ptp_info.adjtime = liquidio_ptp_adjtime;
 	lio->ptp_info.gettime64 = liquidio_ptp_gettime;
 	lio->ptp_info.settime64 = liquidio_ptp_settime;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
index 5bf117d2179f..cbd06d9b95d4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
@@ -194,17 +194,20 @@ int cxgb4_ptp_redirect_rx_packet(struct adapter *adapter, struct port_info *pi)
 }
 
 /**
- * cxgb4_ptp_adjfreq - Adjust frequency of PHC cycle counter
+ * cxgb4_ptp_adjfine - Adjust frequency of PHC cycle counter
  * @ptp: ptp clock structure
- * @ppb: Desired frequency change in parts per billion
+ * @scaled_ppm: Desired frequency in scaled parts per billion
  *
- * Adjust the frequency of the PHC cycle counter by the indicated ppb from
+ * Adjust the frequency of the PHC cycle counter by the indicated amount from
  * the base frequency.
+ *
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  */
-static int cxgb4_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int cxgb4_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct adapter *adapter = (struct adapter *)container_of(ptp,
 				   struct adapter, ptp_clock_info);
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	struct fw_ptp_cmd c;
 	int err;
 
@@ -404,7 +407,7 @@ static const struct ptp_clock_info cxgb4_ptp_clock_info = {
 	.n_ext_ts       = 0,
 	.n_per_out      = 0,
 	.pps            = 0,
-	.adjfreq        = cxgb4_ptp_adjfreq,
+	.adjfine        = cxgb4_ptp_adjfine,
 	.adjtime        = cxgb4_ptp_adjtime,
 	.gettime64      = cxgb4_ptp_gettime,
 	.settime64      = cxgb4_ptp_settime,
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 67aa694a62ec..ab86bb8562ef 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -338,18 +338,21 @@ void fec_ptp_start_cyclecounter(struct net_device *ndev)
 }
 
 /**
- * fec_ptp_adjfreq - adjust ptp cycle frequency
+ * fec_ptp_adjfine - adjust ptp cycle frequency
  * @ptp: the ptp clock structure
- * @ppb: parts per billion adjustment from base
+ * @scaled_ppm: scaled parts per million adjustment from base
  *
  * Adjust the frequency of the ptp cycle counter by the
- * indicated ppb from the base frequency.
+ * indicated amount from the base frequency.
+ *
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  *
  * Because ENET hardware frequency adjust is complex,
  * using software method to do that.
  */
-static int fec_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int fec_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	unsigned long flags;
 	int neg_adj = 0;
 	u32 i, tmp;
@@ -742,7 +745,7 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	fep->ptp_caps.n_per_out = 1;
 	fep->ptp_caps.n_pins = 0;
 	fep->ptp_caps.pps = 1;
-	fep->ptp_caps.adjfreq = fec_ptp_adjfreq;
+	fep->ptp_caps.adjfine = fec_ptp_adjfine;
 	fep->ptp_caps.adjtime = fec_ptp_adjtime;
 	fep->ptp_caps.gettime64 = fec_ptp_gettime;
 	fep->ptp_caps.settime64 = fec_ptp_settime;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.c b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
index c9c8225f04d6..747cc5e2bb78 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
@@ -28,16 +28,19 @@ struct qede_ptp {
 };
 
 /**
- * qede_ptp_adjfreq() - Adjust the frequency of the PTP cycle counter.
+ * qede_ptp_adjfine() - Adjust the frequency of the PTP cycle counter.
  *
  * @info: The PTP clock info structure.
- * @ppb: Parts per billion adjustment from base.
+ * @scaled_ppm: Scaled parts per million adjustment from base.
+ *
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  *
  * Return: Zero on success, negative errno otherwise.
  */
-static int qede_ptp_adjfreq(struct ptp_clock_info *info, s32 ppb)
+static int qede_ptp_adjfine(struct ptp_clock_info *info, long scaled_ppm)
 {
 	struct qede_ptp *ptp = container_of(info, struct qede_ptp, clock_info);
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	struct qede_dev *edev = ptp->edev;
 	int rc;
 
@@ -47,7 +50,7 @@ static int qede_ptp_adjfreq(struct ptp_clock_info *info, s32 ppb)
 		rc = ptp->ops->adjfreq(edev->cdev, ppb);
 		spin_unlock_bh(&ptp->lock);
 	} else {
-		DP_ERR(edev, "PTP adjfreq called while interface is down\n");
+		DP_ERR(edev, "PTP adjfine called while interface is down\n");
 		rc = -EFAULT;
 	}
 	__qede_unlock(edev);
@@ -462,7 +465,7 @@ int qede_ptp_enable(struct qede_dev *edev)
 	ptp->clock_info.n_ext_ts = 0;
 	ptp->clock_info.n_per_out = 0;
 	ptp->clock_info.pps = 0;
-	ptp->clock_info.adjfreq = qede_ptp_adjfreq;
+	ptp->clock_info.adjfine = qede_ptp_adjfine;
 	ptp->clock_info.adjtime = qede_ptp_adjtime;
 	ptp->clock_info.gettime64 = qede_ptp_gettime;
 	ptp->clock_info.settime64 = qede_ptp_settime;
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index eaef4a15008a..9f07e1ba7780 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -351,7 +351,7 @@ struct efx_ptp_data {
 	void (*xmit_skb)(struct efx_nic *efx, struct sk_buff *skb);
 };
 
-static int efx_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta);
+static int efx_phc_adjfine(struct ptp_clock_info *ptp, long scaled_ppm);
 static int efx_phc_adjtime(struct ptp_clock_info *ptp, s64 delta);
 static int efx_phc_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts);
 static int efx_phc_settime(struct ptp_clock_info *ptp,
@@ -1508,7 +1508,7 @@ static const struct ptp_clock_info efx_phc_clock_info = {
 	.n_per_out	= 0,
 	.n_pins		= 0,
 	.pps		= 1,
-	.adjfreq	= efx_phc_adjfreq,
+	.adjfine	= efx_phc_adjfine,
 	.adjtime	= efx_phc_adjtime,
 	.gettime64	= efx_phc_gettime,
 	.settime64	= efx_phc_settime,
@@ -2137,11 +2137,12 @@ void __efx_rx_skb_attach_timestamp(struct efx_channel *channel,
 					ptp->ts_corrections.general_rx);
 }
 
-static int efx_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta)
+static int efx_phc_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct efx_ptp_data *ptp_data = container_of(ptp,
 						     struct efx_ptp_data,
 						     phc_clock_info);
+	s32 delta = scaled_ppm_to_ppb(scaled_ppm);
 	struct efx_nic *efx = ptp_data->efx;
 	MCDI_DECLARE_BUF(inadj, MC_CMD_PTP_IN_ADJUST_LEN);
 	s64 adjustment_ns;
diff --git a/drivers/net/ethernet/sfc/siena/ptp.c b/drivers/net/ethernet/sfc/siena/ptp.c
index 7c46752e6eae..38e666561bcd 100644
--- a/drivers/net/ethernet/sfc/siena/ptp.c
+++ b/drivers/net/ethernet/sfc/siena/ptp.c
@@ -347,7 +347,7 @@ struct efx_ptp_data {
 	void (*xmit_skb)(struct efx_nic *efx, struct sk_buff *skb);
 };
 
-static int efx_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta);
+static int efx_phc_adjfine(struct ptp_clock_info *ptp, long scaled_ppm);
 static int efx_phc_adjtime(struct ptp_clock_info *ptp, s64 delta);
 static int efx_phc_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts);
 static int efx_phc_settime(struct ptp_clock_info *ptp,
@@ -1429,7 +1429,7 @@ static const struct ptp_clock_info efx_phc_clock_info = {
 	.n_per_out	= 0,
 	.n_pins		= 0,
 	.pps		= 1,
-	.adjfreq	= efx_phc_adjfreq,
+	.adjfine	= efx_phc_adjfine,
 	.adjtime	= efx_phc_adjtime,
 	.gettime64	= efx_phc_gettime,
 	.settime64	= efx_phc_settime,
@@ -2044,11 +2044,12 @@ void __efx_siena_rx_skb_attach_timestamp(struct efx_channel *channel,
 					ptp->ts_corrections.general_rx);
 }
 
-static int efx_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta)
+static int efx_phc_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct efx_ptp_data *ptp_data = container_of(ptp,
 						     struct efx_ptp_data,
 						     phc_clock_info);
+	s32 delta = scaled_ppm_to_ppb(scaled_ppm);
 	struct efx_nic *efx = ptp_data->efx;
 	MCDI_DECLARE_BUF(inadj, MC_CMD_PTP_IN_ADJUST_LEN);
 	s64 adjustment_ns;
diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 7f928c343426..9535396b28cd 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -391,9 +391,10 @@ static irqreturn_t am65_cpts_interrupt(int irq, void *dev_id)
 }
 
 /* PTP clock operations */
-static int am65_cpts_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int am65_cpts_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct am65_cpts *cpts = container_of(ptp, struct am65_cpts, ptp_info);
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	int neg_adj = 0;
 	u64 adj_period;
 	u32 val;
@@ -625,7 +626,7 @@ static long am65_cpts_ts_work(struct ptp_clock_info *ptp);
 static struct ptp_clock_info am65_ptp_info = {
 	.owner		= THIS_MODULE,
 	.name		= "CTPS timer",
-	.adjfreq	= am65_cpts_ptp_adjfreq,
+	.adjfine	= am65_cpts_ptp_adjfine,
 	.adjtime	= am65_cpts_ptp_adjtime,
 	.gettimex64	= am65_cpts_ptp_gettimex,
 	.settime64	= am65_cpts_ptp_settime,
diff --git a/drivers/ptp/ptp_dte.c b/drivers/ptp/ptp_dte.c
index 8641fd060491..7cc5a00e625b 100644
--- a/drivers/ptp/ptp_dte.c
+++ b/drivers/ptp/ptp_dte.c
@@ -134,8 +134,9 @@ static s64 dte_read_nco_with_ovf(struct ptp_dte *ptp_dte)
 	return ns;
 }
 
-static int ptp_dte_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int ptp_dte_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	u32 nco_incr;
 	unsigned long flags;
 	struct ptp_dte *ptp_dte = container_of(ptp, struct ptp_dte, caps);
@@ -219,7 +220,7 @@ static const struct ptp_clock_info ptp_dte_caps = {
 	.n_ext_ts	= 0,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= ptp_dte_adjfreq,
+	.adjfine	= ptp_dte_adjfine,
 	.adjtime	= ptp_dte_adjtime,
 	.gettime64	= ptp_dte_gettime,
 	.settime64	= ptp_dte_settime,
-- 
2.38.0.83.gd420dda05763


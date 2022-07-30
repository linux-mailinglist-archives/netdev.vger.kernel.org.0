Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E6E585A4F
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 13:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbiG3L62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 07:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbiG3L6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 07:58:21 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D1026AC5;
        Sat, 30 Jul 2022 04:58:19 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26UBu3nZ001480;
        Sat, 30 Jul 2022 04:58:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=4ld6NJqVY2yfjN8Z+5MKhcFsb/s3B6nb3vd8nKttG2o=;
 b=OXnU71fxGfawseZSu6KxW34nn9AzqIgKb5P4+ioS0NPUiegk3WQQdOafktva1EiE+OUu
 1i2XveUmLuNjWrJphQwJIRXAjsDUx/kctzh4FQmsJqlFqxpdljAtiFt53xdF6J7Ch/k4
 cbHwGvz1gd28kCVrlPqaQGh3hwU1sL0d06uSacGzs6iFmKH8QFiDIwu38ADwRRe6BXBy
 QVdQUpj2skpkJvyeCSRsZh+V/+mQnfI0t1nodTFYkCCcMWXIUr4OQ3Rptkb9TscdQET5
 lOtmBDBoQPv6Z7+gxTEU4pNCkJ5UPHBGMeyEzfkfyowZiOHFogeQWv0KO2BQhq9CUXV5 fA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hn20q09xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 30 Jul 2022 04:58:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jul
 2022 04:58:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sat, 30 Jul 2022 04:58:09 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id A92953F704B;
        Sat, 30 Jul 2022 04:58:06 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>
CC:     Hariprasad Kelam <hkelam@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH v2 2/4] octeontx2-pf: Add support for ptp 1-step mode on CN10K silicon
Date:   Sat, 30 Jul 2022 17:27:56 +0530
Message-ID: <20220730115758.16787-3-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20220730115758.16787-1-naveenm@marvell.com>
References: <20220730115758.16787-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: ceUfMnIQXerYymlmewp-A3T41ajD9G2z
X-Proofpoint-ORIG-GUID: ceUfMnIQXerYymlmewp-A3T41ajD9G2z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-30_07,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

Add support for ptp 1-step mode using timecounter. The seconds and
nanoseconds to be updated in PTP header are calculated by adding the
timecounter offset to the free running PTP clock counter time. The PF
driver periodically gets the PTP clock time using AF mbox. The 1-step
support uses HW feature to update correction field rather than
OriginTimestamp field in PTP header.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |  19 +++-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |   5 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   1 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  13 +++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   8 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  11 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |  90 +++++++++++------
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  11 ++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 110 ++++++++++++++++++++-
 10 files changed, 234 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index ef59de43b11e..a70e1153fa04 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -415,11 +415,26 @@ void rpm_lmac_ptp_config(void *rpmd, int lmac_id, bool enable)
 		return;
 
 	cfg = rpm_read(rpm, lmac_id, RPMX_CMRX_CFG);
-	if (enable)
+	if (enable) {
 		cfg |= RPMX_RX_TS_PREPEND;
-	else
+		cfg |= RPMX_TX_PTP_1S_SUPPORT;
+	} else {
 		cfg &= ~RPMX_RX_TS_PREPEND;
+		cfg &= ~RPMX_TX_PTP_1S_SUPPORT;
+	}
+
 	rpm_write(rpm, lmac_id, RPMX_CMRX_CFG, cfg);
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_XIF_MODE);
+
+	if (enable) {
+		cfg |= RPMX_ONESTEP_ENABLE;
+		cfg &= ~RPMX_TS_BINARY_MODE;
+	} else {
+		cfg &= ~RPMX_ONESTEP_ENABLE;
+	}
+
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_XIF_MODE, cfg);
 }
 
 int rpm_lmac_pfc_config(void *rpmd, int lmac_id, u8 tx_pause, u8 rx_pause, u16 pfc_en)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index c2bd6e54ea51..77f2ef9e1425 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -16,6 +16,7 @@
 /* Registers */
 #define RPMX_CMRX_CFG			0x00
 #define RPMX_RX_TS_PREPEND              BIT_ULL(22)
+#define RPMX_TX_PTP_1S_SUPPORT          BIT_ULL(17)
 #define RPMX_CMRX_SW_INT                0x180
 #define RPMX_CMRX_SW_INT_W1S            0x188
 #define RPMX_CMRX_SW_INT_ENA_W1S        0x198
@@ -72,6 +73,10 @@
 #define RPMX_MTI_MAC100X_CL89_PAUSE_QUANTA		0x8108
 #define RPM_DEFAULT_PAUSE_TIME                          0x7FF
 
+#define RPMX_MTI_MAC100X_XIF_MODE		        0x8100
+#define RPMX_ONESTEP_ENABLE				BIT_ULL(5)
+#define RPMX_TS_BINARY_MODE				BIT_ULL(11)
+
 /* Function Declarations */
 int rpm_get_nr_lmacs(void *rpmd);
 u8 rpm_get_lmac_type(void *rpmd, int lmac_id);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 0879a48411f3..7646bb2ec89b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4296,8 +4296,14 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 	/* Restore CINT timer delay to HW reset values */
 	rvu_write64(rvu, blkaddr, NIX_AF_CINT_DELAY, 0x0ULL);
 
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SEB_CFG);
+
 	/* For better performance use NDC TX instead of NDC RX for SQ's SQEs" */
-	rvu_write64(rvu, blkaddr, NIX_AF_SEB_CFG, 0x1ULL);
+	cfg |= 1ULL;
+	if (!is_rvu_otx2(rvu))
+		cfg |= NIX_PTP_1STEP_EN;
+
+	rvu_write64(rvu, blkaddr, NIX_AF_SEB_CFG, cfg);
 
 	if (is_block_implemented(hw, blkaddr)) {
 		err = nix_setup_txschq(rvu, nix_hw, blkaddr);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 77a9ade91f3e..0e0d536645ac 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -266,6 +266,7 @@
 #define NIX_AF_TX_NPC_CAPTURE_CONFIG	(0x0660)
 #define NIX_AF_TX_NPC_CAPTURE_INFO	(0x0670)
 #define NIX_AF_SEB_CFG			(0x05F0)
+#define NIX_PTP_1STEP_EN		BIT_ULL(2)
 
 #define NIX_AF_DEBUG_NPC_RESP_DATAX(a)          (0x680 | (a) << 3)
 #define NIX_AF_SMQX_CFG(a)                      (0x700 | (a) << 16)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index e795f9ee76dd..a7683969c2eb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -237,6 +237,7 @@ struct otx2_hw {
 #define CN10K_MBOX		1
 #define CN10K_LMTST		2
 #define CN10K_RPM		3
+#define CN10K_PTP_ONESTEP	4
 	unsigned long		cap_flag;
 
 #define LMT_LINE_SIZE		128
@@ -270,6 +271,13 @@ struct refill_work {
 	struct otx2_nic *pf;
 };
 
+/* PTPv2 originTimestamp structure */
+struct ptpv2_tstamp {
+	__be16 seconds_msb; /* 16 bits + */
+	__be32 seconds_lsb; /* 32 bits = 48 bits*/
+	__be32 nanoseconds;
+} __packed;
+
 struct otx2_ptp {
 	struct ptp_clock_info ptp_info;
 	struct ptp_clock *ptp_clock;
@@ -285,6 +293,9 @@ struct otx2_ptp {
 	struct ptp_pin_desc extts_config;
 	u64 (*convert_rx_ptp_tstmp)(u64 timestamp);
 	u64 (*convert_tx_ptp_tstmp)(u64 timestamp);
+	struct delayed_work synctstamp_work;
+	u64 tstamp;
+	u32 base_ns;
 };
 
 #define OTX2_HW_TIMESTAMP_LEN	8
@@ -357,6 +368,7 @@ struct otx2_nic {
 #define OTX2_FLAG_TC_MATCHALL_EGRESS_ENABLED	BIT_ULL(12)
 #define OTX2_FLAG_TC_MATCHALL_INGRESS_ENABLED	BIT_ULL(13)
 #define OTX2_FLAG_DMACFLTR_SUPPORT		BIT_ULL(14)
+#define OTX2_FLAG_PTP_ONESTEP_SYNC		BIT_ULL(15)
 #define OTX2_FLAG_ADPTV_INT_COAL_ENABLED BIT_ULL(16)
 	u64			flags;
 	u64			*cq_op_addr;
@@ -486,6 +498,7 @@ static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
 		__set_bit(CN10K_MBOX, &hw->cap_flag);
 		__set_bit(CN10K_LMTST, &hw->cap_flag);
 		__set_bit(CN10K_RPM, &hw->cap_flag);
+		__set_bit(CN10K_PTP_ONESTEP, &hw->cap_flag);
 	}
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 3f60a80e34c8..d1d089160ed4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -963,10 +963,12 @@ static int otx2_get_ts_info(struct net_device *netdev,
 
 	info->phc_index = otx2_ptp_clock_index(pfvf);
 
-	info->tx_types = (1 << HWTSTAMP_TX_OFF) | (1 << HWTSTAMP_TX_ON);
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON);
+	if (test_bit(CN10K_PTP_ONESTEP, &pfvf->hw.cap_flag))
+		info->tx_types |= BIT(HWTSTAMP_TX_ONESTEP_SYNC);
 
-	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
-			   (1 << HWTSTAMP_FILTER_ALL);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_ALL);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 9376d0e62914..676bd14e1c40 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1987,8 +1987,19 @@ int otx2_config_hwtstamp(struct net_device *netdev, struct ifreq *ifr)
 
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
+		if (pfvf->flags & OTX2_FLAG_PTP_ONESTEP_SYNC)
+			pfvf->flags &= ~OTX2_FLAG_PTP_ONESTEP_SYNC;
+
+		cancel_delayed_work(&pfvf->ptp->synctstamp_work);
 		otx2_config_hw_tx_tstamp(pfvf, false);
 		break;
+	case HWTSTAMP_TX_ONESTEP_SYNC:
+		if (!test_bit(CN10K_PTP_ONESTEP, &pfvf->hw.cap_flag))
+			return -ERANGE;
+		pfvf->flags |= OTX2_FLAG_PTP_ONESTEP_SYNC;
+		schedule_delayed_work(&pfvf->ptp->synctstamp_work,
+				      msecs_to_jiffies(500));
+		fallthrough;
 	case HWTSTAMP_TX_ON:
 		otx2_config_hw_tx_tstamp(pfvf, true);
 		break;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
index fdc2c9315b91..743c8a6d5dad 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
@@ -10,6 +10,33 @@
 #include "otx2_common.h"
 #include "otx2_ptp.h"
 
+static u64 otx2_ptp_get_clock(struct otx2_ptp *ptp)
+{
+	struct ptp_req *req;
+	struct ptp_rsp *rsp;
+	int err;
+
+	if (!ptp->nic)
+		return 0;
+
+	req = otx2_mbox_alloc_msg_ptp_op(&ptp->nic->mbox);
+	if (!req)
+		return 0;
+
+	req->op = PTP_OP_GET_CLOCK;
+
+	err = otx2_sync_mbox_msg(&ptp->nic->mbox);
+	if (err)
+		return 0;
+
+	rsp = (struct ptp_rsp *)otx2_mbox_get_rsp(&ptp->nic->mbox.mbox, 0,
+						  &req->hdr);
+	if (IS_ERR(rsp))
+		return 0;
+
+	return rsp->clk;
+}
+
 static int otx2_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
 {
 	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
@@ -49,29 +76,8 @@ static int ptp_set_thresh(struct otx2_ptp *ptp, u64 thresh)
 static u64 ptp_cc_read(const struct cyclecounter *cc)
 {
 	struct otx2_ptp *ptp = container_of(cc, struct otx2_ptp, cycle_counter);
-	struct ptp_req *req;
-	struct ptp_rsp *rsp;
-	int err;
-
-	if (!ptp->nic)
-		return 0;
-
-	req = otx2_mbox_alloc_msg_ptp_op(&ptp->nic->mbox);
-	if (!req)
-		return 0;
 
-	req->op = PTP_OP_GET_CLOCK;
-
-	err = otx2_sync_mbox_msg(&ptp->nic->mbox);
-	if (err)
-		return 0;
-
-	rsp = (struct ptp_rsp *)otx2_mbox_get_rsp(&ptp->nic->mbox.mbox, 0,
-						  &req->hdr);
-	if (IS_ERR(rsp))
-		return 0;
-
-	return rsp->clk;
+	return otx2_ptp_get_clock(ptp);
 }
 
 static u64 ptp_tstmp_read(struct otx2_ptp *ptp)
@@ -101,6 +107,15 @@ static u64 ptp_tstmp_read(struct otx2_ptp *ptp)
 	return rsp->clk;
 }
 
+static void otx2_get_ptpclock(struct otx2_ptp *ptp, u64 *tstamp)
+{
+	struct otx2_nic *pfvf = ptp->nic;
+
+	mutex_lock(&pfvf->mbox.lock);
+	*tstamp = timecounter_read(&ptp->time_counter);
+	mutex_unlock(&pfvf->mbox.lock);
+}
+
 static int otx2_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
 {
 	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
@@ -119,14 +134,10 @@ static int otx2_ptp_gettime(struct ptp_clock_info *ptp_info,
 {
 	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
 					    ptp_info);
-	struct otx2_nic *pfvf = ptp->nic;
-	u64 nsec;
+	u64 tstamp;
 
-	mutex_lock(&pfvf->mbox.lock);
-	nsec = timecounter_read(&ptp->time_counter);
-	mutex_unlock(&pfvf->mbox.lock);
-
-	*ts = ns_to_timespec64(nsec);
+	otx2_get_ptpclock(ptp, &tstamp);
+	*ts = ns_to_timespec64(tstamp);
 
 	return 0;
 }
@@ -191,6 +202,23 @@ static void otx2_ptp_extts_check(struct work_struct *work)
 	schedule_delayed_work(&ptp->extts_work, msecs_to_jiffies(200));
 }
 
+static void otx2_sync_tstamp(struct work_struct *work)
+{
+	struct otx2_ptp *ptp = container_of(work, struct otx2_ptp,
+					    synctstamp_work.work);
+	struct otx2_nic *pfvf = ptp->nic;
+	u64 tstamp;
+
+	mutex_lock(&pfvf->mbox.lock);
+	tstamp = otx2_ptp_get_clock(ptp);
+	mutex_unlock(&pfvf->mbox.lock);
+
+	ptp->tstamp = timecounter_cyc2time(&pfvf->ptp->time_counter, tstamp);
+	ptp->base_ns = tstamp % NSEC_PER_SEC;
+
+	schedule_delayed_work(&ptp->synctstamp_work, msecs_to_jiffies(250));
+}
+
 static int otx2_ptp_enable(struct ptp_clock_info *ptp_info,
 			   struct ptp_clock_request *rq, int on)
 {
@@ -302,6 +330,8 @@ int otx2_ptp_init(struct otx2_nic *pfvf)
 		ptp_ptr->convert_tx_ptp_tstmp = &cn10k_ptp_convert_timestamp;
 	}
 
+	INIT_DELAYED_WORK(&ptp_ptr->synctstamp_work, otx2_sync_tstamp);
+
 	pfvf->ptp = ptp_ptr;
 
 error:
@@ -316,6 +346,8 @@ void otx2_ptp_destroy(struct otx2_nic *pfvf)
 	if (!ptp)
 		return;
 
+	cancel_delayed_work(&pfvf->ptp->synctstamp_work);
+
 	ptp_clock_unregister(ptp->ptp_clock);
 	kfree(ptp);
 	pfvf->ptp = NULL;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
index 4bbd12ff26e6..aa205a0d158f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -236,8 +236,15 @@ struct nix_sqe_sg_s {
 
 /* NIX send memory subdescriptor structure */
 struct nix_sqe_mem_s {
-	u64 offset        : 16; /* W0 */
-	u64 rsvd_51_16    : 36;
+	u64 start_offset  : 8;
+	u64 rsvd_11_8	  : 4;
+	u64 rsvd_12	  : 1;
+	u64 udp_csum_crt  : 1;
+	u64 update64      : 1;
+	u64 rsvd_15_16    : 1;
+	u64 base_ns       : 32;
+	u64 step_type     : 1;
+	u64 rsvd_51_49    : 3;
 	u64 per_lso_seg   : 1;
 	u64 wmem          : 1;
 	u64 dsz           : 2;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index a18e8efd0f1e..5ec11d71bf60 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -19,6 +19,12 @@
 #include "cn10k.h"
 
 #define CQE_ADDR(CQ, idx) ((CQ)->cqe_base + ((CQ)->cqe_size * (idx)))
+#define PTP_PORT	        0x13F
+/* PTPv2 header Original Timestamp starts at byte offset 34 and
+ * contains 6 byte seconds field and 4 byte nano seconds field.
+ */
+#define PTP_SYNC_SEC_OFFSET	34
+
 static bool otx2_xdp_rcv_pkt_handler(struct otx2_nic *pfvf,
 				     struct bpf_prog *prog,
 				     struct nix_cqe_rx_s *cqe,
@@ -686,7 +692,8 @@ static void otx2_sqe_add_ext(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 }
 
 static void otx2_sqe_add_mem(struct otx2_snd_queue *sq, int *offset,
-			     int alg, u64 iova)
+			     int alg, u64 iova, int ptp_offset,
+			     u64 base_ns, int udp_csum)
 {
 	struct nix_sqe_mem_s *mem;
 
@@ -696,6 +703,13 @@ static void otx2_sqe_add_mem(struct otx2_snd_queue *sq, int *offset,
 	mem->wmem = 1; /* wait for the memory operation */
 	mem->addr = iova;
 
+	if (ptp_offset) {
+		mem->start_offset = ptp_offset;
+		mem->udp_csum_crt = udp_csum;
+		mem->base_ns = base_ns;
+		mem->step_type = 1;
+	}
+
 	*offset += sizeof(*mem);
 }
 
@@ -952,16 +966,102 @@ static int otx2_get_sqe_count(struct otx2_nic *pfvf, struct sk_buff *skb)
 	return skb_shinfo(skb)->gso_segs;
 }
 
+static bool otx2_validate_network_transport(struct sk_buff *skb)
+{
+	if ((ip_hdr(skb)->protocol == IPPROTO_UDP) ||
+	    (ipv6_hdr(skb)->nexthdr == IPPROTO_UDP)) {
+		struct udphdr *udph = udp_hdr(skb);
+
+		if (udph->source == htons(PTP_PORT) &&
+		    udph->dest == htons(PTP_PORT))
+			return true;
+	}
+
+	return false;
+}
+
+static bool otx2_ptp_is_sync(struct sk_buff *skb, int *offset, int *udp_csum)
+{
+	struct ethhdr *eth = (struct ethhdr *)(skb->data);
+	u16 nix_offload_hlen = 0, inner_vhlen = 0;
+	u8 *data = skb->data, *msgtype;
+	__be16 proto = eth->h_proto;
+	int network_depth = 0;
+
+	/* NIX is programmed to offload outer  VLAN header
+	 * in case of single vlan protocol field holds Network header ETH_IP/V6
+	 * in case of stacked vlan protocol field holds Inner vlan (8100)
+	 */
+	if (skb->dev->features & NETIF_F_HW_VLAN_CTAG_TX &&
+	    skb->dev->features & NETIF_F_HW_VLAN_STAG_TX) {
+		if (skb->vlan_proto == htons(ETH_P_8021AD)) {
+			/* Get vlan protocol */
+			proto = __vlan_get_protocol(skb, eth->h_proto, NULL);
+			/* SKB APIs like skb_transport_offset does not include
+			 * offloaded vlan header length. Need to explicitly add
+			 * the length
+			 */
+			nix_offload_hlen = VLAN_HLEN;
+			inner_vhlen = VLAN_HLEN;
+		} else if (skb->vlan_proto == htons(ETH_P_8021Q)) {
+			nix_offload_hlen = VLAN_HLEN;
+		}
+	} else if (eth_type_vlan(eth->h_proto)) {
+		proto = __vlan_get_protocol(skb, eth->h_proto, &network_depth);
+	}
+
+	switch (ntohs(proto)) {
+	case ETH_P_1588:
+		if (network_depth)
+			*offset = network_depth;
+		else
+			*offset = ETH_HLEN + nix_offload_hlen +
+				  inner_vhlen;
+		break;
+	case ETH_P_IP:
+	case ETH_P_IPV6:
+		if (!otx2_validate_network_transport(skb))
+			return false;
+
+		*udp_csum = 1;
+		*offset = nix_offload_hlen + skb_transport_offset(skb) +
+			  sizeof(struct udphdr);
+	}
+
+	msgtype = data + *offset;
+
+	/* Check PTP messageId is SYNC or not */
+	return (*msgtype & 0xf) == 0;
+}
+
 static void otx2_set_txtstamp(struct otx2_nic *pfvf, struct sk_buff *skb,
 			      struct otx2_snd_queue *sq, int *offset)
 {
+	struct ptpv2_tstamp *origin_tstamp;
+	int ptp_offset = 0, udp_csum = 0;
+	struct timespec64 ts;
 	u64 iova;
 
-	if (!skb_shinfo(skb)->gso_size &&
-	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+	if (unlikely(!skb_shinfo(skb)->gso_size &&
+		     (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))) {
+		if (unlikely(pfvf->flags & OTX2_FLAG_PTP_ONESTEP_SYNC)) {
+			if (otx2_ptp_is_sync(skb, &ptp_offset, &udp_csum)) {
+				origin_tstamp = (struct ptpv2_tstamp *)
+						((u8 *)skb->data + ptp_offset +
+						 PTP_SYNC_SEC_OFFSET);
+				ts = ns_to_timespec64(pfvf->ptp->tstamp);
+				origin_tstamp->seconds_msb = htons((ts.tv_sec >> 32) & 0xffff);
+				origin_tstamp->seconds_lsb = htonl(ts.tv_sec & 0xffffffff);
+				origin_tstamp->nanoseconds = htonl(ts.tv_nsec);
+				/* Point to correction field in PTP packet */
+				ptp_offset += 8;
+			}
+		} else {
+			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+		}
 		iova = sq->timestamps->iova + (sq->head * sizeof(u64));
-		otx2_sqe_add_mem(sq, offset, NIX_SENDMEMALG_E_SETTSTMP, iova);
+		otx2_sqe_add_mem(sq, offset, NIX_SENDMEMALG_E_SETTSTMP, iova,
+				 ptp_offset, pfvf->ptp->base_ns, udp_csum);
 	} else {
 		skb_tx_timestamp(skb);
 	}
-- 
2.16.5


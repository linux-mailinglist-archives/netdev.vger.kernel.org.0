Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD0841ADDA
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbhI1LdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:33:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21116 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240426AbhI1LdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 07:33:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SAFB9t019512;
        Tue, 28 Sep 2021 04:31:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=YpdgH2yMIHWYr1euH8cXqh2OAVkI1JEaM+Z4U4h2HBg=;
 b=EDn9iO3IgdnDwf1SFyxsnfKC4lPnm6O3vpTGRe7lg7OacXVfst1EdUTZMc8TUSNiId6G
 ZRz7JKDAVQzoCoCDdlplBBpqMB0MbmPEIf6NfQNLAeJpmqgRejscFS4+RHlMjV43Q9aH
 W8sb3ybXIACYm8Tzef+ySx2/Sxb8962SXsehRk1hZpMYwBJ6lUFnMaMJGo1wDQBoivv0
 TVYSvwfznVJa0a+JVZBa8FfQPRVk5odunnk1Mx/zXrG4zfhF4/qglqZ3ksiqeGfMoTY7
 Vw7FANbL1waco/9P+o/Z4rwCootTfyU9lnt96EPaB4w4sULik94MM5I7aBOx5f8e9+pe sw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bc14pr84r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 04:31:23 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 04:31:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 28 Sep 2021 04:31:21 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 277613F7099;
        Tue, 28 Sep 2021 04:31:17 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 4/4] octeontx2-af: Add external ptp input clock
Date:   Tue, 28 Sep 2021 17:01:01 +0530
Message-ID: <20210928113101.16580-5-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210928113101.16580-1-hkelam@marvell.com>
References: <20210928113101.16580-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: lZCazmaqVYz10NH5ogOyuhJyoteDmcdI
X-Proofpoint-GUID: lZCazmaqVYz10NH5ogOyuhJyoteDmcdI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yi Guo <yig@marvell.com>

PTP hardware block can be configured to utilize
the external clock. Also the current ptp timestamp
can be captured when external trigger is applied on
a gpio pin. These features are required in scenarios
like connecting a external timing device to the chip
for time synchronization. The timing device provides
the clock and trigger(PPS signal) to the PTP block.
This patch does the following:
1. configures PTP block to use external clock
frequency and timestamp capture on external event.
2. sends PTP_REQ_EXTTS events to kernel ptp phc susbsytem
with captured timestamps
3. aligns PPS edge to adjusted ptp clock in the ptp device
by setting the PPS_THRESH to the reminder of the last
timestamp value captured by external PPS

Signed-off-by: Yi Guo <yig@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |   3 +
 .../net/ethernet/marvell/octeontx2/af/ptp.c   |  55 +++++++-
 .../net/ethernet/marvell/octeontx2/af/ptp.h   |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   3 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   4 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   6 +
 .../ethernet/marvell/octeontx2/nic/otx2_ptp.c | 120 +++++++++++++++++-
 7 files changed, 187 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index b5ee324d17c9..dfe487235007 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1420,12 +1420,15 @@ struct npc_mcam_get_stats_rsp {
 enum ptp_op {
 	PTP_OP_ADJFINE = 0,
 	PTP_OP_GET_CLOCK = 1,
+	PTP_OP_GET_TSTMP = 2,
+	PTP_OP_SET_THRESH = 3,
 };
 
 struct ptp_req {
 	struct mbox_msghdr hdr;
 	u8 op;
 	s64 scaled_ppm;
+	u64 thresh;
 };
 
 struct ptp_rsp {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index 477491c001b6..d6321de3cc17 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -30,9 +30,22 @@
 
 #define PTP_CLOCK_CFG				0xF00ULL
 #define PTP_CLOCK_CFG_PTP_EN			BIT_ULL(0)
+#define PTP_CLOCK_CFG_EXT_CLK_EN		BIT_ULL(1)
+#define PTP_CLOCK_CFG_EXT_CLK_IN_MASK		GENMASK_ULL(7, 2)
+#define PTP_CLOCK_CFG_TSTMP_EDGE		BIT_ULL(9)
+#define PTP_CLOCK_CFG_TSTMP_EN			BIT_ULL(8)
+#define PTP_CLOCK_CFG_TSTMP_IN_MASK		GENMASK_ULL(15, 10)
+#define PTP_CLOCK_CFG_PPS_EN			BIT_ULL(30)
+#define PTP_CLOCK_CFG_PPS_INV			BIT_ULL(31)
+
+#define PTP_PPS_HI_INCR				0xF60ULL
+#define PTP_PPS_LO_INCR				0xF68ULL
+#define PTP_PPS_THRESH_HI			0xF58ULL
+
 #define PTP_CLOCK_LO				0xF08ULL
 #define PTP_CLOCK_HI				0xF10ULL
 #define PTP_CLOCK_COMP				0xF18ULL
+#define PTP_TIMESTAMP				0xF20ULL
 
 static struct ptp *first_ptp_block;
 static const struct pci_device_id ptp_id_table[];
@@ -107,7 +120,7 @@ static int ptp_get_clock(struct ptp *ptp, u64 *clk)
 	return 0;
 }
 
-void ptp_start(struct ptp *ptp, u64 sclk)
+void ptp_start(struct ptp *ptp, u64 sclk, u32 ext_clk_freq, u32 extts)
 {
 	struct pci_dev *pdev;
 	u64 clock_comp;
@@ -128,14 +141,48 @@ void ptp_start(struct ptp *ptp, u64 sclk)
 
 	/* Enable PTP clock */
 	clock_cfg = readq(ptp->reg_base + PTP_CLOCK_CFG);
+
+	if (ext_clk_freq) {
+		ptp->clock_rate = ext_clk_freq;
+		/* Set GPIO as PTP clock source */
+		clock_cfg &= ~PTP_CLOCK_CFG_EXT_CLK_IN_MASK;
+		clock_cfg |= PTP_CLOCK_CFG_EXT_CLK_EN;
+	}
+
+	if (extts) {
+		clock_cfg |= PTP_CLOCK_CFG_TSTMP_EDGE;
+		/* Set GPIO as timestamping source */
+		clock_cfg &= ~PTP_CLOCK_CFG_TSTMP_IN_MASK;
+		clock_cfg |= PTP_CLOCK_CFG_TSTMP_EN;
+	}
+
 	clock_cfg |= PTP_CLOCK_CFG_PTP_EN;
+	clock_cfg |= PTP_CLOCK_CFG_PPS_EN | PTP_CLOCK_CFG_PPS_INV;
 	writeq(clock_cfg, ptp->reg_base + PTP_CLOCK_CFG);
 
+	/* Set 50% duty cycle for 1Hz output */
+	writeq(0x1dcd650000000000, ptp->reg_base + PTP_PPS_HI_INCR);
+	writeq(0x1dcd650000000000, ptp->reg_base + PTP_PPS_LO_INCR);
+
 	clock_comp = ((u64)1000000000ull << 32) / ptp->clock_rate;
 	/* Initial compensation value to start the nanosecs counter */
 	writeq(clock_comp, ptp->reg_base + PTP_CLOCK_COMP);
 }
 
+static int ptp_get_tstmp(struct ptp *ptp, u64 *clk)
+{
+	*clk = readq(ptp->reg_base + PTP_TIMESTAMP);
+
+	return 0;
+}
+
+static int ptp_set_thresh(struct ptp *ptp, u64 thresh)
+{
+	writeq(thresh, ptp->reg_base + PTP_PPS_THRESH_HI);
+
+	return 0;
+}
+
 static int ptp_probe(struct pci_dev *pdev,
 		     const struct pci_device_id *ent)
 {
@@ -250,6 +297,12 @@ int rvu_mbox_handler_ptp_op(struct rvu *rvu, struct ptp_req *req,
 	case PTP_OP_GET_CLOCK:
 		err = ptp_get_clock(rvu->ptp, &rsp->clk);
 		break;
+	case PTP_OP_GET_TSTMP:
+		err = ptp_get_tstmp(rvu->ptp, &rsp->clk);
+		break;
+	case PTP_OP_SET_THRESH:
+		err = ptp_set_thresh(rvu->ptp, req->thresh);
+		break;
 	default:
 		err = -EINVAL;
 		break;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.h b/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
index 1ed350ad6f1f..1b81a0493cd3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
@@ -20,7 +20,7 @@ struct ptp {
 
 struct ptp *ptp_get(void);
 void ptp_put(struct ptp *ptp);
-void ptp_start(struct ptp *ptp, u64 sclk);
+void ptp_start(struct ptp *ptp, u64 sclk, u32 ext_clk_freq, u32 extts);
 
 extern struct pci_driver ptp_driver;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 87a32a17d49e..4cb24e91e648 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3241,7 +3241,8 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&rvu->rswitch.switch_lock);
 
 	if (rvu->fwdata)
-		ptp_start(rvu->ptp, rvu->fwdata->sclk);
+		ptp_start(rvu->ptp, rvu->fwdata->sclk, rvu->fwdata->ptp_ext_clk_rate,
+			  rvu->fwdata->ptp_ext_tstamp);
 
 	return 0;
 err_dl:
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 95e807626a3e..58b166698fa5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -396,7 +396,9 @@ struct rvu_fwdata {
 	u64 mcam_addr;
 	u64 mcam_sz;
 	u64 msixtr_base;
-#define FWDATA_RESERVED_MEM 1023
+	u32 ptp_ext_clk_rate;
+	u32 ptp_ext_tstamp;
+#define FWDATA_RESERVED_MEM 1022
 	u64 reserved[FWDATA_RESERVED_MEM];
 #define CGX_MAX         5
 #define CGX_LMACS_MAX   4
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 8e51a1db7e29..0a792fce55f1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -264,6 +264,12 @@ struct otx2_ptp {
 
 	struct cyclecounter cycle_counter;
 	struct timecounter time_counter;
+
+	struct delayed_work extts_work;
+	u64 last_extts;
+	u64 thresh;
+
+	struct ptp_pin_desc extts_config;
 };
 
 #define OTX2_HW_TIMESTAMP_LEN	8
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
index ec9e49985c2c..5e3056a89ee0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
@@ -27,6 +27,23 @@ static int otx2_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
 	return otx2_sync_mbox_msg(&ptp->nic->mbox);
 }
 
+static int ptp_set_thresh(struct otx2_ptp *ptp, u64 thresh)
+{
+	struct ptp_req *req;
+
+	if (!ptp->nic)
+		return -ENODEV;
+
+	req = otx2_mbox_alloc_msg_ptp_op(&ptp->nic->mbox);
+	if (!req)
+		return -ENOMEM;
+
+	req->op = PTP_OP_SET_THRESH;
+	req->thresh = thresh;
+
+	return otx2_sync_mbox_msg(&ptp->nic->mbox);
+}
+
 static u64 ptp_cc_read(const struct cyclecounter *cc)
 {
 	struct otx2_ptp *ptp = container_of(cc, struct otx2_ptp, cycle_counter);
@@ -55,6 +72,33 @@ static u64 ptp_cc_read(const struct cyclecounter *cc)
 	return rsp->clk;
 }
 
+static u64 ptp_tstmp_read(struct otx2_ptp *ptp)
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
+	req->op = PTP_OP_GET_TSTMP;
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
 static int otx2_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
 {
 	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
@@ -102,9 +146,73 @@ static int otx2_ptp_settime(struct ptp_clock_info *ptp_info,
 	return 0;
 }
 
+static int otx2_ptp_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
+			       enum ptp_pin_function func, unsigned int chan)
+{
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_EXTTS:
+		break;
+	case PTP_PF_PEROUT:
+	case PTP_PF_PHYSYNC:
+		return -1;
+	}
+	return 0;
+}
+
+static void otx2_ptp_extts_check(struct work_struct *work)
+{
+	struct otx2_ptp *ptp = container_of(work, struct otx2_ptp,
+					    extts_work.work);
+	struct ptp_clock_event event;
+	u64 tstmp, new_thresh;
+
+	mutex_lock(&ptp->nic->mbox.lock);
+	tstmp = ptp_tstmp_read(ptp);
+	mutex_unlock(&ptp->nic->mbox.lock);
+
+	if (tstmp != ptp->last_extts) {
+		event.type = PTP_CLOCK_EXTTS;
+		event.index = 0;
+		event.timestamp = timecounter_cyc2time(&ptp->time_counter, tstmp);
+		ptp_clock_event(ptp->ptp_clock, &event);
+		ptp->last_extts = tstmp;
+
+		new_thresh = tstmp % 500000000;
+		if (ptp->thresh != new_thresh) {
+			mutex_lock(&ptp->nic->mbox.lock);
+			ptp_set_thresh(ptp, new_thresh);
+			mutex_unlock(&ptp->nic->mbox.lock);
+			ptp->thresh = new_thresh;
+		}
+	}
+	schedule_delayed_work(&ptp->extts_work, msecs_to_jiffies(200));
+}
+
 static int otx2_ptp_enable(struct ptp_clock_info *ptp_info,
 			   struct ptp_clock_request *rq, int on)
 {
+	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
+					    ptp_info);
+	int pin = -1;
+
+	if (!ptp->nic)
+		return -ENODEV;
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_EXTTS:
+		pin = ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS,
+				   rq->extts.index);
+		if (pin < 0)
+			return -EBUSY;
+		if (on)
+			schedule_delayed_work(&ptp->extts_work, msecs_to_jiffies(200));
+		else
+			cancel_delayed_work_sync(&ptp->extts_work);
+		return 0;
+	default:
+		break;
+	}
 	return -EOPNOTSUPP;
 }
 
@@ -149,20 +257,28 @@ int otx2_ptp_init(struct otx2_nic *pfvf)
 	timecounter_init(&ptp_ptr->time_counter, &ptp_ptr->cycle_counter,
 			 ktime_to_ns(ktime_get_real()));
 
+	snprintf(ptp_ptr->extts_config.name, sizeof(ptp_ptr->extts_config.name), "TSTAMP");
+	ptp_ptr->extts_config.index = 0;
+	ptp_ptr->extts_config.func = PTP_PF_NONE;
+
 	ptp_ptr->ptp_info = (struct ptp_clock_info) {
 		.owner          = THIS_MODULE,
 		.name           = "OcteonTX2 PTP",
 		.max_adj        = 1000000000ull,
-		.n_ext_ts       = 0,
-		.n_pins         = 0,
+		.n_ext_ts       = 1,
+		.n_pins         = 1,
 		.pps            = 0,
+		.pin_config     = &ptp_ptr->extts_config,
 		.adjfine        = otx2_ptp_adjfine,
 		.adjtime        = otx2_ptp_adjtime,
 		.gettime64      = otx2_ptp_gettime,
 		.settime64      = otx2_ptp_settime,
 		.enable         = otx2_ptp_enable,
+		.verify         = otx2_ptp_verify_pin,
 	};
 
+	INIT_DELAYED_WORK(&ptp_ptr->extts_work, otx2_ptp_extts_check);
+
 	ptp_ptr->ptp_clock = ptp_clock_register(&ptp_ptr->ptp_info, pfvf->dev);
 	if (IS_ERR_OR_NULL(ptp_ptr->ptp_clock)) {
 		err = ptp_ptr->ptp_clock ?
-- 
2.17.1


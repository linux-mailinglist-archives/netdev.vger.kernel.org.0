Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8D44BA89D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244594AbiBQSoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:44:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244619AbiBQSoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:44:12 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A933B030;
        Thu, 17 Feb 2022 10:43:54 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21HGH43j014913;
        Thu, 17 Feb 2022 10:43:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=jEc+Xgh/pv009ONqoZO13Cf6KkRQGdrEOXdOnrn/VHI=;
 b=VsNd2XF4s14a0Y/FCRFQQzchblCVDwuWPbtokk7HV0fkOUf+gX38yNmL1skJZer4Jem3
 Fa2DZFpkj/Vw5Rm6+2DQjQhxwfUUhpbj/ZzJa+c25yQnLFtQQ24YWXU8SSAjp6CnINUU
 5OJVVsxWTMMO+3222yZcetyew8ZEC80Ss1EiLfVD8IoYrOON1Pk4qYji0kTJDfx6ggVb
 b/3lApIi4uHyeapeF+V6mfkInaICOiAM4hRXHcPgjLS1VmD7fOBxRgHFdQm/y3rB5yBG
 dbD5aGKmJnn0B/o49Z6Bg7ZOXutmc0/pn4/j6j+5oiZG1fAWZYJ+Xgug98AzmWo2CUee ZA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3e9sqrgqtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 10:43:52 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Feb
 2022 10:08:10 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 17 Feb 2022 10:08:08 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id F260B3F7108;
        Thu, 17 Feb 2022 10:05:05 -0800 (PST)
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Naveen Mamindlapalli <naveenm@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>
Subject: [net-next PATCH 2/3] octeontx2-pf: cn10k: add support for new ptp timestamp format
Date:   Thu, 17 Feb 2022 23:34:49 +0530
Message-ID: <20220217180450.21721-3-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220217180450.21721-1-rsaladi2@marvell.com>
References: <20220217180450.21721-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: PNsgHLgimsjzyrzes_dMT_KTwd3jDC-u
X-Proofpoint-GUID: PNsgHLgimsjzyrzes_dMT_KTwd3jDC-u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_07,2022-02-17_01,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Naveen Mamindlapalli <naveenm@marvell.com>

The cn10k hardware ptp timestamp format has been modified primarily
to support 1-step ptp clock. The 64-bit timestamp used by hardware is
split into two 32-bit fields, the upper one holds seconds, the lower
one nanoseconds. A new register (PTP_CLOCK_SEC) has been added that
returns the current seconds value. The nanoseconds register PTP_CLOCK_HI
resets after every second. The cn10k RPM block provides Rx/Tx timestamps
to the NIX block using the new timestamp format. The software can read
the current timestamp in nanoseconds by reading both PTP_CLOCK_SEC &
PTP_CLOCK_HI registers.

This patch provides support for new timestamp format.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu Saladi <rsaladi2@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/ptp.c   | 44 ++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/ptp.h   |  2 +
 .../marvell/octeontx2/nic/otx2_common.h       |  3 ++
 .../ethernet/marvell/octeontx2/nic/otx2_ptp.c |  8 ++++
 .../ethernet/marvell/octeontx2/nic/otx2_ptp.h | 15 +++++++
 .../marvell/octeontx2/nic/otx2_txrx.c         |  6 ++-
 6 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index 211c375446f4..6f5e1a5d957f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -25,6 +25,9 @@
 #define PCI_SUBSYS_DEVID_OCTX2_95XXO_PTP	0xB600
 #define PCI_DEVID_OCTEONTX2_RST			0xA085
 #define PCI_DEVID_CN10K_PTP			0xA09E
+#define PCI_SUBSYS_DEVID_CN10K_A_PTP		0xB900
+#define PCI_SUBSYS_DEVID_CNF10K_A_PTP		0xBA00
+#define PCI_SUBSYS_DEVID_CNF10K_B_PTP		0xBC00
 
 #define PCI_PTP_BAR_NO				0
 
@@ -46,10 +49,43 @@
 #define PTP_CLOCK_HI				0xF10ULL
 #define PTP_CLOCK_COMP				0xF18ULL
 #define PTP_TIMESTAMP				0xF20ULL
+#define PTP_CLOCK_SEC				0xFD0ULL
 
 static struct ptp *first_ptp_block;
 static const struct pci_device_id ptp_id_table[];
 
+static bool is_ptp_tsfmt_sec_nsec(struct ptp *ptp)
+{
+	if (ptp->pdev->subsystem_device == PCI_SUBSYS_DEVID_CN10K_A_PTP ||
+	    ptp->pdev->subsystem_device == PCI_SUBSYS_DEVID_CNF10K_A_PTP)
+		return true;
+	return false;
+}
+
+static u64 read_ptp_tstmp_sec_nsec(struct ptp *ptp)
+{
+	u64 sec, sec1, nsec;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ptp->ptp_lock, flags);
+	sec = readq(ptp->reg_base + PTP_CLOCK_SEC) & 0xFFFFFFFFUL;
+	nsec = readq(ptp->reg_base + PTP_CLOCK_HI);
+	sec1 = readq(ptp->reg_base + PTP_CLOCK_SEC) & 0xFFFFFFFFUL;
+	/* check nsec rollover */
+	if (sec1 > sec) {
+		nsec = readq(ptp->reg_base + PTP_CLOCK_HI);
+		sec = sec1;
+	}
+	spin_unlock_irqrestore(&ptp->ptp_lock, flags);
+
+	return sec * NSEC_PER_SEC + nsec;
+}
+
+static u64 read_ptp_tstmp_nsec(struct ptp *ptp)
+{
+	return readq(ptp->reg_base + PTP_CLOCK_HI);
+}
+
 struct ptp *ptp_get(void)
 {
 	struct ptp *ptp = first_ptp_block;
@@ -132,7 +168,7 @@ static int ptp_get_clock(struct ptp *ptp, bool is_pmu, u64 *clk, u64 *tsc)
 	do {
 		start = get_tsc(0);
 		*tsc = get_tsc(is_pmu);
-		*clk = readq(ptp->reg_base + PTP_CLOCK_HI);
+		*clk = ptp->read_ptp_tstmp(ptp);
 		end = get_tsc(0);
 		retries++;
 	} while (((end - start) > 50) && retries < 5);
@@ -232,6 +268,12 @@ static int ptp_probe(struct pci_dev *pdev,
 	if (!first_ptp_block)
 		first_ptp_block = ptp;
 
+	spin_lock_init(&ptp->ptp_lock);
+	if (is_ptp_tsfmt_sec_nsec(ptp))
+		ptp->read_ptp_tstmp = &read_ptp_tstmp_sec_nsec;
+	else
+		ptp->read_ptp_tstmp = &read_ptp_tstmp_nsec;
+
 	return 0;
 
 error_free:
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.h b/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
index 1b81a0493cd3..95a955159f40 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
@@ -15,6 +15,8 @@
 struct ptp {
 	struct pci_dev *pdev;
 	void __iomem *reg_base;
+	u64 (*read_ptp_tstmp)(struct ptp *ptp);
+	spinlock_t ptp_lock; /* lock */
 	u32 clock_rate;
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 7724f17ec31f..65e31a2210d9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -17,6 +17,7 @@
 #include <linux/soc/marvell/octeontx2/asm.h>
 #include <net/pkt_cls.h>
 #include <net/devlink.h>
+#include <linux/time64.h>
 
 #include <mbox.h>
 #include <npc.h>
@@ -275,6 +276,8 @@ struct otx2_ptp {
 	u64 thresh;
 
 	struct ptp_pin_desc extts_config;
+	u64 (*convert_rx_ptp_tstmp)(u64 timestamp);
+	u64 (*convert_tx_ptp_tstmp)(u64 timestamp);
 };
 
 #define OTX2_HW_TIMESTAMP_LEN	8
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
index 61c20907315f..fdc2c9315b91 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
@@ -294,6 +294,14 @@ int otx2_ptp_init(struct otx2_nic *pfvf)
 		goto error;
 	}
 
+	if (is_dev_otx2(pfvf->pdev)) {
+		ptp_ptr->convert_rx_ptp_tstmp = &otx2_ptp_convert_rx_timestamp;
+		ptp_ptr->convert_tx_ptp_tstmp = &otx2_ptp_convert_tx_timestamp;
+	} else {
+		ptp_ptr->convert_rx_ptp_tstmp = &cn10k_ptp_convert_timestamp;
+		ptp_ptr->convert_tx_ptp_tstmp = &cn10k_ptp_convert_timestamp;
+	}
+
 	pfvf->ptp = ptp_ptr;
 
 error:
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h
index 6ff284211d7b..7ff41927ceaf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h
@@ -8,6 +8,21 @@
 #ifndef OTX2_PTP_H
 #define OTX2_PTP_H
 
+static inline u64 otx2_ptp_convert_rx_timestamp(u64 timestamp)
+{
+	return be64_to_cpu(*(__be64 *)&timestamp);
+}
+
+static inline u64 otx2_ptp_convert_tx_timestamp(u64 timestamp)
+{
+	return timestamp;
+}
+
+static inline u64 cn10k_ptp_convert_timestamp(u64 timestamp)
+{
+	return ((timestamp >> 32) * NSEC_PER_SEC) + (timestamp & 0xFFFFFFFFUL);
+}
+
 int otx2_ptp_init(struct otx2_nic *pfvf);
 void otx2_ptp_destroy(struct otx2_nic *pfvf);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 7c4068c5d1ac..c26de15b2ac3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -148,6 +148,7 @@ static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
 	if (skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) {
 		timestamp = ((u64 *)sq->timestamps->base)[snd_comp->sqe_id];
 		if (timestamp != 1) {
+			timestamp = pfvf->ptp->convert_tx_ptp_tstmp(timestamp);
 			err = otx2_ptp_tstamp2time(pfvf, timestamp, &tsns);
 			if (!err) {
 				memset(&ts, 0, sizeof(ts));
@@ -167,14 +168,15 @@ static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
 static void otx2_set_rxtstamp(struct otx2_nic *pfvf,
 			      struct sk_buff *skb, void *data)
 {
-	u64 tsns;
+	u64 timestamp, tsns;
 	int err;
 
 	if (!(pfvf->flags & OTX2_FLAG_RX_TSTAMP_ENABLED))
 		return;
 
+	timestamp = pfvf->ptp->convert_rx_ptp_tstmp(*(u64 *)data);
 	/* The first 8 bytes is the timestamp */
-	err = otx2_ptp_tstamp2time(pfvf, be64_to_cpu(*(__be64 *)data), &tsns);
+	err = otx2_ptp_tstamp2time(pfvf, timestamp, &tsns);
 	if (err)
 		return;
 
-- 
2.17.1


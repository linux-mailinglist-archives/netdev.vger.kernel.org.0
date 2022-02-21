Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492534BD6FD
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 08:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345987AbiBUHVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 02:21:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345973AbiBUHVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 02:21:18 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47B1DA9;
        Sun, 20 Feb 2022 23:20:55 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21KMnbFP030539;
        Sun, 20 Feb 2022 23:20:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=8kOwvDTl45DgZnzS4zO0qxmfSeJRd8nohhKRQkC6CgU=;
 b=PXsB/xybIE8ciW/TcLiDMFE66WQrDoazznpnBfwuKRSLhPGx6cMGWRtYDisEFIajTSDm
 /Aqn5JH8xOXWLX+DJgsSaPkhMx6EIeBzNZEbciqs8gL1jTJVD7Ak6gEaPqCrEIiVMBr/
 LyWzC40U6CSY8Csnxnt6Zc5s4XnYAWmjZwpdA2uwfPFOaj5RwWIEJhgR1S3Ex6Gy8NE9
 VrLpr25F7ysIoudrKL+AHPJgzfMinmEFVT9yVO5N4rPtpFvY0eu9USyay8uMXta3C0BV
 H/m1TKl1OoW0HTUg7l0XMEDc9hItraDz3Iq4LzS6GAGjuxE15QnzQDlBWkr2EOX3Upqy bA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ebpvntcwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 20 Feb 2022 23:20:52 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 20 Feb
 2022 23:20:50 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 20 Feb 2022 23:21:12 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 6E4D765E8FA;
        Sun, 20 Feb 2022 22:45:19 -0800 (PST)
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <rsaladi2@marvell.com>, Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH v2 2/2] octeontx2-af: cn10k: add workaround for ptp errata
Date:   Mon, 21 Feb 2022 12:15:08 +0530
Message-ID: <20220221064508.19148-3-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220221064508.19148-1-rsaladi2@marvell.com>
References: <20220221064508.19148-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: YfbHU52-3iaLSbp4Ih57xkLpcT-WeoGJ
X-Proofpoint-GUID: YfbHU52-3iaLSbp4Ih57xkLpcT-WeoGJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_02,2022-02-18_01,2021-12-02_01
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

This patch adds workaround for PTP errata given below.

1. At the time of 1 sec rollover of nano-second counter,
   the nano-second counter is set to 0. However, it should
   be set to (existing counter_value - 10^9). This leads to
   an accumulating error in the timestamp value with each sec
   rollover.
2. Additionally, the nano-second counter currently is rolling
   over at 'h3B9A_C9FF. It should roll over at 'h3B9A_CA00.

The workaround for issue #1 is to speed up the ptp clock by
adjusting PTP_CLOCK_COMP register to the desired value to
compensate for the nanoseconds lost per each second.

The workaround for issue #2 is to slow down the ptp clock
such that the rollover occurs at ~1sec.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu Saladi <rsaladi2@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/ptp.c   | 87 +++++++++++++++++--
 1 file changed, 80 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index 5b8906fd45c3..67a6821d2dff 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -51,9 +51,19 @@
 #define PTP_TIMESTAMP				0xF20ULL
 #define PTP_CLOCK_SEC				0xFD0ULL
 
+#define CYCLE_MULT				1000
+
 static struct ptp *first_ptp_block;
 static const struct pci_device_id ptp_id_table[];
 
+static bool cn10k_ptp_errata(struct ptp *ptp)
+{
+	if (ptp->pdev->subsystem_device == PCI_SUBSYS_DEVID_CN10K_A_PTP ||
+	    ptp->pdev->subsystem_device == PCI_SUBSYS_DEVID_CNF10K_A_PTP)
+		return true;
+	return false;
+}
+
 static bool is_ptp_tsfmt_sec_nsec(struct ptp *ptp)
 {
 	if (ptp->pdev->subsystem_device == PCI_SUBSYS_DEVID_CN10K_A_PTP ||
@@ -86,6 +96,58 @@ static u64 read_ptp_tstmp_nsec(struct ptp *ptp)
 	return readq(ptp->reg_base + PTP_CLOCK_HI);
 }
 
+static u64 ptp_calc_adjusted_comp(u64 ptp_clock_freq)
+{
+	u64 comp, adj = 0, cycles_per_sec, ns_drift = 0;
+	u32 ptp_clock_nsec, cycle_time;
+	int cycle;
+
+	/* Errata:
+	 * Issue #1: At the time of 1 sec rollover of the nano-second counter,
+	 * the nano-second counter is set to 0. However, it should be set to
+	 * (existing counter_value - 10^9).
+	 *
+	 * Issue #2: The nano-second counter rolls over at 0x3B9A_C9FF.
+	 * It should roll over at 0x3B9A_CA00.
+	 */
+
+	/* calculate ptp_clock_comp value */
+	comp = ((u64)1000000000ULL << 32) / ptp_clock_freq;
+	/* use CYCLE_MULT to avoid accuracy loss due to integer arithmetic */
+	cycle_time = NSEC_PER_SEC * CYCLE_MULT / ptp_clock_freq;
+	/* cycles per sec */
+	cycles_per_sec = ptp_clock_freq;
+
+	/* check whether ptp nanosecond counter rolls over early */
+	cycle = cycles_per_sec - 1;
+	ptp_clock_nsec = (cycle * comp) >> 32;
+	while (ptp_clock_nsec < NSEC_PER_SEC) {
+		if (ptp_clock_nsec == 0x3B9AC9FF)
+			goto calc_adj_comp;
+		cycle++;
+		ptp_clock_nsec = (cycle * comp) >> 32;
+	}
+	/* compute nanoseconds lost per second when nsec counter rolls over */
+	ns_drift = ptp_clock_nsec - NSEC_PER_SEC;
+	/* calculate ptp_clock_comp adjustment */
+	if (ns_drift > 0) {
+		adj = comp * ns_drift;
+		adj = adj / 1000000000ULL;
+	}
+	/* speed up the ptp clock to account for nanoseconds lost */
+	comp += adj;
+	return comp;
+
+calc_adj_comp:
+	/* slow down the ptp clock to not rollover early */
+	adj = comp * cycle_time;
+	adj = adj / 1000000000ULL;
+	adj = adj / CYCLE_MULT;
+	comp -= adj;
+
+	return comp;
+}
+
 struct ptp *ptp_get(void)
 {
 	struct ptp *ptp = first_ptp_block;
@@ -113,8 +175,8 @@ void ptp_put(struct ptp *ptp)
 static int ptp_adjfine(struct ptp *ptp, long scaled_ppm)
 {
 	bool neg_adj = false;
-	u64 comp;
-	u64 adj;
+	u32 freq, freq_adj;
+	u64 comp, adj;
 	s64 ppb;
 
 	if (scaled_ppm < 0) {
@@ -136,15 +198,22 @@ static int ptp_adjfine(struct ptp *ptp, long scaled_ppm)
 	 * where tbase is the basic compensation value calculated
 	 * initialy in the probe function.
 	 */
-	comp = ((u64)1000000000ull << 32) / ptp->clock_rate;
 	/* convert scaled_ppm to ppb */
 	ppb = 1 + scaled_ppm;
 	ppb *= 125;
 	ppb >>= 13;
-	adj = comp * ppb;
-	adj = div_u64(adj, 1000000000ull);
-	comp = neg_adj ? comp - adj : comp + adj;
 
+	if (cn10k_ptp_errata(ptp)) {
+		/* calculate the new frequency based on ppb */
+		freq_adj = (ptp->clock_rate * ppb) / 1000000000ULL;
+		freq = neg_adj ? ptp->clock_rate + freq_adj : ptp->clock_rate - freq_adj;
+		comp = ptp_calc_adjusted_comp(freq);
+	} else {
+		comp = ((u64)1000000000ull << 32) / ptp->clock_rate;
+		adj = comp * ppb;
+		adj = div_u64(adj, 1000000000ull);
+		comp = neg_adj ? comp - adj : comp + adj;
+	}
 	writeq(comp, ptp->reg_base + PTP_CLOCK_COMP);
 
 	return 0;
@@ -202,7 +271,11 @@ void ptp_start(struct ptp *ptp, u64 sclk, u32 ext_clk_freq, u32 extts)
 	writeq(0x1dcd650000000000, ptp->reg_base + PTP_PPS_HI_INCR);
 	writeq(0x1dcd650000000000, ptp->reg_base + PTP_PPS_LO_INCR);
 
-	clock_comp = ((u64)1000000000ull << 32) / ptp->clock_rate;
+	if (cn10k_ptp_errata(ptp))
+		clock_comp = ptp_calc_adjusted_comp(ptp->clock_rate);
+	else
+		clock_comp = ((u64)1000000000ull << 32) / ptp->clock_rate;
+
 	/* Initial compensation value to start the nanosecs counter */
 	writeq(clock_comp, ptp->reg_base + PTP_CLOCK_COMP);
 }
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D50B6B0BB8
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjCHOqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbjCHOoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:44:46 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E705AB7C
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 06:43:23 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3288MYRI003608;
        Wed, 8 Mar 2023 06:42:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=dE2fYQ7o6xTrMESvnWy9rd7ugEPx9g+tSoBG7FgA9+0=;
 b=TYl9ggXQFVEhq2slQLfMZF8O40HHCb7ymQrFgA5GmsP3I2CkS6fPrd+OQCrH0IiXd/py
 VXuKYgBV3oyD85EbC9iZB+XEs0qv/VKQumkjita0L7NMCkKqfueWs45Khua5jPB1kNHN
 M2oLkt7q4aT/o9MuTgaxOwC7WAievvl+X9h+FoRNrEPqPbsQ2Nom2tqjR8p29gUq3HAP
 tcMA4Jh3LYxDZ2utrX6svisXMLBcAkdo07kuzPno3cLrtjPisYUKo1ioLAY6rHUNhBsw
 CwXwqdvWuKzW/WhxqpmrQmTfmk2K2DGdnwMUa40HwizK03jrGhV4zFhWWt0HZ+w+dDn2 CQ== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3p6ffbc4gr-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Mar 2023 06:42:31 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server id
 15.1.2507.17; Wed, 8 Mar 2023 06:42:29 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
CC:     Vadim Fedorenko <vadfed@meta.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        <netdev@vger.kernel.org>
Subject: [PATCH net v2] bnxt_en: reset PHC frequency in free-running mode
Date:   Wed, 8 Mar 2023 06:42:09 -0800
Message-ID: <20230308144209.150456-1-vadfed@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::d]
X-Proofpoint-GUID: HYn_-elHqFp62oaKEMnzU0et-N5lUGfD
X-Proofpoint-ORIG-GUID: HYn_-elHqFp62oaKEMnzU0et-N5lUGfD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_08,2023-03-08_03,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using a PHC in shared between multiple hosts, the previous
frequency value may not be reset and could lead to host being unable to
compensate the offset with timecounter adjustments. To avoid such state
reset the hardware frequency of PHC to base frequency on init. Some
refactoring is needed to make code readable.

Fixes: 85036aee1938 ("bnxt_en: Add a non-real time mode to access NIC clock")
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 57 +++++++++++--------
 3 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5d4b1f2ebeac..8472ff79adf3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6989,11 +6989,9 @@ static int bnxt_hwrm_func_qcfg(struct bnxt *bp)
 		if (flags & FUNC_QCFG_RESP_FLAGS_FW_DCBX_AGENT_ENABLED)
 			bp->fw_cap |= BNXT_FW_CAP_DCBX_AGENT;
 	}
-	if (BNXT_PF(bp) && (flags & FUNC_QCFG_RESP_FLAGS_MULTI_HOST)) {
+	if (BNXT_PF(bp) && (flags & FUNC_QCFG_RESP_FLAGS_MULTI_HOST))
 		bp->flags |= BNXT_FLAG_MULTI_HOST;
-		if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
-			bp->fw_cap &= ~BNXT_FW_CAP_PTP_RTC;
-	}
+
 	if (flags & FUNC_QCFG_RESP_FLAGS_RING_MONITOR_ENABLED)
 		bp->fw_cap |= BNXT_FW_CAP_RING_MONITOR;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index dcb09fbe4007..c0628ac1b798 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2000,6 +2000,8 @@ struct bnxt {
 	u32			fw_dbg_cap;
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
+#define BNXT_PTP_USE_RTC(bp)	(!BNXT_MH(bp) && \
+				 ((bp)->fw_cap & BNXT_FW_CAP_PTP_RTC))
 	u32			hwrm_spec_code;
 	u16			hwrm_cmd_seq;
 	u16                     hwrm_cmd_kong_seq;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 4ec8bba18cdd..4ee8581b5fea 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -63,7 +63,7 @@ static int bnxt_ptp_settime(struct ptp_clock_info *ptp_info,
 						ptp_info);
 	u64 ns = timespec64_to_ns(ts);
 
-	if (ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
+	if (BNXT_PTP_USE_RTC(ptp->bp))
 		return bnxt_ptp_cfg_settime(ptp->bp, ns);
 
 	spin_lock_bh(&ptp->ptp_lock);
@@ -196,7 +196,7 @@ static int bnxt_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
 	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
 						ptp_info);
 
-	if (ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
+	if (BNXT_PTP_USE_RTC(ptp->bp))
 		return bnxt_ptp_adjphc(ptp, delta);
 
 	spin_lock_bh(&ptp->ptp_lock);
@@ -205,34 +205,39 @@ static int bnxt_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
 	return 0;
 }
 
+static int bnxt_ptp_adjfine_rtc(struct bnxt *bp, long scaled_ppm)
+{
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
+	struct hwrm_port_mac_cfg_input *req;
+	int rc;
+
+	rc = hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
+	if (rc)
+		return rc;
+
+	req->ptp_freq_adj_ppb = cpu_to_le32(ppb);
+	req->enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_PTP_FREQ_ADJ_PPB);
+	rc = hwrm_req_send(bp, req);
+	if (rc)
+		netdev_err(bp->dev,
+			   "ptp adjfine failed. rc = %d\n", rc);
+	return rc;
+}
+
 static int bnxt_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
 {
 	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
 						ptp_info);
-	struct hwrm_port_mac_cfg_input *req;
 	struct bnxt *bp = ptp->bp;
-	int rc = 0;
 
-	if (!(ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)) {
-		spin_lock_bh(&ptp->ptp_lock);
-		timecounter_read(&ptp->tc);
-		ptp->cc.mult = adjust_by_scaled_ppm(ptp->cmult, scaled_ppm);
-		spin_unlock_bh(&ptp->ptp_lock);
-	} else {
-		s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
-
-		rc = hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
-		if (rc)
-			return rc;
+	if (BNXT_PTP_USE_RTC(ptp->bp))
+		return bnxt_ptp_adjfine_rtc(bp, scaled_ppm);
 
-		req->ptp_freq_adj_ppb = cpu_to_le32(ppb);
-		req->enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_PTP_FREQ_ADJ_PPB);
-		rc = hwrm_req_send(ptp->bp, req);
-		if (rc)
-			netdev_err(ptp->bp->dev,
-				   "ptp adjfine failed. rc = %d\n", rc);
-	}
-	return rc;
+	spin_lock_bh(&ptp->ptp_lock);
+	timecounter_read(&ptp->tc);
+	ptp->cc.mult = adjust_by_scaled_ppm(ptp->cmult, scaled_ppm);
+	spin_unlock_bh(&ptp->ptp_lock);
+	return 0;
 }
 
 void bnxt_ptp_pps_event(struct bnxt *bp, u32 data1, u32 data2)
@@ -879,7 +884,7 @@ int bnxt_ptp_init_rtc(struct bnxt *bp, bool phc_cfg)
 	u64 ns;
 	int rc;
 
-	if (!bp->ptp_cfg || !(bp->fw_cap & BNXT_FW_CAP_PTP_RTC))
+	if (!bp->ptp_cfg || !BNXT_PTP_USE_RTC(bp))
 		return -ENODEV;
 
 	if (!phc_cfg) {
@@ -932,13 +937,15 @@ int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
 	atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
 	spin_lock_init(&ptp->ptp_lock);
 
-	if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
+	if (BNXT_PTP_USE_RTC(ptp->bp)) {
 		bnxt_ptp_timecounter_init(bp, false);
 		rc = bnxt_ptp_init_rtc(bp, phc_cfg);
 		if (rc)
 			goto out;
 	} else {
 		bnxt_ptp_timecounter_init(bp, true);
+		if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
+			bnxt_ptp_adjfine_rtc(bp, 0);
 	}
 
 	ptp->ptp_info = bnxt_ptp_caps;
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA83537D6D
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbiE3Njg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236834AbiE3Ngi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:36:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17AD98599;
        Mon, 30 May 2022 06:30:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8880660F19;
        Mon, 30 May 2022 13:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F94C3411E;
        Mon, 30 May 2022 13:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917398;
        bh=czw9kRjZG40hr+kia3G/03BugvUAA5H+FXWgSqt3PEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFTZq925QikfXb8Y3HRKPdipCEc1eo06RyhmFDZ1agjQW4vUwsF8k5tV6rY2c/yIj
         Lne6IDVqTW8MeBQayE6twDxUcCGXH8IfLblDCzvnUs43RKQLxi5QT0DDhornoSHxx9
         I1Uk5g8Q7sSZeFEZVOpFr2368c//RZobRbrugE1Kuqyk0ys4K4y7CYSmwNtI7NTXj+
         +Ysk5PgmDqK5R8kHWhPhNn2ZDOEYL49ycNmbBRxjFLzHURXIgm6xG0yTChzU3M9ViQ
         TVTjkYoWwI8VlJ26xdcG29EZ5/MdvNjmwR8wxdK/CzdMXq6t/eyT5eBbnuabJ4h0NJ
         Wi+UQNtVoiedA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 122/159] bnxt_en: Configure ptp filters during bnxt open
Date:   Mon, 30 May 2022 09:23:47 -0400
Message-Id: <20220530132425.1929512-122-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 11862689e8f117e4702f55000790d7bce6859e84 ]

For correctness, we need to configure the packet filters for timestamping
during bnxt_open.  This way they are always configured after firmware
reset or chip reset.  We should not assume that the filters will always
be retained across resets.

This patch modifies the ioctl handler and always configures the PTP
filters in the bnxt_open() path.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 56 ++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  2 +
 3 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1d69fe0737a1..d5149478a351 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10363,6 +10363,7 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	if (BNXT_PF(bp))
 		bnxt_vf_reps_open(bp);
 	bnxt_ptp_init_rtc(bp, true);
+	bnxt_ptp_cfg_tstamp_filters(bp);
 	return 0;
 
 open_err_irq:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 00f2f80c0073..f9c94e5fe718 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -295,6 +295,27 @@ static int bnxt_ptp_cfg_event(struct bnxt *bp, u8 event)
 	return hwrm_req_send(bp, req);
 }
 
+void bnxt_ptp_cfg_tstamp_filters(struct bnxt *bp)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	struct hwrm_port_mac_cfg_input *req;
+
+	if (!ptp || !ptp->tstamp_filters)
+		return;
+
+	if (hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG))
+		goto out;
+	req->flags = cpu_to_le32(ptp->tstamp_filters);
+	req->enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_RX_TS_CAPTURE_PTP_MSG_TYPE);
+	req->rx_ts_capture_ptp_msg_type = cpu_to_le16(ptp->rxctl);
+
+	if (!hwrm_req_send(bp, req))
+		return;
+	ptp->tstamp_filters = 0;
+out:
+	netdev_warn(bp->dev, "Failed to configure HW packet timestamp filters\n");
+}
+
 void bnxt_ptp_reapply_pps(struct bnxt *bp)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
@@ -435,27 +456,36 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp_info,
 static int bnxt_hwrm_ptp_cfg(struct bnxt *bp)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
-	struct hwrm_port_mac_cfg_input *req;
 	u32 flags = 0;
-	int rc;
+	int rc = 0;
 
-	rc = hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
-	if (rc)
-		return rc;
+	switch (ptp->rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		flags = PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_DISABLE;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		flags = PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_ENABLE;
+		break;
+	}
 
-	if (ptp->rx_filter)
-		flags |= PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_ENABLE;
-	else
-		flags |= PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_DISABLE;
 	if (ptp->tx_tstamp_en)
 		flags |= PORT_MAC_CFG_REQ_FLAGS_PTP_TX_TS_CAPTURE_ENABLE;
 	else
 		flags |= PORT_MAC_CFG_REQ_FLAGS_PTP_TX_TS_CAPTURE_DISABLE;
-	req->flags = cpu_to_le32(flags);
-	req->enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_RX_TS_CAPTURE_PTP_MSG_TYPE);
-	req->rx_ts_capture_ptp_msg_type = cpu_to_le16(ptp->rxctl);
 
-	return hwrm_req_send(bp, req);
+	ptp->tstamp_filters = flags;
+
+	if (netif_running(bp->dev)) {
+		rc = bnxt_close_nic(bp, false, false);
+		if (!rc)
+			rc = bnxt_open_nic(bp, false, false);
+		if (!rc && !ptp->tstamp_filters)
+			rc = -EIO;
+	}
+
+	return rc;
 }
 
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 530b9922608c..4ce0a14c1e23 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -113,6 +113,7 @@ struct bnxt_ptp_cfg {
 					 BNXT_PTP_MSG_PDELAY_RESP)
 	u8			tx_tstamp_en:1;
 	int			rx_filter;
+	u32			tstamp_filters;
 
 	u32			refclk_regs[2];
 	u32			refclk_mapped_regs[2];
@@ -133,6 +134,7 @@ do {						\
 int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id, u16 *hdr_off);
 void bnxt_ptp_update_current_time(struct bnxt *bp);
 void bnxt_ptp_pps_event(struct bnxt *bp, u32 data1, u32 data2);
+void bnxt_ptp_cfg_tstamp_filters(struct bnxt *bp);
 void bnxt_ptp_reapply_pps(struct bnxt *bp);
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
-- 
2.35.1


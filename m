Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8924811CA44
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 11:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbfLLKJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 05:09:04 -0500
Received: from inva021.nxp.com ([92.121.34.21]:44490 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbfLLKJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 05:09:02 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4B07F2006B5;
        Thu, 12 Dec 2019 11:08:59 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1CE3020068A;
        Thu, 12 Dec 2019 11:08:57 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 05C1840307;
        Thu, 12 Dec 2019 18:08:51 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 3/3] dpaa2-ptp: add external trigger event support
Date:   Thu, 12 Dec 2019 18:08:06 +0800
Message-Id: <20191212100806.17447-4-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212100806.17447-1-yangbo.lu@nxp.com>
References: <20191212100806.17447-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add external trigger event support
for dpaa2-ptp driver with v2 dprtc_set_irq_mask() API.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c | 20 ++++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h |  4 +++-
 drivers/net/ethernet/freescale/dpaa2/dprtc.h     |  2 ++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
index a9503ae..a0061e9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
@@ -27,6 +27,20 @@ static int dpaa2_ptp_enable(struct ptp_clock_info *ptp,
 	mc_dev = to_fsl_mc_device(dev);
 
 	switch (rq->type) {
+	case PTP_CLK_REQ_EXTTS:
+		switch (rq->extts.index) {
+		case 0:
+			bit = DPRTC_EVENT_ETS1;
+			break;
+		case 1:
+			bit = DPRTC_EVENT_ETS2;
+			break;
+		default:
+			return -EINVAL;
+		}
+		if (on)
+			extts_clean_up(ptp_qoriq, rq->extts.index, false);
+		break;
 	case PTP_CLK_REQ_PPS:
 		bit = DPRTC_EVENT_PPS;
 		break;
@@ -96,6 +110,12 @@ static irqreturn_t dpaa2_ptp_irq_handler_thread(int irq, void *priv)
 		ptp_clock_event(ptp_qoriq->clock, &event);
 	}
 
+	if (status & DPRTC_EVENT_ETS1)
+		extts_clean_up(ptp_qoriq, 0, true);
+
+	if (status & DPRTC_EVENT_ETS2)
+		extts_clean_up(ptp_qoriq, 1, true);
+
 	err = dprtc_clear_irq_status(mc_dev->mc_io, 0, mc_dev->mc_handle,
 				     DPRTC_IRQ_INDEX, status);
 	if (unlikely(err)) {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h
index 4ac05bf..96ffeb9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h
@@ -9,9 +9,11 @@
 
 /* Command versioning */
 #define DPRTC_CMD_BASE_VERSION		1
+#define DPRTC_CMD_VERSION_2		2
 #define DPRTC_CMD_ID_OFFSET		4
 
 #define DPRTC_CMD(id)	(((id) << DPRTC_CMD_ID_OFFSET) | DPRTC_CMD_BASE_VERSION)
+#define DPRTC_CMD_V2(id) (((id) << DPRTC_CMD_ID_OFFSET) | DPRTC_CMD_VERSION_2)
 
 /* Command IDs */
 #define DPRTC_CMDID_CLOSE			DPRTC_CMD(0x800)
@@ -19,7 +21,7 @@
 
 #define DPRTC_CMDID_SET_IRQ_ENABLE		DPRTC_CMD(0x012)
 #define DPRTC_CMDID_GET_IRQ_ENABLE		DPRTC_CMD(0x013)
-#define DPRTC_CMDID_SET_IRQ_MASK		DPRTC_CMD(0x014)
+#define DPRTC_CMDID_SET_IRQ_MASK		DPRTC_CMD_V2(0x014)
 #define DPRTC_CMDID_GET_IRQ_MASK		DPRTC_CMD(0x015)
 #define DPRTC_CMDID_GET_IRQ_STATUS		DPRTC_CMD(0x016)
 #define DPRTC_CMDID_CLEAR_IRQ_STATUS		DPRTC_CMD(0x017)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dprtc.h b/drivers/net/ethernet/freescale/dpaa2/dprtc.h
index 311c184..05c4137 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dprtc.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dprtc.h
@@ -20,6 +20,8 @@ struct fsl_mc_io;
 #define DPRTC_IRQ_INDEX		0
 
 #define DPRTC_EVENT_PPS		0x08000000
+#define DPRTC_EVENT_ETS1	0x00800000
+#define DPRTC_EVENT_ETS2	0x00400000
 
 int dprtc_open(struct fsl_mc_io *mc_io,
 	       u32 cmd_flags,
-- 
2.7.4


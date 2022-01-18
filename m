Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA2D4917CE
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343498AbiARCnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:43:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48872 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346818AbiARCkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:40:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60B45B81233;
        Tue, 18 Jan 2022 02:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCDDC36AEF;
        Tue, 18 Jan 2022 02:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473598;
        bh=sovLNmWwA9wnuElnBirZEn7t7GuDTXFhhWCtO7yz5rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJQnoGSwK004v2zChY2IrrhA/+pQ+go8B+xPbBhLoNcVLbENv1u8CiX+zpdQTsqMl
         0IO9+8a/bSIxcomeBq9pHXJyUCbO0JIXEfTPLfqq0uw31VxI1xQbiu6bpOPCsT3PuO
         /zHaPK2rR0SmocJPM7dn5JuNdKwqvYL9qkSM6++d5ffr0hUFJl/yvyx0eRTGFVMGNH
         rlMp2z3jJ6D/px5zxP1jVEyjEK/S55QDlIuVHKR1U3lcMe371rh8IvcuSopGNu/yTp
         7IVKkOTEQMBtOEAax+bCNKojFe7/Gfw0m7nzUDvu2JpOEev30WHY8K4L5tRwmAH6Zi
         dETI8s7I6PqWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, wg@grandegger.com,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 186/188] can: flexcan: add more quirks to describe RX path capabilities
Date:   Mon, 17 Jan 2022 21:31:50 -0500
Message-Id: <20220118023152.1948105-186-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit c5c88591040ee7d84d037328eed9019d3ffab821 ]

Most flexcan IP cores support 2 RX modes:
- FIFO
- mailbox

Some IP core versions cannot receive CAN RTR messages via mailboxes.
This patch adds quirks to document this.

This information will be used in a later patch to switch from FIFO to
more performant mailbox mode at the expense of losing the ability to
receive RTR messages. This trade off is beneficial in certain use
cases.

Link: https://lore.kernel.org/all/20220107193105.1699523-5-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 66 ++++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 02299befe2852..18d7bb99ec1bd 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -252,6 +252,12 @@
 #define FLEXCAN_QUIRK_NR_IRQ_3 BIT(12)
 /* Setup 16 mailboxes */
 #define FLEXCAN_QUIRK_NR_MB_16 BIT(13)
+/* Device supports RX via mailboxes */
+#define FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX BIT(14)
+/* Device supports RTR reception via mailboxes */
+#define FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR BIT(15)
+/* Device supports RX via FIFO */
+#define FLEXCAN_QUIRK_SUPPPORT_RX_FIFO BIT(16)
 
 /* Structure of the message buffer */
 struct flexcan_mb {
@@ -382,59 +388,78 @@ struct flexcan_priv {
 
 static const struct flexcan_devtype_data fsl_mcf5441x_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_NR_IRQ_3 | FLEXCAN_QUIRK_NR_MB_16,
+		FLEXCAN_QUIRK_NR_IRQ_3 | FLEXCAN_QUIRK_NR_MB_16 |
+		FLEXCAN_QUIRK_SUPPPORT_RX_FIFO,
 };
 
 static const struct flexcan_devtype_data fsl_p1010_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_BROKEN_WERR_STATE |
 		FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN,
+		FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_FIFO,
 };
 
 static const struct flexcan_devtype_data fsl_imx25_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_BROKEN_WERR_STATE |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_FIFO,
 };
 
 static const struct flexcan_devtype_data fsl_imx28_devtype_data = {
-	.quirks = FLEXCAN_QUIRK_BROKEN_PERR_STATE,
+	.quirks = FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_FIFO,
 };
 
 static const struct flexcan_devtype_data fsl_imx6q_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_USE_RX_MAILBOX | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR,
+		FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR,
 };
 
 static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_USE_RX_MAILBOX | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW,
+		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR,
 };
 
 static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_RX_MAILBOX |
 		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR |
-		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SUPPORT_ECC,
+		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SUPPORT_ECC |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR,
 };
 
 static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_RX_MAILBOX |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SUPPORT_ECC,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SUPPORT_ECC |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR,
 };
 
 static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_USE_RX_MAILBOX,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_USE_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR,
 };
 
 static const struct flexcan_devtype_data fsl_lx2160a_r1_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
 		FLEXCAN_QUIRK_USE_RX_MAILBOX | FLEXCAN_QUIRK_SUPPORT_FD |
-		FLEXCAN_QUIRK_SUPPORT_ECC,
+		FLEXCAN_QUIRK_SUPPORT_ECC |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR,
 };
 
 static const struct can_bittiming_const flexcan_bittiming_const = {
@@ -2164,8 +2189,25 @@ static int flexcan_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	if ((devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) &&
-	    !(devtype_data->quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)) {
-		dev_err(&pdev->dev, "CAN-FD mode doesn't work with FIFO mode!\n");
+	    !((devtype_data->quirks &
+	       (FLEXCAN_QUIRK_USE_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR |
+		FLEXCAN_QUIRK_SUPPPORT_RX_FIFO)) ==
+	      (FLEXCAN_QUIRK_USE_RX_MAILBOX |
+	       FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+	       FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR))) {
+		dev_err(&pdev->dev, "CAN-FD mode doesn't work in RX-FIFO mode!\n");
+		return -EINVAL;
+	}
+
+	if ((devtype_data->quirks &
+	     (FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+	      FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR)) ==
+	    FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR) {
+		dev_err(&pdev->dev,
+			"Quirks (0x%08x) inconsistent: RX_MAILBOX_RX supported but not RX_MAILBOX\n",
+			devtype_data->quirks);
 		return -EINVAL;
 	}
 
-- 
2.34.1


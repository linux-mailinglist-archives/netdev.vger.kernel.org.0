Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303B820E606
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403871AbgF2Vni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbgF2Sht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:37:49 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F53DC031C7E;
        Mon, 29 Jun 2020 11:18:20 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 2AD6822FE5;
        Mon, 29 Jun 2020 20:18:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1593454698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cNOkHiPv2byQuAj2pn9ZPa3+Ddro6cPpf6otG6XMIXU=;
        b=Qt5Lh88+98GRoG6VG+zgAmNMRTGGa5VpEv+Ku63uodMS0RsBKLYndk4AYHhmRbWS8RtJ6w
        UYR3Ctbmic8zNcTFOnYMnlHam8JyvG0QERHY2zeMl3NObqvIJQpNv+AE/65FH/xg5yR9qY
        wSoZZ3y9pgoFrus6TXetUx3rMtdENHE=
From:   Michael Walle <michael@walle.cc>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH 2/2] can: flexcan: add support for ISO CAN-FD
Date:   Mon, 29 Jun 2020 20:18:09 +0200
Message-Id: <20200629181809.25338-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200629181809.25338-1-michael@walle.cc>
References: <20200629181809.25338-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Up until now, the controller used non-ISO CAN-FD mode, although it
supports it. Add support for ISO mode, too. By default the hardware
is in non-ISO mode and an enable bit has to be explicitly set.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/can/flexcan.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 183e094f8d66..a92d3cdf4195 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -94,6 +94,7 @@
 #define FLEXCAN_CTRL2_MRP		BIT(18)
 #define FLEXCAN_CTRL2_RRS		BIT(17)
 #define FLEXCAN_CTRL2_EACEN		BIT(16)
+#define FLEXCAN_CTRL2_ISOCANFDEN	BIT(12)
 
 /* FLEXCAN memory error control register (MECR) bits */
 #define FLEXCAN_MECR_ECRWRDIS		BIT(31)
@@ -1344,14 +1345,25 @@ static int flexcan_chip_start(struct net_device *dev)
 	else
 		reg_mcr |= FLEXCAN_MCR_SRX_DIS;
 
-	/* MCR - CAN-FD */
-	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
+	/* MCR, CTRL2
+	 *
+	 * CAN-FD mode
+	 * ISO CAN-FD mode
+	 */
+	reg_ctrl2 = priv->read(&regs->ctrl2);
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 		reg_mcr |= FLEXCAN_MCR_FDEN;
-	else
+		reg_ctrl2 |= FLEXCAN_CTRL2_ISOCANFDEN;
+	} else {
 		reg_mcr &= ~FLEXCAN_MCR_FDEN;
+	}
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO)
+		reg_ctrl2 &= ~FLEXCAN_CTRL2_ISOCANFDEN;
 
 	netdev_dbg(dev, "%s: writing mcr=0x%08x", __func__, reg_mcr);
 	priv->write(reg_mcr, &regs->mcr);
+	priv->write(reg_ctrl2, &regs->ctrl2);
 
 	/* CTRL
 	 *
@@ -1952,6 +1964,7 @@ static int flexcan_probe(struct platform_device *pdev)
 
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) {
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
+		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD_NON_ISO;
 		priv->can.bittiming_const = &flexcan_fd_bittiming_const;
 		priv->can.data_bittiming_const =
 			&flexcan_fd_data_bittiming_const;
-- 
2.20.1


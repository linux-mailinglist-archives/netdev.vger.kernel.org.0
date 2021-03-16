Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C473F33CFAD
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbhCPIVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbhCPIVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:21:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFD5C061764
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 01:21:19 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lM4x3-0003A3-H3
        for netdev@vger.kernel.org; Tue, 16 Mar 2021 09:21:17 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E0DDD5F644C
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 08:21:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D6AF65F6418;
        Tue, 16 Mar 2021 08:21:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b86149c7;
        Tue, 16 Mar 2021 08:21:05 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Angelo Dureghello <angelo@kernel-space.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 05/11] can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing bitrate
Date:   Tue, 16 Mar 2021 09:20:58 +0100
Message-Id: <20210316082104.4027260-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316082104.4027260-1-mkl@pengutronix.de>
References: <20210316082104.4027260-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Angelo Dureghello <angelo@kernel-space.org>

For cases when flexcan is built-in, bitrate is still not set at
registering. So flexcan_chip_freeze() generates:

[    1.860000] *** ZERO DIVIDE ***   FORMAT=4
[    1.860000] Current process id is 1
[    1.860000] BAD KERNEL TRAP: 00000000
[    1.860000] PC: [<402e70c8>] flexcan_chip_freeze+0x1a/0xa8

To allow chip freeze, using an hardcoded timeout when bitrate is still
not set.

Fixes: ec15e27cc890 ("can: flexcan: enable RX FIFO after FRZ/HALT valid")
Link: https://lore.kernel.org/r/20210315231510.650593-1-angelo@kernel-space.org
Signed-off-by: Angelo Dureghello <angelo@kernel-space.org>
[mkl: use if instead of ? operator]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 134c05757a3b..57f3635ad8d7 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -697,9 +697,15 @@ static int flexcan_chip_disable(struct flexcan_priv *priv)
 static int flexcan_chip_freeze(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
-	unsigned int timeout = 1000 * 1000 * 10 / priv->can.bittiming.bitrate;
+	unsigned int timeout;
+	u32 bitrate = priv->can.bittiming.bitrate;
 	u32 reg;
 
+	if (bitrate)
+		timeout = 1000 * 1000 * 10 / bitrate;
+	else
+		timeout = FLEXCAN_TIMEOUT_US / 10;
+
 	reg = priv->read(&regs->mcr);
 	reg |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_HALT;
 	priv->write(reg, &regs->mcr);
-- 
2.30.1



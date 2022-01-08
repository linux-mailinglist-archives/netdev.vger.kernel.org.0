Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FBC488670
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbiAHVo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbiAHVoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:44:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BFFC061245
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:44:11 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVR-0004fm-Ah
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:44:09 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 172926D3AA9
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:55 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6E2DF6D3A33;
        Sat,  8 Jan 2022 21:43:49 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c0141510;
        Sat, 8 Jan 2022 21:43:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 20/22] can: flexcan: add ethtool support to get rx/tx ring parameters
Date:   Sat,  8 Jan 2022 22:43:43 +0100
Message-Id: <20220108214345.1848470-21-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108214345.1848470-1-mkl@pengutronix.de>
References: <20220108214345.1848470-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

This patch adds ethtool support to get the number of message buffers
configured for reception/transmission, which may also depends on
runtime configurations such as the 'rx-rtr' flag state.

Link: https://lore.kernel.org/all/20220108181633.420433-1-dario.binacchi@amarulasolutions.com
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
[mkl: port to net-next/master, replace __sw_hweight64 by simpler calculation]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan/flexcan-ethtool.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/can/flexcan/flexcan-ethtool.c b/drivers/net/can/flexcan/flexcan-ethtool.c
index d01347fbfaa9..3ae535577700 100644
--- a/drivers/net/can/flexcan/flexcan-ethtool.c
+++ b/drivers/net/can/flexcan/flexcan-ethtool.c
@@ -17,6 +17,26 @@ static const char flexcan_priv_flags_strings[][ETH_GSTRING_LEN] = {
 	"rx-rtr",
 };
 
+static void
+flexcan_get_ringparam(struct net_device *ndev, struct ethtool_ringparam *ring,
+		      struct kernel_ethtool_ringparam *kernel_ring,
+		      struct netlink_ext_ack *ext_ack)
+{
+	const struct flexcan_priv *priv = netdev_priv(ndev);
+
+	ring->rx_max_pending = priv->mb_count;
+	ring->tx_max_pending = priv->mb_count;
+
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)
+		ring->rx_pending = priv->offload.mb_last -
+			priv->offload.mb_first + 1;
+	else
+		ring->rx_pending = 6;	/* RX-FIFO depth is fixed */
+
+	/* the drive currently supports only on TX buffer */
+	ring->tx_pending = 1;
+}
+
 static void
 flexcan_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 {
@@ -81,6 +101,7 @@ static int flexcan_get_sset_count(struct net_device *netdev, int sset)
 }
 
 static const struct ethtool_ops flexcan_ethtool_ops = {
+	.get_ringparam = flexcan_get_ringparam,
 	.get_strings = flexcan_get_strings,
 	.get_priv_flags = flexcan_get_priv_flags,
 	.set_priv_flags = flexcan_set_priv_flags,
-- 
2.34.1



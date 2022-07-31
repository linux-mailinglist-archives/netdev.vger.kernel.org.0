Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3035860D8
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbiGaTVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238076AbiGaTUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:20:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770A4EE13
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUS-0007Gu-Pt
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:40 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 80EF5BEC65
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:36 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E078ABEC4F;
        Sun, 31 Jul 2022 19:20:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bdce955b;
        Sun, 31 Jul 2022 19:20:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 13/36] can: flexcan: export flexcan_ethtool_ops and remove flexcan_set_ethtool_ops()
Date:   Sun, 31 Jul 2022 21:20:06 +0200
Message-Id: <20220731192029.746751-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220731192029.746751-1-mkl@pengutronix.de>
References: <20220731192029.746751-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The function flexcan_set_ethtool_ops() does one thing: populate
net_device::ethtool_ops. Instead, it is possible to directly assign
this field and remove one function call and slightly reduce the object
size. To do so, export flexcan_ethtool_ops so it becomes visible to
flexcan-core.c.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220727104939.279022-4-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan/flexcan-core.c    | 2 +-
 drivers/net/can/flexcan/flexcan-ethtool.c | 7 +------
 drivers/net/can/flexcan/flexcan.h         | 2 +-
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index d060088047f1..f857968efed7 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -2113,7 +2113,7 @@ static int flexcan_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	dev->netdev_ops = &flexcan_netdev_ops;
-	flexcan_set_ethtool_ops(dev);
+	dev->ethtool_ops = &flexcan_ethtool_ops;
 	dev->irq = irq;
 	dev->flags |= IFF_ECHO;
 
diff --git a/drivers/net/can/flexcan/flexcan-ethtool.c b/drivers/net/can/flexcan/flexcan-ethtool.c
index 3ae535577700..f0873f3a2f34 100644
--- a/drivers/net/can/flexcan/flexcan-ethtool.c
+++ b/drivers/net/can/flexcan/flexcan-ethtool.c
@@ -100,15 +100,10 @@ static int flexcan_get_sset_count(struct net_device *netdev, int sset)
 	}
 }
 
-static const struct ethtool_ops flexcan_ethtool_ops = {
+const struct ethtool_ops flexcan_ethtool_ops = {
 	.get_ringparam = flexcan_get_ringparam,
 	.get_strings = flexcan_get_strings,
 	.get_priv_flags = flexcan_get_priv_flags,
 	.set_priv_flags = flexcan_set_priv_flags,
 	.get_sset_count = flexcan_get_sset_count,
 };
-
-void flexcan_set_ethtool_ops(struct net_device *netdev)
-{
-	netdev->ethtool_ops = &flexcan_ethtool_ops;
-}
diff --git a/drivers/net/can/flexcan/flexcan.h b/drivers/net/can/flexcan/flexcan.h
index 23fc09a7e10f..8621a8ea1dea 100644
--- a/drivers/net/can/flexcan/flexcan.h
+++ b/drivers/net/can/flexcan/flexcan.h
@@ -114,7 +114,7 @@ struct flexcan_priv {
 	void (*write)(u32 val, void __iomem *addr);
 };
 
-void flexcan_set_ethtool_ops(struct net_device *dev);
+extern const struct ethtool_ops flexcan_ethtool_ops;
 
 static inline bool
 flexcan_supports_rx_mailbox(const struct flexcan_priv *priv)
-- 
2.35.1



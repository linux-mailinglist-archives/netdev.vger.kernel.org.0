Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707515860E2
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbiGaTVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237893AbiGaTUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:20:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA0CDF9F
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:41 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUR-0007FU-PE
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:39 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 048B7BEC52
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:36 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 73827BEC45;
        Sun, 31 Jul 2022 19:20:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bf9a4a73;
        Sun, 31 Jul 2022 19:20:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 11/36] can: slcan: export slcan_ethtool_ops and remove slcan_set_ethtool_ops()
Date:   Sun, 31 Jul 2022 21:20:04 +0200
Message-Id: <20220731192029.746751-12-mkl@pengutronix.de>
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

The function slcan_set_ethtool_ops() does one thing: populate
net_device::ethtool_ops. Instead, it is possible to directly assign
this field and remove one function call and slightly reduce the object
size. To do so, export slcan_ethtool_ops so it becomes visible to
sclan-core.c.

This patch reduces the footprint by 14 bytes:

| $ ./scripts/bloat-o-meter drivers/net/can/slcan/slcan.{old,new}.o
| drivers/net/can/slcan/slcan.o
| add/remove: 0/1 grow/shrink: 1/0 up/down: 15/-29 (-14)
| Function                                     old     new   delta
| slcan_open                                  1010    1025     +15
| slcan_set_ethtool_ops                         29       -     -29
| Total: Before=11115, After=11101, chg -0.13%

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220727104939.279022-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan/slcan-core.c    | 2 +-
 drivers/net/can/slcan/slcan-ethtool.c | 7 +------
 drivers/net/can/slcan/slcan.h         | 3 ++-
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index dc28e715bbe1..6162e6132ea4 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -866,8 +866,8 @@ static struct slcan *slc_alloc(void)
 
 	snprintf(dev->name, sizeof(dev->name), "slcan%d", i);
 	dev->netdev_ops = &slc_netdev_ops;
+	dev->ethtool_ops = &slcan_ethtool_ops;
 	dev->base_addr  = i;
-	slcan_set_ethtool_ops(dev);
 	sl = netdev_priv(dev);
 
 	/* Initialize channel control data */
diff --git a/drivers/net/can/slcan/slcan-ethtool.c b/drivers/net/can/slcan/slcan-ethtool.c
index bf0afdc4e49d..328ae1fb065b 100644
--- a/drivers/net/can/slcan/slcan-ethtool.c
+++ b/drivers/net/can/slcan/slcan-ethtool.c
@@ -52,14 +52,9 @@ static int slcan_get_sset_count(struct net_device *netdev, int sset)
 	}
 }
 
-static const struct ethtool_ops slcan_ethtool_ops = {
+const struct ethtool_ops slcan_ethtool_ops = {
 	.get_strings = slcan_get_strings,
 	.get_priv_flags = slcan_get_priv_flags,
 	.set_priv_flags = slcan_set_priv_flags,
 	.get_sset_count = slcan_get_sset_count,
 };
-
-void slcan_set_ethtool_ops(struct net_device *netdev)
-{
-	netdev->ethtool_ops = &slcan_ethtool_ops;
-}
diff --git a/drivers/net/can/slcan/slcan.h b/drivers/net/can/slcan/slcan.h
index d463c8d99e22..85cedf856db3 100644
--- a/drivers/net/can/slcan/slcan.h
+++ b/drivers/net/can/slcan/slcan.h
@@ -13,6 +13,7 @@
 
 bool slcan_err_rst_on_open(struct net_device *ndev);
 int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on);
-void slcan_set_ethtool_ops(struct net_device *ndev);
+
+extern const struct ethtool_ops slcan_ethtool_ops;
 
 #endif /* _SLCAN_H */
-- 
2.35.1



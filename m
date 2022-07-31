Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3FA5860F1
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238374AbiGaTWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238373AbiGaTVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:21:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F9211168
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:56 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUg-0007pv-7J
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:54 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A9376BECE4
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 172FDBECC9;
        Sun, 31 Jul 2022 19:20:39 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c6dd8396;
        Sun, 31 Jul 2022 19:20:31 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 27/36] can: dev: add generic function can_ethtool_op_get_ts_info_hwts()
Date:   Sun, 31 Jul 2022 21:20:20 +0200
Message-Id: <20220731192029.746751-28-mkl@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Add function can_ethtool_op_get_ts_info_hwts(). This function will be
used by CAN devices with hardware TX/RX timestamping support to
implement ethtool_ops::get_ts_info. This function does not offer
support to activate/deactivate hardware timestamps at device level nor
support the filter options (which is currently the case for all CAN
devices with hardware timestamping support).

The fact that hardware timestamp can not be deactivated at hardware
level does not impact the userland. As long as the user do not set
SO_TIMESTAMPING using a setsockopt() or ioctl(), the kernel will not
emit TX timestamps (RX timestamps will still be reproted as it is the
case currently).

Drivers which need more fine grained control remains free to implement
their own function, but we foresee that the generic function
introduced here will be sufficient for the majority.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220727101641.198847-8-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/dev.c | 21 +++++++++++++++++++++
 include/linux/can/dev.h   |  3 +++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 523eaacfe29e..f307034ff4fd 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -322,6 +322,27 @@ int can_change_mtu(struct net_device *dev, int new_mtu)
 }
 EXPORT_SYMBOL_GPL(can_change_mtu);
 
+/* generic implementation of ethtool_ops::get_ts_info for CAN devices
+ * supporting hardware timestamps
+ */
+int can_ethtool_op_get_ts_info_hwts(struct net_device *dev,
+				    struct ethtool_ts_info *info)
+{
+	info->so_timestamping =
+		SOF_TIMESTAMPING_TX_SOFTWARE |
+		SOF_TIMESTAMPING_RX_SOFTWARE |
+		SOF_TIMESTAMPING_SOFTWARE |
+		SOF_TIMESTAMPING_TX_HARDWARE |
+		SOF_TIMESTAMPING_RX_HARDWARE |
+		SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->phc_index = -1;
+	info->tx_types = BIT(HWTSTAMP_TX_ON);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_ALL);
+
+	return 0;
+}
+EXPORT_SYMBOL(can_ethtool_op_get_ts_info_hwts);
+
 /* Common open function when the device gets opened.
  *
  * This function should be called in the open function of the device
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index e22dc03c850e..752bd45d8ebf 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -20,6 +20,7 @@
 #include <linux/can/length.h>
 #include <linux/can/netlink.h>
 #include <linux/can/skb.h>
+#include <linux/ethtool.h>
 #include <linux/netdevice.h>
 
 /*
@@ -162,6 +163,8 @@ struct can_priv *safe_candev_priv(struct net_device *dev);
 int open_candev(struct net_device *dev);
 void close_candev(struct net_device *dev);
 int can_change_mtu(struct net_device *dev, int new_mtu);
+int can_ethtool_op_get_ts_info_hwts(struct net_device *dev,
+				    struct ethtool_ts_info *info);
 
 int register_candev(struct net_device *dev);
 void unregister_candev(struct net_device *dev);
-- 
2.35.1



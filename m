Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E765860F3
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238434AbiGaTWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238425AbiGaTVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:21:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713E5EE00
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:57 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUh-00080o-Dd
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:55 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2BE1DBECF5
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:40 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6FA8DBECD8;
        Sun, 31 Jul 2022 19:20:39 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4e9a6c4e;
        Sun, 31 Jul 2022 19:20:31 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 28/36] can: dev: add generic function can_eth_ioctl_hwts()
Date:   Sun, 31 Jul 2022 21:20:21 +0200
Message-Id: <20220731192029.746751-29-mkl@pengutronix.de>
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

Tools based on libpcap (such as tcpdump) expect the SIOCSHWTSTAMP
ioctl call to be supported. This is also specified in the kernel doc
[1]. The purpose of this ioctl is to toggle the hardware timestamps.

Currently, CAN devices which support hardware timestamping have those
always activated. can_eth_ioctl_hwts() is a dumb function that will
always succeed when requested to set tx_type to HWTSTAMP_TX_ON or
rx_filter to HWTSTAMP_FILTER_ALL.

[1] Kernel doc: Timestamping, section 3.1 "Hardware Timestamping
Implementation: Device Drivers"
Link: https://docs.kernel.org/networking/timestamping.html#hardware-timestamping-implementation-device-drivers

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220727101641.198847-9-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/dev.c | 29 +++++++++++++++++++++++++++++
 include/linux/can/dev.h   |  1 +
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index f307034ff4fd..c1956b1e9faf 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -322,6 +322,35 @@ int can_change_mtu(struct net_device *dev, int new_mtu)
 }
 EXPORT_SYMBOL_GPL(can_change_mtu);
 
+/* generic implementation of netdev_ops::ndo_eth_ioctl for CAN devices
+ * supporting hardware timestamps
+ */
+int can_eth_ioctl_hwts(struct net_device *netdev, struct ifreq *ifr, int cmd)
+{
+	struct hwtstamp_config hwts_cfg = { 0 };
+
+	switch (cmd) {
+	case SIOCSHWTSTAMP: /* set */
+		if (copy_from_user(&hwts_cfg, ifr->ifr_data, sizeof(hwts_cfg)))
+			return -EFAULT;
+		if (hwts_cfg.tx_type == HWTSTAMP_TX_ON &&
+		    hwts_cfg.rx_filter == HWTSTAMP_FILTER_ALL)
+			return 0;
+		return -ERANGE;
+
+	case SIOCGHWTSTAMP: /* get */
+		hwts_cfg.tx_type = HWTSTAMP_TX_ON;
+		hwts_cfg.rx_filter = HWTSTAMP_FILTER_ALL;
+		if (copy_to_user(ifr->ifr_data, &hwts_cfg, sizeof(hwts_cfg)))
+			return -EFAULT;
+		return 0;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL(can_eth_ioctl_hwts);
+
 /* generic implementation of ethtool_ops::get_ts_info for CAN devices
  * supporting hardware timestamps
  */
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 752bd45d8ebf..c3e50e537e39 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -163,6 +163,7 @@ struct can_priv *safe_candev_priv(struct net_device *dev);
 int open_candev(struct net_device *dev);
 void close_candev(struct net_device *dev);
 int can_change_mtu(struct net_device *dev, int new_mtu);
+int can_eth_ioctl_hwts(struct net_device *netdev, struct ifreq *ifr, int cmd);
 int can_ethtool_op_get_ts_info_hwts(struct net_device *dev,
 				    struct ethtool_ts_info *info);
 
-- 
2.35.1



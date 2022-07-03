Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD2E5646B3
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbiGCK03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiGCK0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:26:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518E6632D
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 03:26:14 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7wns-0006Gp-Fc
        for netdev@vger.kernel.org; Sun, 03 Jul 2022 12:26:12 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A0D64A6A0D
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 10:14:38 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C0819A69DA;
        Sun,  3 Jul 2022 10:14:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 80cf1a2e;
        Sun, 3 Jul 2022 10:14:32 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 13/15] can: slcan: add ethtool support to reset adapter errors
Date:   Sun,  3 Jul 2022 12:14:27 +0200
Message-Id: <20220703101430.1306048-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220703101430.1306048-1-mkl@pengutronix.de>
References: <20220703101430.1306048-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

This patch adds a private flag to the slcan driver to switch the
"err-rst-on-open" setting on and off.

"err-rst-on-open" on  - Reset error states on opening command

"err-rst-on-open" off - Don't reset error states on opening command
                        (default)

The setting can only be changed if the interface is down:

    ip link set dev can0 down
    ethtool --set-priv-flags can0 err-rst-on-open {off|on}
    ip link set dev can0 up

Link: https://lore.kernel.org/all/20220628163137.413025-11-dario.binacchi@amarulasolutions.com
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan/Makefile        |  1 +
 drivers/net/can/slcan/slcan-core.c    | 36 +++++++++++++++
 drivers/net/can/slcan/slcan-ethtool.c | 65 +++++++++++++++++++++++++++
 drivers/net/can/slcan/slcan.h         | 18 ++++++++
 4 files changed, 120 insertions(+)
 create mode 100644 drivers/net/can/slcan/slcan-ethtool.c
 create mode 100644 drivers/net/can/slcan/slcan.h

diff --git a/drivers/net/can/slcan/Makefile b/drivers/net/can/slcan/Makefile
index 2e84f7bf7617..8a88e484ee21 100644
--- a/drivers/net/can/slcan/Makefile
+++ b/drivers/net/can/slcan/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_CAN_SLCAN) += slcan.o
 
 slcan-objs :=
 slcan-objs += slcan-core.o
+slcan-objs += slcan-ethtool.o
diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 249b5ade06fc..c1fd1e934d93 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -57,6 +57,8 @@
 #include <linux/can/dev.h>
 #include <linux/can/skb.h>
 
+#include "slcan.h"
+
 MODULE_ALIAS_LDISC(N_SLCAN);
 MODULE_DESCRIPTION("serial line CAN interface");
 MODULE_LICENSE("GPL");
@@ -98,6 +100,8 @@ struct slcan {
 #define SLF_INUSE		0		/* Channel in use            */
 #define SLF_ERROR		1               /* Parity, etc. error        */
 #define SLF_XCMD		2               /* Command transmission      */
+	unsigned long           cmd_flags;      /* Command flags             */
+#define CF_ERR_RST		0               /* Reset errors on open      */
 	wait_queue_head_t       xcmd_wait;      /* Wait queue for commands   */
 						/* transmission              */
 };
@@ -109,6 +113,28 @@ static const u32 slcan_bitrate_const[] = {
 	250000, 500000, 800000, 1000000
 };
 
+bool slcan_err_rst_on_open(struct net_device *ndev)
+{
+	struct slcan *sl = netdev_priv(ndev);
+
+	return !!test_bit(CF_ERR_RST, &sl->cmd_flags);
+}
+
+int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
+{
+	struct slcan *sl = netdev_priv(ndev);
+
+	if (netif_running(ndev))
+		return -EBUSY;
+
+	if (on)
+		set_bit(CF_ERR_RST, &sl->cmd_flags);
+	else
+		clear_bit(CF_ERR_RST, &sl->cmd_flags);
+
+	return 0;
+}
+
  /************************************************************************
   *			SLCAN ENCAPSULATION FORMAT			 *
   ************************************************************************/
@@ -510,6 +536,15 @@ static int slc_open(struct net_device *dev)
 			goto cmd_transmit_failed;
 		}
 
+		if (test_bit(CF_ERR_RST, &sl->cmd_flags)) {
+			err = slcan_transmit_cmd(sl, "F\r");
+			if (err) {
+				netdev_err(dev,
+					   "failed to send error command 'F\\r'\n");
+				goto cmd_transmit_failed;
+			}
+		}
+
 		err = slcan_transmit_cmd(sl, "O\r");
 		if (err) {
 			netdev_err(dev, "failed to send open command 'O\\r'\n");
@@ -629,6 +664,7 @@ static struct slcan *slc_alloc(void)
 	snprintf(dev->name, sizeof(dev->name), "slcan%d", i);
 	dev->netdev_ops = &slc_netdev_ops;
 	dev->base_addr  = i;
+	slcan_set_ethtool_ops(dev);
 	sl = netdev_priv(dev);
 
 	/* Initialize channel control data */
diff --git a/drivers/net/can/slcan/slcan-ethtool.c b/drivers/net/can/slcan/slcan-ethtool.c
new file mode 100644
index 000000000000..bf0afdc4e49d
--- /dev/null
+++ b/drivers/net/can/slcan/slcan-ethtool.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (c) 2022 Amarula Solutions, Dario Binacchi <dario.binacchi@amarulasolutions.com>
+ *
+ */
+
+#include <linux/can/dev.h>
+#include <linux/ethtool.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/platform_device.h>
+
+#include "slcan.h"
+
+static const char slcan_priv_flags_strings[][ETH_GSTRING_LEN] = {
+#define SLCAN_PRIV_FLAGS_ERR_RST_ON_OPEN BIT(0)
+	"err-rst-on-open",
+};
+
+static void slcan_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
+{
+	switch (stringset) {
+	case ETH_SS_PRIV_FLAGS:
+		memcpy(data, slcan_priv_flags_strings,
+		       sizeof(slcan_priv_flags_strings));
+	}
+}
+
+static u32 slcan_get_priv_flags(struct net_device *ndev)
+{
+	u32 flags = 0;
+
+	if (slcan_err_rst_on_open(ndev))
+		flags |= SLCAN_PRIV_FLAGS_ERR_RST_ON_OPEN;
+
+	return flags;
+}
+
+static int slcan_set_priv_flags(struct net_device *ndev, u32 flags)
+{
+	bool err_rst_op_open = !!(flags & SLCAN_PRIV_FLAGS_ERR_RST_ON_OPEN);
+
+	return slcan_enable_err_rst_on_open(ndev, err_rst_op_open);
+}
+
+static int slcan_get_sset_count(struct net_device *netdev, int sset)
+{
+	switch (sset) {
+	case ETH_SS_PRIV_FLAGS:
+		return ARRAY_SIZE(slcan_priv_flags_strings);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static const struct ethtool_ops slcan_ethtool_ops = {
+	.get_strings = slcan_get_strings,
+	.get_priv_flags = slcan_get_priv_flags,
+	.set_priv_flags = slcan_set_priv_flags,
+	.get_sset_count = slcan_get_sset_count,
+};
+
+void slcan_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &slcan_ethtool_ops;
+}
diff --git a/drivers/net/can/slcan/slcan.h b/drivers/net/can/slcan/slcan.h
new file mode 100644
index 000000000000..d463c8d99e22
--- /dev/null
+++ b/drivers/net/can/slcan/slcan.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * slcan.h - serial line CAN interface driver
+ *
+ * Copyright (C) Laurence Culhane <loz@holmes.demon.co.uk>
+ * Copyright (C) Fred N. van Kempen <waltje@uwalt.nl.mugnet.org>
+ * Copyright (C) Oliver Hartkopp <socketcan@hartkopp.net>
+ * Copyright (C) 2022 Amarula Solutions, Dario Binacchi <dario.binacchi@amarulasolutions.com>
+ *
+ */
+
+#ifndef _SLCAN_H
+#define _SLCAN_H
+
+bool slcan_err_rst_on_open(struct net_device *ndev);
+int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on);
+void slcan_set_ethtool_ops(struct net_device *ndev);
+
+#endif /* _SLCAN_H */
-- 
2.35.1



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67F0693F52
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 09:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjBMIKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 03:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBMIKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 03:10:11 -0500
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8996DCC0B
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 00:10:07 -0800 (PST)
X-QQ-mid: bizesmtp76t1676275799tzwlbr7m
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 13 Feb 2023 16:09:52 +0800 (CST)
X-QQ-SSF: 01400000000000N0P000000A0000000
X-QQ-FEAT: ILHsT53NKPjGf5m6K6AhIs9laObzD8MLXA3NTWraKjhk6XuiEzYakH3DhNplA
        jYoqnnimovVWUQf65VI5V7ap9kzdAqUxnf/fJsnHtTZ+yvDNKeHc3Tx/2Mi8kxQfnQgUyeV
        CGn4+/w+45Y7vhtzdkhBpxRsDUUZo0QE1zFHyvSq+5CKF1aZVGFr+KPzBW/NB7J8y59KXJs
        ilTybGcZsjzv7PtsJKAtKdSlWOW5YTU82fvhijZEJAkH7g4UZCCTM4dcUSQFfuETiCDFPkT
        qH/R+FV9KMO7fhTpBo6qNfySCVseqo1ZdhvadJCMlAK9Dx9TpTUPHt4ioiACfopGb+rMnkb
        8IHF5Un+VuepajF55+hBo+6z9ZYVFI1C7c4mHlcPx8XbnAYahX5v/RXKwxuG7F3z1EPfyAU
        3aY/XBRVzP63ZjW0nI24Hg==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next] net: wangxun: Add base ethtool ops.
Date:   Mon, 13 Feb 2023 16:09:49 +0800
Message-Id: <20230213080949.52370-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add base ethtool ops get_drvinfo for ngbe and txgbe.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/Makefile   |  2 +-
 .../net/ethernet/wangxun/libwx/wx_ethtool.c   | 29 +++++++++++++++++++
 .../net/ethernet/wangxun/libwx/wx_ethtool.h   |  9 ++++++
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  1 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  5 ++++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  3 ++
 6 files changed, 48 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_ethtool.h

diff --git a/drivers/net/ethernet/wangxun/libwx/Makefile b/drivers/net/ethernet/wangxun/libwx/Makefile
index 850d1615cd18..42ccd6e4052e 100644
--- a/drivers/net/ethernet/wangxun/libwx/Makefile
+++ b/drivers/net/ethernet/wangxun/libwx/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_LIBWX) += libwx.o
 
-libwx-objs := wx_hw.o wx_lib.o
+libwx-objs := wx_hw.o wx_lib.o wx_ethtool.o
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c b/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
new file mode 100644
index 000000000000..e83235aa6ff2
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/pci.h>
+#include <linux/phy.h>
+
+#include "wx_type.h"
+#include "wx_ethtool.h"
+
+static void wx_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *info)
+{
+	struct wx *wx = netdev_priv(netdev);
+
+	strscpy(info->driver, wx->driver_name, sizeof(info->driver));
+	strscpy(info->fw_version, wx->eeprom_id, sizeof(info->fw_version));
+	strscpy(info->bus_info, pci_name(wx->pdev), sizeof(info->bus_info));
+}
+
+static const struct ethtool_ops wx_ethtool_ops = {
+	.get_drvinfo		= wx_get_drvinfo,
+};
+
+void wx_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &wx_ethtool_ops;
+}
+EXPORT_SYMBOL(wx_set_ethtool_ops);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_ethtool.h b/drivers/net/ethernet/wangxun/libwx/wx_ethtool.h
new file mode 100644
index 000000000000..42c222e3210e
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/libwx/wx_ethtool.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _WX_ETHTOOL_H_
+#define _WX_ETHTOOL_H_
+
+void wx_set_ethtool_ops(struct net_device *netdev);
+
+#endif /* _WX_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index eede93d4120d..6d51b1e509d8 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -633,6 +633,7 @@ struct wx {
 	bool adapter_stopped;
 	u16 tpid[8];
 	char eeprom_id[32];
+	char driver_name[32];
 	enum wx_reset_type reset_type;
 
 	/* PHY stuff */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index f94d415daf3c..4d80ff8a0e5a 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -14,6 +14,7 @@
 #include "../libwx/wx_type.h"
 #include "../libwx/wx_hw.h"
 #include "../libwx/wx_lib.h"
+#include "../libwx/wx_ethtool.h"
 #include "ngbe_type.h"
 #include "ngbe_mdio.h"
 #include "ngbe_hw.h"
@@ -546,6 +547,8 @@ static int ngbe_probe(struct pci_dev *pdev,
 		goto err_pci_release_regions;
 	}
 
+	strscpy(wx->driver_name, ngbe_driver_name, sizeof(wx->driver_name));
+	wx_set_ethtool_ops(netdev);
 	netdev->netdev_ops = &ngbe_netdev_ops;
 
 	netdev->features |= NETIF_F_HIGHDMA;
@@ -631,6 +634,8 @@ static int ngbe_probe(struct pci_dev *pdev,
 		etrack_id |= e2rom_ver;
 		wr32(wx, NGBE_EEPROM_VERSION_STORE_REG, etrack_id);
 	}
+	snprintf(wx->eeprom_id, sizeof(wx->eeprom_id),
+		 "0x%08x", etrack_id);
 
 	eth_hw_addr_set(netdev, wx->mac.perm_addr);
 	wx_mac_set_default_filter(wx, wx->mac.perm_addr);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 094df377726b..f532137c283d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -13,6 +13,7 @@
 #include "../libwx/wx_type.h"
 #include "../libwx/wx_lib.h"
 #include "../libwx/wx_hw.h"
+#include "../libwx/wx_ethtool.h"
 #include "txgbe_type.h"
 #include "txgbe_hw.h"
 
@@ -565,6 +566,8 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_pci_release_regions;
 	}
 
+	strscpy(wx->driver_name, txgbe_driver_name, sizeof(wx->driver_name));
+	wx_set_ethtool_ops(netdev);
 	netdev->netdev_ops = &txgbe_netdev_ops;
 
 	/* setup the private structure */
-- 
2.39.1


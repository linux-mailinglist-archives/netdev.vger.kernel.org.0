Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B06264FDD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgIJTxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:53:24 -0400
Received: from mail-eopbgr60116.outbound.protection.outlook.com ([40.107.6.116]:17127
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731206AbgIJPDd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 11:03:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkNRRRVJ2yjOypLCHacCDqsFfutkUD3x6Nwf9KYS8i6+AhZA7ISSd9q8q88CkBxCdSDunysaEaSsvkBhzkkEWXQ1dkmtp9fATzfs6vDY+FAJh0J/8lm057oEtcEgsF3D0klN3upmEPLFlOx6t9svPZGRAWQIFYrPLAY5gxqF8I90BXcaXVaB3hqX8teQT29ibCHYbJpdan0AofcuCH3DigvEVy5vqvwT9/+vSgku/W2qrWCHXy6DBvJH6E0bOOv9WMSEVxTLRx0ABn4BSPxRJWlIx93G/fctgSV73HVulSWtMKaF/0IDTyp24+QIWiuhg4vBiCqavT3J3ROU3ni68w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nshoVx8G68D2WxWY7ETcs9K5UrEl8pgOQQ/qtWFwAaI=;
 b=iE1d35NAJtm3CVxZssNDYpD/cfyINM9AD7vH7c4m0aZLT1wRFrMUNIU9+jp7i//3Hk85/1U3AL5mluY7tex7YPZzjxPOSYehPEdmqMt/eTrrOyRBD/VEj1mLlXlTkWkTMQ5QxNA9cPedHPRoroRwqiUeq6piYlglQ2jCxjq+CLPaz/DcTSXGNbGUUV4BySeJ9Ip4T1KF3lqbgstkKGgjC7YsX47DJKmlu4HliVuNT5ILyL+FOYDb4XXadf/kRkxITWrUQg9oFWoKonUG3WJKlfcAEXKr2qDY7emwZNWpftIeIXzTJ4bSzCOFKfcvgNHDyuiV6YOWkhtjkzwSwyUekQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nshoVx8G68D2WxWY7ETcs9K5UrEl8pgOQQ/qtWFwAaI=;
 b=q5X62m7E5uPOTLa7NwKVbKcMxmhbWZSmlL07MEZV7GhiNxzsBy4dYw8lB7tCJ9zLzPvdAa8q09wQVfGinkPuTRhfwEmp/c1N1NzFd51HVRFj3ewacTiDBhE//J+u6ePx4COnEVUwp3HCw+d8AKTDkY9kIKia64caN0KtcIX5w+4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0459.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.19; Thu, 10 Sep 2020 15:01:23 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 15:01:23 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [net-next v8 3/6] net: marvell: prestera: Add basic devlink support
Date:   Thu, 10 Sep 2020 18:00:52 +0300
Message-Id: <20200910150055.15598-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910150055.15598-1-vadym.kochan@plvision.eu>
References: <20200910150055.15598-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0009.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::19) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by BE0P281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.10 via Frontend Transport; Thu, 10 Sep 2020 15:01:19 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6bc5b9c-f3c0-4055-b24c-08d8559a60a6
X-MS-TrafficTypeDiagnostic: HE1P190MB0459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0459772A43A87390BC8EAFD495270@HE1P190MB0459.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PpDIBYb8e0NA1PmU/NSmo2meFzkRURv6FYkAbUA+nhbM6RU7hbs1o6zWwv4QbqCfUGfV4KORjRDX1KmavQWu/KF0R37aCxSrJC8zzKDyUUvOfxezkHDWNMNoB6RGCT1SFpelAZ8AzV5iKK7IG4+D0ywwxSdAHIFBxLMHFJidUc2gS6988QRI8sUiUTM+Py6qWs7BU3rM/pFra6Hw2iv/g2Ewv3cljwn5erOmtoN8PXh2Lm8uyl5SHk4x07k3R0JF48VjCg5xlpdFvxxXSE99nJaIRUoKsFuCjCt5dXQ6xS6eWwWB9E1JauMmyOvNK7f351UIgq6xgag8Nd6KoEQF+shx5tgjQa4UIPBMbOZdish57G0O7cybdMvbIgB7af2I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(366004)(376002)(26005)(2906002)(8936002)(110136005)(186003)(16526019)(8676002)(2616005)(83380400001)(44832011)(4326008)(66556008)(66946007)(54906003)(66476007)(30864003)(1076003)(6506007)(5660300002)(6666004)(107886003)(956004)(6486002)(478600001)(86362001)(316002)(6512007)(36756003)(52116002)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: pdxokJDDhQtmlyk/FHTjDJb3kAqDhla+9IIsd05JdP1LbECjV7jJN1Cwd+RQ5KjYFORzntPYvzRtvb6boZV3DHdVnZY051/G5avWhgX4qzWmX6w//7e7dYSiOxJ8OCyMNyUKsvzPCEku8a7UpadE8jOGj4KfzyA76LQ5kgyJJe2IRcbLsp/IZF5cykug03/4ymc7PKQ64nYr8zeqY5b8oD16kf6kGP/vQYzy5fnNug7HM2rz9x83mYdQUNiN8ILgCO0T39Q/dZ0iZYnXn16t6t8/d287XoIiVIM3GovmddfRIiFcHNbhJmB+iGpP7qGiJGTvyQ8NpRbm0cjJd2Ik6mtnpXhpZS4QYEzSwxnJqR1FrLC2k/mc1wYmXOy4swodS3LTtN2N1xSGeWBzhJLwgiHVv1Wp1AeWceCXPNlgRIKV5gX5E2elmM5auvYjYRzq4WSBJ3HKrLWubKrWk1Pf7ZPKWNNCRO0/k4mcD/UveSlfYvFgXOX9iit8nYx6WPVb96kPLna37MjplEQhwa/pRwuP3Yv/Omht2Dsor8xbv2NnagZ8vhsn+YaPd50VSCQe/Ph+zK7vytP8wDxqLTgdEpgJWvlm0SPYJfOZHp6vzFkiwjGaiz52uz3qpDioEcmCDUJURUUyN6ZirQOhfBiWqg==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a6bc5b9c-f3c0-4055-b24c-08d8559a60a6
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 15:01:21.0565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2KqzQOaGu9HkjeeK/bbdZZiuHyddnKTxFTJpd8B3QJQkNsF9KfHlPzIULkW0zjejrRcJ2HSU42O8WqBTMeaiG4N2ErsOikL+OiBeseHDwkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0459
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add very basic support for devlink interface:

    - driver name
    - fw version
    - devlink ports

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
PATCH v8:
    1) Put license in one line.

    2) Use traditional error handling pattern in prestera_devlink_port_register():

       err = F();
       if (err)
           return err;

    3) Initialize 'sw' and 'dl' on definition.

PATCH v5:
    1) Simplified some error path handling by simple return error code in:

       - prestera_dl_info_get(...)

    2) Remove not-needed err assignment in:
       - prestera_dl_info_get(...)

    3) Use dev_err() in prestera_devlink_register(...).

 drivers/net/ethernet/marvell/prestera/Kconfig |   1 +
 .../net/ethernet/marvell/prestera/Makefile    |   2 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   4 +
 .../marvell/prestera/prestera_devlink.c       | 112 ++++++++++++++++++
 .../marvell/prestera/prestera_devlink.h       |  23 ++++
 .../ethernet/marvell/prestera/prestera_main.c |  28 ++++-
 6 files changed, 165 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.h

diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
index 2a5945c455cc..b1fcc44f566a 100644
--- a/drivers/net/ethernet/marvell/prestera/Kconfig
+++ b/drivers/net/ethernet/marvell/prestera/Kconfig
@@ -6,6 +6,7 @@
 config PRESTERA
 	tristate "Marvell Prestera Switch ASICs support"
 	depends on NET_SWITCHDEV && VLAN_8021Q
+	select NET_DEVLINK
 	help
 	  This driver supports Marvell Prestera Switch ASICs family.
 
diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
index 2146714eab21..babd71fba809 100644
--- a/drivers/net/ethernet/marvell/prestera/Makefile
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_PRESTERA)	+= prestera.o
 prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
-			   prestera_rxtx.o
+			   prestera_rxtx.o prestera_devlink.o
 
 obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index c5bf0fe8d59e..0a34d7ca4823 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -7,8 +7,11 @@
 #include <linux/notifier.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
+#include <net/devlink.h>
 #include <uapi/linux/if_ether.h>
 
+#define PRESTERA_DRV_NAME	"prestera"
+
 struct prestera_fw_rev {
 	u16 maj;
 	u16 min;
@@ -58,6 +61,7 @@ struct prestera_port_caps {
 struct prestera_port {
 	struct net_device *dev;
 	struct prestera_switch *sw;
+	struct devlink_port dl_port;
 	u32 id;
 	u32 hw_id;
 	u32 dev_id;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
new file mode 100644
index 000000000000..94c185a0e2b8
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <net/devlink.h>
+
+#include "prestera_devlink.h"
+
+static int prestera_dl_info_get(struct devlink *dl,
+				struct devlink_info_req *req,
+				struct netlink_ext_ack *extack)
+{
+	struct prestera_switch *sw = devlink_priv(dl);
+	char buf[16];
+	int err;
+
+	err = devlink_info_driver_name_put(req, PRESTERA_DRV_NAME);
+	if (err)
+		return err;
+
+	snprintf(buf, sizeof(buf), "%d.%d.%d",
+		 sw->dev->fw_rev.maj,
+		 sw->dev->fw_rev.min,
+		 sw->dev->fw_rev.sub);
+
+	return devlink_info_version_running_put(req,
+					       DEVLINK_INFO_VERSION_GENERIC_FW,
+					       buf);
+}
+
+static const struct devlink_ops prestera_dl_ops = {
+	.info_get = prestera_dl_info_get,
+};
+
+struct prestera_switch *prestera_devlink_alloc(void)
+{
+	struct devlink *dl;
+
+	dl = devlink_alloc(&prestera_dl_ops, sizeof(struct prestera_switch));
+
+	return devlink_priv(dl);
+}
+
+void prestera_devlink_free(struct prestera_switch *sw)
+{
+	struct devlink *dl = priv_to_devlink(sw);
+
+	devlink_free(dl);
+}
+
+int prestera_devlink_register(struct prestera_switch *sw)
+{
+	struct devlink *dl = priv_to_devlink(sw);
+	int err;
+
+	err = devlink_register(dl, sw->dev->dev);
+	if (err)
+		dev_err(prestera_dev(sw), "devlink_register failed: %d\n", err);
+
+	return err;
+}
+
+void prestera_devlink_unregister(struct prestera_switch *sw)
+{
+	struct devlink *dl = priv_to_devlink(sw);
+
+	devlink_unregister(dl);
+}
+
+int prestera_devlink_port_register(struct prestera_port *port)
+{
+	struct prestera_switch *sw = port->sw;
+	struct devlink *dl = priv_to_devlink(sw);
+	struct devlink_port_attrs attrs = {};
+	int err;
+
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = port->fp_id;
+	attrs.switch_id.id_len = sizeof(sw->id);
+	memcpy(attrs.switch_id.id, &sw->id, attrs.switch_id.id_len);
+
+	devlink_port_attrs_set(&port->dl_port, &attrs);
+
+	err = devlink_port_register(dl, &port->dl_port, port->fp_id);
+	if (err) {
+		dev_err(prestera_dev(sw), "devlink_port_register failed: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+void prestera_devlink_port_unregister(struct prestera_port *port)
+{
+	devlink_port_unregister(&port->dl_port);
+}
+
+void prestera_devlink_port_set(struct prestera_port *port)
+{
+	devlink_port_type_eth_set(&port->dl_port, port->dev);
+}
+
+void prestera_devlink_port_clear(struct prestera_port *port)
+{
+	devlink_port_type_clear(&port->dl_port);
+}
+
+struct devlink_port *prestera_devlink_get_port(struct net_device *dev)
+{
+	struct prestera_port *port = netdev_priv(dev);
+
+	return &port->dl_port;
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.h b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
new file mode 100644
index 000000000000..51bee9f75415
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved. */
+
+#ifndef _PRESTERA_DEVLINK_H_
+#define _PRESTERA_DEVLINK_H_
+
+#include "prestera.h"
+
+struct prestera_switch *prestera_devlink_alloc(void);
+void prestera_devlink_free(struct prestera_switch *sw);
+
+int prestera_devlink_register(struct prestera_switch *sw);
+void prestera_devlink_unregister(struct prestera_switch *sw);
+
+int prestera_devlink_port_register(struct prestera_port *port);
+void prestera_devlink_port_unregister(struct prestera_port *port);
+
+void prestera_devlink_port_set(struct prestera_port *port);
+void prestera_devlink_port_clear(struct prestera_port *port);
+
+struct devlink_port *prestera_devlink_get_port(struct net_device *dev);
+
+#endif /* _PRESTERA_DEVLINK_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index eb695e2ebda3..47cd2bc367bf 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -12,6 +12,7 @@
 #include "prestera.h"
 #include "prestera_hw.h"
 #include "prestera_rxtx.h"
+#include "prestera_devlink.h"
 
 #define PRESTERA_MTU_DEFAULT	1536
 
@@ -186,6 +187,7 @@ static const struct net_device_ops prestera_netdev_ops = {
 	.ndo_change_mtu = prestera_port_change_mtu,
 	.ndo_get_stats64 = prestera_port_get_stats64,
 	.ndo_set_mac_address = prestera_port_set_mac_address,
+	.ndo_get_devlink_port = prestera_devlink_get_port,
 };
 
 static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
@@ -250,9 +252,13 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 					&port->fp_id);
 	if (err) {
 		dev_err(prestera_dev(sw), "Failed to get port(%u) info\n", id);
-		goto err_port_init;
+		goto err_port_info_get;
 	}
 
+	err = prestera_devlink_port_register(port);
+	if (err)
+		goto err_dl_port_register;
+
 	dev->features |= NETIF_F_NETNS_LOCAL;
 	dev->netdev_ops = &prestera_netdev_ops;
 
@@ -313,11 +319,16 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	if (err)
 		goto err_register_netdev;
 
+	prestera_devlink_port_set(port);
+
 	return 0;
 
 err_register_netdev:
 	prestera_port_list_del(port);
 err_port_init:
+	prestera_devlink_port_unregister(port);
+err_dl_port_register:
+err_port_info_get:
 	free_netdev(dev);
 	return err;
 }
@@ -327,8 +338,10 @@ static void prestera_port_destroy(struct prestera_port *port)
 	struct net_device *dev = port->dev;
 
 	cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
+	prestera_devlink_port_clear(port);
 	unregister_netdev(dev);
 	prestera_port_list_del(port);
+	prestera_devlink_port_unregister(port);
 	free_netdev(dev);
 }
 
@@ -446,6 +459,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_handlers_register;
 
+	err = prestera_devlink_register(sw);
+	if (err)
+		goto err_dl_register;
+
 	err = prestera_create_ports(sw);
 	if (err)
 		goto err_ports_create;
@@ -453,6 +470,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	return 0;
 
 err_ports_create:
+	prestera_devlink_unregister(sw);
+err_dl_register:
 	prestera_event_handlers_unregister(sw);
 err_handlers_register:
 	prestera_rxtx_switch_fini(sw);
@@ -464,6 +483,7 @@ static int prestera_switch_init(struct prestera_switch *sw)
 static void prestera_switch_fini(struct prestera_switch *sw)
 {
 	prestera_destroy_ports(sw);
+	prestera_devlink_unregister(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
 	prestera_hw_switch_fini(sw);
@@ -474,7 +494,7 @@ int prestera_device_register(struct prestera_device *dev)
 	struct prestera_switch *sw;
 	int err;
 
-	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
+	sw = prestera_devlink_alloc();
 	if (!sw)
 		return -ENOMEM;
 
@@ -483,7 +503,7 @@ int prestera_device_register(struct prestera_device *dev)
 
 	err = prestera_switch_init(sw);
 	if (err) {
-		kfree(sw);
+		prestera_devlink_free(sw);
 		return err;
 	}
 
@@ -496,7 +516,7 @@ void prestera_device_unregister(struct prestera_device *dev)
 	struct prestera_switch *sw = dev->priv;
 
 	prestera_switch_fini(sw);
-	kfree(sw);
+	prestera_devlink_free(sw);
 }
 EXPORT_SYMBOL(prestera_device_unregister);
 
-- 
2.17.1


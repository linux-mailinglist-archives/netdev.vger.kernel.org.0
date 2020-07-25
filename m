Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA1822D855
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 17:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgGYPHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 11:07:37 -0400
Received: from mail-eopbgr20112.outbound.protection.outlook.com ([40.107.2.112]:19488
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727856AbgGYPHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 11:07:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RX7n5wWtUX+2fZUcDeEIzuZ6AEh7Sr3/6UXW6hxtaV+Z90W1xByqwXH8eGwRiROPyBaIP3hkw72BeYOcTAceZB368jQD7AP42L5ggiRisSXKDhke2Re+PeezaTx2HuWBxDk2p8B0eM8vXHu5HyoNWlSjJcxFSZtm8Wm3R6ef8kJwVjRfC8aZ9Lt9EYY1EizBVe9U5JNjZY57Qo/P/CRhOyLvj8e+b2wT17K2d3guKkfjElbWeSEgDr6ZzyfKwttz1aNBPi82ebA9xcHY4qQePH740PBjcc5+KvpI/0fMSJ/VyXgaUSuS96EgHhNWhIvJLbcKkAMHZ/wHXqas1aHKog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6XN8Giv81x5ZiLu+d0WaO/WLAdxahEYVdNx7AVPtJo=;
 b=Sd0XbWGNWX7G1Tt9GJjKDDK6bgm8JdO96AdOUu8BLL+UzQHUf9Kd+m9wPF6D2qHDwkzje5rrkEb1I4ZzMsIXnAavfPX9/orheEGkuYgQ/ESQLe+vG91cnT402FY4aRbvUsnbUffb1t621RukXvCR4YsFg5vjyMf9Gokc4R7PDBf2SrQ/5IeFmg/dp6k6Uwd8NV5ZLvHDNOEkcwn7+EJpRH6w0lESZ87/ZvsO4G/F6zYBoVmdkpTzmN1AujpKIY9bcx3AR2Rya5whk8paroXjulsMv8xLkawhHccZsXcycfaRZnG2HpsvJ1Lx9fhqEZp0BM4zwuHPdQiXIIH4xtoyYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6XN8Giv81x5ZiLu+d0WaO/WLAdxahEYVdNx7AVPtJo=;
 b=txv/RQ9cFG5IFAl4bZcUAE6W743nkvNOrrJIxZu8E5J3xqtm1wQzFgFYUyg8jLyIMmX5JdLR/ltFGyPkgsNVr+FfpF+I3NHfBhPNKcGrVcOS5fH3c2pmPVYYDWw7HEfv+08y/iCrkmsw6+Bj9PiGS8Bp0x3lDqxduArruSgcWOY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:33::15) by
 DB6P190MB0568.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:31::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.21; Sat, 25 Jul 2020 15:07:16 +0000
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d]) by DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d%7]) with mapi id 15.20.3216.028; Sat, 25 Jul 2020
 15:07:16 +0000
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
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [net-next v3 3/6] net: marvell: prestera: Add basic devlink support
Date:   Sat, 25 Jul 2020 18:06:48 +0300
Message-Id: <20200725150651.17029-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725150651.17029-1-vadym.kochan@plvision.eu>
References: <20200725150651.17029-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0032.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::45) To DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6PR05CA0032.eurprd05.prod.outlook.com (2603:10a6:20b:2e::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Sat, 25 Jul 2020 15:07:14 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5a35947-9884-46ed-0357-08d830ac6aee
X-MS-TrafficTypeDiagnostic: DB6P190MB0568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB05688081078F6E7B6BE56D7895740@DB6P190MB0568.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:428;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DLaMy70TeexV8QSgpfN1Ce6j8OjzHsE0Kosh0x/onA4Hgm0prb4/uZrM7VumvsS5MvGVoRmZ5QcO+WGP2B6ggrV054oilPiDvzxFzshjqo1OP87hqkSWWbyW1zr5CjotOoOXBsld0ey+zqZvpuTFIs2GwrMZ7MSV74gAfEXpx7PA0Arkuo2B19RrHa5h68dO3gHfxQkOxW0JeQ09RHpMbrOTmKptt7A2iDwBm7Yzz+us+FydKP35VguVzoCQ/B5ySswWw9Skk9OEfISmolqD9BfHwo9tp+34NwqHVb0w0d90G3WHvbY4xjibJKm5jJMYqdyTMkLecAjCQJ48Sg3r3zdcfHwEsZ+eVv4Ws6ttG7Oxe4RQJpUCPI0UijKcbv10
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0534.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39830400003)(376002)(366004)(396003)(346002)(2616005)(86362001)(26005)(1076003)(956004)(6506007)(8936002)(4326008)(16526019)(36756003)(6666004)(186003)(8676002)(83380400001)(44832011)(52116002)(5660300002)(6512007)(66556008)(6486002)(66476007)(508600001)(107886003)(66946007)(2906002)(110136005)(54906003)(316002)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: MXsCC/MU+W59VQw8S1rOzMQoQm/09Ar2j0oEBuBM2GSHvuu0LrsJzK/KtUIO341HngcEQUlaIeVmIVkyJaQSTSC2kB4f+W3r4j/Gpzz6iZ7qfKtdXa31N7ZWJCmeVaFFFxqMtEYZRjyDhuK6PkOhsvvFxgacPC+QqvKgy+ipvxB87qIvbSIZ+euqLXsKqhkNjz4HDg0ZZS7K9oQHmD3IitP/tNZzK18M639V2+8U+lK88hulGtNqpJx03FR0iY+3pPL0hg5k4mklzv4HNu81d2mfWnYQMiFzoUjkhZS36vhfUOAtNppgiXfZA4iFBdHc6i37tdZMF2TuGjHKfF+nm/ygdNUQ0CuTbEnzI00Wo3EGi3MASUFSmLLggFlzY26C26C8875cKqOrIgYw4QO2zPzhVNStbAiXMDXBbEGHPqxlnlN4yYXa7yZMepS0SUvoIbjkhuWZvsAsAOQ47o4AUkW5DmHRWYdGmQySrcl4icM=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a35947-9884-46ed-0357-08d830ac6aee
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2020 15:07:16.3524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rxbD5JCuAL3IWetGkDmm9ibGFEgRaFOwbgf3J94NvItMch5072mS5gA269a9grBLFGfuwb2lgAtKkgQjakTNy29siPXLpz/otpp2EeQ6vzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0568
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
 drivers/net/ethernet/marvell/prestera/Kconfig |   1 +
 .../net/ethernet/marvell/prestera/Makefile    |   2 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   4 +
 .../marvell/prestera/prestera_devlink.c       | 120 ++++++++++++++++++
 .../marvell/prestera/prestera_devlink.h       |  26 ++++
 .../ethernet/marvell/prestera/prestera_main.c |  28 +++-
 6 files changed, 176 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.h

diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
index d30e3e6d8b7b..7926960d1967 100644
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
index 5079d872e18a..f8abaaff5f21 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -11,6 +11,9 @@
 #include <linux/notifier.h>
 #include <uapi/linux/if_ether.h>
 #include <linux/workqueue.h>
+#include <net/devlink.h>
+
+#define PRESTERA_DRV_NAME	"prestera"
 
 struct prestera_fw_rev {
 	u16 maj;
@@ -63,6 +66,7 @@ struct prestera_port_caps {
 struct prestera_port {
 	struct net_device *dev;
 	struct prestera_switch *sw;
+	struct devlink_port dl_port;
 	u32 id;
 	u32 hw_id;
 	u32 dev_id;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
new file mode 100644
index 000000000000..dd09f6ee1c3e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
+
+#include <net/devlink.h>
+
+#include "prestera.h"
+#include "prestera_devlink.h"
+
+static int prestera_dl_info_get(struct devlink *dl,
+				struct devlink_info_req *req,
+				struct netlink_ext_ack *extack)
+{
+	struct prestera_switch *sw = devlink_priv(dl);
+	char buf[16];
+	int err = 0;
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
+	err = devlink_info_version_running_put(req,
+					       DEVLINK_INFO_VERSION_GENERIC_FW,
+					       buf);
+	if (err)
+		return err;
+
+	return 0;
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
+	if (err) {
+		dev_warn(sw->dev->dev, "devlink_register failed: %d\n", err);
+		return err;
+	}
+
+	return 0;
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
+	struct devlink *dl = priv_to_devlink(port->sw);
+	struct devlink_port_attrs attrs = {};
+	struct prestera_switch *sw;
+	int err;
+
+	sw = port->sw;
+	dl = priv_to_devlink(sw);
+
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = port->fp_id;
+	attrs.switch_id.id_len = sizeof(port->sw->id);
+	memcpy(attrs.switch_id.id, &port->sw->id, attrs.switch_id.id_len);
+
+	devlink_port_attrs_set(&port->dl_port, &attrs);
+
+	err = devlink_port_register(dl, &port->dl_port, port->fp_id);
+	if (err)
+		dev_err(sw->dev->dev, "devlink_port_register failed: %d\n", err);
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
index 000000000000..b0793c948148
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+ *
+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
+ *
+ */
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
index dbe146163004..f24a49bde7c3 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -14,6 +14,7 @@
 #include "prestera.h"
 #include "prestera_hw.h"
 #include "prestera_rxtx.h"
+#include "prestera_devlink.h"
 
 #define PRESTERA_MTU_DEFAULT 1536
 
@@ -175,6 +176,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_change_mtu = prestera_port_change_mtu,
 	.ndo_get_stats64 = prestera_port_get_stats64,
 	.ndo_set_mac_address = prestera_port_set_mac_address,
+	.ndo_get_devlink_port = prestera_devlink_get_port,
 };
 
 static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
@@ -224,9 +226,13 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
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
 	dev->netdev_ops = &netdev_ops;
 
@@ -285,11 +291,16 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	if (err)
 		goto err_register_netdev;
 
+	prestera_devlink_port_set(port);
+
 	return 0;
 
 err_register_netdev:
 	list_del(&port->list);
 err_port_init:
+	prestera_devlink_port_unregister(port);
+err_dl_port_register:
+err_port_info_get:
 	free_netdev(dev);
 	return err;
 }
@@ -299,8 +310,10 @@ static void prestera_port_destroy(struct prestera_port *port)
 	struct net_device *dev = port->dev;
 
 	cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
+	prestera_devlink_port_clear(port);
 	unregister_netdev(dev);
 	list_del(&port->list);
+	prestera_devlink_port_unregister(port);
 	free_netdev(dev);
 }
 
@@ -421,6 +434,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_handlers_register;
 
+	err = prestera_devlink_register(sw);
+	if (err)
+		goto err_dl_register;
+
 	err = prestera_create_ports(sw);
 	if (err)
 		goto err_ports_create;
@@ -428,6 +445,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	return 0;
 
 err_ports_create:
+	prestera_devlink_unregister(sw);
+err_dl_register:
 	prestera_event_handlers_unregister(sw);
 err_handlers_register:
 	prestera_rxtx_switch_fini(sw);
@@ -439,6 +458,7 @@ static int prestera_switch_init(struct prestera_switch *sw)
 static void prestera_switch_fini(struct prestera_switch *sw)
 {
 	prestera_destroy_ports(sw);
+	prestera_devlink_unregister(sw);
 	prestera_event_handlers_unregister(sw);
 	prestera_rxtx_switch_fini(sw);
 	prestera_hw_switch_fini(sw);
@@ -449,7 +469,7 @@ int prestera_device_register(struct prestera_device *dev)
 	struct prestera_switch *sw;
 	int err;
 
-	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
+	sw = prestera_devlink_alloc();
 	if (!sw)
 		return -ENOMEM;
 
@@ -458,7 +478,7 @@ int prestera_device_register(struct prestera_device *dev)
 
 	err = prestera_switch_init(sw);
 	if (err) {
-		kfree(sw);
+		prestera_devlink_free(sw);
 		return err;
 	}
 
@@ -471,7 +491,7 @@ void prestera_device_unregister(struct prestera_device *dev)
 	struct prestera_switch *sw = dev->priv;
 
 	prestera_switch_fini(sw);
-	kfree(sw);
+	prestera_devlink_free(sw);
 }
 EXPORT_SYMBOL(prestera_device_unregister);
 
-- 
2.17.1


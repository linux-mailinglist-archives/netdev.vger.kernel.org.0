Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6158342044
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 11:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408415AbfFLJIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 05:08:25 -0400
Received: from nsg-static-220.246.72.182.airtel.in ([182.72.246.220]:50319
        "EHLO swlab-raju.vitesse.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407738AbfFLJIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 05:08:23 -0400
Received: by swlab-raju.vitesse.org (Postfix, from userid 1001)
        id 7CE2315225D0; Wed, 12 Jun 2019 14:27:10 +0530 (IST)
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, f.fainelli@gmail.com, andrew@lunn.ch,
        Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Subject: [RFC, net-next v0 1/2] net: phy: mscc: Add PHY Netlink Interface along with Cable Diagnostics command
Date:   Wed, 12 Jun 2019 14:27:06 +0530
Message-Id: <1560329827-6345-2-git-send-email-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560329827-6345-1-git-send-email-Raju.Lakkaraju@microchip.com>
References: <1560329827-6345-1-git-send-email-Raju.Lakkaraju@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

Add the PHY Netlink interface driver to implement the cable
diagnostics of Microsemi Ethernet PHYs.

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/phy/Kconfig       |   6 ++
 drivers/net/phy/Makefile      |   1 +
 drivers/net/phy/phy.c         |  17 ++++
 drivers/net/phy/phy_netlink.c | 226 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h           |  88 ++++++++++++++++
 include/linux/phy_netlink.h   |  48 +++++++++
 6 files changed, 386 insertions(+)
 create mode 100644 drivers/net/phy/phy_netlink.c
 create mode 100644 include/linux/phy_netlink.h

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index db5645b..a105058 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -406,6 +406,12 @@ config MICROCHIP_T1_PHY
 	---help---
 	  Supports the LAN87XX PHYs.
 
+config PHY_NETLINK
+        tristate "PHY Netlink Interface"
+    depends on NET
+        ---help---
+          Supports the PHY netlink interface.
+
 config MICROSEMI_PHY
 	tristate "Microsemi PHYs"
 	---help---
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index bac339e..96aad9b 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_MICREL_KS8995MA)	+= spi_ks8995.o
 obj-$(CONFIG_MICREL_PHY)	+= micrel.o
 obj-$(CONFIG_MICROCHIP_PHY)	+= microchip.o
 obj-$(CONFIG_MICROCHIP_T1_PHY)	+= microchip_t1.o
+obj-$(CONFIG_PHY_NETLINK)	+= phy_netlink.o
 obj-$(CONFIG_MICROSEMI_PHY)	+= mscc.o
 obj-$(CONFIG_NATIONAL_PHY)	+= national.o
 obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d915076..29b2921 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1251,3 +1251,20 @@ int phy_ethtool_nway_reset(struct net_device *ndev)
 	return phy_restart_aneg(phydev);
 }
 EXPORT_SYMBOL(phy_ethtool_nway_reset);
+
+int phy_cabdiag_request(struct net_device *ndev, struct phy_cabdiag_req *cfg)
+{
+	struct phy_device *phydev = ndev->phydev;
+
+	if (!phydev)
+		return -ENODEV;
+
+	if (!phydev->drv)
+		return -EIO;
+
+	if (phydev->drv->request_cable_diag)
+		return phydev->drv->request_cable_diag(phydev, cfg);
+
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL(phy_cabdiag_request);
diff --git a/drivers/net/phy/phy_netlink.c b/drivers/net/phy/phy_netlink.c
new file mode 100644
index 0000000..896c1b2
--- /dev/null
+++ b/drivers/net/phy/phy_netlink.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2019 Microchip Technology
+
+#include <linux/bitmap.h>
+#include <linux/rtnetlink.h>
+#include <net/sock.h>
+#include <linux/phy.h>
+#include <linux/netdevice.h>
+#include <net/genetlink.h>
+#include <net/sock.h>
+#include <linux/phy_netlink.h>
+
+static struct genl_family phynl_genl_family;
+
+static const struct nla_policy cabdiag_op_policy[CABDIAG_OP_ATTR_MAX + 1] = {
+	[CABDIAG_OP_ATTR_NOOP]     = { .type = NLA_UNSPEC },
+	[CABDIAG_OP_ATTR_REQUEST]  = { .type = NLA_NESTED },
+};
+
+static const struct nla_policy
+cabdiag_pair_sta_policy[CABDIAG_PAIR_STA_ATTR_MAX + 1] = {
+	[CABDIAG_PAIR_STA_ATTR_NOOP]     = { .type = NLA_UNSPEC },
+	[CABDIAG_PAIR_STA_ATTR_STATUS]   = { .type = NLA_U8 },
+	[CABDIAG_PAIR_STA_ATTR_LENGTH]   = { .type = NLA_U8 },
+};
+
+static const struct nla_policy cabdiag_req_policy[CABDIAG_REQ_ATTR_MAX + 1] = {
+	[CABDIAG_REQ_ATTR_NOOP]       = { .type = NLA_UNSPEC },
+	[CABDIAG_REQ_ATTR_IFNAME]     = { .type = NLA_STRING },
+	[CABDIAG_REQ_ATTR_OP_STA]     = { .type = NLA_U8 },
+	[CABDIAG_REQ_ATTR_PAIRS_MASK] = { .type = NLA_U8 },
+	[CABDIAG_REQ_ATTR_TIMEOUT]    = { .type = NLA_U8 },
+	[CABDIAG_REQ_ATTR_STATUS]     =
+	NLA_POLICY_NESTED_ARRAY(cabdiag_pair_sta_policy),
+};
+
+static int phynl_interface_check(struct genl_info *info, const char *ifname)
+{
+	struct net *net = genl_info_net(info);
+	struct net_device *netdev;
+	int ret = 0;
+
+	netdev = dev_get_by_name(net, ifname);
+	if (netdev) {
+		if (netdev->phydev) {
+			if (!netdev->phydev->drv) {
+				pr_err("PHYNL: netdev->phydev->drv == NULL\n");
+				ret = -EINVAL;
+				goto out_dev_put;
+			}
+		} else {
+			pr_err("PHYNL: netdev->phydev == NULL\n");
+			ret = -EINVAL;
+			goto out_dev_put;
+		}
+	} else {
+		pr_err("PHYNL: can't find net device\n");
+		return -ENODEV;
+	}
+
+out_dev_put:
+	dev_put(netdev);
+
+	return ret;
+}
+
+static int phynl_cabdiag_request(struct genl_info *info, struct nlattr *nest)
+{
+	struct nlattr *tb[CABDIAG_REQ_ATTR_MAX + 1];
+	struct net *net = genl_info_net(info);
+	struct phy_cabdiag_req cfg;
+	struct net_device *netdev;
+	struct sk_buff *msg;
+	__be64 val_64;
+	char *ifname;
+	void *hdr;
+	int ret;
+
+	if (!nest) {
+		pr_err("PHYNL: nelink message error\n");
+		return -EINVAL;
+	}
+
+	memset(&cfg, 0, sizeof(struct phy_cabdiag_req));
+	ret = nla_parse_nested(tb, CABDIAG_REQ_ATTR_MAX, nest,
+			       cabdiag_req_policy, info->extack);
+	if (ret < 0)
+		return ret;
+
+	ifname = (char *)nla_data(tb[CABDIAG_REQ_ATTR_IFNAME]);
+	if (tb[CABDIAG_REQ_ATTR_IFNAME]) {
+		ret = phynl_interface_check(info, ifname);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (tb[CABDIAG_REQ_ATTR_PAIRS_MASK])
+		cfg.pairs_bitmask =
+		nla_get_u8(tb[CABDIAG_REQ_ATTR_PAIRS_MASK]);
+
+	if (tb[CABDIAG_REQ_ATTR_TIMEOUT])
+		cfg.timeout_cnt = nla_get_u8(tb[CABDIAG_REQ_ATTR_TIMEOUT]);
+
+	netdev = dev_get_by_name(net, ifname);
+
+	/* Initialize to default status */
+	cfg.pairs[CABDIAG_PAIR_A].length = CD_LENGTH_NOT_SUPPORTED;
+	cfg.pairs[CABDIAG_PAIR_B].length = CD_LENGTH_NOT_SUPPORTED;
+	cfg.pairs[CABDIAG_PAIR_C].length = CD_LENGTH_NOT_SUPPORTED;
+	cfg.pairs[CABDIAG_PAIR_D].length = CD_LENGTH_NOT_SUPPORTED;
+	cfg.pairs[CABDIAG_PAIR_A].status = CD_STATUS_NOT_SUPPORTED;
+	cfg.pairs[CABDIAG_PAIR_B].status = CD_STATUS_NOT_SUPPORTED;
+	cfg.pairs[CABDIAG_PAIR_C].status = CD_STATUS_NOT_SUPPORTED;
+	cfg.pairs[CABDIAG_PAIR_D].status = CD_STATUS_NOT_SUPPORTED;
+	ret = phy_cabdiag_request(netdev, &cfg);
+	if (ret < 0)
+		goto out_dev_put;
+
+	/* Reply back */
+	msg = genlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		ret = -ENOMEM;
+		goto out_dev_put;
+	}
+
+	hdr = genlmsg_put_reply(msg, info, &phynl_genl_family, 0,
+				PHYNL_CMD_CABDIAG);
+
+	nest = nla_nest_start(msg, CABDIAG_OP_ATTR_REQUEST | NLA_F_NESTED);
+	nla_put_u8(msg, CABDIAG_REQ_ATTR_OP_STA, cfg.op_status);
+	nla_put_u8(msg, CABDIAG_REQ_ATTR_PAIRS_MASK, cfg.pairs_bitmask);
+	nla_put_u8(msg, CABDIAG_REQ_ATTR_TIMEOUT, cfg.timeout_cnt);
+	val_64 = ((__be64)cfg.pairs[CABDIAG_PAIR_D].length << 56 |
+		  (__be64)cfg.pairs[CABDIAG_PAIR_D].status << 48 |
+		  (__be64)cfg.pairs[CABDIAG_PAIR_C].length << 40 |
+		  (__be64)cfg.pairs[CABDIAG_PAIR_C].status << 32 |
+		  (__be64)cfg.pairs[CABDIAG_PAIR_B].length << 24 |
+		  (__be64)cfg.pairs[CABDIAG_PAIR_B].status << 16 |
+		  (__be64)cfg.pairs[CABDIAG_PAIR_A].length << 8  |
+		  cfg.pairs[CABDIAG_PAIR_A].status);
+	nla_put_be64(msg, CABDIAG_REQ_ATTR_STATUS, val_64, 4);
+	nla_nest_end(msg, nest);
+
+	genlmsg_end(msg, hdr);
+	genlmsg_reply(msg, info);
+
+out_dev_put:
+	if (netdev)
+		dev_put(netdev);
+
+	return ret;
+}
+
+static int phynl_cabdiag_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[CABDIAG_OP_ATTR_MAX + 1];
+	int ret;
+
+	ret = genlmsg_parse(info->nlhdr, &phynl_genl_family, tb,
+			    CABDIAG_OP_ATTR_MAX, cabdiag_op_policy,
+			    info ? info->extack : NULL);
+	if (ret < 0) {
+		pr_err("PHYNL: genlmsg_parse returns:%d\n", ret);
+		return ret;
+	}
+
+	if (tb[CABDIAG_OP_ATTR_REQUEST]) {
+		ret = phynl_cabdiag_request(info, tb[CABDIAG_OP_ATTR_REQUEST]);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+#define PHYNL_GENL_NAME	"phynl"
+#define	PHYNL_GENL_VERSION	1
+#define	PHYNL_MCGRP_MONITOR	"phy_monitor"
+static struct genl_multicast_group phynl_genl_mcgroups[] = {
+	{
+		.name = PHYNL_MCGRP_MONITOR
+	},
+};
+
+static const struct genl_ops phynl_genl_ops[] = {
+	{
+		.cmd    = PHYNL_CMD_CABDIAG,
+		.doit   = phynl_cabdiag_doit,
+	},
+};
+
+static struct genl_family phynl_genl_family = {
+	.hdrsize	= 0,
+	.name		= PHYNL_GENL_NAME,
+	.version	= PHYNL_GENL_VERSION,
+	.netnsok	= true,
+	.parallel_ops	= false,
+	.ops		= phynl_genl_ops,
+	.n_ops		= ARRAY_SIZE(phynl_genl_ops),
+	.mcgrps		= phynl_genl_mcgroups,
+	.n_mcgrps	= ARRAY_SIZE(phynl_genl_mcgroups),
+};
+
+static int __init phynl_genl_init(void)
+{
+	int ret;
+
+	ret = genl_register_family(&phynl_genl_family);
+	if (ret < 0)
+		panic("PHYNL: Could not register genetlink family\n");
+
+	return 0;
+}
+
+static void __exit phynl_genl_exit(void)
+{
+	genl_unregister_family(&phynl_genl_family);
+}
+
+module_init(phynl_genl_init);
+module_exit(phynl_genl_exit);
+
+MODULE_DESCRIPTION("PHY Netlink Interface driver");
+MODULE_AUTHOR("Nagaraju Lakkaraju");
+MODULE_LICENSE("GPL");
+
diff --git a/include/linux/phy.h b/include/linux/phy.h
index d0af7d3..b045ddf 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -320,6 +320,91 @@ struct phy_c45_device_ids {
 	u32 device_ids[8];
 };
 
+#define CABDIAG_PAIR_A_MASK 0x0001
+#define CABDIAG_PAIR_B_MASK 0x0002
+#define CABDIAG_PAIR_C_MASK 0x0004
+#define CABDIAG_PAIR_D_MASK 0x0008
+enum phy_cabdiag_pairs {
+	CABDIAG_PAIR_A,
+	CABDIAG_PAIR_B,
+	CABDIAG_PAIR_C,
+	CABDIAG_PAIR_D,
+
+	CABDIAG_PAIR_CNT,
+};
+
+/**
+ * phy_cabdiag_op_sta - Cable diagnostics operational status
+ * CD_REQ_NONE                    - Unknown
+ * CD_REQ_INVALID_PAIR_MASK       - Invalid pair mask
+ * CD_REQ_INVALID_TIMEOUT         - Invalid Timeout counter
+ * CD_REQ_REJECTED_BUSY           - Previous command execution busy
+ * CD_STATUS_SUCCESS              - Operation success
+ * CD_STATUS_FAILED_TIMEOUT       - Failed due to Timeout
+ * CD_STATUS_FAILED_INVALID       - Status results invalid
+ */
+enum phy_cabdiag_op_sta {
+	CD_REQ_NONE,
+	CD_REQ_INVALID_PAIR_MASK,
+	CD_REQ_INVALID_TIMEOUT,
+	CD_REQ_REJECTED_BUSY,
+	CD_STATUS_SUCCESS,
+	CD_STATUS_FAILED_TIMEOUT,
+	CD_STATUS_FAILED_INVALID
+};
+
+#define CD_LENGTH_NOT_SUPPORTED 0xFF
+#define CD_STATUS_NOT_SUPPORTED 0xFF
+
+/**
+ * phy_cabdiag_sta_code - Cable diagnostics fault codes
+ * b0000 - 0100: Individual cable pair fault codes
+ * b10xx       : Cross pair short to pair 'xx'
+ * b11xx       : Abnormal Cross pair coupling with pair 'xx'
+ *    xx       : b00 - Pair-A,
+ *             : b01 - Pair-B,
+ *             : b10 - Pair-C,
+ *             : b11 - Pair-D
+ */
+enum phy_cabdiag_sta_code {
+	CD_NORMAL_PAIR            = 0x0,
+	CD_OPEN_PAIR              = 0x1,
+	CD_SHORTED_PAIR           = 0x2,
+	CD_ABNORMAL_TERMINATION   = 0x4,
+	CD_X_PAIR_SHORT_TO_PAIR_A = 0x8,
+	CD_X_PAIR_SHORT_TO_PAIR_B = 0x9,
+	CD_X_PAIR_SHORT_TO_PAIR_C = 0xA,
+	CD_X_PAIR_SHORT_TO_PAIR_D = 0xB,
+	CD_ABNORMAL_X_PAIR_A      = 0xC,
+	CD_ABNORMAL_X_PAIR_B      = 0xD,
+	CD_ABNORMAL_X_PAIR_C      = 0xE,
+	CD_ABNORMAL_X_PAIR_D      = 0xF
+};
+
+/**
+ * struct phy_cabdiag_pair_sta - PHY diagnostics pair status
+ * @status: Fault codes
+ * @length: Length in meters
+ */
+struct phy_cabdiag_pair_sta {
+	enum phy_cabdiag_sta_code status;
+	u8 length;
+};
+
+/**
+ * struct phy_cabdiag_req - PHY diagnostics request/status command
+ * @op_status: Cable Diagnostics Operational status
+ * @pairs_bitmask: Allows settings diag request just for a pair
+ * @timeout_cnt: Timeout count (i.e. Multiples of driver wait time)
+ * @pairs[CABDIAG_PAIR_CNT]: Status of 4 pairs of cable
+ */
+struct phy_cabdiag_req {
+	enum phy_cabdiag_op_sta op_status;
+	u8 pairs_bitmask;
+	u8 timeout_cnt;
+	struct phy_cabdiag_pair_sta pairs[CABDIAG_PAIR_CNT];
+};
+
 /* phy_device: An instance of a PHY
  *
  * drv: Pointer to the driver for this PHY instance
@@ -621,6 +706,8 @@ struct phy_driver {
 			    struct ethtool_tunable *tuna,
 			    const void *data);
 	int (*set_loopback)(struct phy_device *dev, bool enable);
+	int (*request_cable_diag)(struct phy_device *dev,
+				  struct phy_cabdiag_req *cfg);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
@@ -1170,6 +1257,7 @@ int phy_ethtool_get_link_ksettings(struct net_device *ndev,
 int phy_ethtool_set_link_ksettings(struct net_device *ndev,
 				   const struct ethtool_link_ksettings *cmd);
 int phy_ethtool_nway_reset(struct net_device *ndev);
+int phy_cabdiag_request(struct net_device *ndev, struct phy_cabdiag_req *cfg);
 
 #if IS_ENABLED(CONFIG_PHYLIB)
 int __init mdio_bus_init(void);
diff --git a/include/linux/phy_netlink.h b/include/linux/phy_netlink.h
new file mode 100644
index 0000000..2823d67
--- /dev/null
+++ b/include/linux/phy_netlink.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+#ifndef __PHY_NETLINK_H
+#define __PHY_NETLINK_H
+
+#include <linux/rtnetlink.h>
+#include <linux/phy.h>
+#include <linux/netdevice.h>
+#include <net/genetlink.h>
+
+/* Genetlink setup */
+enum {
+	PHYNL_CMD_NOOP,
+	PHYNL_CMD_CABDIAG,
+
+	__PHYNL_CMD_CNT,
+	PHYNL_CMD_MAX = (__PHYNL_CMD_CNT - 1)
+};
+
+enum {
+	CABDIAG_OP_ATTR_NOOP,
+	CABDIAG_OP_ATTR_REQUEST,
+
+	__CABDIAG_OP_ATTR_CNT,
+	CABDIAG_OP_ATTR_MAX = (__CABDIAG_OP_ATTR_CNT - 1)
+};
+
+enum {
+	CABDIAG_PAIR_STA_ATTR_NOOP,
+	CABDIAG_PAIR_STA_ATTR_STATUS,
+	CABDIAG_PAIR_STA_ATTR_LENGTH,
+
+	__CABDIAG_PAIR_STA_ATTR_CNT,
+	CABDIAG_PAIR_STA_ATTR_MAX = (__CABDIAG_PAIR_STA_ATTR_CNT - 1)
+};
+
+enum {
+	CABDIAG_REQ_ATTR_NOOP,
+	CABDIAG_REQ_ATTR_IFNAME,
+	CABDIAG_REQ_ATTR_OP_STA,
+	CABDIAG_REQ_ATTR_PAIRS_MASK,
+	CABDIAG_REQ_ATTR_TIMEOUT,
+	CABDIAG_REQ_ATTR_STATUS,
+
+	__CABDIAG_REQ_ATTR_CNT,
+	CABDIAG_REQ_ATTR_MAX = (__CABDIAG_REQ_ATTR_CNT - 1)
+};
+
+#endif /* __PHY_NETLINK_H */
-- 
2.7.4


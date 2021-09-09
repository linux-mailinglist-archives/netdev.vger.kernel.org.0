Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A0F404234
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 02:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348509AbhIIATJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 20:19:09 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:42468
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348223AbhIIATG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 20:19:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLUNoETa1lxDz8d99LQH6Tgejxbi4Jees7e1LbzVZoUEc6bNEknZ03xhtNhbYYuGFutO02TwOiwN6t3TBBeGiAkvsejKbH3jeItaK6+IF4H0gTHcq598EpTSVwspxW8IEJ3ykm3gC3yinv8ZSmNmCQuCwSo3J4mpjow/OeILoCNqdlOEPnSapB9Lkg4+PFR1wY07zRmtIv7GZuI1En7Eqx/m5qItrB4q9LROsEQKS7hQiDbwHlrbf2G6ZVtx9fh4I8/eOsVkKBSqhq9+eKb/v2t8tb6sZ0hLHTQwY6xlqXoauiDUNIJ6mK/HdqcHdyjXcVB4XQo2C9EcnuYSU7oacw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9aMxHzkYxYn0+rnlIUEa1CYSrVZLKo5KGhX827QeHFw=;
 b=E76eFkqAuFoSfgtq7cM5F4QnkTBMGfDS0H88ChHqqo3uHbqE3A5MSc6f9ussGB1izSRFxVGMtrtiGEMeNnMSDV0/CH/ZeD8o5CcRuSDE4vZGxx7sr71/VQO32zkbgtAFPhF9iJ71FBZtOIx+Vib76MbX3O6U6nrxYvw9xzEjzWPCkvaZw7371EvVVZqvT/pfWj7HxZ1LfP4lULPljNz/iZk3EoQV7dlT8ZChXdc9hKbU+XT7r90hwpVlDLK3Px8pASZlifQ+Qys7ouZ+lrJxyeQpm3u9Okaq2q/ca3IBnJFWlZjy3SUBk9FCLr6ygnibGCLZ6m/Wmdvq/wHCMk34FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9aMxHzkYxYn0+rnlIUEa1CYSrVZLKo5KGhX827QeHFw=;
 b=YxkdhD9zC9cyU0wcTTzQSVTl1L6ocguz5ujN6kera6Bk4kt5sIyZ0azddcrZaCa2j1mwq5kNmrRe/19vKQvQMpsr7WPx2u4wPwtka+VgqCiAjVTIBdv1KI8PEzDej5F21TQEjSu4mYO2uEvOBzybSmf49nPltkA9BwZeDeb4XTc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 9 Sep
 2021 00:17:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4478.026; Thu, 9 Sep 2021
 00:17:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net 1/2] net: dsa: sja1105: split out the probing code into a separate driver
Date:   Thu,  9 Sep 2021 03:17:35 +0300
Message-Id: <20210909001736.3769910-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210909001736.3769910-1-vladimir.oltean@nxp.com>
References: <20210909001736.3769910-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0058.eurprd04.prod.outlook.com
 (2603:10a6:802:2::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by VI1PR04CA0058.eurprd04.prod.outlook.com (2603:10a6:802:2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Thu, 9 Sep 2021 00:17:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d491e025-80f2-40f4-2d21-08d973274286
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6511EEBA24FFD79923B2DC27E0D59@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RF71ncWdNSayXsl3IK5NuNfomWvS1gnf68YhKJIlwFeiy4keTHu3koTT5o2GSEdnrHddR5p0mL2hub6kPRy9qiNvDhmo+IbmemJATH4Ju+zwCh3sE/k+x0xKR1iSuD7Y74iZXyDNv7HQZAoj+2/Y56HPrYflY9WyZPr9pcveVSASPKZwbXRRgWsmm6uDq35XZqnkA6R5w5FU2lkyqr6SQ5oJRlzXCWxAvXQgoPYxNPGCDzG8nAzERDOK0pDPAP4bXq9KAR0h7wY62rG8QgsTrOzYmV5QxVPFG+Qzd8hGK6GRD+XV3JlKZ/hccslGR6yHfmCqtq+A9u2ZoyomUq83mheTqyXXGR1em8RVc5WwVFPHg4sEnzdgd0299qmZKq7vKbuakC8ZLut0cwPUdGp9ZpVDn8p+FvE677sZwfhsWfgRdhMGfob1CJJ8rfqOY5XUODRS+gSb/VN3ke+UfET1hrOllEwjD5SqwLnY6jv9lxwO2hUBrqHqcNMifEJQyJysbCfS64vsDNt9pKwUJkwhfjdQzEeZS2NCV/YKfHsJAVaGszYRMmNRZrP3mTj0AJYSZulcoKp/q+9x7pSz+N3NRZHDfI6KY4G7RvT/PpfmBUaauUMFgs8bY7Qc6RFuT6B2PqfORvzndlCf8My3cEWUXji73eE18Jgsf9cMR6oKcQ0LByFB5F6C/hJ2IRukwqHl/be/KSBdvUBfY5f849oJ9VqfURbx1X/7ew+xVb6susJPUWFlqmf0f45dMjDHhQbYE69PMqAat+o1gAvlsOa2s+SuN/TycqJV9vcwdqWtSiw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(38100700002)(1076003)(4326008)(8676002)(2906002)(6506007)(66946007)(83380400001)(2616005)(956004)(66556008)(966005)(6486002)(26005)(6512007)(8936002)(66476007)(5660300002)(6666004)(36756003)(6916009)(52116002)(86362001)(44832011)(316002)(508600001)(186003)(30864003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fy2h9HceJ0cwrxPE/BdHo9fjil3vhPBHfuzp2pl+vpSUuZna1Cm9JRgzlqxh?=
 =?us-ascii?Q?1vtHjNjYvWwAKW+agGZ3OvIGk6iNTLI4IfeHNX4WeviUPqwKhWEAgITRggOM?=
 =?us-ascii?Q?AghGhbMyHIeq4w5QBJBZOW3M9RgDrg4fS2NgW/0LotVy4MzZxOboclWmGTpP?=
 =?us-ascii?Q?0v8OY1jTTh1vlRjsxgzcKV8eBPiFXGxjtJ9wJXq5qzlxEPxmzLLFf+tTKs9j?=
 =?us-ascii?Q?FXmnzGKwVr2QbxVgCG8gyVwgzISy1zjHDkyNsoRTLGKcVvAdrBNHQ4ZKOVK9?=
 =?us-ascii?Q?iTv2NlxSga5snRZzy5oU7pkifzVW8ddE+hpV7hth6OTKrzfHgcMsa6Hxu+gB?=
 =?us-ascii?Q?EsuPMa9auWu+5Ukxh5bOyLBUBm4/EHAuqvrmjpa1HkVDMdOlduoCJpfnlrv2?=
 =?us-ascii?Q?h7e6OoGmve0M2fhdcZQx9ffoKUwvs5Dl/TXjDJWlDOWlSd6488qBNX+jfHdx?=
 =?us-ascii?Q?Py5sJovWsZn5HN9hGPKdULxGoNPZWLPIE2DTjGpfsA9wiTAr7rnZLfXYsH+n?=
 =?us-ascii?Q?64jv1nFBa7Tv69E/vvm1hk7GurXRxLdXzok8cRsiSpfe42AUkPxwAY/LxABm?=
 =?us-ascii?Q?Mipawg/vqoWGs0HTKVRmcJrI7m4yGSQs9KljysUrMXYHkEiVrmXlQQc6kksV?=
 =?us-ascii?Q?RIkG+O0EdB3trLJat8UNM4L+hpv7Df77SfIvSze9chF+2bfVTEDOy95a3mId?=
 =?us-ascii?Q?zE1HuzMo3kh5NXdyki59ONRLm10cdrGFBloAAwRK71e4L+S6HSzWoWLRSJai?=
 =?us-ascii?Q?AX9tBr7mP9jUE5xCCw2mFPr4hJE63VTHEOd53LAWQ3cxb+wC2KDyms+9IEC5?=
 =?us-ascii?Q?td6UNp/4iSAtT8WO3/PjpLtniQLNNzprIK4sBrTJs1cToug8FymFoj/z1L9g?=
 =?us-ascii?Q?L9WryszVRvIFZDrprdIScb7CmYaikhsJyhantjZuj4RVMo38NBfXmVfwBYhV?=
 =?us-ascii?Q?ESyxYx8g2xsIQAeXPtWD7tNCkYvDHWyoFcKJf7ppFgfOn00RnjoyEwG5WUto?=
 =?us-ascii?Q?7KtZZtNEEOhUAYkqfrI4DM+OtRhDUAc2IKnSw9DnXmR/Tqtrgd6e8I0c0U/a?=
 =?us-ascii?Q?GXeUg+DrVzJpwrx1uKyT/6b2ZOAWZP+otGlAkLUERo1sV3VSSzuWD+JwQc1R?=
 =?us-ascii?Q?8m4S9/zL7Wa9QHosD0/SKxv4BabGQYJXIfy8HkNCJxoIpTX+fAlhtFWzwOLV?=
 =?us-ascii?Q?xDWE45EhSNM8Da83/NJPioQGVIGubwfT/0VUtn+089GxNUoMzJUqxWCnLN1v?=
 =?us-ascii?Q?x5frO+/iG4ondDEhz8uz0o9On5Hl+8LXM4m9wNG4AJkjxNFj1Guxj7dfOX8z?=
 =?us-ascii?Q?XRTmUlX234vIy6j9tXNiRdRi?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d491e025-80f2-40f4-2d21-08d973274286
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 00:17:50.8932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HS5IC1GDPkDN4HXfcOpRBa4YmvfuiP1MdKwGwiZP/6bHopYWGZeaQSlU33Z7BadkyejCVlQFd9kJ/mLOB+LF8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tag_sja1105.ko depends on the sja1105_switch_ops being exported by
the kernel before it can be inserted as a module, but at the same time,
it must be inserted into the kernel before the sja1105 driver can probe.

Solve this circular dependency by adding a third kernel module, which is
only responsible for probing the hardware and depends on the driver
which provides sja1105_switch_ops and interacts with DSA and with the
hardware at runtime, generally speaking.

Fixes: 994d2cbb08ca ("net: dsa: tag_sja1105: be dsa_loop-safe")
Link: https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/
Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/Kconfig               |   4 +
 drivers/net/dsa/sja1105/Makefile              |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 316 -----------------
 drivers/net/dsa/sja1105/sja1105_probe.c       | 322 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c         |  12 +
 .../net/dsa/sja1105/sja1105_static_config.c   |   1 +
 6 files changed, 341 insertions(+), 316 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_probe.c

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 1291bba3f3b6..33f948d9ea18 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -23,6 +23,10 @@ tristate "NXP SJA1105 Ethernet switch family support"
 	    - SJA1110C (Gen. 3, SGMII, TT-Ethernet, 100base-TX PHY, 7 ports)
 	    - SJA1110D (Gen. 3, SGMII, TT-Ethernet, no 100base-TX PHY, 7 ports)
 
+config NET_DSA_SJA1105_PROBE
+tristate "Actual driver that probes the hardware"
+	depends on NET_DSA_SJA1105
+
 config NET_DSA_SJA1105_PTP
 	bool "Support for the PTP clock on the NXP SJA1105 Ethernet switch"
 	depends on NET_DSA_SJA1105
diff --git a/drivers/net/dsa/sja1105/Makefile b/drivers/net/dsa/sja1105/Makefile
index 40d69e6c0bae..73b4281f8218 100644
--- a/drivers/net/dsa/sja1105/Makefile
+++ b/drivers/net/dsa/sja1105/Makefile
@@ -23,3 +23,5 @@ endif
 ifdef CONFIG_NET_DSA_SJA1105_VL
 sja1105-objs += sja1105_vl.o
 endif
+
+obj-$(CONFIG_NET_DSA_SJA1105_PROBE) += sja1105_probe.o
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2f8cc6686c38..01ef4839f631 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -10,12 +10,8 @@
 #include <linux/printk.h>
 #include <linux/spi/spi.h>
 #include <linux/errno.h>
-#include <linux/gpio/consumer.h>
 #include <linux/phylink.h>
 #include <linux/of.h>
-#include <linux/of_net.h>
-#include <linux/of_mdio.h>
-#include <linux/of_device.h>
 #include <linux/pcs/pcs-xpcs.h>
 #include <linux/netdev_features.h>
 #include <linux/netdevice.h>
@@ -27,17 +23,6 @@
 
 #define SJA1105_UNKNOWN_MULTICAST	0x010000000000ull
 
-static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int pulse_len,
-			     unsigned int startup_delay)
-{
-	gpiod_set_value_cansleep(gpio, 1);
-	/* Wait for minimum reset pulse length */
-	msleep(pulse_len);
-	gpiod_set_value_cansleep(gpio, 0);
-	/* Wait until chip is ready after reset */
-	msleep(startup_delay);
-}
-
 static void
 sja1105_port_allow_traffic(struct sja1105_l2_forwarding_entry *l2_fwd,
 			   int from, int to, bool allow)
@@ -1095,103 +1080,6 @@ static int sja1105_static_config_load(struct sja1105_private *priv)
 	return sja1105_static_config_upload(priv);
 }
 
-static int sja1105_parse_rgmii_delays(struct sja1105_private *priv)
-{
-	struct dsa_switch *ds = priv->ds;
-	int port;
-
-	for (port = 0; port < ds->num_ports; port++) {
-		if (!priv->fixed_link[port])
-			continue;
-
-		if (priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_RXID ||
-		    priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_ID)
-			priv->rgmii_rx_delay[port] = true;
-
-		if (priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_TXID ||
-		    priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_ID)
-			priv->rgmii_tx_delay[port] = true;
-
-		if ((priv->rgmii_rx_delay[port] || priv->rgmii_tx_delay[port]) &&
-		    !priv->info->setup_rgmii_delay)
-			return -EINVAL;
-	}
-	return 0;
-}
-
-static int sja1105_parse_ports_node(struct sja1105_private *priv,
-				    struct device_node *ports_node)
-{
-	struct device *dev = &priv->spidev->dev;
-	struct device_node *child;
-
-	for_each_available_child_of_node(ports_node, child) {
-		struct device_node *phy_node;
-		phy_interface_t phy_mode;
-		u32 index;
-		int err;
-
-		/* Get switch port number from DT */
-		if (of_property_read_u32(child, "reg", &index) < 0) {
-			dev_err(dev, "Port number not defined in device tree "
-				"(property \"reg\")\n");
-			of_node_put(child);
-			return -ENODEV;
-		}
-
-		/* Get PHY mode from DT */
-		err = of_get_phy_mode(child, &phy_mode);
-		if (err) {
-			dev_err(dev, "Failed to read phy-mode or "
-				"phy-interface-type property for port %d\n",
-				index);
-			of_node_put(child);
-			return -ENODEV;
-		}
-
-		phy_node = of_parse_phandle(child, "phy-handle", 0);
-		if (!phy_node) {
-			if (!of_phy_is_fixed_link(child)) {
-				dev_err(dev, "phy-handle or fixed-link "
-					"properties missing!\n");
-				of_node_put(child);
-				return -ENODEV;
-			}
-			/* phy-handle is missing, but fixed-link isn't.
-			 * So it's a fixed link. Default to PHY role.
-			 */
-			priv->fixed_link[index] = true;
-		} else {
-			of_node_put(phy_node);
-		}
-
-		priv->phy_mode[index] = phy_mode;
-	}
-
-	return 0;
-}
-
-static int sja1105_parse_dt(struct sja1105_private *priv)
-{
-	struct device *dev = &priv->spidev->dev;
-	struct device_node *switch_node = dev->of_node;
-	struct device_node *ports_node;
-	int rc;
-
-	ports_node = of_get_child_by_name(switch_node, "ports");
-	if (!ports_node)
-		ports_node = of_get_child_by_name(switch_node, "ethernet-ports");
-	if (!ports_node) {
-		dev_err(dev, "Incorrect bindings: absent \"ports\" node\n");
-		return -ENODEV;
-	}
-
-	rc = sja1105_parse_ports_node(priv, ports_node);
-	of_node_put(ports_node);
-
-	return rc;
-}
-
 /* Convert link speed from SJA1105 to ethtool encoding */
 static int sja1105_port_speed_to_ethtool(struct sja1105_private *priv,
 					 u64 speed)
@@ -3168,208 +3056,4 @@ const struct dsa_switch_ops sja1105_switch_ops = {
 };
 EXPORT_SYMBOL_GPL(sja1105_switch_ops);
 
-static const struct of_device_id sja1105_dt_ids[];
-
-static int sja1105_check_device_id(struct sja1105_private *priv)
-{
-	const struct sja1105_regs *regs = priv->info->regs;
-	u8 prod_id[SJA1105_SIZE_DEVICE_ID] = {0};
-	struct device *dev = &priv->spidev->dev;
-	const struct of_device_id *match;
-	u32 device_id;
-	u64 part_no;
-	int rc;
-
-	rc = sja1105_xfer_u32(priv, SPI_READ, regs->device_id, &device_id,
-			      NULL);
-	if (rc < 0)
-		return rc;
-
-	rc = sja1105_xfer_buf(priv, SPI_READ, regs->prod_id, prod_id,
-			      SJA1105_SIZE_DEVICE_ID);
-	if (rc < 0)
-		return rc;
-
-	sja1105_unpack(prod_id, &part_no, 19, 4, SJA1105_SIZE_DEVICE_ID);
-
-	for (match = sja1105_dt_ids; match->compatible[0]; match++) {
-		const struct sja1105_info *info = match->data;
-
-		/* Is what's been probed in our match table at all? */
-		if (info->device_id != device_id || info->part_no != part_no)
-			continue;
-
-		/* But is it what's in the device tree? */
-		if (priv->info->device_id != device_id ||
-		    priv->info->part_no != part_no) {
-			dev_warn(dev, "Device tree specifies chip %s but found %s, please fix it!\n",
-				 priv->info->name, info->name);
-			/* It isn't. No problem, pick that up. */
-			priv->info = info;
-		}
-
-		return 0;
-	}
-
-	dev_err(dev, "Unexpected {device ID, part number}: 0x%x 0x%llx\n",
-		device_id, part_no);
-
-	return -ENODEV;
-}
-
-static int sja1105_probe(struct spi_device *spi)
-{
-	struct device *dev = &spi->dev;
-	struct sja1105_private *priv;
-	size_t max_xfer, max_msg;
-	struct dsa_switch *ds;
-	int rc;
-
-	if (!dev->of_node) {
-		dev_err(dev, "No DTS bindings for SJA1105 driver\n");
-		return -EINVAL;
-	}
-
-	priv = devm_kzalloc(dev, sizeof(struct sja1105_private), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	/* Configure the optional reset pin and bring up switch */
-	priv->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
-	if (IS_ERR(priv->reset_gpio))
-		dev_dbg(dev, "reset-gpios not defined, ignoring\n");
-	else
-		sja1105_hw_reset(priv->reset_gpio, 1, 1);
-
-	/* Populate our driver private structure (priv) based on
-	 * the device tree node that was probed (spi)
-	 */
-	priv->spidev = spi;
-	spi_set_drvdata(spi, priv);
-
-	/* Configure the SPI bus */
-	spi->bits_per_word = 8;
-	rc = spi_setup(spi);
-	if (rc < 0) {
-		dev_err(dev, "Could not init SPI\n");
-		return rc;
-	}
-
-	/* In sja1105_xfer, we send spi_messages composed of two spi_transfers:
-	 * a small one for the message header and another one for the current
-	 * chunk of the packed buffer.
-	 * Check that the restrictions imposed by the SPI controller are
-	 * respected: the chunk buffer is smaller than the max transfer size,
-	 * and the total length of the chunk plus its message header is smaller
-	 * than the max message size.
-	 * We do that during probe time since the maximum transfer size is a
-	 * runtime invariant.
-	 */
-	max_xfer = spi_max_transfer_size(spi);
-	max_msg = spi_max_message_size(spi);
-
-	/* We need to send at least one 64-bit word of SPI payload per message
-	 * in order to be able to make useful progress.
-	 */
-	if (max_msg < SJA1105_SIZE_SPI_MSG_HEADER + 8) {
-		dev_err(dev, "SPI master cannot send large enough buffers, aborting\n");
-		return -EINVAL;
-	}
-
-	priv->max_xfer_len = SJA1105_SIZE_SPI_MSG_MAXLEN;
-	if (priv->max_xfer_len > max_xfer)
-		priv->max_xfer_len = max_xfer;
-	if (priv->max_xfer_len > max_msg - SJA1105_SIZE_SPI_MSG_HEADER)
-		priv->max_xfer_len = max_msg - SJA1105_SIZE_SPI_MSG_HEADER;
-
-	priv->info = of_device_get_match_data(dev);
-
-	/* Detect hardware device */
-	rc = sja1105_check_device_id(priv);
-	if (rc < 0) {
-		dev_err(dev, "Device ID check failed: %d\n", rc);
-		return rc;
-	}
-
-	dev_info(dev, "Probed switch chip: %s\n", priv->info->name);
-
-	ds = devm_kzalloc(dev, sizeof(*ds), GFP_KERNEL);
-	if (!ds)
-		return -ENOMEM;
-
-	ds->dev = dev;
-	ds->num_ports = priv->info->num_ports;
-	ds->ops = &sja1105_switch_ops;
-	ds->priv = priv;
-	priv->ds = ds;
-
-	mutex_init(&priv->ptp_data.lock);
-	mutex_init(&priv->mgmt_lock);
-
-	rc = sja1105_parse_dt(priv);
-	if (rc < 0) {
-		dev_err(ds->dev, "Failed to parse DT: %d\n", rc);
-		return rc;
-	}
-
-	/* Error out early if internal delays are required through DT
-	 * and we can't apply them.
-	 */
-	rc = sja1105_parse_rgmii_delays(priv);
-	if (rc < 0) {
-		dev_err(ds->dev, "RGMII delay not supported\n");
-		return rc;
-	}
-
-	if (IS_ENABLED(CONFIG_NET_SCH_CBS)) {
-		priv->cbs = devm_kcalloc(dev, priv->info->num_cbs_shapers,
-					 sizeof(struct sja1105_cbs_entry),
-					 GFP_KERNEL);
-		if (!priv->cbs)
-			return -ENOMEM;
-	}
-
-	return dsa_register_switch(priv->ds);
-}
-
-static int sja1105_remove(struct spi_device *spi)
-{
-	struct sja1105_private *priv = spi_get_drvdata(spi);
-	struct dsa_switch *ds = priv->ds;
-
-	dsa_unregister_switch(ds);
-
-	return 0;
-}
-
-static const struct of_device_id sja1105_dt_ids[] = {
-	{ .compatible = "nxp,sja1105e", .data = &sja1105e_info },
-	{ .compatible = "nxp,sja1105t", .data = &sja1105t_info },
-	{ .compatible = "nxp,sja1105p", .data = &sja1105p_info },
-	{ .compatible = "nxp,sja1105q", .data = &sja1105q_info },
-	{ .compatible = "nxp,sja1105r", .data = &sja1105r_info },
-	{ .compatible = "nxp,sja1105s", .data = &sja1105s_info },
-	{ .compatible = "nxp,sja1110a", .data = &sja1110a_info },
-	{ .compatible = "nxp,sja1110b", .data = &sja1110b_info },
-	{ .compatible = "nxp,sja1110c", .data = &sja1110c_info },
-	{ .compatible = "nxp,sja1110d", .data = &sja1110d_info },
-	{ /* sentinel */ },
-};
-MODULE_DEVICE_TABLE(of, sja1105_dt_ids);
-
-static struct spi_driver sja1105_driver = {
-	.driver = {
-		.name  = "sja1105",
-		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(sja1105_dt_ids),
-	},
-	.probe  = sja1105_probe,
-	.remove = sja1105_remove,
-};
-
-module_spi_driver(sja1105_driver);
-
-MODULE_AUTHOR("Vladimir Oltean <olteanv@gmail.com>");
-MODULE_AUTHOR("Georg Waibel <georg.waibel@sensor-technik.de>");
-MODULE_DESCRIPTION("SJA1105 Driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/sja1105/sja1105_probe.c b/drivers/net/dsa/sja1105/sja1105_probe.c
new file mode 100644
index 000000000000..debb9bcd788c
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_probe.c
@@ -0,0 +1,322 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2021 NXP */
+#include <linux/gpio/consumer.h>
+#include <linux/of_device.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
+#include <linux/spi/spi.h>
+#include "sja1105.h"
+
+static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int pulse_len,
+			     unsigned int startup_delay)
+{
+	gpiod_set_value_cansleep(gpio, 1);
+	/* Wait for minimum reset pulse length */
+	msleep(pulse_len);
+	gpiod_set_value_cansleep(gpio, 0);
+	/* Wait until chip is ready after reset */
+	msleep(startup_delay);
+}
+
+static int sja1105_parse_rgmii_delays(struct sja1105_private *priv)
+{
+	struct dsa_switch *ds = priv->ds;
+	int port;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (!priv->fixed_link[port])
+			continue;
+
+		if (priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_RXID ||
+		    priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_ID)
+			priv->rgmii_rx_delay[port] = true;
+
+		if (priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_TXID ||
+		    priv->phy_mode[port] == PHY_INTERFACE_MODE_RGMII_ID)
+			priv->rgmii_tx_delay[port] = true;
+
+		if ((priv->rgmii_rx_delay[port] || priv->rgmii_tx_delay[port]) &&
+		    !priv->info->setup_rgmii_delay)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static int sja1105_parse_ports_node(struct sja1105_private *priv,
+				    struct device_node *ports_node)
+{
+	struct device *dev = &priv->spidev->dev;
+	struct device_node *child;
+
+	for_each_available_child_of_node(ports_node, child) {
+		struct device_node *phy_node;
+		phy_interface_t phy_mode;
+		u32 index;
+		int err;
+
+		/* Get switch port number from DT */
+		if (of_property_read_u32(child, "reg", &index) < 0) {
+			dev_err(dev, "Port number not defined in device tree "
+				"(property \"reg\")\n");
+			of_node_put(child);
+			return -ENODEV;
+		}
+
+		/* Get PHY mode from DT */
+		err = of_get_phy_mode(child, &phy_mode);
+		if (err) {
+			dev_err(dev, "Failed to read phy-mode or "
+				"phy-interface-type property for port %d\n",
+				index);
+			of_node_put(child);
+			return -ENODEV;
+		}
+
+		phy_node = of_parse_phandle(child, "phy-handle", 0);
+		if (!phy_node) {
+			if (!of_phy_is_fixed_link(child)) {
+				dev_err(dev, "phy-handle or fixed-link "
+					"properties missing!\n");
+				of_node_put(child);
+				return -ENODEV;
+			}
+			/* phy-handle is missing, but fixed-link isn't.
+			 * So it's a fixed link. Default to PHY role.
+			 */
+			priv->fixed_link[index] = true;
+		} else {
+			of_node_put(phy_node);
+		}
+
+		priv->phy_mode[index] = phy_mode;
+	}
+
+	return 0;
+}
+
+static int sja1105_parse_dt(struct sja1105_private *priv)
+{
+	struct device *dev = &priv->spidev->dev;
+	struct device_node *switch_node = dev->of_node;
+	struct device_node *ports_node;
+	int rc;
+
+	ports_node = of_get_child_by_name(switch_node, "ports");
+	if (!ports_node)
+		ports_node = of_get_child_by_name(switch_node, "ethernet-ports");
+	if (!ports_node) {
+		dev_err(dev, "Incorrect bindings: absent \"ports\" node\n");
+		return -ENODEV;
+	}
+
+	rc = sja1105_parse_ports_node(priv, ports_node);
+	of_node_put(ports_node);
+
+	return rc;
+}
+
+static const struct of_device_id sja1105_dt_ids[];
+
+static int sja1105_check_device_id(struct sja1105_private *priv)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	u8 prod_id[SJA1105_SIZE_DEVICE_ID] = {0};
+	struct device *dev = &priv->spidev->dev;
+	const struct of_device_id *match;
+	u32 device_id;
+	u64 part_no;
+	int rc;
+
+	rc = sja1105_xfer_u32(priv, SPI_READ, regs->device_id, &device_id,
+			      NULL);
+	if (rc < 0)
+		return rc;
+
+	rc = sja1105_xfer_buf(priv, SPI_READ, regs->prod_id, prod_id,
+			      SJA1105_SIZE_DEVICE_ID);
+	if (rc < 0)
+		return rc;
+
+	sja1105_unpack(prod_id, &part_no, 19, 4, SJA1105_SIZE_DEVICE_ID);
+
+	for (match = sja1105_dt_ids; match->compatible[0]; match++) {
+		const struct sja1105_info *info = match->data;
+
+		/* Is what's been probed in our match table at all? */
+		if (info->device_id != device_id || info->part_no != part_no)
+			continue;
+
+		/* But is it what's in the device tree? */
+		if (priv->info->device_id != device_id ||
+		    priv->info->part_no != part_no) {
+			dev_warn(dev, "Device tree specifies chip %s but found %s, please fix it!\n",
+				 priv->info->name, info->name);
+			/* It isn't. No problem, pick that up. */
+			priv->info = info;
+		}
+
+		return 0;
+	}
+
+	dev_err(dev, "Unexpected {device ID, part number}: 0x%x 0x%llx\n",
+		device_id, part_no);
+
+	return -ENODEV;
+}
+
+static int sja1105_probe(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct sja1105_private *priv;
+	size_t max_xfer, max_msg;
+	struct dsa_switch *ds;
+	int rc;
+
+	if (!dev->of_node) {
+		dev_err(dev, "No DTS bindings for SJA1105 driver\n");
+		return -EINVAL;
+	}
+
+	priv = devm_kzalloc(dev, sizeof(struct sja1105_private), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	/* Configure the optional reset pin and bring up switch */
+	priv->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(priv->reset_gpio))
+		dev_dbg(dev, "reset-gpios not defined, ignoring\n");
+	else
+		sja1105_hw_reset(priv->reset_gpio, 1, 1);
+
+	/* Populate our driver private structure (priv) based on
+	 * the device tree node that was probed (spi)
+	 */
+	priv->spidev = spi;
+	spi_set_drvdata(spi, priv);
+
+	/* Configure the SPI bus */
+	spi->bits_per_word = 8;
+	rc = spi_setup(spi);
+	if (rc < 0) {
+		dev_err(dev, "Could not init SPI\n");
+		return rc;
+	}
+
+	/* In sja1105_xfer, we send spi_messages composed of two spi_transfers:
+	 * a small one for the message header and another one for the current
+	 * chunk of the packed buffer.
+	 * Check that the restrictions imposed by the SPI controller are
+	 * respected: the chunk buffer is smaller than the max transfer size,
+	 * and the total length of the chunk plus its message header is smaller
+	 * than the max message size.
+	 * We do that during probe time since the maximum transfer size is a
+	 * runtime invariant.
+	 */
+	max_xfer = spi_max_transfer_size(spi);
+	max_msg = spi_max_message_size(spi);
+
+	/* We need to send at least one 64-bit word of SPI payload per message
+	 * in order to be able to make useful progress.
+	 */
+	if (max_msg < SJA1105_SIZE_SPI_MSG_HEADER + 8) {
+		dev_err(dev, "SPI master cannot send large enough buffers, aborting\n");
+		return -EINVAL;
+	}
+
+	priv->max_xfer_len = SJA1105_SIZE_SPI_MSG_MAXLEN;
+	if (priv->max_xfer_len > max_xfer)
+		priv->max_xfer_len = max_xfer;
+	if (priv->max_xfer_len > max_msg - SJA1105_SIZE_SPI_MSG_HEADER)
+		priv->max_xfer_len = max_msg - SJA1105_SIZE_SPI_MSG_HEADER;
+
+	priv->info = of_device_get_match_data(dev);
+
+	/* Detect hardware device */
+	rc = sja1105_check_device_id(priv);
+	if (rc < 0) {
+		dev_err(dev, "Device ID check failed: %d\n", rc);
+		return rc;
+	}
+
+	dev_info(dev, "Probed switch chip: %s\n", priv->info->name);
+
+	ds = devm_kzalloc(dev, sizeof(*ds), GFP_KERNEL);
+	if (!ds)
+		return -ENOMEM;
+
+	ds->dev = dev;
+	ds->num_ports = priv->info->num_ports;
+	ds->ops = &sja1105_switch_ops;
+	ds->priv = priv;
+	priv->ds = ds;
+
+	mutex_init(&priv->ptp_data.lock);
+	mutex_init(&priv->mgmt_lock);
+
+	rc = sja1105_parse_dt(priv);
+	if (rc < 0) {
+		dev_err(ds->dev, "Failed to parse DT: %d\n", rc);
+		return rc;
+	}
+
+	/* Error out early if internal delays are required through DT
+	 * and we can't apply them.
+	 */
+	rc = sja1105_parse_rgmii_delays(priv);
+	if (rc < 0) {
+		dev_err(ds->dev, "RGMII delay not supported\n");
+		return rc;
+	}
+
+	if (IS_ENABLED(CONFIG_NET_SCH_CBS)) {
+		priv->cbs = devm_kcalloc(dev, priv->info->num_cbs_shapers,
+					 sizeof(struct sja1105_cbs_entry),
+					 GFP_KERNEL);
+		if (!priv->cbs)
+			return -ENOMEM;
+	}
+
+	return dsa_register_switch(priv->ds);
+}
+
+static int sja1105_remove(struct spi_device *spi)
+{
+	struct sja1105_private *priv = spi_get_drvdata(spi);
+	struct dsa_switch *ds = priv->ds;
+
+	dsa_unregister_switch(ds);
+
+	return 0;
+}
+
+static const struct of_device_id sja1105_dt_ids[] = {
+	{ .compatible = "nxp,sja1105e", .data = &sja1105e_info },
+	{ .compatible = "nxp,sja1105t", .data = &sja1105t_info },
+	{ .compatible = "nxp,sja1105p", .data = &sja1105p_info },
+	{ .compatible = "nxp,sja1105q", .data = &sja1105q_info },
+	{ .compatible = "nxp,sja1105r", .data = &sja1105r_info },
+	{ .compatible = "nxp,sja1105s", .data = &sja1105s_info },
+	{ .compatible = "nxp,sja1110a", .data = &sja1110a_info },
+	{ .compatible = "nxp,sja1110b", .data = &sja1110b_info },
+	{ .compatible = "nxp,sja1110c", .data = &sja1110c_info },
+	{ .compatible = "nxp,sja1110d", .data = &sja1110d_info },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, sja1105_dt_ids);
+
+static struct spi_driver sja1105_driver = {
+	.driver = {
+		.name  = "sja1105",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(sja1105_dt_ids),
+	},
+	.probe  = sja1105_probe,
+	.remove = sja1105_remove,
+};
+
+module_spi_driver(sja1105_driver);
+
+MODULE_AUTHOR("Vladimir Oltean <olteanv@gmail.com>");
+MODULE_AUTHOR("Georg Waibel <georg.waibel@sensor-technik.de>");
+MODULE_DESCRIPTION("SJA1105 Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index d60a530d0272..420c21bfd6b5 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -118,6 +118,7 @@ int sja1105_xfer_buf(const struct sja1105_private *priv,
 {
 	return sja1105_xfer(priv, rw, reg_addr, buf, len, NULL);
 }
+EXPORT_SYMBOL_GPL(sja1105_xfer_buf);
 
 /* If @rw is:
  * - SPI_WRITE: creates and sends an SPI write message at absolute
@@ -172,6 +173,7 @@ int sja1105_xfer_u32(const struct sja1105_private *priv,
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(sja1105_xfer_u32);
 
 static int sja1105et_reset_cmd(struct dsa_switch *ds)
 {
@@ -601,6 +603,7 @@ const struct sja1105_info sja1105e_info = {
 	.supports_rgmii		= {true, true, true, true, true},
 	.name			= "SJA1105E",
 };
+EXPORT_SYMBOL_GPL(sja1105e_info);
 
 const struct sja1105_info sja1105t_info = {
 	.device_id		= SJA1105T_DEVICE_ID,
@@ -633,6 +636,7 @@ const struct sja1105_info sja1105t_info = {
 	.supports_rgmii		= {true, true, true, true, true},
 	.name			= "SJA1105T",
 };
+EXPORT_SYMBOL_GPL(sja1105t_info);
 
 const struct sja1105_info sja1105p_info = {
 	.device_id		= SJA1105PR_DEVICE_ID,
@@ -666,6 +670,7 @@ const struct sja1105_info sja1105p_info = {
 	.supports_rgmii		= {true, true, true, true, true},
 	.name			= "SJA1105P",
 };
+EXPORT_SYMBOL_GPL(sja1105p_info);
 
 const struct sja1105_info sja1105q_info = {
 	.device_id		= SJA1105QS_DEVICE_ID,
@@ -699,6 +704,7 @@ const struct sja1105_info sja1105q_info = {
 	.supports_rgmii		= {true, true, true, true, true},
 	.name			= "SJA1105Q",
 };
+EXPORT_SYMBOL_GPL(sja1105q_info);
 
 const struct sja1105_info sja1105r_info = {
 	.device_id		= SJA1105PR_DEVICE_ID,
@@ -735,6 +741,7 @@ const struct sja1105_info sja1105r_info = {
 	.supports_sgmii		= {false, false, false, false, true},
 	.name			= "SJA1105R",
 };
+EXPORT_SYMBOL_GPL(sja1105r_info);
 
 const struct sja1105_info sja1105s_info = {
 	.device_id		= SJA1105QS_DEVICE_ID,
@@ -771,6 +778,7 @@ const struct sja1105_info sja1105s_info = {
 	.supports_sgmii		= {false, false, false, false, true},
 	.name			= "SJA1105S",
 };
+EXPORT_SYMBOL_GPL(sja1105s_info);
 
 const struct sja1105_info sja1110a_info = {
 	.device_id		= SJA1110_DEVICE_ID,
@@ -821,6 +829,7 @@ const struct sja1105_info sja1110a_info = {
 				   SJA1105_PHY_BASE_T1},
 	.name			= "SJA1110A",
 };
+EXPORT_SYMBOL_GPL(sja1110a_info);
 
 const struct sja1105_info sja1110b_info = {
 	.device_id		= SJA1110_DEVICE_ID,
@@ -871,6 +880,7 @@ const struct sja1105_info sja1110b_info = {
 				   SJA1105_NO_PHY},
 	.name			= "SJA1110B",
 };
+EXPORT_SYMBOL_GPL(sja1110b_info);
 
 const struct sja1105_info sja1110c_info = {
 	.device_id		= SJA1110_DEVICE_ID,
@@ -921,6 +931,7 @@ const struct sja1105_info sja1110c_info = {
 				   SJA1105_NO_PHY},
 	.name			= "SJA1110C",
 };
+EXPORT_SYMBOL_GPL(sja1110c_info);
 
 const struct sja1105_info sja1110d_info = {
 	.device_id		= SJA1110_DEVICE_ID,
@@ -971,3 +982,4 @@ const struct sja1105_info sja1110d_info = {
 				   SJA1105_NO_PHY},
 	.name			= "SJA1110D",
 };
+EXPORT_SYMBOL_GPL(sja1110d_info);
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 7a422ef4deb6..d5bca0d43b21 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -52,6 +52,7 @@ void sja1105_unpack(const void *buf, u64 *val, int start, int end, size_t len)
 		       start, end);
 	dump_stack();
 }
+EXPORT_SYMBOL_GPL(sja1105_unpack);
 
 void sja1105_packing(void *buf, u64 *val, int start, int end,
 		     size_t len, enum packing_op op)
-- 
2.25.1


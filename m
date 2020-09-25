Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BC52786EA
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgIYMTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:19:41 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:63262
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728148AbgIYMTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:19:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFrO9XDkX1iV1Z6ex1MjmWeDeU4YbMtw5pj7ACPTsqsaCPjuvo8cJQqzAb6DYns8xakWydz8/BzGzXEoiF21GEATpRJOawagSt4BIiZTIL0dZqfMoUuEgZeitHwTr/4It2U0NLaXmosI9zcWmbwZbk7jGLxxDCWsxPD30iAv4y9LDylaqu6JJIClHYUZUnoOKq3IH9nmfGu4ICuHCe7SOa0yrtKW751BaLEwBv4ySx0DHsuKy1FT/VhvLKXStbzSvf5/EddbhFysTEWF3Imnvydbx/tKQ2Au0o4KRPlNeyeJSKJvc3/Lh70K6jmuji8Qtr2dWSq/FHAsBhqaV7JqYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWRCP0kmQUEKPXSHq6huGYpO3drytS/cZmW+c0FmlLA=;
 b=XATY+PmwiXJwOp4lXAsoGZLJ83noG0AzHSn8tipCKDTEriV5wIBTNN9Ev/8Y0zu7W1Sn9AMeMPTAY5ogSwJ44F8Oo9BMyWQyZSAW1yt2unhbYyg/lgBr8lOES4ZRlGr8vlPjc62Bdl8cuN0CZ+tPydn4+1fnT4zAlUflBCKtYh8BBiD0y4PKgGRm0dGv5HPFK8GwVPX6RCEzhFHZiEfwDjR5XiZEkt4mAIceuHS9jnsHTmaJ+45Btosf/gnDL1ZmdQB3dBjuzyVjYhGA1im/XpmmJJIShi73WaeO64VTzlElQ50osKcLDNzNX4yBnsHBAfxT5KysaLQaTK03204gHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWRCP0kmQUEKPXSHq6huGYpO3drytS/cZmW+c0FmlLA=;
 b=k5as5AewjjiZnSPoRZXM9yVd0+eDFEcSF/ILaMuPGG3nkN4wYpFrC67Fh+5dAyyfgO0lR0MH9DYAD+YF9EozbMcCGoMh9xlUwvZ9iXGGR1Xp+U358j8kSa2mWa5TtXdqrLUQBIM/blaU8SkRehZca9O2K3pCNieONBN1mjNpykE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3550.eurprd04.prod.outlook.com (2603:10a6:803:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 12:19:27 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 12:19:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 07/14] net: mscc: ocelot: introduce conversion helpers between port and netdev
Date:   Fri, 25 Sep 2020 15:18:48 +0300
Message-Id: <20200925121855.370863-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925121855.370863-1-vladimir.oltean@nxp.com>
References: <20200925121855.370863-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0007.eurprd08.prod.outlook.com
 (2603:10a6:803:104::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VE1PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:803:104::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 12:19:26 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c1e52ca9-cb8b-4f90-f60a-08d8614d3ed8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3550671C1089F403D0AA8BBDE0360@VI1PR0402MB3550.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zUkAdiRo9/JNE0AefaTsyDF1sgOfh48rgp95SkxbUxO4qni2qiuCWb8m7UXduQASskUVlZa/HZvWgflgEQXxy04yDA8d2xA8V+VyXOUNxUGfXaE6Vb7nawiFkWKG21/EoS24oUDI4KicR6RCvAEGU3DN0CKc/Wt0XTqhW9WF9CxtPrcLOmFN8tzQE5bz3x/+eUK6aTXruZK6BhSvjcpHaoNUBUd628nr/6wkUZzyr5Vkuyn51rjPJ+sQhlT6p298pA8ik29X90u7bqzvh8jd12L+uwCX9AozsIjCoxBhk2Fnfu35B0O05ELlJ6bggucQocJiJb8PjLjG3uDj2j2GfxWz2iZffKJnpT62a4dq08p09bu5ExvLQ3qqc68xSc4R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(66946007)(66556008)(36756003)(26005)(4326008)(8676002)(956004)(2616005)(69590400008)(86362001)(66476007)(44832011)(52116002)(6916009)(6666004)(1076003)(6512007)(8936002)(6506007)(186003)(7416002)(5660300002)(6486002)(2906002)(316002)(478600001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RarcnWtPAE6qhy0Io1LrgabzpbyjJmrm589a4lRHAGkkDlV9+E7dOh90SmctZSr7kX0Sfrzp4RGFQPDwoRiJJur+AKkFxwXG476MNoNhi37I5MfeQMJ3ery/34keAsvzgcF7/pRGznuCWPTyfzyvQi6WN8gAxJ6yIFIcjL4pCInIICTOqcAWYZPPxYAXYuCz116nEWvdorkl3cQR09pfPy2ZUhOny7D3JWwtV7A2ztOeNHaMNwyiLlWsH70fPqY6hC36LzTdyP/Fdqy860XnVPhlEN03bUVKHzVRXs6TO3Ha1fzocRzjiIjz29MHt8UMXs4iHJ/Pr6MLDzLtx08MKTr7CFIbqWmGrmYnfSspK65X/t0iibay0aDGU6wWeEY1TnBDVbp90spNX4GfHokvoSkcwBdixRQgHY0xaqYoNR7kotjamFElrlKEldt//1zUcIbWMbySgvB4i1vagfV5Baw+ZFAzEBaj0N0LO0OEWkh87SYSP7FG+wiXnBySh9f30iWmVqKMGyYlZpw8220ev+K2yhE1mhYHI/JaxfSJAkNcblgISDwefz5PJqTjJ9FeSaXwSgwvDvO/HoDvFMtcjbR1cHRT8Qwa80z1H/Uf6QPr3cfJlC4srkq/5jK2muonoZEOCRrmHEV/yWNuoryyuA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e52ca9-cb8b-4f90-f60a-08d8614d3ed8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 12:19:26.9826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KVbQIice9JKLkJP0hm5ltJzxS+/e/YFL/+2y9Fyuq0kZMvvv3WdTq0NfYlrJV82y/rsqMKnEJ4Cpbyt1uSfEqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the mscc_ocelot_switch_lib is common between a pure switchdev and
a DSA driver, the procedure of retrieving a net_device for a certain
port index differs, as those are registered by their individual
front-ends.

Up to now that has been dealt with by always passing the port index to
the switch library, but now, we're going to need to work with net_device
pointers from the tc-flower offload, for things like indev, or mirred.
It is not desirable to refactor that, so let's make sure that the flower
offload core has the ability to translate between a net_device and a
port index properly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c             | 22 ++++++++++++++++
 drivers/net/dsa/ocelot/felix.h             |  3 +++
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  2 ++
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  2 ++
 drivers/net/ethernet/mscc/ocelot.h         |  2 ++
 drivers/net/ethernet/mscc/ocelot_net.c     | 30 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  2 ++
 include/soc/mscc/ocelot.h                  |  2 ++
 8 files changed, 65 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 8ebdebc44c72..a0b803fdbac8 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -810,3 +810,25 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.cls_flower_stats	= felix_cls_flower_stats,
 	.port_setup_tc		= felix_port_setup_tc,
 };
+
+struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_switch *ds = felix->ds;
+
+	if (!dsa_is_user_port(ds, port))
+		return NULL;
+
+	return dsa_to_port(ds, port)->slave;
+}
+
+int felix_netdev_to_port(struct net_device *dev)
+{
+	struct dsa_port *dp;
+
+	dp = dsa_port_from_netdev(dev);
+	if (IS_ERR(dp))
+		return -EINVAL;
+
+	return dp->index;
+}
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 6f6383904cc9..83bab486c61a 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -51,4 +51,7 @@ struct felix {
 	resource_size_t			imdio_base;
 };
 
+struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
+int felix_netdev_to_port(struct net_device *dev);
+
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 601853e05754..66e991ab9df5 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -867,6 +867,8 @@ static u16 vsc9959_wm_enc(u16 value)
 static const struct ocelot_ops vsc9959_ops = {
 	.reset			= vsc9959_reset,
 	.wm_enc			= vsc9959_wm_enc,
+	.port_to_netdev		= felix_port_to_netdev,
+	.netdev_to_port		= felix_netdev_to_port,
 };
 
 static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index b921ad98e90a..87ca36c77606 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -920,6 +920,8 @@ static u16 vsc9953_wm_enc(u16 value)
 static const struct ocelot_ops vsc9953_ops = {
 	.reset			= vsc9953_reset,
 	.wm_enc			= vsc9953_wm_enc,
+	.port_to_netdev		= felix_port_to_netdev,
+	.netdev_to_port		= felix_netdev_to_port,
 };
 
 static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index dc29e05103a1..abb407dff93c 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -98,6 +98,8 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond);
+struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
+int ocelot_netdev_to_port(struct net_device *dev);
 
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 028a0150f97d..64e619f0f5b2 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -656,6 +656,36 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_do_ioctl			= ocelot_ioctl,
 };
 
+struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_port_private *priv;
+
+	if (!ocelot_port)
+		return NULL;
+
+	priv = container_of(ocelot_port, struct ocelot_port_private, port);
+
+	return priv->dev;
+}
+
+static bool ocelot_port_dev_check(const struct net_device *dev)
+{
+	return dev->netdev_ops == &ocelot_port_netdev_ops;
+}
+
+int ocelot_netdev_to_port(struct net_device *dev)
+{
+	struct ocelot_port_private *priv;
+
+	if (!dev || !ocelot_port_dev_check(dev))
+		return -EINVAL;
+
+	priv = netdev_priv(dev);
+
+	return priv->chip_port;
+}
+
 static void ocelot_port_get_strings(struct net_device *netdev, u32 sset,
 				    u8 *data)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 5a93f7a76ade..a7f53fc6f746 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -757,6 +757,8 @@ static u16 ocelot_wm_enc(u16 value)
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
+	.port_to_netdev		= ocelot_port_to_netdev,
+	.netdev_to_port		= ocelot_netdev_to_port,
 };
 
 static const struct vcap_field vsc7514_vcap_is2_keys[] = {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 45c7dc7b54b6..9706206125a7 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -546,6 +546,8 @@ enum ocelot_tag_prefix {
 struct ocelot;
 
 struct ocelot_ops {
+	struct net_device *(*port_to_netdev)(struct ocelot *ocelot, int port);
+	int (*netdev_to_port)(struct net_device *dev);
 	int (*reset)(struct ocelot *ocelot);
 	u16 (*wm_enc)(u16 value);
 };
-- 
2.25.1


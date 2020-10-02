Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432FD2811ED
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387787AbgJBMDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:03:11 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:10595
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbgJBMDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 08:03:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwhdK8gq1lkTMPkd+79TI0qLuMnsQyxVAQOjAeUQV3v4sXBi6p+qzGngYLcoThwCKdOvYuflGzWXAiNof4SespOja74FkRKZmbA7SE2snzLsZhSxa7aS7xr5g6tWSnYTWiXjHuGtHGz+dAdt7OS2qZERttFVRInKs6lXDplYtpHiiXN1dq25SOoNxNbp6hTCkh+AxsMZLWruwv0NnAbi/NqvOhYCc+/b50nrsnDPC8BiOZNkuZ+MqUWAQmI089a0trVn0VmvCVOITHSgAE1jDqvAki8lVQW6wYG14zhnunDmosGcDsAymNw1fy7Dua8OfM452zwhAlUjqMoJhHMC4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKzyKJoXmR5vjGb1NCALDuE5vrQdPD5zXdm5ImflJZQ=;
 b=IQcEDXxQod759s+RsBjYVhOfOMwELYFGWORsGAmLfPWT3NITQd7Jce74aReLBjKx4RQowGG7wvlwfDyXj7NWNk0VURR7TAKBChjdVVRzuJFGC+9ov9mVuWmSN4ZN34xTfb+MEG730kKqPdCvVN396SwEJHAB6Xub0rDY7vFz+Krbe+NkMhyP2w4tRQol0N3jlEvT+NQOX1Kyqc80VdD+e6g1gnSGmr+AkNwCe4vhdIxsNoAsCOGgF8BD6YuZLK4d/lIE2VDWAYvVUMszQ3xtzuZNGpJbyVHdozvlecO3PuhwcFOlO9fgwL/SMSVC6nI2lmU+ZYA07xVHkIwgdu+S2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKzyKJoXmR5vjGb1NCALDuE5vrQdPD5zXdm5ImflJZQ=;
 b=lFziokKdgK8/yvmExGPk/x/G5J99d58hVihQaFj4zqoia9MgQcoOASun5EkXcULXCDc8ixtZmzUVuCskU6zCMkeMSUeQuORPndDbwHRcgTxJtg/gheYcdZtQ13lgVybJQsIwJT2DckIDvhEXnRg4lTxwwpCaqRcci2Nxz2ziSZg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Fri, 2 Oct
 2020 12:03:00 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 12:03:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 2/9] net: mscc: ocelot: introduce conversion helpers between port and netdev
Date:   Fri,  2 Oct 2020 15:02:21 +0300
Message-Id: <20201002120228.3451337-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201002120228.3451337-1-vladimir.oltean@nxp.com>
References: <20201002120228.3451337-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM3PR07CA0130.eurprd07.prod.outlook.com
 (2603:10a6:207:8::16) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM3PR07CA0130.eurprd07.prod.outlook.com (2603:10a6:207:8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14 via Frontend Transport; Fri, 2 Oct 2020 12:02:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 993dbcd5-3f1e-40ad-650b-08d866cb1acd
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB42227F2E39F92F95354C128DE0310@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7qXFJcSPim6lGMDSpyM0iWzeFfaDrau/6yuNI5c1GKK1xyT5YXW0EBkPQgsVaWt36ZD3wIp1J0HIO1+AnTz5Gq5bdxuCRZisrhXcMfHP9899tpiM1lT1e+kWiJsS6xv6prBkehsxRwgCSVVo22rvAn6cyvMuqseLGBeri4Rm4laNC7FPNnrZg0x3NflvTaWCJvwb6ajJYrlDzkhWk2QWYdlItCUNRBRfK5BK112mPRWjDcHPUBvrtRndTylxIU5bsqlDVhl+1BdEnGGFlT4G+6DB72TIw2vZL2cATLQcV1PRaw26T9TKlHUnPrV4fonO/puD0IAJbz8kMIL/zpElHHRGLknEDZczUHImFfgf57M680Gz3kaUZSisjdtpYDozKgFBMkNv4rH0utq0A6zfWNlGMzK/6+kPkxgm1CwhuG2xcZs0k8IvXuELONPwg0vM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(86362001)(186003)(26005)(2616005)(16526019)(7416002)(52116002)(478600001)(5660300002)(6916009)(2906002)(6506007)(6486002)(66946007)(36756003)(69590400008)(66476007)(66556008)(956004)(6512007)(6666004)(44832011)(4326008)(8676002)(8936002)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xbWVqhIV/nAeXVjYZwQ9YFE8mhUVss+LaBdo0GjKLk5a6wy0eZY8P5IPxDB8YVImsRJWwSX37PzzxXS+ko8dNN9eo1zj+glYOm+xYKr7eYW8HbZUdDr4nB2ZhuHjeXMnieOjniArVqe064sCJqdJKRWW27YYpg9MMZyOu07GYzVfizSRAU2vQ132UMAkp29/DpnsM3WW9J3RvZvDlrcWjQXbtMZ1hUFLxmMuF8lcFapPA8RwbuWzh7de4bXjo+nk8qKmzMUfX/g+zwW0MBuk970ovk0OcuztoAFrlKQsxfaB0PAT0PLZjG93aBD4IsSQkOg4fjuItmBZ9AMLj/s1mASZC+baa9ZOZLX0VGYb+5jdZqi0S0EZD/55RbAbd6LJACsSTRN5CydwaLTSy9oRZzMkXYNjImICH6YOlI3uooC64mcH5v6d8o6OgpbgOk1tRPTPTMpjXrALRhyANFlQUBI/bDVqE6tpkuA30R6zfrpnAbuzQPKE35IzZ684Do+HSVAlfVzU4n7HE08LQsMl14YVihZapgCdkjHHwEYkehBRQo0qzo4IODWc5pVgM+6CsAYOtIS9tuONhdL5AuiVnH5FnrZPHhQHVjIU4vn9mCjpDeB/U50NroemZorq8oXtguJObQ+3m4JEhpRlkb25YQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 993dbcd5-3f1e-40ad-650b-08d866cb1acd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 12:02:59.9140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wVYO6yEe0+JjWsfOm60GNSsxz6hV32MHi2ym0JZzaYetadbz8ebnuAR7PZDtwpBYQhf6JkCyfPUzq8lLnwZeUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
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
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes since RFC:
None.

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
index da54363b5c92..552b1f7bde17 100644
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
index d5f46784306e..4c717324ac2f 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -52,4 +52,7 @@ struct felix {
 	resource_size_t			imdio_base;
 };
 
+struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
+int felix_netdev_to_port(struct net_device *dev);
+
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 7d9b5fb73f2e..c98ba7c529c5 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1006,6 +1006,8 @@ static u16 vsc9959_wm_enc(u16 value)
 static const struct ocelot_ops vsc9959_ops = {
 	.reset			= vsc9959_reset,
 	.wm_enc			= vsc9959_wm_enc,
+	.port_to_netdev		= felix_port_to_netdev,
+	.netdev_to_port		= felix_netdev_to_port,
 };
 
 static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 874e84092b68..e993f3eac3eb 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1058,6 +1058,8 @@ static u16 vsc9953_wm_enc(u16 value)
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
index 086cddef319f..f3e54589e6d6 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -763,6 +763,8 @@ static u16 ocelot_wm_enc(u16 value)
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
+	.port_to_netdev		= ocelot_port_to_netdev,
+	.netdev_to_port		= ocelot_netdev_to_port,
 };
 
 static const struct vcap_field vsc7514_vcap_es0_keys[] = {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 0c40122dcb88..424256fa531b 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -559,6 +559,8 @@ enum ocelot_tag_prefix {
 struct ocelot;
 
 struct ocelot_ops {
+	struct net_device *(*port_to_netdev)(struct ocelot *ocelot, int port);
+	int (*netdev_to_port)(struct net_device *dev);
 	int (*reset)(struct ocelot *ocelot);
 	u16 (*wm_enc)(u16 value);
 };
-- 
2.25.1


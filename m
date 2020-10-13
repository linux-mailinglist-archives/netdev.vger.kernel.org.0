Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C71C28CF7E
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 15:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388026AbgJMNtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 09:49:52 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:43748
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387996AbgJMNtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 09:49:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ddXnw1RWNBlF4wUDTwBAh2PLeDEF8XOTVRn9VHX9elrePrbTNWssPVj291Xu0PNbbMhSndeXndmKC0UmxueJpaHQB3h1/GnNmT0H3iwMkJEYBpMT9c0EXzlZ00//saNhJHvOiNbFRr9xwXP/TdujdfCg7TAlgM53pNE3E+/5zJRkpFj1OKbpFxqW5c9eO2NME93AQmZ4F8+jaPWHJuFWqF9f7/dbfuYraCdNFFsfmq396ueSc4Vyejb4modbIn7lsUc7OgdCxGoCo46ib6iHR0HquUetOzDpM2pRvEn8D9ISeIgSm4nlpoJQd4vRY5HxxpsFmGilXPLETMIKQ1dWzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtGNClwuQCRRcChzGHJN0wxfSS2GSdJMDVc+i+choyo=;
 b=Ulvzi0SD3H7aewGtopu68JCcBscKU9KXvmrFuUpAvDNWo9sxiy9Zqa56E5xk/7Q3O/GCz9fHJM9ks91dzeCm/dcWZC8oyH9CmWxwzcEF51iaLHSNOoWiEN4sNNL9XrCpxZmqY/3ZhUdopN8xwhwbQs8vZkZp66t+iT+dUfb45ZkweIAU7z4fMf8o15hdN4u8Rj9lrUYQP3g0/JtGSqNLYg4hcQxbAdHh3f9eSdq4Jlc17H3KefEjOqW+CBeYxQQyFe5wf+0IdteuOC74JfYj42/4bD/11Bxdr2F+c4pio81j1lwMaOxZAIJlcWtPl/qyd2wHhwlc6vHiuVoo9X48bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtGNClwuQCRRcChzGHJN0wxfSS2GSdJMDVc+i+choyo=;
 b=hkMuuNcNDeF0q1WRThznZ24W0wVemKXel7EISRiyx5fAvFoGXSavaOrOkVruuC1996XQvAMfRuO74s7woiKt1ouExIrIDxcO7g2y/9DGs6cQhtewQ8mGYjsHjaSrHEmFI4gloiUQrX61OnQNFvVf4GYGiocnXqPTTsXzUGsQ9Mw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Tue, 13 Oct
 2020 13:49:21 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Tue, 13 Oct 2020
 13:49:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH 08/10] net: mscc: ocelot: register devlink ports
Date:   Tue, 13 Oct 2020 16:48:47 +0300
Message-Id: <20201013134849.395986-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201013134849.395986-1-vladimir.oltean@nxp.com>
References: <20201013134849.395986-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::25) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR01CA0084.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Tue, 13 Oct 2020 13:49:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 998bdeac-48b8-4dac-5ce7-08d86f7ec967
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104B369703369C56A775867E0040@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9TZimBh0/vpHScm3oMPoPfYlspWW3u2ydAwQjnufyt+J5wQZJzzc8kDT/i00AHSmE2UqGwy3aTygxQV0GbGpe3LfrC6lVC94jr23cdZkQKqjE+ydu0jdfWom+wcNFNtOP1Zk2T6hsOjEVXSCrEFxyDTMEcLwZQDP1OkqRFujWv3KiP8FVK2StitCwTCK5zIyo7bfG86uSv+VaZJwoVxaqre+Wjk6la8CZHRteLuDkT9MbmRzubrwv7LngEZRV238ZkIMgyMNQH4/fpopxvfSEa9KHboH7FgKAek3iFeAV43lMOAT0FQ0FfDh4LBq3qQVzOi8wAFJw08K3gzKcmbL4Q2Xpl4elP/jrdhFxNGHP5RnoeEs1R+63TVVVcgB7wzx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(39850400004)(376002)(396003)(478600001)(83380400001)(6506007)(8936002)(69590400008)(6486002)(66556008)(66476007)(6666004)(66946007)(5660300002)(1076003)(316002)(4326008)(36756003)(956004)(8676002)(86362001)(2616005)(186003)(6916009)(16526019)(26005)(52116002)(44832011)(2906002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HDjj8Ck4xi/n7NvzRN+StAooE89Xv5JqNTPhHGd69tgzDic956glily+91L7EsHt9xYhjP7qjAI/NJkI4Tom5YU22zlw0fDQImprPQaRSsE5ku8nHbYJ9pJXKs514Y0ebMwovkxkE/DoizznhaxQGsh0M+awLlmhy6Qe8EQcIv9+vhSf1xHVlLv4HbIjMOPo0QlMg3vzlzVGNzQguvCvT8JgJUCfdmuXcblgx+2a1XU7rf/sZwyr/JkNcBZyPbuzzfjQYWcOgx9oybBefOL13A+aEIj1Ix2uB1iOjAFxB2yNY+vg94dh/BISGlF4wZ4Qkx4vGI+vjKZ5hKdWlpTBVCY/UNo04WLw0+AW0hukTrMxl4UozMY+N+a3JWAYJMIUymgqCUCzq8ORYXIdufNBgJbvRtJ42yjPrxcptF8sRWOpcNogULxey0k7/ZfeQz4oWU8TFCVFoVfLfIa3+t4cJcEVaJOdcjQS24q0Wrk4MMFw04orN9+C4dwFHPt+6YZ2uOcMnFckH+i8CwQD81YIXIwX3MHotRG7vcAsfI83jOQyd0ISBRNr7SnMx+Lr3ccgVuKeniMbVy6xLmZfwni+rm5arrFG7EAIIi3iNB1YJ05z3k0BbWgjo9xMshE3bcdAZTIlGOR2IibyMr4Tf4MVng==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 998bdeac-48b8-4dac-5ce7-08d86f7ec967
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 13:49:21.1210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EU98uOmHbBeE/9cQgrsQB4yM8sFJ/cjghp9w+08HLDNqYnnCZsScYP+SXGDImMi/4qpPhIqrJykEtxK6AyfM1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink integration into the mscc_ocelot switchdev driver. Only the
probed interfaces are registered with devlink, because for convenience,
struct devlink_port was included into struct ocelot_port_private, which
is only initialized for the ports that are used.

Note that the felix DSA driver is already integrated with devlink by
default, since that is a thing that the DSA core takes care of.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.h         |  4 +
 drivers/net/ethernet/mscc/ocelot_net.c     | 92 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  7 ++
 include/soc/mscc/ocelot.h                  |  1 +
 4 files changed, 104 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 8eae68e0fd0b..3fee5f565920 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -65,6 +65,8 @@ struct ocelot_port_private {
 	struct phy *serdes;
 
 	struct ocelot_port_tc tc;
+
+	struct devlink_port devlink_port;
 };
 
 struct ocelot_dump_ctx {
@@ -106,6 +108,8 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 
 int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		      struct phy_device *phy);
+int ocelot_devlink_init(struct ocelot *ocelot);
+void ocelot_devlink_teardown(struct ocelot *ocelot);
 
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index d3c03942546d..a11e5e7a0228 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -8,6 +8,98 @@
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
+struct ocelot_devlink_private {
+	struct ocelot *ocelot;
+};
+
+static const struct devlink_ops ocelot_devlink_ops = {
+};
+
+static int ocelot_port_devlink_init(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct devlink *dl = ocelot->devlink;
+	struct devlink_port_attrs attrs = {};
+	struct ocelot_port_private *priv;
+	struct devlink_port *dlp;
+
+	if (!ocelot_port)
+		return 0;
+
+	priv = container_of(ocelot_port, struct ocelot_port_private, port);
+	dlp = &priv->devlink_port;
+
+	attrs.phys.port_number = port;
+
+	if (priv->dev)
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	else
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
+
+	devlink_port_attrs_set(dlp, &attrs);
+
+	return devlink_port_register(dl, dlp, port);
+}
+
+static void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_port_private *priv;
+	struct devlink_port *dlp;
+
+	if (!ocelot_port)
+		return;
+
+	priv = container_of(ocelot_port, struct ocelot_port_private, port);
+	dlp = &priv->devlink_port;
+
+	devlink_port_unregister(dlp);
+}
+
+int ocelot_devlink_init(struct ocelot *ocelot)
+{
+	struct ocelot_devlink_private *dl_priv;
+	int port, err;
+
+	ocelot->devlink = devlink_alloc(&ocelot_devlink_ops, sizeof(*dl_priv));
+	if (!ocelot->devlink)
+		return -ENOMEM;
+	dl_priv = devlink_priv(ocelot->devlink);
+	dl_priv->ocelot = ocelot;
+
+	err = devlink_register(ocelot->devlink, ocelot->dev);
+	if (err)
+		goto free_devlink;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		err = ocelot_port_devlink_init(ocelot, port);
+		if (err) {
+			while (port-- > 0)
+				ocelot_port_devlink_teardown(ocelot, port);
+			goto unregister_devlink;
+		}
+	}
+
+	return 0;
+
+unregister_devlink:
+	devlink_unregister(ocelot->devlink);
+free_devlink:
+	devlink_free(ocelot->devlink);
+	return err;
+}
+
+void ocelot_devlink_teardown(struct ocelot *ocelot)
+{
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++)
+		ocelot_port_devlink_teardown(ocelot, port);
+
+	devlink_unregister(ocelot->devlink);
+	devlink_free(ocelot->devlink);
+}
+
 int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
 			       struct flow_cls_offload *f,
 			       bool ingress)
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index ea55f4d20ecc..6512ddeafd50 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1292,6 +1292,12 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		}
 	}
 
+	err = ocelot_devlink_init(ocelot);
+	if (err) {
+		mscc_ocelot_release_ports(ocelot);
+		goto out_put_ports;
+	}
+
 	register_netdevice_notifier(&ocelot_netdevice_nb);
 	register_switchdev_notifier(&ocelot_switchdev_nb);
 	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
@@ -1307,6 +1313,7 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 {
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
 
+	ocelot_devlink_teardown(ocelot);
 	ocelot_deinit_timestamp(ocelot);
 	mscc_ocelot_release_ports(ocelot);
 	ocelot_deinit(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index c6153c73dbfe..19ce7ea11163 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -599,6 +599,7 @@ struct ocelot_port {
 
 struct ocelot {
 	struct device			*dev;
+	struct devlink			*devlink;
 
 	const struct ocelot_ops		*ops;
 	struct regmap			*targets[TARGET_MAX];
-- 
2.25.1


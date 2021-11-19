Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E5F4578E8
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 23:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbhKSWqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 17:46:37 -0500
Received: from mail-co1nam11on2117.outbound.protection.outlook.com ([40.107.220.117]:22881
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234248AbhKSWqb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 17:46:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBArHpRMYPxq3lUTMMTwGxNDsC9gJ/6C5WzKtj1ctBjztVe/I03ZP2fkEhj6ldkc+EncwnnNODV42U6XZf1NyKGHLoPT4bzc5ufWfDNs3c2OveXpvqlsRiuQ2qpLmSXpiOxZqu/qWRD8xQlF5sMZMrcMoog4+cwnQl8A+gsFDeHMs+OydRkna0PeD8oJ7PFQGMbKoHj/AqQ0DbnXShmcuAhKRYwRGeyTOxL5ljAlhonfulsawIigqL3r01+bKNzOPCnkJqs53AiPDfWoWqm2TgVwna+owDbCN8r+N9VOfT/l089bxsoujno1Zb2ls7+SUpHtoSm2EfYVtyXAtK3fWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJAhBvMQsfsrmilvvepIMGy7l2AnN9UgT4ZJJs6/nE4=;
 b=Qfv7wn7TGDvYl27CzDdTOV2O0Z4JReVeqntSn+bL/4BbD/9WZmH1HuNU+nUBJLhy5iwqV2/iriv1XFb7zFcy0p3+N+ErdTicsoXxzLFKEZ41E/uSvHb+7hZeMFLequKD7ND6obUm4H/etcO+D6Lo8eON+/kl5B3jpBDzHrlUgV4LrubYwY12soFPDFoGzbfisxKC6cidBzMKRLRMx9O+iqL80gC42/YGHqx98EWzWkg6AwigionMtO3D5wPe8nlmmmqegyPxKD5YVRvBvrA5P91WaK/gKsJ4uiSFf4z7FU/putNuTlaibW3Z8MThBNuuclpnNeU/Z1/69opkgVHL0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJAhBvMQsfsrmilvvepIMGy7l2AnN9UgT4ZJJs6/nE4=;
 b=TMn2y0UVHLdDSf82zZhfcLskt9lat0Rd223zD24DAeKTpdGrxYTb7HLNcCQlZZisb6c6murBrd1XYyyR7i+gIGcKyBT0Vo0vxvrTGj2EHmSpVlyrMG239ODbpTMYrXg/HFvJ1o8/gl5FGB/VzDGR4wfmXwa4uofa+iTYlJ8XMvs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5701.namprd10.prod.outlook.com
 (2603:10b6:303:18b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 22:43:26 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Fri, 19 Nov 2021
 22:43:26 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v1 net-next 4/6] net: dsa: ocelot: felix: add per-device-per-port quirks
Date:   Fri, 19 Nov 2021 14:43:11 -0800
Message-Id: <20211119224313.2803941-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119224313.2803941-1-colin.foster@in-advantage.com>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0061.namprd19.prod.outlook.com
 (2603:10b6:300:94::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR19CA0061.namprd19.prod.outlook.com (2603:10b6:300:94::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 22:43:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91987185-6fbd-4eed-7bc5-08d9abae003c
X-MS-TrafficTypeDiagnostic: MW4PR10MB5701:
X-Microsoft-Antispam-PRVS: <MW4PR10MB5701838FE0E3E4EE78AC324EA49C9@MW4PR10MB5701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ev59NCn6Q+ycPo5wv0cc7XNFsWEwIlWRQcexkxbHAn2hxJXchxUgJDubzZjUZK71NGSPwacsQeOHlQbcvY3rIJX2W6xNjHh9DIe9khGaPjuHrsx9TT+BbeqSoeAZxzEES1yQffncxkMf/RMQhr57Z9M0h3WQQo+X84YOWDRYvt/OO7Bin5i2k3ZDrgFKEatZMt+yH5LqSS1hrbalg7NE38c54nPlVg9C6wE9FWmTXCHgU3oPfN2TL+w33eFXKlUvxTtqsYAwfF3PBiC7sBXvz9T795I3wy3EsIE0CQhV0MBVcIU4nAuuGu6LBWqqzP7H/NGLwljU7/vjZBEr0NCfn1kYZETqGJ063SqOATtL6zS5ymw6mLiuBO03bm8BnJGA4GBocEoqmvdqyf5dyKG1nToqtpVuHzR/cKuMNRb9JLzsGKCn9coUN3WF3NVvEtohC2x5NLvPfPy9RDdhQjx8j1gJf+hXg0E7lFBJ7qOdyK0FuhL2wFjKsiwLNxHzS5KVSOSl0yCFXR2JmPDecL73/DAnJWSOsNFLLDJ67Kz6vtA8XZ7p9OCWPVLxvEcVVkl1CWqPFgR0l9sn2EX1DnCGHAoXsoM4P7qTb2iJTQvGpteS0Pmux3L0+d9S1AIXr2DQFw51a7xv8UlvtYq5r6a6rQ7TmuVAbvNS9bMZXfMG26JBCxNzPBPrjhxNXqPBfLhhNliKCYFsC2++6A71TAljqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(396003)(136003)(346002)(376002)(316002)(36756003)(44832011)(8936002)(8676002)(6486002)(4326008)(6506007)(508600001)(956004)(2616005)(1076003)(7416002)(6512007)(26005)(86362001)(66476007)(66946007)(66556008)(83380400001)(2906002)(38100700002)(52116002)(38350700002)(186003)(54906003)(5660300002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N6foJoal1TOuJKMOWGbeV+wD9qSF+Jhvdt5ya4IFcvIDnorMnNAn2c1ZGack?=
 =?us-ascii?Q?Hukkext48SLjHdt22tCQhLHzO/jStOsyIphO191wOPk3ARp7kyhWs0DlseTn?=
 =?us-ascii?Q?mXrmZoc0aKQoP2UWud/UnPP9hh7HTIxBt5OFRu/J7+0f6XT1R9/fC/qBHQyA?=
 =?us-ascii?Q?XhFWcomHV9oxwBGL7j7uQPNVztVtZc4+UTeIJP9nHwV1yVTKcR/SUjbGSKMo?=
 =?us-ascii?Q?CWD2zA5pZTGyWf0naL/BKBVgV/ljJsY6OQ8j5FfrcNZYEO/rk9zcyKaFMqE/?=
 =?us-ascii?Q?m7zQ7HJYSYEaVTiiPoCfPTdyVwgZ+CJfhKhrRoHxAyFPIKCJrGz5a4GnhY6i?=
 =?us-ascii?Q?j/6myGNaLp6XYlY7+BW71cq0jz0o3l1sEb3Xd0Byf/ev2d7eFA13CYyiXDzA?=
 =?us-ascii?Q?2UslC9ekARaiWMAEz5l/eFMvEjlUXfgR3p6DJrCu2y5u49sx5xQnPMd5dhoU?=
 =?us-ascii?Q?5BMfvqLZuBrJhSPGeHVzLFp7apEBxb7sxuWEwN0ZeGJQOiDPny2SuTYatcFw?=
 =?us-ascii?Q?UEIA9cXHbs2rgGUPRKFmkIUEzfGn5I0dZXYS2gsX0LrMMnu4jncuPir2NuVQ?=
 =?us-ascii?Q?Ni6z3wNCOxc0/sA+bf6wJnuGJx8XPbUKKOOffJIiC3kgbNuBKunejyVojVKf?=
 =?us-ascii?Q?uTQ4WCouT35cgiDLy8r30ScUPJGWUyiWRcaJFW5hdqBKtqxR45nvZsDkIXLx?=
 =?us-ascii?Q?kRBF5Mtl+s1TGfp+p9qAJCjFiM6cqTxRS5T/cUsXWWSu9NcOS45D5tJCoqOa?=
 =?us-ascii?Q?oO/GFF7979Lb7btnfM3tDbw4GYheuUNiqnleD47oVLeskxIMNQxSAEmFTzXt?=
 =?us-ascii?Q?tL+dJdQNaV+D5dmdRDjVShJMGSbhu9KGesFDvFqQYpX38L1RRoXS2i+UDlw2?=
 =?us-ascii?Q?oDCHG5Huy6my8wU+W18Ko3rWm3qJVw0lBpRlxYDdTKda0pENDPOXazkjvFtF?=
 =?us-ascii?Q?JjMuuktF0yx+0RQ/VxYdsezDszILRUE/zNg1qcYpo49NjUzST652H9pReIEU?=
 =?us-ascii?Q?HI9KK1P0uzztWd9wGTg1Mvjs3qsZhDufPsK0+fih370YUgXJUWZ02sTQz+YH?=
 =?us-ascii?Q?pQKCZhEPPYzAZBcRzQI+7QRCOt2PYjzEv+mq1R+xqKuuTeGsndf1JiYjWEpi?=
 =?us-ascii?Q?lmREaunJISml4KhC5ueoMAQ27ZPlrgwK5BAeXMVyqT6ESQG7xXujFTwgHrTF?=
 =?us-ascii?Q?RczAb1GbCZggA5zVU7/kwHsA/kKPEsveym36NssfMOahW+WA8mck4xAcs0Os?=
 =?us-ascii?Q?uUIuBOkS9zxUyyVII5tnVC+7GG3e1hQ4T8sYP3h3Iqe8xbgPuAK4rA2Llug+?=
 =?us-ascii?Q?D0B9wo15GxQQRk2Y5c0JZIaFKuVh2JRE3YceL0ZZTcam1dcQltJSdg5OOJOx?=
 =?us-ascii?Q?yx6d+/U4vnu2+ohEfywOd/N4UT/Ncyf3bj9YuNHzM8u6ZGQBjaek3kxtX1DP?=
 =?us-ascii?Q?2FOFyf0HSCOVLPCKJ7J/OGHDDQl62aPu38Lm9e4I4QM3lJCdgAaCkIBOu3hS?=
 =?us-ascii?Q?w5kMB1otIL5Le9qsbHVZgaQJckGA26wYYIj6YwWMlEP51HN2i16vXdqN+bLV?=
 =?us-ascii?Q?LR5JkLDQ4hmrk0vxVNTc8mxw3qM1gj3xsTAXBEEjDkba1ssHPTOAhsE1NknX?=
 =?us-ascii?Q?GWg4llCFqVi/bPB9qag0E28KZ7kTsGjrn/cNqpnf0qElb+aZJpiTcV9Cf9G+?=
 =?us-ascii?Q?D5Za0yOPTtj6sWXmbK4qZi7ZJA0=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91987185-6fbd-4eed-7bc5-08d9abae003c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 22:43:26.7748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DMJyLTzjOEW960Ysobv7tirU+AMHYR4NUjX0TOOUyotXkxGYpQnH+wwC24Tk3KvI4KN2lmmK5bFbBxe+YwGm1ZvhH3/tF2n3xO2dx+KcA60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initial Felix-driver products (VSC9959 and VSC9953) both had quirks
where the PCS was in charge of rate adaptation. In the case of the
VSC7512 there is a differnce in that some ports (ports 0-3) don't have
a PCS and others might have different quirks based on how they are
configured.

This adds a generic method by which any port can have any quirks that
are handled by each device's driver.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c           | 20 +++++++++++++++++---
 drivers/net/dsa/ocelot/felix.h           |  4 ++++
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c |  1 +
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 2a90a703162d..5be2baa83bd8 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -824,14 +824,25 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
 }
 
+unsigned long felix_quirks_have_rate_adaptation(struct ocelot *ocelot,
+						int port)
+{
+	return FELIX_MAC_QUIRKS;
+}
+EXPORT_SYMBOL(felix_quirks_have_rate_adaptation);
+
 static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					unsigned int link_an_mode,
 					phy_interface_t interface)
 {
 	struct ocelot *ocelot = ds->priv;
+	unsigned long quirks;
+	struct felix *felix;
 
+	felix = ocelot_to_felix(ocelot);
+	quirks = felix->info->get_quirks_for_port(ocelot, port);
 	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
-				     FELIX_MAC_QUIRKS);
+				     quirks);
 }
 
 static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -842,11 +853,14 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				      bool tx_pause, bool rx_pause)
 {
 	struct ocelot *ocelot = ds->priv;
-	struct felix *felix = ocelot_to_felix(ocelot);
+	unsigned long quirks;
+	struct felix *felix;
 
+	felix = ocelot_to_felix(ocelot);
+	quirks = felix->info->get_quirks_for_port(ocelot, port);
 	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
 				   interface, speed, duplex, tx_pause, rx_pause,
-				   FELIX_MAC_QUIRKS);
+				   quirks);
 
 	if (felix->info->port_sched_speed_set)
 		felix->info->port_sched_speed_set(ocelot, port, speed);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 515bddc012c0..251463f7e882 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -52,6 +52,7 @@ struct felix_info {
 					u32 speed);
 	struct regmap *(*init_regmap)(struct ocelot *ocelot,
 				      struct resource *res);
+	unsigned long (*get_quirks_for_port)(struct ocelot *ocelot, int port);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
@@ -72,4 +73,7 @@ struct felix {
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
 int felix_netdev_to_port(struct net_device *dev);
 
+unsigned long felix_quirks_have_rate_adaptation(struct ocelot *ocelot,
+						int port);
+
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 4ddec3325f61..7fc5cf28b7d9 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2166,6 +2166,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
 	.init_regmap		= ocelot_regmap_init,
+	.get_quirks_for_port	= felix_quirks_have_rate_adaptation,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index ce30464371e2..c996fc45dc5e 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1188,6 +1188,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.phylink_validate	= vsc9953_phylink_validate,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
 	.init_regmap		= ocelot_regmap_init,
+	.get_quirks_for_port	= felix_quirks_have_rate_adaptation,
 };
 
 static int seville_probe(struct platform_device *pdev)
-- 
2.25.1


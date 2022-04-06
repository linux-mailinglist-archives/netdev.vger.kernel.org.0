Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1387C4F6C9E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbiDFV1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235821AbiDFV1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:27:05 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80088.outbound.protection.outlook.com [40.107.8.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DDF332DD0
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 13:23:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCKFXCuYfV+YQTkQ8WrblZ0p2VMMMatkZVeiqBaB9xFn+rAZ6skVKSfjq6dbtYdyUv4IQXAlHsgqEbchibW0gLsTWIyXASGQVQ49S7qOnjM8e579ngLWM86+kAgn5zd2a5qcBgYedJmrGGYIM9SaDrst4jRp5kw3mY8I+JK9QAbhKW6voC41wWMmVB79Lb96JHqfViXVljI3Ahz1sxf3VgNYyHjAhV4pYs1Zym1l/yTVIq2MWHI2rgJSsJdHRKWempC+JbJw/46PfYbb2sHPnXJidLq0YSlbw7wYQJbhfMXTzyj1rJuQeFq6ywqy0nDXT365/9aIHyHEH93hwdsUBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sznhAvq2yej6QJ6WQ9rUQ543EzXoThK5BS/bD3u7urc=;
 b=VQHEX7iGKbJ3mMQd0oJFCOswHvpgs46xDhup7J8wuKtr6iRdlZyUPxPPCZWmkl+SqFKzuUqOGc02fayJF1DAWzi2qZ5RPYEL34skENC1e4sz5UuxgMyIERItjsCeOsbdYho7KVEmUpnrJe9uvevvUDdctgXDj5Q2WHa1zCKyVXxa/iK7a12G0jWHrvEfhoT724yjyDyyOo0bMo85mXWeeRR5Y/zwrnlXpmVXvvvxl2MzZOqU+tUPS6RKSO5Ps+I3N0VTmYICyFqra6GArj8Q69S7xYKbYsWixbZOXXWJeFLVEBhuYG21jceMepVmCOdRA7tG71YsdURRS27mvkncKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sznhAvq2yej6QJ6WQ9rUQ543EzXoThK5BS/bD3u7urc=;
 b=ajLV6gAH0BFIutFG5LmdX0RbRX4EymUilQqdrOhgxtEVjhQgX43N33x436rOccFKjfvEeEVqe3N787vN2/XKQMdzE32NkaLXRG5Xbxjz2NRA4ugA3BkArvonfzOUJYvXh29YFI/znDfbV1siob0NUH1i3N/j2STTWXZk0YWSDbo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4465.eurprd04.prod.outlook.com (2603:10a6:208:73::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Wed, 6 Apr
 2022 20:23:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 20:23:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH net] net: mdio: don't defer probe forever if PHY IRQ provider is missing
Date:   Wed,  6 Apr 2022 23:23:23 +0300
Message-Id: <20220406202323.3390405-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM7PR03CA0004.eurprd03.prod.outlook.com
 (2603:10a6:20b:130::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72ff487f-6dbc-4b78-7d78-08da180b53af
X-MS-TrafficTypeDiagnostic: AM0PR04MB4465:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB44650CCE3A283B1480691C77E0E79@AM0PR04MB4465.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dO5jBSa++SzVGUtwGrmP/AVaxZ0xg4u5cUH5F/N75HfYqXxUYmwUXuwnEEZDPRhdh+qAnBI4o8EekL80nxg8qU2ncxrCKpT/5YlQwJRjHwZo2HGXq+Qzww5L5OVbIZ93IVx64Gwrxc8SuV+XRI2UIBwNeaF5emFZnLHsjM1z15KIHweqy4c1ropMR+Ppdk69nXYo742DvgyxugaTtpH4C9X3ljSYbeoXsqvyVZTgomUKwbhxs2j6tX2+IyWlzIbuKsXPx1+hSXlC9IvQizZFRtKLgrO59KgE2gVFgtT14eEhhKO9gm4nDdGwMseRde3wCcRQmCCKoloBBdTJ7RWlU+QLf8JVZzQ7S8d56af+zt2Gumw3ERkh6aGGXApHBmFS0fVjp4Y20AL4zEYlBz+0yrkAJOoE3CnrGiP7XpyrNZATvRV7BMiIFXVwIJ8+g65SGwfENiJNtb4aKTt/AiX7RG85gRm7N+SN/hPMOuTM1sClAg0iU885ta6WUSMqFVqrysd5nvo/6S1wMQq8VsnkQfclwjYDda1CarWhkDOHoxyjVChV7MX/LWS9dVNwDfVu/bc/IuCvvbE5IuE+Cqbq/4Ih/RIMh+Gra6OtmtAEQQh9u/stD4pHHKi/KNfGnGPecjN6jB00BkLO85KRT391CArCau2g6nkOQZnuUKhuzUBr3CATWZ5rWidLLTnAN/uqVJ2hk73ejBh23XB8UrcXOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(54906003)(6916009)(5660300002)(2616005)(6512007)(86362001)(36756003)(6486002)(508600001)(8936002)(83380400001)(6666004)(1076003)(26005)(6506007)(186003)(52116002)(38100700002)(38350700002)(2906002)(8676002)(4326008)(44832011)(66476007)(316002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vxTJZwdPOKSQmX+SXFEZrcGTXgZ0frHdWjyszW1MxF5/vm8rJ+FYbHhTiN72?=
 =?us-ascii?Q?gUrnvjT+g413YSe0840b4Wv6X/GodO961mLc8qTWxAFixJ0TGJwSZ3uavS4c?=
 =?us-ascii?Q?jCfQpDxSR1rovIjdPDxXzR/nmUbKxaiW4p31e+rGJSqYuFPG+3zMoc7PE4Gu?=
 =?us-ascii?Q?8L+cg28503jyfnPSKAn5WoIgiuNIwJ7wtpqbEFnFC2ZlFbpNzYC/1iYl5hmX?=
 =?us-ascii?Q?oLY5aWIHFq+svJ0s0CSX/2YoJFpyvtN0KFS4k9hxXZtg1f2/ui2P+fqAo7Rg?=
 =?us-ascii?Q?sCc3vJF7QxEqHIygqbOVZVrEf10TGR3bTQ8yLN8PddulSx7vgEwftA1NYVcK?=
 =?us-ascii?Q?4sdSiQBKdY3GExoa+YOj2cVub+lJSz826nyrXODiuym91d6kvZMiGn04hLM9?=
 =?us-ascii?Q?5H16BXVyCF3k35my9Q8wGAOXMMnWYX2zKTzH7gF5NHTPK63Ao9EX4AvWvx51?=
 =?us-ascii?Q?15YbapfG57adaSmEO0pud12EXgnIupeXS21mQSridV/QY0EoFgBr/gXtVGmp?=
 =?us-ascii?Q?HBE1qnptF0595tBun+ZoUMaXtsioNFq3/he2HyADVc1m4CFoN6sTB57BxVqV?=
 =?us-ascii?Q?rqBkF2DQ6/83fENqmaTs04YPSvQZkYKnXvSBs4hVrogp5/kBW2ZjJ2tPLCc+?=
 =?us-ascii?Q?qJsHhzmkv77qJSaEqT2ZuRuHstJyKBfGA4zmh5IQAFcKaDFydSc8hKiv6D0J?=
 =?us-ascii?Q?jc4D+Essa+lXt7KX9jp0X5Pv9tU+pGEcrsPf7zbaSSbvDNh2MVWCnqeQxffy?=
 =?us-ascii?Q?v8PlX4fZeq3KwPZEb4/ms/SI25fXc2lm0ZSrVI5nsBoWRkSRgk+YN3bQAc0o?=
 =?us-ascii?Q?yhwSG5DgWwLP+GFRDqToMzuiAnyLlZgPVgOklEyfqt1hELzRIgadgJP0Oeq6?=
 =?us-ascii?Q?uFSy6K5M6VaaEo297NMdiqmgSrDFa4TQO8r7NfQWXB+NyYswhw5G7J+FnqbW?=
 =?us-ascii?Q?SIErqhH3pmefJXh/NE14HKrmoqjZk7+R5bKs3xkTCPzMY/+2jyPKUu02rH89?=
 =?us-ascii?Q?6g6xHrDF/2WAlXnQ95S0Is/OiTPuQVEU9SsUpS+2num1yFxrHxUzs9MWJR3T?=
 =?us-ascii?Q?PmO4wzjIxebzuxxsC9di3xCv9kU3IRYXl2Yo0nvpgdKep1gI8XRSc6dUWVb/?=
 =?us-ascii?Q?xV9Oo5m2D5f8Oa1iFa1frEwdB1EdFhwU0SPdXjc3zJCGrAdh5139VsvIEme1?=
 =?us-ascii?Q?Qt4F6K0XqNcZKpjbsU1lvqtApZftVHtGHDb7fiR62hniwyN6ZlLdXGkuX9x1?=
 =?us-ascii?Q?bfbuuSTChuYav46fO6e71B1vOEKHRd0WT97we9j3mzfr/ShQiGxJhQQEuHs2?=
 =?us-ascii?Q?xwSGr2MxhFiQpehRzfNukYuNOPycCFw83i8Jn01P0hoIr6n98Eq7J4yZXwXl?=
 =?us-ascii?Q?hH6+5X7rt00JygllSjVeeetvNn+pFs3krb/SfuHdDtu/9Mt1paAg1YaYLcpd?=
 =?us-ascii?Q?Dvud6Z9GMWPLLNj4AYZvgPy9U6PNtp6Flk4nHEnTKsuy6vVzp2JN+Ga2TgDQ?=
 =?us-ascii?Q?sfI03EMvdbehbJNm85MLdWVNfSGzNtmEVj4xKGWn9Z5xwTwuyZGAjkj5JoJu?=
 =?us-ascii?Q?yoT+7OSvy9gctKxNp3nePMcvC/X5eYNyh/CVR2QJ3jPlHs+DlVHgMYfzc/O3?=
 =?us-ascii?Q?bJExrNHd1CYNvEsGUaBcYNTwuK6qjGJv9kYglbFwXogXT7lxg0prNtS117Us?=
 =?us-ascii?Q?RdjUWIDGZlc028DFk9zYEwIHvhQIUa/+Nwxnfb0OpYnokXxYCScCRBeWq5nu?=
 =?us-ascii?Q?pAxws9YJpLZfH8B7bcyWQ4U0bfuCj9U=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ff487f-6dbc-4b78-7d78-08da180b53af
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 20:23:35.5781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /izvSGNB8ZHydGcoKZ6rUhR3tMEiLP/I6pIpkkm/y3XzaWnReBRbNMD6UohmiIf2iPfuXwjs2HpytOFHLJ5yQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4465
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a driver for an interrupt controller is missing, of_irq_get()
returns -EPROBE_DEFER ad infinitum, causing
fwnode_mdiobus_phy_device_register(), and ultimately, the entire
of_mdiobus_register() call, to fail. In turn, any phy_connect() call
towards a PHY on this MDIO bus will also fail.

This is not what is expected to happen, because the PHY library falls
back to poll mode when of_irq_get() returns a hard error code, and the
MDIO bus, PHY and attached Ethernet controller work fine, albeit
suboptimally, when the PHY library polls for link status. However,
-EPROBE_DEFER has special handling given the assumption that at some
point probe deferral will stop, and the driver for the supplier will
kick in and create the IRQ domain.

Reasons for which the interrupt controller may be missing:

- It is not yet written. This may happen if a more recent DT blob (with
  an interrupt-parent for the PHY) is used to boot an old kernel where
  the driver didn't exist, and that kernel worked with the
  vintage-correct DT blob using poll mode.

- It is compiled out. Behavior is the same as above.

- It is compiled as a module. The kernel will wait for a number of
  seconds specified in the "deferred_probe_timeout" boot parameter for
  user space to load the required module. The current default is 0,
  which times out at the end of initcalls. It is possible that this
  might cause regressions unless users adjust this boot parameter.

The proposed solution is to use the driver_deferred_probe_check_state()
helper function provided by the driver core, which gives up after some
-EPROBE_DEFER attempts, taking "deferred_probe_timeout" into consideration.
The return code is changed from -EPROBE_DEFER into -ENODEV or
-ETIMEDOUT, depending on whether the kernel is compiled with support for
modules or not.

Fixes: 66bdede495c7 ("of_mdio: Fix broken PHY IRQ in case of probe deferral")
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
This will not apply to stable kernels prior to commit bc1bee3b87ee
("net: mdiobus: Introduce fwnode_mdiobus_register_phy()"). I am planning
to send an adapted patch for those when Greg sends out the emails
stating that the patch fails to apply.

 drivers/net/mdio/fwnode_mdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1becb1a731f6..1c1584fca632 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -43,6 +43,11 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 	int rc;
 
 	rc = fwnode_irq_get(child, 0);
+	/* Don't wait forever if the IRQ provider doesn't become available,
+	 * just fall back to poll mode
+	 */
+	if (rc == -EPROBE_DEFER)
+		rc = driver_deferred_probe_check_state(&phy->mdio.dev);
 	if (rc == -EPROBE_DEFER)
 		return rc;
 
-- 
2.25.1


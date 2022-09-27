Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3225ECCAB
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiI0TPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbiI0TPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:15:41 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80057.outbound.protection.outlook.com [40.107.8.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940D463F1A
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 12:15:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtIo3J6cFmcR9k5eY1z3MjHGos93Wa+d91CRbE86SSUpkY0XFeP9mqxTO1VNLh473wiB6oKDzf6g3Gf23n/vnteeXZDN3Drs/SJBYGM1hZfL9EEIAAlCRwdfI9H7KeBKl1uPFLBRVMJoZkMbJVv84mP5tZEShNcPj9CxzrSeWvfFhJMF6D+KiktqaRNCdrtTxNr9qRTROBGieONowMiN3+AUvDofiBGdKWOGGeD1MyzYysRhKXgwTXDdtE7lWboJPy0fiGZCkGBl8eMT4HJXm0zwfskLmhIEKMJcZK55fo0FeXV33uTeAvfqvVLRIjwumZjo+FL+GXWmPFChn7hy1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eMRPWwgy6uquSk3TssA9D4nmRegyAG757auYHujJlbI=;
 b=OUTN7WL8lRzMyHVWOkcMzW2E6Z/zuRziYxbTaDo3v8nkbzlYBN2/YeHoKWJY285lWfXiJS3ILgNGjj06cLROvV89WXUGBaZunLgkXAflyr2QGOm6odviNnq0GgycfaQxZewNuCcBtCq+J5FOQkx90fO9c9GQLHOvkWGAdFeRTVhG/hsHpIzvgrFGYvANPca0toO1G3pFlvHoOIciupgOuOzn+wTavmXe4Hw5KjzEm4eilvKhdfL8SIGhgyR5PN5mln3kcfZfyDCMVnE/R9D1DgFIGJZ53huYCSH/4w1SlwEkXRF6QWy7UlOQ9wG2Rll9Uo7Csy60FFNklr45CZAZSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMRPWwgy6uquSk3TssA9D4nmRegyAG757auYHujJlbI=;
 b=sZrTRGtca6OWHr8CBL19F7Fpr3O4UneJ77zW75NmYoBmiyOVjM9ibolLgk78QljuNxUaLrUz1o8g2tbV/fR1aWVCe4hWZMZyxjtTyv9Z92h1UocSjbuXXx6+u/Zyhj1/p5tz96lVsZxtZTBXT+JKLnS22309nGeSEogFx7s5czA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7029.eurprd04.prod.outlook.com (2603:10a6:20b:118::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 19:15:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 19:15:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH net-next 2/5] net: dsa: felix: remove felix_info :: imdio_base
Date:   Tue, 27 Sep 2022 22:15:17 +0300
Message-Id: <20220927191521.1578084-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
References: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0287.eurprd07.prod.outlook.com
 (2603:10a6:800:130::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d6e30e8-4726-4c83-e784-08daa0bca759
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QoHZNqB83MgazsCadEbwiR9oiAXz9HLobjKx5CU5CFgZNFRObnQX++dFtU+NAGu/iiwk/BNrXv3Wufs5WGSrq5copbICFdNOdf3A5zRFeeuRMz1we8VnmcpVIOLJ9gCFgNUSVE4tY0uI9t69TdQJyDE4FScEo2jJnmPV+VtJFD5yYppH7SYrezEV1Qnd9QcM1dbfTAag7QPTg++KBZXFLNMUkHq36KTYv/Vy2Guo5Fb3/J7BtWFCsnuK96rLkEh3HHGX9kjJAJ3QVpyHvjKl908OXhVSNOOugynIA2GfPFnF0e3PP6vTVxvef5qYe3Eo9bk4AVJq9hOYHC6y203NCJNyEPz4rispTCLTxQ/O6Az1v6ui2L5eUQfUTnrPdq5/gRuFWVAobTC4akG3q9j5gQpruT7pAgrD7ND/2x1QrJrETJX7Y8mJ9BrcCC1cQH77gy5NAYCxmo5yM6/fgYf2RaHxXdUuArn079174vNu7OmxypCw6ST0zkYLSVfQzNvDZL9oN+GezOUTVAlyK+t/9buZoSsmblkZQRMooV8HpXdTofPNwDNXzKsRQZ5xNYmOs7+fm1uAesYEX2t4cFrUB8JL1GshHd1s+7rc4qXxqfkuXOI1FFK3mnBJUmvD2uTuvjcXiJm9I1JsuMjdQ11+agsvJ1IhOHNQyX2X7D7lLqpmvjczdQWBwtWQHWkL3uuzsx3NEgtOG/+9tRQ9WprG1yGHhthSRE2chESySHjJ8dyov8napxbLdyZ1q1VjhBWY+8w15s/kgiZKjhjH/frzXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(86362001)(38100700002)(38350700002)(36756003)(2906002)(44832011)(2616005)(6506007)(478600001)(6486002)(6666004)(186003)(83380400001)(52116002)(26005)(1076003)(6512007)(54906003)(7416002)(8936002)(316002)(8676002)(6916009)(66476007)(66946007)(5660300002)(4326008)(41300700001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aPwtEuoI8xX3V1chrjK9WnXW/YQ9R1cvc0Hz3BUw4qJmhKkLqP0VU5XFBlMB?=
 =?us-ascii?Q?W6XiWTUzLFmfdkcwl9gOsTLiDcfSty60DJxuB4m0vkz8+wET/fMtkfXc4R2n?=
 =?us-ascii?Q?Ev1lTcumi9A5r0lgHSC5koV3m6n3nX9f/snhMtCHvmfTRdEfc5bWqKNwYp0U?=
 =?us-ascii?Q?fgzKv4M2303ZdE1zQxGrLekgnZoqk6caWuX3L7x6YjuQUeSWAX/nTXVfWrlg?=
 =?us-ascii?Q?pWUKJzkgF+Y77UfnCDx8R09xHAtXkNeB9/tOcWTzmB2mhBcnluDan2WDv+U6?=
 =?us-ascii?Q?QNdca+y2KF6XBISapWiZGe0Su0+3SKVdsAsUoGINoGbpIWoxFDKiYsGp/hzx?=
 =?us-ascii?Q?TeeTDkgn61P3Gl8reTLbv27uhoFGTrAhZyUQw7CXF5Q8VbfCSzpW536pEa0R?=
 =?us-ascii?Q?GQFJymM0Dnvc2zVZf8OloaOJD7/8ZPlBy4Bh9G8ks1tSinAvwJpbFB+SJs35?=
 =?us-ascii?Q?398KETJQFicOBwgvH7xRLLRkZtQW48B0Je+oxzcH6JZ9uqFYboJgvbPv4nsg?=
 =?us-ascii?Q?qqfLOm6Yo1ZS23WyWZ1Iao6CZOTbLPAH78JxIVR5f38mmr1b8Fh0lO2T23K3?=
 =?us-ascii?Q?yIRtJ+p/3jLdqQMYuITeloQRxKKQ/cMWb0r53axAvAVftp+udhbB97gjqgo9?=
 =?us-ascii?Q?7UQ8/mlBk3uPjqrRZ6wAIv/seUncd+fgnRdNRIKxP0mslxC9SGJt5hXU0d7o?=
 =?us-ascii?Q?8DVT7LXpvItZBcRl+nD+bYU4a6bqrkfHaFMg0YTV7EZ17G+p7GJxn6BjMfF0?=
 =?us-ascii?Q?HAOW3yhpWzOAZJXODntA3sAmDsN4ST5QCuj/ZnQMUgpOpRF5t1z55iZMO6pd?=
 =?us-ascii?Q?3k9e5Zv6Td3xrOf3hh5FCH1MZ8HSCG3oYC5z5RHV0gGyTiM2Qxh+sQwhPQZx?=
 =?us-ascii?Q?sV1i87vaGLj0sUxeGYWa4k9ngq8w9js0uDVeq6hn7dZv9Fhb1w5yeQ6VeKMw?=
 =?us-ascii?Q?9vjDUcOWGXRfhzjsztKzxV1xH3lIgDBKcvCgv/tQeD1hheoH/n0iM17+pBaD?=
 =?us-ascii?Q?4gf4+mqEWNK8ALdGFnrZKDy2OYpz0tvAwk5BLqhPQN9ebGoBebZqQZhoXARG?=
 =?us-ascii?Q?Y+zVafSBUKRtaCbRpQU3natwAs33eFS2jrr0B1VzhGqFkYWxwl0eu0iXrvMg?=
 =?us-ascii?Q?woBvEb0feWhK8U+scP7YNPGr1rk5vSHlTi+QajEzm+0u/+i9ZISqacNmdCwE?=
 =?us-ascii?Q?zgwu58aNywV5sSCg7hyTjxLtsGXQkS7xOoeQwQOd73KSNf8XhFMRKj8EXvhE?=
 =?us-ascii?Q?+WzW/FFea0SHQ0RAo/4f8rQnccxOVn4xd6GHda8q/+bcv9tV4AwqJ1DnYxJ5?=
 =?us-ascii?Q?HRR5AJcz9AHjnK09F9hKaSQ+ehRybXzagnsJSn0/faUKUuOcgPr69YiosUMZ?=
 =?us-ascii?Q?VBtjsISao/y5vv7yO4IwPqXBV08kIfcbL3IGjAN9SJUi6DyjerS/m/1bOLEn?=
 =?us-ascii?Q?RuBk7Y3azbQToLk18fbRaCd+ieTgp82gU2peVa+uClT9PeIZLifXIQv7gDIR?=
 =?us-ascii?Q?caF4Nue+mfzGN/r2WNfS7pj2JNjw2IeIc0/yHfNg+FQig9mK4utDYItHjC4n?=
 =?us-ascii?Q?Gtnete5WFW/GtCcYVEh/P5gM5bdetr0ZcpgavNtkBF4UCpACO7BavjKuTW3J?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d6e30e8-4726-4c83-e784-08daa0bca759
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 19:15:35.2079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4wIaBtgi9VY2WzEUXxy4T3z+cQIlt5dCWPzExivaun5sFXRCIYm/tB1RTIv7ePyEokYyAiv4cr5Ns5vpkV3xXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7029
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This address is only relevant for the vsc9959, which is a PCIe device
that holds its switch registers in a different PCIe BAR compared to the
registers for the internal MDIO controller.

Hide this aspect from the common felix driver and move the
pci_resource_start() call to the only place that needs it, which is in
vsc9959_mdio_bus_alloc().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.h         | 1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c | 9 ++++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 535a615f2b70..4921f5cc8170 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -85,7 +85,6 @@ struct felix {
 	struct mii_bus			*imdio;
 	struct phylink_pcs		**pcs;
 	resource_size_t			switch_base;
-	resource_size_t			imdio_base;
 	enum dsa_tag_protocol		tag_proto;
 	const struct felix_tag_proto_ops *tag_proto_ops;
 	struct kthread_worker		*xmit_worker;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2234b4eccc1e..4ca9fbe197c7 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1003,9 +1003,11 @@ static void vsc9959_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
 
 static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 {
+	struct pci_dev *pdev = to_pci_dev(ocelot->dev);
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct enetc_mdio_priv *mdio_priv;
 	struct device *dev = ocelot->dev;
+	resource_size_t imdio_base;
 	void __iomem *imdio_regs;
 	struct resource res;
 	struct enetc_hw *hw;
@@ -1021,10 +1023,12 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		return -ENOMEM;
 	}
 
+	imdio_base = pci_resource_start(pdev, VSC9959_IMDIO_PCI_BAR);
+
 	memcpy(&res, &vsc9959_imdio_res, sizeof(res));
 	res.flags = IORESOURCE_MEM;
-	res.start += felix->imdio_base;
-	res.end += felix->imdio_base;
+	res.start += imdio_base;
+	res.end += imdio_base;
 
 	imdio_regs = devm_ioremap_resource(dev, &res);
 	if (IS_ERR(imdio_regs))
@@ -2665,7 +2669,6 @@ static int felix_pci_probe(struct pci_dev *pdev,
 	ocelot->num_flooding_pgids = OCELOT_NUM_TC;
 	felix->info = &felix_info_vsc9959;
 	felix->switch_base = pci_resource_start(pdev, VSC9959_SWITCH_PCI_BAR);
-	felix->imdio_base = pci_resource_start(pdev, VSC9959_IMDIO_PCI_BAR);
 
 	pci_set_master(pdev);
 
-- 
2.34.1


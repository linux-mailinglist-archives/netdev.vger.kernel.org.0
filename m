Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DD56A1EFA
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjBXPxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjBXPw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:52:58 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD536BBB6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:52:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HcO94V/6X5U4BlY09z12bfrEWYtW6uPeZd7VUmxfWuQAeGpUHxjwOiQmEP2lsy81R9z2yPcbm54VeBPUp/Wr6U2Osm2fq8kNTyhEkF9cplJGGizm/yUPdtC2IvH/ZXG/Z58BjebjyvXCkfGaT4QNcHNTAvzE56tY7yRNzUPrlRYZ60tii//H5IU8f0KjmMOswFIe5xoqAFp2+D+5xblKgCOw7t5p8eeOtg5SkYj5w/vNeirsIdZWccdlbJbtaNNbH8hVZo/8Joe5aZV6zke3dVJ0cxJ4IcV2iJja7qFUi6ZD0tL/SJ95nyDWmD9OMqh3JBmyNto17FQJKzUqsudTsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckCCOWJmh2Vl45rxeydv+ns8rRyGEZXMLSSUB3vB8dk=;
 b=V8g6HIlBKjjdEf0EXgHVUjcQvqg7xpYcaAzR3iCzKc1qhpj5kY3JkJmumHiAgPDaYJPdHgQRc9dgcOX9PQRDDL88slq7DA7esNLK+R8jLKXPLXlfJyEgg3Df0pEJOl8ETOQgvAFM/oD7DLI5Vjqn3KqdgD6AKrHZt9L2hWFD4Tw8HOWH+tUhv+j40FAgfVIHYnQ4hpb2VSbbXdV3oHB8Ba7gRDjVjNJeO4kMIUxdP2YZ0oSWmfPb2uezw1XEcGJXoc/+ILSp/R/2+t1lZXohVz+WmvsNiNeA2wDMM2grvJ3W5Hb4Ey0DpkWo8NF3CDyRTIGeU+VTar5grdQ7sQ2J0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckCCOWJmh2Vl45rxeydv+ns8rRyGEZXMLSSUB3vB8dk=;
 b=PyOpwcQcWFHXLljvNpB4G1RM8F7s1sAzBUS/UikuR+dyqGRq8d/WXVw9oJbHUp7GvZPQXDrx7Z4T7GOcfk1ZG487v5Qq3MONKgtG2u6xNX+OgUQ0qN4YVeXkNIihtFnU8/AnSqqsBGQbNrN7Z/0zXbyoUPBsBYVE6vyYkH1sdOw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 15:52:52 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%4]) with mapi id 15.20.6134.019; Fri, 24 Feb 2023
 15:52:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net 2/3] net: dsa: felix: fix internal MDIO controller resource length
Date:   Fri, 24 Feb 2023 17:52:34 +0200
Message-Id: <20230224155235.512695-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224155235.512695-1-vladimir.oltean@nxp.com>
References: <20230224155235.512695-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0101.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM8PR04MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: b848ace6-16ba-459a-0da1-08db167f2fb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HSuDbafE22g23AgcmUP+U22fhzwe01/dgXQ90R6ZQ9ULKZ2Jq4OzoqF1IxqE9DzpLby9uttOggJcwYYYce6e2j3lQ5ymyzvJe8ijJmaPwDtN6ZDPq6otlPr6UZXNy5EPVzD5jSrCs/BeGO3qZoHz+go+uRcnYwZ/tdTjjrN6x8PjwNkue0w/o05t22+RRDTbUbxsh84hXNAuV3Xykx/5wV9wmg934bpjtWpQhzTPCi4WF4hYgdXKdnA3hzhvMXlpD3KB2I7LptumeMnt+1QSPC1UKPsjLeqCqSo8t3MP5LrTJGgE4Odw/jOcQtW2EGgAu5anTfWBgva5GWzf5r7ZxnCL6UHin5fLu6pI5vj6iXTF4KxKngfXMwnX4WsEOerkoVjBUvgriy0GASlO1wjb4cr02mKx78iOBH45Nrn2i+yauFNeSz+0s8XQtRx2KziN5PYuIq6NT0+HsTMedqVDWbWSZv19f582EJFIfTlOfRCZrbxxol81OV7GMkXBgHfHl2pRz99sX7SvGUwDvRad8hYJV3oiLXscA2kNJYTouhywnQY3YSP1zC1UhYAe0QFUuLX1cdmDlG91qWOM6DrRzU47LZJrrldjlKKkLisQiBD4jJDUjX8nilaaFMbzncE3VVM+h9qdaMsU7SVF5DoAnk1bAQujAmDD9McwyA70nT9xO1HqQSj3F2KK0zjnOWk0T5bfSO2nKJuLy+1NPFPImw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199018)(8936002)(66946007)(6916009)(8676002)(4326008)(316002)(66476007)(54906003)(6486002)(7416002)(2906002)(478600001)(52116002)(41300700001)(66556008)(1076003)(36756003)(26005)(186003)(6666004)(6506007)(6512007)(2616005)(38100700002)(83380400001)(5660300002)(38350700002)(44832011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Aw51OZT0Qmlb6nhSvxjchVdRfinWFXeRwDoIfaXa+EqkefBSEchfQGi1LeyO?=
 =?us-ascii?Q?ulw/tpkgtZE1lp8wF9FIJh7PveS/JG8t8VCwctUUYwh/qvZQHGE4iY/aEsB4?=
 =?us-ascii?Q?nG1FZaVHDNw+JqZBkqqVdvHK3rwseJK+Q0c5ePo8c8EvZygVogy7pI3EPfMI?=
 =?us-ascii?Q?AyXa+icc8qmhMA9oP6R9HBylZbNF60xXMXMGhpYkTjhwG3TsGbayU4hS7sz4?=
 =?us-ascii?Q?X418SoxezXMQUwy4se7E2AI215HzhXHkDIkWvZcf3VxitbAHmcMRUyFcaJj9?=
 =?us-ascii?Q?gqBNjfcYSJqMU/LART5Xa3XstCKNycXvAVYIKA7f2e2zY0tP90Wt4TZm80SJ?=
 =?us-ascii?Q?n69H7AdUU/mc+xkQKMuTREtZ1eDFlbtZcctzjkY2D5whGLBvRrRXYe0AyakE?=
 =?us-ascii?Q?EP0Hsm+/KGbez++Tr6qhcbn7QIGlFyCwLlDdxVsJ0uyg90nPCdvjYh0C215g?=
 =?us-ascii?Q?yRzR13sLhc5nIYpaDLibJ2DBkXrJ4YPPE/i5dx/IGI4MRVsJv+x1bPJn2X1W?=
 =?us-ascii?Q?mV2FMZ49VJIs5mozLHDsVtipqlgtjbhCOOjzpgq7CyZ3fS7TOZh+u74m6erJ?=
 =?us-ascii?Q?dnEEKm2Rk5+zDSMk3Lbij0IBTAXsB1QM8fn84JPQok46opNXi3E9CpMNt2Dc?=
 =?us-ascii?Q?WM0bALXuIyAFq3EUS8voT2ZftTSiqUNaoaDcK8ahpskhfxNi+J9Ms/yNRZ2+?=
 =?us-ascii?Q?VgkItM5NgO/wM1YteDVj5V7LeopkxX515W828d2tIDAFY9AvQ+eAX59LTPvI?=
 =?us-ascii?Q?jSvlxnI8d8b2atTFcwAMKJiIz+PszAmM5Xr8XDxxVc5ABOBvBTT2X7nR1Knx?=
 =?us-ascii?Q?Pw80UpRbDokL5Lr/NmwgUtT2xRL7OMIZ9D3zi4TMbVBT2nm2R1fHQ7G51WEs?=
 =?us-ascii?Q?swK01VP4wWX/Pdle9BMybo7xl2mkXauoLSyfucO964qhQ2Y94NNv0HVj+O/p?=
 =?us-ascii?Q?tRqENpCVzGOF/UZoaMVJewLXsfHdjGPqrqjsKXTBdIWk+E1IHW20TXycHHrH?=
 =?us-ascii?Q?MPUZrFIr5BnbhvywUclJZum/OjjbTDGG4wyou1kKaSuIx1Ed8zk4R1v1icJo?=
 =?us-ascii?Q?jbChsrAzhNhqELblNwZyKT1H/5AiB7bU7AIECJPp7qsDfHfgY39S9dkG9HBL?=
 =?us-ascii?Q?4N6a7qaF1XEC4PjuFKsWOgcFVM5D1DvKXuDoHY2eWH73e5x+HxeScAxCye0z?=
 =?us-ascii?Q?9sx/+MMycSkuHzSN89vkA3czt0Ifv1k1S0XH1dFEaFyC3erAd3VM1jFqTLZJ?=
 =?us-ascii?Q?BLZ5toTsboZNL25MO208hE0nU8YNqNcGcS41ZAl4Fw4pQmhHXSS1657Loo7g?=
 =?us-ascii?Q?zGaEyQQ5SjT2n+FfnbJzT+lZxZEili7mQ7wd5cEnmV214iSrxeFUJrz+6Sni?=
 =?us-ascii?Q?g1TgGNXhZmOXxXYhZB/sOQAAWxZHMfsaSGcNx7v8ET5gixWGgA36KSuhvKq8?=
 =?us-ascii?Q?7ed9os6937YBSNRcY5x29g8j7uQnKuajaRINeE/6Zsjn/hsgsLTzw/LKPW7B?=
 =?us-ascii?Q?8Qj6/cK/O8OrrF3HUMzcIyApjhrOuqSVPprku3DXUCy9isxyDgk7AWnaAkgH?=
 =?us-ascii?Q?zt+axq/Bg8M0FsH/vx9r436VCn2Y/xAVe/9wGq9PFNUq5VW7pE0veuqvDW2F?=
 =?us-ascii?Q?4A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b848ace6-16ba-459a-0da1-08db167f2fb8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 15:52:52.2024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VdqqQ/0cZHpFtQR1/YJyomLxotg1e3Np+fZP/FQ0wXLTdmvyAJ0TPRi/F1cOc7sQtvuTBonVxlj+9PcajN8tPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8036
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit did not properly convert the resource start/end format
into the DEFINE_RES_MEM_NAMED() start/length format, resulting in a
resource for vsc9959_imdio_res which is much longer than expected:

$ cat /proc/iomem
1f8000000-1f815ffff : pcie@1f0000000
  1f8140000-1f815ffff : 0000:00:00.5
    1f8148030-1f815006f : imdio

vs (correct)

$ cat /proc/iomem
1f8000000-1f815ffff : pcie@1f0000000
  1f8140000-1f815ffff : 0000:00:00.5
    1f8148030-1f814803f : imdio

Luckily it's not big enough to exceed the size of the parent resource
(pci_resource_end(pdev, VSC9959_IMDIO_PCI_BAR)), and it doesn't overlap
with anything else that the Linux driver uses currently, so the larger
than expected size isn't a practical problem that I can see. Although it
is clearly wrong in the /proc/iomem output.

Fixes: 044d447a801f ("net: dsa: felix: use DEFINE_RES_MEM_NAMED for resources")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 354aa3dbfde7..dddb28984bdf 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -554,7 +554,7 @@ static const char * const vsc9959_resource_names[TARGET_MAX] = {
  * SGMII/QSGMII MAC PCS can be found.
  */
 static const struct resource vsc9959_imdio_res =
-	DEFINE_RES_MEM_NAMED(0x8030, 0x8040, "imdio");
+	DEFINE_RES_MEM_NAMED(0x8030, 0x10, "imdio");
 
 static const struct reg_field vsc9959_regfields[REGFIELD_MAX] = {
 	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 6, 6),
-- 
2.34.1


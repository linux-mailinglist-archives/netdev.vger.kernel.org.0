Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A1C698E17
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 08:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjBPHxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 02:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjBPHxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 02:53:41 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2137.outbound.protection.outlook.com [40.107.237.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164F010269;
        Wed, 15 Feb 2023 23:53:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VcrPEPijKseRnna7TmjFpy/Cf3VTGPHVjWaG0V/ouKUmdvSG9BDPZijxYL/ZoA9sgpuye+dYf/2fNYb7qJZIoCrIxFUCfvdp/TS+W8EACob5uJWSKiUmwCKiPvQs8rgOLL/NXU4Geg1FPihMSQxxVhWXO0rJVn55SLK3awrxCat3oLXwjE1CxPZeCTiDm0N1DpcQkMPR/fDfqfOEG5S/PvkmQZRvnrYJA+Mqv8q/E/fgqohr3YfGahaXwRnFGGyBaawmLfgx6jJCOXfzy4zP8oHtlI3sPfWRljl25kY5aWyhKTXrvAu4xNrE85wXCx2HRps9rLrPdiGsOHfXYn9EkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gcRoJiCvCkiv8fJLAmXLBlmCWuKMQSYugqM6PhSpavA=;
 b=OaOh2wBDMljeTNQ9DrBcOmZSKmwim53G2vKZ1vh6CxCUvQgozmT3Ry2jb+sSaY+91tvtHo0PhmZ4gYnRZ42tOxhQYKBQtQq+if6jfPjs/th+hmpAwjCj8NQGrYKTfjhHUtR3OAR7i/sBZC4T0afqJh+ndADHaECS7AJ1VHtmqHQqoG2yqlWnDhPqiRpoCw9Ji+G2txR7+00b5+Vk0O5bCS44r7ikszYeUBKdONq8UjyQ3a0zyaMup7L13hK+z+GfkeleSpT0vHtSmRB5VuDUHndDX6rgWwE9uD8W/XV51utcJVZ7HkF/wHu1XKdTS/hLECDmkDdkiQMJmY5qxRfpUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcRoJiCvCkiv8fJLAmXLBlmCWuKMQSYugqM6PhSpavA=;
 b=BvtRU8A1uWniPLHzLbUjkkwjPz6n0AZIn/5sKYEp1QU+ThPnKRmH+snLQwgyqUwyxZvmmQ59PWn6xjd0PhrDAWsnHsoub5U8h3puQqWBXE3tWobRb9Lkc8U6cWsFNdlE1dxSoPWpWatbGucqhAMgwbe9gy/1dkstBOoiKfk9Uzs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by IA1PR10MB5993.namprd10.prod.outlook.com
 (2603:10b6:208:3ef::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Thu, 16 Feb
 2023 07:53:37 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6111.010; Thu, 16 Feb 2023
 07:53:37 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 2/7] mfd: ocelot: add ocelot-serdes capability
Date:   Wed, 15 Feb 2023 23:53:16 -0800
Message-Id: <20230216075321.2898003-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230216075321.2898003-1-colin.foster@in-advantage.com>
References: <20230216075321.2898003-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:254::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|IA1PR10MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: 0430b4ff-f234-405f-f5aa-08db0ff2e955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Loxu0tPfvJr/SHC3XszaG3Dp2Ol+9rb+DNfr4hS5tdLDuz2HOjkLCMVoNHjE42Itr840W+XPMNejsyjKD9KNRQCypoKOFieIC3T+AcvRYF3ElYZu8UzE4sLqvTsFn1SwsJoXR5+xmuFRvQxwRYpEenRIWKUsi4LbOZ6w1eGx0YbLerZu7F0kEfC7RAohNDuHs3un879QWgCpmWbgJ7KPZn7s/c+YIVwecWjpPPYShbqsHA1HOYwU5u6GWWJ5nrbQUd29p4cgzHF/D/bz6D3Qjx1v32xuOCRPKoIwjbYeJ/DWTn8B95L/+t8BfvwWwDwlzizSln9LALNuSPF82ljXytpVA5MSqGrmnQjSsDXZdb8gq5eNrNgMG361H0TGrodVwOjGwtI4r5HbNAGsCnsp3eNeMRQincPZc+5L5l/hxJWcC56vCn+XathKM3zmJgSLZwat1KAvOQFPeDwURqkXK1z30mZakeho98wIvnbfxFPVNiRXyfhAdRlUWXd25H4WBSZq15z0rTc9WZHA0hRabxNiNyeGvio49OITDPVsMjMpb7CObWcfVNvn9D9alqsOUTTG8RcCFDTo4Md+OZ55gNQRlFlJKVgVQR6NYW4fB4uvnSx9peksjdcH3KqWwqN32HXEe9uFlymHwC0cPLOv3BdeNOP9/jxgbuWOr+nU5V1ZYa54B0+q/XltB2I/tOY83TPnUSNod0Je0MpYNpTV2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39830400003)(396003)(366004)(346002)(376002)(451199018)(5660300002)(38350700002)(41300700001)(2906002)(8936002)(38100700002)(2616005)(6506007)(26005)(6512007)(186003)(6666004)(478600001)(52116002)(6486002)(44832011)(1076003)(86362001)(316002)(66476007)(66946007)(54906003)(4326008)(8676002)(66556008)(7416002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6q3K+HGULKKBSwWgmq7lHoE8bNlQF4vu05dZJ1aLjptrOWOtsx1vf2Yx4e3C?=
 =?us-ascii?Q?RTpLWDb4lk53FOwR8A4btarNBHHskE645pzh6BrSGeebDcSkxyxgKqNRP9Wj?=
 =?us-ascii?Q?6sf2sDJMKHNp967SOUk/pNqjSpUmYqs9GIuPN7APyd0ZqciDvADvAhUFTJpc?=
 =?us-ascii?Q?p41wcePUftAcOOmjVnP1rP/8zRWN8vbQX2uAwTpyb0bvEfzO+VEQgvXg/tTo?=
 =?us-ascii?Q?FKvMewHB4ucMPH1+1aIEs9t165dm5/xipP1oW2CMUcv5PTqtVKtXT8edk19Q?=
 =?us-ascii?Q?JcRO0dHNlDpZ55a1w1E+KDKD9Tjxw06ynJn/63f8/rSt/IM+ul+QVxjc1Air?=
 =?us-ascii?Q?zBoCW5dKPNKhgOwsLepMf5Gh1lGzrJnp1+2bKvxqmhnGRekL470EWCFS1yYw?=
 =?us-ascii?Q?c0OWJf1zGQ/QW+Rn80oCaHwvpIFeAZmgtrhXHg0SfkI4fQSvKaKzWT386jXd?=
 =?us-ascii?Q?Dsrb5VcitoKrXUoWkJOpPLo5LxI97uSbEUZ1St3MAVDSmhjO7aKUBzefhZIv?=
 =?us-ascii?Q?gA2kckgW4McFoNuB6N/EJW5XQzwQlOWG9aKomNX57ODCn79J/1VGsn9Q29+X?=
 =?us-ascii?Q?1RVYfP6YLu7gDf3b/jgXFLt0fpG71oaBtddBo/DhL0NES7rlmeb/s768m0Ne?=
 =?us-ascii?Q?rNM9W6OHNOUpovqZXQtPN0tUsRnDHl7yuiPjnhqi6o2C6R4fk1ZkOL19hO31?=
 =?us-ascii?Q?UxVnwPdNFm/5CZN3oPTs5OeOIjDe3BrRnLQEYM3vxgUAKH1nt0pbMI9Kj5OV?=
 =?us-ascii?Q?PtPr4qNXoy0sT3zb2RWzhUZBu6T63rvCyJZOB2mDpIyoCVuS7p8ThEctpqn3?=
 =?us-ascii?Q?Z7GMs5TgFB2gjV+Ve0D/s5jhvq6KxJnzOyCrvCD4+H1krtHKT6tuWrLmsr4L?=
 =?us-ascii?Q?kVTQg9PMCctmfhkkQmjJW+VTsV00BcvbMGzqhiSLgRuRPSuArsIRG7Ys1sd5?=
 =?us-ascii?Q?PKl2nQWAQDI+Ellc9EIT0XP3P/i3qQyjEFl/OJw+YaijzkXBVQNAbj5ou18E?=
 =?us-ascii?Q?9l7zsWAP+pna1WdK72Sp2HUYFnODFRvEMQd9i7E48DllVhu+TUre64tEJNbL?=
 =?us-ascii?Q?c15lZan26MG/dNWTa6An2ZGxmLGHFIn1+gG+Fee9AHFw6wUj/7rriD1SGsiR?=
 =?us-ascii?Q?yyHtJC6qP5s5RYxdfYmoFu48TuKVzpYC5qujIeIGULLrITxzEa31B7WmpAtC?=
 =?us-ascii?Q?kSfDuUtSKJI3n9mbamth9l8r32clDP3bbLfM/36vHjhed4DE2zPFXzBSGfZB?=
 =?us-ascii?Q?hMBFi4xKF0X2HGoY9cTna14+HszERJDYqQj377qSJHgUbIYoIr3s871ClCrq?=
 =?us-ascii?Q?kgk9jeJSL6VUQChw63nfJH0YN9n513OzkRB2VVCOcGLUxTODcpBdt9Gk0uE1?=
 =?us-ascii?Q?R3ymOiXSo58QU3Z8MsbU8eN3bHJ8MTTJTGjLctvm0L/Q6U/Cl/PgonC7P8XQ?=
 =?us-ascii?Q?Sd4B2izFxNc6wkcs6mecwsyMDkmioX2koS51rfXP+psqh6oE9EHlSOyfEtx+?=
 =?us-ascii?Q?lEFjvZVb6/VQePA4sIf8GpO3JiiK7CiHph5RBTtUikU8rJOvOz+mC9PVfy9o?=
 =?us-ascii?Q?TLXBVb4dUGYkRdc6iha++ECVu3pGQVYLw5Ho6FS8kVxstQu7/zAuhCndnH6V?=
 =?us-ascii?Q?HzsLYjpCga7SfCaHnAFFxU4=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0430b4ff-f234-405f-f5aa-08db0ff2e955
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 07:53:37.6471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: js7JFgF6TmJ69qSgx/tp8cecQlQiNCrs8t8kOdkp1Ggd9ywUfvXXY1RDTf9rZBrylGvMe93+yWjN/Lfztd2GlEsxvVBDIBJXlnBGC8+QFvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5993
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the Ocelot SERDES module to support functionality of all
non-internal phy ports.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/ocelot-core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index b0ff05c1759f..c2224f8a16c0 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -45,6 +45,9 @@
 #define VSC7512_SIO_CTRL_RES_START	0x710700f8
 #define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
 
+#define VSC7512_HSIO_RES_START		0x710d0000
+#define VSC7512_HSIO_RES_SIZE		0x00000128
+
 #define VSC7512_ANA_RES_START		0x71880000
 #define VSC7512_ANA_RES_SIZE		0x00010000
 
@@ -129,8 +132,13 @@ static const struct resource vsc7512_sgpio_resources[] = {
 	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START, VSC7512_SIO_CTRL_RES_SIZE, "gcb_sio"),
 };
 
+static const struct resource vsc7512_serdes_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_HSIO_RES_START, VSC7512_HSIO_RES_SIZE, "hsio"),
+};
+
 static const struct resource vsc7512_switch_resources[] = {
 	DEFINE_RES_REG_NAMED(VSC7512_ANA_RES_START, VSC7512_ANA_RES_SIZE, "ana"),
+	DEFINE_RES_REG_NAMED(VSC7512_HSIO_RES_START, VSC7512_HSIO_RES_SIZE, "hsio"),
 	DEFINE_RES_REG_NAMED(VSC7512_QS_RES_START, VSC7512_QS_RES_SIZE, "qs"),
 	DEFINE_RES_REG_NAMED(VSC7512_QSYS_RES_START, VSC7512_QSYS_RES_SIZE, "qsys"),
 	DEFINE_RES_REG_NAMED(VSC7512_REW_RES_START, VSC7512_REW_RES_SIZE, "rew"),
@@ -176,6 +184,11 @@ static const struct mfd_cell vsc7512_devs[] = {
 		.use_of_reg = true,
 		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
 		.resources = vsc7512_miim1_resources,
+	}, {
+		.name = "ocelot-serdes",
+		.of_compatible = "mscc,vsc7514-serdes",
+		.num_resources = ARRAY_SIZE(vsc7512_serdes_resources),
+		.resources = vsc7512_serdes_resources,
 	}, {
 		.name = "ocelot-switch",
 		.of_compatible = "mscc,vsc7512-switch",
-- 
2.25.1


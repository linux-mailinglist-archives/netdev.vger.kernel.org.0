Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1434B6BF128
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjCQSzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjCQSy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:54:59 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4CC33CC5;
        Fri, 17 Mar 2023 11:54:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6n4+t6nyV3pDhqy/B4r1jpxwAJgiHoB9G3PYgAMes7bbIh41IY0uL7eoStIEqtbPntHk/7XrFyGdKg2S4pBHnwrcElqy82fID7uy0Jh9FQCvgClXeqY5UROVZLb/9YUsxtc5NwXgi601H3+ZWtnBNOoG2JJDSbd89YqMxAgUdbtqv9K9cIp8WFORRdoWXesFpaaA37Vn6BXtWeOttiKGCOS4XcB4bIaVo4YQE0jDIE42Bj16PdZlcpSfBMaozt2z8RKAEY3/+YPw85/2OR38q5S5caD7CrxJaf6SfnCfWpgN0hyzCXGYQlNcQbXVcwT2jl/5nDx1KUmHDeFU+yuPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U98yt0frVEXxN7yvtH3nxyAM2KDkva4smn9pvieFhn0=;
 b=XSz8S5oh/BQvOXLFK34+cxBY+8CpFaFJymZG0clHxjbLZRG+gRgLQnWaiL8smDx+V5BAMoJo1qZkPt+xR7M2lsG14dWAk7bID/qkSQkzyHqoUWqS4UuClgXrb2IP8QXXBVyfOmi+JRLu6am9/L5Vgqrg8V2dgaKc47bKeK9Px7q7F1shXJ72IU1exje6Jaoil+DWjp8FcRWMfQTQwT9Jp5vyTpSH4tySR4kq408lq5utr58ut/nnmj9mTX6KbsUBs81TPxZjFw8zeXNU1G97f7qyCKnJgYpdV9JglHNeA2dE1q+DSkAlNW8WMFeMJxfrfkrqyfa58QS39wvEUeelog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U98yt0frVEXxN7yvtH3nxyAM2KDkva4smn9pvieFhn0=;
 b=CJtS81MqQ+sPf4zTD3WRRCy6Opji+kWavYXfeBdYS0g13PQsvKSYfruEYiWCk2qrsYVa00rpOBSlCPVcydIuSDZq+7tCGcsBJtLsi4YUeJAq7emVgTcbjja2qkbNhLtwI2bOIwXG3H0jl18KWur0jWsIT+Bme4d0seR8AdoJ2U8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH3PR10MB7530.namprd10.prod.outlook.com
 (2603:10b6:610:155::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 18:54:38 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 18:54:38 +0000
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
Subject: [PATCH v2 net-next 7/9] net: dsa: felix: allow configurable phylink_mac_config
Date:   Fri, 17 Mar 2023 11:54:13 -0700
Message-Id: <20230317185415.2000564-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317185415.2000564-1-colin.foster@in-advantage.com>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH3PR10MB7530:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a4937e-a1a4-433b-b737-08db27190ee3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qBIS8Tx2pd93CVFM+wN2aC1FT0YKBAvo8cWBElw625Z5hsb9siRWOrH4AHjO3xkTy4dTvYZwta1t56tlnzNxXpafl4l7Bdd1r5i6WnRzlqSpo+u6ThorPOLIxNIUhs8xe3fykAYMTCRHXrB7+8sWsH4uquyaVaL9FvfdpdCPII8qXAz+F4C6O/e5PAjqewUsDUZWt/gHYbp9dgZY+yoPnp24G0VCY6iPjo4HCaWCW4c6g4L6GWp31Xn9H0e5oJBqGbVH50pxoDg0WqIjVA8CRIpOs67Vrw3UZVGTA+CbO8CtUp9dAqQp/Aza0/oVHJNAJJn8uqiu58JwRur8As/p/ByOxefX53eww0O93/V/SWCngYL7UC9cv1MdvlqHUJlXNRnQsAPaXsmmvjQQEgkTElGp361Hkv+DoPgZA36tEwPLhGzBLnD+FGtdtqGPkpBLdbscVw6jRQnDEQXoHMscanQA4ZgzzqSG9YfzXUhslJDNLu06O6aeNmoIFjFqWB2PEDZMiH5pjVJaAVIlmsfX9QVN5/6nhw5h2pWXdCVWPBFIyqNbZNldoIKQyw0PEMvGoEEnAccRu71RBM2MsQypuFtWGIDA07+6IeCfbabtAhp8cCq1sVf9IzSW2TdEbn64Nr8vWwqHsc4d7gELD2bg/3P6Z8N+WNRHkEqKC+x2Jct/rrfOFBALGmfVJozjMzmOzBK3RB33ka0DlOGgGl2Uyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(376002)(346002)(39840400004)(136003)(451199018)(54906003)(478600001)(41300700001)(66476007)(66556008)(4326008)(8676002)(36756003)(38350700002)(38100700002)(1076003)(186003)(26005)(52116002)(6666004)(8936002)(6506007)(44832011)(316002)(6512007)(6486002)(5660300002)(2906002)(83380400001)(66946007)(7416002)(2616005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FixaEPj0yFs7FFqxPfm8qkDNuQCQmEGdiS2ef/GdlJaWnxZhvLUTjACyZP3f?=
 =?us-ascii?Q?ExA7yCRnzJe0P8Y4g4dd6a0BSeuy71ZHQSiTPDgAlWz5GBE9QTqXZAzy1e6O?=
 =?us-ascii?Q?ov3KMPm2ukf0OSfwTM27HkMsIyi4c6zoqDTt1iTHRmY1QC65K1/dTI2rAy9w?=
 =?us-ascii?Q?Xblw8wmioAAQGUSdkuEmt9OFcNg0frBJ40u/pKAtrdnOIDTpHUZfwh1bIf5q?=
 =?us-ascii?Q?8hf7rKfK9DtvAN267HbPvwma1186N3UfNLhJLmfoOwedHSMZF8Kf83egC+2E?=
 =?us-ascii?Q?3eNVkHXMx+Os218XS6lOYlRCDJutVe9NFT+gARyw+VgNe2rvCqU2z6xiNe/K?=
 =?us-ascii?Q?3MIiNbhFjnk233QagerkZCn2IX2GGmaPyU4vWrvx0Y5euVY7VxFmnvkLYNZO?=
 =?us-ascii?Q?pG1AC3qryK+qIMFJiyca2zrp/vgsLszFsQywHzbpUo6A6FknXgH4L4+bmMq/?=
 =?us-ascii?Q?CiITFbnirGUz9O92YGC6UJXOe1F1E+fG06ZA4Y7JX5rz5JzsCttMSS5oQg3f?=
 =?us-ascii?Q?v8622ecYEMO69/FziaOQ2dmQGp4HYOmmpF/qVEF3ojIvVANxpAIe/rB5/gjH?=
 =?us-ascii?Q?sRTz8/j/1mHd1pOtMVekvDkueSh7+MNjwtVRo0WP7um/0qydhFfzZEq1gjED?=
 =?us-ascii?Q?uIpj+Qjdi2VDkYHtySGRW/Kr7dPtDg5bufuLXp+EyHhJDYOCciOgeXc5y73f?=
 =?us-ascii?Q?orBZAAPjQ8VGlbSZLSfgICdHh5klH4V8vbWIbyhU8JIjnkci5h8IxSIa9if7?=
 =?us-ascii?Q?zOecI/aiKK06mZ2ahCjX5Uid2L+y9y7f/mW+JNDR6u0c7mP+oPR77x3vFSB6?=
 =?us-ascii?Q?ccPCWSqv81PC0dTEn8wg8Z6rdmovyuNA12QTcC3InXnsnPx0HM5Y3pwl+K7T?=
 =?us-ascii?Q?ShyiZ7XXQgm6voJsgyO/G9tCFL/bbXSG1LoW3/0KELZT21eGuG9kETBcFOX2?=
 =?us-ascii?Q?nYULN720+FejEl9Fb3nuQ2I1tLEIRxuduzBPsS5Q1IC94UggWFBvIIRf5Z2L?=
 =?us-ascii?Q?DU2Gp2CPCSH/nyweaXL8Q0OJV6cYuS96pAPfkpcohw8lTHw4RLrKYIeICEEY?=
 =?us-ascii?Q?Hr75a30LFy4dmPMCt6yoQYFRns94E9jWcAfTfPnCLAjrR+VaGYcug4i7Bswq?=
 =?us-ascii?Q?575v1jUgXRFyk1uqygFIXePFfGbAbRV80xWM/58ek2Xa40yfI+D7kipLBijf?=
 =?us-ascii?Q?Uy/FBsoZGRlL/3yysPyrwIT0G2blGD0qLovjzVFI9ML3cm5D5V6AqXlBOymh?=
 =?us-ascii?Q?4hoL94lUeTrNQ8z/kz4Qz+flLWNrKs7mKoI+iP64hDzc/aNiKlnqsIXhmHM7?=
 =?us-ascii?Q?Sotyhk7dLuh4VXzts+7qTTej9O0kkdgwak/WV0WVx4jxrdfHVAGvAUPSWGPM?=
 =?us-ascii?Q?zS5pFH+OdZTxBmfNvlJXTxjOtLmHRG6rxC+eUH5MJFjI4wMaVqsahJ1quJXB?=
 =?us-ascii?Q?XiAquqwXfMmPibfuPU/tFmG13QiFAezsr0ZOqtrcd6sF763CDCK+h7qtq0x7?=
 =?us-ascii?Q?YsAwBmcNcVKqG0fwi/BA13OhrEqfOO1leP0pXlWYUAli8DGUMz6w6O50lIOG?=
 =?us-ascii?Q?4SDMINaApl+h/pU89Ov0P13ipLH9nE9OqWwL0DQr84l+gHjfuMJUEYrRpFOm?=
 =?us-ascii?Q?l+43rqO+MZoGzQqM2SMjMGk=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a4937e-a1a4-433b-b737-08db27190ee3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:54:38.2402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DK0GpjbrcuKKq8+mk9SDnQF6q0vocXkqDCFDUjXcdeIJ2EPATbrC6s3f+4qgBEsH0eYQ/3jEUqpGs8JmSIwBTjNA4/vrdQId7l9EPj0x1cA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7530
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a user of the Felix driver has a port running in SGMII / QSGMII mode, it
will need to utilize phylink_mac_config(). Add this configurability.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2
    * New patch

---
 drivers/net/dsa/ocelot/felix.c | 12 ++++++++++++
 drivers/net/dsa/ocelot/felix.h |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 21dcb9cadc12..845068bcbeb4 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1056,6 +1056,17 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
 		  config->supported_interfaces);
 }
 
+static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
+				     unsigned int mode,
+				     const struct phylink_link_state *state)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->info->phylink_mac_config)
+		felix->info->phylink_mac_config(ocelot, port, mode, state);
+}
+
 static struct phylink_pcs *felix_phylink_mac_select_pcs(struct dsa_switch *ds,
 							int port,
 							phy_interface_t iface)
@@ -2088,6 +2099,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.get_sset_count			= felix_get_sset_count,
 	.get_ts_info			= felix_get_ts_info,
 	.phylink_get_caps		= felix_phylink_get_caps,
+	.phylink_mac_config		= felix_phylink_mac_config,
 	.phylink_mac_select_pcs		= felix_phylink_mac_select_pcs,
 	.phylink_mac_link_down		= felix_phylink_mac_link_down,
 	.phylink_mac_link_up		= felix_phylink_mac_link_up,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index d5d0b30c0b75..98771273512b 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -58,6 +58,9 @@ struct felix_info {
 	void	(*tas_guard_bands_update)(struct ocelot *ocelot, int port);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
+	void	(*phylink_mac_config)(struct ocelot *ocelot, int port,
+				      unsigned int mode,
+				      const struct phylink_link_state *state);
 };
 
 /* Methods for initializing the hardware resources specific to a tagging
-- 
2.25.1


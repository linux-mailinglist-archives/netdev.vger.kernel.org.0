Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD77346C139
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 18:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239681AbhLGREW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 12:04:22 -0500
Received: from mail-bn8nam08on2122.outbound.protection.outlook.com ([40.107.100.122]:58464
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239713AbhLGREU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 12:04:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QctDoBNS3rXIZOf4EhF/hbbJCdYGRtfuagqk6Aef3A8axvrnCNelT08kkwnThmgNg0yb5iYfMCA3V1g/NhOGCRLdwvYitb8rYFkSDYOo1MK3RQNxP7yslMqOMWU28Hh8UrIPO0pNIQkHE6w3qSPqKlLsEMMHN6FmhQDxyE/CjgZbUBbDZ0C0qxLzb5ljAYC7xk7eNbJe9E9evWO19K1SntpavwnVWhqO+4NEXvb3BGuxTkpDuAiK8ouUVyAWc12F/Mg+TkzDGQTDQwiKrx72APOwx98cdsFj2gIhfBEkr5Y3ihgUeITeFdhk4j82Foho2dFMCYVYImHzHN18PhHP0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKsV0+aJT13foVJqdh7fX35si6lg1Y4VnWIc0IliEVY=;
 b=N7ZI89AAT3sWSSzRsx+tq1RxV+YlxkGfbDVLpTqtFOOooOcgZLokfYe+efkUQb+QU/9osZkSjv/s21IL3pVKTl9PO24HCWMoho3wePHtQNsIWaGj2N3ei9Z1b6fQBueZsKGI/cGS7MsedGXirNbiXP/QL0mUDAXt5VEeQJagnGtobrc3Wv2tiuY042YZAcxnB4CyjSe0b6ReNEM1SxsYpbdOKBe5r1zzeD/2NipvotXCxmh4Ejhkic6wsfVoy1c9zQ4cZTQI66rtMTL9l4i0Czje/HT3OMKBO7dK2VnLVsgjv9a2c025V+pPPsM+Y1MDcht9iPDT3Sm8IIhenhyDNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKsV0+aJT13foVJqdh7fX35si6lg1Y4VnWIc0IliEVY=;
 b=S+OVnPgrfRTbcta7wmkBN5y4NYOQBdh6Un943KE5uYn7ePASPBPD1sZexocxmzKfVp5kUtWISA+wK/PXMrwMHzcL5aK/kp/ubeVetqqhwa8c/0IJOiMWT+Ez7eY8VsFY5d4dVnfMPhyyOeFN9+LYmvhHqYHrrZBVJELmz7jMkfw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5441.namprd10.prod.outlook.com
 (2603:10b6:5:35a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Tue, 7 Dec
 2021 17:00:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 17:00:43 +0000
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
Subject: [PATCH v5 net-next 3/4] net: dsa: ocelot: felix: add interface for custom regmaps
Date:   Tue,  7 Dec 2021 09:00:29 -0800
Message-Id: <20211207170030.1406601-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207170030.1406601-1-colin.foster@in-advantage.com>
References: <20211207170030.1406601-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0059.namprd16.prod.outlook.com
 (2603:10b6:907:1::36) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW2PR16CA0059.namprd16.prod.outlook.com (2603:10b6:907:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 17:00:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c4d5235-7d82-4b85-6d31-08d9b9a31aa5
X-MS-TrafficTypeDiagnostic: CO6PR10MB5441:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB544167C07C8B4E5C9ED0F012A46E9@CO6PR10MB5441.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MaAcdAXAzP2/GjjDSUJh1qorzAvRKeGLGSWqobvfkpus4rx5WPfhvXv+z0lTSoJfN4lqgMue6cvMQe2NQeMw6BQnNOgDtOpmcW/pe5AiAd+dSVMtBYXTxnUpKhbZi1dXn+n0cxxOEACGAfOB2SjB1xTxf5Uh/YQFayqA11hGeI13SRSUv1Q+QyyE44K+KvHwtk6zoO5f8rCzjR0M5dea2dJpD2rQUspXmELacw+FmGaVLf/0jbTX7Obo8BO+riVVurKCJElw/xg0QXhUagwo/ElyhFnMii7mo5r+HfdRwL3TmqVj3yZ2g1ClzkhwIK6T7vgY/DuTs4voolbDbo2DaVd7V4eWR+NzBmYD75aWEImXz/vtNG/Gl1ze9hmpJDSOW3rKxwfnJMLd6mvBM7D3Qg0xruG4wCKjqGm+5K0AAqsh2thZvLoRltLt931Vgq2J3qXG9QK9Z8qBI/q1cWjiB6BARRW7mSVEgb0hJOU/5fQ68vFsqbY53QVO4CxSUIVqKk7oLoihQLn24yiIwuCh/2cdoxCOb1K9aIOaVTCyqIPNdpc11yvP3GPceJvsen03gw9+iBgNLhdYiO7Rf7n5rgRwgTqsidvocrxQ+z2Yx7yR4prXZ+I4P2sf0u78voPchYNiSWjSEMvLhu/XUfvud1pRbzo+HuNmSCCR9KlDeP0R5T2lsBaXMB0sMu2JJAVtqPbUh9wzknK4XX47D4uHvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(366004)(39830400003)(376002)(508600001)(316002)(7416002)(5660300002)(8936002)(8676002)(83380400001)(1076003)(54906003)(186003)(4326008)(66556008)(6512007)(66476007)(66946007)(6666004)(86362001)(36756003)(6486002)(26005)(2906002)(52116002)(44832011)(6506007)(2616005)(38350700002)(38100700002)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vsp+XF4KFxQzXaTSdoRUuQZm3ZZ57x03j7kzAo9ibEzHBRXBzVCb5L9hgFTX?=
 =?us-ascii?Q?86blA3e3NxQC59Z47SJ9mad72HMCOz9u1aI6N2Tor57/IIqrH8ncmHFeq+HL?=
 =?us-ascii?Q?tLcc7q495buKpNC4BndkElKX9Lgh1Zk4ScTrLeZFCttpdD1HiiuBEF1BawDq?=
 =?us-ascii?Q?0QGH23/JC+VJk3stWCAnVaQQgN3nboG9GfojfIxQgf0OC+a1vObwshGeewqH?=
 =?us-ascii?Q?P86E0wWWMrS8u1MQU1JwpHuTi4/kUJSF6Hg2rzEymjan/3LT1PyZsHMuzmmn?=
 =?us-ascii?Q?Xs9B12aBoG5N1IqHBolwC3ga5FKXxXP4f1TcKtFkE3MltuUvD5hWOAQNRCXO?=
 =?us-ascii?Q?YM/AzoSVdUS8cq+7PKMFbnaYXVb3syWXFA5Gm6/l0usYag/acTBTUaNbvWep?=
 =?us-ascii?Q?IOsmLkE3B66HYmrYpLa+wRNBBMzvOJkqQeVcZtth4p80kamO06lLgjkgbBBF?=
 =?us-ascii?Q?3WY0g/lzgZvTupBwB08hJVmPxvifQe9J0V2Qh8oXHn8GJXZQG2QD/xAqi6PS?=
 =?us-ascii?Q?vd3yux3WEYU9ch55nnU45SilAODhPheih8/zFD1lZa12nL2+Z/asdrJQj9z3?=
 =?us-ascii?Q?UQsetQZ3Hcsglv7FYcA6WFzQyIpISZoNnQWFXKVsZGUzTcFSqFzgFiIZw27j?=
 =?us-ascii?Q?6zmRL5Xwm0dU6I7sLcGRLSeDlYDBgEYsGzCt43oepNBYZH8JRAouDuBr80ES?=
 =?us-ascii?Q?yRzewAgYqoQqXeZXmAYWb3P07xbBOuU3Yg2k41VePJVlFZJ/WTMhke566T4+?=
 =?us-ascii?Q?zgrFdmmCPVBdw8CjdjrxhaBxYN22nHWOUiX9bcRt//tMBiMVZMGvtUjvmdgB?=
 =?us-ascii?Q?JN88BOz8YNEX8TVsSoVJlxe3QBddpJEFSYdYONfQSfBiwk56BXSvLJ5hTkle?=
 =?us-ascii?Q?nVoGzim3B+4quQhfsH0GRwOxVg2Qm7LZ91+JVsTjPkwePbvieK59hh8wXIG7?=
 =?us-ascii?Q?WmF4ayBsK6N0C+pqMK/DkF8L7rxB+C4RtNef2oyY4GkkpGdXgWmfpC+kp38M?=
 =?us-ascii?Q?cJ2NJ5jsW+KamV8V94t1iwzQf9pdOaCTHFZQPeEJgdKvAM0VfS06aTuw2QYY?=
 =?us-ascii?Q?y9dxZloqZ7XVMnFP8S9qJcgYIhO/edcYPf4z0qkw8/79IHaI0cfw7GCtEx1H?=
 =?us-ascii?Q?fMIzI6uOqNAA0ELEQQlvfIQUpqPmuuZJi6l2DOTwcdVyLdoZDa/9ZEG3Il3X?=
 =?us-ascii?Q?0qZe0UJ4I6FDr6wd48ZEQJa5wGQLdVgoWG+ckUibiL8cjRl/EaqHJZJ4cESj?=
 =?us-ascii?Q?2apt0ZREXaYzcYOreKuk8Cq9rtkNQruyFykksHGzK6BfTaDoKZvUqwxsl+92?=
 =?us-ascii?Q?HkpElKwsDep4EYN6q/ygRSKw6CrWlSoC0YR7A2bDKojHzl68V/mzOmot0aoP?=
 =?us-ascii?Q?jTXz6fO1OFZdroasFXLiS10P9W4c5bWZUcYQusRjJwNYv/V/uodU0a91JCKv?=
 =?us-ascii?Q?1wAK8MiLgtmAbeh7tCRaK1RrvV9PnwEJTTr6z7w83se2pr3Mm74IQGpU3YoL?=
 =?us-ascii?Q?/vYnAn8UZ0zKNdeo0Dl8QnFOKSoFbu2LxK3YNH9FyCD1LB4czuxKIlvVsdkw?=
 =?us-ascii?Q?/gt7dn0NV+dZ/qhrltD03Ie4XySNdK6eK1RHyDLiEEX1Ge51BVP20lHTZWpe?=
 =?us-ascii?Q?CrUIngDCVSIwnYrOB9WQyoryg9j/TNv3NLx9jxbvGIFFPkjiT3YRKlkWrFtq?=
 =?us-ascii?Q?eIxzMg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4d5235-7d82-4b85-6d31-08d9b9a31aa5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 17:00:43.0001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2klX07eMrAVIn5L1zUOWcXAIKjFg1RLYSGpl03HRw871dM9ytG7dZDGYE+9k4g8ocUVefmc1FVJox5sarxRtExTJ/9yzC1+7wtAkVsamJ4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5441
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an interface so that non-mmio regmaps can be used

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           | 4 ++--
 drivers/net/dsa/ocelot/felix.h           | 2 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4ead3ebe947b..57beab3d3ff3 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1028,7 +1028,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map device memory space\n");
@@ -1065,7 +1065,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map memory space for port %d\n",
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 183dbf832db9..515bddc012c0 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -50,6 +50,8 @@ struct felix_info {
 				 enum tc_setup_type type, void *type_data);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
+	struct regmap *(*init_regmap)(struct ocelot *ocelot,
+				      struct resource *res);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 0676e204c804..74c5c8cd664a 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2240,6 +2240,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index b9be889016ce..e110550e3507 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1104,6 +1104,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static int seville_probe(struct platform_device *pdev)
-- 
2.25.1


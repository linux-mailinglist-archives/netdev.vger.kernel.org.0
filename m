Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7925E5A03
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiIVEEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiIVEEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:04:02 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2106.outbound.protection.outlook.com [40.107.223.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72C3AF48E;
        Wed, 21 Sep 2022 21:02:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rgk1kyYT5AY3V+soItT8SKhc6zIX5HI8wDgUXcwfv8SxbZ3Gwofq+PdOuPVYWGybNc1nJmxIRKISd6z1UaSIUvpVuCVrU31ULzbgfw6PXq/DRTvH0lDEAnIoZDlVjtPX9PC305SDN8rlxiXdrHjmjsv2/j3KZ09Bjbt2MF+uwb6Nk2rGgT6FHRoItasmd8CX6S4lB1CfgFB65jBCoz4OI+0hacxDSljYwy/8P/Po5nMiCl1CzpAUDlF/wl215RFdcPJdldijxOZ1FwAra+CrOH125E5PomUdLFKstttoygjPZKtZEcApI9n7Tj1pZD5Nv0CmKiq0Bpn6RWiu+SHlYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/n8RK0v98+d7c0SY9gkcOV6pbpiXqD6OzHjwmVs/J4=;
 b=UURB3USGYVnggrBmiBjuiI4UvU5Rqd/1Y9EeguI6oLO6MQAmNQ3u/XLwX5PRP7T1+/vQCeEFFU0tm1fvG39eIzTzjlP2oAj1ss3p8+SaUyXEzC3kgQzmEkL4f+HRL3UYM5iciFpwfHB0ebIMS5wI98irlhcCSy9tl6/ew5qx91L5xZiF8lDONivCsnbH/MCGJRruXpShST3WBIE82xBYZ7yrytCAeVmcAMvJODpzwJPr7ENxnnYQ0LDbQaSJGZpHvD/OVCGlh5yyzCVxdcQJVb9P3xbb72WlTVBt2MhYHITnIpu/flwYkdqIlIqH3zvBCKDu5y/owt/k2Vv3mlir1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/n8RK0v98+d7c0SY9gkcOV6pbpiXqD6OzHjwmVs/J4=;
 b=aeCWbU9fppzm/Wqu181W0TS5U/7buWr/3Ptre51qp+cwmrRC//KB5CFpwYLP21anRo+w8mvUHtBbZ+9O8rIsi+9yjMCnrJ+spkaqh4jPcU/qrteALqKZgPSA0TmZToxn3rExvmS6fBdPoWwAJec3puR6sYXButVVItPOXUrViDY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4412.namprd10.prod.outlook.com (2603:10b6:806:117::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 04:01:41 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:41 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 14/14] mfd: ocelot: add external ocelot switch control
Date:   Wed, 21 Sep 2022 21:01:02 -0700
Message-Id: <20220922040102.1554459-15-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: a731b424-cf7e-49ff-2967-08da9c4f280d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UOi699KGPr9jzPD+alRqSYZcxLiWuloNJS+2lZWuBitU/xYMF2ac2Ys3lkEMsWYWCBT08rjba9fdgUQMORos+lYvEumpoGD+CzrLKLmmHMg3ZnODYYnSgLXDSghnfhqWe+HxkHrqpdG2elAB2Ws8KDt2dXnBGJJ50WhNVcaGlLpH/DLmFvxAWANpjzlKcZiOx4gpa5F1Pqh/J0T3jJCPWGcK4j6t84rhNdiUc96yrqzIej5VV4sOGuikfU7qR1Z9IJncPRaSrJgDaY5F8pLntD/u70UQA3w1rfSX+z7MQaTjHGdVVpm5gwV2l6JYi1wKrRUgktARIGo814G5gWicmGkbN2UAcaoqEwSqxvDwjT1YRcNLiqqj4NHQqeM3OoQ0/wZCGyjrEzvp0Zckv2BwjgZVdeL6e+tst3WigMrRiyiqL9nutxY7Z9a/pYzc6Uvp+AcajccdUjAZT+0ZDwDnRnxG218GqqHt+J/R+RF0uw9YhnFZpA+8jcKAEXm0Vl8nC/qZvPSJ5mWQ8EABUl/h3d1cgfxjLnSVflDLuDm752A3AfbHHMujWPg9F7H4rI9OcRO8kMpfV8ApmDqIjmYFqmEedEq9I/8oy2eGq5d2O0ZYixfyQHql5OJO1hS7dj5Rtt3wz/1fxOdYUojOgp9rJo9nvCnhLletFbS+5z+fPxGy1PxAdM73Vp70lIeneeObOpXu6QL6OeihJtqOfC7TF3MpTb2guiqJQNW8KnvYwbAD2Hik9HiABFhUcdsq/FbRqOmdpSXV+7J5r/VKIJBKdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(396003)(346002)(136003)(39830400003)(451199015)(36756003)(6506007)(6666004)(52116002)(6512007)(26005)(86362001)(66476007)(66556008)(54906003)(4326008)(66946007)(41300700001)(8676002)(6486002)(38350700002)(38100700002)(2616005)(186003)(478600001)(1076003)(2906002)(316002)(5660300002)(7416002)(44832011)(4744005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nwNkTbTtJC/bzKYQpcVlFaVbK0/3ZmfwHeSvFghemCY6jXC9lq514Zd48UG0?=
 =?us-ascii?Q?tvrrBwA0jFdO26I2nQNZZcT5RX3zpscC6zIWDXunWQYDe7tWrhRSxdP4lfMR?=
 =?us-ascii?Q?kHqOV4G1iOOVDKqCsIz4cjyoKjSU+EBOoSHAW7EQxxm3ix/LUoDJ+VyKvgFc?=
 =?us-ascii?Q?4H+FL5rPRxQsW8rMgCLvtnS/uuFeD83meqCr16BsFyPZtJia0WN1aai3cE54?=
 =?us-ascii?Q?JeuJqOcRsLTzcrUgm9AgNepCG68Usg17+5cp8zxIG+rH3wRJT8EvsMSOxXVC?=
 =?us-ascii?Q?18YpAjiy5OaHcviTl9xnNP6u0YY7+fvwmRxjAgnpQXngbxJiYnzRVlPGqPjC?=
 =?us-ascii?Q?BjtWlTTfuNAutWcfws89KExtAC3xRyzb4y3WO9BliV7gS1o4GtcgoC1XcCio?=
 =?us-ascii?Q?gyCKzdppg1pomo54XHE9ibgp0AhglptK08qI2EaXewmtF7jusrmOpa1EYneP?=
 =?us-ascii?Q?7y5PQrggb6Wlpy7CpNc/XIVstlrfQRV6ZfEzclPBpz0JJeH/SyX9WTWIdHlD?=
 =?us-ascii?Q?O4EEn0aRTcOqs/bpty1uhynzWh2m2HomWtpqsurJ5XJ1xcTW0EcnwKyF+pMi?=
 =?us-ascii?Q?tK8NIQvLCIJqXASBYUsXU4T/foHg45O+T30J3guqC9dhP55FIpbCrQMf+xCh?=
 =?us-ascii?Q?SEbBSnqMxTi/tG4Q8Z2geEKOSk6nJjJehsyCQXehZ5avoflbjf4O6YmUtaLg?=
 =?us-ascii?Q?gcEMZg9Dd0x9APLzjd2G5hRY5TXlbNXojSiv27dI27ZvngcdV1rsHy/4RQex?=
 =?us-ascii?Q?iNPTe0on4wCmosj9qN52vZ+IchWfoxyKTZp3k1013qdJQbQDOwtPQHO+ToUy?=
 =?us-ascii?Q?XpxdsKET6sPxLbY7f6yk7VpLWF2NEwzbLP3ZIQrpEU4syYuGqgbj5iUnBpz8?=
 =?us-ascii?Q?32LVDKEcvrxzbqjGVbXFIhnWb9Btt1AXZeJQamrI4IbsjObrCoJX92Boys5G?=
 =?us-ascii?Q?OLYRCXkBQvpXOZ/fmGdGBuNjP2e9dOSz19ab0aPRDebp0vpBxWWa8aSyo20x?=
 =?us-ascii?Q?nwr5yVoo9btZTA1lmz89NicpMnJGnUrjvrah1oCQeG1iXtQedo8dxK1l+T0P?=
 =?us-ascii?Q?tRRgTaCCKLh7f1DiaWGsrAAeOIDc2IhtUSyiSk0fzeU2yJGDz1B4gajH1G5j?=
 =?us-ascii?Q?MOwx1Ymumw5x8SIDkrv0uaGzvzU7DtGaNvVkWORzuGZ2CACiAV3p8VABiJc9?=
 =?us-ascii?Q?Gp79UdbKfCsoriS3BG/L2ifO0ebHYCPZ0BzpDveoFJx9/wv6rnoA+zib50re?=
 =?us-ascii?Q?rMkpyGfXsH0eAJsy2SrpkO66DzoL/rrsmId0eDcNvLMOeyCTUuk0TGu1jP+C?=
 =?us-ascii?Q?RgsbxQPrH2wdYsru+5IXteJUlx4fCnhNspGCA+DWX9kyxbRjWqu2BaP/f6cq?=
 =?us-ascii?Q?TSB8PYA5IUMM260dWFde+Oy7vstW2voUSAyPax+AeAo8AXfmrxr44/6+RYfP?=
 =?us-ascii?Q?dTpffIBqEVfYaD3htGMkybiHkHAgIauJ7SirjS43Bp8+P5uACRgL0JlgNBQ1?=
 =?us-ascii?Q?8VuF8w2xWT88ftm6UOR3c/IEkVsjZQwJJVUsLm05Tfdsa3bh3Mk+SfpU/HnL?=
 =?us-ascii?Q?ROUMQURNQFkd4v9nu/x0ZVAxcncskA2ZtX5mhqeA1pbz9ouIrjQNEz7yaUaL?=
 =?us-ascii?Q?Yi7aAF6QEd6F/yaLjcvNDGM=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a731b424-cf7e-49ff-2967-08da9c4f280d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:41.6365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4sUdL+VEoDkOuKLm7Nl5S5vpus9Ze9lfdSz2AF3/bPyiG2BLAehEEvOuUVjYYDVbS9FyYlPJUfZksYhbT78JP9HoP7BKiyFKLq72xxGEvEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4412
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize the existing ocelot MFD interface to add switch functionality to
the Microsemi VSC7512 chip.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2
    * New patch, broken out from a previous one

---
 drivers/mfd/ocelot-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 702555fbdcc5..8b4d813d3139 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -190,6 +190,9 @@ static const struct mfd_cell vsc7512_devs[] = {
 		.use_of_reg = true,
 		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
 		.resources = vsc7512_miim1_resources,
+	}, {
+		.name = "ocelot-switch",
+		.of_compatible = "mscc,vsc7512-switch",
 	},
 };
 
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FE967EE46
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjA0Th1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjA0Tg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:36:59 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2106.outbound.protection.outlook.com [40.107.93.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F95F83074;
        Fri, 27 Jan 2023 11:36:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrqY6ZPA1iiyh3ojEJEm2JBDxIFKY8IUe2DbjTKJXg68MDGLNu5y3AJhRnOq2etFLPzVRnal5GQ1NuCXjrHVVJaBCRTwY9qRzsUyjBmCkzH1TlI7XBX/8tHrJESPt7Z7sj785iTVX5HGrZpCM7WFrevnyaklB/kYlLdO9tBpGsRA75CSD3IzipUnLHllLQVyshpLZ1DqNsvYdiDNaaVt9UlA/5fRlJjIOxfB0upQTT2WrjMm7OsO0EeAGA7kPNfbSOsPVbz6NONC98TrWXF0+Hzli4EG10Rxsw3rKRZbgEz/um3yIkjMJz/k3L/TojIUlQiRa6OUiribmR87Rj9wcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlPZT1EXglkoXkEs+nucm47znfcXnk4bOI9ZxFdoPnM=;
 b=Gtp/dxtIYHGN1/r7emQMeFC9xYn3kkppkJw1DK8nc3IWayUnHqcLasMCVO1SmECezlJJGb7PTbctEv4H2GDjWAD4sSaCUwyQduBZUt9JVJzJf57nAozgTfg+G0nx0ENLU16VCnxAmgKNOl2V1Sp87R+OWn9nFGWv65KTHt9JEyrKxNoYlMdbblwdI7Y3hRj+1oQJWMm7XjT8OJmxpT9gtMrIi5a+rQTGI3JXvw0nBFsVd1GupXWTdH7RNFdEqR7iowGDnWPAvp+4BoLIFt6d31VEbtrgCMuDeXioWgA04xHBdNi4wSKlYWIeQ60d+QAwRTozEQwLD7VifD/vttmPHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlPZT1EXglkoXkEs+nucm47znfcXnk4bOI9ZxFdoPnM=;
 b=IrDHXwPwt3LBR1gjGUDuvt3AUdbGjuopCmdH61WpVqvItWC35mqEdJIkfU8I+Tl3vMU/RAj/uRSmcBbiiQsF72JlVb/QGsyfpLcywQtMMFVm1MQDQAWJ/hzyagXlSqRc6zN/t7QGDKZ2sHI7Ijsk4tzC4/lprN5MSR2CIxHKj9E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 19:36:23 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 19:36:23 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v5 net-next 07/13] net: dsa: felix: add support for MFD configurations
Date:   Fri, 27 Jan 2023 11:35:53 -0800
Message-Id: <20230127193559.1001051-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127193559.1001051-1-colin.foster@in-advantage.com>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b5af373-871b-4e11-89f1-08db009dc5ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: crjRVV+KfVq9R+JEx22/NRPkgE02+r5TA+fkWQBFZlCSq9fASdGXqxME8H/cBPEbw4SkfNT8WISuHObTt21BLntYTYMHBF6l87wG6CjlKZ3rWCOOi5vmUCIbb+fzJ3Q+tmqj4FlyzieDLTphQU2jJmqjC8CrEGEMFJ24MH9j9nVsMuoxlxW2nHGuT6WsQ/bLNetKHzvCECHOy7aguFhb9oUso1fqcHLU8FDaLogCE1eaaHkEyaFE1bz5lbS9PF2mrESMIsTEN3TeKVXwgzXiWu0/qms4KSIO2Pc+pz7YTeibQw2HA0Lwt9pAoNY90RFU52gZ4g8FtyQmonA5Wa0sX2+cqA5yLzI7Lrx4ZABn+ykoeJYSe+MQa4nBgsN9A2ucnmADYbzmxglG9/x2tW96uV9tRUwyP6CegrQ9dLUViH1JILtUaPWvrC66njWkvs5p7fESjHUDdyGEgRiK9GDVctzIpIAjt1LGTiAdm0pX6DlkJJgkJ1uC8W4duZEQbpcofFUwyRYAgYtHnBQ47iIIrBh+Zmt+FmmT2P4Z5YTqNQIMQPhjDdubCRIsvTkPWJGPwklAiZdv199rtOFoaGFI7IUAjL4ufSczoxeyQdz/rKnDDFzrb8xdwQWWWORIMFIRW7X2M7dtio2uxlsi9SiKF5Hj2kWUnQxzfbozYgUmlTWlFY94qWUPv+vEwDH3JmpMSRtdcoro/X23Sq5ksgUbOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39840400004)(396003)(346002)(366004)(451199018)(36756003)(86362001)(2906002)(2616005)(6512007)(26005)(186003)(66946007)(66556008)(8676002)(4326008)(66476007)(52116002)(316002)(54906003)(6666004)(1076003)(6506007)(6486002)(478600001)(38350700002)(38100700002)(5660300002)(44832011)(41300700001)(7416002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5VtjRdd+bPIX/xJewmjJoXJOAYXC8XMuCN0I6T6qU7r9DrjxpuDNWclRrlQW?=
 =?us-ascii?Q?dPKPlup19mwUrq/+NdNGgoxvWacZiW1qSx6Gl1JCG34cNlC65QmxTwYwI/3m?=
 =?us-ascii?Q?Az+VIxMGD0dV+qqsRO+AYGcwANMViRN5TgThCeiAgnrRMsELEylv2S92w9w5?=
 =?us-ascii?Q?Sqd4Gys6GrAuhNfenbrUwAbn417dlEIkG2IXEqYUi5BOSHOelbv5iktG7tiD?=
 =?us-ascii?Q?bsXwa1UZZTza7bjtbGaNgQaE4kfD33staDK65xPinQeJMq2lWpTo0QYc2gTA?=
 =?us-ascii?Q?Y9yqA3y/qEI/CF5N66SfdXGdoZ1prxgzA7ggPKeBKJGVYIPE1Q0bIWEDQB30?=
 =?us-ascii?Q?2CyDekv36u/YP9tCItVF8jx9mA2sSXLsRSQvGiZtsNAU/HpPiFE0OvFshtCN?=
 =?us-ascii?Q?01cAG7f+/9wPRJoOZeCZdGGsLAtgvua3WN9KEZdYHSGE+dve21AHSxGieEX5?=
 =?us-ascii?Q?zI7rf/v3V9Pm4yJab4RmH4ZBZSSIICm1xhAyxDCBDIOKZfWmkQuPUqW/hnCw?=
 =?us-ascii?Q?htShbK2ZYHnPWwk9Iq0gwCnJxyG6zZOlRcqfy+pXJ6+tR1D6Egn8JJsOycyf?=
 =?us-ascii?Q?UqTLFHqm8XG9AY4ztyCD/j5fvmnX44aMbeiQBgwCFbFuQC+l/VrJayttOu80?=
 =?us-ascii?Q?izy0biKUC4k5QI00pghTj/xAXAUkYavyzGl+M2NY5jGYn6s0tzlf/mZ8M9pd?=
 =?us-ascii?Q?Z3Y45RzbPIP7PReSaKkFOyKHb+/pKTfbQn+9wgnNkFVGJUaK2se1jJQkpkZg?=
 =?us-ascii?Q?mFdINZcKKUpl34v4Bzqx8EcY0qeUFX1MXQcmqFoRq5eO6wzWnocMCZVvarrV?=
 =?us-ascii?Q?xr5eUYTiCTsMdN5HEMWiRx4pqnjNkoimYvBLrJjuK078XEbW8/W0+kVQvZgJ?=
 =?us-ascii?Q?fSfs2FUniPa1mfcESp25zPcEBqZQe7CtLl3Raf23IEgotZT90w7Tcse+LGVz?=
 =?us-ascii?Q?TrITXK/xi+LDw+bIXF8WAH11WDkITXESWxxH0CV5HT2m+CczsQnViVyPL84l?=
 =?us-ascii?Q?sfmYsCN3o5K5zi9pXctU+SFld3tzIknu89xxJrXRzxhGqRF8+NhkJ5BArFhJ?=
 =?us-ascii?Q?4BOaeUx3IL9NLFLgzLO2cCT31XuLbcdKRsfeHJ00dljdwvH0mQhmkMuvheBH?=
 =?us-ascii?Q?1k98eszELcJYFyfmEJ/s/VN1G1aRiX0ArFp6OesfVb5P5FDNdb5PE77n1qbc?=
 =?us-ascii?Q?DFprNHbIF6WL8mqjIvSvU/piErKQF6DyqTu0Ld15jp345BYNm3oV8Yf9+KMe?=
 =?us-ascii?Q?CFu64P2RjUgwGLNRb9XdFrtZGtRQPwdT5iQw1APSxJ0+tUS/BW5YILXMqt9y?=
 =?us-ascii?Q?isFMzF9xF1Tg6Z29VusE3vR6PlhRnszDUG6z+2duq32Wwsj40YjWSEUIq9cm?=
 =?us-ascii?Q?I/Mj031bjRMqL+YFEBniC4Uphee6IMuQiB5dv5iFQBK43zTImV7MgSd0oSpw?=
 =?us-ascii?Q?pOk/Q1TDbT8XRru/gcMbznO02RyzwLI8yytQpNJIak3kx8+eYWbC2+lKE6xU?=
 =?us-ascii?Q?06tiZ/ZWsjHFMLt+Lx/p3drvLLsgILU8MwFzseMDoupz7jb/VWyzuChHG9cF?=
 =?us-ascii?Q?V3ar5QWjB45BwQzHzUeChVssaHUd7vmzMhnuzRWCn5E4YDqdFgEkbXXFJpZz?=
 =?us-ascii?Q?6OvwxmdmsbUbG62B3GCxALU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b5af373-871b-4e11-89f1-08db009dc5ce
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 19:36:23.3757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zR6qxdTyKLOfHm6FLnbF2pa6OduqDvtf52J1laoErvB22toZakPWpKyRe5smyGiSmV/URAonip295XGRD8EgKrexgwoXyjFhekPa7Wo03n0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The architecture around the VSC7512 differs from existing felix drivers. In
order to add support for all the chip's features (pinctrl, MDIO, gpio) the
device had to be laid out as a multi-function device (MFD).

One difference between an MFD and a standard platform device is that the
regmaps are allocated to the parent device before the child devices are
probed. As such, there is no need for felix to initialize new regmaps in
these configurations, they can simply be requested from the parent device.

Add support for MFD configurations by performing this request from the
parent device.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v5
    * No changes

v4
    * New patch

---
 drivers/net/dsa/ocelot/felix.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 462a1a683996..d3ff6e8a82e9 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1315,6 +1315,13 @@ static struct regmap *felix_request_regmap_by_name(struct felix *felix,
 	struct resource res;
 	int i;
 
+	/* In an MFD configuration, regmaps are registered directly to the
+	 * parent device before the child devices are probed, so there is no
+	 * need to initialize a new one.
+	 */
+	if (!felix->info->resources)
+		return dev_get_regmap(ocelot->dev->parent, resource_name);
+
 	for (i = 0; i < felix->info->num_resources; i++) {
 		if (strcmp(resource_name, felix->info->resources[i].name))
 			continue;
-- 
2.25.1


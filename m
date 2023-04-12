Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4456DF616
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjDLMuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbjDLMuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:50:02 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2058.outbound.protection.outlook.com [40.107.22.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22878A71;
        Wed, 12 Apr 2023 05:49:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzT0l9+xkQucwb8At2BunfW9yy/qT44gFcnvc9c0BO2mavXKUhKijS1V8keOPBtDFv4jt6e3uweYPt8R7w+zXY4ylWU6+ZKbtqdnXmIy0HaFuZD1B8lua7cnAH8lV4JwFLlpHmkJtbFeC8+QTyS/oTuxk/nZIVpG0w9WwCw4dMLqqIRK2Q2GfLrvnetnezoAFAokfMF7I5UBzchzw+tdPrO3DdTlDuVpkWaY5Z19tTMEBxpl0HhdxLKXjr/8aboSOZ+JBW4gPnLBwf82QD1Hrr8FiQD5ZTH35bAyngzfeLf3sLf5ygjGIxeSc9c0TEQiTknQqirMCSVL0Linv1ajtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9A3FkgECR+wOrtxS66iwjqK7z4EGPmIhtRTRgbu8FOI=;
 b=Iarnrli3YsHpXVAkC/g1j9jI3H351QjJyEtuC0l8gNmyr/447sK+aKy84OX0HTIO6lnDW8Ps2RNmm6gyHjRNh3JGA9VtGAWxSLbrlAfa2v2Uvl2x6A3wpPuL4y/bBOxkDDXnxGnw3EWNF9CtAFJ3VU4uLlaqmRVUeMnLXnkgOqLeQmAkw/rW/6dO43/uVCa6XeYkUjz2qbj5M9oaspzYYE5s/H5rrT9AqtYHXYZdTr7Gw9rqpGOflCiBhJdHDbcRCQPh/4RTNQhQqry0OJNH0U5NUg1uyVROVZOzone3GkrI6jHHNBneASiouKhOSJXi32JCdMKuCst3stgm8OBWCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9A3FkgECR+wOrtxS66iwjqK7z4EGPmIhtRTRgbu8FOI=;
 b=CaKN/sUswcriWoAGvpTDKiilLEOOvWZ1YxWyN560rURUL7QdaxTsq62N1ixZQmJjpAsb7yBTSHfI7ZxeaztzyWJ2wWBpdZQlBXjzoMfnJlsQDk740QPxn1HEj3nhwal322Hw/vBmEd8fbkIq9+EMEJBF341W+9MhSmkrj0B1PqM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6888.eurprd04.prod.outlook.com (2603:10a6:20b:107::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 12:47:55 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 12:47:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/8] net: mscc: ocelot: debugging print for statistics regions
Date:   Wed, 12 Apr 2023 15:47:32 +0300
Message-Id: <20230412124737.2243527-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0056.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: 19106e46-226d-4f6a-588a-08db3b5422b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hb7WzG5Iy4pCw+AbbV5bg/wwscGTOxjq3fDICDRbhXUXKncIn7shT6Z4I14zMHRjheK4J/XITfjEh/yhjVAP+aqAq7AUAF5kpNiwdRCx2viH3llImnKAQ8If1IDNda1yxs7xPHQdie1JbWlrrWOTs84k5BbTakxiUDZn90jTNcvOMKKLr3JiQGcyCcSKJRZONv8V9LxM7C8ZgFQxv3adcxxXCRrdTTk36Jpk/lQL8qBZJRcfmZ51b4ggpDSszxuyRz0tC1uvy+6KcatBwbO46z6hqif7wtu/GxrEPNoGVPQlboPfwMyQKHFeHcdg78g7twm2pDPrUCSB9kPTLZOxgqODqi4vHhP/9MLiiZKu9gV7pwjY1vJPsHkshGTv7OTdn1fNWyyicLC2KzQp6TH9/4Wcz4y4Ir8f9OrbMKSljPDPWAtCHB+eb0EcEeBA8lDOjIslKFgOIE5ilK9q+UrW8DRhuNeGxIXgoQ1GqTFtDZNLEa/3CDIswyE0wwDTsHZ4seoUlyytSyk+EgQDMMOl1WJnsNj0lZQPSXnMyWlbUR1gyc+g/WNoinyPWQwlfW/oVrP34ojWcdlgRCfypjuXobHlv2TTzzJqzfNizvzsVgFbcx3EXwKpxlkRoPy90+Jr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(478600001)(52116002)(86362001)(6512007)(36756003)(38350700002)(2616005)(38100700002)(316002)(2906002)(1076003)(6506007)(26005)(54906003)(44832011)(186003)(5660300002)(66476007)(6486002)(6666004)(6916009)(8936002)(66556008)(41300700001)(8676002)(7416002)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7kuLUF6uAuCOef+rAVgdEvGBtVqwpN7geWGr9u3Y11qtGjOTdjUDT6nYxuG6?=
 =?us-ascii?Q?c9Y4EeiO83RT4HjiHfOA/SECPZWiX8TLoRNRAHb3CcTAYDterWwxxmhyDgxE?=
 =?us-ascii?Q?yknaglO2CwQJj3k/ti4GKRvhzOy2w4kJdbtulnVOVrR9nx9codm7MUe/viuy?=
 =?us-ascii?Q?ODrgNYwPBjfWKJ6E8kqBmPN7yT+fdCxDav6AdIUzaC/MJ1ADmWGVanXuo3ZC?=
 =?us-ascii?Q?MXMXAylmoSLW1j1aYYa0ViTQRTHbrIvIqx0CRrtZJZ9Bp+mQ8tsRjhyZsbo9?=
 =?us-ascii?Q?bZ7QguTyHU49LltaGgtwh0UlJpEA9JXj85/Gpmi7LF6px7huLCC+rop94D3e?=
 =?us-ascii?Q?Rb5GIS+8lazmeqAzOCArN9cY1pmWITh7zniwGye/EGm3oKCGZLBMXnkiSOy5?=
 =?us-ascii?Q?3aIotTxnvN4SGZW+Xp5k6FrtJz+4e0xURffvFIh94ViUMpWBTOCftIUsquc8?=
 =?us-ascii?Q?OkYrFEAZmzyKC3/zDRh4z6Jn+J7aHPNv3GT8nnBOM2T9kplLezvkctlPzAGz?=
 =?us-ascii?Q?1Dt0YbnFeJ2R26eIvBPf/VWVbBr7OvaYZFFSurcCdlL2q4YSwGqAW2fWe5xt?=
 =?us-ascii?Q?ZDB72qaGaVU1JHjapR46EwKFXR4b36hSMZMqZQehUF5vHfmzeTag+r+m+J6V?=
 =?us-ascii?Q?+FfVQnP8w/u89l9MYIt5trp3sjdWe9iMqlaVXIAiNKj2LcyYIdgTAEY2yIV+?=
 =?us-ascii?Q?wsHRfPAaBtXStnJ3ztLVKPmZOIIESzxcGWNfRWY8Q7JctX9XXmCTyOIHYT6v?=
 =?us-ascii?Q?s9FdwHxYRjELYlChDR4ISDPjfPv1p3SkxfeOgZ+j2zVy0NOd0lnaniEpGCHI?=
 =?us-ascii?Q?jrlrX7XXo7olwsbgEvYrhner6A5JcxM13GHVIFisD2JO17pdgLOSdSVQlx+W?=
 =?us-ascii?Q?l8Nsb0d29hq+exdMElHbHTU9MRuKJI4jcx7zo3czydCCB1C6LGRiTYytZn1K?=
 =?us-ascii?Q?YTBBU9rgbTEf3LSDY0hEQIcmkD+oDecUXmKygm07zS33nw6cPDI2mAm+0OAj?=
 =?us-ascii?Q?z215nXsJa4zoF9b/+dkf/GrMJu/VaoTv+qNEOSBB74fwIc8LTt6IV+U1YYIP?=
 =?us-ascii?Q?Vt5C1ooYRX3uU12IIiwjoRbmaU5PP3WfP1AvI9GuYBeFQm+7aKpYIZfH9tcW?=
 =?us-ascii?Q?K+JGh7NIx0jqEiRgNFLBGHCso0xt2RWjY14wXW41pJtoolfSR3304hMgNUYo?=
 =?us-ascii?Q?W+UiRSGXtwISKJWzLttIkTKoUjq0u5a5oCZQq5bYbq3i0adaB5o8c+EInmOB?=
 =?us-ascii?Q?5gMZorik+ar9+fVfEwW6xeryG2vKWah8B/f2ufUIxb0RQQ4UTc/tYPu1FZO1?=
 =?us-ascii?Q?l/CjqivkJLZyJiFJuMBbpSfQVbp3nNmhEnNxguf5k11/f+WjagkXgCIyqViP?=
 =?us-ascii?Q?pWto+zsW7TkHFsbN1yNwcKf8NvCAvgyzOv3nx4a+Vo2di7RPzZ7PZUZl096P?=
 =?us-ascii?Q?/UkMLfBiRABzthnDYa7hC8LxmbrX6cY6FOGgEl68sHYPewVdt/e79paAqPWn?=
 =?us-ascii?Q?9xTPx3Eo0+a53uZl7QhVcqLOflsPzZBViRH2g4tPIjJn3Xbu950HgZiQRNn+?=
 =?us-ascii?Q?kgswNGrfJV2LQUH0dmpTNMHxrOS+7UfYjfyykrJ9bb6c076j19R1DGLU4xfx?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19106e46-226d-4f6a-588a-08db3b5422b9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 12:47:55.0822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sh9hWutSYRWV9goJleANIHn0glIzBI4VYaUayBcuO0DMDhHk/CbNJruUVxpfbQsCpzXmRWbGN0frcXbcZmpJOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6888
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make it easier to debug future issues with statistics counters not
getting aggregated properly into regions, like what happened in commit
6acc72a43eac ("net: mscc: ocelot: fix stats region batching"), add some
dev_dbg() prints which show the regions that were dynamically
determined.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_stats.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index d0e6cd8dbe5c..b50d9d9f8023 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -925,6 +925,15 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 	}
 
 	list_for_each_entry(region, &ocelot->stats_regions, node) {
+		enum ocelot_target target;
+		u32 addr;
+
+		ocelot_reg_to_target_addr(ocelot, region->base, &target,
+					  &addr);
+
+		dev_dbg(ocelot->dev,
+			"region of %d contiguous counters starting with SYS:STAT:CNT[0x%03x]\n",
+			region->count, addr / 4);
 		region->buf = devm_kcalloc(ocelot->dev, region->count,
 					   sizeof(*region->buf), GFP_KERNEL);
 		if (!region->buf)
-- 
2.34.1


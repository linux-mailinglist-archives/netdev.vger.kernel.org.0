Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7025ECCAA
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiI0TPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbiI0TPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:15:39 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80057.outbound.protection.outlook.com [40.107.8.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A890361732
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 12:15:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLtLvzv1V7tCs/RzV7tQ39MkoXmWQ1FpWX2M00jFdbk7jaNIhZUnTSNhSbNLXIwJRchfm3KVLYqzluTYkLkUUlPgquERV5QlpST5MjFZm4wIrhYpFrIEE1zJLULVof6HJf1RvTz/81utO4d6A0cuJ20X8UWctZlF/AoB4HIrG0WZlR45E5pAe0YhCJYAEoM3+OeRXQAVZGjb8+ilpfAWSQKJpXhrm8249Fc19U9onI1Q6FZU4tAhCTC2is8Klcmg0qEg4XzaMfP0geT79O+M0LJ7p02frz08hsitapz6yy/IAbZDias3SkYnDBFcPAqLwSJ0431Rb8m5G3abWVsVww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dZxyejdX7H1NAB4OgjtxnsKPijr+Fb7Up4fRx9gYj8=;
 b=QbV4Pr3t+PHqxBzwepXxV2XxapQaNMYEcVRZprejrx37LoMavSAmSoyjBjGkj/sTilOLxniYM5XWjuYHRfbeWrY75Kzkl42wfQgnITiHWekXlRgeGkQTOixW8pKgUDoU1df1ey68Wq0SXdQ3uFckYNcZEwTBaWzWfnhipvTV53QLfqwAvG5idrRbyW/BGGXAumJ7N4ECl/v8WTs/Qyntyb6zlU0PcoGDklt8X5vr1qTgvW5JZgbEomkWDxlrqq2pScOcUWuBNNpfOQ2C4kEPEWSIdYEY2wZMH3yKQYRmfjx+Tpyr6h4lgesEHnaOeBwzy+xHtJCHz++a4QliP6sxwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dZxyejdX7H1NAB4OgjtxnsKPijr+Fb7Up4fRx9gYj8=;
 b=o/8mERF6m2Ze/FY8tNVuWcVN0nYrBzytQzUiMbg6P5inuhdHcL7oVnoljZQ5BThd5D5vRrslZBfOL7Qx7cedbb+A1lNSRosl90ebZg1pK8PI+vFOGEGmNvZaU/xHHgtz84IK6czhIEu/vTDg/H3uYSW7ROIYdYCyPV0U464VCMk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7029.eurprd04.prod.outlook.com (2603:10a6:20b:118::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 19:15:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 19:15:34 +0000
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
Subject: [PATCH net-next 1/5] net: dsa: felix: remove felix_info :: imdio_res
Date:   Tue, 27 Sep 2022 22:15:16 +0300
Message-Id: <20220927191521.1578084-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 88441585-ab10-46c1-a3aa-08daa0bca6b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Wmk0lQPmrPQQSY9wqYKgU438GMrm/ubYF0MnPTtHWvWmnccg4ZxfyMpRKnaaeaayeIxhwsn1m1/JGsYi9KUpTGf6DGeXQMsPNZDgKW9gdsIeyC96N/Ajr69LNT+IevhG3uw2ITSStw9s/88z71NabdscVXrAYHnRNQRcD4TuwiuNU/ZgFKFBjjHd2dMUGpj2Ry5z3+JOoFR8UxKFyS1gGpT1YFR2Rseym7/BnEju6nkuVhnyOquslshh5z2UY2gyncfZBGTAzwygSuLuCdaAVNrtk5jNWY3DaLml2wGBUCIZP1UeZp5713Rw49/3xyAMHpalXkk/vw8cv3hu7LZxDNOEnK/t5SfZMz2UiKkjGBuHY+ff8bQGstJDkQa7Eckpy97jnepVlVOZE+UfTjYB50jEy6nL/CPE4MEWk/+UYaalXieFjSUcYAb67HnZqpQRgJjF8we4KkFa1f6ll6/RNf9lS0hUHO1hh9IrFkCCiSfF3JbsIK63t9Ob7f3nYqeL/rsf1Rxo+381P7tuhWdZbI+HfxAf6Jt3fOcrhKqiWc/xTD9vEExip9LnmkYx7ey56l5L+BUywweO2pFWCL13HQKlI/4f6FZKS7ET7Tc+7hPGdFaGhlAV58CGomk21di/rsgsZI0RJjU7DWG4T0I04H9SSJchxCVTE72x6GhIPTaH6TTVbB/iGp6u+P+HD6PtFfkE+TQCEf+YW9up282SWx+rPckPIU9QKQfxG2SLd/aRr6GmC+o71V8t/cvMl4kiSNy1CyeY/yBF6oY/qjRVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(86362001)(38100700002)(38350700002)(36756003)(2906002)(44832011)(2616005)(6506007)(478600001)(6486002)(6666004)(186003)(83380400001)(52116002)(26005)(1076003)(6512007)(54906003)(7416002)(8936002)(316002)(8676002)(6916009)(66476007)(66946007)(5660300002)(4326008)(41300700001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JVC9f7U54RsHa0ZAM+fViO8kX8FOuEhJoxWTBuPk+/OB6AjZljbQD/2EmjAi?=
 =?us-ascii?Q?Y0HOhIW8RppJR1pN6QgvxnmNBnPAje7v/poC/hrLkCgvPEVMFldVjAAhp8xQ?=
 =?us-ascii?Q?IlQiZdhbxDi0l/fvSkO/gd9GKFdGYriSrQMWkV6WO01IpmMzPtAsBX+uyiN0?=
 =?us-ascii?Q?h6TkbFl1VLu3vrsbDQRcL6UtO156E03sBzsJu11NadXmxfl6XxnMtuT17hae?=
 =?us-ascii?Q?n/7eewLKP4I+jR01YW5EX3Ce8Bfy0fk5uxn+vM3D403j1CrmAGKz1KDeCJCY?=
 =?us-ascii?Q?6aaf6lYunmv5SWJYsezJ7KU8s3WOfPByv78GjG9pXBRunELXt2xRridaEn6h?=
 =?us-ascii?Q?p+dRdd29lqMkJaTvxGizGjcubAqop/oNwCWqTLMZYPVwb88LKWoapvbNSFR3?=
 =?us-ascii?Q?q7pZfMzjt4NjmQa4zhU5v1Lfr3oI1u2liiHVlflBuTKmX60jbUSVBe1d3xRI?=
 =?us-ascii?Q?Ek3H2Nfgj7OC+ObIG1V/EUz6kKRewvFF6rAdrpxpjhBiudiic4/UhkIaOo9v?=
 =?us-ascii?Q?+RS0WeW4XsOW3GSNSVv5K/Bzq4h9Lj/55D92VJdSfeQdrymYyxzxVA/6/TS4?=
 =?us-ascii?Q?55ttz6hNrhHzZXYJ23bRAf9tzsZhLSMpJfVOPGammOmaExJGUSgSUcbwkw8y?=
 =?us-ascii?Q?1s03ScJMRx06mOcItpevUPWnA1fy2jw16lP1pAkFharivwdp5SIYxwSW07KU?=
 =?us-ascii?Q?e0mVww1k1oM+2eVEjPiRd9TkS+W1DfLF4TI0qexcqfOrzYllZwMVZ36Ye7oT?=
 =?us-ascii?Q?AJU9JLjyQ8i7cCZc0OBNgSs0pQAVwl3ZKOvzZdWqQHcboGg/SrOEYpiqKleU?=
 =?us-ascii?Q?AQQ81gyi570RBgG02rOmz+7pxC6H29Ggs4dDCLo+ehq9hpEkfyBb+FfRgs1s?=
 =?us-ascii?Q?MhKHSmGposQ83u1D46GtQQDIWukgAjt294zMzJqKO2/G5UV7eUuC3oPAnC3+?=
 =?us-ascii?Q?dP0phF8GPnQlBtgGgpLzQg5YgxnJsq3Obra3mE1GguJddE7becjBveMb19/d?=
 =?us-ascii?Q?GQ1tWmf+Vhg0QYfkvcWhsfSPKV30uhXUneUg3txBbBFutOmx/Ch3lMlZyIwY?=
 =?us-ascii?Q?FL6YZpktO3fPvgYdjRHQKpQ6DqfBMWopmAUtrYvjGgG02TgCcyeNI7cb+OKX?=
 =?us-ascii?Q?q/mM7MxrP21JqOjySY2jM0xi+7r3eE5b2aOTAvgj6ZjfpV7rFIZLKVChWBwe?=
 =?us-ascii?Q?FsAtW2/QRlQzM9SI2kAudNa6s2MqwwXSV6g4Uv9VFjNIAyBdXfhT9kqKa2Yc?=
 =?us-ascii?Q?xf7cVP9rorfZrVrwzhOBq+3nOPKLQNUUA1OORII+AJk24QlQKfZxUs6M3YJC?=
 =?us-ascii?Q?Ai+hpxeUTVcInDalB556iDvJD8ZYwJx/4dHz8xxktOSwqKJjybrLFdpELjrK?=
 =?us-ascii?Q?btINAJ1KpziQYGdUle/WZZp/TTFBeDX1AiYZuxdEKIqr8EB+9v2okRbclZ3y?=
 =?us-ascii?Q?SRtAEDBrNPuytxO1KBHlbX70rl8VkJU5wmcpkXtcTFWMdTYrGX4HDPw2q6WV?=
 =?us-ascii?Q?BDHlEmQnxaq6vGNy4snkXe/o/sfTUG/grITOPk/e8VBQIU7xJ5KZ20YpTXdV?=
 =?us-ascii?Q?U2tjv+tHhWBfAKsGdoqjJ0qp/pgYZyWkrLBg9sUjyLQvSaOzgKtU7L0R/siF?=
 =?us-ascii?Q?JQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88441585-ab10-46c1-a3aa-08daa0bca6b0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 19:15:34.1298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 430PY3IsUIJ9cGlWdfufOCpsDOw3CyeDkHbyfwcL69OcLRV+gAGTBGkAca77xSqVD6W1zAOi+TaxxFTUnfX8sQ==
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

The imdio_res is used only by vsc9959, which references its own
vsc9959_imdio_res through the common felix_info->imdio_res pointer.
Since the common code doesn't care about this resource (and it can't be
part of the common array of resources, either, because it belongs in a
different PCI BAR), just reference it directly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.h         | 1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index e4fd5eef57a0..535a615f2b70 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -18,7 +18,6 @@
 struct felix_info {
 	const struct resource		*target_io_res;
 	const struct resource		*port_io_res;
-	const struct resource		*imdio_res;
 	const struct reg_field		*regfields;
 	const u32 *const		*map;
 	const struct ocelot_ops		*ops;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2ec49e42b3f4..2234b4eccc1e 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1021,7 +1021,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		return -ENOMEM;
 	}
 
-	memcpy(&res, felix->info->imdio_res, sizeof(res));
+	memcpy(&res, &vsc9959_imdio_res, sizeof(res));
 	res.flags = IORESOURCE_MEM;
 	res.start += felix->imdio_base;
 	res.end += felix->imdio_base;
@@ -2592,7 +2592,6 @@ static const struct ocelot_ops vsc9959_ops = {
 static const struct felix_info felix_info_vsc9959 = {
 	.target_io_res		= vsc9959_target_io_res,
 	.port_io_res		= vsc9959_port_io_res,
-	.imdio_res		= &vsc9959_imdio_res,
 	.regfields		= vsc9959_regfields,
 	.map			= vsc9959_regmap,
 	.ops			= &vsc9959_ops,
-- 
2.34.1


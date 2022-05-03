Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C665183D0
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbiECMFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbiECMFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:05:43 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80040.outbound.protection.outlook.com [40.107.8.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31B430F79
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:02:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMXOs8vEEK5YecVpPJxXKr5OUJi7+CMsPz8KQ0kl6hpXWIrtCVyF4YFHVG9IFlaAyJgzvxhf7LLPzUCruzNPtOwTkEjhZTpwsij4i2NHyRN9F1CbAU7EpA6ovn1//zcO7gphy5QV65ZiqQrovqrgWH8PTbXcDEXmpGA9mqK0atinvBt9hTeIVts9PsVNgFmWxA8gN8wxXrymzduoimJ1p+8iBhsl+C6TUJor/9NKVojHWgHiEv/M2Ln3m+FaRnAUWPe7UkAxcnpFPIxOStz4udyA1wPQbCDsBsArjBEAJr2/jQea0Cz5+TDGUIDtIAv8uGd2Vk3CJxHVpX/iyS8u+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ohkYq+kLivhawBUs43JPMHRcu0N/UnSIoogKQAiToe0=;
 b=iL9aKYQtaAC5NappI+KBQQOxJF7SpzWpnyroLhUWnkkKeFad+gMNKvhOpHYx9TIsdwZpLjdXZZlnHnkj1RZrKe7JO0Y0hAXCPfXrdhPVArf9GG9C1zaUpLiOXEtrTDQFAvSsRGFh9d9PFsuY8bXdac5bmBRB5xd+ukEdb+/M8nwvF3gGp97Sau4SoBK1T4GHzpArxqlSoh/cb2y4J6mxdcjbh7sJcmcL8MnRn+rO3Y8jc/FrruojFdsz9NE0XuudS8w203qUTTe6gKeLo8ChocrYcy96eYeYocn6ctfVTpLBbgcLXNov3xBQKJOyrNyXOMx7HxM0UynlsMHtx8gFRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ohkYq+kLivhawBUs43JPMHRcu0N/UnSIoogKQAiToe0=;
 b=VKaHFWW30coRZGjvI+aTJ8HQkyr1KcOTFaIbTlH40G7/ua2s5ZjrfE3gH1SRJWYp+BRoBiGUAfhv4uJ80mnQzCWqbpi86kH2RxiD85FcAZM4ozYKB+Juu4Wh0Q91/rTqsDjwpXxHgFzjP/qbyxg+f3lyBjiSqxJ0xPtph/u95Vw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS1PR04MB9480.eurprd04.prod.outlook.com (2603:10a6:20b:4d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 12:02:10 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:02:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 5/5] net: mscc: ocelot: don't use magic numbers for OCELOT_POLICER_DISCARD
Date:   Tue,  3 May 2022 15:01:50 +0300
Message-Id: <20220503120150.837233-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503120150.837233-1-vladimir.oltean@nxp.com>
References: <20220503120150.837233-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0067.eurprd04.prod.outlook.com
 (2603:10a6:802:2::38) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b58b9f4-e135-49d4-c4c6-08da2cfcc075
X-MS-TrafficTypeDiagnostic: AS1PR04MB9480:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB9480F220D622E3F0CAD12B07E0C09@AS1PR04MB9480.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KzStuHSNX8I7vaA8N4waBcOdcTxR5Iv4qZda3e57UZZOE1zGdLEqJn4C89LV8cPu90m/Jud6GkKS2MSemD/jg1/aDzGqkZSLkh3ZsUE9ZwhTpyStMG7iK0m7CIRMGe9R01rgTOth0o2COjJwQx2+09QpWEclLGmL4cV4dldwljVqvYXmiNi2eFFUajy/Mcep9G4jeY4YdaZeVWM0RbfDXjeouy7wIuPEuxjSzbePbHHkKsOrD7HeFe1r9OeSTkTGGznOWIp7Ht9Ype51CGpRmBLQ38Eui3m9zst4VBQ4KaIUb2tVqk8s4zhHfrLYwRnXitPjfbhem3f4ULkOfJCKyZSS/oD46O31/wPIyweJxEiviuc3+goKq6CQ883cRjXUShGRdhZFDxu2IOtNhBdHKhsJpR7ZZk/Ea6XPR469rxLaXvPGMGq1bGBTH75FCGlj9pL+h5dkcLy9hv4ajm8M5+34raaF2gwd/5+vpk4k+zs4aoqDA4EfCDeu1WPoFrs/Lq7v4cafRY2wkC/ci7wz3aex4Kff754O3SxIk6aqZtcJDid8AZF2a6lmTRPyy0X27ge1o0HeKxToThD04dWygUJZXgFx1xnHGN2a89/JG+jj3IyR/lfW4RVqH5KnnpAiCBKfi9ad70HDGqEbS88WbtgeWUBT5Fmw8DcwGCiUTcc8YVL1n1LK92qjQAW0snK89v/mNXvUD187H3988jrVBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(83380400001)(8936002)(7416002)(8676002)(66476007)(44832011)(5660300002)(38350700002)(4326008)(508600001)(86362001)(6666004)(186003)(54906003)(2616005)(1076003)(38100700002)(6916009)(6506007)(26005)(316002)(2906002)(6512007)(52116002)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L674NZUDCka3KSMlUx/qMcJr/cy4Yq+JRmBz+8xAoCksmMsFKOt9AAbfEIvE?=
 =?us-ascii?Q?NijAUt+qq4nF+WpbevafiTmWb5uU9aPHuHC894XSSo9ibL9hnsUiGUJRpDGQ?=
 =?us-ascii?Q?dkl3UjLsnJPkoTRAEcJkUhiotoJxm63qlImFhmOpWh6037ePE2JCE2YMkiDC?=
 =?us-ascii?Q?PlvN2TTR0VTVbAMHf+hvoMiiro7QEOOsWXP8I1cE7jx9yKPOhaY/KCgZW5qv?=
 =?us-ascii?Q?jtqRge91W9AlSuRnnCRcSfCMfTRZt5Wobogdzhyg3qDT7iOt6li1SMGJ1CTL?=
 =?us-ascii?Q?Jg9aTRxuhcdz1YGP1PnVW/aBkxSJwO8L6gXVUY//ZXP0G01JQCuiJmPKQO0O?=
 =?us-ascii?Q?+7xR6isBSQkwvS5FtajbUrmIulbfp7BtRkliX4EoRnA6qfpnR7AJQK+agLOx?=
 =?us-ascii?Q?guWB8LILDESUr/SpVCdYNOlQYmoUgu6JP8Ck+GKIlQ8VBUdF1SJZCoZSMU1q?=
 =?us-ascii?Q?2ETqh0T9ypS0RpReDIBHFiRehwhuaK6yS7OSPoGZqKXLwWnprtPQkb6xoGgZ?=
 =?us-ascii?Q?af+NfHdE47p7Ac+4zblTReoqtIa/28I++W5ZcP3EPvZHUqBlYSfmn29NXrbP?=
 =?us-ascii?Q?oDrL9eNtYfDzXmdLfw29ImX/uwTBrTwwmi7MLFVc+OR4GXoiePB18glvJyXw?=
 =?us-ascii?Q?buF5NYTmhku3vrUH8qfMoJVlyaiJ84xPUgH3o3gM4U2rQnbt0OncSNpL0ACt?=
 =?us-ascii?Q?IyLxneuHBli0rsMx7F19PAHXOBU3MSoEGvH1voc9zbceNWDBpZajy2aec4EQ?=
 =?us-ascii?Q?Cm1dEvp3E2TRquUHQhkWG5BzTV6p4RdGuSKBvmaPRnSNHvOocK/RxMSBcZS0?=
 =?us-ascii?Q?wT1cCeXS+wCCHmsFRQMotsY0GN8LrR/E6b2oDg8fauWKo6KEqxztqHRw6L5/?=
 =?us-ascii?Q?aKY50yIOEjF1lZ/BKXj/bQg4U9RQnuG8nfqytONVc57XF2+dsumQBti+GfVH?=
 =?us-ascii?Q?VOwYuQiGOHiIdqVbb13GJpg7sFveCL2GFJ1HbZF63Z178EXTnvlan4twG4EN?=
 =?us-ascii?Q?DaR5b9tf1EltEcIY3dfxISs05eQXZeFVS+AlpFfVwTEUoZmXp+oTiDTvzh+h?=
 =?us-ascii?Q?GzQw51ouC/v0OroeCLiJVJq6su5yuvasaG0Xj3HY2eMdxyiuxDGNU20IERDa?=
 =?us-ascii?Q?5U7g68/V4rS4QAv7DjGBRsEBs8iddXBMcOWkvYzCUk3Ok8dUQUBj924zvjK/?=
 =?us-ascii?Q?V1+X/NEDAXydsIAmStYe6LyMhGlTNzpuHhgPVwUz+4sh0ZEUtGagUdrjiAOj?=
 =?us-ascii?Q?zcQYMWFsLKv7s7APIFATZp0KTp5iJIC38Owm2/qmXbp9WhLP+qXIIvNL+UFi?=
 =?us-ascii?Q?ElAZadQ96uodA/bF8BxGX1A9lVIohsOxH0fNSiTd1uuJINZAIG9J58/jx5b8?=
 =?us-ascii?Q?JeK8WnKY1fBjcHNacQRU5lD9u4sDlRT7VMoQLpdPKNprPcLokXjiAuJyZTte?=
 =?us-ascii?Q?oeVNVdlY8FS9yDC6GdZgkmHG6wAimM/f7vVXjTY04ACVhs8fulA4KpTWcWxd?=
 =?us-ascii?Q?xy0njBwIbBvy8QNYxW7OkBSeNTQjDVFYg29tl2T/Uzg0GJV/SWcG5DdGz96l?=
 =?us-ascii?Q?BTdG0V4XWDCs2I7RyddufoAjScShZVWWpQ5XbpC+aYJS2GkjDTV4Rbo6C3xv?=
 =?us-ascii?Q?darsLCvNDwolBmECOF6pEviIXQjgp4gsZbeJwsD2cIYghcOdMhMyKVjGMevS?=
 =?us-ascii?Q?kk4Ac711mZvIREvoDmjP3rTfEA9dOorjBlFSCZ4Qym15OW9AxjLTrepatFh9?=
 =?us-ascii?Q?6W207bWPwX4J9OJN4JOkVBm6FLjNQAQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b58b9f4-e135-49d4-c4c6-08da2cfcc075
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:02:10.0389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmf+B7cKcnA8gyUqN5ijBaVkIe+myxxIhcpA+HgZMf1/ezh1va2uVqqOLxMyC6Nrg/Go4P0l6F5Nx5jbQuRT4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9480
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OCELOT_POLICER_DISCARD helps "kill dropped packets dead" since a
PERMIT/DENY mask mode with a port mask of 0 isn't enough to stop the CPU
port from receiving packets removed from the forwarding path.

The hardcoded initialization done for it in ocelot_vcap_init() is
confusing. All we need from it is to have a rate and a burst size of 0.

Reuse qos_policer_conf_set() for that purpose.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 30e25d45f08d..40afab2c076a 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1403,22 +1403,18 @@ static void ocelot_vcap_detect_constants(struct ocelot *ocelot,
 
 int ocelot_vcap_init(struct ocelot *ocelot)
 {
-	int i;
+	struct qos_policer_conf cpu_drop = {
+		.mode = MSCC_QOS_RATE_MODE_DATA,
+	};
+	int ret, i;
 
 	/* Create a policer that will drop the frames for the cpu.
 	 * This policer will be used as action in the acl rules to drop
 	 * frames.
 	 */
-	ocelot_write_gix(ocelot, 0x299, ANA_POL_MODE_CFG,
-			 OCELOT_POLICER_DISCARD);
-	ocelot_write_gix(ocelot, 0x1, ANA_POL_PIR_CFG,
-			 OCELOT_POLICER_DISCARD);
-	ocelot_write_gix(ocelot, 0x3fffff, ANA_POL_PIR_STATE,
-			 OCELOT_POLICER_DISCARD);
-	ocelot_write_gix(ocelot, 0x0, ANA_POL_CIR_CFG,
-			 OCELOT_POLICER_DISCARD);
-	ocelot_write_gix(ocelot, 0x3fffff, ANA_POL_CIR_STATE,
-			 OCELOT_POLICER_DISCARD);
+	ret = qos_policer_conf_set(ocelot, OCELOT_POLICER_DISCARD, &cpu_drop);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < OCELOT_NUM_VCAP_BLOCKS; i++) {
 		struct ocelot_vcap_block *block = &ocelot->block[i];
-- 
2.25.1


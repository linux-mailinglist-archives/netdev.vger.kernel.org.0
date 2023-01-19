Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12802673E2E
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjASQFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjASQEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:04:54 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2084.outbound.protection.outlook.com [40.107.20.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6AA6C556
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 08:04:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=at2tApEee1n0yQ07zrDQKbYu4xF+rd4Va45sNqrbAMYbiGzpWdwmOGDK7uF7idcdsdlWM1Svi/X1L9n+GZvJC+/j3/4trJUYSVFc/2EVNQax9Xkj1/NlLaMrwqYhA70Mui6FMjYbh1VQ6W9529OJ+0j7yQiMn4xwadQxyZ94E9p7BRhFTokUSocmgUFF3G1iXdCM3VtnxPYVKpCEnUj7W9meGMfByzsCgoD6+fP6u4UjbTwF7xOSBhGoRLJcd9vHvnO/wxW9X4qKz++71pE8t3rri1LyNIou8DZZckPwvbEZIESB3HR8hQ6wns675wMleeKWcG3Q2zJ5LS1tysXeXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JV8KuectmPgsr0sqqNTHniqOQljFZswnz3U9CD1OGbQ=;
 b=RbehPmJSOhsHQm7TaouGD4yvbA1LUZg/hdm1PCOee10+l6wRwJRiDU8EZSBKMQr5qUVobXrCa8GVvFy0vRC8kjkFLezydoN0JSIocARH4GEOqrL3M4JktOjlZr5NT5YzjS+D9knNdA+xFDF/mMB0dnWrm20fR2bwDcedcVYe/we9Zha1si8v+0ShLXD441F2FDEEqkivb+aXWLF+tHSbIhOAWUoFio387PcpdRJePcGa7YArXis9agWlG97L4fAnOwiQQdW/HLcwVg80MNO0B25GmJlqcJhfZZ+Z94lphk7rSoWK5hV6b3+0i+GXzb+5UmIEQ93qJ2XySW6cLa7dhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JV8KuectmPgsr0sqqNTHniqOQljFZswnz3U9CD1OGbQ=;
 b=bKwSwDNuZLkIUz36htMc801ycVvhIgpbE7dsyGA2b38NXdg9fXNaKIB5IgCFPxWDmiJ1H37HbbS4D2IQ6nB9hMNDfoVXQ7feFf6X2KGZU0ZiGcMW06PgnkNkyj2cKXqxz0fiKdhaEX/mH5oqx2TaPIJRAoATrRluTj8A1DXF+ZY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 16:04:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 16:04:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net-next 3/6] net: enetc: add definition for offset between eMAC and pMAC regs
Date:   Thu, 19 Jan 2023 18:04:28 +0200
Message-Id: <20230119160431.295833-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119160431.295833-1-vladimir.oltean@nxp.com>
References: <20230119160431.295833-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0130.eurprd04.prod.outlook.com
 (2603:10a6:208:55::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: 14deb01c-5392-47e2-f08d-08dafa36e1a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tk+YjUcvqXT0h+5GJKIzRBRXTIOMpl7fyy/DEyyTY6boEBXnUdImIPQYO+Mjm83Gfky/WHzWwRuXmNeHn4y2KRXFSdD9gFjqpJwNTlLzwfrzNfIGXxbgQEr9VhPoISP8HS7gdPVTx5P8J6U8Li4qIhP5F0Xf7bsLp9T7zap91u0+D51q9adsZS9uq8/BD8CC7GRdNR6klJdKOfZiSj5Xa3yvisfqvPXNgozkwMlPkhFGbKYW7tm1261Gu6tgV5JtY1A4qY9hLZfpkY7Pu7qB9oN1Dur2vL4NPC7vOuDWV1sXXAYS6Vbq3e5D4xI9aZaUSHW7kR0xZgcqUlCb9auVZ2Vszr3hA09mgWflVTX7GZM37UkfjS7hAgrb7okCqO/tSUKZbeu+APXRVN+DeEn3fQIXGuI4eA4VsWDec2fG3GXCf2AFwi1In8uLgAHfI5dQn+X3A6Znq/iXqc19DxlWctHFkVxuHdFnXQ+Y4OqyLIwk+6c+JGQHwyXCjfDvi1WtDTs91YWYXIzWrOQTCNq/KfNiTiLxP0Zr1QvPQxF1mxuNargZH1g8oHD9u2qZpEHH3CkBSDtQKeUqyBC5yOzhNMFxX6F1FQqJPZG8wJIscmRevN/pw1xHjFnk9DWelZe5NoaQXLrwl4FTI/1ByU08n0/lnz3qJuZxK3F+Hm+Z1sGgOLLrZE2mxnhuJlelhtKWCjmgRBpZgYlDNzAul/7oXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199015)(2906002)(41300700001)(83380400001)(6916009)(8676002)(66946007)(66476007)(66556008)(4326008)(36756003)(44832011)(2616005)(8936002)(316002)(5660300002)(54906003)(1076003)(6666004)(38100700002)(186003)(26005)(38350700002)(6506007)(52116002)(86362001)(478600001)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IcTOKgKLwqiI8rE2ew5wf55vkNanXe2EmKRO0h+knisBhzFD8+AMN2xr6bPp?=
 =?us-ascii?Q?Lu+DWbQlELSih+hy0zCHxstC6NPI++Ce7jh35QSX+qsthUTs34kVRwKPW4cG?=
 =?us-ascii?Q?chE6/iTQ9ST+tCvXjIRlmm0DnL1n+XTCM5DCooVX3oX8virtYyhQPf/CbqJB?=
 =?us-ascii?Q?4ZEFJ3LE+qmioyVMrRC2XK0leywtlpE5G4NUPHRAXo4q9E0MSVo4D2dSWN15?=
 =?us-ascii?Q?EljN4AbFA8tsDf4zOLUZewp+9xnCLjFoyaZdIbc0wEoecYyPAbYEiWtphNb/?=
 =?us-ascii?Q?09vIMb7CneiXT9WYMUFK4BhRQRuSpEuXKYCcHeFd0vEi5dHLize7j+I7O6zl?=
 =?us-ascii?Q?owH1uXdyAEO0EE+E/r59MAUiOSRtU6Xq+GfMCkM0l7JkOqt/Ctv4ezGIZWgs?=
 =?us-ascii?Q?kIu9lhyhbYAxF9SuFWMpMkHgSnCIa4EXcOic5MJ84Q9x+NGIJ3Kt70vPMeWT?=
 =?us-ascii?Q?FtIs0mjLNHS47cKvCJpdy8WohPmBiZ9guWWAE8yz8476TPBAEW/IyGiGpg6X?=
 =?us-ascii?Q?WahbUKCcji4KAoW7dRx7pm2+aahzlFx04hvsAuLyR0aJ7dHuzC7KpmOiuNsO?=
 =?us-ascii?Q?FakpR8WZU+JwvuOha1bZ3tgVyS95Omn7vUA2OYxTT+Tf/28t2j8YHTIpYGwm?=
 =?us-ascii?Q?+z99eTmZrRhisCxwo2oIkKrWJ4PJk9aYUaQdpmltJbuRV3FrfPdHe29Is2o4?=
 =?us-ascii?Q?5jj8kLSu7AnnrhnhvaQdH2QgW60EM1v9GwL+HFCx39XtVt2JUBjY5rZZfvyt?=
 =?us-ascii?Q?xDmM15+UvKzChWL6JKPPLwP3PwYcHNbq1sfZta39JT2cDpV6xqIr/WdXnv2R?=
 =?us-ascii?Q?WYMSzSG1Hhq8SpxSFPMcl3uO/7F1fDc6bCjkh4Dz2cygLyCsPfSsk4jBg9jM?=
 =?us-ascii?Q?YhX4LoB85Tq6lsJYTg1ctv212YrqmS78amTMk+KV5QyWlv78HmvHE1VG6laa?=
 =?us-ascii?Q?ASQJrSCkhbcZwBVWWN/jdqL/LKY1i9P/9iYJUq5gLtog4mIISSwT7jTSqP4Y?=
 =?us-ascii?Q?q2ToQabHZjWenYKedqnSUrreRx815RRKSMa+H6ZTs5Bg61Gg7jHDA317nVKF?=
 =?us-ascii?Q?5AMKhK01enzkVU+K1JHWJdMGQiKgqanBRc8FCm1hwFyXqt3nj2hBvC9Z/A9V?=
 =?us-ascii?Q?7cAWnzqlLvO1fleH9ERFaREkeH2PBhGdGUP9ozReuwdIvLBpGkiYpMNPk3bV?=
 =?us-ascii?Q?yGxsqvEQh6aWeEkcuqPtMRVKVLpiKH0YCpsUq33e1eT+2RLdM4XTSncATjm5?=
 =?us-ascii?Q?vNgsffHX2PZqvu71xr2rGz4JezLhlj8JtyqcJQqGfmV/esLOgS4c3mrH2Vis?=
 =?us-ascii?Q?y/8Y7qsTweAmOzzpjsN6ZkSH7Cll4aB0JPz7D+pgHIDnLHbHfkBfqtEVMfpC?=
 =?us-ascii?Q?5b9pcv7AeOtPA+jleYSDPVVTWcO496ULpPTUHVojk4wGFf5FebRHENRJgfu2?=
 =?us-ascii?Q?ofYgdWngIueBOG7ZNO7xPmMQY/WjGPWNInDpE0eqU5xQQI84lCRoLo3bb0NM?=
 =?us-ascii?Q?0sK/CCFKAvqoAxrTs9SA3aeD75Rhx/CM7wIro0Pjv5HALs6wV5dxGedjWWNW?=
 =?us-ascii?Q?owBHyg3j2q6EsJ8RF2MIh3UH3r512yuzPnfeBv5cNc7DmTmorXoDDJQKaPmM?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14deb01c-5392-47e2-f08d-08dafa36e1a8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 16:04:44.9188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Z8t0EXH6i70z67fKeBFx/dHBurlQiED+MRaYJFKcK1ZU3pos8J2EZpOA8Z+duneKjAfzHtepaPUUd3FvmyeMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8036
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary patch which replaces the hardcoded 0x1000 present
in other PM1 (port MAC 1, aka pMAC) register definitions, which is an
offset to the PM0 (port MAC 0, aka eMAC) equivalent register.
This definition will be used in more places by future code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 104 +++++++++---------
 1 file changed, 53 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index cc8f1afdc3bc..5c88b3f2a095 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -226,6 +226,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_MMCSR_ME		BIT(16)
 #define ENETC_PTCMSDUR(n)	(0x2020 + (n) * 4) /* n = TC index [0..7] */
 
+#define ENETC_PMAC_OFFSET	0x1000
+
 #define ENETC_PM0_CMD_CFG	0x8008
 #define ENETC_PM1_CMD_CFG	0x9008
 #define ENETC_PM0_TX_EN		BIT(0)
@@ -280,57 +282,57 @@ enum enetc_bdr_type {TX, RX};
 /* Port MAC counters: Port MAC 0 corresponds to the eMAC and
  * Port MAC 1 to the pMAC.
  */
-#define ENETC_PM_REOCT(mac)	(0x8100 + 0x1000 * (mac))
-#define ENETC_PM_RALN(mac)	(0x8110 + 0x1000 * (mac))
-#define ENETC_PM_RXPF(mac)	(0x8118 + 0x1000 * (mac))
-#define ENETC_PM_RFRM(mac)	(0x8120 + 0x1000 * (mac))
-#define ENETC_PM_RFCS(mac)	(0x8128 + 0x1000 * (mac))
-#define ENETC_PM_RVLAN(mac)	(0x8130 + 0x1000 * (mac))
-#define ENETC_PM_RERR(mac)	(0x8138 + 0x1000 * (mac))
-#define ENETC_PM_RUCA(mac)	(0x8140 + 0x1000 * (mac))
-#define ENETC_PM_RMCA(mac)	(0x8148 + 0x1000 * (mac))
-#define ENETC_PM_RBCA(mac)	(0x8150 + 0x1000 * (mac))
-#define ENETC_PM_RDRP(mac)	(0x8158 + 0x1000 * (mac))
-#define ENETC_PM_RPKT(mac)	(0x8160 + 0x1000 * (mac))
-#define ENETC_PM_RUND(mac)	(0x8168 + 0x1000 * (mac))
-#define ENETC_PM_R64(mac)	(0x8170 + 0x1000 * (mac))
-#define ENETC_PM_R127(mac)	(0x8178 + 0x1000 * (mac))
-#define ENETC_PM_R255(mac)	(0x8180 + 0x1000 * (mac))
-#define ENETC_PM_R511(mac)	(0x8188 + 0x1000 * (mac))
-#define ENETC_PM_R1023(mac)	(0x8190 + 0x1000 * (mac))
-#define ENETC_PM_R1522(mac)	(0x8198 + 0x1000 * (mac))
-#define ENETC_PM_R1523X(mac)	(0x81A0 + 0x1000 * (mac))
-#define ENETC_PM_ROVR(mac)	(0x81A8 + 0x1000 * (mac))
-#define ENETC_PM_RJBR(mac)	(0x81B0 + 0x1000 * (mac))
-#define ENETC_PM_RFRG(mac)	(0x81B8 + 0x1000 * (mac))
-#define ENETC_PM_RCNP(mac)	(0x81C0 + 0x1000 * (mac))
-#define ENETC_PM_RDRNTP(mac)	(0x81C8 + 0x1000 * (mac))
-#define ENETC_PM_TEOCT(mac)	(0x8200 + 0x1000 * (mac))
-#define ENETC_PM_TOCT(mac)	(0x8208 + 0x1000 * (mac))
-#define ENETC_PM_TCRSE(mac)	(0x8210 + 0x1000 * (mac))
-#define ENETC_PM_TXPF(mac)	(0x8218 + 0x1000 * (mac))
-#define ENETC_PM_TFRM(mac)	(0x8220 + 0x1000 * (mac))
-#define ENETC_PM_TFCS(mac)	(0x8228 + 0x1000 * (mac))
-#define ENETC_PM_TVLAN(mac)	(0x8230 + 0x1000 * (mac))
-#define ENETC_PM_TERR(mac)	(0x8238 + 0x1000 * (mac))
-#define ENETC_PM_TUCA(mac)	(0x8240 + 0x1000 * (mac))
-#define ENETC_PM_TMCA(mac)	(0x8248 + 0x1000 * (mac))
-#define ENETC_PM_TBCA(mac)	(0x8250 + 0x1000 * (mac))
-#define ENETC_PM_TPKT(mac)	(0x8260 + 0x1000 * (mac))
-#define ENETC_PM_TUND(mac)	(0x8268 + 0x1000 * (mac))
-#define ENETC_PM_T64(mac)	(0x8270 + 0x1000 * (mac))
-#define ENETC_PM_T127(mac)	(0x8278 + 0x1000 * (mac))
-#define ENETC_PM_T255(mac)	(0x8280 + 0x1000 * (mac))
-#define ENETC_PM_T511(mac)	(0x8288 + 0x1000 * (mac))
-#define ENETC_PM_T1023(mac)	(0x8290 + 0x1000 * (mac))
-#define ENETC_PM_T1522(mac)	(0x8298 + 0x1000 * (mac))
-#define ENETC_PM_T1523X(mac)	(0x82A0 + 0x1000 * (mac))
-#define ENETC_PM_TCNP(mac)	(0x82C0 + 0x1000 * (mac))
-#define ENETC_PM_TDFR(mac)	(0x82D0 + 0x1000 * (mac))
-#define ENETC_PM_TMCOL(mac)	(0x82D8 + 0x1000 * (mac))
-#define ENETC_PM_TSCOL(mac)	(0x82E0 + 0x1000 * (mac))
-#define ENETC_PM_TLCOL(mac)	(0x82E8 + 0x1000 * (mac))
-#define ENETC_PM_TECOL(mac)	(0x82F0 + 0x1000 * (mac))
+#define ENETC_PM_REOCT(mac)	(0x8100 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RALN(mac)	(0x8110 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RXPF(mac)	(0x8118 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RFRM(mac)	(0x8120 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RFCS(mac)	(0x8128 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RVLAN(mac)	(0x8130 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RERR(mac)	(0x8138 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RUCA(mac)	(0x8140 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RMCA(mac)	(0x8148 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RBCA(mac)	(0x8150 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RDRP(mac)	(0x8158 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RPKT(mac)	(0x8160 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RUND(mac)	(0x8168 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_R64(mac)	(0x8170 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_R127(mac)	(0x8178 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_R255(mac)	(0x8180 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_R511(mac)	(0x8188 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_R1023(mac)	(0x8190 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_R1522(mac)	(0x8198 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_R1523X(mac)	(0x81A0 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_ROVR(mac)	(0x81A8 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RJBR(mac)	(0x81B0 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RFRG(mac)	(0x81B8 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RCNP(mac)	(0x81C0 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_RDRNTP(mac)	(0x81C8 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TEOCT(mac)	(0x8200 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TOCT(mac)	(0x8208 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TCRSE(mac)	(0x8210 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TXPF(mac)	(0x8218 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TFRM(mac)	(0x8220 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TFCS(mac)	(0x8228 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TVLAN(mac)	(0x8230 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TERR(mac)	(0x8238 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TUCA(mac)	(0x8240 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TMCA(mac)	(0x8248 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TBCA(mac)	(0x8250 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TPKT(mac)	(0x8260 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TUND(mac)	(0x8268 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_T64(mac)	(0x8270 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_T127(mac)	(0x8278 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_T255(mac)	(0x8280 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_T511(mac)	(0x8288 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_T1023(mac)	(0x8290 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_T1522(mac)	(0x8298 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_T1523X(mac)	(0x82A0 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TCNP(mac)	(0x82C0 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TDFR(mac)	(0x82D0 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TMCOL(mac)	(0x82D8 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TSCOL(mac)	(0x82E0 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TLCOL(mac)	(0x82E8 + ENETC_PMAC_OFFSET * (mac))
+#define ENETC_PM_TECOL(mac)	(0x82F0 + ENETC_PMAC_OFFSET * (mac))
 
 /* Port counters */
 #define ENETC_PICDR(n)		(0x0700 + (n) * 8) /* n = [0..3] */
-- 
2.34.1


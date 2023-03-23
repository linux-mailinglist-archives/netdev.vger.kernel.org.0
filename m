Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AC56C6506
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbjCWKaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjCWK3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:29:23 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2070.outbound.protection.outlook.com [40.107.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9CB1CAE7
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 03:27:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DE+ssfOtEuOOXF0HWwUG9EIhe2YIrzZqwX4438MoxapmhA8BlNn+HqbgUl0/zZ+JnB32MMwY3lsOdWZ3DzdziRpYv8CjRxBb3OTvr/sAWPabKTzOF8cInWM1FDwkijglhjqBCSLL3YNPgaBnIiYDS3qjUHonbExK39kycUoQuZior6zBXz8xrfJShYoDF/GVtQnvwPGt5WvsPabgdEGf3B54YA+v+ARpbGUb7kADvfbb2JWNzOD2zezeihXJPJVi78Ub7CrCeCBlQJXEf2v0JH5cDpvVXDwHEtC61ezCeI4F85ybI8ivseDdcf9V8EZWp2tzkv2XALNJvP4hCazcEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M3M6Wqi9l5yJ9ghNwy/2Q6oLEvTs3croxYbxl7hQHOY=;
 b=DoIU6Kz0d/hURz1rwphCTwch0qLE/guU/XCto0L//WRaw8CG9E+s3GJkVvayxxIKh3DT342J12Ppsjt1dacJCxl3T5u0qmJzW5hJMP8FMuScdJGuJK2oVwYYcGZVZVw1ArdcI4SsCEDLBCWOkdtHH2B2SiVJEvqoPn2py6iRjr/xuMm4fIPuxuV4biilT2Up7zWQMw6PjZqYMqT6q6yJZlulhJ//n10Q5JG2iS0SMfy3/hkdn8jrqJfESfyohcymA0Snu52ZmWWlu5DwfV0DNBc4dZLSchWhpmPMLh4PRVlTP9wVPDfnK2bIOYcdxkBWdPvavpxOzKxZz4PDCAZqrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3M6Wqi9l5yJ9ghNwy/2Q6oLEvTs3croxYbxl7hQHOY=;
 b=FLXjcCEkLjN3eRIBI0PPVTHlXf1JvNV7VmIhwn2gytkfMnrjR/RPAnVUjAApvzS0fVT5N47QKqPArd92s+cKS1mMPSanSNm+aEN+OB93mtY7zeYPWeL+ByZbs+45Vm62mxjah5RWbqkheruhEugl5c6MzyRiY5KXuw5vsEpfR/Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
Received: from AS5PR04MB9797.eurprd04.prod.outlook.com (2603:10a6:20b:679::10)
 by DBBPR04MB7580.eurprd04.prod.outlook.com (2603:10a6:10:1f7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 10:26:51 +0000
Received: from AS5PR04MB9797.eurprd04.prod.outlook.com
 ([fe80::df65:64bc:2219:8ad9]) by AS5PR04MB9797.eurprd04.prod.outlook.com
 ([fe80::df65:64bc:2219:8ad9%6]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 10:26:51 +0000
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     Josua Mayer <josua@solid-run.com>,
        Yazan Shhady <yazan.shhady@solid-run.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] net: phy: dp83869: fix default value for tx-/rx-internal-delay
Date:   Thu, 23 Mar 2023 12:25:36 +0200
Message-Id: <20230323102536.31988-1-josua@solid-run.com>
X-Mailer: git-send-email 2.35.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR2P278CA0047.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:53::12) To AS5PR04MB9797.eurprd04.prod.outlook.com
 (2603:10a6:20b:679::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS5PR04MB9797:EE_|DBBPR04MB7580:EE_
X-MS-Office365-Filtering-Correlation-Id: daf693e5-1574-4e0f-9da1-08db2b891dcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jgzigf8CRdD9KtHsTCPCvPS+jddKo8CC5LN5sMqvcOnwkWBS9cvOdEoMBejebswTBZHUnGWIsaadaTmn2SaP5YYYjRrOeaqwFcsj61j0gkGOfFbeq/FoikpPu+JZvEfGb37xhKeqXBOxQW6NMH7AAmGsO6ZO4Suezan07FLkE/ET8xVFVVXf/UAooVAoBNBCouFeTtGpUkOF1SzulWsL2WPCaxLw46afsTdofmmIH52JA+Y3rVoJRLO3uuvvLPKaM+tTxB3HsbnXnL12TUmaw4KstUgCADgQnGRyI+M3D3qrBzwVtExOAq0OWebWE2LnCjOKuy/Wt+Ci/K1qisPYNcZfmPy2ZdmTDI8jkrA4vTRCaIuMZ9FeSAt86XcUc+reX4q69nn3enSy5nPegYQqED+Ay87dmOPGtwW/+youHuWCM5mhOfFsndngHUA7g/x83UKo8Fq4xvyTgJf/5buuEgzRMHTN8TtfQDZ8Lipytq88pQ9XxxYQjDBwO3rXx6bBGCGr7c7WNglWKmHmqr+8uff9v8QFX+gSCJ3s5GFDmXarjwwzAl5AlWjAvNI6HyFiCFj1M0Hx8pivhpEk/8A973nA+b/FRck4rRdbP6AWXK4b9vWPbkn0PDmrmpterSlE78VczLisrBlkJ9F1fsV5UD/3AGPkzITu9vXaih0N/yrGbA5yZdFA4OeE7JDmxnxkWV1PFF0FNlYu1qAu7g6B4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS5PR04MB9797.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39840400004)(366004)(376002)(136003)(346002)(396003)(451199018)(4326008)(6916009)(66556008)(66476007)(8676002)(66946007)(316002)(54906003)(5660300002)(41300700001)(8936002)(1076003)(26005)(6512007)(6506007)(6666004)(2616005)(186003)(83380400001)(478600001)(6486002)(52116002)(86362001)(36756003)(38100700002)(2906002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BIFPi5xbPE2o+/QH0QLoUPeGROKS/NPObb2dwxsfPU1SLOogf/YSSs4BlncN?=
 =?us-ascii?Q?kFXVNtHKqwdnbeMjhobHDEIAwRKAchfXQ5qqPbxGGj74Xagkcfq+ZojJuEux?=
 =?us-ascii?Q?1I6yG/ouddg6AJz/geqk5SeWolCiWoovxLW5JIZ9jM/AJSTgNRyBHoRbN92W?=
 =?us-ascii?Q?KDXUtTwONJJXxEVm6eap3fzXoXoQQ9UH6ypDYKh2Rtw7SXjjtnSv8d7LVGAP?=
 =?us-ascii?Q?2C/J4gQod5xeWVCD92UJdgwTUhRWkPmKI/IhRf30FN0QrwLPlTpxWkpbndJf?=
 =?us-ascii?Q?qHYm/0MzcLD8S5H4AoS7jo2JU65s07n0YNQ9Lb8RY6sZHHadf/3B+NP4kv87?=
 =?us-ascii?Q?nG/41SgX28bAV/uUSbezk1GtJzKqkj856b/UIUw27ArLA/nTF504BXsCu6yf?=
 =?us-ascii?Q?0rXEDGrllpPWniL43CMSk4VBMu2dWGZnNF7ljy71t+fCYPBaQ8XW9Vvd/VKd?=
 =?us-ascii?Q?RccxMdJazT8WksHNyP0rQXAdu6tZ2eA7NOCsqa+rcFMUG1lT0GXBFfxJx4EQ?=
 =?us-ascii?Q?4mtYiOrp+hZJEq5KggmHOasRdtfQqj5rhDsIQ6vEMrHT/Pc42bjrpA8TI3KQ?=
 =?us-ascii?Q?poh0qb+mTXNTGWxDPkXtA5wYMRNE3rBVxPNsb68KdeQETg1K5zVzWm8pUbIe?=
 =?us-ascii?Q?U+yUEqx9gdFi4S1KSZVAqiehSMiqa1NA+jms0v9uYS3NRWS5kK/z3HVT1l49?=
 =?us-ascii?Q?+R/VQP3ecKAiBZk6HB+mXtSMK6BvAyxLVM/oBJX0so6seIGmPpmtDbKgVK3A?=
 =?us-ascii?Q?0f4zUn5TYXoP3hog9YmaP19afzS+eAlH+0+Lb+ieuCZ8l6wpNHGFs2Uo04Pl?=
 =?us-ascii?Q?iNnRrJ94XGHofR2aoq3kDz4XmJzgau58TNtXyazRaLtKAtBtcLEH2vNy8r7f?=
 =?us-ascii?Q?CriekQE/v22m1UGV0uKsfwFkEP0tYcYXQ14kIyi8TA8JGVoicRJeaByEE+x8?=
 =?us-ascii?Q?JxAPIvCOgBxHA3OJ53iqnLpZog5XoUNFv2IM/byJZ3imYrw+LBb2j+MmDINJ?=
 =?us-ascii?Q?LixpRacK0c9oZQiCHZ23FQzUSKPssQBntID1TjexrA1XY9t5zCHGimaB8I+h?=
 =?us-ascii?Q?sp6pluUBYr+Qsmr/FzhxpzNRbgsZcf5bFCCZDm1SNNTYV8V06wh/bb0T212E?=
 =?us-ascii?Q?vyIIPb96ZuAqS4uaAw/Va8SoLb9WS5Jq71tL5VNaiKal/3JTIRqBaSzLhQg+?=
 =?us-ascii?Q?h6MDFNVQ0DYU8AelPWI2KucmoIp6/w1ZqIUqMxJ1Fzj8l2Pwbd18/6ilHV7y?=
 =?us-ascii?Q?Iq3kCpQMQeOVPSmu2nGviD+StVGGOHvXWFWKuV0RwxQKbUixZg9OYjialn7x?=
 =?us-ascii?Q?/+TEYlbbhrwij4UXpWwZepNGRMc8cJYW5ZYtmLmLI8qB9qXTbDd7lV6ts3rj?=
 =?us-ascii?Q?GUaf3aSZE1c/kaQNb2O/LK90Rx+mFHDM2+oMiNRby96lGnXYfoDF64q37vzW?=
 =?us-ascii?Q?JkciIBy0FUcKaccbGvzUOlYaFnoqj6xpQO5iFx8sMNKI/UyP48wPpVdjMvIu?=
 =?us-ascii?Q?IZtpg/8mtgWHHDjUgubpP0alXu5ks/dnbjmWf6Het3FQsxPxxa9mxpD7y/aH?=
 =?us-ascii?Q?I24oNOV4LHwl6Wq7Sp0s4WXP1ODSDnrNKX0AtxZB?=
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daf693e5-1574-4e0f-9da1-08db2b891dcb
X-MS-Exchange-CrossTenant-AuthSource: AS5PR04MB9797.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 10:26:51.5620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1F6m9bhgEkEkwRObRH2zIpinr3GhDBa2tZzCLbXPbEUh4M2ifPdf3SYe3dGj/tK1Wb1N1m6gqjg2zcjU7drlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7580
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dp83869 internally uses a look-up table for mapping supported delays in
nanoseconds to register values.
When specific delays are defined in device-tree, phy_get_internal_delay
does the lookup automatically returning an index.

The default case wrongly assigns the nanoseconds value from the lookup
table, resulting in numeric value 2000 applied to delay configuration
register, rather than the expected index values 0-7 (7 for 2000).
Ultimately this issue broke RX for 1Gbps links.

Fix default delay configuration by assigning the intended index value
directly.

Co-developed-by: Yazan Shhady <yazan.shhady@solid-run.com>
Signed-off-by: Yazan Shhady <yazan.shhady@solid-run.com>
Signed-off-by: Josua Mayer <josua@solid-run.com>
---
 drivers/net/phy/dp83869.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index b4ff9c5073a3c..9ab5eff502b71 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -588,15 +588,13 @@ static int dp83869_of_init(struct phy_device *phydev)
 						       &dp83869_internal_delay[0],
 						       delay_size, true);
 	if (dp83869->rx_int_delay < 0)
-		dp83869->rx_int_delay =
-				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+		dp83869->rx_int_delay = DP83869_CLK_DELAY_DEF;
 
 	dp83869->tx_int_delay = phy_get_internal_delay(phydev, dev,
 						       &dp83869_internal_delay[0],
 						       delay_size, false);
 	if (dp83869->tx_int_delay < 0)
-		dp83869->tx_int_delay =
-				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+		dp83869->tx_int_delay = DP83869_CLK_DELAY_DEF;
 
 	return ret;
 }
-- 
2.35.3


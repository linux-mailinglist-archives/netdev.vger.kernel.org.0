Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774E64C9DE7
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 07:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbiCBGmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 01:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiCBGmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 01:42:16 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2133.outbound.protection.outlook.com [40.107.255.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C57813E80;
        Tue,  1 Mar 2022 22:41:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tz9xe8Bz/hJgsTHuVJvzCOHVCbxn9MAy4E4deFCMhUOpzBCPbR4dFQ9uO4mA3f9mJnDF6F0UbUm9UJDrKpDEsmOweDZ2DYTP/xSyPi+2EtsI8v+NbbCV0wvZQPLUzOGjcFttTMftFTEvFZVs1xja+GJ8XY9IDAKcgadqXkfTw48f5WUfOGkPXYBJOVA+ERzutyQxM/Nk45gpZ15tpbHJiSlv5SZTMLKauS8RAq1Olh/wodeJL/iK23a5qZZ2zFToLpHlKSDQBooe14RxOqb4L5/VSRnwTQGOGbnZ0DaFW9/ITElt2G2sjYH8n3x8gBt1/jygTS8jZVHR9fqq/apU0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=732Y1mduzolRxlHj8FbTSTY/tzXpomQ4qHm6ZX1gfpI=;
 b=EOKEZwHG9zq08/r0Bl9nsIGQwjqAm1KM6orETClaBi8I/X2su5xx3LhWtIGQJ5r9IIQt7PoOkfi7wRY0NCcCugqtOPA1wWzFYQLALwUtSafB2c9o3nPfD0YUMwD56bB7ZnCvsUTS8apB5g6phkqygJAo2REnOMup+pT3aXFaB0KcXz/DQQGvlcfj5xxhPaowwqVt06CtIWiazbcLSJpYQDyMaHT26dmRRRyKkhag7nU3OUHppC44SfPOno2yg4Sm+mFJ+vjhGUp1uyxa+B93q9E3EDePJlBL3aRNEmkDRTir0W29uA2Z1FezX6pMvECS07DgymMzcxFfrCVA5jrAhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=732Y1mduzolRxlHj8FbTSTY/tzXpomQ4qHm6ZX1gfpI=;
 b=d+vNt7p8TPQxpkxTyjlt3kRbRTR8o316W4w7DQCVLfvpjcOkkwYIF3hNcUreODrNd7j5PYWUk1XQwqk1OaHLcbYEK1D4oGn/Xc6jpqkY81pNu5IEEBx6ZOObYfBAVdvpovLpsXlgMGWL68WntXMTqiTSO9BeZa9CjNRuB+9JSIU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by HK0PR06MB2579.apcprd06.prod.outlook.com (2603:1096:203:6f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Wed, 2 Mar
 2022 06:41:29 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d%5]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 06:41:29 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Joerg Reuter <jreuter@yaina.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: hamradio: fix compliation error
Date:   Tue,  1 Mar 2022 22:41:14 -0800
Message-Id: <1646203277-83159-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0039.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::8)
 To SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7942767-03a2-4390-df80-08d9fc17ae5e
X-MS-TrafficTypeDiagnostic: HK0PR06MB2579:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB2579E67F10ABDA374834FF3DBD039@HK0PR06MB2579.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3I2uy4k5D53Sd8wOXYHq5ycnwNtSkNfgMK+W8E4H/po1YkHFdhr4noLZAK4WK6i2vubbngJqGmOkWlOnxkYmbhb3h2nf6ByKry84UxSs+wsS2QVvFQCXOdIeRHM9SWcijDzT7sA9aBbmysScT90p/EDiVtzwXunBwJmvSqA5A3+EQv3OnnasOpBsd/m379obBouEHIj5qVhDSByRjGbV+7QeH/31bNqEkgcRI3hLuwnJ6MF3PBgPbjaVHrXpMnuLsnz9nIq4FA2Mhwgyq9cP3tFeFy+SQOco8L4OgQ9tK100GKkPTASFeFM/rEYkVCy2T0TPoen+70agr9gVjUEeAwLMqSiz29D31FfqYfVHN0fh9hlsJt5jVX2GAeUfJPxNZ4C9SKRhHDpfOw8LBRZgJQW4iIQ+OHRn1M82PtVgkSl1TQI9WqK2wEiMgtpS3cmdm5Sg157nnMhbkt4L3MXBQSNwd/nIzVFMLhqlxG/0yRDjHcG+oqKst1Qh7yExs9Tj+jsSeW/zDU3QUEeSLxfSWbYlm2ghjkGSmZPgSwrGF+T/K25AHaSlkSL32r6Gg0ZBTcO36VqMBbeWSO/k8/BvaVPkxxFAjR6JvY3ILbpTn2T7Z8rEdx46XXvgnaM7zDqU8KSIt4CsXC10q5zuHYdRX30gwkiENR8sf52n8Xbaxeg/8NFLpJr/kOmN5Q3YJZA2jvFaeLgt4jB43iYG/uXJXM9dUWEHv9OXT7jco0nKjr6+n06x4UHSXazR3zwl4ZxJNnDe5oqTrcGMeTKnGF+NheT+zZRE/yrDG3y0Hp5xbS4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4744005)(2616005)(508600001)(8936002)(26005)(107886003)(186003)(5660300002)(83380400001)(966005)(6486002)(110136005)(86362001)(52116002)(38350700002)(6666004)(6512007)(6506007)(66476007)(38100700002)(66556008)(8676002)(4326008)(36756003)(316002)(2906002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2s9VTs7SshnmkWnh03c2C4jqEKtInid5aGl6KU8dpI2d2HQk2rk57K+Kdjr5?=
 =?us-ascii?Q?VK+IgjMt56JY5boPAbxOLFU43sO2t4+6ORWfOZIRLAcb2YU0DVo9xeaQ3Lxq?=
 =?us-ascii?Q?qyLGmxuAMLe6M2LLolxgmvTqNqwXIdYwpJ9qA5WpBhRodAMCAEXyTMEuvW1n?=
 =?us-ascii?Q?yz2VOzzoisKaLvdkmONy2/jNnraMUVL9w1+8wnQayPDwmxFjMXQt9ALPKdho?=
 =?us-ascii?Q?7Lb94TMDq3cIzdZXYK0cFNfvfC2bXOeu/er6L1kkKBh3qwgGn7XiSwvXt9G5?=
 =?us-ascii?Q?HFB3GXqjF3W/eITfIONY4aW8tYa0jarfCwU6Xe93KhyUCHySI1xSezFDQWMh?=
 =?us-ascii?Q?NYocK6XYsb7BhjLSanTzVc4Dguj4ZSHczWmOy5f+NOqPx75ZMGp+egQq6Ywg?=
 =?us-ascii?Q?DmAnjNtsIkc+TeLSMFuAsFtn2dMvBRYPTezuuYZnFTObM25UckgR9UeRc8jv?=
 =?us-ascii?Q?pIEdnS8KpthxS+dRz+XFkElcAWdLuSSueUHmhxcmURL4xgpaniXlhq9eN1BT?=
 =?us-ascii?Q?2bxRSkkgjEMShYVX2Qamih8c+7S9cHKrlVyo0rk4+6FsuV2S84kHjqabedr/?=
 =?us-ascii?Q?JjgvJ6o8jfyheJvJIS1ebAzlZ9CuaaAGHIrr3kWpIPjC/jLTlPZQONZUEClK?=
 =?us-ascii?Q?BjCknsHXrSq3aFi73fM/rQwFlHgraj+63R1XxZgyzi+ujysbBC0jhODLXplw?=
 =?us-ascii?Q?bf/qGHEUJuFxwnVanrvkO92QEkbaOdAqCUoREDXr1nxsfETr/0jtAX1JZ+GH?=
 =?us-ascii?Q?MCb3szhbssDC1D2HyzK3/UGNv1gTWdlWa08R2Bsw/h7dP6hzLGbKAF+FCZZ0?=
 =?us-ascii?Q?PMDXBXmmrCpQLE9/f8Ng2VjMp0alqsHOtJKL/64hFZIOp8W4kEhJPFKfxtbR?=
 =?us-ascii?Q?cFSYcPgLOhuXF17SrvXeONMz/koEay0RbDoi2vC3LX9oYgDgroDpMUmHLUk6?=
 =?us-ascii?Q?zyfgQAcQcSmrPBTSvqX9CVN8AUMa2yW1BOYd5DusZ3W0mla9FrIYJgInJlHO?=
 =?us-ascii?Q?24ou+mZi5Pg7HO5ESCHNNuvVpdncWZ8TBe0kkp/sDjJVBtaL+29piFO1mHtV?=
 =?us-ascii?Q?Hmhx6vrYaUrg+BfdDU94SBrqXTl0+AbQo3VgXW4HN6EsH67bpxsWOaXcjhPp?=
 =?us-ascii?Q?tcMZpgbSfgHcWIVRjvAiO/gfAuBXPJSC6KFhNWLcxgsSkItfA8E7GV4Grj6c?=
 =?us-ascii?Q?8BWtuiUwxGeZ51McW4kd41movIuGqI9MpRgMHBe3W1IzpL4MwQgCJf+oU+hY?=
 =?us-ascii?Q?NjrcBXjwy/R2Db/qCTEQq4dXr4MrCG1ElvhNWPT4ECI6DAkzSgF1xNXF2nkT?=
 =?us-ascii?Q?kTk9rglMmgGiJQpZJLX4GXBxRV1yg5YkuyTtPKZyXE4La5ksinFhRtg4jkkE?=
 =?us-ascii?Q?M+Em82uFZZCtmk0bub/6ScoRq2bE2/xoA7/XRQdi5c7oCE3Q//4uUVaB7qex?=
 =?us-ascii?Q?18+oitvzxJfr3Hwj2lDXfp33j56jCwYCbLvqfiSnASKyoW2ASHIzXeIpGM5C?=
 =?us-ascii?Q?ZE0ApoWgLQJ+BqWRlgU7mK6OFNrQJc43aBZMyHavlRW0oJiEoCqTrsuhqWhv?=
 =?us-ascii?Q?XUi96WGHZ2iI/zpQWMtg58oviSWdiy3m/Bjsac2/yrJxg13mlMniQVQXu45M?=
 =?us-ascii?Q?CCkoTI+w9k1mb1xrih4XB0k=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7942767-03a2-4390-df80-08d9fc17ae5e
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 06:41:29.2661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iOE01eQSC117SckH2vv21rIxNHTw68XZbuU6bmXiow+pVdmdFpWhIPNADjqSpW5p+E+L/mWZx/zHZ7jXL2ckSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2579
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

add missing ")" which caused by previous commit.

Link: https://lore.kernel.org/all/1646018012-61129-1-git-send-email-wangqing@vivo.com/
Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/hamradio/dmascc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/dmascc.c b/drivers/net/hamradio/dmascc.c
index 6e7d17a..a2a1220
--- a/drivers/net/hamradio/dmascc.c
+++ b/drivers/net/hamradio/dmascc.c
@@ -1354,7 +1354,7 @@ static void es_isr(struct scc_priv *priv)
 		/* Switch state */
 		write_scc(priv, R15, 0);
 		if (priv->tx_count &&
-		    time_is_after_jiffies(priv->tx_start + priv->param.txtimeout) {
+		    time_is_after_jiffies(priv->tx_start + priv->param.txtimeout)) {
 			priv->state = TX_PAUSE;
 			start_timer(priv, priv->param.txpause, 0);
 		} else {
-- 
2.7.4


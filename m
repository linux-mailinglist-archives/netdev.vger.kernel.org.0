Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299B446B3F1
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhLGHfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 02:35:06 -0500
Received: from mail-psaapc01on2103.outbound.protection.outlook.com ([40.107.255.103]:12800
        "EHLO APC01-PSA-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230202AbhLGHfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 02:35:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTQp6e0TdoQZQeULumA8jlYlx5i+YGZEFKXvhC8PVJZaP/jIZcJJq7+zEuwu9sy4+LHctzUQKP91Im/a2Q4knyZK7yfYSItuwJ5Noz/c02FIJ4iEdp6+XFnapCcIhDNb5VTTVd8wXQfQchGU4MPLun4Vf92O3axWSclVJmvizTjsmyH78CMNSD8AVBmsbIklXvgAi1X24lK1XLMoeknifZRewCfNy6VCc+XXw5jbjh1yTrOGDrTccEwBZ+8pnx5DiIXa/p4fLxFSQRdy9Qyn7NES3nf+3Nvjt0lvzWabBEB4nepd3P7vNWPjeB+np3AokGbutzWZS1lnhBRe4e+LXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwvjk2tVjYCRClsu4aGXnVl/fzhjkzBCK/RQJh9FYyM=;
 b=OnFYIQzzMhmDkmt4S2bmyx1pj7jOrK67NnZy+ww389tYlMJCWnn+F8DjDdGaELoKnSQR5qsLN0qUEr28j3DuJUvfIsD2dCZptWGRr5fl82Q672aHQLeQroql22mku31SczjOMRJDCiZfzbHVoYQmyMm1k0bN6rLVduZ6OD7QBbLmmtX6FISuwNyBAOR8/qXR1kVXm/Bh3CXoXTUJjv+b1frCYAjsedqkBdfNPn7yvMzmajh/LMebvMGTft8tUHyORrIAHYWd6hWNF8204WvmkZgGvy+Dc4sYjYc7qwJ+sl+6EHReS0FNtWLCwdxycFG7tjXlmjZ845LCeuWU85PNWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwvjk2tVjYCRClsu4aGXnVl/fzhjkzBCK/RQJh9FYyM=;
 b=Hlq4pekZ16HqEl7vueVyB/qwq3kZeCWM8mqlOPbzcH9eJCIDCLFI2yf4jsqgEGAngNUMF3310sfQLC06CVaTJCMmzQ4AU0O3VV8W41SPaCmrmwTCQsO2l7PZct+UnObZbebv7BSLggfI0cJfw9701qLVkDzK+aWopbnToUj7sBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by HK2PR06MB3283.apcprd06.prod.outlook.com (2603:1096:202:3c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 7 Dec
 2021 07:31:30 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::8986:b885:90d7:5e61]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::8986:b885:90d7:5e61%3]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 07:31:30 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Guo Zhengkui <guozhengkui@vivo.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com
Subject: [PATCH] net: gro: use IS_ERR before PTR_ERR
Date:   Tue,  7 Dec 2021 15:31:09 +0800
Message-Id: <20211207073116.3856-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0302CA0016.apcprd03.prod.outlook.com
 (2603:1096:202::26) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
Received: from guozhengkui.debian (218.213.202.190) by HK2PR0302CA0016.apcprd03.prod.outlook.com (2603:1096:202::26) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 07:31:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d335222-8aa9-4a7c-0166-08d9b9539625
X-MS-TrafficTypeDiagnostic: HK2PR06MB3283:EE_
X-Microsoft-Antispam-PRVS: <HK2PR06MB3283ECABDBD1316727C3318BC76E9@HK2PR06MB3283.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:184;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kcdr/REY2vGI+8Q4+YN/3huvxF5lcmqvIqIChsn+OXZFUvDqp455JCt3AbaPBouubFzYDoc8/QQrG7P4oneA59dYwozxCWvSDxRHtT1y0XnpFyrgZTUBahThN9FjTKYBn5/rU24VYtCcAfWTU/aihdiYQi1q6e0coBJ70XacjEQtW4SA5wQ4IWvO/ArKaD+/kiNOiFfkL6kSHN3+YIdz3xkJXlpa3hYO0vHzQz21rOTMIflP4+DsAc05BcbcTsWcJzrtAwgIVsKyTYK6MZMBbdDCNE6wsVRyM/X76FSvNL7FpYG47F3f+kx7IXhigN98rh77fOPvAPD50zzDapW95qUd+koTm6D0/VhL2PG3mN2SScW4G9JSDPIwi7Rek1+rR29mDqwoKCReLzTAz4ylyoM2Rcdk5gPdDk7eTaz7/sIpfB5tECtKQ0rqQwNupDlLc8WDfdaJAPHBZhUwajCQxtHV7fQSXYSX9+f/LwP5gmbuwbL8BEuVoa8hgr5LmNY4AI+O2Al8XliB03oq0kYI9InwmY0IaWG9a6BzjtDGl5exWOvtCZlw+987HyeaPtwy6Z3ZJUuDy9EHMlGNaffsyKH1qqT2K7UZS5xLiTkrRiocL41qz5QlQtPPo5aBjANwtNNx3b62haE9ZCTl56ip7FuW9dk7afJszJxehp79UWhlYEwj0ELexk02bhIqdv1ohmtBGgsBctNmaqUgoT9u9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(508600001)(6512007)(4326008)(52116002)(66476007)(66556008)(6506007)(86362001)(4744005)(186003)(66946007)(316002)(2906002)(8676002)(1076003)(5660300002)(6486002)(110136005)(36756003)(107886003)(2616005)(38350700002)(956004)(38100700002)(8936002)(83380400001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I2T9NVd6tKL43iJrgVdx2QQSlx9kk9rHpgTrYLXMjuv6kQXWgl9iztN4YL0W?=
 =?us-ascii?Q?FAJVrE9/QObTfLcjPqJErSfBp+s31UW9ceBR6Wnt18ARZlWnZOlKb2VlDzmA?=
 =?us-ascii?Q?AHzz85qtcetjlgL2seLOX5JTZXudFULomMxFi08U23pF+0fUkIPZEsGF+wM8?=
 =?us-ascii?Q?vk1xDwSqBcLjxKrep6CnO4yhVpt8VCG76dWQJMdO3lWn4tEEh03ET297IhZN?=
 =?us-ascii?Q?ysctT/NrI5dLbHm6/FwSpYGKgp1fHrb3yUbtTdwgdJqXJmBZ9QfJJB5XIRr5?=
 =?us-ascii?Q?bJAOx3Jz2WkYhNzCSazqG1OE9A1I94me65wGqisYHO3jhC5NuzO3ohvNO9P1?=
 =?us-ascii?Q?7Iz7WohYJHDpGDEGlah69DuKXlE16rpcFfC5HR6WUHnSWO4PHwoSPtlerfXN?=
 =?us-ascii?Q?cKMUOnNOYkPPrueichIFGGs59c6llQ5Fd0jAJSGrZMa72iI98RlweByoTibR?=
 =?us-ascii?Q?Lm5qEe26IwZGVV4eV4HCDHzQ7eUob2E2lIfvb5pkZPHQP5ZLU6RyEbeEfaGL?=
 =?us-ascii?Q?ANbkjD7MgOmpq0iGZN3fEqeiA/LEQto3V5bTdRr3g++H1wZC6pnkMiGBNyk/?=
 =?us-ascii?Q?AEh8m0aqKeSfe3ArLm3PDOIwGInruK5yC5i673NZQ3VQ9jEhHyx2aGubyrES?=
 =?us-ascii?Q?BwJVBusGM343DYSx4dOGcplPdGN11KG704Mj3KKp83JQBmvMr9WkTES97/2Z?=
 =?us-ascii?Q?6mkv4lVzHkRr9WPybGJvYYACsBKwe4wiRNn/oDVVaZySsHHrdhbVeubof52k?=
 =?us-ascii?Q?kHkCScRhF6VPpsBzKp53K565ObvO/LKmVFaZ94njGPkSW2mCTBWApcY53fQN?=
 =?us-ascii?Q?KqDrcqUyl6dA8Vf7++8NRsQAgIT/LyX3vUT8+IAra7tE5o4rGvNJ+753fT9X?=
 =?us-ascii?Q?5KT3u4CoZrAo0Nm5CGcHgB+p9+wpVNptHNZD5JRs0yyBhZZB1pDLUWAFa+xm?=
 =?us-ascii?Q?4ES+BTRWIKaROSYSLYQjIhbOWcjD7rtxW9zqIrMOX0ei/wm4UjhvRVLMJhpv?=
 =?us-ascii?Q?T+hBdFmtcDGXvQlZN6JEfDDicEGp8HZbyD790yH6X+hG8bklWRTZ9L/pi+UB?=
 =?us-ascii?Q?o1Sm8mUkDAyVvACkNkJlGevOzdydg3l5RkahipUptDa3JbtOFSW2aay8YTBn?=
 =?us-ascii?Q?E0OinX+kiA4oed9ii1WXIvLxhK9feblQzUloQkX7arApdU1Yn2i5YT+pep7X?=
 =?us-ascii?Q?+pdTeYJx0GF1RGnLG0v0jttykYHYBf96CqODCC74X5ftEoIIgKtS/8NodO/O?=
 =?us-ascii?Q?2m/QjkUfXIhnYXfai16NnYrSEIXYY+ehHaPH+Mj1UHyqgK0Kj8DTM5Yvi0mD?=
 =?us-ascii?Q?Dp+hY0Zc/f5bI88LiYV/GGVWgY+egg6BQYqLZ0cmkKoJ6N7LaiTG/nFoyMZJ?=
 =?us-ascii?Q?eL8Mmt3+oeC1iZ2Z8FiMYGGnRLXEcQNUORBKl3Xr9L1IH9fOX1pgnsmZJLvI?=
 =?us-ascii?Q?6dNjrJhAxcNy2LT6MJF3L4w4bbpOqn/wnJTp6fCUoU/v55QE9lfZcB5yz6mb?=
 =?us-ascii?Q?8atlR3f4w4mlSe7q/NdIFGjpcsuIwoZF0kQRP4/XBWIcrLrh8bTvK7xshYLQ?=
 =?us-ascii?Q?dggCrQEKWENEtxEoIgrfW7ckqNdJyCGSEbQOn/hjxv/hZA6t7UAXWU2N2tLr?=
 =?us-ascii?Q?/0XNruXFayDB14cLZRMlbvA=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d335222-8aa9-4a7c-0166-08d9b9539625
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 07:31:30.4567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AWoboaZOdce24Xhxras8QQD+KMuoP8xqFLv05loibJnzEhxzRrnfeN/WiMVnYPNknP6N1c0uMq6kCevzGji1Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR06MB3283
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix following cocci warning:
./net/core/gro.c:493:5-12: ERROR: PTR_ERR applied after initialization to constant on line 441

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 net/core/gro.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index 8ec8b44596da..ee08f7b23793 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -490,9 +490,11 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	if (&ptype->list == head)
 		goto normal;
 
-	if (PTR_ERR(pp) == -EINPROGRESS) {
-		ret = GRO_CONSUMED;
-		goto ok;
+	if (IS_ERR(pp)) {
+		if (PTR_ERR(pp) == -EINPROGRESS) {
+			ret = GRO_CONSUMED;
+			goto ok;
+		}
 	}
 
 	same_flow = NAPI_GRO_CB(skb)->same_flow;
-- 
2.20.1


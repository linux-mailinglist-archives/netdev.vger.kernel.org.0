Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161F950099B
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241656AbiDNJXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241654AbiDNJXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:23:37 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2111.outbound.protection.outlook.com [40.107.117.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F666E570;
        Thu, 14 Apr 2022 02:21:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPv1TU40iQ8gaX98WgCAHJaG5kV6qZWozqq/Oj7w2maJXuRyWnQHOoLgVY7qK8nlErSnNBFURA0BdHSxLVWeYfMd1oCefAAGG+hQrO9NEjlfxgF2KPeUxzckhTX3jMz6ENK/2FjAw839tDrcQWXAYqvWLj0xg3ZJEptyY1lHCsa6aCbL7AgQdIinLmU3wy7SZE3fiWdVG0IF+iMpMNHlP52ad8Avr+JFY78S0m7GGEfcSoHhhS5dnmiO7Vjp4HcPmG/qU3FT//yNavqn8DRq2rcGVkp77F8TYx8qTh0y5L3nK7ez8Np0EJDIFlcdVX2kiKxpe2J5iUNrnpJ3bNNwZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZA7Mas52dmajd8b2ILGwUm0QTxrBMGNN5OQ4R/OocI8=;
 b=mkT5Cp7LBDmwM0wSWpvhxAquxzDU+e0Sx0xCsss0ghWYzSNprsQCU2zh/VKdnzCZ3ncC3fUCoU3SovDYjPZ/WfNy43ndNGNuxUufE5N1yE9+ZvMOIRQ2Aq1giJqHkwZOqo8dVXpwTwAhs645L2N6B06EHb91jkvy0vTTCGnV2aHDWF2KENbMqsr1tzOYbSDjgr3pCK9Hb5SEl3uWQWyfW9PGD/Okevg9UfunGgOPNJNLcbBatW7OP87JL0bY30G8iDmDY2V4PfIMdHO2mq5KPLutYdvfyg468wLBoYB46y23IfpMcV8N6VyqQoo6OTI3jYew2CpmU81qvNnb+2I3Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZA7Mas52dmajd8b2ILGwUm0QTxrBMGNN5OQ4R/OocI8=;
 b=iBTg1bAmkKeEj7TcQwHl/uyFNzaaqBZqJLlRYgbmTGJtYcz9UoraLovLmqIzbbslbhC5VlRPdqYAeSW/jhmUrI068s1CTE10ZDJa+XIb5gdh2fVR3JKYgx9i6yZ+2PkafF2wXwqj3Z3oEi+Jg1f7A+L5mF1MEtDE0yrRIS/6FYE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by HK0PR06MB3700.apcprd06.prod.outlook.com (2603:1096:203:b3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Thu, 14 Apr
 2022 09:20:56 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::d4bd:64f4:e1c0:25cb]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::d4bd:64f4:e1c0:25cb%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 09:20:56 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH] ath11k: simplify if-if to if-else
Date:   Thu, 14 Apr 2022 02:20:42 -0700
Message-Id: <20220414092042.78152-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0018.apcprd06.prod.outlook.com
 (2603:1096:202:2e::30) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36fb2039-e194-4369-5470-08da1df81493
X-MS-TrafficTypeDiagnostic: HK0PR06MB3700:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB37009190A86BECE30A7AAFD8A2EF9@HK0PR06MB3700.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 332w1yCqCZ5PRqcypZ9zQgqizWxlysMrgLwC6AxQTVqnp2j/wsS5D5+YyX+IaMzHlyAtzZmiOZl5/jknOUqfUhrJYdqYH+/KG49q8BQhw5howVe6ci15wUcQh0I1aaXvtzTTfeJ4M4IUloAdJ39M8WiXrlPwDkTan+m3+TxJN4niFZAO69zaoGsPtz6v7rd6Jwd01wVPXF0NwyFD1t57ORVYfIlC1DaPtuPINPP1VypBECsvQ2BicG0rVg1RmvUrZ3fj72H20PVK4fxt1KExLcVoviVELg+YXk4+qjmZ/j5mWAUBlATFjgp2jaExbw08Kln9Gl8vmRJYakwzdyFa2hK/bmISgDN+LRqsjP/SHIitCb0KfsegvbaaxgKPBK/GKAiIB9LYu5s/iR/o37XGQ+JHVMmPeobIQytywTcp+++AChKpHu9iyhLn5vlWKhUuNlAU1K79tJAdwsZlWwa+0gUe4B45wlxkr1jO+btl3+CUf0x4G2XsduKcCBgml7dV0I3jBNA/vitjoHuS/lfHYozU3DXBuaL6U2jCgFH30WpMP8RCwvJ/i3OouKYLzjkLTELXQQ9jlDgxmLTIZEygfkS5v1PwIALZ9fBpe4fUPQuGGEIOej5dVP07GRMmeVMZZl5EUsbTshMkwsOEM0L/g2sB7gRA3sltQUC6J2Vx09wms9DTECMGKwWeg1pvKZ6cVW7yQKUDS18VwRVTSlrYyvdJI9TmuQGVtu82VYW1RHmh8zqd51biM66OzvXS8CW2AqxJkpDssBZJYUNg+Rw5zE+ORp6PrquV+bAVZ+2UKU8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8676002)(316002)(66556008)(66476007)(2906002)(107886003)(36756003)(8936002)(66946007)(38100700002)(966005)(5660300002)(6666004)(6512007)(6506007)(86362001)(110136005)(52116002)(1076003)(508600001)(38350700002)(83380400001)(6486002)(26005)(2616005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RR5+AHtPphR6UTnDzYfKyKOx+t5ZcUhiU933CPPLSoDWQ5IRYF3TfiaV6wje?=
 =?us-ascii?Q?7fEXxN8uHE1kyjWrfVpo7lXNP8h+sF2/eUG0mX6zkJh0PzO/V/X7fvU57piN?=
 =?us-ascii?Q?SzjgaprwLxj7Lp/iV9P9A+knCNci6lATZZyAqolHo1yMW80K9OYZ8felIC6d?=
 =?us-ascii?Q?Hy26FipzJbDys/gJLVoiWNRYqgBlGhp3N78uKc4w6K3rAxXOx4bKLgEeCqbG?=
 =?us-ascii?Q?8/PuJi/0NQJTkFVtfWhpGi8La2Ga0vIWSCwKG7jq1lTHzOdzfnteZLVrWShb?=
 =?us-ascii?Q?ft9PjqWtZJoSsh2KmFejrlaTaMHrcNEoDXNBxuWcn7+7d+l0VZxSg//GPa/O?=
 =?us-ascii?Q?dm2sAA7D4DUKjzCtgpHUV72xF6vm9NtgD+FB7A2kN7KmnOd2g9yJ+VtkFFs4?=
 =?us-ascii?Q?sc5ozR6NYMMAkpvgA3O+YjfpRMc005n3EymzPNYRgN21AZrghxUhc6jd+js2?=
 =?us-ascii?Q?Vqoqu+l7ELCU22AO+eFvIHNOxNaJMKSk6AuoWKGz0cBxD3c4qLYpJP7UBQnj?=
 =?us-ascii?Q?MoNbPsI3wEcXDfeXz3OU8LtAcvX4ZXZ3Ei3FzRDL5wG/skaSecSpRhiTNOVF?=
 =?us-ascii?Q?9qZYUgqY8CXpq56zsK+98dLCIj08ujI6BbLuIUza9tY2s41VRXIZiPkfFGmx?=
 =?us-ascii?Q?hv/HK613WQ91yrhCmu03ysseowGF3Ulvxzs2QuxZ09NyIvmUMP9p4dv058O7?=
 =?us-ascii?Q?OOGuU6LQ9wYzoPGo+qV+vjRd7adCb1CzCzIfN5eCWyeJN1dbInxhrP2VxaA+?=
 =?us-ascii?Q?I030C4g9x/FdUiLuKNh5pLpqei6IrNpgD00//Lxz9zaMfzs3YGA+6iJR7D/l?=
 =?us-ascii?Q?Q8XZx6DJFsfVV9UBWtzozwIMX+484qyDhm+dANyRK4iqzeST8jeFtge/mbMs?=
 =?us-ascii?Q?Vn8v1XjjXiZm/1X2Rc+ILKvOVei1kyPB0kMFxKxC+u6OoPP2QhnkmCBNiTBL?=
 =?us-ascii?Q?gXtBXHAOeEnd2i2taJrF4y6hbMaaUcV1P+Tk/evYGLi/5JXFol1oPhd3HG0T?=
 =?us-ascii?Q?KLxJQaDW6uwCLs8Ob3juevx3dj7qXLdZbhc6l4hogG/aBIAi8VC+JW9bNUsT?=
 =?us-ascii?Q?GLSJzLahFXDLcAyOLTWeUFBAld1Q0Pd6GGGpe9JQyMto8QfsuuOYsTBeIN1t?=
 =?us-ascii?Q?8Ae9P587CqQzqF76W5q2AvkSK/PvNgJFUifbYVsF8929k9OZUatt5HXcAeLe?=
 =?us-ascii?Q?YkDbSaUJ7LGA8Ym2pTr9GCCY46wBoCQQpB7X1bCBDWMzdV1mOWVJ45CdoihP?=
 =?us-ascii?Q?Runvgt5gVX+6cgL4WZDGfOCzDsxpAtVTJSGRsW4RHHc+KNV9rbeRPS4IwAWY?=
 =?us-ascii?Q?9Y1T6DUx6DQmwxOylcDCKwPIqpp6qlTygA7ea/TY7MsY31tXKDI3uodg66MS?=
 =?us-ascii?Q?FVy4oz6tF8v6gm2hU+hArQzWsSn+MJIlBjGwduGBLxYnZzwJ5PZCUVoS5Rp4?=
 =?us-ascii?Q?OyvAV5/2cfVulGj2UOnzmBPpWZ9JY7NaJWna40TAuAcdHSJ/71y4vTu0/N1h?=
 =?us-ascii?Q?ew0uiTY2y0v4C7ZBYlzPSma2Ar28ymhUGd/bScr/K7q5gV/u449x4hXpba4A?=
 =?us-ascii?Q?+wczLh75Tvwaa5TA/fEFKB9bWbbuGkwuWlQgNhsSynno+eExhplsydhUgNK+?=
 =?us-ascii?Q?XYRQVUDFgN2fYSXk2XMf4mcI98Ya65uZ9oI9b3h6ZyHC6z/JygGEe/JQJbiY?=
 =?us-ascii?Q?SfTbdeKf33BiegLUy+P2ylXn16PF7KCDQtxhs3BTlOks7ZYu/Kf1WOxJGAg1?=
 =?us-ascii?Q?cZ35xxvb1A=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36fb2039-e194-4369-5470-08da1df81493
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:20:56.2359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AuTtgXyI+swTFm8yjM/1jPYZQCCavfz3a1YYltd+x6BMJmngvYc2wtQLt5rXQG23AjFFdEsto/yL25TQrj4mpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB3700
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace `if (!ab->is_reset)` with `else` for simplification
and add curly brackets according to the kernel coding style:

"Do not unnecessarily use braces where a single statement will do."

...

"This does not apply if only one branch of a conditional statement is
a single statement; in the latter case use braces in both branches"

Please refer to:
https://www.kernel.org/doc/html/v5.17-rc8/process/coding-style.html

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 drivers/net/wireless/ath/ath11k/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index cbac1919867f..80009482165a 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1532,8 +1532,7 @@ static void ath11k_core_restart(struct work_struct *work)
 
 	if (ab->is_reset)
 		complete_all(&ab->reconfigure_complete);
-
-	if (!ab->is_reset)
+	else
 		ath11k_core_post_reconfigure_recovery(ab);
 }
 
-- 
2.17.1


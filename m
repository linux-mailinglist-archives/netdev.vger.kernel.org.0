Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188EE4C098F
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbiBWCmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237796AbiBWCmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:42:05 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300113.outbound.protection.outlook.com [40.107.130.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A984092B;
        Tue, 22 Feb 2022 18:35:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QyLkhQnhiomKaCg7jNp9Hzad18+sssh2b/xYd5MxvmVM1UXaM4y9ZhzsIBU0JjSkI0dVda3fgd5Wiuap4jUNYHbnF9pMTHcUXoCbwi9NxnjbfvLRXUboXiR9YzE7uTeNb8PnNf2UjAfAKO4GH19IFfVeW/p4eUvqeGAlbpjM+bSEgrDwG2UuXZsUKrYKQVVOMkt6yGqz2R6ZX03kH6u4EJ98SIDcPIPREnVF6hTwTLD6U8F1J/DC0OXRdH3IQhAuEmatJNFUs3AtvM6+3yqz0vvTMWUiK1pZ/aBnS/XzkpCh35gW7tIzF1FE6BTk+qFeoG5SIL+pH4e13fQE/5hbFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T/q+PgdGy3mV/+3AL31QH8SH6953pVqZ0F7Cwc0JoWI=;
 b=ZQgTFJ+ff+S36Uyx3fxVI2EB1ubyQ2IlBXHfXhZ4+eAeGVKoNg0i9nzX79mwkUh4t8ySd4s0Ea101Hvl6v3DfWJ8dNnyYD0MrD5m/OYV177i1t9hhnbaTaGnseHLeaS+3ZErfk+7Dudq7+Cupvp3PrDEzQOmsJahfllE0InNVQgyGaQ2AJfdXQm400OIkH8HsBcTsFj0+QfotfpL7jCN4hUslhz5+TUiyBdQpzlTO7lNvfXS3kF9evM1JgA3rxz7298KHZ4cUKdtViojR26vWtIKQ6hMRC98+L+vZn5iqMmcEz87y3u+qQF0q7M+p2/gdLWMAfUpLw7kNpJaILcipg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/q+PgdGy3mV/+3AL31QH8SH6953pVqZ0F7Cwc0JoWI=;
 b=bBN0/jv4f3xRdscltJBBpRD1a9+RqYPrPJO1QLy9y1f0hxrysozkr/Gm+5L/Rw+XfIXN/bluIfrRwo8Ma4R6v/Q6ZFHjkKINFKvXYg9YMOahPW6thoxYjXVcMqs/C3jQiAl/j/QAdmVuzOG5zvUJea38nlMWg414KOBf8IrZZaA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 TYZPR06MB4302.apcprd06.prod.outlook.com (2603:1096:400:8f::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Wed, 23 Feb 2022 02:34:53 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732%4]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 02:34:53 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     jiabing.wan@qq.com, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] net: sched: avoid newline at end of message in NL_SET_ERR_MSG_MOD
Date:   Wed, 23 Feb 2022 10:34:19 +0800
Message-Id: <20220223023419.396365-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0163.apcprd02.prod.outlook.com
 (2603:1096:201:1f::23) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4ae29b9-6600-4ab0-5c80-08d9f67511e1
X-MS-TrafficTypeDiagnostic: TYZPR06MB4302:EE_
X-Microsoft-Antispam-PRVS: <TYZPR06MB43029EE0B45709D56356CBDBAB3C9@TYZPR06MB4302.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xahGF4BjJ2jPZNVN577Ny1F0x44Kc2wrgtaNkPpl3wnkcRUKuGsWdZREngR7dAZfOK6iwPOTjrmngwmin0dsBOpSsyjKl9R+z6GxymlCToI1RKvANnSa2F7Ht991/2UaDyRgs1BUEvcHzBZfXHvh/WR8zY98tc/ylDJef13rwjBEopCxFoBYCxlPzUs5jXvNS95NhiE3gCi6RvWE0Mu2vYeoW9fCi+ES3ad9bE1oyPoKmEnd8p4ydJdlBR/zDPaikoSSjJvmcoRjKBjuYqg0oNkSlFhlYlB+Lu5CJzZonqBCXB8YgwjJh0jg+n8ukTVDNO4/0uLpTOcZL1mu/3o0R701oEbXFSEOtvFb+uqN/+oRB0z1L0af4lasbSNfEYG33ipOx+Ieuri508jl63q8UZxXAnT1hqaK2XEwhRAIuDNwMRFM2E5Bd1qEIXWD9iHElZIr660eSNfGxOI6WwUIGMuEIF1efvLd8sYQn+dquwEUglZbvvgPoO0wyvnbr6t4eYsYi0LEGicdJ8MKvBkd+btUqSTRr+TwTzehnYBfSKs5K44Bx3Hfr95/X3AaBYKYb+b1sR+Ocp3ul40qqleJx/nfoEyHWupi4RfRjMQyWw6FFkyyfMNtDpilg7zAKcUZqhxboYuvbbrrlb4irtsK3B87gAeQwQSb4ID7DOaJmn146j6OpaTY7HRz18qxf6a6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2616005)(6666004)(52116002)(6486002)(508600001)(6512007)(38350700002)(2906002)(38100700002)(6506007)(107886003)(26005)(66556008)(66476007)(186003)(4326008)(5660300002)(1076003)(110136005)(8676002)(66946007)(316002)(86362001)(83380400001)(15650500001)(8936002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?flN5n9M4g1l8hzkih8I/9oXf1y9DSm5wIMvu8vgLaZtjlrMEmDmRFHzNdX+3?=
 =?us-ascii?Q?P9K5wkuMX8S3AS+noEDlZAJVRX4gS4ohZkcMQYHMPOvm00J9vFBWcya7JQGp?=
 =?us-ascii?Q?XA0iZHQNFirdGQM/1H+MQ7Q5Tf8w6MDQ0ovqc3abkU0jdUEAqFE2nASWwaKu?=
 =?us-ascii?Q?dG6dO6LEndIT2ZYjSqvLcnTF9owcoqTP4Cx5+5cpQqTjaLtncHKoLGm/zq5q?=
 =?us-ascii?Q?E5/o/KrivHgBRImRBur8wNgzTIMfUU3t4kpCY8M8sN8Xnn4dR9cFedBwxv8B?=
 =?us-ascii?Q?pJQiQNevw+xjMG06HpJ+MFIO1jgUsDb24zTEou4mlUI5ZZOK/20SWRz2UJre?=
 =?us-ascii?Q?i4H4RarChEkB6lfN7Atal809we4tVEra9eEZZm1t4faoG3u7ToYbWaIaaJY6?=
 =?us-ascii?Q?Ap/dphzk+gwrZRB78TRcmGeaq669Mx2pxwDCj5yn4qEWJzFn6vsgwD4/bG3L?=
 =?us-ascii?Q?LmVEpGs4VhdV4tsNmW70g+myYsJIhtfSjd5cPvK50TIrsRZ69tHlCrOarfiB?=
 =?us-ascii?Q?EIGMTDCp13HwM7V/QYI9rPAm7irdcA04XqL2WIMOauQgIAhhQRc2Y8EOA3Df?=
 =?us-ascii?Q?ige16YP1xxDk+yoN5GEUltyBlZ60w9Yozus+mJtPcpyDyagAAVHw9KzhTAkz?=
 =?us-ascii?Q?DSEpQJXvub+gXTreJ5Utbc1XwaJYVplliBXSVG3o+86QhQMNyuZStMixunXW?=
 =?us-ascii?Q?gqNaXQdkbHZPnRV0txK7T60EUSES7wuluSAjAPXlIgz3nx1izs4GmdS5unSM?=
 =?us-ascii?Q?PPBzOOjvookU6ZsCeiBVWNd4YL90lLSttPMrZfXFytlbDROHJ6GstuypwUCL?=
 =?us-ascii?Q?b+NNX18do0tJVBXvonUufdWHsC+G7cUveTppYJKSwPTti7bhR6ShAaAHTZFQ?=
 =?us-ascii?Q?MGCrB7mFiRieu8J/bOoOGqm8TvwVi+v8NaRITYyuPO7TWCAZHp45W4z4dFfI?=
 =?us-ascii?Q?Mb8kCU73HOCreVfypyQ0yVv7lJj88BFEbXq6Sh1QQp5ABqvKEeTwD9vIbc7S?=
 =?us-ascii?Q?7hG9cuCTFqGj6MdQ9FwSaFR2YB9i1DQnyZbOwnGfnf6ArZma8KARwsmG2hWk?=
 =?us-ascii?Q?NNW0/F8uidtHTPLpQSJD/PDKhfAk9pmpcJQxkadhS5IegwsvcZ6eCCxKK4sJ?=
 =?us-ascii?Q?HchG/Q8cc3YNPegll8VD1Yc0c+h0hLzFNWbLFxXfiWE3ZwdjcAVC8cX0biAD?=
 =?us-ascii?Q?HKFRuPOHxS9Bp/nr15D7N+Nw05OwEE1ZhzpUfb506em3VXOOhQ+voTdDkyNA?=
 =?us-ascii?Q?vBcU7EC4zzL/qvLMxNFYw6/uX9rl8nuCfeMFVz3ShvtzjUgfV7GqrvMas0hR?=
 =?us-ascii?Q?nC7LKCwFZvRX2dkzvE52078Dd12566hGRWfCD7kjD0o6iadh0g929AY5/3U/?=
 =?us-ascii?Q?FeywOD1vpVeOJOmwrUnD84w5tT0PEst2KbUFKlKCTPXGuYTWj327RH4nOE4Z?=
 =?us-ascii?Q?VEDasRb+deDd2OUegOUxptgWJDUC7GwiyCp3/5xq26SWrnjj9H1DWLvwgxSm?=
 =?us-ascii?Q?Wg6HSF2UV/pDyw0S4mKsCKTQWo82qLLaAGTTOMEVAsGMOlBRHUkzrtLExAHo?=
 =?us-ascii?Q?Zbq+HnSwl71/NyUlVkbUpoje8sbesB6oehX0B0Htr6fWrVn+f66bDnq9p/sV?=
 =?us-ascii?Q?TddLdmLG+mzpLtfV7N9ZSpo=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ae29b9-6600-4ab0-5c80-08d9f67511e1
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 02:34:52.7005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z425IkbQvSZFGTb0KmZHS/+0F/YwVtX3q9uw7/1Lm3k2xyMMB8ZRwbMJxw37g6CjcmZKd+eqfYCzUbKnO4/uPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB4302
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
./net/sched/act_api.c:277:7-49: WARNING avoid newline at end of message
in NL_SET_ERR_MSG_MOD

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 net/sched/act_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 2811348f3acc..ca03e7284254 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -274,7 +274,7 @@ static int tcf_action_offload_add_ex(struct tc_action *action,
 	err = tc_setup_action(&fl_action->action, actions);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Failed to setup tc actions for offload\n");
+				   "Failed to setup tc actions for offload");
 		goto fl_err;
 	}
 
-- 
2.35.1


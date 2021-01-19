Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A3C2FB49B
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbhASIyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 03:54:54 -0500
Received: from mail-am6eur05on2139.outbound.protection.outlook.com ([40.107.22.139]:42624
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729306AbhASIyp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 03:54:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtvKsRVKU/CVMZyzHCpFpCsRKial0RI6l91xNLtfIWlXj6ZopLqxlz5mab6AoXKYFBgC8OxyVL3/dt/5Cdd6ya0zEvnqVoee2Cu7Ryh6ie3b9PEFMf40xQ+6sp5Eo6RtLEzd9SU4fRX6DmHlPbFa7ljEIIlPG6+xgerixlX/4yKaLAGIM4upakxTNjwLOYzHCY7olwT31TlQlhSYaQWMvrAFLE+rjjJAUzB5fdAIkYykWVe5G639egVUdt+7Drpum5eGYdELcBOJHjmrov83/5Pe/dk2FVVlgjuQzQtEgxKqo3As9HdVzhUhA9SwL2aKBhc4TYHP7vgbAMEljvZfoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7qfmXuS8EYSkZqb+BHFKTyydYoY2FfxttZNfxvwBUo=;
 b=bSToDCzrUQsip6QFew/hpq55WyOtsik/EvfjOsjkbuc/x9dlD1fiHEoejnotuzI4T5TVlbKPwCzh8ZQsHIn9q0P1o5pi6CMeJxHX4ZnGvwMI0hqf2zTQI2xBmvETaS0RkXL/boJ1WgD/YAWejjTHSID24Q0MvcuQ5tp1XkFduQ07Lblo734ctKYBOM8a9bjyE5kR6KWl1Yicp2s/RSeG2x9OKaj64qzACQ+veB9ei/EBHMuvT3q8vpczHVhLibXnReippXUlr+tZfFOOLjR3NBCR1fNIWRC+Zn+BT+4ra7piTgEMKofmWsZ0V4AKYuEAv1sYJiUQb1qcDr4vJqTHqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7qfmXuS8EYSkZqb+BHFKTyydYoY2FfxttZNfxvwBUo=;
 b=tN7eKJzmh2jUfatkTXT8RXSuBPTx70UJZTTAY2oEGC2tC9V/qRXeeglotQeB9Cqu/iXRboRBjuN31axykF4koJ2GJ1gExBF3iQRFT/FQW2rIxr7TNsrQ7188TIti6S09liuCf6yZmdeZ/APCqTYsAJn4DP49+p+GYdvg6LEIrzI=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0426.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.13; Tue, 19 Jan 2021 08:53:56 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%4]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 08:53:56 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Parav Pandit <parav@mellanox.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [PATCH v2 net] net: core: devlink: use right genl user_ptr when handling port param get/set
Date:   Tue, 19 Jan 2021 10:53:33 +0200
Message-Id: <20210119085333.16833-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR0202CA0024.eurprd02.prod.outlook.com
 (2603:10a6:203:69::34) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM5PR0202CA0024.eurprd02.prod.outlook.com (2603:10a6:203:69::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Tue, 19 Jan 2021 08:53:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e44cb8db-544d-496b-a493-08d8bc57c123
X-MS-TrafficTypeDiagnostic: HE1P190MB0426:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0426A4B082B14E12CC55016995A30@HE1P190MB0426.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:275;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FY2twaReUaHC7EGg3EiDLGpyg26wSEauTR1/tywpmlkMlOYU0jXt9tlsOvrG+hxh6dlHB14zYeMkeMa56xfvTVcvVVmTp0majlkQCME1ocq4nJb5sxA+jnLZdZv3vxdqwhfmXf6II1q7rn24kQMCdqdDpvYz6FLzBA8HvpAvylQJ0u6ak0DHgADQ1ukwH6H7+G8RU2ZuTvqP/qj/HBHbwsJfUEG63r2efaa8nlSwripUG4GGNMbQDQSS0nQ39TrL6LcDqXoLjiycafbUt4+ZpWKvMRNap5fK4yLc4xEpCJ70JX4W9GVRxf97OetzexeE7MVTdNRHOABTJIkItBZDE2tBY2/+YSHAxupyUpg7nrg2etgpUSuOflkSGqWEJ19HDdRqjWBSm6NVygeBWsp8sq0Zm2D4nSpVWtQM8YvT+lz8VI7kW1SYUJAPwR7sZ/xl+Kv/f/Sk09sFdwu5oY7OdBtbaJ5UzBDbWf4fICJUFovwyfZUE6dNWAXlHXDCO5ynjTt4gBCqalgZL9gK79UmXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(376002)(346002)(136003)(396003)(366004)(186003)(6512007)(54906003)(110136005)(2906002)(16526019)(83380400001)(26005)(6506007)(66556008)(6666004)(316002)(1076003)(5660300002)(2616005)(66476007)(52116002)(8936002)(956004)(8676002)(66946007)(44832011)(36756003)(107886003)(478600001)(4326008)(6486002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?l7QLWu/PCOq7mOltM+f8kpbhl9iyqEc7/y9YwLiEtpV8xY4fOcwIamNSD/ay?=
 =?us-ascii?Q?EvPUFVr7YXZfqnnCDzHPG/1jcL14nnsuG92uDikBBDn0sa/NZEugFDu4Busa?=
 =?us-ascii?Q?IrUBiVVazeweYFJMiYv/WlLUUCc5evJgnyZcREQmGHtgLZeaG5rClUXdrico?=
 =?us-ascii?Q?hNHhjnhZufgBylGMb5RkD+AGXWweOpe2kZJsPpPEe16sYIfdDsU4ZEYut9mz?=
 =?us-ascii?Q?9u1T5nS0N2K3srt9X5542W65/Qph5SJAD1jWYg7BE3LuC8N0Traz6kYpydM6?=
 =?us-ascii?Q?VluqtFH6jkQr8VtNUS5bFjYUjegnNbhfIVmWoe3IEdR0X8aotxfYc2nhZrlz?=
 =?us-ascii?Q?rPN18uxlatWPkvu7N0SMQMrLZth2zrHaKCSEpHRVvruuRhHSx/kOw8fYyRv8?=
 =?us-ascii?Q?FSFceK5gs55rskEAaj+4z5IXcnUnCiRBQLwKXiRRGkh9bya8TG4r5FV2Wf6U?=
 =?us-ascii?Q?tD4YhpY9DNkExJasG0mAK5F4eV1Y3aVj4gKQJk9e/YG9xDMSUefcue4fTgK/?=
 =?us-ascii?Q?KCgnTMt1dt2mrkAIhWiHK0QnvmzxHMHneKV6/oiK8NtWEnpLsjN32e0q009f?=
 =?us-ascii?Q?AhkJ5S7hheYPdSvBQ/v3+rGO3F69ckj1ni9TmJzHYhinjAYiRDwIF+war62b?=
 =?us-ascii?Q?H9zea1duqw8vsWDN7564iUqMv775Ub8sxi4XseM+1LPyRACElZElXmxX0Oll?=
 =?us-ascii?Q?3Cn9TqqmL5l3FZGnTqO87LMe+NLxADKL0+j7ws8jYOQK4oeYexzbKhHncPVb?=
 =?us-ascii?Q?ssoTEqabbBoYoBDz5fo2Bh9E7azJJP/mwR/jWODCvFBFnNgWo/aDRN8VQefF?=
 =?us-ascii?Q?/hFdHlBKx5A/7Q4z4atFcvHbnMOphpbV8/PmWBZYK9q8PnG76CjG4oui/RdC?=
 =?us-ascii?Q?jF+EpX3z/JyBXHHTrp8DM8uwaJT+jCW067OxvnBUWQIZYQCN6T9nJwUR4FlP?=
 =?us-ascii?Q?ynht4tuOT7nqKGEwgz8JuO0kyjM/FDSZQotsqPrUhlxzH8EsDmKE7QbqSCKi?=
 =?us-ascii?Q?NtgV?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e44cb8db-544d-496b-a493-08d8bc57c123
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 08:53:56.2939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/BGQFpWgCCVin1oip7FVI+aQN8fhjbMx3ztyPNZaYokoh6r7AQ7EMaUldV0oCJKQAuOR5JEvke/41kpp4J8H+iUgs8AYXxQSVLsTuLhmDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0426
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

Fix incorrect user_ptr dereferencing when handling port param get/set:

    idx [0] stores the 'struct devlink' pointer;
    idx [1] stores the 'struct devlink_port' pointer;

Fixes: 637989b5d77e ("devlink: Always use user_ptr[0] for devlink and simplify post_doit")
CC: Parav Pandit <parav@mellanox.com>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
v2:
    1) Use correct "Fixes" commit.

 net/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index ee828e4b1007..738d4344d679 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4146,7 +4146,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 static int devlink_nl_cmd_port_param_get_doit(struct sk_buff *skb,
 					      struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[0];
+	struct devlink_port *devlink_port = info->user_ptr[1];
 	struct devlink_param_item *param_item;
 	struct sk_buff *msg;
 	int err;
@@ -4175,7 +4175,7 @@ static int devlink_nl_cmd_port_param_get_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_port_param_set_doit(struct sk_buff *skb,
 					      struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[0];
+	struct devlink_port *devlink_port = info->user_ptr[1];
 
 	return __devlink_nl_cmd_param_set_doit(devlink_port->devlink,
 					       devlink_port->index,
-- 
2.17.1


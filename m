Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3222C2FA7B7
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436627AbhARRlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:41:35 -0500
Received: from mail-eopbgr30117.outbound.protection.outlook.com ([40.107.3.117]:57434
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436638AbhARRk7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 12:40:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNmuzR50ga0E/h1Kup2XlI//mt9IqzsED9V4FLVoN1hLP5EaUjKeF923LWffuVMJ5LAjrJzs4Bims8UIlMlsiOpnskqpGD4bV5YBgtiAYA3S6BuW3sfswfZfa/07mybDMIKCKPmW3ztH29vumtxCrKu8IoCwlIfxDy0HZiIsj0MkZDvLpsv+lRMV7qsaeWKQb43Jm7/P9kH+EKqrW4hEXLeu9XIN7nlpC6DpPeiuLE9j+eNFina4Af8XY8eseaY61AGDQDca/DVPY0EMB/xbnH/0JYlRDpVltwjEoCziIFZ/AJHdfrTKysWcKBhp9XCX1FNPlH7EuLq7EipPMr99GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caNA/1L1RkSNF2od84JPQBsYywAfm0RNTq78lAKyVbY=;
 b=IHdpgnDDBEBiL/7u+QK41D2JZIAjET+ISLvVlp3R4lslRKajjRa/dlFu0ly4yX1bbZt1V17wgjD99PihkBtDQ8raObIRaRtraggcXRF3gcK58glaWkQpeHyxpEbkn5lAwZp+hRjfXUQ0cEiQOaBeTswCMUQ6++I/X3N/xX2oHqDmrpAuLKya4DoKkJ14RUidnig0rTAH1CpfdUeWXSrQYN15aB0ihbcvcLIhp7PpXJ/P5Ghsm4+VPrnvR3+RxY32eDPpDgL3WRoXQMhodZuEKUmc16HlXFB/PG/da7P6PHxXQ9KHU5WRkSd5oltvuhFlUQKd8sPjY+h8eaaxhS3sZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caNA/1L1RkSNF2od84JPQBsYywAfm0RNTq78lAKyVbY=;
 b=PGMg84UvK4shFPq47FrHNlzGl/k2OTcElkTOmQu59235uPN6iMY+r53NFVU8OXIHmby+lX3xBpeRVhZpfe5cDmc0//wphJa3A/rMSOHRCKl9FyG2qPZ6SBzAwKMcBouYHI71oxeZFdzxbJHiLeSac2zmVikDtABVW9L6xRsgg1E=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0330.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:61::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.13; Mon, 18 Jan 2021 17:40:08 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%4]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 17:40:08 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [RESEND PATCH] net: core: devlink: use right genl user_ptr when handling port param get/set
Date:   Mon, 18 Jan 2021 19:39:54 +0200
Message-Id: <20210118173954.17530-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM7PR02CA0015.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::25) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM7PR02CA0015.eurprd02.prod.outlook.com (2603:10a6:20b:100::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Mon, 18 Jan 2021 17:40:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d490e5ba-2403-4278-6c15-08d8bbd81926
X-MS-TrafficTypeDiagnostic: HE1P190MB0330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0330BBAFB9EC60BFEB19476995A40@HE1P190MB0330.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1qFeO0qA0ez6cSoGI78u94QNNBEEGn0cElysu1PdbOIFNicxLMR/p1prf/haQd+2KBCNQ90TzRag6pEVruy+oUSJBM4Ke29tLhT52tr/pF7d0GRO8cHI0PKM03hDs6pyQOdGy4BV3GOgEfkKdxXdsucsA4G/KjLW8k+ghaDoEjlPf8wvsjT1SaDAYUXvvsraE/ET8FPLEaMC0otwKu8nda5hapheQye5Sxw/L/8vZ6/iiI9/orubfH2Lf8ZbYFvMLXRRuYBLnoMtWmPnX5M983l1GwjfScz7w5mHtZs947ACEB8SEsHiZAduTuo2f6PvoOlf5PXFxtfT0gQDeVdovwHGDJLRjtDxomdPy/u78BPEiu3sFsDOz41e2F/lESV88o0Cdbb1l9qxOWfiGwBEgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(39830400003)(376002)(346002)(136003)(396003)(66476007)(2616005)(52116002)(4326008)(6512007)(8936002)(54906003)(6666004)(186003)(1076003)(8676002)(16526019)(83380400001)(2906002)(44832011)(26005)(956004)(5660300002)(36756003)(6506007)(66946007)(107886003)(86362001)(478600001)(316002)(66556008)(110136005)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZqwnyCVZmDmtHtG66jfWFDNJgRum5xX5YC5qKFAejciGASwK6iiX+Sy/sNmm?=
 =?us-ascii?Q?iQtUK+z1cml6iQ2xEAxTotrhLHCqtPO5BRH0kVp9oPrHAj8AKnXydkPmykhs?=
 =?us-ascii?Q?ht4gkPMZj4jkUPG/mcp4hyeqrDX8x8caYPQ83kMV9LwFQQKy7OdQT2xAZHWf?=
 =?us-ascii?Q?4rHRgz7M9eC0yjsVlAjWmncNi+8RlHs/8hGgJJcXGi3N/4FeMBE6NTOMiyBv?=
 =?us-ascii?Q?d5hWpHhdXPiW77hAb0AfTHUbyhkvVObSjKqbVVsn0N6asf4vJNxTd4zgMHUy?=
 =?us-ascii?Q?f+RSiV6p3IpJoUhS2XLABIr9gq/rQsJQRzlvhHbK5u3AePJlaFFLiNJ/vrad?=
 =?us-ascii?Q?Xf23Uq88WuxcD/TpjDUC/jVNcFjE7eVpEWqG6onfP2UFtzFebxf5VMWSMWlG?=
 =?us-ascii?Q?u+vyt6l609UnQA/oUm7Uu5fy/gFo2PDt2dp6zQEvWB61zOR1xcK1N8xR3J+9?=
 =?us-ascii?Q?zl5SbVxMszZd/2XzWRlVA56pgRDOmb3gJQA+8RKEDI4habMjFBMhQOCXmFNi?=
 =?us-ascii?Q?bnhA6TzeybntS1Zqa54JmmQ8bKzZuIQTlJGz7Ll2tAsSd00TrSaJ3ZoPoiYp?=
 =?us-ascii?Q?/Wou2NOwppOVWsT/Ro9lcfQStXkQor7n3kFUFCQ5DXojLoH2L3M9VH7ouqh1?=
 =?us-ascii?Q?Vp2MxcUnEt4tvxAgfDPPAp9WhhL6JFfvZ5dXSDUNmpy0kZhZLcR52sULv3DP?=
 =?us-ascii?Q?N4eL77dT92SY+MxYePa4pew0rbmeiUlAxGUBpUKIIk5zlE3AecOUblrCm77Q?=
 =?us-ascii?Q?2Y/Y3TQujehO9ZEbHqxvV7EaLUyLkGKWawUiZcto79xtPTp87b1/oG+hXmRw?=
 =?us-ascii?Q?49LMWkkXv1akn1Pvw52ifDFA05M6DCkmrtu375SfgcMNrQtQyz9W1kVF4ARD?=
 =?us-ascii?Q?CYIoyuG974rza/W2fXAKNqeiWMLG8HcHmrrtZKAyYX6kpdCoHPhjUexAJC4B?=
 =?us-ascii?Q?Q0rzqZmLEsFvo9eOcY3sq3mtaiBQww8J/VvHxdW49NtaMjvwCJwIdWyCyo9q?=
 =?us-ascii?Q?vQs6?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d490e5ba-2403-4278-6c15-08d8bbd81926
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 17:40:08.3752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A0NHJBes/XFZp2mbneWwlZmalfT/duy7CPQBmT0sZB7Pfe6m4BbT+vqaFS0ugpq9KzsTq6dFM9hpCY41EJ2yRsi6IVONPjbnZvmThKojLn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0330
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

Fix incorrect user_ptr dereferencing when handling port param get/set:

    idx [0] stores the 'struct devlink' pointer;
    idx [1] stores the 'struct devlink_port' pointer;

Fixes: f4601dee25d5 ("devlink: Add port param get command")
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
1) Fixed plvision.com -> plvision.eu

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


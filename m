Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20677423E6A
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 15:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238601AbhJFNJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:09:09 -0400
Received: from mail-eopbgr10114.outbound.protection.outlook.com ([40.107.1.114]:24902
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230008AbhJFNJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 09:09:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7wM9nsKaXHNp7c7J9pDEoRqyMieSZ8v+O4BKHkva3C1XKlEhRXN0zr3CBf94xmyM0sjLrANE8yA0Si9IgUN18w6DgwuN3KU1e4uRxmAE/MKEG809jTFXtug16CW7moVjXHugduiaJZi4jlZI93nd/x6wr1VoHpVq4UuB93gvP9nxUR2nmRO70A8gFHVxhCGpUTaRqJEMVWZFBOBjIc4RlIOWDTFJmUaOHCW6slJFvzrPZMYYaE1d9O0+49RmSt0pOO/eAL2uh6UxIW5PMkhoIownICisKN9G/bAXzUfyG5Q9S/pSCaKV52XWo7IRZnB00BFwtBiBQJFNM5KdPa/Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZLFuA7B+Cy/bNnY4SuniBwXGOZvbjOS/wrgmae6mZU=;
 b=HJnrKRV3lUyedvldLrSo0Gq/tcO5zxPX4fLmRenFHmm0W+wydEI3FTBBr0NTlN4ruYhmf9TCGQvJJ7k7MLJ0RwMIqIzcyB71VJJjomRtWbzDYUHkNgbuKFbLLaHgFKb8Ay263LI4PYm92WVBr/RXHTH29oE8UYEGCxSqXUEI+QuFnqz1W1FKe+RlChdCXLtIYCyXsaLQSfqHzkaOlGeN4LrkXVL+JKXLDgO8W3i5y3J5AE3vmx2RhXBrtmTVH08X9c4qGcfTqs5OrhKs7fvAJLgVniMQbDbhPrmqzTWe8GNeho71OEtupKpF5e1CTNCxsE3RjnaG2zvZF9gaXV6OOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZLFuA7B+Cy/bNnY4SuniBwXGOZvbjOS/wrgmae6mZU=;
 b=qf3VA+8/3dZs2dVkkWQJlrzQJeNbRkp+CoxIRPPgvaVt4Yfno/Rhx2byvhmCtGDD3G+/d3pWO8Ig/ULfRto56TfXXzNGyWDfu8qKlOLnW3fWdV+fLwu0jvQHUbacaASYsHZTAdSB1FLI0i0trgUL/LFowRGo9wRwuCkJDCrjwdM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VE1P190MB0942.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:1ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 6 Oct
 2021 13:07:13 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::4c5:a11b:e5c6:2f36]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::4c5:a11b:e5c6:2f36%4]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 13:07:13 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <vmytnyk@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] flow_offload: add l4 port range match
Date:   Wed,  6 Oct 2021 16:06:54 +0300
Message-Id: <1633525615-6341-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HE1PR0902CA0015.eurprd09.prod.outlook.com
 (2603:10a6:3:e5::25) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by HE1PR0902CA0015.eurprd09.prod.outlook.com (2603:10a6:3:e5::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4566.21 via Frontend Transport; Wed, 6 Oct 2021 13:07:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a5fbb25-a04f-49ed-b906-08d988ca3692
X-MS-TrafficTypeDiagnostic: VE1P190MB0942:
X-Microsoft-Antispam-PRVS: <VE1P190MB09420C7DC25D9D65902373928FB09@VE1P190MB0942.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7qS3d3PePL4cGdjccnegGhvTiASLsMeq+vau3TrzHZ1m4PfW0vAq5+6EiPn6xx0fhrV63Zw/FcyDsyEZhZzSyoiivCw0Uw9AAuaDnnZMTXfRzpygM/Ba5k5tONv+9+qoNurZ+nqhdAmZdyfvBeKUOtO91VEWZvmNyJ3K/7Jig4X69vrZobU6icn0mGmPYimA8kF+DqizT+ri8ne0DJJFEW+oef4zMaJu2em8a3lvMNE4K4wU7tovHJVSuw3INJRcuYzNP9gCLuctm0QBSxXnl0UoRq4vjEgAeyb+3dtzQVuacWS2j+Gb4wEDv4pXPn7+WlPmXqU216fzfFlLOrn4Wertm3XpmHEun0P/Tdyuo6kKLtrURlxDEg32P9juD6IvIjXCPshcjuxa0qlD5kj5JDl5l88IqmeWso6XtRb94qSZrnA01I0mPApSsVgkjlF50IWNMc1F2WhjQx2I0grR9+QH2Wyvhj8wkMlZs1/rVcbxWpdGD1V1uoyuASc+sI27ie94+XW2J3JUdQtoS3NEFSkDPP2sqb/zyZxtD3AWzUyA6lHE6YQte4jkmP1XEnCeEYEoPkve5BhCZxg1XTN1eHcv5gFXKAm5pbtz0xgpHo9w1+PHyhUa8ozw3d6kX3wePUvd2RIdELOnfJc7mAIclNqJsh251RfbEBij2D2B/PTPkOQ5Yg71U6CG5iJkdSCnWyJ+Zi72DebBriMMljdIPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(366004)(376002)(396003)(346002)(136003)(44832011)(508600001)(316002)(2906002)(38100700002)(36756003)(6666004)(38350700002)(6512007)(26005)(6486002)(66556008)(66476007)(8676002)(66946007)(8936002)(4326008)(6506007)(6916009)(52116002)(186003)(86362001)(54906003)(5660300002)(956004)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Ot+7f6+k5jUXZtH90EGjZSg/wfcrE9YjtqehrrhsRbZgmL8kGJwkT5fJ7xW?=
 =?us-ascii?Q?tsWl+4aiHRMrgVckynh0ihg3F7MOETIxoPnHdWQx3NUDCBgqh7Qg4RNNtS1c?=
 =?us-ascii?Q?ZILhKYLeGQwHy2GiG2FCU9OXR+9asphptaPjZ34g7HT2ql1fS4YQFRSW1KSy?=
 =?us-ascii?Q?h/ETMMTcqxFtACbrj0sOS7lpGCaY2OrydZn1D9/1HgyG0jJpanb+oVm1NIgR?=
 =?us-ascii?Q?XuY1TDe8M0xY8rBBpMTiLL8Onwo9FB1fxl6mDVtQR6SuDLx1YfbtQxi6TdQr?=
 =?us-ascii?Q?BdRs98c7jOjgTco7yPUmRzlBKHViSuHjY+IiTBZ6ThtXzWmnRPObc7ybUXJ6?=
 =?us-ascii?Q?gST/tUBR2nN35UaMSF7rEyMcpEsgUYujMnbdEBlHMNwbysbp3MOmnLo+zUrb?=
 =?us-ascii?Q?GF47/3Hfi/EmVT0HzKOYz8n7hLa+ZIygWMEChLq8BQAS/klhytHk51EjLAry?=
 =?us-ascii?Q?ap7xtkixmcHD/GT5qjzGOijubmvTs3uhPFcsImMVwt1z9VWT/1gjgjRpUylx?=
 =?us-ascii?Q?F+91x4B33w1HEhxdJrVGkqhBZ8zI9/5sF4U+o5ZDMjXQZUb2wNybEOOHb0WZ?=
 =?us-ascii?Q?enG07I0xlJpNUDUS+0HFDXt0ukydypBz719RYmYUTi6hpnBV0/CGjO/qvaTQ?=
 =?us-ascii?Q?ZX/hRyLeRubyqnX1G1RwoNfFiIXHYpTE+BOo681BQNskRoatpUYPDpSUpLjv?=
 =?us-ascii?Q?xByO0VUJOmiQmSgqXsMLd3T5HomknzrtX2T9HWyJJCvDro3JzTxVHGJeMnq+?=
 =?us-ascii?Q?lL+Zjfi06g7JPQF7WXz9/55yPm+ul2E4ho686UtxcTzQh24vgewnL92DRedH?=
 =?us-ascii?Q?HVr7C+Fm7MjXYGSU1GqI0AiuDsPzQVVx2CbxNGZrNyNyEbifLBkGoeUVFpS8?=
 =?us-ascii?Q?rIGSw7L2kuaDZr/jCkT1npJjcmpEXu4GJKGtSZbc560DdH+sJNCfKTz3r64e?=
 =?us-ascii?Q?HKCE/ahrHEyQK0hqkZ8aZLD/1Ko9fafg9SzMSaj2d9UqtxHZ9qybLfYIM4ce?=
 =?us-ascii?Q?K2tLzBs6hp2git2fj+1CEpnUXoYeghNasky+1LPGHA7Rp+AtkkvyxKpV6bpC?=
 =?us-ascii?Q?qe9/sDbTeU7poEpQpebwnwqMlhgDLbFrypbRBGo4orzF8VaQRV2LkKm0X8Iz?=
 =?us-ascii?Q?ssQuvJ2gJf+x9pZgGkY+oRc6jeGJongEkdA51U/z7+diPaUEsq4bWJVhL0RW?=
 =?us-ascii?Q?3IUbEsG9dvmjIdQZrDiigdQJuAoj3ZrEN6JuK2N9Oa1UybjUFb8Dq4nmcpFb?=
 =?us-ascii?Q?kknIRZsBWxc6j4nnLZs65NnsWr62jhHufn5JBubbuG1K3Al7Ge+sxRkgrfdW?=
 =?us-ascii?Q?psZSbEC1VBi9u53hZJ4qcSN8?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a5fbb25-a04f-49ed-b906-08d988ca3692
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 13:07:13.1914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7X6glD1BcVtBltoHCEow+0F5tYJkrykR+xPGrdTyU1OpfN+v3z1LGeKUOfsQ5K0la7RsQneVhtIXstv2qiFr0Ed7cfpArVhaf9pWeyLPUr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1P190MB0942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

Current flow offload API doen't allow to offload l4 port range
match dissector (FLOW_DISSECTOR_KEY_PORTS_RANGE) in the driver,
as is no relevant data struct that will hold this information
and pass it to the driver.

Thus, to make offload of l4 port range possible by other drivers
add dedicated dissector port range struct to get min and max
value provided by user.

- add flow_dissector_key_ports_range to store
  l4 port range match.
- add flow_match_ports_range key/mask

tc cmd example:
    tc qd add dev PORT clsact
    tc filter add dev PORT protocol ip ingress \
        flower skip_sw ip_proto udp src_port 2-37 action drop

Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 include/net/flow_dissector.h | 10 ++++++++++
 include/net/flow_offload.h   |  6 ++++++
 net/core/flow_offload.c      |  7 +++++++
 3 files changed, 23 insertions(+)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index ffd386ea0dbb..8eada83a816e 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -177,6 +177,16 @@ struct flow_dissector_key_ports {
 };
 
 /**
+ * struct flow_dissector_key_ports_range:
+ *	@tp_min: min port number in range
+ *	@tp_max: max port number in range
+ */
+struct flow_dissector_key_ports_range {
+	struct flow_dissector_key_ports tp_min;
+	struct flow_dissector_key_ports tp_max;
+};
+
+/**
  * flow_dissector_key_icmp:
  *		type: ICMP type
  *		code: ICMP code
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index dc5c1e69cd9f..cb480afa674d 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -48,6 +48,10 @@ struct flow_match_ports {
 	struct flow_dissector_key_ports *key, *mask;
 };
 
+struct flow_match_ports_range {
+	struct flow_dissector_key_ports_range *key, *mask;
+};
+
 struct flow_match_icmp {
 	struct flow_dissector_key_icmp *key, *mask;
 };
@@ -94,6 +98,8 @@ void flow_rule_match_ip(const struct flow_rule *rule,
 			struct flow_match_ip *out);
 void flow_rule_match_ports(const struct flow_rule *rule,
 			   struct flow_match_ports *out);
+void flow_rule_match_ports_range(const struct flow_rule *rule,
+				 struct flow_match_ports_range *out);
 void flow_rule_match_tcp(const struct flow_rule *rule,
 			 struct flow_match_tcp *out);
 void flow_rule_match_icmp(const struct flow_rule *rule,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 715b67f6c62f..d218c1deb40b 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -104,6 +104,13 @@ void flow_rule_match_ports(const struct flow_rule *rule,
 }
 EXPORT_SYMBOL(flow_rule_match_ports);
 
+void flow_rule_match_ports_range(const struct flow_rule *rule,
+				 struct flow_match_ports_range *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_PORTS_RANGE, out);
+}
+EXPORT_SYMBOL(flow_rule_match_ports_range);
+
 void flow_rule_match_tcp(const struct flow_rule *rule,
 			 struct flow_match_tcp *out)
 {
-- 
2.7.4


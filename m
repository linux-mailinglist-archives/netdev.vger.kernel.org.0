Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268C62220E7
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgGPKse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 06:48:34 -0400
Received: from mail-db8eur05on2081.outbound.protection.outlook.com ([40.107.20.81]:6113
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727940AbgGPKsd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 06:48:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PoaAKhTOToZbHJLavwVjJQvRfy3SqE9HBTBOz8PzHeL4+VcqDQonocY0eyBREDvRW8rJjVRJDqmX/MJRqwnWRCeqX+JwYtgUnEAT6dG4KsdexunIeuqpqGh4uRlZAHo4WD5owGrtd+UbkhDUqwh+iyJHUA9ROjFc7l5L/Y+nBtEZpqiiA8vxlejlge6r6+a3RMuHJbvbbvktfSr8kQqNA8HBe5RLbmJakSxV7mhdo2825rb2jcr/dK+GyDNisb2wVcX04hyY+IRe2DYTuTeaV5dB9xukBwsSV5ODK1APQchBqEXhPBq37yyF7XZ+/+jJrAup1bXTipWjAWijFsAYtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5AVaPYZQix8buqzjKHVhrZMLtnw8psXz7HPinnZZMY=;
 b=Ggfhk7+WwHJos3I0FV/xkpskhv7wKowIBouiR7iNvkcsnt66EhwbXW6k+ox2Xchl+GThsaTnjiEkBuR4Gsjf3dcK+me0wzcffvoMtv0/7YnncA1Io2Aen5A80n7Dfax6XYz+L8DB0H5ZY09Ltv5Y8KowxlRuXBF3OFcNrjH0TKCNbJFLNiRwfRMcuwptC3kmlKYVxIbaGgbqqIzk1nf3D5yYxB5EEuGzglEQmrqNE4UZmo1ApJtBds2okfUhCbf1pQTk8Qbmy0UMqzxDM4jPBNQ+CVXL//WOZGnMfdM/Klo4tXlfGah+izOJtGHG0qbewhEsVZvVw7V6+h/5OaqFYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5AVaPYZQix8buqzjKHVhrZMLtnw8psXz7HPinnZZMY=;
 b=kUa+Oxghjptbq97bG6JtXfOidCC5EAr6uZ409S/hK7GU8QygdtyOckTYBR6gbROqf4gXRqmKeJESEnK4z+hkHQLm3KLtOspz+q/WsIsni9nR7tH4CS0+IQrYArutQbb8X9waeGf4540PBKiM4EbTEmlxozROfEs+sMpH672Ua38=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB2940.eurprd05.prod.outlook.com (2603:10a6:3:e0::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.22; Thu, 16 Jul 2020 10:48:26 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 10:48:26 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next 2/2] tc: q_red: Implement has_block for RED
Date:   Thu, 16 Jul 2020 13:48:00 +0300
Message-Id: <fec7e409f07da9e90423135ed6679d2481235d59.1594896187.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594896187.git.petrm@mellanox.com>
References: <cover.1594896187.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0046.eurprd03.prod.outlook.com (2603:10a6:208::23)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR03CA0046.eurprd03.prod.outlook.com (2603:10a6:208::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Thu, 16 Jul 2020 10:48:25 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2f19ae18-86a5-4ef4-6c64-08d82975c49a
X-MS-TrafficTypeDiagnostic: HE1PR0502MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB294043AE3CEC93BF2AD7F1F4DB7F0@HE1PR0502MB2940.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QEamh4VJbKsk2gHqME/XNbKecreZ4soFEaQEuxhhiYzMS1S0HQJ2qZCuTJniMUtJYo8p8RtJ/My/eyTvAavGxo/0O4QRkgBAcdD6M2WUQvAh84Nk2Ck0dKG74WF62uNLLfP+CxR8eut621jYnS6GoiZij/dyvza7JHHjD1K0VqHKNieNiO+llRk84LB9JW+qjB85duyLsmAZhdpgnJwZclnwsJx6+fLTX6MfPYPDhrn/mhFlcnpL0tR2NlauDY+BOjd2FAwYG8v8cMkUuEeFzoJQPXhDUFUB/QcL/Brr4dkFKbB2Ei1Wn9YTJxQ7EW7ITbqmqlpKrNKDmpozL5iRYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(4744005)(83380400001)(6916009)(4326008)(5660300002)(8936002)(478600001)(66556008)(6486002)(16526019)(52116002)(6666004)(36756003)(66946007)(86362001)(8676002)(6506007)(107886003)(186003)(2616005)(66476007)(26005)(2906002)(6512007)(54906003)(956004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: k6MSUkui5net9ZtaNpnNQLAVH8KxgSbyt7V01hF9mqC0mPTsnr434AUU2jklDIpo+gxLXFAxcFEQbePpFzT6ZL2JzCiYTx7m07CtpHmkaBHUEEi5lRSPrYqTlYoMHeCVSvmr2GaYguxqMXrOwB1qjsyKSzTir/THzprzDYjsNXBRVOgDJ+ebjOm+sRw0D6J3F5IeYHfAXZ6Il4Td8JByUxveYncgct5SpSMG3XLVr7NBQ78bIOL9ahbIEOhUPzPX+Q8D7+gxz/PebdeuYEgSgExXWxY1gFF6PsKXyl/jxB4+ADU+IXjCtPGDg0tAsoQnIFcaysTw7sUW2D1lkg2noCYr6QnpweSwkzwpeb9deo7f00hI/RdrUvNnV8mEB7mnsZQaYrh31bVBoy7faTOdi7WF+lA+dHJRWrRlXdY69OGGj1lLVHfS6FPduHDui65KDhpXjpgr58Q/ybadqNMY0O4s7ziJDalzb5Pw6fGoZHzQpoCc0kBawnYvktPnPdwF
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f19ae18-86a5-4ef4-6c64-08d82975c49a
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 10:48:26.2780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tOApMwC2vAVCsmw3eUp75KjLuIBwtH7O50yjbQOH83lcxTfCZ6UVFA1PaD/ymPfNbP9fJVoXzM8OF/1rJjT3nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB2940
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for "tc filter show block X" to find a given block, implement the
has_block callback.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 tc/q_red.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tc/q_red.c b/tc/q_red.c
index 97856f03..dfef1bf8 100644
--- a/tc/q_red.c
+++ b/tc/q_red.c
@@ -264,10 +264,27 @@ static int red_print_xstats(struct qdisc_util *qu, FILE *f, struct rtattr *xstat
 	return 0;
 }
 
+static int red_has_block(struct qdisc_util *qu, struct rtattr *opt, __u32 block_idx, bool *p_has)
+{
+	struct rtattr *tb[TCA_RED_MAX + 1];
+
+	if (opt == NULL)
+		return 0;
+
+	parse_rtattr_nested(tb, TCA_RED_MAX, opt);
+
+	qevents_init(qevents);
+	if (qevents_read(qevents, tb))
+		return -1;
+
+	*p_has = qevents_have_block(qevents, block_idx);
+	return 0;
+}
 
 struct qdisc_util red_qdisc_util = {
 	.id		= "red",
 	.parse_qopt	= red_parse_opt,
 	.print_qopt	= red_print_opt,
 	.print_xstats	= red_print_xstats,
+	.has_block	= red_has_block,
 };
-- 
2.20.1


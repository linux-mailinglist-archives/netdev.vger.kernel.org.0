Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178ED2227CE
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgGPPuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:50:22 -0400
Received: from mail-eopbgr30043.outbound.protection.outlook.com ([40.107.3.43]:21828
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728126AbgGPPuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 11:50:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZvAL18YNFvD3qIKTHog7vhXwpfVX/pB8Y4U23NMJH/JV7gp1hpGZZepYauA4X+9fr3O4f2MA2J92T4xlen8g/gxThv+dMmsI2WTZ6KTmAyLKcZjn8v79PRfaoSu46f5KeTUeZHznL7o/TKrgYfQh2wn3sjstNmaWjSKudY0HHF6FG6Cdq2g70gvnL/OY9Ddu/PlzUwdhACum2OmM3R2hUFLmvGO/ceg9euhdZMfbJD/PGT9uhBm91HxqAlgtV5kixPhiRIxcc0UWOVCfr0NeCRPxteW/FrV4cADruUP4zSZ/nUGGj3kdAYLiB/WuGekOPKPEGWqoiGl3X/GHlTNUzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5AVaPYZQix8buqzjKHVhrZMLtnw8psXz7HPinnZZMY=;
 b=d0oUGt+p7HliSlHMsL/cc4Fr1yMWpPh1oj1C7WyIwl+/lFqsARJb6eUPitlXe50vLzR2gUV5hwHnq/2GgMzwLoJSJGuHqjcdC3m0+wRGtfbdZy74QzcpcFcQvUJPXLKL7lbZyfgIg/0bo3mV+QuGogWQxcCWDeUH0PqRm1b3Tqh1YHIavC2P0wmq/VEkv6D0P915Q/MYuvAHjkjGShOwBHXMlWwQHJYnEmmEX19uDftSpsWl/4zq4W5E0vpc/Y4B7xzgMsTaBaMgzwT8DRqVTs3ydZzHccSkO0c6ctqxUYhG7P5LwcsBN15AAGywKMq3hPsZ0PhJHGAWswh01zBj6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5AVaPYZQix8buqzjKHVhrZMLtnw8psXz7HPinnZZMY=;
 b=n0+WqdhnYQj2OFvWxjXMitFmWKP7QsmFTTrR0g2wnE9KyaNNI7MjLLHlyQNbZsUnRDsnbeef/vkjgys5+OQgMyAsOLJtd0qaNcdtwC442E8FaL02raV59xnLbnnxn+vblke7TdOjWCCEPpLVTtpx+vnJtRIsTYWybG2/z+b6KZs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Thu, 16 Jul 2020 15:50:02 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 15:50:02 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v2 2/2] tc: q_red: Implement has_block for RED
Date:   Thu, 16 Jul 2020 18:49:46 +0300
Message-Id: <18f80c432a0d278d32711bdafdd9d2376028ad50.1594914405.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594914405.git.petrm@mellanox.com>
References: <cover.1594914405.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0060.eurprd05.prod.outlook.com
 (2603:10a6:200:68::28) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4PR0501CA0060.eurprd05.prod.outlook.com (2603:10a6:200:68::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Thu, 16 Jul 2020 15:50:01 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bc515b5d-2d38-4e84-9858-08d8299fe6c5
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB33541287A07426154D6F8A46DB7F0@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: edwYqBaZa4rI1UzF5PtoC3ZanOFmZOt7R5CgisV0EEO71cgsBmCrdiPQdqrSA2yu9oyqwAjWjupk30VvWD/O+0Q/Twt/4pVnH5bgcyGCQmD0RiUkYH9lys97XywEyHJMw7p1HAgXd0B+qTmhKZn6ERYPfAWW1Wsi7CqWzsuSKMg1VqcWHgSuCXpY7jwwKscRfQTij0sTqtvTqiopVxaoIKW6K4/CNsgGZ8cWYZu0SJ/nmTUth/sIgRtfQn5s0lwPueRHcZlY09K0lrc0iGBj1hUb1UKiGQg+54ihY5UJtkoPXGqjkb7CIo50dROZ/re0RtlPTh6CzmZZmdrczqyfbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(6916009)(478600001)(107886003)(54906003)(26005)(66946007)(4744005)(16526019)(956004)(66476007)(2906002)(2616005)(66556008)(186003)(316002)(6486002)(8676002)(86362001)(6512007)(36756003)(6506007)(5660300002)(6666004)(8936002)(52116002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BIr+qfN/mcsh8GU8pI9l7Ao+cAwYgGQlnHWztw1GhjQ26nBItvxwQto6EWu4kZ58+0acRL6XLUHX7OMo/Mzum/kUcnzs9chNmTNR0tFKM1e44QdDyLmafJ+SL5P60ovBvts7DPZhYWm6tmyCRzRGsks5KPtbduTLIarMzuY+VJGLMxfuTz6sX8n+G22E9qMwnkK2Y7t19esAsr5QbpH6s55QWl6HEsH9J/CxWjcKA23xXkMhZR0jDKR5amFEzga2CNX/7S1+N3mmB4hVaYoP6FectjD2V5jl9U7VLOdX8dmyc7lFPJXtaZFCFzVfxmXSzdWyS/9N3SQ7+8W1xqO/xgnc8kvISoflT6hefhLDowoGL58ty09lFj3pwz5DzKw4HRRIWNEKWrNHItsxFHjZJDyxsTW1QRjFb6S4WpfY+jIsYS6/0IUdbNwitc75CtArqBLHXOqkk2bY4kJUYUlkPQ1ZCIbpid4z+YYWMm16f4TNdT1N2MF8gdublCORd8Tw
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc515b5d-2d38-4e84-9858-08d8299fe6c5
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 15:50:02.3811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NoFLiLb2VnRJRbpvDxe/SE3WFseCbreoruXANOo42BPCJUCIljxOc+mtp6Scm4iuYuzOrHOhOk32uQv+uK82cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
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


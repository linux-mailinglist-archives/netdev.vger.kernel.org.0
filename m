Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1EF222881
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgGPQre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:47:34 -0400
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:10414
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728257AbgGPQrb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 12:47:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4BcQ52UlX8Q6+fikLrLQKobwu25gxSM4jW8HlF/y9dCqSKUYhISI3t2F135njz2T7HERsgRoPgx1SueNTXstdyUnVxFTAgbaThI8lSH2wLedKSIlBqR7r3PAREeJmo+nGroQx696Qa7odHv8bNO+pjaS5MJDdWELdl3I/a8EpKV29JaGqk2HUQuucGMe9k5/6C0W4YAK9NeOeLAzwsfnoadR8OBdr4RsH5LO+esYwHC9OPssFB+x6EoTJvM3Ae9I34l2hEaMchqpxsRQe6TqhhX/YWcRNkJHxt2FSr69DNlitQ2ZGfpjS3Q6Y+mIG7fc7SQvjhGu7b6In6QV+QMRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nk7Mebi6pfIGcsZ5QLkVtXXaVWOjTJ+c3peFh1u/1PA=;
 b=K7OM/wblagfUfSEOQKfjUVpOkDTTQfx4Q4DmMo2znvwrAP3gOFZkvVfHAEvhkcyYYhiv3MB5733bHh28O4g5p3aHetKlQGPhIN9b3DBkOdEk5rW6qwxurffqeCxjAFQwyljibRxfnJOrcy5RMyeETALwNzONBGoKDbpyj7+2Xg0YhMTPgjBiFZxRIoxWWhJm1hAZYQK42sAewKxlk3sXrpQW7R2Rfs/oEWhtVgHIknxjmmChACZUbjTWzhaFLVSyqoQG4qqdIAsbzDOTdAzxYiH4swKYT7qnAKlgef9MLEdH6mDKFfKaJEFerHpIGSSOxdlNhl5bkjvBNVgVFTU4yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nk7Mebi6pfIGcsZ5QLkVtXXaVWOjTJ+c3peFh1u/1PA=;
 b=FegbqnxFiljKqVw3GOCGT4uXh+wv1CriYTuiAB5TxY6tajRingv+W8mkqFEMjgiAv2A804fWPYOIXp0NsltTQMWtHseZp7t7ZCye4bPNjALByyhceZ4EdEh7RrPTMat59vrvViO9GkOfgYImu1PKgACqgKVpqGt7uy6ayfukVdY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB3834.eurprd05.prod.outlook.com (2603:10a6:7:83::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.24; Thu, 16 Jul 2020 16:47:24 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 16:47:24 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v3 2/2] tc: q_red: Implement has_block for RED
Date:   Thu, 16 Jul 2020 19:47:08 +0300
Message-Id: <90d89616b567192d0a38372340e3e2dc1a673fb9.1594917961.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594917961.git.petrm@mellanox.com>
References: <cover.1594917961.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0002.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::15) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR02CA0002.eurprd02.prod.outlook.com (2603:10a6:208:3e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Thu, 16 Jul 2020 16:47:23 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 06309212-fbca-4321-e0f0-08d829a7ea43
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3834:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB3834F352534E309D5A87D3DADB7F0@HE1PR0502MB3834.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W1qWqHaY4po8K+XtwbM6FSbk1OkfVZkJ4xF/xysGWe6DW6oKtTrbLn4PBYdaYkYRSt7IJGb77WBU724WQjoVIa5k+NWVBJPhYEHvwc5WEV2E0ogIDqRxykH12dNh26mbfk2zG2dl1M5h/gvRAp3IaPMqiVQaamppqOSOgCJe3f0m8OIFEl9W4MHY6bxTDjJ9tAmk6yEDRDJqG5d5IHZ2MRnEND36sP7YuOgmz86ESdp56kzk8X9qXwd3Jqz46yf9ngxRqGZc/1UZFljdKQPUQqUpUGxXxqucsXeGGh1TFtBoIYxOZ+2nnxA6pFgY4yDsZ0TFIqvd1RxfrlywPNLBWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(16526019)(83380400001)(86362001)(2906002)(8676002)(8936002)(478600001)(6512007)(107886003)(6486002)(66556008)(54906003)(66946007)(6506007)(26005)(186003)(52116002)(6916009)(316002)(36756003)(5660300002)(66476007)(2616005)(4326008)(6666004)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3tB1Xcs9HgVOi1O0oIiL2Cj/r2VZHvDCuen1io8b4DYir27aRzD4qhRdqc+vY5dKir3zuAnNkx7mJaN6IPxqySFNcgdhC+/a0NhK/yuzBt12YiCrOmLMYHLp+weJsNY9/xThyXGwR4roAttOwwdYV7xbv0r2xGHIgp931lxWu9b7cuZzpI34DVlqZcjL0ZtloROZsYvqqjk4bRmJR7OwnUFxxITBVHYTlfiPN01v86T9AXuaiqepIahuGnaozTuca3WLnalSUXm1Zy/2NoL6eQxPZVKTCR65Wv3v5ZgbwJgXtZeAp7fBZVylkBsILVmt+ex+xmlSk0MzNRr17MlOqvUIrn4CcATdpzi73Poxom150dRG7og2kn9zOugVbMQ55MTtaBegL/993qbi5dK32x+jo1NKu+xnUc5MtzkAJKGdTTCMXi5UdmTnubiB6183d2PG9LP55v+OckP4zZj6ct6SD677KyJPg4y6Hlblw93U55x4soVbpqHis2ivB3U5
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06309212-fbca-4321-e0f0-08d829a7ea43
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 16:47:24.2008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: atlYBhGd0DqjuYXFToCCzAk8xw8nwDhXy4cSAC654F3IvxRazRNIFyFShbemZcXZSTlqPaLilcw8VrnyXdgRag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3834
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for "tc filter show block X" to find a given block, implement the
has_block callback.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF2F1E2802
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388412AbgEZRKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:10:54 -0400
Received: from mail-eopbgr40061.outbound.protection.outlook.com ([40.107.4.61]:58964
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388093AbgEZRKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:10:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJ40xOJi5ln8b7gzBEhA6qF0JUPG528dZTQx3yTUKPwI23EpEeGQacCtxNiqvmYkE5NwAQdJ3dh7AxUKTiQNN4HFhkmK6qyObmGNfXCmkSU2VUbpApltHkSkyDjEIoTTxaZEtW19wXBmrYkRun0GoCDnG1luhG57NV4etYmxpeDEqsgd8YNqOTTkiQu6UH9hQXht1FMmook9vGXJaK+jNLIYhYmjoWGnFKeJtloTdP+PMXovanw0qK/lkqcrG4K8e/vTMmJUBxV4LLClxa1cBATrI1CAxRVWyLLFfYskfnDrMqT7C9NH5xlvuxWjaivfpWDkF7dM6RugBIVWW0Od6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mT5VjUkgPTMUMRh4hwXkiT5n4MohfHn3OeEeq2Tw24M=;
 b=iWKh8gB0HLp8+QOozd3at/mFeedXyTrp4SchTzh0mSSgyo8OPDrbIgPqDnxDnjBx36erf35LU8XqAO0Eo94oZFNNjTKImZuFIg+opqBIHk18n0rsHmSB/VsMYyd2nLGf1/iJi0kiNCQ31q6nKrPWReVKB3vKboPLYEVhMu3v/dwiWpDeEwG28T3e4HGMNQHWjCilDT+/tdFJb/odHtdjzqXoSbscsAV7jKj7X+orI+Qv5GMpimi/HQgp6U232ben/lIsLoFPLWJs5qd1NgjqODDT/D7zdAVxXuJmVi2u+LSsQnOM2GLiny3iXRGR4m3SgYqO/TokTi2lXpOjKvWjKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mT5VjUkgPTMUMRh4hwXkiT5n4MohfHn3OeEeq2Tw24M=;
 b=WcmzP5arPgbludyqZnrv7KHDUfdpP/TzYUnVIbxa1lKqIZ+P0NBk9CbZD848kZiTb4p244Op44GGVehUOHWUO8Uam+u3xrw9t7WrCxvoBKvVF1KinEyPvmHKl3QRxCU++2mBzp60fZjfaGuqqh3/cMIqQi0+6LejRB96m+MPnHM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3225.eurprd05.prod.outlook.com (2603:10a6:7:37::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Tue, 26 May 2020 17:10:41 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:10:41 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        jiri@mellanox.com, idosch@mellanox.com,
        Petr Machata <petrm@mellanox.com>
Subject: [RFC PATCH iproute2-next 4/4] tc: q_red: Add support for qevents "mark" and "early"
Date:   Tue, 26 May 2020 20:10:11 +0300
Message-Id: <0c9025dd6e2ba2f26468fee1efa666a45b2fe02f.1590512905.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <b4fb87c7d38ab9b8ed4d67bec0a22dd602a11fbf.1590512905.git.petrm@mellanox.com>
References: <b4fb87c7d38ab9b8ed4d67bec0a22dd602a11fbf.1590512905.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0034.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::47) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR02CA0034.eurprd02.prod.outlook.com (2603:10a6:208:3e::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27 via Frontend Transport; Tue, 26 May 2020 17:10:40 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cb465673-2872-4734-9f14-08d80197b7e5
X-MS-TrafficTypeDiagnostic: HE1PR05MB3225:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB322545CCAEFB3E65514770CCDBB00@HE1PR05MB3225.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cym4mFu8JB3H/Lkvuj/jrCMVi2gTobQOR/o7EB0qnLARdQuoKO3jygVWqKcW5Mv3AbWea+1TpNxZFUrPo55B4j9fBOSKFnh8YS0xEPBM/RwXalO+UZv4q+72ApQ8UStyKcoQaft+gOo8YZ5w2U6ICSGFrWgl3s7Ik1lSiM47qOFxCrC8OyuAhg6RqZLo2xGo7ChSX/2AS1Tew8wLkVvNzAr4ZO1NGAThsNde92698KPRVCF7eFdESn9Pr/xkdAJuN72v9obFaiipXAxAmBypdrcyz/LNPgBnUCEe5GIzrMjbfqi6fDHUYFDHTBIUwbiUhI5l8Q8zVJB8B+DyWDu9CA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(956004)(6486002)(2616005)(26005)(186003)(52116002)(6506007)(86362001)(2906002)(8676002)(8936002)(16526019)(5660300002)(6666004)(36756003)(6512007)(54906003)(6916009)(66556008)(107886003)(4326008)(478600001)(66946007)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Otto/2HwD10NMt7p0u1sUkwkBRqtBc3MO06yy8XI/L+ZZcdDW+Z+xMC30XdiQz0Q2y8yQUZLEC+8n48p9VIzLMB+TCGKuhOyIb3Rq9tlrw9vKrAWiZGe3xrj7g75TCxFoyRQeWiNqop0dzpKtaygRm4JVpUe2nAY2fbUkPYnhDdAvJpjlZIYA99EUT+jUSDA0Rbo6rhhAxCMbsrW/hfy88/DPK8VkpGMVXDWH7DcqGHpTWoSAJmntsZJqzFOEKnRyn76nqBxLDjv8V+I9GyHRwRSaDjHHCMRKV9iPBTwp8dfCnXfsYZhIyXCoVjezGynYUj/K/z8JE4jM3DFL2ZSDbloVOLVgW59gjqzwlfYIYWTtPOGTo3vpQRK5K/UEss1ph/YEdlhEu645vktz1dD/73ugi7gK8B5dSs696cWTbPfpuacCmynzlM4c2K+PNb7enS7XAFv2dYmIdfn/zxvhQI9vNXc45MNozaxGV3y57s8uZlOyl4xxFLPtIdrH3WL
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb465673-2872-4734-9f14-08d80197b7e5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:10:41.2442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P6eimp5IE0Jqa58sudr1NvaY1vUPiWvjguwL2Xy8mAKZqvMH8WdZJ4297RuxhRAZEnQz60bk1Yo50qeYd7s9Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "early" qevent matches packets that have been early-dropped. The
"mark" qevent matches packets that have been ECN-marked.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 man/man8/tc-red.8 | 18 +++++++++++++++++-
 tc/q_red.c        | 23 ++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/man/man8/tc-red.8 b/man/man8/tc-red.8
index b5aaa986..e74dd330 100644
--- a/man/man8/tc-red.8
+++ b/man/man8/tc-red.8
@@ -17,7 +17,11 @@ packets
 rate
 .B ] [ probability
 chance
-.B ] [ adaptive ]
+.B ] [ adaptive ] [ qevent early block
+index
+.B ] [ qevent mark block
+index
+.B ]
 
 .SH DESCRIPTION
 Random Early Detection is a classless qdisc which manages its queue size
@@ -134,6 +138,18 @@ Goal of Adaptive RED is to make 'probability' dynamic value between 1% and 50% t
 .B (max - min) / 2
 .fi
 
+.SH QEVENTS
+See tc (8) for some general notes about qevents. The RED qdisc supports the
+following qevents:
+
+.TP
+early
+The associated block is executed when packets are early-dropped. This includes
+non-ECT packets in ECN mode.
+.TP
+mark
+The associated block is executed when packets are marked in ECN mode.
+
 .SH EXAMPLE
 
 .P
diff --git a/tc/q_red.c b/tc/q_red.c
index 53181c82..7e7dfa05 100644
--- a/tc/q_red.c
+++ b/tc/q_red.c
@@ -22,6 +22,7 @@
 
 #include "utils.h"
 #include "tc_util.h"
+#include "tc_qevent.h"
 
 #include "tc_red.h"
 
@@ -30,7 +31,8 @@ static void explain(void)
 	fprintf(stderr,
 		"Usage: ... red	limit BYTES [min BYTES] [max BYTES] avpkt BYTES [burst PACKETS]\n"
 		"		[adaptive] [probability PROBABILITY] [bandwidth KBPS]\n"
-		"		[ecn] [harddrop] [nodrop]\n");
+		"		[ecn] [harddrop] [nodrop]\n"
+		"		[qevent early block IDX] [qevent mark block IDX]\n");
 }
 
 #define RED_SUPPORTED_FLAGS (TC_RED_HISTORIC_FLAGS | TC_RED_NODROP)
@@ -38,6 +40,14 @@ static void explain(void)
 static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 			 struct nlmsghdr *n, const char *dev)
 {
+	struct qevent_plain qe_early = {};
+	struct qevent_plain qe_mark = {};
+	struct qevent_util qevents[] = {
+		QEVENT("early", plain, &qe_early),
+		QEVENT("mark", plain, &qe_mark),
+		{},
+	};
+
 	struct nla_bitfield32 flags_bf = {
 		.selector = RED_SUPPORTED_FLAGS,
 	};
@@ -109,6 +119,11 @@ static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 			flags_bf.value |= TC_RED_ADAPTATIVE;
 		} else if (strcmp(*argv, "adaptive") == 0) {
 			flags_bf.value |= TC_RED_ADAPTATIVE;
+		} else if (matches(*argv, "qevent") == 0) {
+			NEXT_ARG();
+			if (qevent_parse(qevents, &argc, &argv))
+				return -1;
+			continue;
 		} else if (strcmp(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -162,6 +177,12 @@ static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	max_P = probability * pow(2, 32);
 	addattr_l(n, 1024, TCA_RED_MAX_P, &max_P, sizeof(max_P));
 	addattr_l(n, 1024, TCA_RED_FLAGS, &flags_bf, sizeof(flags_bf));
+	if (qe_early.base.block_idx)
+		addattr32(n, 1024, TCA_RED_EARLY_BLOCK,
+			  qe_early.base.block_idx);
+	if (qe_mark.base.block_idx)
+		addattr32(n, 1024, TCA_RED_MARK_BLOCK,
+			  qe_mark.base.block_idx);
 	addattr_nest_end(n, tail);
 	return 0;
 }
-- 
2.20.1


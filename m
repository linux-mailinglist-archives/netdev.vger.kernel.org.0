Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C79F20F268
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732315AbgF3KPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:15:31 -0400
Received: from mail-eopbgr40051.outbound.protection.outlook.com ([40.107.4.51]:13646
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731155AbgF3KPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 06:15:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLtMHIh8TezDvLye0oPk+0RfsqkG+NNAe6DsQxNCaqPFStJfyGOjdhjAKIGkutSW12orMU3tiR1Hsj5IYkQJIQGsPm2a9F97MbwBqIONaGd4wshw6VSXkKYmLnLW8KNmLIstHe/Ekh21XWqgSUj0PfWv1p9BC9puvtzFerBezRby8FpznfRfFGWvFxZp3GM3XTbdDSYLGHHvxeZYYr2je1LVTZ3+1NTHdZyk0tfjQU+Pr4FAf+E/EXd/slAsJhLrmbGFI3JPT6/CGT74t83LDZJmA6H28KBeZeTUt6cCS/k19eNfjhAE5MmrEJ9C4RH09C0/UgCP+BAra3Dn6N48kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndyWQNZcVFEwJnhZBLwApPvfSG8J7sth2i0NHwevsKk=;
 b=QcANn3yXdmL0pWcEb+UwRPG+ylFnbXLmkGFXEcn8H7RxWyqO7kdLDdQScIKtgkgReT4qcrMm0tkELDYLnKt4cMhaetaJRNuFlpgvcDZVpAfLE4teOc8Q/sPKXlUBi7k1AuAhRfWmO9uLszQqeh8UWSuq+Ea3oY19x7GYLD2Qpeaj1P/lwlvihlwGdFOK42ynWRBYBgcct+RwmTVDlsfrqQrUhWGP+CwwL5/IbFXewswWcCHHlvEMOGfIjkj2kJ25RlTnzJwnv+4k099xbKTiDMSG0PZEY1+qjVQoKzt0GeDADruwxYIxJjhedqyqHUSMvIIJi9uAHvudDT0ovi0lCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndyWQNZcVFEwJnhZBLwApPvfSG8J7sth2i0NHwevsKk=;
 b=ZUacuEujLWQdY7qnPIOUsNNGTc9NmrlsFPOXzowCLOFpuV8VzcMmtFuWVEM6J/+jmux/oodXkWmhpa2CO4B2i59O44rxYVzXe3lenZ4i5NhQzf+8bV6qVkp4m8nsKEeKMWtkao4kE4n7qtOUAwWLsBeLrwWm7ZPZBTJHgZThOKM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4745.eurprd05.prod.outlook.com (2603:10a6:7:9a::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.25; Tue, 30 Jun 2020 10:15:21 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.028; Tue, 30 Jun 2020
 10:15:21 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v2 4/4] tc: q_red: Add support for qevents "mark" and "early_drop"
Date:   Tue, 30 Jun 2020 13:14:52 +0300
Message-Id: <d59e81ab4b09eaaf193cb8a610712b3a120eddd5.1593509090.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1593509090.git.petrm@mellanox.com>
References: <cover.1593509090.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:208:be::49) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR04CA0108.eurprd04.prod.outlook.com (2603:10a6:208:be::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 10:15:20 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3f0ef911-d27c-4ace-04cd-08d81cde7f05
X-MS-TrafficTypeDiagnostic: HE1PR05MB4745:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4745383F6DAA3A3521BC7CCBDB6F0@HE1PR05MB4745.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:210;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 12cR/GU5mkZz9qmdvLBi6RjaLVxsKuC4mjDyYKW+c0xTSt27odn9C/8WgSRzKKyu2FRmBoDssHf0w612moE6lXLGmOWXTHwnE/wenhEyH9xSa65kM9bH2J97WOaiAqv43ztK8n2NwPbN/aGEvZ4bxyn21qzSggavqFMg2ASLuc4UpVCOXRhZ/8A4EE1cciJj2Y887wqpj1MehoYXVS5XTxxrws2lLERUmyqFS8+jBpv2XpXh+2KxanN9qxyh+HJBoqPuGiVncEROqCd2TIH0CqG6e9og5ApIC+bcRgKFo6o314WddUTR41sgYIuaYsWI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(478600001)(107886003)(4326008)(6486002)(2906002)(8936002)(6512007)(5660300002)(66556008)(66476007)(16526019)(6506007)(52116002)(83380400001)(316002)(54906003)(8676002)(956004)(2616005)(36756003)(6666004)(86362001)(66946007)(6916009)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FL9my166B4SBF9K+3qTaYpncoIHc/NdFQMIlKHWN3v8+1xiexjdoSUY3KY0PpA5wIWCH4+RUGuWWt6WnxBer2bT2+3R7uSLiln+tVP0veQmZ1hzcHhG2ssk6oRfo9ncAKu/mnsjFrQoQhlVtWgjk2lbRhfJw2KbQOqvjl2yKCACR0KgLUfXPCcTwsdwr7TVH8GOqg6fsN19cIsJLQ9ToZ8eKdP74GMIniJjOiDENNulnxIC4lcII5fL4K55XOU5yM/5z2ph8/f5Ve6ROjVxisZdqt+UPeZyAPCJzgbCidxWZq8JeI9AQ+PHzQucb5CB+gk+wLWUPwplbmz1ZlrmyFjP0Jr3KbQwT68ixo70k8edCe8+F8RxQRUsA5rqL9QiBXA7xwOqm82meo+NbhTtO4zmMvXa/O34bNdoJ24k7qhMf/c+QElX8MlVKa/xVHljicGCm5iz3Opub87QGK/nOBscpIq5kZsJoi64u3+CSyQs=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f0ef911-d27c-4ace-04cd-08d81cde7f05
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 10:15:21.5026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EZhgfwMbdZPaI+1I8Q5ltbnsfTwqIQW59OMewHTt9vXfwpTx85AVn/inCOYQSx0Xlat1jvl0g9UHOZvHMqblTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4745
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "early_drop" qevent matches packets that have been early-dropped. The
"mark" qevent matches packets that have been ECN-marked.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 man/man8/tc-red.8 | 18 +++++++++++++++++-
 tc/q_red.c        | 30 +++++++++++++++++++++++++++---
 2 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/man/man8/tc-red.8 b/man/man8/tc-red.8
index b5aaa986..662e4d8b 100644
--- a/man/man8/tc-red.8
+++ b/man/man8/tc-red.8
@@ -17,7 +17,11 @@ packets
 rate
 .B ] [ probability
 chance
-.B ] [ adaptive ]
+.B ] [ adaptive ] [ qevent early_drop block
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
+early_drop
+The associated block is executed when packets are early-dropped. This includes
+non-ECT packets in ECN mode.
+.TP
+mark
+The associated block is executed when packets are marked in ECN mode.
+
 .SH EXAMPLE
 
 .P
diff --git a/tc/q_red.c b/tc/q_red.c
index 53181c82..97856f03 100644
--- a/tc/q_red.c
+++ b/tc/q_red.c
@@ -22,6 +22,7 @@
 
 #include "utils.h"
 #include "tc_util.h"
+#include "tc_qevent.h"
 
 #include "tc_red.h"
 
@@ -30,11 +31,20 @@ static void explain(void)
 	fprintf(stderr,
 		"Usage: ... red	limit BYTES [min BYTES] [max BYTES] avpkt BYTES [burst PACKETS]\n"
 		"		[adaptive] [probability PROBABILITY] [bandwidth KBPS]\n"
-		"		[ecn] [harddrop] [nodrop]\n");
+		"		[ecn] [harddrop] [nodrop]\n"
+		"		[qevent early_drop block IDX] [qevent mark block IDX]\n");
 }
 
 #define RED_SUPPORTED_FLAGS (TC_RED_HISTORIC_FLAGS | TC_RED_NODROP)
 
+static struct qevent_plain qe_early_drop = {};
+static struct qevent_plain qe_mark = {};
+static struct qevent_util qevents[] = {
+	QEVENT("early_drop", plain, &qe_early_drop, TCA_RED_EARLY_DROP_BLOCK),
+	QEVENT("mark", plain, &qe_mark, TCA_RED_MARK_BLOCK),
+	{},
+};
+
 static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 			 struct nlmsghdr *n, const char *dev)
 {
@@ -51,6 +61,8 @@ static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	__u32 max_P;
 	struct rtattr *tail;
 
+	qevents_init(qevents);
+
 	while (argc > 0) {
 		if (strcmp(*argv, "limit") == 0) {
 			NEXT_ARG();
@@ -109,6 +121,11 @@ static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
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
@@ -162,6 +179,8 @@ static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	max_P = probability * pow(2, 32);
 	addattr_l(n, 1024, TCA_RED_MAX_P, &max_P, sizeof(max_P));
 	addattr_l(n, 1024, TCA_RED_FLAGS, &flags_bf, sizeof(flags_bf));
+	if (qevents_dump(qevents, n))
+		return -1;
 	addattr_nest_end(n, tail);
 	return 0;
 }
@@ -203,12 +222,12 @@ static int red_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	print_uint(PRINT_JSON, "min", NULL, qopt->qth_min);
 	print_string(PRINT_FP, NULL, "min %s ", sprint_size(qopt->qth_min, b2));
 	print_uint(PRINT_JSON, "max", NULL, qopt->qth_max);
-	print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt->qth_max, b3));
+	print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt->qth_max, b3));
 
 	tc_red_print_flags(qopt->flags);
 
 	if (show_details) {
-		print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt->Wlog);
+		print_uint(PRINT_ANY, "ewma", " ewma %u ", qopt->Wlog);
 		if (max_P)
 			print_float(PRINT_ANY, "probability",
 				    "probability %lg ", max_P / pow(2, 32));
@@ -217,6 +236,11 @@ static int red_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		print_uint(PRINT_ANY, "Scell_log", "Scell_log %u",
 			   qopt->Scell_log);
 	}
+
+	qevents_init(qevents);
+	if (qevents_read(qevents, tb))
+		return -1;
+	qevents_print(qevents, f);
 	return 0;
 }
 
-- 
2.20.1


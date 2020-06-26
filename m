Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6177420BCE5
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgFZWqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:46:31 -0400
Received: from mail-eopbgr50045.outbound.protection.outlook.com ([40.107.5.45]:16979
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725836AbgFZWqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 18:46:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJF4ig9YLYwayqOiffhC523dhYVgSA5XbM7t6o/boFPwE0OhgydNet28K74VaeFLhG4Z1WyS35C1uz0vHafIvkZ235MIqhFEB6rUxIyGwCHvy4DIcMT6vYMvWOzojr1b7Z4fX4lFAfLoSTpx/IPPjFSHh3ZxsQmg+CmQ9vV+GXQUnJSVgrK95NZqUWAoxmuzke7ACWXSFnZq0ptmu/R85Hmo906kJHLzm5QfFDHS6vZd1Wi6QlMU01RFNIhbVvOJ/iCOLLUQebzriv/P1nsQeRwvgNXg39EkG3aq2D2ejwQ5gEBG0//ays25/gaLC5AUrTXw60TeWKiQfkHFL76EvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndyWQNZcVFEwJnhZBLwApPvfSG8J7sth2i0NHwevsKk=;
 b=kgLvBj5DoV3GN3LjZsxjRdE51ASPEoD/MPUcmZOgunfjkZfIShsYMF4b84aAqhNvWka3BKGLsqs4nwaZxIWptpGsc2g1n3ka2Va6oZGS5SJbU0JsH1YloKMT/VYXCeP9xHeWeOSHCrySomFRRXuk08gsRckoqJUhvRH36xr8faS5ThmdbZAvoOgT/RX2mhktpjcG4mgwmY2Tc81ZR6xBwJ924rRPfC8GKrcIUXJtbTsnwbooDbFDVCBS8GhdTW3pctzj8KBCiaZ3xOENBT+r/WXy0k638QPY98JiUSqVRLc2urkk4VcdzaDYsiWjKSa9fjKaeaMJ+L5tfl4PF8QnHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndyWQNZcVFEwJnhZBLwApPvfSG8J7sth2i0NHwevsKk=;
 b=rbsx4jafhP0iWdV1ifoBochDvQubiJ5giO58nhwnuSgk1XcM0jlI2ieXUwFPxAswR+S9JRWAoqMDOiy3qejFO0TwkWz0J7vRfTz9LojSm5vAiaFn7uG34m+6MEE7RIvnS4Jcq4AUOhpud8T4GIGNtLl5DmufiiQhaTrVrdMXpkA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4745.eurprd05.prod.outlook.com (2603:10a6:7:9a::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.25; Fri, 26 Jun 2020 22:46:22 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 22:46:22 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jiri@mellanox.com,
        idosch@mellanox.com, Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v1 4/4] tc: q_red: Add support for qevents "mark" and "early_drop"
Date:   Sat, 27 Jun 2020 01:45:33 +0300
Message-Id: <caa9c99f9293bcb61a6ee639d21aaf62b71367bb.1593211071.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <ea058286aa9a3dd430d261e61111cf5f91c857bc.1593211071.git.petrm@mellanox.com>
References: <ea058286aa9a3dd430d261e61111cf5f91c857bc.1593211071.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0139.eurprd05.prod.outlook.com
 (2603:10a6:207:3::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:207:3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 22:46:21 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2b9d1a2e-60d2-446b-03f0-08d81a22bfe1
X-MS-TrafficTypeDiagnostic: HE1PR05MB4745:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB474575EEF923C3874CF2409BDB930@HE1PR05MB4745.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:210;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3nnBGjJ6YWPPQlvHXZ4wPW0VW5t04bGElQqiP8fVf4Phs9b5e6zU52uPFScSd4qiTk3OBZZnG0kPTqGwBxOLoabwsy4lpgfAMV0CIZAewdgVzUVLvbNs/fUcVS7GrXneE9tEHyIaps7OmAvOXHhcJRycc7aDiggYbKurVvi1qyWwGslxc83DMqoSm8lHwFhAa6AFnf6poDIjvM1OjwbF11nXeDChulRzk2xdvflSlmmUhKnfouxEDjq0e1z8A92gm0wB9KHC/bNZ05scimwAF5nlD2JIZKs/1cYY/danloQXtpM+lWmrSAQO8iY6a42W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(86362001)(26005)(54906003)(4326008)(36756003)(66476007)(66556008)(316002)(186003)(16526019)(6666004)(478600001)(5660300002)(52116002)(6486002)(66946007)(6512007)(6506007)(107886003)(2906002)(2616005)(8676002)(956004)(6916009)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: erAhVOElOHHcIoZaEezbHfusVCZDVW84NwfBENaYr1yK2IHMkf+2r7MiDydjutjNylk5NOP8eQsy1A8hmQ/q8vJVXfSbgeIQj5baLSG+DIWj8AKUqGg0InZR66QqE0bW4rSRLhIfaHpjemcgQZm5v/pcVpB4aLSEysO87i/PX5TPEdRYtesy0jTvNQVXs43FWBUkT/Th/ayiN8LPxX/4qXKpxQT7x0y2SGFM8EQA3whw8g0A0OBht+zcmI3yULh41u9gB4Gaq0F4u9QVfUveYgur8OgzOuRvhJPUoUP+h2U2E4ZseNahe78DIyfB1/sDM8smKWBrMrsewY5d5AHT2RQcwgtqUZV8hGfVPui6Cp89KUO3Ldp6+7x+EaupqkFkXXigfUj67ahXQNWEmLzTF6zTCPBT/7HGcjPmXDhNJlqfulAhX6YjKHsTCtZnhSHAK/0QYBvSMdgIKEisX+ROdkNLwK1W4x5t7Y6Be/8n5Uo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b9d1a2e-60d2-446b-03f0-08d81a22bfe1
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 22:46:22.5928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/dUPjSkCmjQ/ZtAhly5tdZ0PtA0d4y25haUvZUAOcekDwfQqLDgk2prAUI7XJP5JJPFxdJfNDgaww4bRASrNQ==
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


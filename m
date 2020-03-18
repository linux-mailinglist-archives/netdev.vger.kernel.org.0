Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86803189BD6
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgCRMTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:19:07 -0400
Received: from mail-db8eur05on2080.outbound.protection.outlook.com ([40.107.20.80]:33625
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726616AbgCRMTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 08:19:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXpDndlSyXH+4XVapJf0Xo8iq1Wf5Ba2Y1DEcHg/PYrN2yUM+xnHiqXisSKRx4OGIA0qGAu/wslva20xxUD1lq6xV7Jgg2Ek8i3XJUxwW8iqdKBdzWM922B0fQtqERa5/1gXqkZkZZarCLbbmr4ACKEw1uqqZ353asKdtrkwJ5lzCyFVZmpmDba2LaWLYdo7jrbDaek7Pzb/2kMKEQLnrNX7GNJktgFwu6MisRtTDkQmzfq6ztPpirPzOJMSX0rkTatjDzJeL+pdGJJbl1TjuS6x4bwRNnWZu3aunN+SyqE4MPmvjDsO8E7Z//FOUrUWZjtkuAufu4eo0SEW8qCbKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lB5K/z/nEXn1krmoNPIfWLQpw0y05L/Bu1JvbGzQKc4=;
 b=CLeRPBlo38Z7T9TmaI8nmZFcrW0bP2Bh6svE0IQsDRbsOsvP/YTu2Is56U1+daXwfKE//EwLpGa3+DeBq9+b8dT1zVr6aOrzKzDn0LDSG3yxa7gh1u3xbBP9xVaR6vmuudvNdoh3djtw4uKBbrHrp8kVn6uJcmmBAtzXF2R6mvrFOfqqyjtFnOV7oQ/y3hYihmIrlKFRJzFsLypdC9N958QmIyACOqwP4OAaacrjypuIhvf01w1Gn7kzCBTvqRoY2/5u3OyGW/kdgJ0ShhKC2uVqXS6+lbypO0NMmGvmTdN/ClylAlLHDc9ctnvZMCZCTa3pzZ4L41RMOOYSuBEpHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lB5K/z/nEXn1krmoNPIfWLQpw0y05L/Bu1JvbGzQKc4=;
 b=YC+t+U2+KZlo3qdkIjM+dMu9EZ4XUZj6UnnHuptZA3PcL6Pflb6qfcEElFGKkIwR8IVGNP+Qpy2ZsFspToJ9ekRDF+nvtZT3FBVSsqYNi+XP95/nj/I4FKUFS4LipUm6AMLCTQjFeI++FjXZPc2upYG87V9u2/8gYridHi6Fco4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from DB6PR05MB4743.eurprd05.prod.outlook.com (10.168.18.154) by
 DB6PR05MB4584.eurprd05.prod.outlook.com (10.168.24.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Wed, 18 Mar 2020 12:19:01 +0000
Received: from DB6PR05MB4743.eurprd05.prod.outlook.com
 ([fe80::1861:6b92:8d4d:651]) by DB6PR05MB4743.eurprd05.prod.outlook.com
 ([fe80::1861:6b92:8d4d:651%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 12:19:01 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 2/2] tc: q_red: Support 'nodrop' flag
Date:   Wed, 18 Mar 2020 14:18:28 +0200
Message-Id: <bb3146bd93e4c5f089033311e8a0418f93420447.1584533829.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1584533829.git.petrm@mellanox.com>
References: <cover.1584533829.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0048.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::36) To DB6PR05MB4743.eurprd05.prod.outlook.com
 (2603:10a6:6:47::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR2P264CA0048.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Wed, 18 Mar 2020 12:19:00 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9eb9776d-f40f-4498-2b31-08d7cb368ad8
X-MS-TrafficTypeDiagnostic: DB6PR05MB4584:|DB6PR05MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR05MB45845419901D30E4E0CB5328DBF70@DB6PR05MB4584.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(199004)(966005)(6486002)(956004)(6916009)(2616005)(316002)(66946007)(54906003)(26005)(478600001)(4326008)(16526019)(186003)(6666004)(6512007)(2906002)(8676002)(66476007)(6506007)(66556008)(5660300002)(86362001)(81166006)(81156014)(52116002)(36756003)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR05MB4584;H:DB6PR05MB4743.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N+C/WLUalWKZGEZPogV6mo1OEQUPGqxjBxIQ9Djs8MSZoEJCWFqTEowZK5iUk+/NIOzCEki5vJcFXZCQhndjKIOlhURknYc08UczcaprDjzPSgCvMgmLgcjl0/EVDP6eXuFCEr/J2m1DZCpWz9+OWULOSNYRSEFT8syw0ZOZ5OTBObNB4UMxDThV/OvTYhDqwXmGxi/aI9VHFWFBNeLeIeeYd0t3tJk1ujhZHLMIFf2jM6olBIGatdzlc9EFmXzM2hHQS7/VN2ehZkCBS6bUJReS6L1qPrppGJb1LphALt115Xx3oQglu92ANmlbRp8OgcHKrH+Z7UmWOBJiYrZFP3xuLzo4NWVXHaTXrT8cXGh1XAHCa6m4nlVxX1Z2d/woK1qKXRbs++ph73Y1u/raa8jphTuye1jIkQhgDLTvXrazqUplgNPsLNUanBiQZ291n3/Uo4mAPDkXirNU6uyj1iJr2JdliaY5zUwtWxbmeTYzuyT4wOUVduO4/2rM2wzwP38cJ+DXo5GrZ9FyxmbOFw==
X-MS-Exchange-AntiSpam-MessageData: 7F5WA0SHPQP5dinumIdQYVjyGRZubXaAleTYHPyGYGZokNz5gxlkoah/od5MU/c0P8y8PvkgbWBqfsInU5HqI/6sNyARsZtODKUWWNI0ccrERRWsbaoAKECNCS2OE6Tmg8S61aXP6hbDlwueXj0q4A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb9776d-f40f-4498-2b31-08d7cb368ad8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 12:19:01.6778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUT1XJNmZTtpBWg55zWQIWA12wPP0E8Stg9FcvdJfjG82AbZ/9HWgcKqtUxXUuuTGiTLtctIVu1BjPQ0i8z60g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB4584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recognize the new configuration option of the RED Qdisc, "nodrop". Add
support for passing flags through TCA_RED_FLAGS, and always use it for
passing RED flags.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 man/man8/tc-red.8 |  6 +++++-
 tc/q_red.c        | 22 +++++++++++++++++-----
 tc/tc_red.c       |  5 +++++
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/man/man8/tc-red.8 b/man/man8/tc-red.8
index dd1ab74c..b5aaa986 100644
--- a/man/man8/tc-red.8
+++ b/man/man8/tc-red.8
@@ -13,7 +13,7 @@ bytes
 bytes
 .B [ burst
 packets
-.B ] [ ecn ] [ harddrop] [ bandwidth
+.B ] [ ecn ] [ harddrop ] [ nodrop ] [ bandwidth
 rate
 .B ] [ probability
 chance
@@ -123,6 +123,10 @@ If average flow queue size is above
 .B max
 bytes, this parameter forces a drop instead of ecn marking.
 .TP
+nodrop
+With this parameter, traffic that should be marked, but is not ECN-capable, is
+enqueued. Without the parameter it is early-dropped.
+.TP
 adaptive
 (Added in linux-3.3) Sets RED in adaptive mode as described in http://icir.org/floyd/papers/adaptiveRed.pdf
 .nf
diff --git a/tc/q_red.c b/tc/q_red.c
index 6256420f..ee81803e 100644
--- a/tc/q_red.c
+++ b/tc/q_red.c
@@ -30,12 +30,17 @@ static void explain(void)
 	fprintf(stderr,
 		"Usage: ... red	limit BYTES [min BYTES] [max BYTES] avpkt BYTES [burst PACKETS]\n"
 		"		[adaptive] [probability PROBABILITY] [bandwidth KBPS]\n"
-		"		[ecn] [harddrop]\n");
+		"		[ecn] [harddrop] [nodrop]\n");
 }
 
+#define RED_SUPPORTED_FLAGS (TC_RED_HISTORIC_FLAGS | TC_RED_NODROP)
+
 static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 			 struct nlmsghdr *n, const char *dev)
 {
+	struct nla_bitfield32 flags_bf = {
+		.selector = RED_SUPPORTED_FLAGS,
+	};
 	struct tc_red_qopt opt = {};
 	unsigned int burst = 0;
 	unsigned int avpkt = 0;
@@ -95,13 +100,15 @@ static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 				return -1;
 			}
 		} else if (strcmp(*argv, "ecn") == 0) {
-			opt.flags |= TC_RED_ECN;
+			flags_bf.value |= TC_RED_ECN;
 		} else if (strcmp(*argv, "harddrop") == 0) {
-			opt.flags |= TC_RED_HARDDROP;
+			flags_bf.value |= TC_RED_HARDDROP;
+		} else if (strcmp(*argv, "nodrop") == 0) {
+			flags_bf.value |= TC_RED_NODROP;
 		} else if (strcmp(*argv, "adaptative") == 0) {
-			opt.flags |= TC_RED_ADAPTATIVE;
+			flags_bf.value |= TC_RED_ADAPTATIVE;
 		} else if (strcmp(*argv, "adaptive") == 0) {
-			opt.flags |= TC_RED_ADAPTATIVE;
+			flags_bf.value |= TC_RED_ADAPTATIVE;
 		} else if (strcmp(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -154,6 +161,7 @@ static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	addattr_l(n, 1024, TCA_RED_STAB, sbuf, 256);
 	max_P = probability * pow(2, 32);
 	addattr_l(n, 1024, TCA_RED_MAX_P, &max_P, sizeof(max_P));
+	addattr_l(n, 1024, TCA_RED_FLAGS, &flags_bf, sizeof(flags_bf));
 	addattr_nest_end(n, tail);
 	return 0;
 }
@@ -183,6 +191,10 @@ static int red_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	    RTA_PAYLOAD(tb[TCA_RED_MAX_P]) >= sizeof(__u32))
 		max_P = rta_getattr_u32(tb[TCA_RED_MAX_P]);
 
+	if (tb[TCA_RED_FLAGS] &&
+	    RTA_PAYLOAD(tb[TCA_RED_FLAGS]) >= sizeof(__u32))
+		qopt->flags = rta_getattr_u32(tb[TCA_RED_FLAGS]);
+
 	print_uint(PRINT_JSON, "limit", NULL, qopt->limit);
 	print_string(PRINT_FP, NULL, "limit %s ", sprint_size(qopt->limit, b1));
 	print_uint(PRINT_JSON, "min", NULL, qopt->qth_min);
diff --git a/tc/tc_red.c b/tc/tc_red.c
index 681ca297..88f5ff35 100644
--- a/tc/tc_red.c
+++ b/tc/tc_red.c
@@ -116,4 +116,9 @@ void tc_red_print_flags(__u32 flags)
 		print_bool(PRINT_ANY, "adaptive", "adaptive ", true);
 	else
 		print_bool(PRINT_ANY, "adaptive", NULL, false);
+
+	if (flags & TC_RED_NODROP)
+		print_bool(PRINT_ANY, "nodrop", "nodrop ", true);
+	else
+		print_bool(PRINT_ANY, "nodrop", NULL, false);
 }
-- 
2.20.1


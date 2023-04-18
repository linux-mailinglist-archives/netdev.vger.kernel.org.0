Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150D36E6016
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjDRLka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbjDRLkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:40:20 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2074.outbound.protection.outlook.com [40.107.14.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20C87D92
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:40:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btAZxPyZyQ6xQOjiap20JTXq/yaXEtc1blQum5IVkfTTgW5K8386/OmYsu+r3m00udXcB8iFSmpV3yX+1G3I9NAzajoz7os9mE70p14RPYgGCBnkAQq3Q9uztaHW6NKLuMLheMtt/1tCEJTlOFe4df7roEqKvD5ED5jb7Gc5kyLgyXc8EkXfLa4fT91YuhIg2Ko8wXgi7VUoc7JeCvAucCrIVPu7Dzh6rO6C/PBGwWT9EhgA8hA1GUoYA1J/TOmNvsNT8BvZltFj0bXnbyJ3auT9TwYbYuHs7cczWuRnrqFIDCc31QO1pbSEJ2SUBA2Nw6EI6PuebqMi9klGm+creA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXvepB2lhAalJhLN8VhDNVTUQP9Lr05k/308Y0MT9rI=;
 b=f6fvWYkI2SEu6BVc9p/TWZ+6UNbUpsEPuSy75nLTglIkUSWzg8plR15KUGdMihOmKrF+IhhNQvWplSoNZ2YRj00fQqrwJa0a+vZooS1oIsy/InHBECC2F7qCPAbrTXDAOyr+Kl0OKfm3YLuCd/ik7v0vY0pBIhy8PQimDC6FAdSel8DlTKif2BUAV+UjY5lbct60NgM3JBByrdebDvtPEji53MfUIa0Y5TehZM/l5JzKgV/Cl0DLP1jBigoJ3VuR8rQrPsE99G14ASoTloDsX7oigu5AbWwHAKFhWpqmrzA6rc44M7jcxKEX7mOL4DvI9MV9hIdAOWOPIR3qJcQ2rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXvepB2lhAalJhLN8VhDNVTUQP9Lr05k/308Y0MT9rI=;
 b=aU/Vg+ZLdJXUlyh5gT1DvlI6q8E+Far1CBz7We+ZmrutRbj3qLkImegFgLmQmCZIiDW0uODKzH3eT6tMwoU5PeEiZ8nGGOmig7Giky/lOWUnEH4ZivqM1f2GuxayoEL4v5H0iN10roEoA7ITnwdfWGjRrbNPgD04pWV9Faq4CwU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8557.eurprd04.prod.outlook.com (2603:10a6:102:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Tue, 18 Apr
 2023 11:40:11 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:40:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 10/10] tc/taprio: add support for preemptible traffic classes
Date:   Tue, 18 Apr 2023 14:39:53 +0300
Message-Id: <20230418113953.818831-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418113953.818831-1-vladimir.oltean@nxp.com>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0003.eurprd05.prod.outlook.com
 (2603:10a6:800:92::13) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8557:EE_
X-MS-Office365-Filtering-Correlation-Id: bb02c654-6a25-402d-371f-08db4001ab12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L/0AxQ6CREzU3z0II8Ss0nTGF8jJqRB9OeNf0TrxzXUer2HKbrTg1dEwL/v0HnzOOcaS4PjIviH5EJlXaIdmsaHjo/C6z5JIjxbzmY1F2g8zWrgViygXtPtQ6M2iRhMAwUbMxGWzLS65ty9BHXq3V9/eJew5aWpusC9Umqf10szhmYUn/AUrjhJexGKATAvxh728VKrRwQ3SbJGdZKfKMrfM8GD4UWkBsGOT+0eckRA6jQrIcS0m8CWf7w9dSQTcyyNQmwZS6OYOg3u0NmgqlBIWrRwcXnA5m5K22Z1h+Cuj2b60oDTQJK9pXgd/OlmLnXwWxnIIZNKOADGD2iR8VZnd10R3P53Iv2aTGPsnLd2ZREy25Bmx3bBashwwlRudfLL/rYifpbT9iB3koJ3BAGdgN6sHecWzlU4DKd241v9X3HmBgXjIeZuzQjeEqZdjaTT9vg8mY+//Ld/moATk/nezg6rUcIbRWED3MNN1os2r8UrETOFhc6A7tTgFV5r00qEHUZjel886QWdFHmnEl7ohii50wP5nsanj9KHU2XkMl+UsWq7BbTKPY7X9W9wTQ5ZRKQoBzLNJTdZ+N16vfgOdquiEkTjEnJQmP7FQ5LS+Hmt8BKydvh4koEloN0hb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(316002)(4326008)(66946007)(66556008)(66476007)(6916009)(478600001)(54906003)(8936002)(8676002)(5660300002)(44832011)(41300700001)(38100700002)(38350700002)(186003)(83380400001)(2616005)(6486002)(6666004)(52116002)(6512007)(6506007)(1076003)(26005)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6DAKH/dvcyXO4518PR+6v1hbXRejXGtfGSzHd/l5M9oyLCYkpc+5rk1Apgmg?=
 =?us-ascii?Q?zeUBj7BdNj0zECgliU6IXxCYHM77koVOQq97JWUn20VehbK8CstFAv5toqdh?=
 =?us-ascii?Q?oLE0Z6W6XQyELAspXx6IPSFLmrimGwNdzeQAEKbmzM4nMhTynewgAjfjqTPt?=
 =?us-ascii?Q?TFc/9FsIdqTJVsW6sUYWEsTgem9B7B5FPDogdr1N1gmmEt+aD8lT4coSbli2?=
 =?us-ascii?Q?BfBrcIGBmfNf7u938P/VMVaC3pSTyAWJZ52x9dm3Wgb2uZjaL1WQO/x7DGaK?=
 =?us-ascii?Q?/jbrJ4qGXk4ATYXtidFJeSLkq/NKzwXgGoml0iETxSLi4XyyRaCtqsQrxdpf?=
 =?us-ascii?Q?EdY+HbK9PV8ayJMRPGMjGjgKU9hkXGNwgdJus06Ros1mzbuJNKjS4dsQyP1g?=
 =?us-ascii?Q?8yXs9t7vwGJN7DuQ5ijMy5oAdGb+BOkPyuV6VLsOxZKhgujUBmAr9j2Y3wWv?=
 =?us-ascii?Q?PlKhpKjpeObIBVnDbghtBqpP/D09o7e0cXXDwJ+lmYB8KjHLeo8Pp/pOioPL?=
 =?us-ascii?Q?Sh10ZFCt33T0Cq0Llum7GRLIAgjwjoUjhGOYhFzVrrSoSca2Mkvpv78OJC+b?=
 =?us-ascii?Q?Zxitgmh9rg4YKNFYHWFMvPYfw1Ls/kFzNvm7pJMYDYMy9ml+z2M8ISkLkY72?=
 =?us-ascii?Q?zfJHlxqkiMhTeTA61Hv01m4qsVgjuSvN6FHBtuPwS+LAGMry0H+e+MnorPGu?=
 =?us-ascii?Q?gVP937R4A4owjmJ+4kzb5nM4tDL3iifwqM4JomNiVzUYFdiYltK4+tG9ZH+j?=
 =?us-ascii?Q?7ErdzCJ5bL3nqpd7jk7RTFW2GKGNQx+9hmHKvhmQOmSIV9QlCjRvCBF8oNkK?=
 =?us-ascii?Q?4Y+s0gDN4wplX06E1u6RZX/0oLWlsK21LlfeNFSkfsDvuek94ck/pI9KuqIS?=
 =?us-ascii?Q?TmQC45Y7dtDBehJR4eFJfmgCL7kEISyScupxNg9C9QoaI0AVsJIydgBVfcg9?=
 =?us-ascii?Q?Bb0jqPVzNNisSPDX38ytiW5W2qjtXzihzm2tb23wOEyTEDd2jUpVYxKy8B8a?=
 =?us-ascii?Q?LBZJyl6b4MwRAZgT7UMcXvY/6xLiZGqJLyPK2SmOueqTFJZoO0aLnFnJmPQf?=
 =?us-ascii?Q?q6ZZDUb6aA28Y+nlJswksvFTHPVJf6/C6p7ax82YwwYCWAk9hny9oZNqKLes?=
 =?us-ascii?Q?SNlsKZERSqMpiwQiFYq6BhW9zhO6snVbwzavV+AygtikIScyyaKq8NKXGXOZ?=
 =?us-ascii?Q?CmWUL3xn39tipQWnNziKDfqlRKfAWXUjG/tsTJ3MKNfQXVrzJE3LQiHf2ypA?=
 =?us-ascii?Q?SRASPv7XDj0cjEkOTuBVvHRPJuevtwvaYe924jllriDV46llLDNAnJ8I5d4G?=
 =?us-ascii?Q?Gu3zg5PPfA0QXRfUQW2uEEjNiOuX7Wz78xZlkxHXW8JqkfnMxgJWDBeSTRAa?=
 =?us-ascii?Q?pvhk8Y/QQAGMsl+QEysbovgHFO4LMRsVCps60Gp9ZqCp/xO3KYJao7gTelvZ?=
 =?us-ascii?Q?iFqWCapiqxKOWKwz5plMBoMREDAkvaPUcFt39o4uVNuqWBaDJ59tuPyL5eZ0?=
 =?us-ascii?Q?+o3aRIUN3xLdr1+/o8EJ9OO4de7sKdf8FZQYKEHVzqIPAHbLRRMXNJ7RhL+9?=
 =?us-ascii?Q?CBaGtoMl5Mg0ecIFie+C8mGdb/xsD5ZOr9dL98Vm4+hO5kUNxMCWYYaCeuG2?=
 =?us-ascii?Q?RA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb02c654-6a25-402d-371f-08db4001ab12
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:40:11.3852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a5suG1yyxOwJxHeq+T+BBqy6Ps/WqtyAXBrzCN0UKlB7juxzgogcuBxt6YlIztSfHBV4C2gJNni2schYwsy/rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8557
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the same kind of "fp" array argument as in mqprio,
except here we already have some handling for per-tc entries (max-sdu).
We just need to expand that logic such that we also add (and parse) the
FP adminStatus property of each traffic class.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: amended help text so that user space (kselftests) could detect
        the presence of the new feature

 man/man8/tc-taprio.8 |  11 +++++
 tc/q_taprio.c        | 100 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 87 insertions(+), 24 deletions(-)

diff --git a/man/man8/tc-taprio.8 b/man/man8/tc-taprio.8
index c3ccefea9c8a..bf489b032a7e 100644
--- a/man/man8/tc-taprio.8
+++ b/man/man8/tc-taprio.8
@@ -36,6 +36,10 @@ clockid
 [
 .B max-sdu
 <queueMaxSDU[TC 0]> <queueMaxSDU[TC 1]> <queueMaxSDU[TC N]> ]
+.ti +8
+[
+.B fp
+<adminStatus[TC 0]> <adminStatus[TC 1]> <adminStatus[TC N]> ]
 
 .SH DESCRIPTION
 The TAPRIO qdisc implements a simplified version of the scheduling
@@ -163,6 +167,13 @@ represents the maximum L2 payload size that can egress that traffic class.
 Elements that are not filled in default to 0. The value 0 means that the
 traffic class can send packets up to the port's maximum MTU in size.
 
+.TP
+fp
+.br
+Selects whether traffic classes are express or preemptible. See
+.BR tc-mqprio(8)
+for details.
+
 .SH EXAMPLES
 
 The following example shows how an traffic schedule with three traffic
diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index c0da65fe3744..bc29710c4686 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -49,6 +49,7 @@ static void explain(void)
 		"		[queues COUNT@OFFSET COUNT@OFFSET COUNT@OFFSET ...]\n"
 		"		[ [sched-entry index cmd gate-mask interval] ... ]\n"
 		"		[base-time time] [txtime-delay delay]\n"
+		"		[fp FP0 FP1 FP2 ...]\n"
 		"\n"
 		"CLOCKID must be a valid SYS-V id (i.e. CLOCK_TAI)\n");
 }
@@ -148,17 +149,29 @@ static struct sched_entry *create_entry(uint32_t gatemask, uint32_t interval, ui
 }
 
 static void add_tc_entries(struct nlmsghdr *n, __u32 max_sdu[TC_QOPT_MAX_QUEUE],
-			   int num_max_sdu_entries)
+			   int num_max_sdu_entries, __u32 fp[TC_QOPT_MAX_QUEUE],
+			   int num_fp_entries)
 {
 	struct rtattr *l;
+	int num_tc;
 	__u32 tc;
 
-	for (tc = 0; tc < num_max_sdu_entries; tc++) {
+	num_tc = max(num_max_sdu_entries, num_fp_entries);
+
+	for (tc = 0; tc < num_tc; tc++) {
 		l = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_TC_ENTRY | NLA_F_NESTED);
 
 		addattr_l(n, 1024, TCA_TAPRIO_TC_ENTRY_INDEX, &tc, sizeof(tc));
-		addattr_l(n, 1024, TCA_TAPRIO_TC_ENTRY_MAX_SDU,
-			  &max_sdu[tc], sizeof(max_sdu[tc]));
+
+		if (tc < num_max_sdu_entries) {
+			addattr_l(n, 1024, TCA_TAPRIO_TC_ENTRY_MAX_SDU,
+				  &max_sdu[tc], sizeof(max_sdu[tc]));
+		}
+
+		if (tc < num_fp_entries) {
+			addattr_l(n, 1024, TCA_TAPRIO_TC_ENTRY_FP, &fp[tc],
+				  sizeof(fp[tc]));
+		}
 
 		addattr_nest_end(n, l);
 	}
@@ -168,6 +181,7 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 			    char **argv, struct nlmsghdr *n, const char *dev)
 {
 	__u32 max_sdu[TC_QOPT_MAX_QUEUE] = { };
+	__u32 fp[TC_QOPT_MAX_QUEUE] = { };
 	__s32 clockid = CLOCKID_INVALID;
 	struct tc_mqprio_qopt opt = { };
 	__s64 cycle_time_extension = 0;
@@ -175,6 +189,7 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 	bool have_tc_entries = false;
 	int num_max_sdu_entries = 0;
 	struct rtattr *tail, *l;
+	int num_fp_entries = 0;
 	__u32 taprio_flags = 0;
 	__u32 txtime_delay = 0;
 	__s64 cycle_time = 0;
@@ -227,6 +242,23 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 				free(tmp);
 				idx++;
 			}
+		} else if (strcmp(*argv, "fp") == 0) {
+			while (idx < TC_QOPT_MAX_QUEUE && NEXT_ARG_OK()) {
+				NEXT_ARG();
+				if (strcmp(*argv, "E") == 0) {
+					fp[idx] = TC_FP_EXPRESS;
+				} else if (strcmp(*argv, "P") == 0) {
+					fp[idx] = TC_FP_PREEMPTIBLE;
+				} else {
+					fprintf(stderr,
+						"Illegal \"fp\" value \"%s\", expected \"E\" or \"P\"\n",
+						*argv);
+					return -1;
+				}
+				num_fp_entries++;
+				idx++;
+			}
+			have_tc_entries = true;
 		} else if (strcmp(*argv, "max-sdu") == 0) {
 			while (idx < TC_QOPT_MAX_QUEUE && NEXT_ARG_OK()) {
 				NEXT_ARG();
@@ -369,7 +401,7 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 			  &cycle_time_extension, sizeof(cycle_time_extension));
 
 	if (have_tc_entries)
-		add_tc_entries(n, max_sdu, num_max_sdu_entries);
+		add_tc_entries(n, max_sdu, num_max_sdu_entries, fp, num_fp_entries);
 
 	l = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST | NLA_F_NESTED);
 
@@ -460,9 +492,10 @@ static int print_schedule(FILE *f, struct rtattr **tb)
 	return 0;
 }
 
-static void dump_tc_entry(__u32 max_sdu[TC_QOPT_MAX_QUEUE],
-			  struct rtattr *item, bool *have_tc_entries,
-			  int *max_tc_index)
+static void dump_tc_entry(struct rtattr *item,
+			  __u32 max_sdu[TC_QOPT_MAX_QUEUE],
+			  __u32 fp[TC_QOPT_MAX_QUEUE],
+			  int *max_tc_max_sdu, int *max_tc_fp)
 {
 	struct rtattr *tb[TCA_TAPRIO_TC_ENTRY_MAX + 1];
 	__u32 tc, val = 0;
@@ -481,23 +514,30 @@ static void dump_tc_entry(__u32 max_sdu[TC_QOPT_MAX_QUEUE],
 		return;
 	}
 
-	if (*max_tc_index < tc)
-		*max_tc_index = tc;
-
-	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU])
+	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]) {
 		val = rta_getattr_u32(tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]);
+		max_sdu[tc] = val;
+		if (*max_tc_max_sdu < (int)tc)
+			*max_tc_max_sdu = tc;
+	}
 
-	max_sdu[tc] = val;
+	if (tb[TCA_TAPRIO_TC_ENTRY_FP]) {
+		val = rta_getattr_u32(tb[TCA_TAPRIO_TC_ENTRY_FP]);
+		fp[tc] = val;
 
-	*have_tc_entries = true;
+		if (*max_tc_fp < (int)tc)
+			*max_tc_fp = tc;
+	}
 }
 
 static void dump_tc_entries(FILE *f, struct rtattr *opt)
 {
 	__u32 max_sdu[TC_QOPT_MAX_QUEUE] = {};
-	int tc, rem, max_tc_index = 0;
-	bool have_tc_entries = false;
+	__u32 fp[TC_QOPT_MAX_QUEUE] = {};
+	int max_tc_max_sdu = -1;
+	int max_tc_fp = -1;
 	struct rtattr *i;
+	int tc, rem;
 
 	rem = RTA_PAYLOAD(opt);
 
@@ -505,18 +545,30 @@ static void dump_tc_entries(FILE *f, struct rtattr *opt)
 		if (i->rta_type != (TCA_TAPRIO_ATTR_TC_ENTRY | NLA_F_NESTED))
 			continue;
 
-		dump_tc_entry(max_sdu, i, &have_tc_entries, &max_tc_index);
+		dump_tc_entry(i, max_sdu, fp, &max_tc_max_sdu, &max_tc_fp);
 	}
 
-	if (!have_tc_entries)
-		return;
+	if (max_tc_max_sdu >= 0) {
+		open_json_array(PRINT_ANY, "max-sdu");
+		for (tc = 0; tc <= max_tc_max_sdu; tc++)
+			print_uint(PRINT_ANY, NULL, " %u", max_sdu[tc]);
+		close_json_array(PRINT_ANY, "");
 
-	open_json_array(PRINT_ANY, "max-sdu");
-	for (tc = 0; tc <= max_tc_index; tc++)
-		print_uint(PRINT_ANY, NULL, " %u", max_sdu[tc]);
-	close_json_array(PRINT_ANY, "");
+		print_nl();
+	}
 
-	print_nl();
+	if (max_tc_fp >= 0) {
+		open_json_array(PRINT_ANY, "fp");
+		for (tc = 0; tc <= max_tc_fp; tc++) {
+			print_string(PRINT_ANY, NULL, " %s",
+				     fp[tc] == TC_FP_PREEMPTIBLE ? "P" :
+				     fp[tc] == TC_FP_EXPRESS ? "E" :
+				     "?");
+		}
+		close_json_array(PRINT_ANY, "");
+
+		print_nl();
+	}
 }
 
 static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
-- 
2.34.1


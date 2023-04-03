Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DF36D42A2
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjDCKyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjDCKxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:53:38 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2060.outbound.protection.outlook.com [40.107.22.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C6B11641
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 03:53:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hiqu8ogam9BoK4FA+gn3GQWFtjQgahhS7uG2/gKsZ0Z0Meslm/iGfiSRDRz3fdB6ivzN/OMlM9vJeSQL34FI95rNRODsTCmE5G4xEd1wmSuolHDIW8Uivlz3Jk6vE8/kY0hHi03uHMz7NVazSMeaUYxwPdSTEeQS68MvM+d/sDUvdCi4Z4pL9u65DP32zBlsjBG3wl6i7f+8znHzeGySyOzm21LAop0cehTg5TF9W/m7kaDrp6WmizHjwVXfZvah09BJ0b4hDhq9W13iRoYNtMgSzMLqHKx+Bc1UYbnZtBJFBiDtEw39GsmguCrCvvconUIzeSVbthlfci9hZvYSqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcmsjT+oS6JoyxMeBU9bZtMCkGJcfIFKFORtWOUpaAY=;
 b=ciYazCn5UtI5EsFeZwmBQvIKpkl3thX6UIao8ouok21PCQXleKPpKtf54iFgGRpG9ofIU7pfbb1XyB+C208JBSFTrI85mvT5n+w6yvy/+WriMlFzpgzMPofYmKOQ/HQZn1haicovxniQrLAt4IQBiEWefDWDU6wwXoJxfL8ZTShu8cIN/vp6EO4gLY81HHOZoEDSWlrTyqNP/t7A/aagHWwLf0VbXcACdOVev5umQjjQcZ0lO+4/Fnn0es5QyLPoqqFh0aQmCIZMf8Hbl9etdJGsNm1is0emlJTa5E2udebTGWq8YxXIy7zDeiLC/d7n+Y1jjkECbVVVc7xiIcTedA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcmsjT+oS6JoyxMeBU9bZtMCkGJcfIFKFORtWOUpaAY=;
 b=prWgTCdIgyA58RSk0TzgKFChStexxcXkCiZwh1WMIEGkrZM7h0FGiXw92aImmE8Ce5AJX7VP0jvO+StjMVkHaieUVqClQkxYDevT9grSFihL42eO5VKFrFWFiioNTFQr3hBGWJarlG8EkaHzYa61rp5hHjsWwmNZb5nDGaupp0s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB8479.eurprd04.prod.outlook.com (2603:10a6:10:2c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 10:53:08 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:53:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 9/9] tc/taprio: add support for preemptible traffic classes
Date:   Mon,  3 Apr 2023 13:52:45 +0300
Message-Id: <20230403105245.2902376-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
References: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::16)
 To AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e8767cf-95ed-4fdf-f2f9-08db34319c00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /vsoXVdezAeckoVuZYxSxQwRLgfeslOgSx5xBkLiTGRYMuBQxZ1kziJBJ/RQIIKK9CSzXgzCDAYLg4N2OYf7lJbjrYNXpOBdkVUxFaF0U0EtY/6RhJNU5g8jtCcw2uHArJwdvpdsXHgI5qmMNsx1BGpW2r1n0VtS74yhGbuTkbSWTBNMUTHXZfvszxVG2mb35dx3oAWBL93huo8H7qyRkibxg7d93J6B8+3E7K4eAgJcfptbTgmeCLATn8fihZL7FlthvDcmnJhccFb2YS7gZdgGp2dlYLmJcVrQFMwkr0NMocytcE4R/2PEuDm/kVZfdkfIriWuTe7QswKEluP2E5rDT4kZk829hpfuANIiE6DQ4Yev2Th2BvkY6qn5+jChXo5fwymNVRPUbOETsmSoK3pktKC94nzz3h4OlEivf7ZuWxJwaVlIe2JuxUcMOjMOOPQIA0D9jWdoiXKzPLfAH6UhVLMREYyaEppkUVrQ9toStuSH3xJ2VKG2Cb2st1Pp4XdB0t0AtneiS9/AGSobZWwq7WfLG6uNoUALqQbIC6l42Hm8aLcDq204bEZtZCzzaB0i4HIiyJY56ZBrN4PHZP14VRnGLGy75nZK1/N0QrKBszb42TZ8IYdi4u7PwoiD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(8676002)(6916009)(66556008)(66476007)(66946007)(54906003)(316002)(478600001)(8936002)(44832011)(41300700001)(5660300002)(38100700002)(38350700002)(4326008)(186003)(83380400001)(2616005)(52116002)(6486002)(6666004)(1076003)(26005)(6506007)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W33695xmFV2E50cNaFQKourZSto1t3HQyXh3F7hVM4HHe2rIoCjC62CFwZnf?=
 =?us-ascii?Q?5G1V3dmlKmma392UcZK2VaLDlRsTswPuj3pQ5RW19qNfD1pPTnSRVyePOjix?=
 =?us-ascii?Q?ntTWnUx2xty4W5pue2CntH/nqOE8wAaGwUmPbwiwtFzGnvSEsGDm4VtswlYh?=
 =?us-ascii?Q?tQ3d/drbp82Med5eUrQg9ouMX5iNd2/7LinhShj14gCTTtuRueyrbtTOdilm?=
 =?us-ascii?Q?nDak3qvhD+DHuxslDjI9U27eN67OcMdVcc7yucFrlaWFr6b/dXaLpD9kNg3R?=
 =?us-ascii?Q?AWHb3KShjF5a3V7U1DCmgyafCc7q/FoRM4AEv0tOkbOPN6f0DvwX4udQRfjR?=
 =?us-ascii?Q?b4dsL3FrFTvYkDC0DJc2q5epplgzmnjOqLXWfueTN1rL69jpAcJ2c/ZVOtGc?=
 =?us-ascii?Q?hIbTSaM2WFP0IO2PaZ5x17nEc08GqcFsF6NmGoNdFeUf/PKi+UcoUtRcx184?=
 =?us-ascii?Q?lAXxbQeUsADCTgHQhQT/ifp1BY7mJh2fkO52nrWQ9AdvdL8ILxCx/W9gfmHd?=
 =?us-ascii?Q?RRlbevRDauRIdEqK8MpRjNw10boMzhN0ErRD3Qk97b9lBnvLZDkhNA1KbY7s?=
 =?us-ascii?Q?30ORSJCwui4ilXrdXr5dsdhuloBcU8v2BgQUXeRcR0cBpRhjqPoJ/sOjgpYc?=
 =?us-ascii?Q?CRPXE22nwxI4TDcWEwnCgUgqPNQKI0k2pszRlZcTR812eBBPna6c6O2B8xOi?=
 =?us-ascii?Q?Ibe8mS92Ndnbuuk/ZRj/ExAgzCjtaTd9EywA9KZCq28aJVHN7XFt3jdG+2ZP?=
 =?us-ascii?Q?dChA8LRBNnchjE3lTwBcpCi2x6g1TfcB3mOp0qX5DXcvpT1dejJkuQiUC+rr?=
 =?us-ascii?Q?0AYS88XGuF4kkaIqhsGtbuhOBplt+qoz+Dn375Jka8Xnrj3uul4v3/0PIGzi?=
 =?us-ascii?Q?pa3LhT7lhACOxPdKZe8npsFlLf82Nt6klWP6JcbiZasvZFJi6kueg+3Foi9P?=
 =?us-ascii?Q?Kf5uyoqvIVlrfQuTtk9Lb97TsLlATaWswqbr8zj/nWPFdRjzLDBVPj1sUZu0?=
 =?us-ascii?Q?2w1YYFL8hpMBMFGFyACJeJYyN3B2wYWJxoI2mbVNt2kLbZV82ryE611m44VQ?=
 =?us-ascii?Q?3vbo1tC+rFDbWCqpGvk14WjlX3M8KczzkIqmdJeIiCfNJvvfC0GhJvtHpbiU?=
 =?us-ascii?Q?ktmSs5Sxu48f8DsbJgytCgvoI2owWPwGjJtXhENdSK4bLbCFnpHivtqb0WXA?=
 =?us-ascii?Q?8wX7wK68ko2CE2JOKewcBbxl5f2t8tu3sPWlC+LDnfkshVOVxJmYXjf8CGQ2?=
 =?us-ascii?Q?kxraWifaC6QQUdNm19k4U4Z/g69NnxUd0hHIiSdn2oKQVXFzvU+mohCwuvAN?=
 =?us-ascii?Q?nvY0Ek72WDcBR32sDEDcLU5jII426uGNbD10N/nWeER+i4RJUxhHVpOmkm5v?=
 =?us-ascii?Q?0P0gzns26hxP/Tg/H6F//j1JEfvUSwk/nvbtKOsPYvXm1BMD95ty6L4OLfLI?=
 =?us-ascii?Q?2oKpLxVt9WoCUI4RMZ5GPrFvSN8vYTy87jEES7DTQymnCvsg9Lp3kDBXS5EX?=
 =?us-ascii?Q?Q2l3Fwe8eRmiyVYr+UmPzhrIjsWUd14YX4/+oS+j//1j+6hONrYEJJrNlTGe?=
 =?us-ascii?Q?0FCrJBeTqH/pH1T3pwT2tJFNuPivQ8B7Ebm9BQ3EEGYVQRredXeRg9J2p2r5?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e8767cf-95ed-4fdf-f2f9-08db34319c00
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:53:07.9920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9p3gBxaTGEI/AMsWjezXIiaKUdL0vuW5k6fbhI9mlpa+dUCNcKl17e0WQQ30ZSGVeqa3UlVvYDaNQnNQ6pDavA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8479
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 man/man8/tc-taprio.8 | 11 +++++
 tc/q_taprio.c        | 99 +++++++++++++++++++++++++++++++++-----------
 2 files changed, 86 insertions(+), 24 deletions(-)

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
index e00d2aa9a842..23386aa7d82f 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -148,17 +148,29 @@ static struct sched_entry *create_entry(uint32_t gatemask, uint32_t interval, ui
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
@@ -168,6 +180,7 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 			    char **argv, struct nlmsghdr *n, const char *dev)
 {
 	__u32 max_sdu[TC_QOPT_MAX_QUEUE] = { };
+	__u32 fp[TC_QOPT_MAX_QUEUE] = { };
 	__s32 clockid = CLOCKID_INVALID;
 	struct tc_mqprio_qopt opt = { };
 	__s64 cycle_time_extension = 0;
@@ -175,6 +188,7 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 	bool have_tc_entries = false;
 	int num_max_sdu_entries = 0;
 	struct rtattr *tail, *l;
+	int num_fp_entries = 0;
 	__u32 taprio_flags = 0;
 	__u32 txtime_delay = 0;
 	__s64 cycle_time = 0;
@@ -227,6 +241,23 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
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
@@ -369,7 +400,7 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 			  &cycle_time_extension, sizeof(cycle_time_extension));
 
 	if (have_tc_entries)
-		add_tc_entries(n, max_sdu, num_max_sdu_entries);
+		add_tc_entries(n, max_sdu, num_max_sdu_entries, fp, num_fp_entries);
 
 	l = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST | NLA_F_NESTED);
 
@@ -460,9 +491,10 @@ static int print_schedule(FILE *f, struct rtattr **tb)
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
@@ -481,23 +513,30 @@ static void dump_tc_entry(__u32 max_sdu[TC_QOPT_MAX_QUEUE],
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
 
@@ -505,18 +544,30 @@ static void dump_tc_entries(FILE *f, struct rtattr *opt)
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


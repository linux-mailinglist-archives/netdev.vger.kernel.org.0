Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D9C6E6015
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjDRLk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbjDRLkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:40:18 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2074.outbound.protection.outlook.com [40.107.14.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BB57A87
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:40:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdV04UqlMlnQDRAtdFDGI3bM5NluTglTtJ+M2wnfr6zgqEbmeAgZhbutr9s0WKDcqr8T7WiOUlBZ5e3AzTC/X+BhIp/DQMbdfHsV+euK09HQmtMW8SgYDlYeTcLiz6q7DlIszilanp1S5xPyD2aDkbOI2op32Kodv9FpfWlvpq4r/oM12XN7CHc43ztEtw9NCIwiavGZdyafsCQs91zY88pX0RYhmXwTNxv73rlDAzL5bt0n2/h5hTzWpZWLX91OG75Btl/rohwnhIwOYHOmvBt51HhuhkDKoiC1oDThYYHjrUHVZz2iu+ldeCRUb1/0n1ndSD/aLJDfIJlVHoA3uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JYHQMylBME+cyRTwOQeHNAv9TvPU3TuNC1NqrRZqbQ=;
 b=SUDlYphLAfsuCLFLnUIQp6EJRKgviqRnlhQuSltbxSJkaU8WIDwdVGkV0wxqR/MRZRIhnM+3c4fFpTU3wD3sSyO7ff6yy5yGy8inpGnc6+s+omC+ehbdyXYRx3h4rdJfo8To1lXMDe+AjP2/s+2NlzVh/SYiN1yiRNemzNieYvBN5sNkpfPeN5CtohTMRfqqzuJ61OJSLs+RVBKhpW4f7XvbAYZIdls5h1x4SdphVMatuBX/So/rwNCz2bOwKqLe4x4NuiE8jLaEgNdO5Xh4THFzL2mqfyI/+wOkfBh1VdiaB/Q5bOxvqBXqx3U8TMuAAy07xZHycANlSZEp5xcIgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JYHQMylBME+cyRTwOQeHNAv9TvPU3TuNC1NqrRZqbQ=;
 b=kdFX/DPSQNLeodU2RmccnfSadwIdD92sh0rIwMf9/CX8pFm3r1rnbL71d9wxjsvT+yufES7J59+WUEwoS/ouX4hTo7XkWi3iuZp5YiRkPnSPlMaQBDY4GduYkEEYHiAxrx9qWCJB8A68XFe0/Ik6AWmNLcr+bcH16phgoB2nqOw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8557.eurprd04.prod.outlook.com (2603:10a6:102:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Tue, 18 Apr
 2023 11:40:10 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:40:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 09/10] tc/mqprio: add support for preemptible traffic classes
Date:   Tue, 18 Apr 2023 14:39:52 +0300
Message-Id: <20230418113953.818831-10-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1e874259-94a8-4d43-8a7d-08db4001aac3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ohdicx+SaZ5nb4P3iAeSpnBvSRRh4ueRLo29Y7ZOdPKiYeyG7WhRN9pVU57X/Ss0OtOI+oGZ0nzQhq+hs+pP699oJpgtG0vGE3JpwU571zXoAIJFCRMBG3dnqKc3AaJee0OUXhEUv882mgSbEXyUKAdqVamuX65SCe0E58J6/s0+2UDr/zzCAZX0rZyFRRg7FfD4dyp/yDhPNWsF812yt4KU9fKbEd5jn4aTfStGDuKwQRfW8Ze0hWiQxBbD1B2jRvrI1tqMwf5rFB8OmswMPGs3cTQTacRZzgH7qG50P8yaHJ4+1ZdzA13LMH5hb5kSIpzlFwdL1skzXqAyP6joiz4SfEAfoSwh73xYVQNfbSIIyKwVHuMfb4/xyVd6dp8NXdsj9y4hS7x1rRUI1PAJGUvJD8Tzu+Je4ldwI66IVNAiC1aEUX/urq5REYHeGWMOZjN4XOZYW+pcaw2CGaCxKFBx0GdkHb7J4kfqqsXK+zT0gz22QWysuFq1zCLylZyHkCHjtKwHxMiGvji+xyV3j5XSpU2ujzGae7yV3dE4ThS+WRtRzxjis8UYnoTx0ZSMOKWdWvb0Z6nMiCOw9yk0dvUYlGRPM+oBEoGW3zDFhr2r9RKJbpZPCBbFp5Pa92Tn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(316002)(4326008)(66946007)(66556008)(66476007)(6916009)(478600001)(54906003)(8936002)(8676002)(5660300002)(44832011)(41300700001)(38100700002)(38350700002)(186003)(83380400001)(2616005)(6486002)(6666004)(52116002)(6512007)(6506007)(1076003)(26005)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cad5q8Lx6bQ4s6Xo10m9M+8BwRaRD5n3/9IQg2Qtx3+Iy9Ra4SfifcIPMWDq?=
 =?us-ascii?Q?VzH6IWvIfMV5eLZWlSHg9WQVaOpSD0U5CFcBdLrGhbM7KWccuAgCM/1dy3+Z?=
 =?us-ascii?Q?174xxrQgBwyFrphz+YU5MVaJsoQnQvNiV0a2yke0MejLvKEHQAlvHCsulqMP?=
 =?us-ascii?Q?8F29gpfPZ5MTNaJesNdeHBkMzGhmNBeyi7RCmMxmxrizu65fRR5ieit4opaW?=
 =?us-ascii?Q?s2Bk3sdIJwcA2H4x3+8zmMCKnBb88f4w9WMSiDOtQxrzL6xdSx38dP3UrIRD?=
 =?us-ascii?Q?eIuntO94f9KVCWmeHSjGehY2rBcSqQYP1m3TQUPKzSat8XS5jbvSoXu/FSg0?=
 =?us-ascii?Q?JB16HT8Vc3MiMkMfsrgZPhECQLHDRABcZAlkeS0Kcpr+747Jo1CZkYnNvQ6h?=
 =?us-ascii?Q?aLO5HQ5xyfYrFU3TpehrrrEDmzHtYe+kTl7HBctabtfn2w9K08J1edsMpjiu?=
 =?us-ascii?Q?4G3Kce414X1ewd+MUDFCN6rebV/96qlNrhkCMz4UYdTZOo2ALiVZhVuDmx3J?=
 =?us-ascii?Q?a2D1dxNV8gGluAoSd5lBythArnDLJdUwwWnqwUc15/Y++zUh+10tcWzS0MZO?=
 =?us-ascii?Q?9h39rt9hl8IjessDCHqWchM9M8i8854SNHE/3vGQJajsTO7CEiaWKfDh70xe?=
 =?us-ascii?Q?1ZIXkD9AtjHm3k2cPfgrUycFE09rzi2TyFZ3h+YWvqrWb5+/CEyWF7mESi+y?=
 =?us-ascii?Q?JBTlNVc0LjP2pwAglxmZrqsffsowOlOMROvs33FkwTltEpQ8kBupeHDBIE4e?=
 =?us-ascii?Q?7tdK9wlBn3rOjDnLVfOKN/KRaZeI1G/hTkmq7NGOqwePUewGK9sFY9KbdGZM?=
 =?us-ascii?Q?yUV5BEFqa3QzETvWuYdvHTK8qhP6IxnssjpmuhPqAODT/Y9fF96hRJ6CFjnJ?=
 =?us-ascii?Q?yYlFx9VF1RolFZ7KcwTqmRiGfTsDq2J3wNPK8Ug9XSgI1Iv2DAgegl5YGdlb?=
 =?us-ascii?Q?9PNS08Y4LK/vx6cEbrDBVW6YMyZRR3v9sDsbvEpdmgXe0ylvnBolVoHHpHUD?=
 =?us-ascii?Q?ID8YaYdWOZAzRoAnuFp8YiGWM7wW6yrA+G66dKRL8DWrZX8Juxhw6tnn/nrO?=
 =?us-ascii?Q?uBdSE+dheZSk116hKyNTapyHxW67Z2y1LYT/J0jsrvMNtiOM+OdM8YlhxMLA?=
 =?us-ascii?Q?Jbw+Nz24fT3RvBR8IljY+/iDlILdjJbc/y1nYNeJl2hvfS7d5EPqAFUL9Uu2?=
 =?us-ascii?Q?SYXDiVG4ovhfWXQxN03Ksq1IlbrfpYn2HFFh4u/6gQZBoueAy+xr8UFXY5Lh?=
 =?us-ascii?Q?Axie44KZFC4KKVxg/du+JzsFNi5ETNu8ZDUBCxRuRfQldEBmDA3K7p6dOLeA?=
 =?us-ascii?Q?qToIz1PbZqAY9bDHyo0kCz5YaWueOV5ENArYWRqD+vE6A+hc2claJ8/tPJRF?=
 =?us-ascii?Q?0h526aUpnWz5NXphqYEEdcEJiGCMpljbIfmRIcuMv2NnRYYV8tlo1FZwvQ/D?=
 =?us-ascii?Q?q+2ZdhnqgYiEwQI+iN61Nz9gTMeCkq4eVahqdn9MK8opo4ZNtBU6HwvaRCsX?=
 =?us-ascii?Q?a5cYQfZIfP8NQ8ftUtGpPnNH/+m/N3etbb4ayhHYxFN9olsNQNOwRwteIlsc?=
 =?us-ascii?Q?q0QBJwp9m9noYA4qVSs/VWpLZ6+w5m+Fsjhj8BoQIExYVIZpIRmYmFcv/lT+?=
 =?us-ascii?Q?xA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e874259-94a8-4d43-8a7d-08db4001aac3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:40:10.8347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0PrQ35AV1874D9NEinmxKMgwRr8kdDY+Rd1jWokvkYYKAps4/aQ9zktrA4fAbXGVALLHoK297Nl3Bvf9TmrWZw==
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

Add support for the "fp" argument in tc-mqprio, which takes an array
of letters "E" (for express) or "P" (for preemptible), one per traffic
class, and transforms them into TCA_MQPRIO_TC_ENTRY_FP u32 attributes of
the TCA_MQPRIO_TC_ENTRY nest. We also dump these new netlink attributes
when they come from the kernel.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: amended help text so that user space (kselftests) could detect
        the presence of the new feature

 man/man8/tc-mqprio.8 | 36 ++++++++++++++--
 tc/q_mqprio.c        | 99 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 132 insertions(+), 3 deletions(-)

diff --git a/man/man8/tc-mqprio.8 b/man/man8/tc-mqprio.8
index 3441cb68a27f..724ef906090c 100644
--- a/man/man8/tc-mqprio.8
+++ b/man/man8/tc-mqprio.8
@@ -30,9 +30,11 @@ dcb|bw_rlimit ]
 .B min_rate
 min_rate1 min_rate2 ... ] [
 .B max_rate
-max_rate1 max_rate2 ...
-.B ]
-
+max_rate1 max_rate2 ... ]
+.ti +8
+[
+.B fp
+FP0 FP1 FP2 ... ]
 
 .SH DESCRIPTION
 The MQPRIO qdisc is a simple queuing discipline that allows mapping
@@ -162,6 +164,34 @@ the
 argument is set to
 .B 'bw_rlimit'.
 
+.TP
+fp
+Selects whether traffic classes are express (deliver packets via the eMAC) or
+preemptible (deliver packets via the pMAC), according to IEEE 802.1Q-2018
+clause 6.7.2 Frame preemption. Takes the form of an array (one element per
+traffic class) with values being
+.B 'E'
+(for express) or
+.B 'P'
+(for preemptible).
+
+Multiple priorities which map to the same traffic class, as well as multiple
+TXQs which map to the same traffic class, must have the same FP attributes.
+To interpret the FP as an attribute per priority, the
+.B 'map'
+argument can be used for translation. To interpret FP as an attribute per TXQ,
+the
+.B 'queues'
+argument can be used for translation.
+
+Traffic classes are express by default. The argument is supported only with
+.B 'hw'
+set to 1. Preemptible traffic classes are accepted only if the device has a MAC
+Merge layer configurable through
+.BR ethtool(8).
+
+.SH SEE ALSO
+.BR ethtool(8)
 
 .SH EXAMPLE
 
diff --git a/tc/q_mqprio.c b/tc/q_mqprio.c
index 99c43491e0be..7a4417f5363b 100644
--- a/tc/q_mqprio.c
+++ b/tc/q_mqprio.c
@@ -23,12 +23,29 @@ static void explain(void)
 		"Usage: ... mqprio	[num_tc NUMBER] [map P0 P1 ...]\n"
 		"			[queues count1@offset1 count2@offset2 ...] "
 		"[hw 1|0]\n"
+		"			[fp FP0 FP1 FP2 ...]\n"
 		"			[mode dcb|channel]\n"
 		"			[shaper bw_rlimit SHAPER_PARAMS]\n"
 		"Where: SHAPER_PARAMS := { min_rate MIN_RATE1 MIN_RATE2 ...|\n"
 		"			  max_rate MAX_RATE1 MAX_RATE2 ... }\n");
 }
 
+static void add_tc_entries(struct nlmsghdr *n, __u32 fp[TC_QOPT_MAX_QUEUE],
+			   int num_fp_entries)
+{
+	struct rtattr *l;
+	__u32 tc;
+
+	for (tc = 0; tc < num_fp_entries; tc++) {
+		l = addattr_nest(n, 1024, TCA_MQPRIO_TC_ENTRY | NLA_F_NESTED);
+
+		addattr32(n, 1024, TCA_MQPRIO_TC_ENTRY_INDEX, tc);
+		addattr32(n, 1024, TCA_MQPRIO_TC_ENTRY_FP, fp[tc]);
+
+		addattr_nest_end(n, l);
+	}
+}
+
 static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
 			    char **argv, struct nlmsghdr *n, const char *dev)
 {
@@ -43,7 +60,10 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
 	__u64 min_rate64[TC_QOPT_MAX_QUEUE] = {0};
 	__u64 max_rate64[TC_QOPT_MAX_QUEUE] = {0};
 	__u16 shaper = TC_MQPRIO_SHAPER_DCB;
+	__u32 fp[TC_QOPT_MAX_QUEUE] = { };
 	__u16 mode = TC_MQPRIO_MODE_DCB;
+	bool have_tc_entries = false;
+	int num_fp_entries = 0;
 	int cnt_off_pairs = 0;
 	struct rtattr *tail;
 	__u32 flags = 0;
@@ -93,6 +113,21 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
 				idx++;
 				cnt_off_pairs++;
 			}
+		} else if (strcmp(*argv, "fp") == 0) {
+			while (idx < TC_QOPT_MAX_QUEUE && NEXT_ARG_OK()) {
+				NEXT_ARG();
+				if (strcmp(*argv, "E") == 0) {
+					fp[idx] = TC_FP_EXPRESS;
+				} else if (strcmp(*argv, "P") == 0) {
+					fp[idx] = TC_FP_PREEMPTIBLE;
+				} else {
+					PREV_ARG();
+					break;
+				}
+				num_fp_entries++;
+				idx++;
+			}
+			have_tc_entries = true;
 		} else if (strcmp(*argv, "hw") == 0) {
 			NEXT_ARG();
 			if (get_u8(&opt.hw, *argv, 10)) {
@@ -187,6 +222,9 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
 		addattr_l(n, 1024, TCA_MQPRIO_SHAPER,
 			  &shaper, sizeof(shaper));
 
+	if (have_tc_entries)
+		add_tc_entries(n, fp, num_fp_entries);
+
 	if (flags & TC_MQPRIO_F_MIN_RATE) {
 		struct rtattr *start;
 
@@ -218,6 +256,64 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
 	return 0;
 }
 
+static void dump_tc_entry(struct rtattr *rta, __u32 fp[TC_QOPT_MAX_QUEUE],
+			  int *max_tc_fp)
+{
+	struct rtattr *tb[TCA_MQPRIO_TC_ENTRY_MAX + 1];
+	__u32 tc, val = 0;
+
+	parse_rtattr_nested(tb, TCA_MQPRIO_TC_ENTRY_MAX, rta);
+
+	if (!tb[TCA_MQPRIO_TC_ENTRY_INDEX]) {
+		fprintf(stderr, "Missing tc entry index\n");
+		return;
+	}
+
+	tc = rta_getattr_u32(tb[TCA_MQPRIO_TC_ENTRY_INDEX]);
+	/* Prevent array out of bounds access */
+	if (tc >= TC_QOPT_MAX_QUEUE) {
+		fprintf(stderr, "Unexpected tc entry index %d\n", tc);
+		return;
+	}
+
+	if (tb[TCA_MQPRIO_TC_ENTRY_FP]) {
+		val = rta_getattr_u32(tb[TCA_MQPRIO_TC_ENTRY_FP]);
+		fp[tc] = val;
+
+		if (*max_tc_fp < (int)tc)
+			*max_tc_fp = tc;
+	}
+}
+
+static void dump_tc_entries(FILE *f, struct rtattr *opt, int len)
+{
+	__u32 fp[TC_QOPT_MAX_QUEUE] = {};
+	int max_tc_fp = -1;
+	struct rtattr *rta;
+	int tc;
+
+	for (rta = opt; RTA_OK(rta, len); rta = RTA_NEXT(rta, len)) {
+		if (rta->rta_type != (TCA_MQPRIO_TC_ENTRY | NLA_F_NESTED))
+			continue;
+
+		dump_tc_entry(rta, fp, &max_tc_fp);
+	}
+
+	if (max_tc_fp >= 0) {
+		open_json_array(PRINT_ANY,
+				is_json_context() ? "fp" : "\n             fp:");
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
+}
+
 static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 {
 	int i;
@@ -309,7 +405,10 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 				tc_print_rate(PRINT_ANY, NULL, "%s ", max_rate64[i]);
 			close_json_array(PRINT_ANY, "");
 		}
+
+		dump_tc_entries(f, RTA_DATA(opt) + RTA_ALIGN(sizeof(*qopt)), len);
 	}
+
 	return 0;
 }
 
-- 
2.34.1


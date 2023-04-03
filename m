Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B966D429D
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjDCKyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbjDCKxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:53:34 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D0B1166C
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 03:53:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKU2Z4tTncW9EWzoyMUHRfjmOHjmszBqiK1Ir/gpnRVPpOfrc/UC1H4lsSaS5hKTbgXlY7/Sff7sNb76X4+4X4YdhSohR4tsIyGr5Dxo2zJwryqfPjSr3sM3ZPRrkYgvxRw1EQOcLGHsaPIR107oop14dxSA+ndEPXG8uRa1DRwsrAAGFW0klOPpGyQSxbzzXJp9HJe2T40jSanoJpqRemRW1bHE5FsJkcPOOt1yYV3oVrkZBIr1eHRFtL+jP5NtsIdiVmEoTr/0H9E8nXyru4B4YxLmNUaXi0Dl0EBb8wX2bTMW6YzXcPPrbyn26TVwFfy1VFIjqinlrsIXdlbg5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XLJPmYrpLvkcx8Ch5BDBoVjb6FKaRmtoCBBeGtrk2ss=;
 b=SXdA3J+obeX+mIQEOY3kARu9mB9oKkdqWs+glSBMKOUKod7ZcvzrNcc6EEsuL2MTF9T8I9tyB8nFJu+UkyOwcjV4KDS130KVz9Xx7Br8qLt6IugmAf8S+E8FPIfGFbjGEQx+VYzlsr60AuXneOPduH2LgGH7LnCVrMheKiTM76DWyPQ6HCJYqTXWiiCop5HlOfsTagJIG6R8+i8RUnmXMBYoN7FybPza10AkcV7Ihzi+2HxD5c6xtIhVh7r9McJRaMtSiIfKSRM/QtcoZRlZQL2pcTJiwnsGl/BxIjfvC4LYMc6S+g4kSpNslZz2pNmhOAGkvtygt2dJhHgZ0YQrMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLJPmYrpLvkcx8Ch5BDBoVjb6FKaRmtoCBBeGtrk2ss=;
 b=E4iYDC+RfKZ2GBgPh6YhrIyfeb1bSCtlgDlfQrvIfNDJsbWIIN1qnl8m+W9COTtELVEAKpFFJRYRITUibJnHDknVPo4iGVnQ/jxMvDpgef2U96sEppyVND2YT1NNptLqn0aUOP6mqkDbOPVpsawW2tglcX8rbNLx3TgP7816flk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB8479.eurprd04.prod.outlook.com (2603:10a6:10:2c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 10:53:07 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:53:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 8/9] tc/mqprio: add support for preemptible traffic classes
Date:   Mon,  3 Apr 2023 13:52:44 +0300
Message-Id: <20230403105245.2902376-9-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: e02a76b8-d803-4150-81b2-08db34319bad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ISYdJp1VjcPI55IWGq+t3zneq0rmacOgjZ//92IDhDTzZJXrPX10GVciwkqIyZmHXfpXY17Z4o+WmZfk6jF5PlzhuXJ9zEGXbpT5JapXqSQIWRx8l7yx3WKJXYUNUXxdx4uwK7cHCZcaww4xtZtXAXCbDN8BwfzOojWlkvstP1Mc4KZBi/ieYUEggGnG2zXh6prjcv/wDW6Pte9d0ama1/Vg3OulP2c7UTQ0dskpFqCbuvdaP24GtmAz8yaf0zuEQchLV8R7qTMG8SUWcJdSOEYCuoOvNCStItqEIRsiiKTilkbE+0lc9a0Fi3HyhEy4zCrBfy6sMOW2r8ueDo0P9lRcnzxluPckYc2BdE2f+imWM2o38g1y1pjmjat6s7I1Lw33fqQ32wywLS8huwPwlD2u6lTlRV6VeCQiMCBIH+ArWPTQGxPSQSjOpry0+QS1KJ+fFeWzOnkkXFiYeWjVTAVipSEuqdyUG43rlg3pHmRHRYN/3sShkX1r4KYOYn6FfIbqGa1VNbieaui4lmJ6bpgfuCxDybIoqYzJqAZJwE6OzOcL5RnHYVMREIdqJdh2KPCV383GKH+X2addG/UwUlladUIM3cy6xm2R8qs+3MTXdaawkn+TlrdEotR2yDXG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(8676002)(6916009)(66556008)(66476007)(66946007)(54906003)(316002)(478600001)(8936002)(44832011)(41300700001)(5660300002)(38100700002)(38350700002)(4326008)(186003)(83380400001)(2616005)(52116002)(6486002)(6666004)(1076003)(26005)(6506007)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W7SGzuBSjhucqKLws55ZkpMZdB90aAZCzie1o/rbrAjWhCj8uLB8WhFmPBLd?=
 =?us-ascii?Q?jV9Xz4jSOp7C6F3D6ih5Bib0neQF8WJ8gaLXHlKjKLvl+MhbSGtfQ9fkbrK9?=
 =?us-ascii?Q?yn5FuZRTI5sVVSkH0jsdb55DweTuO0j1GiX3C/xaV1uHxuQ/WKY226d8nL1w?=
 =?us-ascii?Q?cdwcjPEbQZ/9xdpToFl++LnR9InLJkHRdXeGkUsc4WQHQKQ+VA1I2l61uZo8?=
 =?us-ascii?Q?GWUbUAE4oqxzXOK+ns9TMsQmO5zMJnmGRP8jYDVUKk6RQxdvF8Pu/Jo/EGrO?=
 =?us-ascii?Q?Q/4WVuXcIWAi6QVUSfbnMSgx5KileMm1F4Jkf6UgpT1SALZ6OHuBFzuRgiyR?=
 =?us-ascii?Q?ih2Q5tkj/Y176u2HIB8ySfT5GBfjeLeK1VbUlMgc4XXshdI3KtSh399eOAtO?=
 =?us-ascii?Q?sIx9ucnnYN1doz2fVokSFAvL5ZqN/qbkrWBRn8QfdcaTfuKXofcJarFLZKwP?=
 =?us-ascii?Q?BX/wN012hz6lvG+D5mc3bamJtoXJIYABIT/jsxplQK00cUEFz3XEC7KZkzBI?=
 =?us-ascii?Q?0WDlWKkmbCy5LdC5c5WaJvr4Wo4CMAyDj4L68WsxQJ3GPCBWEnC7fYF+IGna?=
 =?us-ascii?Q?ALtUBM+xOP+GY1QJKDWnubA9tuyP07mkS8b4jNeRe0mv+6nwiH6gNT7CWmGq?=
 =?us-ascii?Q?vncWIcJvV+t23a1NKBubR6j63G67hkqHW0kiSUl22td2JSkWStGM6Y5g87uM?=
 =?us-ascii?Q?YPrk4lIoZc68D8nxaLFbHAlfpwh6cgJnRt1AH7VgzxTH034lWHIOkic+qkma?=
 =?us-ascii?Q?6509V/S9SqAN/bvumYP5Dy8EezKOoM2oE1Bylqd+TxPDSh3DrdMv5inX4rVM?=
 =?us-ascii?Q?7a59eGE1bwbal/OyRQb+s9ZJe/670Qr3ijPcPIxpdujX68en+iD0fZaBEqLZ?=
 =?us-ascii?Q?GGRx462M7yE7kQE4F55G8+gIXQlCmoOkwsIRYIEiM7yDocrAUmIWj7R/omBg?=
 =?us-ascii?Q?XxTFZzzmoaXSVQqd9MMGOW+ZVDm2JF0KEdG+WTAON9XBzkXUJ/YkFstpHDP4?=
 =?us-ascii?Q?mI8fzLw2dQHDF84rnswTylPJo/k4Vj247TMs4bckXR/hunYDFa7Q7vzDDtgE?=
 =?us-ascii?Q?HVhDqjZX0Fl5cSDrvVXBfzsCbd1y8ez/widErx8lOplZEZ9riRpzfKQr9/v3?=
 =?us-ascii?Q?/48fIyf7PkxRTGpmDsyJFvHWd151Zf2H2lM3pEIprUOX8h8XN8Vs0sOoxrjX?=
 =?us-ascii?Q?BZ5XsAodz6zZKa/6vuzg2ZLw28zDcNHptpDkAu7IuJ2OIhQgXExYHFntxITj?=
 =?us-ascii?Q?bRrW0JBxkQz3Mg4isID1M2EGoDUX9sZi0+bNdeGmCerPFVnuy0HIyUVkz3GN?=
 =?us-ascii?Q?wn9FuEjJFp48kmtmcinVnRGGGHvGTkAb1JFqOIBFiHxczVPfQpqewYqC/r3x?=
 =?us-ascii?Q?06jHuaLR8sny8nU8BSVkNL9I9PGse5tX3WnnmyLGR0EzlSj55IE/fjZE/eLq?=
 =?us-ascii?Q?ngtFvdTtfMVW4HFXaFFagofcBlU1OEDhp0srzauyjvQE55Ksdd5P/E7rHjFW?=
 =?us-ascii?Q?ChXaxN5YknKH6SPzF0koXimozX78Xdd1I2gfVF4xjQRElUs8IDoqjSOOfcLT?=
 =?us-ascii?Q?lFFNn2GxKQgnZ0kImU8GlW8djpo1G3Hu3irJiE9fVnhyFAlqiARPWEG57Ae0?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e02a76b8-d803-4150-81b2-08db34319bad
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:53:07.4830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: goQSad1S/hAkbYTlLFxM8VngiipTpG/6WGOeDZdjSSeYa6UvuiLsglvUaZPhYbTDbc3VOW3rAQgmt2gPadzHfg==
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

Add support for the "fp" argument in tc-mqprio, which takes an array
of letters "E" (for express) or "P" (for preemptible), one per traffic
class, and transforms them into TCA_MQPRIO_TC_ENTRY_FP u32 attributes of
the TCA_MQPRIO_TC_ENTRY nest. We also dump these new netlink attributes
when they come from the kernel.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/tc-mqprio.8 | 36 ++++++++++++++--
 tc/q_mqprio.c        | 98 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 131 insertions(+), 3 deletions(-)

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
index 99c43491e0be..0ecb05a5613a 100644
--- a/tc/q_mqprio.c
+++ b/tc/q_mqprio.c
@@ -29,6 +29,22 @@ static void explain(void)
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
@@ -43,7 +59,10 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
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
@@ -93,6 +112,21 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
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
@@ -187,6 +221,9 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
 		addattr_l(n, 1024, TCA_MQPRIO_SHAPER,
 			  &shaper, sizeof(shaper));
 
+	if (have_tc_entries)
+		add_tc_entries(n, fp, num_fp_entries);
+
 	if (flags & TC_MQPRIO_F_MIN_RATE) {
 		struct rtattr *start;
 
@@ -218,6 +255,64 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
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
@@ -309,7 +404,10 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CF649C3E1
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 07:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237178AbiAZGzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 01:55:35 -0500
Received: from mail-co1nam11on2114.outbound.protection.outlook.com ([40.107.220.114]:37120
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237107AbiAZGze (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 01:55:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOr/XbByYppN5Qgk+y5931i602vqU8e9NlkRTjYjHab08I64nf/TlQ4q0BxBuCxZ9HxwwVXknY1yBN1S3zyoxXX9JXPSs1JwzmJFC7NUhy9AXV/dqkLtmfZli/4CVMYo0boPVtIofg4yw/j0fgVl1EbqmtbfB9D2hwNctGF9BLj0FH1P32ZOrPLfL0AhnpuFQS/HoEu9Ftb32B1ahA8pCz0GSefc9Ruv1Gn05ZNp2G3P2kT7KDxWvPdKZT/MFIl3TCwGVNFPPs9bEkOKtKUyrVjw8wyFfc/DqhHFoKEQ7KVp36LO1UvA6m+9M407JNyM8A2X71NnZRYQSIOIlv5U6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FuIWGCbUyiphrpR+Iu9cnF+EcKkpm6Rp9ql2L8cAN3E=;
 b=d6nuiwkPrutki1uOFQniUCzI0HXQpUqQjtd37XskXmwKM3gR954S1yF9CjjbWSWTcftvvx21tpOWVzlqeUuJJ/Aq8OxVMiHc6yI9CqYz5Euyx5Bj/HYhZmmS6XvUq4NNcuuO/bYjf3BOf2HYFjS5fiCoAi7yo+I8c8Q3j2zSLJpXAfe9NK4rFkM4/SBfFHEib/qbsHzR4a9SWZUNTKnqDfUrAQLdkjvdkwBQ47MaowOYzKfQD5St+K5LNSiBPmYgcTcPTaIcNehmu8qKVUu543EkBfDOywZRmLYIupvyAKWVtpLzIrOhjdgvvgXm9f8NTm5n4/8KdhkvY6/o5GLk+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FuIWGCbUyiphrpR+Iu9cnF+EcKkpm6Rp9ql2L8cAN3E=;
 b=U1eAuR0wHMtTpKP/lScrPqHJke16+b6xDNAfE17iAmb53svlWbtakt77H8Bao8Pf1rh2sdpfCK7SQEEd9cHbuVa74T2n4WfiAi12LCJTKvVPNZnGShe+A6E3dOEpjmVnLwAwQ65rJJjDnRIG47GV4GCpIUhceCkMSMOP8+z+J8E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from CY4PR1301MB2167.namprd13.prod.outlook.com
 (2603:10b6:910:43::20) by BN6PR13MB1105.namprd13.prod.outlook.com
 (2603:10b6:404:73::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Wed, 26 Jan
 2022 06:55:31 +0000
Received: from CY4PR1301MB2167.namprd13.prod.outlook.com
 ([fe80::c9cc:2e41:f4dc:bcb7]) by CY4PR1301MB2167.namprd13.prod.outlook.com
 ([fe80::c9cc:2e41:f4dc:bcb7%6]) with mapi id 15.20.4930.015; Wed, 26 Jan 2022
 06:55:31 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com, jhs@mojatatu.com,
        Victor Nogueira <victor@mojatatu.com>,
        baowen zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control action offload
Date:   Wed, 26 Jan 2022 14:54:39 +0800
Message-Id: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR04CA0085.apcprd04.prod.outlook.com
 (2603:1096:202:15::29) To CY4PR1301MB2167.namprd13.prod.outlook.com
 (2603:10b6:910:43::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f586023-291f-4230-f5a0-08d9e098d7cd
X-MS-TrafficTypeDiagnostic: BN6PR13MB1105:EE_
X-Microsoft-Antispam-PRVS: <BN6PR13MB11052C12DCCB6C0056500FB1E7209@BN6PR13MB1105.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wS/yIX4Ov04QlDByM7Mf3vbFG0OWrgwchCpCRFJ5jM7d7HOnvgYBZnvCyP/NgJ5Nf7CNfbHrlVqa2BWHmXXAng9J8Ih93F3TArLBM0Xsw9igJIA7SG5QX/RsIPOaJssrzdwm1ae85ZnaHwGmmdGvpC9LcgOXsHTqye/SLPkaENMLru0hIGMWUuMduSUBWOo8y7y82AvlDlLDqVQNcWqzT7Mzgs7o5uG3ODcrZwJStT2JIUINK05ZnWAjmaLW1NQsSMpCYY8g1JajcbLp5CUOpUoCK79PsTMJWjru1J7p4MSkIw8O40MVWqB4UQu1xUfopW/ePgqtCtpw+4bphQhuSVsPSnnM8fNv5rU2KC61qqnYck6Ve8/ydCIUjVn0C6GelAC6cBuypTOskvjL3x4sv3bu6DfBEje4r0QgVf2jy1vyYsATbj6yl6iswBMIKimGkAR3Yj4gZeTWoDNN2I3WfLcap0sjqst2JeL5scP2Ma5T58zgX4K4O6MzcO/6MHxUfEO5J/jVI56IfNXqrlLPSpNZbdHeBcYGFnqBqTvokV3u63liBz9RiSkffFD80fdn2e99yM75dx3XCHiTQu3flLJ/mNnHanqzlFQ9yJ1fmTbRylBrAZx5hZLyYVtyraThEb8UIlUI8lLdctulB1s21cvmViFDXUZrPPRS8HwBRyLcowVdo724Ue2rmu8GpOmCAaoMYO8O7lSMZ3Ufb6WHWNrFUxDnu4y7gs0XpinG3pjV1aXUY19DoLunu7Mg+YpX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1301MB2167.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(346002)(376002)(366004)(39830400003)(396003)(2616005)(107886003)(26005)(186003)(83380400001)(6512007)(4326008)(66476007)(38100700002)(36756003)(8936002)(66556008)(38350700002)(8676002)(66946007)(44832011)(86362001)(6506007)(6486002)(54906003)(5660300002)(6916009)(316002)(2906002)(508600001)(52116002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AZQu9XKVB5v8xsOvuFOBI64QMw0xI/G4p+I5WsE/8nZDPgLghKrxDxzHTk63?=
 =?us-ascii?Q?FDym7gK8mUvdm98SKNXOgAx6MvM35DXwB21Mpy5MnoOYLHBx0rINwOseU4bu?=
 =?us-ascii?Q?xbt811WCYaIJUvjVzEJePI1wouNuSJRg2zc+v/yqqBCZfEATLX9rODABKTNq?=
 =?us-ascii?Q?zVAjlUeZtwhZ1yy3c9BWxzB+txR5Zi0VjMLOQsFUjaJdm10PtQoEVrRdu6Gz?=
 =?us-ascii?Q?g/4MsmHpDuDIBmTK9AJZdcHq2FAIrJ05c4g5axdNP9YOGqZPYyPgdyxKSqlZ?=
 =?us-ascii?Q?XrHIsgqm4tO8A3S/RV+cdu09D66240iwFxZw9oDV+vcxV2Qrgg3ZkQ9KeQHR?=
 =?us-ascii?Q?h5l/37Z9ofpCb8nW2T5pZS5u6z5irscLBHnZpMb1dH5eLCaTHNQWcsv/n+jD?=
 =?us-ascii?Q?aC9Tl3tblXyvs3l8pKPp4fKWUiO21aLU/eQSN1EMsf4NkhmIZ2PHHXnrRL8r?=
 =?us-ascii?Q?fpnwF6e9Pdc/n4gfr9Bpm/+GIpXeW0XLCBU33m92jFuDlPBtOkD8evVKsAw1?=
 =?us-ascii?Q?hIGKbbsp2bbcHPlHnbAzVmAleMVr6y1gPrroBzE/wh9mg+K32J8ILI1p8lPA?=
 =?us-ascii?Q?B8ZfatTh6KOUCidFKtYxOjzTzsOp/udn1Zc3VrsfEEYZIszXK5HwmSljsNGx?=
 =?us-ascii?Q?bzkqHB50PmC4NFzApdxkyxerv64cpz7RoFRnNfwPK2JRVMwFPGjIG63C4HUr?=
 =?us-ascii?Q?RR1dhFq9K9bsleDjw1WOajCmHXh+x4CSQ4wV2Wyt/3WRmIzUr0fE+MQpXD6G?=
 =?us-ascii?Q?JeEYgDpEw1wvso/rStk5y5DswkZ1mimOSMWBs86s0zybxi3i47kv4cZtPjw6?=
 =?us-ascii?Q?NhMXiVKK9/4uCNjTndPWcMGFBLM7hR+YQFJSFgEDdnaNRZ+xBMS7C+mMX6T0?=
 =?us-ascii?Q?oYUdOmplaOkSwQJ4erBAehIQw93HnogujFNNYizhoBQz1uv6D7FDYE+SVi/x?=
 =?us-ascii?Q?JfEZk4X6KepFRWLYlHcKfAKMVTc2FH+nNmoilHERKJ1AaX05+56P7dyRJxBk?=
 =?us-ascii?Q?ZsosgEf9vlFXTB1VxSI/8gQEKtsoOxxbJ4j1EWlCRM6LXgjr3Ib7l76DIuOZ?=
 =?us-ascii?Q?gFRX+V1O+IIj9G0WVBVQjXPgPH7cARwNKsNeMEL+1L3cXN5hCAaGIZWB0cF+?=
 =?us-ascii?Q?+89Y+9h6jIkF9qQ42bLkt5FpfUTXdPQa/lAf8vkzBS0FFz5uHcABs/zQiD6v?=
 =?us-ascii?Q?Mfmb0FT/JX8JZWWLT0cB5YmYIet1SFQbRB4IxyasfURfu7Jz80s8lHMubs9d?=
 =?us-ascii?Q?G3JF+X5PVBZAuQarO4D7zTxe4EIN83/TmKrmV5pUTSOGVMu212wQZEMb9ZEA?=
 =?us-ascii?Q?raHp3CtG2psCPMafCeazt0g2wkPFXkTxKh9lPDgE1+T3jpORU+Wa47BAXtqA?=
 =?us-ascii?Q?nMnGSMLArgfU6dWkhPeeMT1pO1+XyTv6SLBXJZOUUq0xokqGPl9Sc9JqB03w?=
 =?us-ascii?Q?CJIMoPKwolpf90HOi3GObLzvgprFlfOmdpXusdLWeSv6rhNqWhpCQxw4wgIL?=
 =?us-ascii?Q?bkCZ1O5XtRaIJOtrNEhWcj6tvPkHjz21FDbJ12/t7d0eHcLjSPjAQF8JhdaC?=
 =?us-ascii?Q?f6k5KbhLP0GGFmFUplxcM9WCiz+ctXryWg2PEDCs1FoSx9yyKi/7zikmywCk?=
 =?us-ascii?Q?GAmJ0GFTpQgYjtqoo3PrhAtCjk2vL69beFJhE3Tu9x4hrWUeBK1hHTp5Cxzg?=
 =?us-ascii?Q?n1QBtLKHiVulJU9ojFO82+TlRtc=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f586023-291f-4230-f5a0-08d9e098d7cd
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1301MB2167.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 06:55:31.1760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Z0Y9sHQUSul9GoFUA+dWKVGi6qTiMXLfk+edPNGzzYFzkY+0p1LvzKZdLZQkr9P8kN9xiJA3LbxOyNa77+RGQpx9lM8HiwEhcWPzXSf4WU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB1105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add skip_hw and skip_sw flags for user to control whether
offload action to hardware.

Also we add hw_count to show how many hardwares accept to offload
the action.

Change man page to describe the usage of skip_sw and skip_hw flag.

An example to add and query action as below.

$ tc actions add action police rate 1mbit burst 100k index 100 skip_sw

$ tc -s -d actions list action police
total acts 1
    action order 0:  police 0x64 rate 1Mbit burst 100Kb mtu 2Kb action reclassify overhead 0b linklayer ethernet
    ref 1 bind 0  installed 2 sec used 2 sec
    Action statistics:
    Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
    backlog 0b 0p requeues 0
    skip_sw in_hw in_hw_count 1
    used_hw_stats delayed

Signed-off-by: baowen zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 man/man8/tc-actions.8 | 24 ++++++++++++++++++++
 tc/m_action.c         | 63 +++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 77 insertions(+), 10 deletions(-)

diff --git a/man/man8/tc-actions.8 b/man/man8/tc-actions.8
index 6f1c201..5c399cd 100644
--- a/man/man8/tc-actions.8
+++ b/man/man8/tc-actions.8
@@ -52,6 +52,8 @@ actions \- independently defined actions in tc
 .I HWSTATSSPEC
 ] [
 .I CONTROL
+] [
+.I SKIPSPEC
 ]
 
 .I ACTISPEC
@@ -99,6 +101,11 @@ Time since last update.
 .IR reclassify " | " pipe " | " drop " | " continue " | " ok
 }
 
+.I SKIPSPEC
+:= {
+.IR skip_sw " | " skip_hw
+}
+
 .I TC_OPTIONS
 These are the options that are specific to
 .B tc
@@ -270,6 +277,23 @@ Return to the calling qdisc for packet processing, and end classification of
 this packet.
 .RE
 
+.TP
+.I SKIPSPEC
+The
+.I SKIPSPEC
+indicates how
+.B tc
+should proceed when executing the action. Any of the following are valid:
+.RS
+.TP
+.B skip_sw
+Do not process action by software. If hardware has no offload support for this
+action, operation will fail.
+.TP
+.B skip_hw
+Do not process action by hardware.
+.RE
+
 .SH SEE ALSO
 .BR tc (8),
 .BR tc-bpf (8),
diff --git a/tc/m_action.c b/tc/m_action.c
index b16882a..b4cf94f 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -51,9 +51,10 @@ static void act_usage(void)
 		"	FL := ls | list | flush | <ACTNAMESPEC>\n"
 		"	ACTNAMESPEC :=  action <ACTNAME>\n"
 		"	ACTISPEC := <ACTNAMESPEC> <INDEXSPEC>\n"
-		"	ACTSPEC := action <ACTDETAIL> [INDEXSPEC] [HWSTATSSPEC]\n"
+		"	ACTSPEC := action <ACTDETAIL> [INDEXSPEC] [HWSTATSSPEC] [SKIPSPEC]\n"
 		"	INDEXSPEC := index <32 bit indexvalue>\n"
 		"	HWSTATSSPEC := hw_stats [ immediate | delayed | disabled ]\n"
+		"	SKIPSPEC := [ skip_sw | skip_hw ]\n"
 		"	ACTDETAIL := <ACTNAME> <ACTPARAMS>\n"
 		"		Example ACTNAME is gact, mirred, bpf, etc\n"
 		"		Each action has its own parameters (ACTPARAMS)\n"
@@ -245,6 +246,8 @@ int parse_action(int *argc_p, char ***argv_p, int tca_id, struct nlmsghdr *n)
 			goto done0;
 		} else {
 			struct action_util *a = NULL;
+			int skip_loop = 2;
+			__u32 flag = 0;
 
 			if (!action_a2n(*argv, NULL, false))
 				strncpy(k, "gact", sizeof(k) - 1);
@@ -314,13 +317,27 @@ done0:
 			}
 
 			if (*argv && strcmp(*argv, "no_percpu") == 0) {
+				flag |= TCA_ACT_FLAGS_NO_PERCPU_STATS;
+				NEXT_ARG_FWD();
+			}
+
+			/* we need to parse twice to fix skip flag out of order */
+			while (skip_loop--) {
+				if (*argv && strcmp(*argv, "skip_sw") == 0) {
+					flag |= TCA_ACT_FLAGS_SKIP_SW;
+					NEXT_ARG_FWD();
+				} else if (*argv && strcmp(*argv, "skip_hw") == 0) {
+					flag |= TCA_ACT_FLAGS_SKIP_HW;
+					NEXT_ARG_FWD();
+				}
+			}
+
+			if (flag) {
 				struct nla_bitfield32 flags =
-					{ TCA_ACT_FLAGS_NO_PERCPU_STATS,
-					  TCA_ACT_FLAGS_NO_PERCPU_STATS };
+					{ flag, flag };
 
 				addattr_l(n, MAX_MSG, TCA_ACT_FLAGS, &flags,
 					  sizeof(struct nla_bitfield32));
-				NEXT_ARG_FWD();
 			}
 
 			addattr_nest_end(n, tail);
@@ -396,13 +413,39 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
 					   strsz, b1, sizeof(b1)));
 		print_nl();
 	}
-	if (tb[TCA_ACT_FLAGS]) {
-		struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_ACT_FLAGS]);
+	if (tb[TCA_ACT_FLAGS] || tb[TCA_ACT_IN_HW_COUNT]) {
+		bool skip_hw = false;
+		if (tb[TCA_ACT_FLAGS]) {
+			struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_ACT_FLAGS]);
+
+			if (flags->selector & TCA_ACT_FLAGS_NO_PERCPU_STATS)
+				print_bool(PRINT_ANY, "no_percpu", "\tno_percpu",
+					   flags->value &
+					   TCA_ACT_FLAGS_NO_PERCPU_STATS);
+			if (flags->selector & TCA_ACT_FLAGS_SKIP_HW) {
+				print_bool(PRINT_ANY, "skip_hw", "\tskip_hw",
+					   flags->value &
+					   TCA_ACT_FLAGS_SKIP_HW);
+				skip_hw = !!(flags->value & TCA_ACT_FLAGS_SKIP_HW);
+			}
+			if (flags->selector & TCA_ACT_FLAGS_SKIP_SW)
+				print_bool(PRINT_ANY, "skip_sw", "\tskip_sw",
+					   flags->value &
+					   TCA_ACT_FLAGS_SKIP_SW);
+		}
+		if (tb[TCA_ACT_IN_HW_COUNT] && !skip_hw) {
+			__u32 count = rta_getattr_u32(tb[TCA_ACT_IN_HW_COUNT]);
+			if (count) {
+				print_bool(PRINT_ANY, "in_hw", "\tin_hw",
+					   true);
+				print_uint(PRINT_ANY, "in_hw_count",
+					   " in_hw_count %u", count);
+			} else {
+				print_bool(PRINT_ANY, "not_in_hw",
+					   "\tnot_in_hw", true);
+			}
+		}
 
-		if (flags->selector & TCA_ACT_FLAGS_NO_PERCPU_STATS)
-			print_bool(PRINT_ANY, "no_percpu", "\tno_percpu",
-				   flags->value &
-				   TCA_ACT_FLAGS_NO_PERCPU_STATS);
 		print_nl();
 	}
 	if (tb[TCA_ACT_HW_STATS])
-- 
1.8.3.1


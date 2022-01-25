Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C579249B20A
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347860AbiAYKee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 05:34:34 -0500
Received: from mail-bn8nam08on2098.outbound.protection.outlook.com ([40.107.100.98]:29824
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355388AbiAYK2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 05:28:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egBW+bMwYjlah6x/KIYxgUnChFVit0MLgTNp118yR4IhFqDk4vRRG/KMwtl5Ds9fuXZ/XvMjeaugr96fHXdquocN2NpRgzKVMUm0tNxKfor3LbrvPrInLn8pYA5si1ULXCzAkPjG+XwoTLjQJPFq6djM0ikDEdlpAAuuHKqjyJzH3Gsx7Qqhajpv7TKoNvwwUWGpMzYndvD8G6GaPZz/avDY8tu//YOTtyL1vFAcGUheIBRr/9UQvPvYGT91/1Hn48qML7B5CI4KL9go7/qty8toKI08Z8zwDgrf1ui/GY7LYU7S1hGV8mHQg0rQnKwWJQbq9N3CU31WckLftjwf1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cx5poso3WSUpoPYeDGuZFg2jMgzHedDntyk+dR/SE4g=;
 b=P2iEJP912wIlDpxnsMKIk3h7RRfo8I5lWmnl7CVnZWSMRU0bJpMYVh6SjMJmCJr5o+ZIKm3Li5ObaNe+zfCxetozvvQAGzMAG24dVSUOviGwJ1OH8mL1J8YmxKHR/0KAFol1wWdR9UvlvsElEr1Wt3FoqMHwc8Re03eYYfEoNpAo4aQw3/fJa+5M1yzHVQ5tOSQBAry0UCp0fuV6g/NwV6QDBi7NuvW36UoD3G8s9WV3UPjwq9UddEXw3zVoUqSIo5EsAQx0HLRvNAzM/tItboVp4hLf+EMyBlzRdRfDlsXD2iFBeb6B1DIawTFZE4248SZILELkFVTQP8Gqt8krFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cx5poso3WSUpoPYeDGuZFg2jMgzHedDntyk+dR/SE4g=;
 b=Iz+0Ez1pb9tAeYRCvjHFC+P7pJSK0wAR5Xfe/4/CY1G480V1ausPtwAO20ypyjt7pYvFZXU0OoOFvwpUv5qd9J+EYqRZnKUcIB2To2JgCenCTPPRe7U5eJJyufByXujiImJZrJPrsHOcAEXPyu6Zjf7fod32YE6jOC0tDdm9CDI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by MN2PR13MB4008.namprd13.prod.outlook.com (2603:10b6:208:26d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.4; Tue, 25 Jan
 2022 10:28:11 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::59fc:ab8c:b945:3109]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::59fc:ab8c:b945:3109%5]) with mapi id 15.20.4930.014; Tue, 25 Jan 2022
 10:28:11 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com, jhs@mojatatu.com,
        baowen zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH iproute2-next v1] tc: add skip_hw and skip_sw to control action offload
Date:   Tue, 25 Jan 2022 18:26:03 +0800
Message-Id: <1643106363-20246-1-git-send-email-baowen.zheng@corigine.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: HK0PR03CA0105.apcprd03.prod.outlook.com
 (2603:1096:203:b0::21) To DM5PR1301MB2172.namprd13.prod.outlook.com
 (2603:10b6:4:2d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2329649-8e88-4e89-4d56-08d9dfed6340
X-MS-TrafficTypeDiagnostic: MN2PR13MB4008:EE_
X-Microsoft-Antispam-PRVS: <MN2PR13MB4008FA2521CE5BE051C78A9CE75F9@MN2PR13MB4008.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6eWfCbhgZlgX5I934lWEdhjZ7/BE6XidOXxUs1IOoonZ5J0Ey1vbSOsFlOMRSc3FRXJbiRqFGOLghsYpsxVhEArga8jc565p/FSSkYFwy8TLKGbeXiAisZZKGZtqG7NX7RVFh4HnGAVKAy8j/0MVDJRowFoldaqUqRMvAUU+yQ9eXmLxuEiw4vGzHBoL71BWWUrfbOiFBcmaQ/rd8xKmGzeAedEKWtDEjE2098i+TB/nvAW5bAgZtiYShPKLt2M/RI0JZej8JsxBbzkkGyYYu6ggPbTEJ7+Drh2wE+m6H+DU/k1od/XyzG42SdMvSdD9+GIreYgtUSgAPy2/EOkp+9IJlY4kYxeAz7Ck82yIsWdz2in9NHuhFEPnfIlMmwnbWMHwZtOI5YDOSqGgKXjWOUoCGnry+H9nYnykbLhQIJ0d6Jm4ioOtNHfDu1u1M0W/DB08mTjBLMADiiQSnH5BPlwI34OVkNfVgPZlCqmBTTMvj89Te2oHH3ebQaQ4B42bePD9Cg/RwQTLbAsA8NwUdL9FX0Ocr9zQBgLCLBYU2Tu9SUxCalJ1oz3+Eb44MeJn0Hn8quMxx/PX09WGYDrQ6abeFyQrClWoxU3qyZ0v2/y0HZOMJC9rMjrRJsyxUvOJxKiqkbvhwxNGYgj1QAQbYz0KoeDIBnZCzMj848EPtrJavxI5RdhZ0Nwbm2YlzkzeOac7kHkk7M1MwVPdJqudfnngtfk9aDsIMob31n1HByQ0WxY+nh1CM7i19wnETh8M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(39830400003)(366004)(396003)(376002)(346002)(6512007)(6916009)(86362001)(107886003)(508600001)(5660300002)(2616005)(66556008)(4326008)(66476007)(8676002)(6506007)(8936002)(6486002)(52116002)(6666004)(66946007)(54906003)(316002)(36756003)(83380400001)(186003)(38100700002)(26005)(38350700002)(2906002)(44832011)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xk/Boo5U11lqjh6dc0OzgJUL7JUsdNc9I1lQnZTxJ/At+gQjx3jVZOBKcfn/?=
 =?us-ascii?Q?ja5GVeC9lBuY8ExytsCc+dgTmIl2rz9aSPd9EKBmL8I6Qnkpat2HRPcTfOl2?=
 =?us-ascii?Q?69xgfSIQoZj9941MyF5JMCx9xAoYwa1Uuq9om0vArgfw3ZAVQBJr+zn+3yua?=
 =?us-ascii?Q?Cakmw4te/1NQ/+fM0qRYf00ZopMesKAPecPEkq1OwFDIZlSiOAnSvZnPwnGo?=
 =?us-ascii?Q?a5wTIppfM46amp+i6lSPHPKMwH4OKckA5elNHjbB9EjwV85K42APmoym9NLZ?=
 =?us-ascii?Q?Dibl72IDcECarGVp7zbOQ93aQ3eV216eTIsjUtdDd3Ad+iLmnCw2ZBwx5Ar1?=
 =?us-ascii?Q?4vcu9mQe0BlKptWKDtr3/c8BQxvG7iDO/cEYJv/JzfN6EhivLayy5Wy7uesA?=
 =?us-ascii?Q?ImNrpJIdoduyNF1DdTcqJ7tc4wnUtwuljRMW69j6N1nTagcLo1zkHvbYkYIh?=
 =?us-ascii?Q?i+AZZxeNkAPrbOMad8w/8ZBH/yCtVcPiiZQXCb8yNPDfIP55dGRD0bh83wa9?=
 =?us-ascii?Q?eLHDUrY98FaJqf1klAxAZ6FgnKmIVPlBf+L4cJqOFkZdQhOArE3MsznSEdys?=
 =?us-ascii?Q?ljCiGN9+UyL3cOEBhCD2eLfL4Tqw3Bx6j6YH5/DRSpM7QP1VyixUu8YuSG0j?=
 =?us-ascii?Q?m6sxhKmoaL6y45YZMQKiuhLMcgFV4nsaAkw5yqypfVYLuI4yeDraWshQzkYk?=
 =?us-ascii?Q?VP/NTup7vdzy9eVLzjE2jq5aZQROhX6IWl8atUNqGlJLD0u6WmZ70HQ9DZD4?=
 =?us-ascii?Q?Ki0efPFxKYnzSEkyyOdDs5/s82uYI91R7ADbIWtoVnmElh8NLIrTEzQAzo2/?=
 =?us-ascii?Q?XtKM+QYmzZVxSX9dL5oJ8uuK5FYCDO9XpHUBITXMLG8Xe1H9vbIj8EwwAFwZ?=
 =?us-ascii?Q?guaZS0HD6/Q+kLEbEycobx5zuBDG2DAdWOb/qJD3iSjKNcSkP4bDirwsFnkn?=
 =?us-ascii?Q?DfNyt4GLgTMssGudsH2TmOX7Qt1+iUCq5Q/yg7L5AQvecpMg2NCqnRcCOAkv?=
 =?us-ascii?Q?Z1QmZn894vt5F9OtX/y+8vLeioGZXACHhbOclzARvyBpBZoSPP5ANJDCSzLn?=
 =?us-ascii?Q?CwAQVIAgaTcni2FCzXMkeoh5wLOkMD70YgfbNC2jAIEvSNljI+BTKpf3bVsp?=
 =?us-ascii?Q?dh96aQH91gHZ9NRbW0LuIchFzqoribIbb/JAjI3FP+KKCfGY39D4CQUUUXjl?=
 =?us-ascii?Q?xl9wnHJjmivfpKe3xPAK8T7yG54EzAWSkScLBWzWUBF9rP3oRVPIXyd/tfzU?=
 =?us-ascii?Q?CWHo9rmJbj8VAXrWnm6c0r0utaWLq1i9ej4G/aAOMVJvq+ODJlz5UqMgmvIG?=
 =?us-ascii?Q?kpbbaoTZXwx6VvtbzBdrucQkPurYwoIJEORhoP+1t9ockaWN+7N3KFXHyP5S?=
 =?us-ascii?Q?fqWlUeHUY7K1ZYYiTF0+9pNJHt7Zwz1QRDGh9pN05P1Y5xReL0GQQeHlmFEQ?=
 =?us-ascii?Q?AyR6zEhzh+s+VWY4GqZEhpSGSUfbGNsCT+AcsbwKPNzgthW9VR7txNpXpQOI?=
 =?us-ascii?Q?tjjufy0PeSgzcqs5cdeJsw0iT6sa9E3ODL9K/nmoyciL3xeKohaM8oJ4VUL8?=
 =?us-ascii?Q?x3P8xPOcsH/cGy7J7d5k876557Rz7BqRU+oRRbstVP5fpvrBjbwX/eW4KWXU?=
 =?us-ascii?Q?ljTWxONZVA+eI7sD2Pd5sEYG/g0pyVKPQkDXxb2c/Qq5cnG2srwoJMLQXoDN?=
 =?us-ascii?Q?28fjAQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2329649-8e88-4e89-4d56-08d9dfed6340
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 10:28:11.6443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MGuPsVQwanpB+dZr81bFXW2Y9nUUxS/CzJA+qvVsnCFl65nXXvSetJ8+gyithPtv26oxBqxKLWvDZfK7L5/Tad8xeRD6DpKchYBp307jnBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4008
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
index b16882a..b9fed6f 100644
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
@@ -210,12 +211,14 @@ int parse_action(int *argc_p, char ***argv_p, int tca_id, struct nlmsghdr *n)
 	struct rtattr *tail, *tail2;
 	char k[FILTER_NAMESZ];
 	int act_ck_len = 0;
+	__u32 flag = 0;
 	int ok = 0;
 	int eap = 0; /* expect action parameters */
 
 	int ret = 0;
 	int prio = 0;
 	unsigned char act_ck[TC_COOKIE_MAX_SIZE];
+	int skip_loop = 2;
 
 	if (argc <= 0)
 		return -1;
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


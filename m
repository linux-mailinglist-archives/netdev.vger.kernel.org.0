Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4455B8F7A
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 22:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiINUHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 16:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiINUHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 16:07:20 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF33D46602
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 13:07:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aN8x8f7dH5HM+QNyyR6IDLUyKcBBzrUytLrQDcCBhreXyJlxjky9G/JbZ3bTUDL8ESJtKpjNBVDL72Ui7ILaCt+qiKp4Odem+cbtLXL/YbFGg6evoTmkEemGdzgeRRQtQWjfRWS4pAcD73y/lRP892+apXh3k+qvD2est+/Y02jdSKPreSP6wA3EOFPd9j4sGa2MukL6zTUilo1LmVwqmb/XvA1/HU7uCg3kto5kkmytYhQ45waB4xp0K2zbrm62voB4DLjp5oBhDAJc1nAaXcMXbk1waRYh8yxmuz8olzwWq81fOUAQqByQ5l3aZDe5YjHkEY84DDIaUmXyLXEwUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAIN4CsSTsufxBHjKGAqRejSigzTn9GUNxN1bK3ubws=;
 b=CASPJuFDDzn53R0qg6bhTGQHp2E3YAKRh8I4ebKPx1wv9PeoqFq4sK292o9P6zP2Cm/FObdTG7ZQib3Zmt9JVVuS0JP+ZbRwIQeFEi8ag7QXuyoJeFbPcPcHLMv8RAYyd/sOxg7oZqN3iO086MxZv/w59jXcIWeozT2zHU5egZo9RvT87yjvsI6rNZeEsvm5uiUvtjsRoZ7Z5WhrjFQV1ICQB4OmZ6s5+i1IGpT1UBUhP0Z80H5YMA0fjzsWsXroYpmEvDbJ9CyiHZZB2mb/Nfs45QVXco1bDwYNSpdQLW7OipGzCKbmhT3p1u3whz+IJjoRZpsUp4cbu6JuLKJpXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAIN4CsSTsufxBHjKGAqRejSigzTn9GUNxN1bK3ubws=;
 b=ZUuJ7N5yUSESZzboL5P9MOLWltVMH7PmbhTJFawYldXxjQc+eKFqGX4UScREl68AQhSgThuCclToosTpF7t+uv6JH0tSd3Rp40+ZGP/LCFu+c5FMKQETju9vEiLQuo4/syaYc4Se+ljGQ+MUyjU4dcsfiIq/HUuu3MmjeC1LHZI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8137.eurprd04.prod.outlook.com (2603:10a6:10:244::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 20:07:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 20:07:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] taprio: support dumping and setting per-tc max SDU
Date:   Wed, 14 Sep 2022 23:07:06 +0300
Message-Id: <20220914200706.1961613-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0113.eurprd05.prod.outlook.com
 (2603:10a6:207:2::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8137:EE_
X-MS-Office365-Filtering-Correlation-Id: ecec5a12-e904-4761-65f1-08da968cb87b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O3PEUVk3CYmhtNMgfUZHI2LDXBNBq7cCBnY78uo3aVoCGgNNRKWS+YzfpUwuLRX7M77J5nft/pOklGSIgLrCPK2dMhyvMZ8xwA5D/AwDrNFUpkd8pecE0txQ8UwbPPGiiWrms0HOcRhd2F5J2i7tK9Tegsjhw3jfec7RBAoEHFUIbWUxRUQ83VCEMw9jR/vD8n5to7L49ARUkLT5VQLtBfnIJ+BYc5NA8FdpBDXLvUjqiiYoTZWwjf1uyYuCpgu+3eU8KCNWaWnUcyVrekZ1nmJz1IOVXeAoXnJzuFzw8IcL+H+Q7lNpzJaqYDORZprSmD3zgmXB/7/iaQbdQnuTiHQfOrF12k1Nn8GFjB07UYOJcKLI/SrfVQd0ZfJmMGO3UqAWkPUFAq3BQ+2zkIpCoSu6ASgvJsHXygI+B+Yy7eyl+sAcg7e2nTy5xEJNJIGxvghZnhzVtIP3wyLUIvSUfBmPpVXZ4DlC0mGVGqR1m+3o/+iKLEJT+XmvG8Vuge/6zLmXMvRpVWDUaHqRLD3y5tim5T4701/nIH0tgFiu1glFkC6EcAYb29PzYiMcXZqiua4CP6G+qIcQmAotwZOniADLemf5Vk5fyMLmkpREmlQcTAM6+GHP0f5KQhOlTcGphie1Wi393yb7jRlguUFKpkumzEhO4EdssAI5s3smjaYUjZC23SdEEZqh518RecLj1CX23ddT4c94tyFSwvrw3BFgW2i/PhhIWv3+c+4OF15oFP4fn18JABdt0OVg7lslB77VtNcmL8I2T7r42GkXH/phLVrKy3uJmGAZuKCWqMc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199015)(66476007)(2616005)(6506007)(8676002)(6486002)(2906002)(36756003)(6512007)(54906003)(186003)(86362001)(1076003)(52116002)(83380400001)(8936002)(38100700002)(38350700002)(5660300002)(6666004)(6916009)(44832011)(66556008)(316002)(66946007)(26005)(41300700001)(478600001)(966005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D3kFZfKfqGvERCsjlBKX+kz2Jz8zgv8qecZ44reRydeJgHTsyuALAFs/DocS?=
 =?us-ascii?Q?OfQprwfa8wVt+Nx5oIpuTt2s5d4gF3a2dmO9wCPZWDmqFN6BuIsC0HIN+0Uq?=
 =?us-ascii?Q?OGJsqcli5TuQEwkq4lB82WRPmRKzAaHfr2dgOk04hMwWnXI3VkpOlp89lXIr?=
 =?us-ascii?Q?i7Y95IKvR4l7/Vm1XYTnxgY0oAlWw8Oj9sfcTx1Xjq5Cgxo6rEPEHtnTsWlh?=
 =?us-ascii?Q?TjqkFnAL5Jcj1wx4b+shourIMxeG3zxXCyvp0lBtVbiRbYUvlUh9FwHTJAOK?=
 =?us-ascii?Q?KMeAR1AhwNSMMHPDCLas3dhAGsgvtYQh0hYs4EeGnQwLruePayufLbwRE1R+?=
 =?us-ascii?Q?dC/7OLNyEBhzZFsZDSg/+CRuXoubO2CLfbLpNdssHhHMuY4soMLqCUpGvQat?=
 =?us-ascii?Q?/cZ1rudtM7lUkWBLfwHO2igeqWYwi2zB+gyOgCBRbOYXKpyrl4d2JXyyCNib?=
 =?us-ascii?Q?zzGsmZG9Wu4JaU9MYFqC7Dy4Q/Yzhb4xKt4o/TUvTmHrgS7t9elMM7N5tDYQ?=
 =?us-ascii?Q?IaSwsOlaXH+i9ZnjTzJnSZG/zd0UAFG0Q61PaaBsTrJ8iBeTT3dTG4lNJLv2?=
 =?us-ascii?Q?50wYw08af6Ky2m7fLiE36VyQHUdmibFz3H0T/t7QnskkhidEAoGGroSrvmJ0?=
 =?us-ascii?Q?Tr4m+KneuYSOFnKswrnpJ+lHmg90XoGqLNJ3Ui1p/MN+3OH7yGr5ABhjvuVi?=
 =?us-ascii?Q?O85eH8q23d3Ovs+Q3l9LP/EgIehaAvF5ZjwsUi0eHFjdDgH00H9EWs9bZAIl?=
 =?us-ascii?Q?9nlht3pSvj8dZwEsWcbXf2NBo6Eh0IDLWz76yVNucZ4R3YtiFrMNKvtgBRek?=
 =?us-ascii?Q?0ccGMALc5bCEuNqxZLRH+ACSF1eCLgZweTWKH2kyHiq8I6MqnWbc3WKF7kcR?=
 =?us-ascii?Q?fvFaTi6uSjsw6+qhGrCkRRLMebceuIUWXEL7s+fov7kfno9oRpogABJeQVLE?=
 =?us-ascii?Q?fW+y6/gCrg78pwojXGlrB1CSHo1NfRZCx+/BDP2oLfsOJkNhqUZCLD3LTreJ?=
 =?us-ascii?Q?DNWhMzeDwkWLUK57q6ckAD0W2nIDYRFoTI1m6GzCGuCmhh34icM+r8TeZuGN?=
 =?us-ascii?Q?uiQKgo5jvlUTDMIFXnU2OPYNNseUEiKGQxzpwo6UhSgvodac8a6OpWk6F0Ox?=
 =?us-ascii?Q?WoyO5OKrexFdBmow9iKuCROq0wz0HgZJ+XGEvL6BX2pwUrBlrj+GDq1VDIZc?=
 =?us-ascii?Q?Lh70SiM8axPSHdm31Q2tZXAUuZKr7wfGviBMHpqkRBncReeM4mhlztNUkZTK?=
 =?us-ascii?Q?HQl4Cq3+FXBuG+ej2ZBZaF7OEll+iq89zf4d4HZcj0RW2vGw3Qi6mB5Y6861?=
 =?us-ascii?Q?FigbdIMKONyoYT8nts+PzJQxlhyn6iMDLyGjUIpt1G6WQwryZEDKJR+qXqEr?=
 =?us-ascii?Q?V94YTiZzOf0NJdfqFjdPi0VxkTp3inkHyuistsWRcNzchioHvriK4CNCKxOY?=
 =?us-ascii?Q?FIl/0O1PQbypf5+uQOxpMkDJTjvkNYm90pLNlokcOiVlwH3PlIeskQEQiNrK?=
 =?us-ascii?Q?Dqb0emgvkjhHSJyfrTmPtROj/zTgmjVKzLGPkQFf1tpc5QX4B0WXdcJTsIFO?=
 =?us-ascii?Q?cwwudleFZzw4kqDhLCqqF0zPtfVReO5EKKr1xazyhEuJvJy7OX93szwqPLO/?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecec5a12-e904-4761-65f1-08da968cb87b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 20:07:16.3216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: isqDNfb71gfX5NTrT7zUPpfowqlLU8CO/9uM4OPlvm4YZ1qomxSRMPYu7O+ujhwTshrrlWkQuz0JcjMH4qvGkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8137
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 802.1Q queueMaxSDU table is technically implemented in Linux as
the TCA_TAPRIO_TC_ENTRY_MAX_SDU attribute of the TCA_TAPRIO_ATTR_TC_ENTRY
nest. Multiple TCA_TAPRIO_ATTR_TC_ENTRY nests may appear in the netlink
message, one per traffic class. Other configuration items that are per
traffic class are also supposed to go there.

This is done for future extensibility of the netlink interface (I have
the feeling that the struct tc_mqprio_qopt passed through
TCA_TAPRIO_ATTR_PRIOMAP is not exactly extensible, which kind of defeats
the purpose of using netlink). But otherwise, the max-sdu is parsed from
the user, and printed, just like any other fixed-size 16 element array.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
This is the user space counterpart of:
https://patchwork.kernel.org/project/netdevbpf/cover/20220914153303.1792444-1-vladimir.oltean@nxp.com/

 include/uapi/linux/pkt_sched.h | 11 +++++
 man/man8/tc-taprio.8           |  9 ++++
 tc/q_taprio.c                  | 89 ++++++++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index f292b467b27f..000eec106856 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1232,6 +1232,16 @@ enum {
 #define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST	_BITUL(0)
 #define TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD	_BITUL(1)
 
+enum {
+	TCA_TAPRIO_TC_ENTRY_UNSPEC,
+	TCA_TAPRIO_TC_ENTRY_INDEX,		/* u32 */
+	TCA_TAPRIO_TC_ENTRY_MAX_SDU,		/* u32 */
+
+	/* add new constants above here */
+	__TCA_TAPRIO_TC_ENTRY_CNT,
+	TCA_TAPRIO_TC_ENTRY_MAX = (__TCA_TAPRIO_TC_ENTRY_CNT - 1)
+};
+
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,
 	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
@@ -1245,6 +1255,7 @@ enum {
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
 	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
 	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* u32 */
+	TCA_TAPRIO_ATTR_TC_ENTRY, /* nest */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
diff --git a/man/man8/tc-taprio.8 b/man/man8/tc-taprio.8
index d13c86f779b7..086b8f10c1c8 100644
--- a/man/man8/tc-taprio.8
+++ b/man/man8/tc-taprio.8
@@ -150,6 +150,15 @@ value should always be greater than the delta specified in the
 .BR etf(8)
 qdisc.
 
+.TP
+max-sdu
+.br
+Specifies an array containing at most 16 elements, one per traffic class, which
+corresponds to the queueMaxSDU table from IEEE 802.1Q-2018. Each array element
+represents the maximum L2 payload size that can egress that traffic class.
+Elements that are not filled in default to 0. The value 0 means that the
+traffic class can send packets up to the port's maximum MTU in size.
+
 .SH EXAMPLES
 
 The following example shows how an traffic schedule with three traffic
diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index e43db9d0e952..034428e7eaaa 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -151,13 +151,32 @@ static struct sched_entry *create_entry(uint32_t gatemask, uint32_t interval, ui
 	return e;
 }
 
+static void add_tc_entries(struct nlmsghdr *n,
+			   __u32 max_sdu[TC_QOPT_MAX_QUEUE])
+{
+	struct rtattr *l;
+	__u32 tc;
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
+		l = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_TC_ENTRY | NLA_F_NESTED);
+
+		addattr_l(n, 1024, TCA_TAPRIO_TC_ENTRY_INDEX, &tc, sizeof(tc));
+		addattr_l(n, 1024, TCA_TAPRIO_TC_ENTRY_MAX_SDU,
+			  &max_sdu[tc], sizeof(max_sdu[tc]));
+
+		addattr_nest_end(n, l);
+	}
+}
+
 static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 			    char **argv, struct nlmsghdr *n, const char *dev)
 {
+	__u32 max_sdu[TC_QOPT_MAX_QUEUE] = { };
 	__s32 clockid = CLOCKID_INVALID;
 	struct tc_mqprio_qopt opt = { };
 	__s64 cycle_time_extension = 0;
 	struct list_head sched_entries;
+	bool have_tc_entries = false;
 	struct rtattr *tail, *l;
 	__u32 taprio_flags = 0;
 	__u32 txtime_delay = 0;
@@ -211,6 +230,18 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 				free(tmp);
 				idx++;
 			}
+		} else if (strcmp(*argv, "max-sdu") == 0) {
+			while (idx < TC_QOPT_MAX_QUEUE && NEXT_ARG_OK()) {
+				NEXT_ARG();
+				if (get_u32(&max_sdu[idx], *argv, 10)) {
+					PREV_ARG();
+					break;
+				}
+				idx++;
+			}
+			for ( ; idx < TC_QOPT_MAX_QUEUE; idx++)
+				max_sdu[idx] = 0;
+			have_tc_entries = true;
 		} else if (strcmp(*argv, "sched-entry") == 0) {
 			uint32_t mask, interval;
 			struct sched_entry *e;
@@ -341,6 +372,9 @@ static int taprio_parse_opt(struct qdisc_util *qu, int argc,
 		addattr_l(n, 1024, TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION,
 			  &cycle_time_extension, sizeof(cycle_time_extension));
 
+	if (have_tc_entries)
+		add_tc_entries(n, max_sdu);
+
 	l = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST | NLA_F_NESTED);
 
 	err = add_sched_list(&sched_entries, n);
@@ -430,6 +464,59 @@ static int print_schedule(FILE *f, struct rtattr **tb)
 	return 0;
 }
 
+static void dump_tc_entry(__u32 max_sdu[TC_QOPT_MAX_QUEUE],
+			  struct rtattr *item, bool *have_tc_entries)
+{
+	struct rtattr *tb[TCA_TAPRIO_TC_ENTRY_MAX + 1];
+	__u32 tc, val = 0;
+
+	parse_rtattr_nested(tb, TCA_TAPRIO_TC_ENTRY_MAX, item);
+
+	if (!tb[TCA_TAPRIO_TC_ENTRY_INDEX]) {
+		fprintf(stderr, "Missing tc entry index\n");
+		return;
+	}
+
+	tc = rta_getattr_u32(tb[TCA_TAPRIO_TC_ENTRY_INDEX]);
+
+	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU])
+		val = rta_getattr_u32(tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]);
+
+	max_sdu[tc] = val;
+
+	*have_tc_entries = true;
+}
+
+static void dump_tc_entries(FILE *f, struct rtattr *opt)
+{
+	__u32 max_sdu[TC_QOPT_MAX_QUEUE] = {};
+	bool have_tc_entries = false;
+	struct rtattr *i;
+	int tc, rem;
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		max_sdu[tc] = 0;
+
+	rem = RTA_PAYLOAD(opt);
+
+	for (i = RTA_DATA(opt); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
+		if (i->rta_type != (TCA_TAPRIO_ATTR_TC_ENTRY | NLA_F_NESTED))
+			continue;
+
+		dump_tc_entry(max_sdu, i, &have_tc_entries);
+	}
+
+	if (!have_tc_entries)
+		return;
+
+	open_json_array(PRINT_ANY, "max-sdu");
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		print_uint(PRINT_ANY, NULL, " %u", max_sdu[tc]);
+	close_json_array(PRINT_ANY, "");
+
+	print_nl();
+}
+
 static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 {
 	struct rtattr *tb[TCA_TAPRIO_ATTR_MAX + 1];
@@ -501,6 +588,8 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		close_json_object();
 	}
 
+	dump_tc_entries(f, opt);
+
 	return 0;
 }
 
-- 
2.34.1


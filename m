Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2BB2227CD
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgGPPuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:50:18 -0400
Received: from mail-eopbgr30043.outbound.protection.outlook.com ([40.107.3.43]:21828
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728678AbgGPPuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 11:50:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYtIiTFgETrkLdnZGRVIfUmln6WDQWdUxKz02udaviPD4/xID60Ha1paXw7NA413PrX49p71WbmBhXdvuU8r7pO7l/XgScVo0SNwob7zJfmpHWTLQiEVtYANYJcJHnA4xpiXfbCR22f1aVmvczlMN9bmkFTGrH4GQloqijwwVMh2YBs5iQ/WE6BpIld2M/j3a3l9kgqDd5pBu+Cj+RFKzwj/gDDebtcXAxOOgvoBYDKJmj16vk7xwBbTYJiotIBTLrpHHuVU2CfxrW+XcQas0Fzh4AUpDe3zrgmZyxwwPteE+EyD42qbreN9VsTQ6/kGDwWa/7x7c/SRN21GFYttBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdaP5B/oBfwW01JJh3SN0oZvp5LBm38MwvQ7ue6AFgs=;
 b=VWvOlnx1H8BTlIuM3k4XnBSXgkr6TJzpAtXwrkMUfqwgq5pEn8aKDzatAGn5biCfrPqCsDq8OC8sLTY+rmC0V54NiDnDeawOqH62JR6hV0WSMcX2SCvPzNesBah4i3XujpmQIg2rc1ozGtajSljmL2sw/F+x37Em6+ZJboEUF4j3257GBWE99LjYDLTh9c+l2618wf5FI+PavQvsqbzFnxG31s+GNA4uxeGRIszjqkPiXSloXS0RtAHV5wT3OaLeM81aHhD+5l4z9iqT4rBsk1JsfUShHLkEG8qKeP21qRLCTPTeH1mNt/kH/ENC0FFM57U58MLW5Lw/1HEzKvrFnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdaP5B/oBfwW01JJh3SN0oZvp5LBm38MwvQ7ue6AFgs=;
 b=HEzzvG1HbM9rttAexgiIKTEtIDaL4nKIV9gViBy0e68a6CVpPrO9D2saDMeFSWo8i374skW2+GAVz+xrUPPU9XJk6Oz0pwob83fsOIaIAES9yd8HG+ylvF/Ef3BNOv/lV3GvxtlCqFTeiRJTeH1A9M0XxrXg5dm6dJsFk1RekeU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Thu, 16 Jul 2020 15:50:01 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 15:50:01 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v2 1/2] tc: Look for blocks in qevents
Date:   Thu, 16 Jul 2020 18:49:45 +0300
Message-Id: <7c8ba84ef268fd03e849829278db891a855f4c8e.1594914405.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594914405.git.petrm@mellanox.com>
References: <cover.1594914405.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0060.eurprd05.prod.outlook.com
 (2603:10a6:200:68::28) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4PR0501CA0060.eurprd05.prod.outlook.com (2603:10a6:200:68::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Thu, 16 Jul 2020 15:50:00 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 407d52cb-641b-4c3f-7f43-08d8299fe5ff
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3354603D610709AD5FF42EEADB7F0@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zp6VxtQ4jBhlWfWONAbdGm6GAWjYia3nmmemd7sbzk7ym0OOkfofmJ3G9bJofeu+MIyjdujyTRq0trYMyvbVw9SENoovWkRqY7Snpo5F0sTyiQmUEQHrg6ji+euR3peOYLIgXCG1D8APoFGWeAieIkcj5JgGFaqC+d4u/K+jxz4T5YkiH4e2F0ahO9zoCPDkzsUUiRltqTX1a+NqML06xNwNG0LrAD4sfe00+jmoKoEqge+UMv8kSIUeU2/nS31c75Bp3JrzhbF0c/YwNL8w0t6JaR5m82TVvcciTGFlNoNaexsOMOED1xYTcEW+Ts+eT1hfn6Vt1fQPMcAgvHAdCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(6916009)(478600001)(107886003)(54906003)(26005)(66946007)(16526019)(956004)(66476007)(2906002)(2616005)(66556008)(186003)(316002)(6486002)(8676002)(86362001)(6512007)(36756003)(6506007)(5660300002)(6666004)(8936002)(52116002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RX5ViE23UGg8pa6rGiS4bInxvYu6pqp8mKDlYejXW7TbIOKwK+2oVHJNNTRebyGDNQHirVlzm08/zjCso0JaMOvCXLcOI2+k1Vlo7ave3xPP7po50JUt2u0x2bFR58YyVmesIwE3pMTRsCRWiJ8m1fz7fR6Nbb/e3GxfaVtCS1d3TEKNEUuA1R9j3WhbqtPyaC1QvoD5fgIBuP+X24BFdm89B0n+GnkpicBlR+hHq1bkHyEXNv10aUms8arYRVbFZQgoY6mmBSED4d/cH15sc85m6ynBATLiNxFBEVYjYR9TqzEye5vbaRo8k47+2l4WdC7bHYxUEFUztrXT7DLuCWQ9Lb0PIe5Nl0UCVi6B2p4762IulnHQTc8PTjDpsowH265VOYAdAi+imgDL1VHShmKBv85qk4q+wGbGB8Z5/jucnBO2kxMIdpALuD84eKbKJM+bVue5wam/SbXXLlx9Qsz0Acdbxv97qlgnPXE1wdSbQm9oxsdnmN/kr6dgNMty
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 407d52cb-641b-4c3f-7f43-08d8299fe5ff
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 15:50:01.0939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bRMAOxktatjhhNPyd5TawNHWmi63jj36XEZKTnDSE2EKWNVGC7J3uknuctmZL7gnXgAyReGVSZgbIUmyDv734Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a list of filters at a given block is requested, tc first validates
that the block exists before doing the filter query. Currently the
validation routine checks ingress and egress blocks. But now that blocks
can be bound to qevents as well, qevent blocks should be looked for as
well.

In order to support that, extend struct qdisc_util with a new callback,
has_block. That should report whether, give the attributes in TCA_OPTIONS,
a blocks with a given number is bound to a qevent. In
tc_qdisc_block_exists_cb(), invoke that callback when set.

Add a helper to the tc_qevent module that walks the list of qevents and
looks for a given block. This is meant to be used by the individual qdiscs.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v2:
    - In tc_qdisc_block_exists_cb(), do not initialize 'q'.
    - Propagate upwards errors from q->has_block.

 tc/tc_qdisc.c  | 14 ++++++++++++++
 tc/tc_qevent.c | 15 +++++++++++++++
 tc/tc_qevent.h |  2 ++
 tc/tc_util.h   |  2 ++
 4 files changed, 33 insertions(+)

diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index 8eb08c34..e917280f 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -478,6 +478,9 @@ static int tc_qdisc_block_exists_cb(struct nlmsghdr *n, void *arg)
 	struct tcmsg *t = NLMSG_DATA(n);
 	struct rtattr *tb[TCA_MAX+1];
 	int len = n->nlmsg_len;
+	struct qdisc_util *q;
+	const char *kind;
+	int err;
 
 	if (n->nlmsg_type != RTM_NEWQDISC)
 		return 0;
@@ -506,6 +509,17 @@ static int tc_qdisc_block_exists_cb(struct nlmsghdr *n, void *arg)
 		if (block == ctx->block_index)
 			ctx->found = true;
 	}
+
+	kind = rta_getattr_str(tb[TCA_KIND]);
+	q = get_qdisc_kind(kind);
+	if (!q)
+		return -1;
+	if (q->has_block) {
+		err = q->has_block(q, tb[TCA_OPTIONS], ctx->block_index, &ctx->found);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/tc/tc_qevent.c b/tc/tc_qevent.c
index 1f8e6506..2c010fcf 100644
--- a/tc/tc_qevent.c
+++ b/tc/tc_qevent.c
@@ -92,6 +92,21 @@ void qevents_print(struct qevent_util *qevents, FILE *f)
 		close_json_array(PRINT_ANY, "");
 }
 
+bool qevents_have_block(struct qevent_util *qevents, __u32 block_idx)
+{
+	if (!qevents)
+		return false;
+
+	for (; qevents->id; qevents++) {
+		struct qevent_base *qeb = qevents->data;
+
+		if (qeb->block_idx == block_idx)
+			return true;
+	}
+
+	return false;
+}
+
 int qevents_dump(struct qevent_util *qevents, struct nlmsghdr *n)
 {
 	int err;
diff --git a/tc/tc_qevent.h b/tc/tc_qevent.h
index 574e7cff..d60c3f75 100644
--- a/tc/tc_qevent.h
+++ b/tc/tc_qevent.h
@@ -2,6 +2,7 @@
 #ifndef _TC_QEVENT_H_
 #define _TC_QEVENT_H_
 
+#include <stdbool.h>
 #include <linux/types.h>
 #include <libnetlink.h>
 
@@ -37,6 +38,7 @@ int qevent_parse(struct qevent_util *qevents, int *p_argc, char ***p_argv);
 int qevents_read(struct qevent_util *qevents, struct rtattr **tb);
 int qevents_dump(struct qevent_util *qevents, struct nlmsghdr *n);
 void qevents_print(struct qevent_util *qevents, FILE *f);
+bool qevents_have_block(struct qevent_util *qevents, __u32 block_idx);
 
 struct qevent_plain {
 	struct qevent_base base;
diff --git a/tc/tc_util.h b/tc/tc_util.h
index edc39138..c8af4e95 100644
--- a/tc/tc_util.h
+++ b/tc/tc_util.h
@@ -5,6 +5,7 @@
 #define MAX_MSG 16384
 #include <limits.h>
 #include <linux/if.h>
+#include <stdbool.h>
 
 #include <linux/pkt_sched.h>
 #include <linux/pkt_cls.h>
@@ -40,6 +41,7 @@ struct qdisc_util {
 	int (*parse_copt)(struct qdisc_util *qu, int argc,
 			  char **argv, struct nlmsghdr *n, const char *dev);
 	int (*print_copt)(struct qdisc_util *qu, FILE *f, struct rtattr *opt);
+	int (*has_block)(struct qdisc_util *qu, struct rtattr *opt, __u32 block_idx, bool *p_has);
 };
 
 extern __u16 f_proto;
-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0EA20BCEA
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgFZWq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:46:56 -0400
Received: from mail-am6eur05on2082.outbound.protection.outlook.com ([40.107.22.82]:6168
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725883AbgFZWq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 18:46:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4qJ7q6TYokHcDO38G+yS4P4b90h94MN820Z1eth72hPGp562CBnTkyJmEXsuct53KUh4Jb3GRtaa2pXSvOHou3bAMzHFg1dmslbJLr41WZTj4ul28fX/TaZ24vaTVpdsCBQEgz3qLv9NSQyxjVR3BJmu4/YXHxORSY+6CEVnPN4/K7kS4PJsaZlxrYO3D3D0raKZd8076/t8gb7KQGOwLmobwj1bco6XQ/4bH31mNbI52Orj/qdrU3IjrIGj6yT3O+em7Ovv+fwRndr/zbF7bXr09Mhk8iKn7It4+U8WkBMYxafrT0/q8EglT7OUeVkMnpYGXAPOcWi+A6Ez29QnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUVcaCQdJlQbz8ULpfnrRQ9M6rGk1trJ7w+kZNXgnq4=;
 b=ElELP9PfJ+NavXOHomzpgA/lqgTbkyZk+2NcTIWnbR6WFQ0sdXnQtMObTAatkV4og3XLM4vR1F7/t48C4HonKG3oW5/3RI/vPn7NA76knOvAE/JVeGboLolfoHvJWfhxooE+VUtGPkpBEUyJ0m5DjVqzr86URaSe9qnwu/wE2KEz6vNg07NaaoC4jArsxPlDI4AxbuJO8pZ/+oqa/ukTDuuQ3GqfHW8fH1chws5d6k7p52cmrOCjrHJoQ6MwqLwFx8iIWGEEyvC2VXAW60y/dCAnX9bk1VE7vbWKAVGWfHpxp3+QRRNehSTGZZ4RGlIv3Is3scnplBgwe2V1mNgjcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUVcaCQdJlQbz8ULpfnrRQ9M6rGk1trJ7w+kZNXgnq4=;
 b=rdEPnVQqN9SLeHG8mUicQCwRPO+W8oXePbg+RcGxfSVk2QOZOJhE3g9d7AHg14aMj3n0WTmQJI6xgN1f/E3IAG3Xn8xD4FAXB6hEEoEd982JDlXxUosFkaqjbJ1TUqtuiTZy3v8vRvlgeFDiciS5qvTfL0d3Tz0ca/xMym8urSE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3196.eurprd05.prod.outlook.com (2603:10a6:7:33::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.21; Fri, 26 Jun 2020 22:46:19 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 22:46:19 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jiri@mellanox.com,
        idosch@mellanox.com, Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v1 2/4] tc: Add helpers to support qevent handling
Date:   Sat, 27 Jun 2020 01:45:31 +0300
Message-Id: <e43813643a02858bb5e4ff13d0c2d5bb2f97a9c4.1593211071.git.petrm@mellanox.com>
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
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:207:3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 22:46:18 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fb4ac406-e58b-458b-29f5-08d81a22be0b
X-MS-TrafficTypeDiagnostic: HE1PR05MB3196:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3196D8E6BA2ADFB36B22EEFDDB930@HE1PR05MB3196.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:374;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IcLKm1Z34OKjCAX4lQGvsZsJsTno66Wrt42iihqqenvMlgQeoqJI8yW0TF6Axv2ew8ioQy1RTc8pSgCUypPWB07zoKuYlMwX6yDbyHc3dL9VZuITtDfMWnHPYo3InPOzq/QjnkjqVrzFOzcdjHpCz+NSf8Un5aPVfx19yE+InsRq19l9L1ReT0ir+6ECvGMeUq2agDBnYyM0u1huQysgnTKNkbxRjqLb6scW83PMPjC3ckWGCMLSLbe4zE/GEXgbgThtpeEIvFRLmkF27PJ/CBGz13k3txewfGpwJ01Y12QJfXuArXq0i/P+HcMcRWy1OZqRRK3JCjiV9mu6x9MDQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(5660300002)(66476007)(8676002)(956004)(54906003)(52116002)(2616005)(6666004)(83380400001)(4326008)(6512007)(2906002)(26005)(8936002)(6916009)(107886003)(66556008)(36756003)(478600001)(86362001)(66946007)(186003)(316002)(6486002)(6506007)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yzGQZjNUTYvnZMxwZXzv7lfvIk1BFflU1M1dZ9fxqkLNoP1PnFWZiVNcO3w/aepqGKDV+a0XXrXB7P6RREFb5m77Yb1GOEW7rhFE7fCoRdLhCkKMOGS8+f61GPsRYuLhp53r+OAgYOKC/agmXOPpKIHqWL9vNN3DFgFYj8y2je1/ZE4CTuT0h9Oq61yKKGPMQQsgXpR6Qo3jNy3/fp5otDsBGsr8WJ2aeycYnn4e5qUsjCQekys6MZSZ0WSQMYZtCd16csU/MKsCrsiQ17XNve/jUQdsKlIq41gtWP3/QVXIJsKx/SYnI8Ipuz0QYEekzrTEFK4Ijrs4LFHH0XezWPh2wN/veJ3PAUfVbUK0QqJaRKKN7S2RKPj1X5rF7yUOIPFmoAPZcSkroBSIfpSAIKsH3a4Cicr/CwOjrh6DYaTixzC7kKew9EImkOGXxfRj/7exgP+aiuWRI8mLovhLPz/UmXqzZmcKg3xRjfy0kF0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb4ac406-e58b-458b-29f5-08d81a22be0b
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 22:46:19.6375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YIluPUqbVWEBbM7zO/npwYrWj+14pT5rFzcuKQLOQ4bXBRZQqgr8ULcxcwc2RH3ICdlqQWUTR2U8s6iJ7vmiXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a set of helpers to make it easy to add support for qevents into
qdisc.

The idea behind this is that qevent types will be generally reused between
qdiscs, rather than each having a completely idiosyncratic set of qevents.
The qevent module holds functions for parsing, dumping and formatting of
these common qevent types, and for dispatch to the appropriate set of
handlers based on the qevent name.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 tc/Makefile    |   1 +
 tc/tc_qevent.c | 202 +++++++++++++++++++++++++++++++++++++++++++++++++
 tc/tc_qevent.h |  49 ++++++++++++
 3 files changed, 252 insertions(+)
 create mode 100644 tc/tc_qevent.c
 create mode 100644 tc/tc_qevent.h

diff --git a/tc/Makefile b/tc/Makefile
index 79c9c1dd..5a517af2 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -122,6 +122,7 @@ TCLIB += tc_red.o
 TCLIB += tc_cbq.o
 TCLIB += tc_estimator.o
 TCLIB += tc_stab.o
+TCLIB += tc_qevent.o
 
 CFLAGS += -DCONFIG_GACT -DCONFIG_GACT_PROB
 ifneq ($(IPT_LIB_DIR),)
diff --git a/tc/tc_qevent.c b/tc/tc_qevent.c
new file mode 100644
index 00000000..1f8e6506
--- /dev/null
+++ b/tc/tc_qevent.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+
+/*
+ * Helpers for handling qevents.
+ */
+
+#include <stdio.h>
+#include <string.h>
+
+#include "tc_qevent.h"
+#include "utils.h"
+
+void qevents_init(struct qevent_util *qevents)
+{
+	if (!qevents)
+		return;
+
+	for (; qevents->id; qevents++)
+		memset(qevents->data, 0, qevents->data_size);
+}
+
+int qevent_parse(struct qevent_util *qevents, int *p_argc, char ***p_argv)
+{
+	char **argv = *p_argv;
+	int argc = *p_argc;
+	const char *name = *argv;
+	int err;
+
+	if (!qevents)
+		goto out;
+
+	for (; qevents->id; qevents++) {
+		if (strcmp(name, qevents->id) == 0) {
+			NEXT_ARG();
+			err = qevents->parse_qevent(qevents, &argc, &argv);
+			if (err)
+				return err;
+
+			*p_argc = argc;
+			*p_argv = argv;
+			return 0;
+		}
+	}
+
+out:
+	fprintf(stderr, "Unknown qevent `%s'\n", name);
+	return -1;
+}
+
+int qevents_read(struct qevent_util *qevents, struct rtattr **tb)
+{
+	int err;
+
+	if (!qevents)
+		return 0;
+
+	for (; qevents->id; qevents++) {
+		if (tb[qevents->attr]) {
+			err = qevents->read_qevent(qevents, tb);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+void qevents_print(struct qevent_util *qevents, FILE *f)
+{
+	int first = true;
+
+	if (!qevents)
+		return;
+
+	for (; qevents->id; qevents++) {
+		struct qevent_base *qeb = qevents->data;
+
+		if (qeb->block_idx) {
+			if (first) {
+				open_json_array(PRINT_JSON, "qevents");
+				first = false;
+			}
+
+			open_json_object(NULL);
+			print_string(PRINT_ANY, "kind", " qevent %s", qevents->id);
+			qevents->print_qevent(qevents, f);
+			close_json_object();
+		}
+	}
+
+	if (!first)
+		close_json_array(PRINT_ANY, "");
+}
+
+int qevents_dump(struct qevent_util *qevents, struct nlmsghdr *n)
+{
+	int err;
+
+	if (!qevents)
+		return 0;
+
+	for (; qevents->id; qevents++) {
+		struct qevent_base *qeb = qevents->data;
+
+		if (qeb->block_idx) {
+			err = qevents->dump_qevent(qevents, n);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+static int parse_block_idx(const char *arg, struct qevent_base *qeb)
+{
+	if (qeb->block_idx) {
+		fprintf(stderr, "Qevent block index already specified\n");
+		return -1;
+	}
+
+	if (get_unsigned(&qeb->block_idx, arg, 10) || !qeb->block_idx) {
+		fprintf(stderr, "Illegal qevent block index\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int read_block_idx(struct rtattr *attr, struct qevent_base *qeb)
+{
+	if (qeb->block_idx) {
+		fprintf(stderr, "Qevent block index already specified\n");
+		return -1;
+	}
+
+	qeb->block_idx = rta_getattr_u32(attr);
+	if (!qeb->block_idx) {
+		fprintf(stderr, "Illegal qevent block index\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static void print_block_idx(FILE *f, __u32 block_idx)
+{
+	print_uint(PRINT_ANY, "block", " block %u", block_idx);
+}
+
+int qevent_parse_plain(struct qevent_util *qu, int *p_argc, char ***p_argv)
+{
+	struct qevent_plain *qe = qu->data;
+	char **argv = *p_argv;
+	int argc = *p_argc;
+
+	if (qe->base.block_idx) {
+		fprintf(stderr, "Duplicate qevent\n");
+		return -1;
+	}
+
+	while (argc > 0) {
+		if (strcmp(*argv, "block") == 0) {
+			NEXT_ARG();
+			if (parse_block_idx(*argv, &qe->base))
+				return -1;
+		} else {
+			break;
+		}
+		NEXT_ARG_FWD();
+	}
+
+	if (!qe->base.block_idx) {
+		fprintf(stderr, "Unspecified qevent block index\n");
+		return -1;
+	}
+
+	*p_argc = argc;
+	*p_argv = argv;
+	return 0;
+}
+
+int qevent_read_plain(struct qevent_util *qu, struct rtattr **tb)
+{
+	struct qevent_plain *qe = qu->data;
+
+	return read_block_idx(tb[qu->attr], &qe->base);
+}
+
+void qevent_print_plain(struct qevent_util *qu, FILE *f)
+{
+	struct qevent_plain *qe = qu->data;
+
+	print_block_idx(f, qe->base.block_idx);
+}
+
+int qevent_dump_plain(struct qevent_util *qu, struct nlmsghdr *n)
+{
+	struct qevent_plain *qe = qu->data;
+
+	return addattr32(n, 1024, qu->attr, qe->base.block_idx);
+}
diff --git a/tc/tc_qevent.h b/tc/tc_qevent.h
new file mode 100644
index 00000000..574e7cff
--- /dev/null
+++ b/tc/tc_qevent.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TC_QEVENT_H_
+#define _TC_QEVENT_H_
+
+#include <linux/types.h>
+#include <libnetlink.h>
+
+struct qevent_base {
+	__u32 block_idx;
+};
+
+struct qevent_util {
+	const char *id;
+	int (*parse_qevent)(struct qevent_util *qu, int *argc, char ***argv);
+	int (*read_qevent)(struct qevent_util *qu, struct rtattr **tb);
+	void (*print_qevent)(struct qevent_util *qu, FILE *f);
+	int (*dump_qevent)(struct qevent_util *qu, struct nlmsghdr *n);
+	size_t data_size;
+	void *data;
+	int attr;
+};
+
+#define QEVENT(_name, _form, _data, _attr)				\
+	{								\
+		.id = _name,						\
+		.parse_qevent = qevent_parse_##_form,			\
+		.read_qevent = qevent_read_##_form,			\
+		.print_qevent = qevent_print_##_form,			\
+		.dump_qevent = qevent_dump_##_form,			\
+		.data_size = sizeof(struct qevent_##_form),		\
+		.data = _data,						\
+		.attr = _attr,						\
+	}
+
+void qevents_init(struct qevent_util *qevents);
+int qevent_parse(struct qevent_util *qevents, int *p_argc, char ***p_argv);
+int qevents_read(struct qevent_util *qevents, struct rtattr **tb);
+int qevents_dump(struct qevent_util *qevents, struct nlmsghdr *n);
+void qevents_print(struct qevent_util *qevents, FILE *f);
+
+struct qevent_plain {
+	struct qevent_base base;
+};
+int qevent_parse_plain(struct qevent_util *qu, int *p_argc, char ***p_argv);
+int qevent_read_plain(struct qevent_util *qu, struct rtattr **tb);
+void qevent_print_plain(struct qevent_util *qu, FILE *f);
+int qevent_dump_plain(struct qevent_util *qu, struct nlmsghdr *n);
+
+#endif
-- 
2.20.1


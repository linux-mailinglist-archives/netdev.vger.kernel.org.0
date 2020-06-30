Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42E620F271
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732246AbgF3KRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:17:09 -0400
Received: from mail-vi1eur05on2088.outbound.protection.outlook.com ([40.107.21.88]:6261
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732220AbgF3KRG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 06:17:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnwA4WTNs9AqgmUcuLihwQPbbiSXABvwcgv5K0b4KK5OzQU7liJKsjSKG+rReRyxWrebEc0niJVDrwxR3Nz/Xh5Pl5IcYUiQfwiLsULVALlD6FTFf2hSCSoxb+FjPr3KcUh6ITVcnjUABhzSh77zsIC5NMRcoGmYrFaowB6hWOGEesqv+khqiZ33jeG43T/t26piypUpBVe1/X2M3UB0h6NW0NkHlcVOqwuyTqzah7LGtaS3sEm3U3SfN4DYnUiO3jxTz/S89lyPk2035xbwaEIBINZlxeCq+9OYHS4lvSA2m4Z3GmryTIUzGZJM/oBS1fd1GKHk9yy0wdiFP3+B/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUVcaCQdJlQbz8ULpfnrRQ9M6rGk1trJ7w+kZNXgnq4=;
 b=FHZwjjmWkNjq/DTEMnQJqIv5+AUUFdpferBCdDGKY8L58/1n6lG7C4RY1ZPMyIOD8XJFTOCEZeLfllGkvFgsLxkCPG/jjB5iHn+oQPD0vtH4+iB1z5vmEfiNozXpAty8SnXhvf5nRTwVYqCjZydEGw+7HHvtG00+wO6m1gnlqMQsbxZQFlt1qZy8tCcdlMZJT1PBO8RbvcrIMxRiuNwYaiYhB+YXm/D/uPkHW4DfAoynF1XbyzT/DkVh98sxtoC6nhptKxy7U3clYO5JlY8KHry2weW4lfXc8+P93yn5AF4kqiTKZdeQZPo1Ec668fvqrCGAYhPSxE/PgpvMhrKzRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUVcaCQdJlQbz8ULpfnrRQ9M6rGk1trJ7w+kZNXgnq4=;
 b=e0y852ELAOioMdwvCKDCZGnQd7DgQhrLXf5uMlN3Upc8FPG1hU1+xRyAIhk9Hg7c4OHICpq6Ms4ZMAbOdFKMzpN7/D431QzNBzNrwGi2F+sN9yBsDlApuHhGd+tURwgBehSts3RYUmnYw9x+C7ANRuHCznSse5uWv1qy+AOM5yI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3417.eurprd05.prod.outlook.com (2603:10a6:7:33::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.26; Tue, 30 Jun 2020 10:15:19 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.028; Tue, 30 Jun 2020
 10:15:19 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v2 2/4] tc: Add helpers to support qevent handling
Date:   Tue, 30 Jun 2020 13:14:50 +0300
Message-Id: <e43813643a02858bb5e4ff13d0c2d5bb2f97a9c4.1593509090.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1593509090.git.petrm@mellanox.com>
References: <cover.1593509090.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:208:be::49) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR04CA0108.eurprd04.prod.outlook.com (2603:10a6:208:be::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 10:15:18 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5cbd30ec-66ba-4271-552c-08d81cde7db9
X-MS-TrafficTypeDiagnostic: HE1PR05MB3417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3417CD3066784151141C528BDB6F0@HE1PR05MB3417.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:374;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8cYlquAJajcHV5PhvPHz84k+cku95ECA6mhHI9lCCSW7ybSjivK2x9R5cp1HQnr/o38hEqAVRW8VR68C16UGzngiwOj7gUaSi9v0g6exgL3yeLsExjab5oYfc/IROsQUBl5NYJn9EbiaNfeOBUqS0K8NOK/cukCFoo4NCDjcvcLFCQQcvJheJiLi0l/2oEAdw1PLu8Wz6s13dyGDirxPvw/W16+oxP6wqljosSUED0VlEodvzYC0nWVybUp356xO6PmCmM2W1BTwb/XM+NM4/wu1GJtmYIQ0/e/6M7oSBtNSuXQ7Qi78mZEQgCHmm6CcPJsgE9IPSF7spXbLbqWyMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(6486002)(478600001)(956004)(16526019)(2616005)(107886003)(186003)(4326008)(2906002)(6916009)(8936002)(86362001)(83380400001)(6512007)(316002)(36756003)(66556008)(66476007)(8676002)(66946007)(54906003)(6666004)(6506007)(52116002)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rTCFj7USIAcO9miVNvCq84+71dnKO4eQKuTC0MVD+/32LON1HW/jaw2gFvNfPq9BpUn3GKdEnyMGKgiVqGxInrsxLDYFnBsrk+XGg5n+hznVqJ4GbTYWO8V6nbtT9yxy79JMfXI9UevAmZ7ff1TyGenA8/kflCCqyTTCVXgXCLJSnvlelVBZ3E7g6IBjNhHVkuAWOGaggpgUShzvm9VoCk7ClIHoTAaYVBWo+3FsRo2gzm+J2QDGjqScZ39y2xO4O1W5o7s+Iu6Q1AI/l/Rbsq7Lc/Zii4rB/Te/2oPiPpJhidvMDGI7uIEPK7t9jqmu0kZdn+7AGk2G/MAEmjH2A9VCTxM5TvEx/YBMpY/Ch52jR2UJJtt6/t/aDEDxQHRegoWkX2iP/USEnc0FZoRf2o5A3MUz1GREW/3Bm3QE8G64yYmlmXFBn0tLh/dGCAZvUhkIBQr75aK9jHwdGAMjxLNndzLsnG6VW1Dim/i258U=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cbd30ec-66ba-4271-552c-08d81cde7db9
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 10:15:19.3079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cbtTbkmghBOy+8vdrQfuCFnYDi48qkWN6Ea8nwb9hQMeOfv9s66nFyX5y/3/ueLCc2cpCcel+syplSRJsyzn7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3417
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


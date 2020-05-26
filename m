Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7684F1E2800
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbgEZRKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:10:49 -0400
Received: from mail-eopbgr40061.outbound.protection.outlook.com ([40.107.4.61]:58964
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728444AbgEZRKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:10:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qy0rQnbxo/lfIoJ4HLUnLbuk5geJD11yd6/Oznt8JRWnFtOFcVSe5q1iIZWEDWus53nAckNo5xit5ArU35iqJK+mqF5tpSpmvOMyrobY2zsJjCKwnx5LQMYeR9H/rQsU+WoZXm/eYbGGp/mhQgbfxf56StSAdGnD5xIDZvE6n94hNgP9Q1rsEwsvJPOLsTpwfe5+H0wL/MsgZSAQuze+ER9s1FjQ1Efi173lb+8E4+aRdlUDt5/T2uhgAyKzu/kFYEZObe1EJiGw2hqmUVgtl5CqEyFpb0369mWBTwhZGTusmfH8MTrA7j3VXLSjTVY21+D9zobUaLriy70L0Z43XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNbsJmUiwX+GXv7ynDP2xG4jM/DsguZhc8LSMbrrpCI=;
 b=b68UV/09pchg/lOyFmJ1SjUfpSt5c5UkMXFcePm3E/qWDERi321IWZpeE4BvVnUtkjHJ6N80QAe78wVrsU57S/w2yZF07/UVEZIfoOfK1Ow42eKzZiFMs6yWyD4YAbg4zumJ5FrOezLQl1tcjBz0pqpmzuqC3naHqR64izc3cazSj0qQBSKPeNviYxz4fXDv6dNVK9iMcaKU0D9anQbKPQVNRoaJifxJNpmAv7h2SldejAsoblOfYWlCydsTS+O3X0DG58QIn9dSDN0IyH/JJepNlx/ucPI4kcxIkG3lGPEuDnP75RCVqtpwLZ943Uo10danuOyViwnmK8mZLSwvbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNbsJmUiwX+GXv7ynDP2xG4jM/DsguZhc8LSMbrrpCI=;
 b=BGai7YvZtEcw71Ikb9CrDrKjvqP6CQrxHUMkcIvMA6bBJyH8e77GldqcCLi7+qumGtIepN69Dmj2chZbEBTYxs2nrufFRmzDpGr1jgjLcz9FGME5/mOzaav4D1EsdqWbfE67ra+9T/fLYidC692KiqPiEpQ9eKBWIhHvdloXRgo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3225.eurprd05.prod.outlook.com (2603:10a6:7:37::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Tue, 26 May 2020 17:10:37 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:10:37 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        jiri@mellanox.com, idosch@mellanox.com,
        Petr Machata <petrm@mellanox.com>
Subject: [RFC PATCH iproute2-next 2/4] tc: Add helpers to support qevent parsing
Date:   Tue, 26 May 2020 20:10:09 +0300
Message-Id: <d2f62cd8503f40cce44ef0917989eab72f57d3b6.1590512905.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <b4fb87c7d38ab9b8ed4d67bec0a22dd602a11fbf.1590512905.git.petrm@mellanox.com>
References: <b4fb87c7d38ab9b8ed4d67bec0a22dd602a11fbf.1590512905.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0034.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::47) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR02CA0034.eurprd02.prod.outlook.com (2603:10a6:208:3e::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27 via Frontend Transport; Tue, 26 May 2020 17:10:36 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a57cc170-ea76-47ef-0fa9-08d80197b5cc
X-MS-TrafficTypeDiagnostic: HE1PR05MB3225:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3225D3F4F721C1913F2551D0DBB00@HE1PR05MB3225.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iEOcJ8AEMykbA75TPZT9IwVrrdzqF3LGm8s+C0FDUmprFS8JCWeGqMap0zIyYF6mBFiqsRfTpgP1f8nRTnf2Po0aymNec6DMsnR5zXUqPt7m39M/TNETFszlqcazAjXCqfP3gwIXb0TcnOzLXZIs8ek8orpvCclk+AB9fcSIJWm2eSye23gB+m7pzODpFXYS33UXu3+xaIJsMgvXJ/evR3cJGTFm0jxo8LwRyLnmGi2f9Ucft9smk/6Q706s+UW0g5hlyA8HJb75Fir/rvG7ci3l/V1eA6RLDURGeG3IeQ239/Vl5ZhPWjG9GTjoh3FBjGAJD5mFYMq0B22BrDvzxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(956004)(6486002)(2616005)(26005)(186003)(52116002)(6506007)(86362001)(2906002)(8676002)(8936002)(16526019)(5660300002)(6666004)(36756003)(6512007)(54906003)(6916009)(66556008)(107886003)(4326008)(478600001)(66946007)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /YLVMSRiHP/xCOKKHqeUnbkAkAtqV2JcCCXMmuh8Oj/DFX6puFgGr/raKnM/dDP2C3xqwfrcglN9l9xJMkaMqxM7dSql/OGAIsyGZOLUgJXn9S8ksGTMjS713UnGhyuDU0LBB8QdlxduzmnsaH3YsZ7r5w2BDjyC8/+vKGEAR7wDp1ENdEJRbrJLjU39uoqbnpTvaxh2L5Rss51k7sl/QG3b7kJIliOITWQmd8W/eb2YNXz61tbS/8XEkAiDH+7TzRooUA6CDJbUfQhmJhf3l82uegdfXXX0FDB3JaoinoFPt2Nlct9sgn80QIlJWYNa8onlL+JX3aJN66YQ2/lWPPi0gjH8FwAzfXhHPveMB+VbXKrKQU7jMgcPMXLRB1AsvGq0Z//z5xHFlsTLxk3N96trVnBv6RrEaolY3wM/8W2/1GWrCCcGo2M/4XSyppMaKUrHr1TsR+bPqTuuoIt4aewXP2PIHkxur7eCyM3HN9+0up/4wjlCQDQZ1uTRkqG1
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a57cc170-ea76-47ef-0fa9-08d80197b5cc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:10:37.7992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WfNdhXHd0RZT+w1mxbBx7te2AWoL47zyRGUDxRJIonOtbydsuCInvWW2jSCcVgE9IVG09FN3Ju/6QMot6bYIxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a set of helpers to make it easy to add support for qevents into
qdisc.

The idea behind this is that qevent types will be generally reused between
qdiscs, rather than each having a completely idiosyncratic set of qevents.
The qevent module holds functions for parsing of these common qevent types,
and for dispatching to one of the parsers based on the qevent name.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 tc/Makefile    |  1 +
 tc/tc_qevent.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tc/tc_qevent.h | 34 +++++++++++++++++++++
 3 files changed, 118 insertions(+)
 create mode 100644 tc/tc_qevent.c
 create mode 100644 tc/tc_qevent.h

diff --git a/tc/Makefile b/tc/Makefile
index e31cbc12..10567f33 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -121,6 +121,7 @@ TCLIB += tc_red.o
 TCLIB += tc_cbq.o
 TCLIB += tc_estimator.o
 TCLIB += tc_stab.o
+TCLIB += tc_qevent.o
 
 CFLAGS += -DCONFIG_GACT -DCONFIG_GACT_PROB
 ifneq ($(IPT_LIB_DIR),)
diff --git a/tc/tc_qevent.c b/tc/tc_qevent.c
new file mode 100644
index 00000000..f2b22778
--- /dev/null
+++ b/tc/tc_qevent.c
@@ -0,0 +1,83 @@
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
+int qevent_parse(struct qevent_util *qevents, int *p_argc, char ***p_argv)
+{
+	char **argv = *p_argv;
+	int argc = *p_argc;
+	const char *name = *argv;
+	int err;
+
+	for (; qevents->id; qevents++) {
+		if (strcmp(name, qevents->id) == 0) {
+			NEXT_ARG();
+			err = qevents->parse_qevent(&argc, &argv,
+						    qevents->data);
+			if (err)
+				return err;
+
+			*p_argc = argc;
+			*p_argv = argv;
+			return 0;
+		}
+	}
+
+	fprintf(stderr, "Unknown qevent `%s'\n", name);
+	return -1;
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
+int qevent_parse_plain(int *p_argc, char ***p_argv, void *p_data)
+{
+	struct qevent_plain *qe = p_data;
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
diff --git a/tc/tc_qevent.h b/tc/tc_qevent.h
new file mode 100644
index 00000000..548f3fc6
--- /dev/null
+++ b/tc/tc_qevent.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TC_QEVENT_H_
+#define _TC_QEVENT_H_
+
+#include <linux/types.h>
+
+struct qevent_base {
+	__u32 block_idx;
+};
+
+struct qevent_util {
+	const char *id;
+	int (*parse_qevent)(int *argc, char ***argv, void *data);
+	void *data;
+};
+
+#define QEVENT(_name, _parser, _data)					\
+	{								\
+		.id = _name,						\
+		.parse_qevent = qevent_parse_##_parser,			\
+		.data = ({						\
+				struct qevent_##_parser *__data = _data; \
+				__data;					\
+		}),							\
+	}
+
+int qevent_parse(struct qevent_util *qevents, int *p_argc, char ***p_argv);
+
+struct qevent_plain {
+	struct qevent_base base;
+};
+int qevent_parse_plain(int *p_argc, char ***p_argv, void *p_data);
+
+#endif
-- 
2.20.1


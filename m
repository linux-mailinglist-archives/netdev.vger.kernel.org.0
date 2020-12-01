Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296422CABB6
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404306AbgLATVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:21:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46992 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392324AbgLATVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:21:46 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1J3UOr095907;
        Tue, 1 Dec 2020 14:21:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=9D8ZfPrI+462TH+02ojJ7MWeLJzNALGl1LYfZGrzj0o=;
 b=ofzOT52l5H6YB/1jgU97XYN/O7NccMlqdHt8qAiyDCFeupFIDsnlKxEXHFSmCj0Kob6I
 GybfDmR79IIT8+QGXzPPxFyHDg7xfJ5p7wYxCbBp9ieOaDlhRo+/DxT49A6+gXgULxH1
 TsJmvHS0vaMHgqqZaD8HqMC2KqRdJhqz4njyNB8MVfQPUgnLd8OghRPdJLcLMaWaT8Rj
 oAaw4Y+dKKd3fcbJ3iguzz2FP5lFGyD5PDn/7a9BhxQsiRoUvjsKfFx9Iegn3ffWTSWS
 DKdil3UFB1gx8VZt5mw7OowwbRqCyjj+NM+uansvnZlWkaGwjliUJyFHA+hg3Y9ozHCh gQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355ghr7tny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 14:21:02 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1JGx4x011086;
        Tue, 1 Dec 2020 19:21:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 353e68544d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 19:21:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1JKvgG61538808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 19:20:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2A09AE051;
        Tue,  1 Dec 2020 19:20:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98579AE053;
        Tue,  1 Dec 2020 19:20:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 19:20:57 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v7 08/14] net/smc: Introduce generic netlink interface for diagnostic purposes
Date:   Tue,  1 Dec 2020 20:20:43 +0100
Message-Id: <20201201192049.53517-9-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201201192049.53517-1-kgraul@linux.ibm.com>
References: <20201201192049.53517-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

Introduce generic netlink interface infrastructure to expose
the diagnostic information regarding smc linkgroups, links and devices.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/uapi/linux/smc.h | 11 +++++++++
 net/smc/Makefile         |  2 +-
 net/smc/af_smc.c         | 10 +++++++-
 net/smc/smc_netlink.c    | 53 ++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_netlink.h    | 23 +++++++++++++++++
 5 files changed, 97 insertions(+), 2 deletions(-)
 create mode 100644 net/smc/smc_netlink.c
 create mode 100644 net/smc/smc_netlink.h

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 0e11ca421ca4..b604d64542e8 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -33,4 +33,15 @@ enum {				/* SMC PNET Table commands */
 #define SMCR_GENL_FAMILY_NAME		"SMC_PNETID"
 #define SMCR_GENL_FAMILY_VERSION	1
 
+/* gennetlink interface to access non-socket information from SMC module */
+#define SMC_GENL_FAMILY_NAME		"SMC_GEN_NETLINK"
+#define SMC_GENL_FAMILY_VERSION		1
+
+/* SMC_GENL_FAMILY top level attributes */
+enum {
+	SMC_GEN_UNSPEC,
+	__SMC_GEN_MAX,
+	SMC_GEN_MAX = __SMC_GEN_MAX - 1
+};
+
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/net/smc/Makefile b/net/smc/Makefile
index cb1254541f37..77e54fe42b1c 100644
--- a/net/smc/Makefile
+++ b/net/smc/Makefile
@@ -2,4 +2,4 @@
 obj-$(CONFIG_SMC)	+= smc.o
 obj-$(CONFIG_SMC_DIAG)	+= smc_diag.o
 smc-y := af_smc.o smc_pnet.o smc_ib.o smc_clc.o smc_core.o smc_wr.o smc_llc.o
-smc-y += smc_cdc.o smc_tx.o smc_rx.o smc_close.o smc_ism.o
+smc-y += smc_cdc.o smc_tx.o smc_rx.o smc_close.o smc_ism.o smc_netlink.o
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f79b59a972f0..47340b3b514f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -45,6 +45,7 @@
 #include "smc_ib.h"
 #include "smc_ism.h"
 #include "smc_pnet.h"
+#include "smc_netlink.h"
 #include "smc_tx.h"
 #include "smc_rx.h"
 #include "smc_close.h"
@@ -2495,10 +2496,14 @@ static int __init smc_init(void)
 	smc_ism_init();
 	smc_clc_init();
 
-	rc = smc_pnet_init();
+	rc = smc_nl_init();
 	if (rc)
 		goto out_pernet_subsys;
 
+	rc = smc_pnet_init();
+	if (rc)
+		goto out_nl;
+
 	rc = -ENOMEM;
 	smc_hs_wq = alloc_workqueue("smc_hs_wq", 0, 0);
 	if (!smc_hs_wq)
@@ -2569,6 +2574,8 @@ static int __init smc_init(void)
 	destroy_workqueue(smc_hs_wq);
 out_pnet:
 	smc_pnet_exit();
+out_nl:
+	smc_nl_exit();
 out_pernet_subsys:
 	unregister_pernet_subsys(&smc_net_ops);
 
@@ -2586,6 +2593,7 @@ static void __exit smc_exit(void)
 	proto_unregister(&smc_proto6);
 	proto_unregister(&smc_proto);
 	smc_pnet_exit();
+	smc_nl_exit();
 	unregister_pernet_subsys(&smc_net_ops);
 	rcu_barrier();
 }
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
new file mode 100644
index 000000000000..4f964d03b372
--- /dev/null
+++ b/net/smc/smc_netlink.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  Shared Memory Communications over RDMA (SMC-R) and RoCE
+ *
+ *  Generic netlink support functions to interact with SMC module
+ *
+ *  Copyright IBM Corp. 2020
+ *
+ *  Author(s):	Guvenc Gulce <guvenc@linux.ibm.com>
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/ctype.h>
+#include <linux/mutex.h>
+#include <linux/if.h>
+#include <linux/smc.h>
+
+#include "smc_core.h"
+#include "smc_netlink.h"
+
+#define SMC_CMD_MAX_ATTR 1
+
+/* SMC_GENL generic netlink operation definition */
+static const struct genl_ops smc_gen_nl_ops[] = {
+};
+
+static const struct nla_policy smc_gen_nl_policy[2] = {
+	[SMC_CMD_MAX_ATTR]	= { .type = NLA_REJECT, },
+};
+
+/* SMC_GENL family definition */
+struct genl_family smc_gen_nl_family __ro_after_init = {
+	.hdrsize =	0,
+	.name =		SMC_GENL_FAMILY_NAME,
+	.version =	SMC_GENL_FAMILY_VERSION,
+	.maxattr =	SMC_CMD_MAX_ATTR,
+	.policy =	smc_gen_nl_policy,
+	.netnsok =	true,
+	.module =	THIS_MODULE,
+	.ops =		smc_gen_nl_ops,
+	.n_ops =	ARRAY_SIZE(smc_gen_nl_ops)
+};
+
+int __init smc_nl_init(void)
+{
+	return genl_register_family(&smc_gen_nl_family);
+}
+
+void smc_nl_exit(void)
+{
+	genl_unregister_family(&smc_gen_nl_family);
+}
diff --git a/net/smc/smc_netlink.h b/net/smc/smc_netlink.h
new file mode 100644
index 000000000000..0c757232c0d0
--- /dev/null
+++ b/net/smc/smc_netlink.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Shared Memory Communications over RDMA (SMC-R) and RoCE
+ *
+ *  SMC Generic netlink operations
+ *
+ *  Copyright IBM Corp. 2020
+ *
+ *  Author(s):	Guvenc Gulce <guvenc@linux.ibm.com>
+ */
+
+#ifndef _SMC_NETLINK_H
+#define _SMC_NETLINK_H
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+extern struct genl_family smc_gen_nl_family;
+
+int smc_nl_init(void) __init;
+void smc_nl_exit(void);
+
+#endif
-- 
2.17.1


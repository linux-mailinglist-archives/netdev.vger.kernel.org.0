Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4262C2F3D
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404114AbgKXRvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:51:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404091AbgKXRvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:51:14 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHWFok017684;
        Tue, 24 Nov 2020 12:51:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=BK2BbcVMnQQx/xEv7BGjrGdefeu2ed1pLskQjOvdqVU=;
 b=dQdPLcB2AwgRWh7flqNW8SinMciV4EGvkDfHDK/89zcFazUR/ZEZZLFoBlNSxrdnktr9
 xhL/aEqQrrpo8c7kU/p1eKbWyundvodMhxfLvaaq/Adyq72Jl0VAaJsTKmXX+hyMMc3a
 xX/EZVVtqA+q3b8S61Yhdfabum9cFqVWFK7yNQZ8e5guYiYjD1UBzLEAABRjYnDq9cyc
 NQ/G3cz7Q6BwdFapA3C3tJacPz7LL3ZVVZzS78YoyREQ0eq9Rt6fG7Ee+aK8Uim1gSwb
 6Hc1w5dYMXCFYmn+eEfWCH8xnXB8bvFUBZUFtkMo6oBGatTAeZAf9IFPakKNBmvp2tox ag== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 350rn9n4hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 12:51:10 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHgDvn007852;
        Tue, 24 Nov 2020 17:51:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 34xth8bv2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 17:51:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOHp5nD51184032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:51:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92BF3A404D;
        Tue, 24 Nov 2020 17:51:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C426A4057;
        Tue, 24 Nov 2020 17:51:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 17:51:05 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v5 08/14] net/smc: Introduce generic netlink interface for diagnostic purposes
Date:   Tue, 24 Nov 2020 18:50:41 +0100
Message-Id: <20201124175047.56949-9-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201124175047.56949-1-kgraul@linux.ibm.com>
References: <20201124175047.56949-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_05:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240104
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
 net/smc/af_smc.c         |  4 ++++
 net/smc/smc_netlink.c    | 51 ++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_netlink.h    | 23 ++++++++++++++++++
 5 files changed, 90 insertions(+), 1 deletion(-)
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
index f79b59a972f0..7a76bdab5a28 100644
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
@@ -2494,6 +2495,7 @@ static int __init smc_init(void)
 
 	smc_ism_init();
 	smc_clc_init();
+	smc_nl_init();
 
 	rc = smc_pnet_init();
 	if (rc)
@@ -2570,6 +2572,7 @@ static int __init smc_init(void)
 out_pnet:
 	smc_pnet_exit();
 out_pernet_subsys:
+	smc_nl_exit();
 	unregister_pernet_subsys(&smc_net_ops);
 
 	return rc;
@@ -2586,6 +2589,7 @@ static void __exit smc_exit(void)
 	proto_unregister(&smc_proto6);
 	proto_unregister(&smc_proto);
 	smc_pnet_exit();
+	smc_nl_exit();
 	unregister_pernet_subsys(&smc_net_ops);
 	rcu_barrier();
 }
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
new file mode 100644
index 000000000000..4295723e7843
--- /dev/null
+++ b/net/smc/smc_netlink.c
@@ -0,0 +1,51 @@
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
+static const struct nla_policy smc_gen_nl_policy[SMC_GEN_MAX + 1] = {
+	[SMC_GEN_UNSPEC]	= { .type = NLA_UNSPEC, },
+};
+
+/* SMC_GENL generic netlink operation definition */
+static const struct genl_ops smc_gen_nl_ops[] = {
+};
+
+/* SMC_GENL family definition */
+struct genl_family smc_gen_nl_family __ro_after_init = {
+	.hdrsize = 0,
+	.name = SMC_GENL_FAMILY_NAME,
+	.version = SMC_GENL_FAMILY_VERSION,
+	.maxattr = SMC_GEN_MAX,
+	.policy = smc_gen_nl_policy,
+	.netnsok = true,
+	.module = THIS_MODULE,
+	.ops = smc_gen_nl_ops,
+	.n_ops =  ARRAY_SIZE(smc_gen_nl_ops)
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


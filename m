Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489E94C8845
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 10:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbiCAJou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 04:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiCAJot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 04:44:49 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAA73B01E;
        Tue,  1 Mar 2022 01:44:07 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V5vuqVq_1646127844;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V5vuqVq_1646127844)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 17:44:05 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 1/7] net/smc: add sysctl interface for SMC
Date:   Tue,  1 Mar 2022 17:43:56 +0800
Message-Id: <20220301094402.14992-2-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20220301094402.14992-1-dust.li@linux.alibaba.com>
References: <20220301094402.14992-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add sysctl interface to support container environment
for SMC as we talk in the mail list.

Link: https://lore.kernel.org/netdev/20220224020253.GF5443@linux.alibaba.com
Co-developed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 include/net/netns/smc.h |  3 ++
 net/smc/Makefile        |  2 +-
 net/smc/af_smc.c        | 10 ++++++
 net/smc/smc_sysctl.c    | 70 +++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_sysctl.h    | 32 +++++++++++++++++++
 5 files changed, 116 insertions(+), 1 deletion(-)
 create mode 100644 net/smc/smc_sysctl.c
 create mode 100644 net/smc/smc_sysctl.h

diff --git a/include/net/netns/smc.h b/include/net/netns/smc.h
index 47b166684fd8..1682eae50579 100644
--- a/include/net/netns/smc.h
+++ b/include/net/netns/smc.h
@@ -14,5 +14,8 @@ struct netns_smc {
 	struct smc_stats_rsn		*fback_rsn;
 
 	bool				limit_smc_hs;	/* constraint on handshake */
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header		*smc_hdr;
+#endif
 };
 #endif
diff --git a/net/smc/Makefile b/net/smc/Makefile
index 196fb6f01b14..640af9a39f9c 100644
--- a/net/smc/Makefile
+++ b/net/smc/Makefile
@@ -4,4 +4,4 @@ obj-$(CONFIG_SMC)	+= smc.o
 obj-$(CONFIG_SMC_DIAG)	+= smc_diag.o
 smc-y := af_smc.o smc_pnet.o smc_ib.o smc_clc.o smc_core.o smc_wr.o smc_llc.o
 smc-y += smc_cdc.o smc_tx.o smc_rx.o smc_close.o smc_ism.o smc_netlink.o smc_stats.o
-smc-y += smc_tracepoint.o
+smc-y += smc_tracepoint.o smc_sysctl.o
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 30acc31b2c45..19b3066cf7af 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -51,6 +51,7 @@
 #include "smc_close.h"
 #include "smc_stats.h"
 #include "smc_tracepoint.h"
+#include "smc_sysctl.h"
 
 static DEFINE_MUTEX(smc_server_lgr_pending);	/* serialize link group
 						 * creation on server
@@ -3273,9 +3274,17 @@ static int __init smc_init(void)
 		goto out_sock;
 	}
 
+	rc = smc_sysctl_init();
+	if (rc) {
+		pr_err("%s: sysctl_init fails with %d\n", __func__, rc);
+		goto out_ulp;
+	}
+
 	static_branch_enable(&tcp_have_smc);
 	return 0;
 
+out_ulp:
+	tcp_unregister_ulp(&smc_ulp_ops);
 out_sock:
 	sock_unregister(PF_SMC);
 out_proto6:
@@ -3303,6 +3312,7 @@ static int __init smc_init(void)
 static void __exit smc_exit(void)
 {
 	static_branch_disable(&tcp_have_smc);
+	smc_sysctl_exit();
 	tcp_unregister_ulp(&smc_ulp_ops);
 	sock_unregister(PF_SMC);
 	smc_core_exit();
diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
new file mode 100644
index 000000000000..8a3a8e145976
--- /dev/null
+++ b/net/smc/smc_sysctl.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  Shared Memory Communications over RDMA (SMC-R) and RoCE
+ *
+ *  smc_sysctl.c: sysctl interface to SMC subsystem.
+ *
+ *  Copyright (c) 2022, Alibaba Inc.
+ *
+ *  Author: Tony Lu <tonylu@linux.alibaba.com>
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/sysctl.h>
+#include <net/net_namespace.h>
+
+#include "smc_sysctl.h"
+
+static struct ctl_table smc_table[] = {
+	{  }
+};
+
+static __net_init int smc_sysctl_init_net(struct net *net)
+{
+	struct ctl_table *table;
+
+	table = smc_table;
+	if (!net_eq(net, &init_net)) {
+		int i;
+
+		table = kmemdup(table, sizeof(smc_table), GFP_KERNEL);
+		if (!table)
+			goto err_alloc;
+
+		for (i = 0; i < ARRAY_SIZE(smc_table) - 1; i++)
+			table[i].data += (void *)net - (void *)&init_net;
+	}
+
+	net->smc.smc_hdr = register_net_sysctl(net, "net/smc", table);
+	if (!net->smc.smc_hdr)
+		goto err_reg;
+
+	return 0;
+
+err_reg:
+	if (!net_eq(net, &init_net))
+		kfree(table);
+err_alloc:
+	return -ENOMEM;
+}
+
+static __net_exit void smc_sysctl_exit_net(struct net *net)
+{
+	unregister_net_sysctl_table(net->smc.smc_hdr);
+}
+
+static struct pernet_operations smc_sysctl_ops __net_initdata = {
+	.init = smc_sysctl_init_net,
+	.exit = smc_sysctl_exit_net,
+};
+
+int __init smc_sysctl_init(void)
+{
+	return register_pernet_subsys(&smc_sysctl_ops);
+}
+
+void smc_sysctl_exit(void)
+{
+	unregister_pernet_subsys(&smc_sysctl_ops);
+}
diff --git a/net/smc/smc_sysctl.h b/net/smc/smc_sysctl.h
new file mode 100644
index 000000000000..49553ac236b6
--- /dev/null
+++ b/net/smc/smc_sysctl.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Shared Memory Communications over RDMA (SMC-R) and RoCE
+ *
+ *  smc_sysctl.c: sysctl interface to SMC subsystem.
+ *
+ *  Copyright (c) 2022, Alibaba Inc.
+ *
+ *  Author: Tony Lu <tonylu@linux.alibaba.com>
+ *
+ */
+
+#ifndef _SMC_SYSCTL_H
+#define _SMC_SYSCTL_H
+
+#ifdef CONFIG_SYSCTL
+
+int smc_sysctl_init(void);
+void smc_sysctl_exit(void);
+
+#else
+
+int smc_sysctl_init(void)
+{
+	return 0;
+}
+
+void smc_sysctl_exit(void) { }
+
+#endif /* CONFIG_SYSCTL */
+
+#endif /* _SMC_SYSCTL_H */
-- 
2.19.1.3.ge56e4f7


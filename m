Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8179348E3FD
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 06:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbiANFtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 00:49:06 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:35913 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239150AbiANFtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 00:49:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V1nMT2A_1642139339;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V1nMT2A_1642139339)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 13:48:59 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [RFC PATCH net-next 5/6] net/smc: Unbind buffer size from clcsock and make it tunable
Date:   Fri, 14 Jan 2022 13:48:51 +0800
Message-Id: <20220114054852.38058-6-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114054852.38058-1-tonylu@linux.alibaba.com>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SMC uses smc->sk.sk_{rcv|snd}buf to create buffer for send buffer or
RMB. And the values of buffer size inherits from clcsock. The clcsock is
a TCP sock which is initiated during SMC connection startup.

The inherited buffer size doesn't fit SMC well. TCP provides two sysctl
knobs to tune r/w buffers, net.ipv4.tcp_{r|w}mem, and SMC use the default
value from TCP. The buffer size is tuned for TCP, but not fit SMC well
in some scenarios. For example, we need larger buffer of SMC for high
throughput applications, and smaller buffer of SMC for saving contiguous
memory. We need to adjust the buffer size apart from TCP and not to
disturb TCP.

This unbinds buffer size which inherits from clcsock, and provides
sysctl knobs to adjust buffer size independently. These knobs can be
tuned with different values for different net namespaces for performance
and flexibility.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 Documentation/networking/smc-sysctl.rst | 20 ++++++
 include/net/netns/smc.h                 |  5 ++
 net/smc/Makefile                        |  2 +-
 net/smc/af_smc.c                        | 17 +++++-
 net/smc/smc_sysctl.c                    | 81 +++++++++++++++++++++++++
 net/smc/smc_sysctl.h                    | 22 +++++++
 6 files changed, 144 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/networking/smc-sysctl.rst
 create mode 100644 net/smc/smc_sysctl.c
 create mode 100644 net/smc/smc_sysctl.h

diff --git a/Documentation/networking/smc-sysctl.rst b/Documentation/networking/smc-sysctl.rst
new file mode 100644
index 000000000000..ba2be59a57dd
--- /dev/null
+++ b/Documentation/networking/smc-sysctl.rst
@@ -0,0 +1,20 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========
+SMC Sysctl
+=========
+
+/proc/sys/net/smc/* Variables
+==============================
+
+wmem_default - INTEGER
+    Initial size of send buffer used by SMC sockets.
+    The default value inherits from net.ipv4.tcp_wmem[1].
+
+    Default: 16K
+
+rmem_default - INTEGER
+    Initial size of receive buffer (RMB) used by SMC sockets.
+    The default value inherits from net.ipv4.tcp_rmem[1].
+
+    Default: 131072 bytes.
diff --git a/include/net/netns/smc.h b/include/net/netns/smc.h
index ea8a9cf2619b..f948235e3156 100644
--- a/include/net/netns/smc.h
+++ b/include/net/netns/smc.h
@@ -12,5 +12,10 @@ struct netns_smc {
 	/* protect fback_rsn */
 	struct mutex			mutex_fback_rsn;
 	struct smc_stats_rsn		*fback_rsn;
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header		*smc_hdr;
+#endif
+	int				sysctl_wmem_default;
+	int				sysctl_rmem_default;
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
index ffab9cee747d..0650b5971e0a 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -51,6 +51,7 @@
 #include "smc_close.h"
 #include "smc_stats.h"
 #include "smc_tracepoint.h"
+#include "smc_sysctl.h"
 
 static DEFINE_MUTEX(smc_server_lgr_pending);	/* serialize link group
 						 * creation on server
@@ -2851,8 +2852,8 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
 		smc->clcsock = clcsock;
 	}
 
-	smc->sk.sk_sndbuf = max(smc->clcsock->sk->sk_sndbuf, SMC_BUF_MIN_SIZE);
-	smc->sk.sk_rcvbuf = max(smc->clcsock->sk->sk_rcvbuf, SMC_BUF_MIN_SIZE);
+	smc->sk.sk_sndbuf = sock_net(sk)->smc.sysctl_wmem_default;
+	smc->sk.sk_rcvbuf = sock_net(sk)->smc.sysctl_rmem_default;
 
 out:
 	return rc;
@@ -2932,6 +2933,11 @@ unsigned int smc_net_id;
 
 static __net_init int smc_net_init(struct net *net)
 {
+	net->smc.sysctl_wmem_default = max(net->ipv4.sysctl_tcp_wmem[1],
+					   SMC_BUF_MIN_SIZE);
+	net->smc.sysctl_rmem_default = max(net->ipv4.sysctl_tcp_rmem[1],
+					   SMC_BUF_MIN_SIZE);
+
 	return smc_pnet_net_init(net);
 }
 
@@ -3044,6 +3050,12 @@ static int __init smc_init(void)
 		goto out_sock;
 	}
 
+	rc = smc_sysctl_init();
+	if (rc) {
+		pr_err("%s: sysctl fails with %d\n", __func__, rc);
+		goto out_sock;
+	}
+
 	static_branch_enable(&tcp_have_smc);
 	return 0;
 
@@ -3085,6 +3097,7 @@ static void __exit smc_exit(void)
 	smc_clc_exit();
 	unregister_pernet_subsys(&smc_net_stat_ops);
 	unregister_pernet_subsys(&smc_net_ops);
+	smc_sysctl_exit();
 	rcu_barrier();
 }
 
diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
new file mode 100644
index 000000000000..6706fe1bd888
--- /dev/null
+++ b/net/smc/smc_sysctl.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sysctl.h>
+#include <net/sock.h>
+#include <net/net_namespace.h>
+
+#include "smc_core.h"
+
+static int min_sndbuf = SMC_BUF_MIN_SIZE;
+static int min_rcvbuf = SMC_BUF_MIN_SIZE;
+
+static struct ctl_table smc_table[] = {
+	{
+		.procname	= "wmem_default",
+		.data		= &init_net.smc.sysctl_wmem_default,
+		.maxlen		= sizeof(init_net.smc.sysctl_wmem_default),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &min_sndbuf,
+	},
+	{
+		.procname	= "rmem_default",
+		.data		= &init_net.smc.sysctl_rmem_default,
+		.maxlen		= sizeof(init_net.smc.sysctl_rmem_default),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &min_rcvbuf,
+	},
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
index 000000000000..c01c5de3a3ea
--- /dev/null
+++ b/net/smc/smc_sysctl.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
2.32.0.3.g01195cf9f


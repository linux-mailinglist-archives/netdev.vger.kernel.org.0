Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322014C884F
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 10:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbiCAJoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 04:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbiCAJou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 04:44:50 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C2C3B55E;
        Tue,  1 Mar 2022 01:44:09 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V5wm1KG_1646127846;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V5wm1KG_1646127846)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 17:44:07 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 3/7] net/smc: add sysctl for autocorking
Date:   Tue,  1 Mar 2022 17:43:58 +0800
Message-Id: <20220301094402.14992-4-dust.li@linux.alibaba.com>
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

This add a new sysctl: net.smc.autocorking_size

We can dynamically change the behaviour of autocorking
by change the value of autocorking_size.
Setting to 0 disables autocorking in SMC

Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 Documentation/networking/smc-sysctl.rst | 23 +++++++++++++++++++++++
 include/net/netns/smc.h                 |  1 +
 net/smc/smc_sysctl.c                    | 10 ++++++++++
 net/smc/smc_tx.c                        |  2 +-
 4 files changed, 35 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/smc-sysctl.rst

diff --git a/Documentation/networking/smc-sysctl.rst b/Documentation/networking/smc-sysctl.rst
new file mode 100644
index 000000000000..c53f8c61c9e4
--- /dev/null
+++ b/Documentation/networking/smc-sysctl.rst
@@ -0,0 +1,23 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========
+SMC Sysctl
+=========
+
+/proc/sys/net/smc/* Variables
+==============================
+
+autocorking_size - INTEGER
+	Setting SMC auto corking size:
+	SMC auto corking is like TCP auto corking from the application's
+	perspective of view. When applications do consecutive small
+	write()/sendmsg() system calls, we try to coalesce these small writes
+	as much as possible, to lower total amount of CDC and RDMA Write been
+	sent.
+	autocorking_size limits the maximum corked bytes that can be sent to
+	the under device in 1 single sending. If set to 0, the SMC auto corking
+	is disabled.
+	Applications can still use TCP_CORK for optimal behavior when they
+	know how/when to uncork their sockets.
+
+	Default: 64K
diff --git a/include/net/netns/smc.h b/include/net/netns/smc.h
index 1682eae50579..e5389eeaf8bd 100644
--- a/include/net/netns/smc.h
+++ b/include/net/netns/smc.h
@@ -17,5 +17,6 @@ struct netns_smc {
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header		*smc_hdr;
 #endif
+	unsigned int			sysctl_autocorking_size;
 };
 #endif
diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
index 8a3a8e145976..3b59876aaac9 100644
--- a/net/smc/smc_sysctl.c
+++ b/net/smc/smc_sysctl.c
@@ -14,9 +14,17 @@
 #include <linux/sysctl.h>
 #include <net/net_namespace.h>
 
+#include "smc.h"
 #include "smc_sysctl.h"
 
 static struct ctl_table smc_table[] = {
+	{
+		.procname       = "autocorking_size",
+		.data           = &init_net.smc.sysctl_autocorking_size,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler	= proc_douintvec,
+	},
 	{  }
 };
 
@@ -40,6 +48,8 @@ static __net_init int smc_sysctl_init_net(struct net *net)
 	if (!net->smc.smc_hdr)
 		goto err_reg;
 
+	net->smc.sysctl_autocorking_size = SMC_AUTOCORKING_DEFAULT_SIZE;
+
 	return 0;
 
 err_reg:
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 062c6b1535e3..257dc0d0aeb1 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -147,7 +147,7 @@ static bool smc_should_autocork(struct smc_sock *smc)
 	struct smc_connection *conn = &smc->conn;
 	int corking_size;
 
-	corking_size = min(SMC_AUTOCORKING_DEFAULT_SIZE,
+	corking_size = min(sock_net(&smc->sk)->smc.sysctl_autocorking_size,
 			   conn->sndbuf_desc->len >> 1);
 
 	if (atomic_read(&conn->cdc_pend_tx_wr) == 0 ||
-- 
2.19.1.3.ge56e4f7


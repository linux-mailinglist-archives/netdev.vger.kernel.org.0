Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE3F4CEF41
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 02:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbiCGBzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 20:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiCGBzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 20:55:22 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E782813F0D;
        Sun,  6 Mar 2022 17:54:27 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V6OZE6y_1646618064;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V6OZE6y_1646618064)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Mar 2022 09:54:25 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3] net/smc: fix compile warning for smc_sysctl
Date:   Mon,  7 Mar 2022 09:54:24 +0800
Message-Id: <20220307015424.59154-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
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

kernel test robot reports multiple warning for smc_sysctl:

  In file included from net/smc/smc_sysctl.c:17:
>> net/smc/smc_sysctl.h:23:5: warning: no previous prototype \
	for function 'smc_sysctl_init' [-Wmissing-prototypes]
  int smc_sysctl_init(void)
       ^
and
  >> WARNING: modpost: vmlinux.o(.text+0x12ced2d): Section mismatch \
  in reference from the function smc_sysctl_exit() to the variable
  .init.data:smc_sysctl_ops
  The function smc_sysctl_exit() references
  the variable __initdata smc_sysctl_ops.
  This is often because smc_sysctl_exit lacks a __initdata
  annotation or the annotation of smc_sysctl_ops is wrong.

and
  net/smc/smc_sysctl.c: In function 'smc_sysctl_init_net':
  net/smc/smc_sysctl.c:47:17: error: 'struct netns_smc' has no member named 'smc_hdr'
     47 |         net->smc.smc_hdr = register_net_sysctl(net, "net/smc", table);

Since we don't need global sysctl initialization. To make things
clean and simple, remove the global pernet_operations and
smc_sysctl_{init|exit}. Call smc_sysctl_net_{init|exit} directly
from smc_net_{init|exit}.

Also initialized sysctl_autocorking_size if CONFIG_SYSCTL it not
set, this make sure SMC autocorking is enabled by default if
CONFIG_SYSCTL is not set.

Fixes: 462791bbfa35 ("net/smc: add sysctl interface for SMC")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>

---
v3: 1. add __net_{init|exit} annotation for smc_sysctl_net_{init|exit}
       sugguested by Jakub Kicinski
    2. Remove static inline for smc_sysctl_net_{init|exit} if
       CONFIG_SYSCTL not defined
v2: 1. Removes pernet_operations and smc_sysctl_{init|exit}
    2. Initialize sysctl_autocorking_size if CONFIG_SYSCTL not set
---
 net/smc/Makefile     |  3 ++-
 net/smc/af_smc.c     | 15 ++++++---------
 net/smc/smc_sysctl.c | 19 ++-----------------
 net/smc/smc_sysctl.h |  9 +++++----
 4 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/net/smc/Makefile b/net/smc/Makefile
index 640af9a39f9c..875efcd126a2 100644
--- a/net/smc/Makefile
+++ b/net/smc/Makefile
@@ -4,4 +4,5 @@ obj-$(CONFIG_SMC)	+= smc.o
 obj-$(CONFIG_SMC_DIAG)	+= smc_diag.o
 smc-y := af_smc.o smc_pnet.o smc_ib.o smc_clc.o smc_core.o smc_wr.o smc_llc.o
 smc-y += smc_cdc.o smc_tx.o smc_rx.o smc_close.o smc_ism.o smc_netlink.o smc_stats.o
-smc-y += smc_tracepoint.o smc_sysctl.o
+smc-y += smc_tracepoint.o
+smc-$(CONFIG_SYSCTL) += smc_sysctl.o
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e508e4f3a073..f0d118e9f155 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3179,11 +3179,17 @@ unsigned int smc_net_id;
 
 static __net_init int smc_net_init(struct net *net)
 {
+	int rc;
+
+	rc = smc_sysctl_net_init(net);
+	if (rc)
+		return rc;
 	return smc_pnet_net_init(net);
 }
 
 static void __net_exit smc_net_exit(struct net *net)
 {
+	smc_sysctl_net_exit(net);
 	smc_pnet_net_exit(net);
 }
 
@@ -3296,17 +3302,9 @@ static int __init smc_init(void)
 		goto out_ib;
 	}
 
-	rc = smc_sysctl_init();
-	if (rc) {
-		pr_err("%s: sysctl_init fails with %d\n", __func__, rc);
-		goto out_ulp;
-	}
-
 	static_branch_enable(&tcp_have_smc);
 	return 0;
 
-out_ulp:
-	tcp_unregister_ulp(&smc_ulp_ops);
 out_ib:
 	smc_ib_unregister_client();
 out_sock:
@@ -3336,7 +3334,6 @@ static int __init smc_init(void)
 static void __exit smc_exit(void)
 {
 	static_branch_disable(&tcp_have_smc);
-	smc_sysctl_exit();
 	tcp_unregister_ulp(&smc_ulp_ops);
 	sock_unregister(PF_SMC);
 	smc_core_exit();
diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
index 3b59876aaac9..bae19419e755 100644
--- a/net/smc/smc_sysctl.c
+++ b/net/smc/smc_sysctl.c
@@ -28,7 +28,7 @@ static struct ctl_table smc_table[] = {
 	{  }
 };
 
-static __net_init int smc_sysctl_init_net(struct net *net)
+int __net_init smc_sysctl_net_init(struct net *net)
 {
 	struct ctl_table *table;
 
@@ -59,22 +59,7 @@ static __net_init int smc_sysctl_init_net(struct net *net)
 	return -ENOMEM;
 }
 
-static __net_exit void smc_sysctl_exit_net(struct net *net)
+void __net_exit smc_sysctl_net_exit(struct net *net)
 {
 	unregister_net_sysctl_table(net->smc.smc_hdr);
 }
-
-static struct pernet_operations smc_sysctl_ops __net_initdata = {
-	.init = smc_sysctl_init_net,
-	.exit = smc_sysctl_exit_net,
-};
-
-int __init smc_sysctl_init(void)
-{
-	return register_pernet_subsys(&smc_sysctl_ops);
-}
-
-void smc_sysctl_exit(void)
-{
-	unregister_pernet_subsys(&smc_sysctl_ops);
-}
diff --git a/net/smc/smc_sysctl.h b/net/smc/smc_sysctl.h
index 49553ac236b6..1d554300604d 100644
--- a/net/smc/smc_sysctl.h
+++ b/net/smc/smc_sysctl.h
@@ -15,17 +15,18 @@
 
 #ifdef CONFIG_SYSCTL
 
-int smc_sysctl_init(void);
-void smc_sysctl_exit(void);
+int __net_init smc_sysctl_net_init(struct net *net);
+void __net_exit smc_sysctl_net_exit(struct net *net);
 
 #else
 
-int smc_sysctl_init(void)
+int __net_init smc_sysctl_net_init(struct net *net)
 {
+	net->smc.sysctl_autocorking_size = SMC_AUTOCORKING_DEFAULT_SIZE;
 	return 0;
 }
 
-void smc_sysctl_exit(void) { }
+void __net_exit smc_sysctl_net_exit(struct net *net) { }
 
 #endif /* CONFIG_SYSCTL */
 
-- 
2.19.1.3.ge56e4f7


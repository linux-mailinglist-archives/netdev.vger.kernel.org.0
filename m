Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038E24C9C4A
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 04:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239224AbiCBDoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 22:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239407AbiCBDn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 22:43:59 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BB44BB92;
        Tue,  1 Mar 2022 19:43:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V60kBLn_1646192592;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V60kBLn_1646192592)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Mar 2022 11:43:13 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net-next] net/smc: fix compile warning for smc_sysctl
Date:   Wed,  2 Mar 2022 11:43:12 +0800
Message-Id: <20220302034312.31168-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build:

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

Fixes: 462791bbfa35 ("net/smc: add sysctl interface for SMC")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/smc_sysctl.c | 4 ++--
 net/smc/smc_sysctl.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
index 3b59876aaac9..e6f926757ecb 100644
--- a/net/smc/smc_sysctl.c
+++ b/net/smc/smc_sysctl.c
@@ -69,12 +69,12 @@ static struct pernet_operations smc_sysctl_ops __net_initdata = {
 	.exit = smc_sysctl_exit_net,
 };
 
-int __init smc_sysctl_init(void)
+int __net_init smc_sysctl_init(void)
 {
 	return register_pernet_subsys(&smc_sysctl_ops);
 }
 
-void smc_sysctl_exit(void)
+void __net_exit smc_sysctl_exit(void)
 {
 	unregister_pernet_subsys(&smc_sysctl_ops);
 }
diff --git a/net/smc/smc_sysctl.h b/net/smc/smc_sysctl.h
index 49553ac236b6..8914278ac870 100644
--- a/net/smc/smc_sysctl.h
+++ b/net/smc/smc_sysctl.h
@@ -20,12 +20,12 @@ void smc_sysctl_exit(void);
 
 #else
 
-int smc_sysctl_init(void)
+static inline int smc_sysctl_init(void)
 {
 	return 0;
 }
 
-void smc_sysctl_exit(void) { }
+static inline void smc_sysctl_exit(void) { }
 
 #endif /* CONFIG_SYSCTL */
 
-- 
2.19.1.3.ge56e4f7


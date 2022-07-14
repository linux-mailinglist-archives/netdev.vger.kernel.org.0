Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620AC574970
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 11:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238458AbiGNJpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 05:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238427AbiGNJpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 05:45:39 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B7B4A830;
        Thu, 14 Jul 2022 02:45:36 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VJImAaW_1657791924;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VJImAaW_1657791924)
          by smtp.aliyun-inc.com;
          Thu, 14 Jul 2022 17:45:34 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/6] net/smc: Introduce a sysctl for setting SMC-R buffer type
Date:   Thu, 14 Jul 2022 17:44:02 +0800
Message-Id: <1657791845-1060-4-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
References: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the sysctl smcr_buf_type for setting
the type of SMC-R sndbufs and RMBs.

Valid values includes:

- SMCR_PHYS_CONT_BUFS, which means use physically contiguous
  buffers for better performance and is the default value.

- SMCR_VIRT_CONT_BUFS, which means use virtually contiguous
  buffers in case of physically contiguous memory is scarce.

- SMCR_MIXED_BUFS, which means first try to use physically
  contiguous buffers. If not available, then use virtually
  contiguous buffers.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 Documentation/networking/smc-sysctl.rst | 13 +++++++++++++
 include/net/netns/smc.h                 |  1 +
 net/smc/smc_core.h                      |  6 ++++++
 net/smc/smc_sysctl.c                    | 11 +++++++++++
 4 files changed, 31 insertions(+)

diff --git a/Documentation/networking/smc-sysctl.rst b/Documentation/networking/smc-sysctl.rst
index 0987fd1..742e90e 100644
--- a/Documentation/networking/smc-sysctl.rst
+++ b/Documentation/networking/smc-sysctl.rst
@@ -21,3 +21,16 @@ autocorking_size - INTEGER
 	know how/when to uncork their sockets.
 
 	Default: 64K
+
+smcr_buf_type - INTEGER
+        Controls which type of sndbufs and RMBs to use in later newly created
+        SMC-R link group. Only for SMC-R.
+
+        Default: 0 (physically contiguous sndbufs and RMBs)
+
+        Possible values:
+
+        - 0 - Use physically contiguous buffers
+        - 1 - Use virtually contiguous buffers
+        - 2 - Mixed use of the two types. Try physically contiguous buffers first.
+          If not available, use virtually contiguous buffers then.
diff --git a/include/net/netns/smc.h b/include/net/netns/smc.h
index e5389ee..2adbe2b 100644
--- a/include/net/netns/smc.h
+++ b/include/net/netns/smc.h
@@ -18,5 +18,6 @@ struct netns_smc {
 	struct ctl_table_header		*smc_hdr;
 #endif
 	unsigned int			sysctl_autocorking_size;
+	unsigned int			sysctl_smcr_buf_type;
 };
 #endif
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 46ddec5..7652dfa 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -217,6 +217,12 @@ enum smc_lgr_type {				/* redundancy state of lgr */
 	SMC_LGR_ASYMMETRIC_LOCAL,	/* local has 1, peer 2 active RNICs */
 };
 
+enum smcr_buf_type {		/* types of SMC-R sndbufs and RMBs */
+	SMCR_PHYS_CONT_BUFS	= 0,
+	SMCR_VIRT_CONT_BUFS	= 1,
+	SMCR_MIXED_BUFS		= 2,
+};
+
 enum smc_llc_flowtype {
 	SMC_LLC_FLOW_NONE	= 0,
 	SMC_LLC_FLOW_ADD_LINK	= 2,
diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
index cf3ab13..0613868 100644
--- a/net/smc/smc_sysctl.c
+++ b/net/smc/smc_sysctl.c
@@ -15,6 +15,7 @@
 #include <net/net_namespace.h>
 
 #include "smc.h"
+#include "smc_core.h"
 #include "smc_sysctl.h"
 
 static struct ctl_table smc_table[] = {
@@ -25,6 +26,15 @@
 		.mode           = 0644,
 		.proc_handler	= proc_douintvec,
 	},
+	{
+		.procname	= "smcr_buf_type",
+		.data		= &init_net.smc.sysctl_smcr_buf_type,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
+	},
 	{  }
 };
 
@@ -49,6 +59,7 @@ int __net_init smc_sysctl_net_init(struct net *net)
 		goto err_reg;
 
 	net->smc.sysctl_autocorking_size = SMC_AUTOCORKING_DEFAULT_SIZE;
+	net->smc.sysctl_smcr_buf_type = SMCR_PHYS_CONT_BUFS;
 
 	return 0;
 
-- 
1.8.3.1


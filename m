Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEA64CDF8
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 14:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731897AbfFTMs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 08:48:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34032 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726931AbfFTMsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 08:48:53 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0CDF27CEA37C667575BA;
        Thu, 20 Jun 2019 20:48:48 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 20:48:39 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <bfields@fieldses.org>, <jlayton@kernel.org>,
        <davem@davemloft.net>, <semen.protsenko@linaro.org>,
        <akpm@linux-foundation.org>, <gregkh@linuxfoundation.org>,
        <vvs@virtuozzo.com>, <tglx@linutronix.de>
CC:     <nixiaoming@huawei.com>, <dylix.dailei@huawei.com>,
        <alex.huangjianhui@huawei.com>, <adobriyan@gmail.com>,
        <mingo@kernel.org>, <viresh.kumar@linaro.org>, <luto@kernel.org>,
        <arjan@linux.intel.com>, <Nadia.Derbey@bull.net>,
        <torvalds@linux-foundation.org>, <stern@rowland.harvard.edu>,
        <paulmck@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <stable@kernel.org>
Subject: [PATCH v2 3/3] kernel/notifier.c: remove blocking_notifier_chain_cond_register()
Date:   Thu, 20 Jun 2019 20:48:34 +0800
Message-ID: <1561034914-106990-3-git-send-email-nixiaoming@huawei.com>
X-Mailer: git-send-email 1.8.5.6
In-Reply-To: <1561034914-106990-1-git-send-email-nixiaoming@huawei.com>
References: <1561034914-106990-1-git-send-email-nixiaoming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.174]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

blocking_notifier_chain_cond_register() does not consider
system_booting state, which is the only difference between this
function and blocking_notifier_cain_register(). This can be a bug
and is a piece of duplicate code.

Delete blocking_notifier_chain_cond_register()

Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
---
 include/linux/notifier.h |  4 ----
 kernel/notifier.c        | 23 -----------------------
 net/sunrpc/rpc_pipe.c    |  2 +-
 3 files changed, 1 insertion(+), 28 deletions(-)

diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index 0096a05..0189476 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -150,10 +150,6 @@ extern int raw_notifier_chain_register(struct raw_notifier_head *nh,
 extern int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
 		struct notifier_block *nb);
 
-extern int blocking_notifier_chain_cond_register(
-		struct blocking_notifier_head *nh,
-		struct notifier_block *nb);
-
 extern int atomic_notifier_chain_unregister(struct atomic_notifier_head *nh,
 		struct notifier_block *nb);
 extern int blocking_notifier_chain_unregister(struct blocking_notifier_head *nh,
diff --git a/kernel/notifier.c b/kernel/notifier.c
index e3d221f..63d7501 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -221,29 +221,6 @@ int blocking_notifier_chain_register(struct blocking_notifier_head *nh,
 EXPORT_SYMBOL_GPL(blocking_notifier_chain_register);
 
 /**
- *	blocking_notifier_chain_cond_register - Cond add notifier to a blocking notifier chain
- *	@nh: Pointer to head of the blocking notifier chain
- *	@n: New entry in notifier chain
- *
- *	Adds a notifier to a blocking notifier chain, only if not already
- *	present in the chain.
- *	Must be called in process context.
- *
- *	Currently always returns zero.
- */
-int blocking_notifier_chain_cond_register(struct blocking_notifier_head *nh,
-		struct notifier_block *n)
-{
-	int ret;
-
-	down_write(&nh->rwsem);
-	ret = notifier_chain_register(&nh->head, n);
-	up_write(&nh->rwsem);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(blocking_notifier_chain_cond_register);
-
-/**
  *	blocking_notifier_chain_unregister - Remove notifier from a blocking notifier chain
  *	@nh: Pointer to head of the blocking notifier chain
  *	@n: Entry to remove from notifier chain
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 126d314..1287f80 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -50,7 +50,7 @@
 
 int rpc_pipefs_notifier_register(struct notifier_block *nb)
 {
-	return blocking_notifier_chain_cond_register(&rpc_pipefs_notifier_list, nb);
+	return blocking_notifier_chain_register(&rpc_pipefs_notifier_list, nb);
 }
 EXPORT_SYMBOL_GPL(rpc_pipefs_notifier_register);
 
-- 
1.8.5.6


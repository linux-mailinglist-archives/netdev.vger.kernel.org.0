Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C66E3B71B8
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 04:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388451AbfISC6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 22:58:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2731 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388434AbfISC6V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 22:58:21 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A44D0B2548A33AF6CF65;
        Thu, 19 Sep 2019 10:58:19 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 19 Sep 2019 10:58:11 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <vvs@virtuozzo.com>, <torvalds@linux-foundation.org>,
        <adobriyan@gmail.com>, <anna.schumaker@netapp.com>,
        <arjan@linux.intel.com>, <bfields@fieldses.org>,
        <chuck.lever@oracle.com>, <davem@davemloft.net>,
        <jlayton@kernel.org>, <luto@kernel.org>, <mingo@kernel.org>,
        <Nadia.Derbey@bull.net>, <paulmck@linux.vnet.ibm.com>,
        <semen.protsenko@linaro.org>, <stern@rowland.harvard.edu>,
        <tglx@linutronix.de>, <trond.myklebust@hammerspace.com>,
        <viresh.kumar@linaro.org>
CC:     <stable@kernel.org>, <dylix.dailei@huawei.com>,
        <nixiaoming@huawei.com>, <yuehaibing@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 3/3] kernel/notifier.c: remove blocking_notifier_chain_cond_register()
Date:   Thu, 19 Sep 2019 10:58:08 +0800
Message-ID: <1568861888-34045-4-git-send-email-nixiaoming@huawei.com>
X-Mailer: git-send-email 1.8.5.6
In-Reply-To: <1568861888-34045-1-git-send-email-nixiaoming@huawei.com>
References: <1568861888-34045-1-git-send-email-nixiaoming@huawei.com>
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
index b71a39d..39e14d5 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -51,7 +51,7 @@
 
 int rpc_pipefs_notifier_register(struct notifier_block *nb)
 {
-	return blocking_notifier_chain_cond_register(&rpc_pipefs_notifier_list, nb);
+	return blocking_notifier_chain_register(&rpc_pipefs_notifier_list, nb);
 }
 EXPORT_SYMBOL_GPL(rpc_pipefs_notifier_register);
 
-- 
1.8.5.6


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DC7B71B1
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 04:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388474AbfISC6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 22:58:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2678 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388439AbfISC6W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 22:58:22 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D16BBBC9B83D974F9C30;
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
Subject: [PATCH v4 2/3] kernel/notifier.c: remove notifier_chain_cond_register()
Date:   Thu, 19 Sep 2019 10:58:07 +0800
Message-ID: <1568861888-34045-3-git-send-email-nixiaoming@huawei.com>
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

The only difference between notifier_chain_cond_register() and
notifier_chain_register() is the lack of warning hints for duplicate
registrations.
Consider using notifier_chain_register() instead of
notifier_chain_cond_register() to avoid duplicate code

Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
---
 kernel/notifier.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 30bedb8..e3d221f 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -36,21 +36,6 @@ static int notifier_chain_register(struct notifier_block **nl,
 	return 0;
 }
 
-static int notifier_chain_cond_register(struct notifier_block **nl,
-		struct notifier_block *n)
-{
-	while ((*nl) != NULL) {
-		if ((*nl) == n)
-			return 0;
-		if (n->priority > (*nl)->priority)
-			break;
-		nl = &((*nl)->next);
-	}
-	n->next = *nl;
-	rcu_assign_pointer(*nl, n);
-	return 0;
-}
-
 static int notifier_chain_unregister(struct notifier_block **nl,
 		struct notifier_block *n)
 {
@@ -252,7 +237,7 @@ int blocking_notifier_chain_cond_register(struct blocking_notifier_head *nh,
 	int ret;
 
 	down_write(&nh->rwsem);
-	ret = notifier_chain_cond_register(&nh->head, n);
+	ret = notifier_chain_register(&nh->head, n);
 	up_write(&nh->rwsem);
 	return ret;
 }
-- 
1.8.5.6


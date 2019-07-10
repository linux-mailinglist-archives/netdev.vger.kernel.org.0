Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCB363F86
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 05:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfGJDJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 23:09:27 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38016 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726844AbfGJDJ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 23:09:26 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A43D330CDE34CFC04A64;
        Wed, 10 Jul 2019 11:09:23 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Wed, 10 Jul 2019 11:09:15 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <adobriyan@gmail.com>, <akpm@linux-foundation.org>,
        <anna.schumaker@netapp.com>, <arjan@linux.intel.com>,
        <bfields@fieldses.org>, <chuck.lever@oracle.com>,
        <davem@davemloft.net>, <gregkh@linuxfoundation.org>,
        <jlayton@kernel.org>, <luto@kernel.org>, <mingo@kernel.org>,
        <Nadia.Derbey@bull.net>, <paulmck@linux.vnet.ibm.com>,
        <semen.protsenko@linaro.org>, <stable@kernel.org>,
        <stern@rowland.harvard.edu>, <tglx@linutronix.de>,
        <torvalds@linux-foundation.org>, <trond.myklebust@hammerspace.com>,
        <viresh.kumar@linaro.org>, <vvs@virtuozzo.com>
CC:     <alex.huangjianhui@huawei.com>, <dylix.dailei@huawei.com>,
        <nixiaoming@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v3 2/3] kernel/notifier.c: remove notifier_chain_cond_register()
Date:   Wed, 10 Jul 2019 11:09:12 +0800
Message-ID: <1562728152-30341-1-git-send-email-nixiaoming@huawei.com>
X-Mailer: git-send-email 1.8.5.6
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


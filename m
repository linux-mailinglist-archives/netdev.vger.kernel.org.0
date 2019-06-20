Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF0F54CDFD
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 14:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731743AbfFTMsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 08:48:53 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34030 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726838AbfFTMsw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 08:48:52 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C8BB9DD5EDF0A61C073E;
        Thu, 20 Jun 2019 20:48:47 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 20:48:38 +0800
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
Subject: [PATCH v2 2/3] kernel/notifier.c: remove notifier_chain_cond_register()
Date:   Thu, 20 Jun 2019 20:48:33 +0800
Message-ID: <1561034914-106990-2-git-send-email-nixiaoming@huawei.com>
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


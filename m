Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD06B4CDF9
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 14:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731883AbfFTMsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 08:48:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34034 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726757AbfFTMsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 08:48:54 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 017E69432391C7476A9E;
        Thu, 20 Jun 2019 20:48:48 +0800 (CST)
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
Subject: [PATCH v2 1/3] kernel/notifier.c: avoid duplicate registration
Date:   Thu, 20 Jun 2019 20:48:32 +0800
Message-ID: <1561034914-106990-1-git-send-email-nixiaoming@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.174]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Registering the same notifier to a hook repeatedly can cause the hook
list to form a ring or lose other members of the list.

case1: An infinite loop in notifier_chain_register() can cause soft lockup
        atomic_notifier_chain_register(&test_notifier_list, &test1);
        atomic_notifier_chain_register(&test_notifier_list, &test1);
        atomic_notifier_chain_register(&test_notifier_list, &test2);

case2: An infinite loop in notifier_chain_register() can cause soft lockup
        atomic_notifier_chain_register(&test_notifier_list, &test1);
        atomic_notifier_chain_register(&test_notifier_list, &test1);
        atomic_notifier_call_chain(&test_notifier_list, 0, NULL);

case3: lose other hook test2
        atomic_notifier_chain_register(&test_notifier_list, &test1);
        atomic_notifier_chain_register(&test_notifier_list, &test2);
        atomic_notifier_chain_register(&test_notifier_list, &test1);

case4: Unregister returns 0, but the hook is still in the linked list,
        and it is not really registered. If you call notifier_call_chain
        after ko is unloaded, it will trigger oops.

If the system is configured with softlockup_panic and the same
hook is repeatedly registered on the panic_notifier_list, it
will cause a loop panic.

Add a check in notifier_chain_register() to avoid duplicate registration

Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
---
 kernel/notifier.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index d9f5081..30bedb8 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -23,7 +23,10 @@ static int notifier_chain_register(struct notifier_block **nl,
 		struct notifier_block *n)
 {
 	while ((*nl) != NULL) {
-		WARN_ONCE(((*nl) == n), "double register detected");
+		if (unlikely((*nl) == n)) {
+			WARN(1, "double register detected");
+			return 0;
+		}
 		if (n->priority > (*nl)->priority)
 			break;
 		nl = &((*nl)->next);
-- 
1.8.5.6


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6C863F8F
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 05:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfGJDJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 23:09:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2249 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725935AbfGJDJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 23:09:24 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B20CB753DD21332D48C9;
        Wed, 10 Jul 2019 11:09:18 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 10 Jul 2019 11:09:10 +0800
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
Subject: [PATCH v3 0/3] kernel/notifier.c: avoid duplicate registration
Date:   Wed, 10 Jul 2019 11:09:07 +0800
Message-ID: <1562728147-30251-1-git-send-email-nixiaoming@huawei.com>
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
        after ko is unloaded, it will trigger oops. if the system is
       	configured with softlockup_panic and the same hook is repeatedly
       	registered on the panic_notifier_list, it will cause a loop panic.

so. need add a check in in notifier_chain_register() to avoid duplicate
registration

v1:
* use notifier_chain_cond_register replace notifier_chain_register

v2:
* Add a check in notifier_chain_register() to avoid duplicate registration
* remove notifier_chain_cond_register() to avoid duplicate code 
* remove blocking_notifier_chain_cond_register() to avoid duplicate code

v3:
* Add a cover letter.

Xiaoming Ni (3):
  kernel/notifier.c: avoid duplicate registration
  kernel/notifier.c: remove notifier_chain_cond_register()
  kernel/notifier.c: remove blocking_notifier_chain_cond_register()

 include/linux/notifier.h |  4 ----
 kernel/notifier.c        | 41 +++--------------------------------------
 net/sunrpc/rpc_pipe.c    |  2 +-
 3 files changed, 4 insertions(+), 43 deletions(-)

-- 
1.8.5.6


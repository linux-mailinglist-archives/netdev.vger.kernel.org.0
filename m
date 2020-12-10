Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECA72D5523
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 09:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733226AbgLJIJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 03:09:57 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:58786 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbgLJIJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 03:09:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607587796; x=1639123796;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=aEJzy3+FKb9u4xePy0sLXdWn5xOn3WQ9Rfk09qhrQYk=;
  b=KEdZGycvm1b326PFi92VZyT9la9OZgCStrhOvoboi7XEVNSMPWHE+jiK
   JV94u/VUvz6DYPqXNOTUky3MpGsjZD/zbBF2h6Q39xL/DyyQoAVIqqG60
   ztv3R93F0HmqtRUHzZ3ZxJAUT0sO0fg8tyPc5bKaUdcMrOK2Su/dI48wW
   0=;
X-IronPort-AV: E=Sophos;i="5.78,407,1599523200"; 
   d="scan'208";a="71701030"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 10 Dec 2020 08:09:09 +0000
Received: from EX13D31EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 6BDBFA18C4;
        Thu, 10 Dec 2020 08:09:07 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.161.102) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Dec 2020 08:09:02 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <davem@davemloft.net>
CC:     SeongJae Park <sjpark@amazon.de>, <kuba@kernel.org>,
        <kuznet@ms2.inr.ac.ru>, <edumazet@google.com>, <fw@strlen.de>,
        <paulmck@kernel.org>, <netdev@vger.kernel.org>,
        <rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/1] net: Reduce rcu_barrier() contentions from 'unshare(CLONE_NEWNET)'
Date:   Thu, 10 Dec 2020 09:08:43 +0100
Message-ID: <20201210080844.23741-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D16UWB004.ant.amazon.com (10.43.161.170) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

On a few of our systems, I found frequent 'unshare(CLONE_NEWNET)' calls
make the number of active slab objects including 'sock_inode_cache' type
rapidly and continuously increase.  As a result, memory pressure occurs.

In more detail, I made an artificial reproducer that resembles the
workload that we found the problem and reproduce the problem faster.  It
merely repeats 'unshare(CLONE_NEWNET)' 50,000 times in a loop.  It takes
about 2 minutes.  On 40 CPU cores, 70GB DRAM machine, it reduced about
15GB of available memory in total.  Note that the issue don't reproduce
on every machine.  On my 6 CPU cores machine, the problem didn't
reproduce.

'cleanup_net()' and 'fqdir_work_fn()' are functions that deallocate the
relevant memory objects.  They are asynchronously invoked by the work
queues and internally use 'rcu_barrier()' to ensure safe destructions.
'cleanup_net()' works in a batched maneer in a single thread worker,
while 'fqdir_work_fn()' works for each 'fqdir_exit()' call in the
'system_wq'.

Therefore, 'fqdir_work_fn()' called frequently under the workload and
made the contention for 'rcu_barrier()' high.  In more detail, the
global mutex, 'rcu_state.barrier_mutex' became the bottleneck.

I tried making 'fqdir_work_fn()' batched and confirmed it works.  The
following patch is for the change.  I think this is the right solution
for point fix of this issue, but someone might blame different parts.

1. User: Frequent 'unshare()' calls
From some point of view, such frequent 'unshare()' calls might seem only
insane.

2. Global mutex in 'rcu_barrier()'
Because of the global mutex, 'rcu_barrier()' callers could wait long
even after the callbacks started before the call finished.  Therefore,
similar issues could happen in another 'rcu_barrier()' usages.  Maybe we
can use some wait queue like mechanism to notify the waiters when the
desired time came.

I personally believe applying the point fix for now and making
'rcu_barrier()' improvement in longterm make sense.  If I'm missing
something or you have different opinion, please feel free to let me
know.


Patch History
-------------

Changes from v1
(https://lore.kernel.org/netdev/20201208094529.23266-1-sjpark@amazon.com/)
- Keep xmas tree variable ordering (Jakub Kicinski)
- Add more numbers (Eric Dumazet)
- Use 'llist_for_each_entry_safe()' (Eric Dumazet)

SeongJae Park (1):
  net/ipv4/inet_fragment: Batch fqdir destroy works

 include/net/inet_frag.h  |  2 +-
 net/ipv4/inet_fragment.c | 28 ++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 9 deletions(-)

-- 
2.17.1


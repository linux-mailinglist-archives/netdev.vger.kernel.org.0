Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAB92D71AE
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 09:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436861AbgLKIYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 03:24:03 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:53687 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436842AbgLKIXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 03:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607675017; x=1639211017;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=+1ORPUHdspsm9h53fFYu3DqNR/hyW+duN+x5ggEWKRU=;
  b=bG2+nlW+j/FkmD713dV/aRI893d/7rEl27//i+g0MdnK+eNo/gsCWPvW
   b43o641cQDgs5G+0d5rAN+GDuxKc+XH1+q3TkoHbAp+6A1qWYNFVJ9Vmy
   ylSOudmGyj5V7/QcZa/r55Dp1L69lcBbnKNB69RgH+2JX691cJgAggP/a
   o=;
X-IronPort-AV: E=Sophos;i="5.78,410,1599523200"; 
   d="scan'208";a="71918939"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 11 Dec 2020 08:22:46 +0000
Received: from EX13D31EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 0AA0EA1BBA;
        Fri, 11 Dec 2020 08:20:54 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.144) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Dec 2020 08:20:48 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <davem@davemloft.net>
CC:     SeongJae Park <sjpark@amazon.de>, <kuba@kernel.org>,
        <kuznet@ms2.inr.ac.ru>, <edumazet@google.com>, <fw@strlen.de>,
        <paulmck@kernel.org>, <netdev@vger.kernel.org>,
        <rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/1] net: Reduce rcu_barrier() contentions from 'unshare(CLONE_NEWNET)'
Date:   Fri, 11 Dec 2020 09:20:31 +0100
Message-ID: <20201211082032.26965-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D47UWC004.ant.amazon.com (10.43.162.74) To
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
about 2 minutes.  On 40 CPU cores, 70GB DRAM machine, the available
memory continuously reduced in a fast speed (about 120MB per second,
15GB in total within the 2 minutes).  Note that the issue don't
reproduce on every machine.  On my 6 CPU cores machine, the problem
didn't reproduce.

'cleanup_net()' and 'fqdir_work_fn()' are functions that deallocate the
relevant memory objects.  They are asynchronously invoked by the work
queues and internally use 'rcu_barrier()' to ensure safe destructions.
'cleanup_net()' works in a batched maneer in a single thread worker,
while 'fqdir_work_fn()' works for each 'fqdir_exit()' call in the
'system_wq'.

Therefore, 'fqdir_work_fn()' called frequently under the workload and
made the contention for 'rcu_barrier()' high.  In more detail, the
global mutex, 'rcu_state.barrier_mutex' became the bottleneck.

I tried making 'rcu_barrier()' and subsequent lightweight works in
'fqdir_work_fn()' to be processed by a dedicated singlethread worker in
batch and confirmed it works.  After the change, No continuous memory
reduction but some fluctuation observed.  Nevertheless, the available
memory reduction was only up to about 400MB.  The following patch is for
the change.  I think this is the right solution for point fix of this
issue, but someone might blame different parts.

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

Changes from v2
(https://lore.kernel.org/lkml/20201210080844.23741-1-sjpark@amazon.com/)
- Add numbers after the patch (Eric Dumazet)
- Make only 'rcu_barrier()' and subsequent lightweight works serialized
  (Eric Dumazet)

Changes from v1
(https://lore.kernel.org/netdev/20201208094529.23266-1-sjpark@amazon.com/)
- Keep xmas tree variable ordering (Jakub Kicinski)
- Add more numbers (Eric Dumazet)
- Use 'llist_for_each_entry_safe()' (Eric Dumazet)


SeongJae Park (1):
  net/ipv4/inet_fragment: Batch fqdir destroy works

 include/net/inet_frag.h  |  1 +
 net/ipv4/inet_fragment.c | 45 +++++++++++++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 7 deletions(-)

-- 
2.17.1


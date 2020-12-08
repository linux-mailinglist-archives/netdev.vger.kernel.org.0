Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFB82D280A
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgLHJqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:46:53 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:41445 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727418AbgLHJqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:46:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607420813; x=1638956813;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=2mBk/ERwL0x5uqo2/KwaTsYkq9/KvNSmBymUAmlQXbA=;
  b=CKNIFOSowcUg7H9czrcOE1rigzgAlGtexELC1K4/8xeG4B7bgyKkgQ0m
   BPG3zTVuevzZJp00TQ+GGJ51MQkOkEoBZW873OxCeO9k2PfsJqPohyTxb
   p8xFLs0M5xV8+7kWpongYmnoZboT+vBPYdAgvMXD6wLGzeykGQDr3tRM1
   U=;
X-IronPort-AV: E=Sophos;i="5.78,402,1599523200"; 
   d="scan'208";a="71197780"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 08 Dec 2020 09:46:06 +0000
Received: from EX13D31EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id 58A27A1C3E;
        Tue,  8 Dec 2020 09:46:04 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.160.67) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 09:45:44 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <davem@davemloft.net>
CC:     SeongJae Park <sjpark@amazon.de>, <kuba@kernel.org>,
        <kuznet@ms2.inr.ac.ru>, <paulmck@kernel.org>,
        <netdev@vger.kernel.org>, <rcu@vger.kernel.org>,
        <linux-kernel@vger.kernel.orgor>
Subject: [PATCH 0/1] net: Reduce rcu_barrier() contentions from 'unshare(CLONE_NEWNET)'
Date:   Tue, 8 Dec 2020 10:45:28 +0100
Message-ID: <20201208094529.23266-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.67]
X-ClientProxiedBy: EX13D47UWA002.ant.amazon.com (10.43.163.30) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

On a few of our systems, I found frequent 'unshare(CLONE_NEWNET)' calls
make the number of active slab objects including 'sock_inode_cache' type
rapidly and continuously increase.  As a result, memory pressure occurs.

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
something or you have different opinions, please feel free to let me
know.

SeongJae Park (1):
  net/ipv4/inet_fragment: Batch fqdir destroy works

 include/net/inet_frag.h  |  2 +-
 net/ipv4/inet_fragment.c | 28 ++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 9 deletions(-)

-- 
2.17.1


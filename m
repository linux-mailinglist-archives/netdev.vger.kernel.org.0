Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0B82B8549
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgKRUHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRUHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:07:11 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED6CC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:07:11 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t1so1956946pgo.23
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=4qTy5r8eqhMVlV9VZW8jxUEDHfTCnxRE3J11cARqvUk=;
        b=t4tZ+Duy0UuQRJXp7sJOaLuvXvvhucJRk3z34k2HEOCO5urPu/14v8ItAVEgFzQHax
         j8ZNh/OJ0AliYdON+yzKFk+wy46sTYYBEk2NQFvQBcncvcbpQojnxw+1ixGYPz/xe33F
         q4CkRsXqE+5SmD7OpSlN1ECCYMVQ69iyiuDU/YkrQVBmJHSnFkfHQrrRvSKcekzyW+bS
         QsVPmgKXCIYVVg3QRGjXX+yxI80QiE5aDuNL1JecXtObOv5I7jR4mcOEd0caFy0MlroD
         Ji4jhaq7yyHImiJTK3hWp3b7XAKFWH16dmPAkhxEHG/OCKPlRFg736Oj5kxeSk8jh2SL
         04Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=4qTy5r8eqhMVlV9VZW8jxUEDHfTCnxRE3J11cARqvUk=;
        b=ipAu7Di/hW0jhzCxPnl1wxUllRWvC0IxlK1jv0AAQ4OE4N6OWHRVUyjQp8s9xaaQwv
         ovfTmc3Z8dIq0fLl4xYFwd2nXMN1Hs8rzt4RfznJPc5pjhmLrodDem9aWVF5ib+48EL5
         y3QufVJRNM/+9Mk0qj3UDRVizWnRp8bfBr3689Im8K/LHX5zD86zzSntpzg65XPjctQ/
         Dt7ltXq2zLHhseZy0IezGDicJy1aKu6hj5h453CfZ2bRcrvbk7jaSYWQqZYW79bDI/Ve
         +EGBte7nXJf41WrFoK3kah95TvyEnvVcxJjVueEr9zb3wk+QMmE+/s2RPeDn+my++a3B
         XoWQ==
X-Gm-Message-State: AOAM531WjskG0oIMiMmY5WhquPfv5M8m3mUjhy/JmLyqQ6hs08C97+I1
        6RodjqWeTL2ZYMq07Q3CmC6hZy2ftpQ=
X-Google-Smtp-Source: ABdhPJyF+JLAxAnvHB5ohhwQCr5h2fy8QUG/6QHaHWsOqRgPfeGqTyEAw8hBJUtXmma6SXhw7bIb+cLH9ps=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a62:1455:0:b029:18c:9bd:66af with SMTP id
 82-20020a6214550000b029018c09bd66afmr5944792pfu.37.1605730030768; Wed, 18 Nov
 2020 12:07:10 -0800 (PST)
Date:   Wed, 18 Nov 2020 11:10:04 -0800
Message-Id: <20201118191009.3406652-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH net-next v3 0/5] implement kthread based napi poll
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Hillf Danton <hdanton@sina.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The idea of moving the napi poll process out of softirq context to a
kernel thread based context is not new.
Paolo Abeni and Hannes Frederic Sowa have proposed patches to move napi
poll to kthread back in 2016. And Felix Fietkau has also proposed
patches of similar ideas to use workqueue to process napi poll just a
few weeks ago.

The main reason we'd like to push forward with this idea is that the
scheduler has poor visibility into cpu cycles spent in softirq context,
and is not able to make optimal scheduling decisions of the user threads.
For example, we see in one of the application benchmark where network
load is high, the CPUs handling network softirqs has ~80% cpu util. And
user threads are still scheduled on those CPUs, despite other more idle
cpus available in the system. And we see very high tail latencies. In this
case, we have to explicitly pin away user threads from the CPUs handling
network softirqs to ensure good performance.
With napi poll moved to kthread, scheduler is in charge of scheduling both
the kthreads handling network load, and the user threads, and is able to
make better decisions. In the previous benchmark, if we do this and we
pin the kthreads processing napi poll to specific CPUs, scheduler is
able to schedule user threads away from these CPUs automatically.

And the reason we prefer 1 kthread per napi, instead of 1 workqueue
entity per host, is that kthread is more configurable than workqueue,
and we could leverage existing tuning tools for threads, like taskset,
chrt, etc to tune scheduling class and cpu set, etc. Another reason is
if we eventually want to provide busy poll feature using kernel threads
for napi poll, kthread seems to be more suitable than workqueue.
Furthermore, for large platforms with 2 NICs attached to 2 sockets,
kthread is more flexible to be pinned to different sets of CPUs.  

In this patch series, I revived Paolo and Hannes's patch in 2016 and
left them as the first 2 patches. Then there are changes proposed by
Felix, Jakub, Paolo and myself on top of those, with suggestions from
Eric Dumazet.

In terms of performance, I ran tcp_rr tests with 1000 flows with
various request/response sizes, with RFS/RPS disabled, and compared
performance between softirq vs kthread vs workqueue (patchset proposed
by Felix Fietkau).
Host has 56 hyper threads and 100Gbps nic, 8 rx queues and only 1 numa
node. All threads are unpinned.

        req/resp   QPS   50%tile    90%tile    99%tile    99.9%tile
softirq   1B/1B   2.75M   337us       376us      1.04ms     3.69ms
kthread   1B/1B   2.67M   371us       408us      455us      550us
workq     1B/1B   2.56M   384us       435us      673us      822us

softirq 5KB/5KB   1.46M   678us       750us      969us      2.78ms
kthread 5KB/5KB   1.44M   695us       789us      891us      1.06ms
workq   5KB/5KB   1.34M   720us       905us     1.06ms      1.57ms

softirq 1MB/1MB   11.0K   79ms       166ms      306ms       630ms
kthread 1MB/1MB   11.0K   75ms       177ms      303ms       596ms
workq   1MB/1MB   11.0K   79ms       180ms      303ms       587ms

When running workqueue implementation, I found the number of threads
used is usually twice as much as kthread implementation. This probably
introduces higher scheduling cost, which results in higher tail
latencies in most cases.

I also ran an application benchmark, which performs fixed qps remote SSD
read/write operations, with various sizes. Again, both with RFS/RPS
disabled.
The result is as follows:
         op_size  QPS   50%tile 95%tile 99%tile 99.9%tile  
softirq   4K     572.6K   385us   1.5ms  3.16ms   6.41ms
kthread   4K     572.6K   390us   803us  2.21ms   6.83ms
workq     4k     572.6K   384us   763us  3.12ms   6.87ms

softirq   64K    157.9K   736us   1.17ms 3.40ms   13.75ms
kthread   64K    157.9K   745us   1.23ms 2.76ms    9.87ms 
workq     64K    157.9K   746us   1.23ms 2.76ms    9.96ms

softirq   1M     10.98K   2.03ms  3.10ms  3.7ms   11.56ms
kthread   1M     10.98K   2.13ms  3.21ms  4.02ms  13.3ms
workq     1M     10.98K   2.13ms  3.20ms  3.99ms  14.12ms

In this set of tests, the latency is predominant by the SSD operation.
Also, the user threads are much busier compared to tcp_rr tests. We have
to pin the kthreads/workqueue threads to limit to a few CPUs, to not
disturb user threads, and provide some isolation.


Changes since v2:
Corrected typo in patch 1, and updated the cover letter with more
detailed and updated test results.

Changes since v1:
Replaced kthread_create() with kthread_run() in patch 5 as suggested by
Felix Fietkau.

Changes since RFC:
Renamed the kthreads to be napi/<dev>-<napi_id> in patch 5 as suggested
by Hannes Frederic Sowa.

Paolo Abeni (2):
  net: implement threaded-able napi poll loop support
  net: add sysfs attribute to control napi threaded mode
Felix Fietkau (1):
  net: extract napi poll functionality to __napi_poll()
Jakub Kicinski (1):
  net: modify kthread handler to use __napi_poll()
Wei Wang (1):
  net: improve napi threaded config

 include/linux/netdevice.h |   5 ++
 net/core/dev.c            | 143 +++++++++++++++++++++++++++++++++++---
 net/core/net-sysfs.c      | 100 ++++++++++++++++++++++++++
 3 files changed, 239 insertions(+), 9 deletions(-)

-- 
2.29.2.454.gaff20da3a2-goog


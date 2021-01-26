Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36D6304905
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387814AbhAZFeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbhAZBgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 20:36:22 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25469C061A30
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 17:11:12 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id m21so8370152qtp.6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 17:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=vW18wFKhKSjiZh/DWkgg5R1lFxBnoMFYeeHEi0eAMGg=;
        b=t2tnyQJdrAF352WKZJwp5PbBztF8+rMxR2ZEF8+9S9Mzeepg6qM4uweZ5vooxBk48v
         fwoBMuOF6K8VC2bEaxN9qV2M4tyC+Kf8qTA96nwwfw/KOV1gjyYhrQUlqkMtmUG0woj9
         8m+vJ6WAam2w2BwWCPZjn1ctwh/ilKsjut9bqYfBoEi9BArWAkyMgye9az31WZC0uwNF
         Z6yGLmWQHTLPc+ihDrJWgzm/0DPXz+gkuc1RQkwAuzFW+vjGQE1cnfAt412lVgxfk0PB
         idhlkKOX4UV0dxlspydzI6OXKXhABgcWcp5UV7ukUUNglak/a2GAzzOzxf/K03jWEQzt
         IKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=vW18wFKhKSjiZh/DWkgg5R1lFxBnoMFYeeHEi0eAMGg=;
        b=ndoMp5cDl9RHto4p98UGcUzzcRV4YxwlWS0oOyPbGG228hbFXWdk/ABickTGs6xkbm
         ovtS+JZbufedlThwRvLR0ZNxIZqbIQYzs2XWKxiK9MJeMF5RO0xUz3FyvIXI9uRSbYwA
         mMoy2xsaJeIbtG9bg37atwUSuZKbFvXZyUqSIV2AEtMeEAVPuw2xg2Yp9jzXqFCeAMPP
         fi426mAwmyhe79SkowS4dr6NJycTQxXxAcbz89GFlXmXd+8U180O5ZR8r/BzMwcDD8Sw
         UYKu0Ng8qqNhx0I9UH9SK3qwCdFf/RT0OgzNexFAtMZIjjUefy68ThjmhquEKeBrzDM9
         ZLjg==
X-Gm-Message-State: AOAM532pPr6cwoIkJMMvqP4lMbrBETnrWICsXKrAcbF1Se+DLY2y1IiT
        9+v0o0UlvAUBQkkSNePTnDO4/NB6MH0=
X-Google-Smtp-Source: ABdhPJy9dS2/YWRiLnIfJ6PJTTRE8ROE1iXPIEQbizH4b/uh5zYR6J8CHY6ndLgvSvSbDgxuLZ4z4TDnOc4=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:ad4:5b82:: with SMTP id 2mr3439468qvp.53.1611623471160;
 Mon, 25 Jan 2021 17:11:11 -0800 (PST)
Date:   Mon, 25 Jan 2021 17:11:06 -0800
Message-Id: <20210126011109.2425966-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH net-next v8 0/3] implement kthread based napi poll
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
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
made modifications. Then there are changes proposed by Felix, Jakub,
Paolo and myself on top of those, with suggestions from Eric Dumazet.

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

Changes since v7:
Break napi_set_threaded() into 2 parts, one to create kthread called
from netif_napi_add(), the other to set threaded bit in napi_enable(),
to get rid of inconsistency through all napi in 1 dev.
Added documentation for /sys/class/net/<dev>/threaded.

Changes since v6:
Added memory barrier in napi_set_threaded().
Changed /sys/class/net/<dev>/thread to a ternary value.
Change dev->threaded to a bit instead of bool.

Changes since v5:
Removed ASSERT_RTNL() from napi_set_threaded() and removed rtnl_lock()
operation from napi_enable().

Changes since v4:
Recorded the threaded setting in dev and restore it in napi_enable().

Changes since v3:
Merged and rearranged patches in a logical order for easier review. 
Changed sysfs control to be per device.

Changes since v2:
Corrected typo in patch 1, and updated the cover letter with more
detailed and updated test results.

Changes since v1:
Replaced kthread_create() with kthread_run() in patch 5 as suggested by
Felix Fietkau.

Changes since RFC:
Renamed the kthreads to be napi/<dev>-<napi_id> in patch 5 as suggested
by Hannes Frederic Sowa.

Felix Fietkau (1):
  net: extract napi poll functionality to __napi_poll()

Wei Wang (2):
  net: implement threaded-able napi poll loop support
  net: add sysfs attribute to control napi threaded mode

 Documentation/ABI/testing/sysfs-class-net |  15 ++
 include/linux/netdevice.h                 |  21 +--
 net/core/dev.c                            | 209 ++++++++++++++++++++--
 net/core/net-sysfs.c                      |  50 ++++++
 4 files changed, 271 insertions(+), 24 deletions(-)

-- 
2.30.0.280.ga3ce27912f-goog


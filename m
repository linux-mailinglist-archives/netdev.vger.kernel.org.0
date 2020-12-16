Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E53C2DB867
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgLPBZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgLPBZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 20:25:57 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B062EC061793
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 17:25:17 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id kb15so609726pjb.4
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 17:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=i5sE8Jjv1X5Zf0bpRiyQoJCiFD4DS1oZ3rq7JpYuG+k=;
        b=aN2pDRcwqV1s1286kaX5JqCPUMVgrOBagX6Bj7149ie9EvOjg8/oXcrmOq0SCw5oi1
         0x4l8vz2PSEQp2qw7TNltZxn1vLRWT7fR0P5I0qwDlZaCjSGWKfIAWpsCEua5yoaYKqH
         aXq8r9J1HV0t13hAAtiOyRu3lt2SF35eAlwKGfJbqDLr2gXDC9T/9xntP/VqPWm37tAV
         cfKmllEFHyvDWUeeRM7qPH7doAy4w+jaKDlgUcEgly4Ju+jfR4liLIWFLRvhjvK3UbCr
         3BJW+gS4PWyXKprl57EvNIQsaYCZ9nTtUOpEcEJgoqJZW07ycsul7dk2w+Gm73uZOUzL
         Eo5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=i5sE8Jjv1X5Zf0bpRiyQoJCiFD4DS1oZ3rq7JpYuG+k=;
        b=U6VJ/7W6APtxubyXq/0JAybXbqrD2PlTUzlwpOXnpq4gOgzaz7FfOq7WNpZ3DIOjxe
         p+WOTe+KPV5RPUb1ah/NmM8Pg1+dpey6g+yv6bFOukbFN570bVvD2Gz09xF8Tb/RCXFV
         O8ySVZTPclfTivXKOCxPKN6IZd5LPPjuuAROsNXLwve8o5K20VzQKp7qzV6xG2nDEvIo
         HM/OIEhZdhL3OOzyc+Pl+vZBJd0wXV4PfnsAMC4teMymNMRweYGybO7y8tvDRIe+4+JT
         VRXvhR2I0PSoFc/WDzN5Z9Y+yFhRSX5FPpCTCPkXDSVHaCjpaj2xqMTZlm60oqnkzHji
         tDbA==
X-Gm-Message-State: AOAM533JOBzxD9Jjm65emwCEcwyf24YCQ5dy4wJebgB5XzRuAgKtRw6B
        v0gZjufnuewfxmRMnudILrPWhIzxibM=
X-Google-Smtp-Source: ABdhPJxX9XE1RHX/5pRPndQNCCpGfW/VZ2q6k+UvDaz3fhP/6FCbTW+9ObYiOnZzDt1aSww3ZHlo9T1E5M4=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a62:528c:0:b029:19e:4a39:d9ea with SMTP id
 g134-20020a62528c0000b029019e4a39d9eamr30886740pfb.20.1608081917164; Tue, 15
 Dec 2020 17:25:17 -0800 (PST)
Date:   Tue, 15 Dec 2020 17:25:12 -0800
Message-Id: <20201216012515.560026-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH net-next v5 0/3] implement kthread based napi poll
From:   Wei Wang <weiwan@google.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Eric Dumazet <edumazet@google.com>
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

 include/linux/netdevice.h |  14 +--
 net/core/dev.c            | 184 +++++++++++++++++++++++++++++++++++---
 net/core/net-sysfs.c      |  63 +++++++++++++
 3 files changed, 244 insertions(+), 17 deletions(-)

-- 
2.29.2.684.gfbc64c5ab5-goog


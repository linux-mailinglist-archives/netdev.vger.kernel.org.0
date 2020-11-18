Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F106E2B8565
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgKRUOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgKRUOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:14:22 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B2BC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:14:22 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id e81so1331093ybc.1
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KywnKOp1UPt+y3lrMy1E86/nlqwkNw+YvUJBwNxlo8c=;
        b=Rboxf9ieoWjGRTlx+P6LEUPfBpsqzirv77LTqafQhD0Bkgx7nnSbTX42PNGy14PI/t
         p8AgZy+V5HTpDt5ZcaFXynG6F7kRvOpt0z2O5GC5NX72u6MRV06HRIbtJnv7FEiMgKgw
         X73/uEzHojJlkQm77d8aQ4Xrzzl53Z/4H53e5K4SYxi8L2iupC/S3de+x8+iFNWPsVjm
         U3kW9P39j7GETwVskKQDsyyLhy6yJFCjfYkDtzwWCkuPrKyRE1leP3EWXt0HotHE+uH/
         LEdbPZtVs7JDm1zqg8EtUc3va9wSOaN4URAYzGUwW5sMZga+5PeemoU2KWduLvujZgQ8
         58sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KywnKOp1UPt+y3lrMy1E86/nlqwkNw+YvUJBwNxlo8c=;
        b=itpGraKVPqcCcqw52Ln81l4W9i3spp09V5p76f0KH3dPoMuXFk2HaSGFdsq9kpZxkT
         fFlhli4/y8Ie45YJKOMs4KjTK0KxeDJ7ya95NW9kBWvJYLOWwInax/wSxU9XdkQUQuHW
         bxely803KIOqTKoHwxPufMpccuU/fpwjGi5257Wi1ClzE3/imR3SPDPWTBr9Baj+HJ4x
         6nGlyDOQd2l8Bi0xzflhubqHX3cWmNxXK/kais4bGH1fa1Dld8Gk8OEzgpmofMgYq9RJ
         9cBoEPtDwIbpwKKOkwm2UIc79pqcTuwExRRS7lacR67r2/FmkIXDL7UeUxVfmWk4ZtqL
         m/3g==
X-Gm-Message-State: AOAM533ifkQCx7rABNH1iNZ3buE+nYjYsAj0Hg3GyH/0G+xDdeBUTuXg
        Zu9tY/iS+6yh3dpHMdAy+F+DRWlCVdPKRz/Gwc1xag==
X-Google-Smtp-Source: ABdhPJyhWdAlOewI+/c0TaMEzqV936WpVOskNkCrCCEmd3i+69V8FLl3KnblHTnGs7kJ4zK/xtu6l5fzwjTHZLA2hTY=
X-Received: by 2002:a25:ac19:: with SMTP id w25mr11476558ybi.278.1605730461439;
 Wed, 18 Nov 2020 12:14:21 -0800 (PST)
MIME-Version: 1.0
References: <20201118191009.3406652-1-weiwan@google.com>
In-Reply-To: <20201118191009.3406652-1-weiwan@google.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 18 Nov 2020 12:14:09 -0800
Message-ID: <CAEA6p_CKXMzqqWK0Mo5ppA4vV7bKqV=2toDxmumCJwFeWtq4gQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/5] implement kthread based napi poll
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Hillf Danton <hdanton@sina.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 12:07 PM Wei Wang <weiwan@google.com> wrote:
>
> The idea of moving the napi poll process out of softirq context to a
> kernel thread based context is not new.
> Paolo Abeni and Hannes Frederic Sowa have proposed patches to move napi
> poll to kthread back in 2016. And Felix Fietkau has also proposed
> patches of similar ideas to use workqueue to process napi poll just a
> few weeks ago.
>
> The main reason we'd like to push forward with this idea is that the
> scheduler has poor visibility into cpu cycles spent in softirq context,
> and is not able to make optimal scheduling decisions of the user threads.
> For example, we see in one of the application benchmark where network
> load is high, the CPUs handling network softirqs has ~80% cpu util. And
> user threads are still scheduled on those CPUs, despite other more idle
> cpus available in the system. And we see very high tail latencies. In this
> case, we have to explicitly pin away user threads from the CPUs handling
> network softirqs to ensure good performance.
> With napi poll moved to kthread, scheduler is in charge of scheduling both
> the kthreads handling network load, and the user threads, and is able to
> make better decisions. In the previous benchmark, if we do this and we
> pin the kthreads processing napi poll to specific CPUs, scheduler is
> able to schedule user threads away from these CPUs automatically.
>
> And the reason we prefer 1 kthread per napi, instead of 1 workqueue
> entity per host, is that kthread is more configurable than workqueue,
> and we could leverage existing tuning tools for threads, like taskset,
> chrt, etc to tune scheduling class and cpu set, etc. Another reason is
> if we eventually want to provide busy poll feature using kernel threads
> for napi poll, kthread seems to be more suitable than workqueue.
> Furthermore, for large platforms with 2 NICs attached to 2 sockets,
> kthread is more flexible to be pinned to different sets of CPUs.
>
> In this patch series, I revived Paolo and Hannes's patch in 2016 and
> left them as the first 2 patches. Then there are changes proposed by
> Felix, Jakub, Paolo and myself on top of those, with suggestions from
> Eric Dumazet.
>
> In terms of performance, I ran tcp_rr tests with 1000 flows with
> various request/response sizes, with RFS/RPS disabled, and compared
> performance between softirq vs kthread vs workqueue (patchset proposed
> by Felix Fietkau).
> Host has 56 hyper threads and 100Gbps nic, 8 rx queues and only 1 numa
> node. All threads are unpinned.
>
>         req/resp   QPS   50%tile    90%tile    99%tile    99.9%tile
> softirq   1B/1B   2.75M   337us       376us      1.04ms     3.69ms
> kthread   1B/1B   2.67M   371us       408us      455us      550us
> workq     1B/1B   2.56M   384us       435us      673us      822us
>
> softirq 5KB/5KB   1.46M   678us       750us      969us      2.78ms
> kthread 5KB/5KB   1.44M   695us       789us      891us      1.06ms
> workq   5KB/5KB   1.34M   720us       905us     1.06ms      1.57ms
>
> softirq 1MB/1MB   11.0K   79ms       166ms      306ms       630ms
> kthread 1MB/1MB   11.0K   75ms       177ms      303ms       596ms
> workq   1MB/1MB   11.0K   79ms       180ms      303ms       587ms
>
> When running workqueue implementation, I found the number of threads
> used is usually twice as much as kthread implementation. This probably
> introduces higher scheduling cost, which results in higher tail
> latencies in most cases.
>
> I also ran an application benchmark, which performs fixed qps remote SSD
> read/write operations, with various sizes. Again, both with RFS/RPS
> disabled.
> The result is as follows:
>          op_size  QPS   50%tile 95%tile 99%tile 99.9%tile
> softirq   4K     572.6K   385us   1.5ms  3.16ms   6.41ms
> kthread   4K     572.6K   390us   803us  2.21ms   6.83ms
> workq     4k     572.6K   384us   763us  3.12ms   6.87ms
>
> softirq   64K    157.9K   736us   1.17ms 3.40ms   13.75ms
> kthread   64K    157.9K   745us   1.23ms 2.76ms    9.87ms
> workq     64K    157.9K   746us   1.23ms 2.76ms    9.96ms
>
> softirq   1M     10.98K   2.03ms  3.10ms  3.7ms   11.56ms
> kthread   1M     10.98K   2.13ms  3.21ms  4.02ms  13.3ms
> workq     1M     10.98K   2.13ms  3.20ms  3.99ms  14.12ms
>
> In this set of tests, the latency is predominant by the SSD operation.
> Also, the user threads are much busier compared to tcp_rr tests. We have
> to pin the kthreads/workqueue threads to limit to a few CPUs, to not
> disturb user threads, and provide some isolation.
>
>
> Changes since v2:
> Corrected typo in patch 1, and updated the cover letter with more
> detailed and updated test results.
>

Hi everyone,

We thought it is a good time to re-push this patch series to get
another round of evaluation after several weeks since last version.
The patch series itself did not have much change. But I updated the
cover letter to include the updated and more detailed test results,
hoping to give more contexts.

Thanks for reviewing!
Wei

> Changes since v1:
> Replaced kthread_create() with kthread_run() in patch 5 as suggested by
> Felix Fietkau.
>
> Changes since RFC:
> Renamed the kthreads to be napi/<dev>-<napi_id> in patch 5 as suggested
> by Hannes Frederic Sowa.
>
> Paolo Abeni (2):
>   net: implement threaded-able napi poll loop support
>   net: add sysfs attribute to control napi threaded mode
> Felix Fietkau (1):
>   net: extract napi poll functionality to __napi_poll()
> Jakub Kicinski (1):
>   net: modify kthread handler to use __napi_poll()
> Wei Wang (1):
>   net: improve napi threaded config
>
>  include/linux/netdevice.h |   5 ++
>  net/core/dev.c            | 143 +++++++++++++++++++++++++++++++++++---
>  net/core/net-sysfs.c      | 100 ++++++++++++++++++++++++++
>  3 files changed, 239 insertions(+), 9 deletions(-)
>
> --
> 2.29.2.454.gaff20da3a2-goog
>

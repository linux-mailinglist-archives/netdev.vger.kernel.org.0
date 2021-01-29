Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA44308C47
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 19:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhA2STc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 13:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbhA2SSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 13:18:55 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF55C06174A
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 10:18:15 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id v190so7734720qkc.15
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 10:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=8jttXB2A5d0DvYxOU05R0IoVyY5OhbF8ZIDsDSshQ80=;
        b=rfybohEEiorpROghwr8nXDYzdStgkdZ1jQMCHRQK2PUzd4sp0qqryH527d/qLGJNZ+
         Q4WIHQZx2n9q26eEoKOl7l18FJn8XtwyBoA+AIejO53DhyYINnEv5mR7IVehIrjHc6DH
         TwPuPPF9tlPTmZhutq9wSq60Sgy4Kp+eBJWLFQcNntghDL94ZFtDg85qj2j7mnE4giAz
         fzL0aycQMyu3qyzSGSzviHIeFl87nEs3tZBD03uyTt0GPrLFtHXe9su7SD+vpOzD5lwc
         ITtaH3tMjpKr2z/DlDdLZaBkT8ElKaeDZR6172gLcwL1Izz+VZGeWyX8vgQ3B/xJ1u8H
         aazA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=8jttXB2A5d0DvYxOU05R0IoVyY5OhbF8ZIDsDSshQ80=;
        b=sz8cqrZZ5QJeTDeij9KJUepthJbUzbGt37lMQgC8hj68JsB7XHfBuHHXCd/5ehaOv0
         IVQanrvW98Wi430RWHrDdYqdrKHysJZH9g2FTHUXdtcKPTC2iSNijxAr+VKuE8esCzjx
         GU/zfnLHslNTF/y00xdJLGvzWipw7VHUqopCP/zX2z4SfPflzb7iydwkUwPJQ00vMJlv
         n/ZvSqMpuk6Xy/3Ai6ITXxA1bMY96Mm5wfaJCZtfglEKQZ+xxqVp/Vp+mg8oQzHJj+6U
         4UP++hhMTxNVczfraqViE0h+H+9/t/lKObPjNRzedGYxTO492teg/QDp37UNFUI1h+ws
         PJQg==
X-Gm-Message-State: AOAM5324zDgPFv3hCd46oxV+O64H9RPotXnU2x2VVatapuieVqk5aKND
        OQ/br5n7p0rZbE0EtUqRuytrc9nLN9M=
X-Google-Smtp-Source: ABdhPJyQv4ZUSGU5OgmMWRTeSbCsJ9q+zQym1PnP9gQGgxc1eNB0UASTeaS0tbElVY+goq2YQ68myaWq0T0=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:69ee:ceb1:90eb:1722])
 (user=weiwan job=sendgmr) by 2002:a0c:8406:: with SMTP id l6mr5052519qva.52.1611944294194;
 Fri, 29 Jan 2021 10:18:14 -0800 (PST)
Date:   Fri, 29 Jan 2021 10:18:09 -0800
Message-Id: <20210129181812.256216-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next v9 0/3] implement kthread based napi poll
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
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

Changes since v8:
Added description for threaded param in struct net_device in patch 2.

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
 include/linux/netdevice.h                 |  23 +--
 net/core/dev.c                            | 209 ++++++++++++++++++++--
 net/core/net-sysfs.c                      |  50 ++++++
 4 files changed, 273 insertions(+), 24 deletions(-)

-- 
2.30.0.365.g02bc693789-goog


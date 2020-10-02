Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61DC281E43
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgJBWZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJBWZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:25:30 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87736C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 15:25:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u35so3141377ybd.13
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 15:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=Pl4a2shdj3u09687tZz27F+857jNPVzx4isWZSikC7U=;
        b=QMTYgGJsZ6aJG0VX4n45Lwfa1C5yuV6SmXjiAVQVP71EJnXdWcTXSsUtydLk0mWHzw
         DZwdtcgz/J7wdFUNC0ilu+yMIniiMDY4FLdvuHy9HdOR9kEV9L9ahntNzacwdXNhq7Ok
         TkfdfO4FTkCnD8Cl8nMW+l3LA0Z8I/bOo7LI4VvSNGcg/5Ek+KbbXoJnGWwCNYPm1Dqg
         tgIoqK4YsWnJ4Y/4heIZIYjKzTfoIwaMv3s3v/O8ykFcyWf4lNigXVAegykCfgO295hV
         dtNVBb4TN0TWa8C3IrQJXl66nriUfpKuG0I8/99eXu/M0q8/r3k8M5DDSpEWdKwMYUhF
         fGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=Pl4a2shdj3u09687tZz27F+857jNPVzx4isWZSikC7U=;
        b=SRB8ISonOrngU+1H+Ld9FYSv/j5tMBYrIUJhePpHo7nO1LZnOrcVqZ+OC7aWORuJAw
         U1KlYE1Jrx9IXgAhR3LwpE6+lOPkNmcGNeBhpEjTGKOtupAyFhPoJonstvMAqiaPhtPW
         /AWpiG7LuxXeJ/RzPQsBFBdkz9z1b0CSM92J2GT5fZ7B5bjP+FHJ3x/nnEYm+R3bfAvj
         kDg1eLK48DNdbw980sXfmDXbpxagp6xNAkPh1TbFC1Ok6+H6He9yx9Kx6GFeHGDcsx+R
         SFwdZk0ALCosrSeQ3Ltv6H62IL60rLhQZeZLjNnTTF3w9o0xFVJ83lWO2Hz4sIRrjyDd
         USGQ==
X-Gm-Message-State: AOAM532ig2qO3JpZvmZJgWEAO0MHmWzT2C5pe2gDspUFzRD/A4vT/Ce2
        HXE2y4Bm/8a7aT4YtisEPabzzpcYH0s=
X-Google-Smtp-Source: ABdhPJwmNsBNxHkOHKBBSMFHXWEkExclSCPvjS8kn9dMDx95XTtCsHNLN0hdlk5cPM6Dhwb2KbG08YiEQos=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:900b:: with SMTP id s11mr5547761ybl.426.1601677529733;
 Fri, 02 Oct 2020 15:25:29 -0700 (PDT)
Date:   Fri,  2 Oct 2020 15:25:09 -0700
Message-Id: <20201002222514.1159492-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH net-next v2 0/5] implement kthread based napi poll
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Wei Wang <weiwan@google.com>
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

In this patch series, I revived Paolo and Hannes's patch in 2016 and
left them as the first 2 patches. Then there are changes proposed by
Felix, Jakub, Paolo and myself on top of those, with suggestions from
Eric Dumazet.

In terms of performance, I ran tcp_rr tests with 1000 flows with
various request/response sizes, with RFS/RPS disabled, and compared
performance between softirq vs kthread. Host has 56 hyper threads and
100Gbps nic.

        req/resp   QPS   50%tile    90%tile    99%tile    99.9%tile
softirq   1B/1B   2.19M   284us       987us      1.1ms      1.56ms
kthread   1B/1B   2.14M   295us       987us      1.0ms      1.17ms

softirq 5KB/5KB   1.31M   869us      1.06ms     1.28ms      2.38ms
kthread 5KB/5KB   1.32M   878us      1.06ms     1.26ms      1.66ms

softirq 1MB/1MB  10.78K   84ms       166ms      234ms       294ms
kthread 1MB/1MB  10.83K   82ms       173ms      262ms       320ms

I also ran one application benchmark where the user threads have more
work to do. We do see good amount of tail latency reductions with the
kthread model. 

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
2.28.0.806.g8561365e88-goog


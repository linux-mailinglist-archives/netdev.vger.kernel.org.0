Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D2927F282
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgI3TWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgI3TWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:22:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D17AC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 12:22:12 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r2so2766588yba.7
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 12:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=0//oEHJIhe39mtzfLtoTn9TQveOiXALmn39t/CNp8AY=;
        b=WxnBofx5sBzJKmFLRK2zTn0VcMqufyIY6AK/DWXg9ErG1249C0QzHHMhVSjaGhpb9l
         a+8yawewFopVEZ49SEs3hcNCHf/wq0QB2BG5bZRUlyv/lW5DabcTQCRv7SrIFhfjjYJi
         OkTDxy2HLgU394WipNVJ2wNgD9V7br/gqTMGMnh4zOjwFbSO6Q085E4a1oTGl5C407sH
         kG0hkQDT+Adg+8Q1afF3CpXdBdOJzyAhAloy4NCDHpvcCGX3UZg+U/usdcn5M4vcM5JS
         ubbv5V+AE6BsF24QAsQH04tbHBfnBz0Cmuj/cbd00mKcXj792nfiuJ31KE7zN+jQUj2v
         6Q6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=0//oEHJIhe39mtzfLtoTn9TQveOiXALmn39t/CNp8AY=;
        b=HLN1J0PSRVlVAHTIqriVia+33+3DD7VcqevUuSl5Q+EGJz5Doob2qYCOhj78tAyMqW
         hzoZXjzPHGg6HBHnrjlenattLn1vA/RD5Nn4oOqGkCqT0S4xYwbS2hCTUmHfQzq6mflx
         r8F7mLHZKyG+6WJ5OvfU5sayemb459cb4VoHey7kc/r7u588ZC/A0hnkMOLCPWLFJJTf
         ZS97zybl6Bj68t1+aa3JLg0ti8N3L05+z8GXGKJRGSevNt0Pdv2Iq4AADY24r4QnMZ2h
         fMUuR+JnUkgqagnwX+Gxw5bNh+v4c7wXI7Rk6PWqZbzbnrutIwxpB1c/nM8laNjoSnS/
         g+Kw==
X-Gm-Message-State: AOAM532wkRJSvHEhDK7yAMLGxw8aIwU9GVnGmw8yZcwnsUGBl6BfPI9C
        zkWliWpqHqci1Oe19xZtKNyNYC+j6u0=
X-Google-Smtp-Source: ABdhPJxnLgQncvtH/Lg/oEraC7X20vUdZYbdRkvVZeSz9Sr6RlaUHrjUEEkzCg4VfMhHzGa7fTj6K53typc=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:e710:: with SMTP id e16mr5601968ybh.358.1601493731198;
 Wed, 30 Sep 2020 12:22:11 -0700 (PDT)
Date:   Wed, 30 Sep 2020 12:21:35 -0700
Message-Id: <20200930192140.4192859-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH net-next 0/5] implement kthread based napi poll
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        Wei Wang <weiwan@google.com>
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
 net/core/dev.c            | 139 +++++++++++++++++++++++++++++++++++---
 net/core/net-sysfs.c      | 100 +++++++++++++++++++++++++++
 3 files changed, 235 insertions(+), 9 deletions(-)

-- 
2.28.0.709.gb0816b6eb0-goog


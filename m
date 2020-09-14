Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D403B26931F
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgINR0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgINR0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 13:26:00 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABC4C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:25:58 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id l14so476409pgm.6
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=LfY38ADc8JhuTadvTARA10NxNijWuNygct8ybQdjX+I=;
        b=r0xA7+wQmZexj9DXBp7/OvUyl3W3fR/4kQrnpbMHlTdjdV2U1HOLI19aoNSoaybAYJ
         qIM2tymzrN6A5bk6JPywWkCTVEjPuPlB7uPzYEgFswOoIhSSnejaA+3pg0b29JTTbPFJ
         ULAvQoa/WQc2LH1gi5zPQZ3Dcq0eF9Scrvz+LOAm9N3OnNJWrYn5xDoIWlReticq+7wx
         6wxEF+1Osw+b57bVrQ5bVc4o2qEDmMYuUDuQQKqYHfEEkQLo62o0If3jevqL0LPaFZrJ
         hOIqCsLQjxqhf5AwA8q5w06tyZ52ztx2hfhZEbBROw5uHIbENeRHOo/pl/nSON/YRrqC
         xcNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=LfY38ADc8JhuTadvTARA10NxNijWuNygct8ybQdjX+I=;
        b=m/f1pRdT78bhdykxUgNp4Ny6dggMcmv6XZCJtXnVXGBZr9YG6lN3qYIk3PYk2mj5yE
         msMVS9lLu1OxydfZBVqHLSdHQtOGi9aSmUhyn4E4nmk3GFK6knqhVAM/l1F4mgetprK1
         xBCXcIozQjXctZqVny/CjLt5KuxFOgUcS0TkOW/8Z2h0swIbrmiqcibp1ChF1BkXtEg0
         KYK/HAggBdaB/foYlQqnDO4ne/673JguPdLYDIeHNI0Q5g1gPlj9GOWug+XWZ5mlvAF8
         1dvWHKfFarDM44s7oNJr/cQcy9iqKLj/Q/7Lgr231soXOwUioo83HCKjTXFDuOGo0W6b
         r87A==
X-Gm-Message-State: AOAM533g6OWAxlgeauBPHObvutIshJ2kxuQ0mlJ8VbLvcRn0h6pihkta
        Oo5vujP7re/zE5v8pT3WZhZuUhU0sqA=
X-Google-Smtp-Source: ABdhPJz2jsrawLQlrJMEwyOWpJFCcryKIiO6Fwn/IMWK1QJwJ/Zjm0zZPlwk8f5pbr9uz9m1JH9hEUrorz8=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:aa7:99c7:0:b029:13e:d13d:a056 with SMTP id
 v7-20020aa799c70000b029013ed13da056mr14160452pfi.28.1600104357236; Mon, 14
 Sep 2020 10:25:57 -0700 (PDT)
Date:   Mon, 14 Sep 2020 10:24:47 -0700
Message-Id: <20200914172453.1833883-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [RFC PATCH net-next 0/6] implement kthread based napi poll
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The idea of moving the napi poll process out of softirq context to a
kernel thread based context is not new.
Paolo Abeni and Hannes Frederic Sowa has proposed patches to move napi
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
Paolo Abeni (1):
  net: process RPS/RFS work in kthread context
Wei Wang (1):
  net: improve napi threaded config

 include/linux/netdevice.h |   6 ++
 net/core/dev.c            | 146 +++++++++++++++++++++++++++++++++++---
 net/core/net-sysfs.c      |  99 ++++++++++++++++++++++++++
 3 files changed, 242 insertions(+), 9 deletions(-)

-- 
2.28.0.618.gf4bc123cb7-goog


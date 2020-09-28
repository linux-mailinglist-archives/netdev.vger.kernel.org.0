Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DC627B380
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgI1Rnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgI1Rnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 13:43:49 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548B7C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 10:43:49 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id c5so2111543ilk.11
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 10:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=trTf9MxNXUHe/wVcl0UkPz25wyvxMrwBM3dkdlvvAJk=;
        b=AoiO5hE+gEK/rTeD4JHu0d99EYDkbToApamZNlAnGbvbj3La7KlEOu9AlBSdCWc2dC
         l86k9bj5OeHI540TJq7NqAUGeCiZVuFaS7aBBbuIF1QTrkU87z8TKMq1h2z+vUolI0Lf
         wJhXgj7R/mOxB9gVBv+tzB+Jz/R4/hE4CQq7YUIcFZ/k86bK3lp4HUrKL5Ytu9/TVFy3
         k2Mc7XYHDEQfdY77iEb/Hl6PVQW3sraqJ9lYAWS2Vf0DcAsDf2MO0dJ4vxs5Du9Or3O0
         ljvkzEJ+jPmqL6zSw3etQZ9ZhfeK0JA2DQ1bLKurU/siQXBuAdyGPknVNZz0Bb34hEQu
         Qaqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=trTf9MxNXUHe/wVcl0UkPz25wyvxMrwBM3dkdlvvAJk=;
        b=RjKynS9CgfyJCGE5UeYbMA7nULVfRckExrQVpp1Ip4LMN13uvx6Slum57MRRR96yY3
         UxQh6mvuS+S1vU7DvZxaL8aqe0/h0cPxppvPbhedsbS9R+UTFFa7/lmQeTqUsf4i4iW9
         ixEKz5NqVtwRKPwgDjL+OIr/umv2xZx6E7ahkC5+gHeDC/GnBswGfqtxlL1COwAqWpNm
         M6d6vWi/sniQZ92YV1l3S68i3muhhEHCOv3BDoG6QJxKqn+JHiYayV2j1jPa6CiRMXIh
         R2ByRxUplGdyHpxPq/C2I4u0Vq9qT9CSUn8qvQgYo4tZLevHc9Q1qH+wBQzmC8pvcxTG
         30qA==
X-Gm-Message-State: AOAM532xEUpUYsbfPM1sygAC85VBLctGGt1H06XCigmc+ssAKolj8x6a
        yTIR4d4W2czNYAAcFUZ97zqkwFsZvEW2rm5+gwY0KQ==
X-Google-Smtp-Source: ABdhPJwp5fS5bBcQBa6J804Tck7n1I/5FT6CJQZnpONe4FdzFfL03YPO88rBsiDSKX2lA8tvMgMs7HvtdVCSl503mCM=
X-Received: by 2002:a92:5882:: with SMTP id z2mr2200630ilf.137.1601315028310;
 Mon, 28 Sep 2020 10:43:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com>
In-Reply-To: <20200914172453.1833883-1-weiwan@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 28 Sep 2020 19:43:36 +0200
Message-ID: <CANn89iJDM97U15Znrx4k4bOFKunQp7dwJ9mtPwvMmB4S+rSSbA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
To:     Wei Wang <weiwan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 7:26 PM Wei Wang <weiwan@google.com> wrote:
>
> The idea of moving the napi poll process out of softirq context to a
> kernel thread based context is not new.
> Paolo Abeni and Hannes Frederic Sowa has proposed patches to move napi
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
>
> In this patch series, I revived Paolo and Hannes's patch in 2016 and
> left them as the first 2 patches. Then there are changes proposed by
> Felix, Jakub, Paolo and myself on top of those, with suggestions from
> Eric Dumazet.
>
> In terms of performance, I ran tcp_rr tests with 1000 flows with
> various request/response sizes, with RFS/RPS disabled, and compared
> performance between softirq vs kthread. Host has 56 hyper threads and
> 100Gbps nic.
>
>         req/resp   QPS   50%tile    90%tile    99%tile    99.9%tile
> softirq   1B/1B   2.19M   284us       987us      1.1ms      1.56ms
> kthread   1B/1B   2.14M   295us       987us      1.0ms      1.17ms
>
> softirq 5KB/5KB   1.31M   869us      1.06ms     1.28ms      2.38ms
> kthread 5KB/5KB   1.32M   878us      1.06ms     1.26ms      1.66ms
>
> softirq 1MB/1MB  10.78K   84ms       166ms      234ms       294ms
> kthread 1MB/1MB  10.83K   82ms       173ms      262ms       320ms
>
> I also ran one application benchmark where the user threads have more
> work to do. We do see good amount of tail latency reductions with the
> kthread model.



Wei, this is a very nice work.

Please re-send it without the RFC tag, so that we can hopefully merge it ASAP.

Thanks !

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5773649ED06
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 22:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbiA0VJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 16:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiA0VJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 16:09:07 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F1FC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 13:09:07 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id b9so7766538lfq.6
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 13:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jzQOjyl3/GbprtYdMbhiYnnnP3OY65C6D8broTbaXls=;
        b=w92FqDnTiscq9VlMumQ2DjNiIIwHU9dkd0kivpp9Vnql8K+S+IU6l4o7gTQcdigOK3
         mv+1MI8YCj5zBeYQVHX6Kf6Kp983gk2Pd0MCvLgntPjQKt90hJbJmfKE8reMTU5bad8o
         sOaVvH/X3q71Fzsp+ChQ2gSAnCp/+KSNVXZFY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jzQOjyl3/GbprtYdMbhiYnnnP3OY65C6D8broTbaXls=;
        b=KkcJJFtXhMgynbbrsDzadvAvrdT1+nMY+Bs8DQVAsEBxSM4s6ypoXPlnMWg02E67GT
         49OPnyPHbkb0N7eYYHoHAnGTLezHU4aJgMeoxrOj5rt+4jIDoeICTSg58rqIL+yYIM8S
         eI6CHXBeu1ljdiIohDD6nTZyyCDC5SFb3WuGbmXCOnDEe2nsPbXlg/WQUE0jGte5cP52
         2B8yIbSou6wCqk79z07Wh/pRC+u3Ua9LlMQat1RVvbtz056ib+9RPw23P7HLds1IoVGS
         zBrmQNz+IlTrlNmqR+0hDWrRxjTblvPxqnHKlDHHOw1h94wWYu4QOkODl8fex4qIf84J
         rmwA==
X-Gm-Message-State: AOAM532uQQLguKg+eqlyMeCRZd3RI5qpKC3oXkzjwn/eruPfOVbCgVTL
        W7Jrlw4s9/Sy/sC9STIuLpQE012y8JAMaJPGSok7Hg==
X-Google-Smtp-Source: ABdhPJxXWOyWaAzKmpjMOgmQRDrJ8eEajCVxMxSWND0HLb9WJPs9vw9jGOQBJNYWsvpBfILnE7lxxYvQyaQH/7Ff7Dk=
X-Received: by 2002:a05:6512:3d93:: with SMTP id k19mr4129913lfv.268.1643317745631;
 Thu, 27 Jan 2022 13:09:05 -0800 (PST)
MIME-Version: 1.0
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com> <c7945726-6d6a-2361-3c5a-1f9e3187683a@redhat.com>
In-Reply-To: <c7945726-6d6a-2361-3c5a-1f9e3187683a@redhat.com>
From:   Joe Damato <jdamato@fastly.com>
Date:   Thu, 27 Jan 2022 13:08:54 -0800
Message-ID: <CALALjgxwkRBFd86=kcOjeF4uvhCgB52gG7ka_e16=Qf-3LQiFQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6] net: page_pool: Add page_pool stat counters
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     netdev@vger.kernel.org, brouer@redhat.com, kuba@kernel.org,
        davem@davemloft.net, ilias.apalodimas@linaro.org, hawk@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:51 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 26/01/2022 23.48, Joe Damato wrote:
> > Greetings:
> >
> > This series adds some stat counters for the page_pool allocation path which
> > help to track:
> >
> >       - fast path allocations
> >       - slow path order-0 allocations
> >       - slow path high order allocations
> >       - refills which failed due to an empty ptr ring, forcing a slow
> >         path allocation
> >       - allocations fulfilled via successful refill
> >       - pages which cannot be added to the cache because of numa mismatch
> >         (i.e. waived)
> >
> > Some static inline wrappers are provided for accessing these stats. The
> > intention is that drivers which use the page_pool API can, if they choose,
> > use this stats API.
>
> You are adding (always on) counters to a critical fast-path, that
> drivers uses for the XDP_DROP use-case.

If you prefer requiring users explicitly enable these stats, I am
happy to add a kernel config option (e.g. CONFIG_PAGE_POOL_DEBUG or
similar) in a v2.

> I want to see performance measurements as documentation, showing this is
> not causing a slow-down.
>
> I have some performance tests here[1]:
>   [1]
> https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/lib
>
> Look at:
>   - bench_page_pool_simple.c and
>   - bench_page_pool_cross_cpu.c
>
> How to use + build this[2]:
>   [2]
> https://prototype-kernel.readthedocs.io/en/latest/prototype-kernel/build-process.html

Thanks for the pointers to the benchmarks.

In general, I noted that the benchmark results varied fairly
substantially between repeated runs on the same system.

Results below suggest that:
   -  bench_page_pool_simple is faster on the test kernel, and
   - bench_page_pool_cross_cpu faster on the control

Subsequent runs of bench_page_pool_cross_cpu on the control, however,
reveal *much* slower results than shown below.

Test system:
  - 2 x Intel(R) Xeon(R) Gold 6140 CPU @ 2.30GHz
  - 2 numa zones, with 18 cores per zone and 2 threads per core

Control kernel: built from net-next at commit e2cf07654efb ("ptp:
replace snprintf with sysfs_emit").
Test kernel: This series applied on top of control kernel mentioned above.

Raw output from dmesg for control [1] and test [2] kernel summarized below:

bench_page_pool_simple
  - run with default options (i.e. "sudo mod probe bench_page_pool_simple").

Control:

Type:for_loop Per elem: 0 cycles(tsc) 0.334 ns (step:0)
Type:atomic_inc Per elem: 13 cycles(tsc) 6.021 ns (step:0)
Type:lock Per elem: 31 cycles(tsc) 13.514 ns (step:0)

Type:no-softirq-page_pool01 Per elem: 44 cycles(tsc) 19.549 ns (step:0)
Type:no-softirq-page_pool02 Per elem: 45 cycles(tsc) 19.658 ns (step:0)
Type:no-softirq-page_pool03 Per elem: 118 cycles(tsc) 51.638 ns (step:0)

Type:tasklet_page_pool01_fast_path Per elem: 17 cycles(tsc) 7.472 ns (step:0)
Type:tasklet_page_pool02_ptr_ring Per elem: 42 cycles(tsc) 18.585 ns (step:0)
Type:tasklet_page_pool03_slow Per elem: 109 cycles(tsc) 47.807 ns (step:0)

Test:

Type:for_loop Per elem: 0 cycles(tsc) 0.334 ns (step:0)
Type:atomic_inc Per elem: 14 cycles(tsc) 6.195 ns (step:0)
Type:lock Per elem: 31 cycles(tsc) 13.827 ns (step:0)

Type:no-softirq-page_pool01 Per elem: 44 cycles(tsc) 19.561 ns (step:0)
Type:no-softirq-page_pool02 Per elem: 45 cycles(tsc) 19.700 ns (step:0)
Type:no-softirq-page_pool03 Per elem: 108 cycles(tsc) 47.186 ns (step:0)

Type:tasklet_page_pool01_fast_path Per elem: 12 cycles(tsc) 5.447 ns (step:0)
Type:tasklet_page_pool02_ptr_ring Per elem: 42 cycles(tsc) 18.501 ns (step:0)
Type:tasklet_page_pool03_slow Per elem: 106 cycles(tsc) 46.313 ns (step:0)

bench_page_pool_cross_cpu
  - run with default options (i.e. "sudo mod probe bench_page_pool_cross_cpu").

Control:
Type:page_pool_cross_cpu CPU(0) 1795 cycles(tsc) 782.567 ns (step:2)
Type:page_pool_cross_cpu CPU(1) 1921 cycles(tsc) 837.435 ns (step:2)
Type:page_pool_cross_cpu CPU(2) 960 cycles(tsc) 418.758 ns (step:2)
Sum Type:page_pool_cross_cpu Average: 1558 cycles(tsc) CPUs:3 step:2

Test:
Type:page_pool_cross_cpu CPU(0) 2411 cycles(tsc) 1051.037 ns (step:2)
Type:page_pool_cross_cpu CPU(1) 2467 cycles(tsc) 1075.204 ns (step:2)
Type:page_pool_cross_cpu CPU(2) 1233 cycles(tsc) 537.629 ns (step:2)
Type:page_pool_cross_cpu Average: 2037 cycles(tsc) CPUs:3 step:2


[1]: https://gist.githubusercontent.com/jdamato-fsly/385806f06cb95c61ff8cecf7a3645e75/raw/886e3208f5b9c47abdd59bdaa7ecf27994f477b1/page_pool_bench_control
[2]: https://gist.githubusercontent.com/jdamato-fsly/385806f06cb95c61ff8cecf7a3645e75/raw/886e3208f5b9c47abdd59bdaa7ecf27994f477b1/page_pool_bench_TESTKERNEL


> > It assumed that the API consumer will ensure the page_pool is not destroyed
> > during calls to the stats API.
> >
> > If this series is accepted, I'll submit a follow up patch which will export
> > these stats per RX-ring via ethtool in a driver which uses the page_pool
> > API.
> >
> > Joe Damato (6):
> >    net: page_pool: Add alloc stats and fast path stat
> >    net: page_pool: Add a stat for the slow alloc path
> >    net: page_pool: Add a high order alloc stat
> >    net: page_pool: Add stat tracking empty ring
> >    net: page_pool: Add stat tracking cache refills.
> >    net: page_pool: Add a stat tracking waived pages.
> >
> >   include/net/page_pool.h | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
> >   net/core/page_pool.c    | 15 +++++++--
> >   2 files changed, 94 insertions(+), 3 deletions(-)
> >
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C3E5FDC6C
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 16:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiJMOfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 10:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiJMOfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 10:35:41 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F93EC536
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 07:35:39 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 81so2262736ybf.7
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 07:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GwQFv2vOxDQ7OYeFKTN6dhrhoU/S6EJnw+/KAVnakZs=;
        b=rKS8P6ro2zCpqMNW0n8Mj58ZG0IU4BLAnjN2uwYe3S2hZEJHkkiAaYccxJ4zjWOcVo
         wXceDLZzTrYjus2or/ctjiqhuor4OUOGdXUtzRQK+4TjuWWYM9qPiV5SpstZq8g1eWJH
         /Esx++pEdtjapZ1dw2huRJGYRvm93JDtpWSZehBRrb9pa4rRBVJThM7qLQsOy3OweNV0
         DoV79kLingIRqBi3Nl4cBjXupc9Iwl/3mqPA7sahyOewhRUElZ8VNcivIfM+QqVVmJQz
         Dt0xcwzfWXBbtoGqOfTDTd0CzWVe9k7GN16tORatmROzJUVhuvTVmAJ7Kb9c8jrNCbBU
         5YlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GwQFv2vOxDQ7OYeFKTN6dhrhoU/S6EJnw+/KAVnakZs=;
        b=j2b9YPtygcY6vyBzabQiSIIucfxZwVmr0lOiI9LvQAyqqqpUmzgu+x5frqVCWoXjrr
         U+3XxHBC3Kf2nRN9E1HZoLQCSsOwwwgpmRHkhHNcqkHLkrri6vmP9z5mK58ZMuccpHw0
         pCxPqQYcRI9fLjNv6UK8h1MPruL5qmabWvRLYIIy1/SbkIUO2IR303TvRAPGDSfb/KHu
         z/MFR2LJ2l86yCxP/nrYszXw53cLrBbDgqxjltDV1Sr0MOJjtAFOXhHvPZvS3tLkhwCG
         e4OoEmRX02eAAcHB+oRzPAMwUvpp3kDWoUmfQ/srK6J0DqAqDRGUovg9yumtz1YDA/xO
         yxZQ==
X-Gm-Message-State: ACrzQf3AA+NWJTNlaMzdfLffEhpp68OmobE9fxt1obB2zU00uZghIN7S
        Og320ns0+0xokDUIlhx0IrieGY9gIrmJQixwrvyJ3Q==
X-Google-Smtp-Source: AMsMyM4bxOXbmz2LlCOwwEkuzJE2RkKjyb7bN1dyWdVh2v81I16ON0dxBD2pyjanI9G/0Jk2T2ECqwJnos0t3ryBqLU=
X-Received: by 2002:a25:328c:0:b0:6be:2d4a:e77 with SMTP id
 y134-20020a25328c000000b006be2d4a0e77mr229913yby.407.1665671738124; Thu, 13
 Oct 2022 07:35:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
 <20220609063412.2205738-7-eric.dumazet@gmail.com> <684c6220-9288-3838-a938-0792b57c5968@amd.com>
In-Reply-To: <684c6220-9288-3838-a938-0792b57c5968@amd.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 13 Oct 2022 07:35:26 -0700
Message-ID: <CANn89iKpaJsqeMDQYySmUr2=n8D+dyXKtK0u7hF_8kW10mMm1A@mail.gmail.com>
Subject: Re: [PATCH net-next 6/7] net: keep sk->sk_forward_alloc as small as possible
To:     K Prateek Nayak <kprateek.nayak@amd.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Gautham Shenoy <gautham.shenoy@amd.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Chen Yu <yu.c.chen@intel.com>,
        Abel Wu <wuyun.abel@bytedance.com>,
        Yicong Yang <yangyicong@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 6:16 AM K Prateek Nayak <kprateek.nayak@amd.com> wrote:
>
> Hello Eric,
>
> I might have stumbled upon a possible performance regression observed in
> some microbenchmarks caused by this series.
>
> tl;dr
>
> o When performing regression test against tip:sched/core, I noticed a
>   regression in tbench for the baseline kernel. After ruling out
>   scheduler changes, bisecting on tip:sched/core, then on Linus' tree and
>   then on netdev/net-next led me to this series. Patch 6 of the series
>   which makes changes based on the new reclaim strategy seem to be exact
>   commit where the regression first started. Regression is also observed
>   for netperf-tcp but not for netperf-udp after applying this series.
>

Hi Prateek

Thanks for this detailed report.

Possibly your version of netperf is still using very small writes ?
netperf uses /proc/sys/net/ipv4/tcp_wmem, to read tcp_wmem[1],
and we have increased years ago /proc/sys/net/ipv4/tcp_wmem
to match modern era needs.

# cat /proc/sys/net/ipv4/tcp_wmem
4096 262144 67108864

(Well written applications tend to use large sendmsg() sizes)

What kind of NIC is used ? It seems it does not use GRO ?
The only regression that has been noticed was when memcg was in the picture.
Shakeel Butt sent patches to address this specific mm issue.
Not sure what happened to the series (
https://patchwork.kernel.org/project/linux-mm/list/?series=669584 )

We were aware of the possible performance implications, depending on the setup.
At Google, we use RFS (Documentation/networking/scaling.rst) so that
incoming ACK are handled on the cpu
who did the sendmsg(), so the same per-cpu cache is used for the
charge/uncharge.

Thanks

> I would like to know if this regression is expected based on some of the
> design consideration in the patch. I'll leave a detailed account of
> discovery, bisection, benchmark results and some preliminary analysis
> below. I've also attached the configs used for testing on AMD and Intel
> system.
>
> Details:
>
> When testing community patches, I observed a large degradation in baseline
> tbench numbers for tip:sched/core between older test reports
> (Example: https://lore.kernel.org/lkml/d49aeabd-ee4e-cc81-06d1-b16029a901ee@amd.com/)
> and recent test reports on the AMD Zen3 system I was testing on.
> (Example: https://lore.kernel.org/lkml/7975dcbe-97b3-7e6c-4697-5f316731c287@amd.com/).
>
> Following is the direct baseline to baseline comparison for tbench
> from the two reports mentioned above on AMD Zen3 system (2 x 64C/128T):
>
> NPS Modes are used to logically divide single socket into
> multiple NUMA region.
> Following is the NUMA configuration for each NPS mode on the system:
>
> NPS1: Each socket is a NUMA node.
>     Total 2 NUMA nodes in the dual socket machine.
>
>     Node 0: 0-63,   128-191
>     Node 1: 64-127, 192-255
>
> NPS2: Each socket is further logically divided into 2 NUMA regions.
>     Total 4 NUMA nodes exist over 2 socket.
>
>     Node 0: 0-31,   128-159
>     Node 1: 32-63,  160-191
>     Node 2: 64-95,  192-223
>     Node 3: 96-127, 223-255
>
> NPS4: Each socket is logically divided into 4 NUMA regions.
>     Total 8 NUMA nodes exist over 2 socket.
>
>     Node 0: 0-15,    128-143
>     Node 1: 16-31,   144-159
>     Node 2: 32-47,   160-175
>     Node 3: 48-63,   176-191
>     Node 4: 64-79,   192-207
>     Node 5: 80-95,   208-223
>     Node 6: 96-111,  223-231
>     Node 7: 112-127, 232-255
>
> Note: All tests were performed with performance governor.
>
> commit 5531ecffa4b9 ("sched: Add update_current_exec_runtime helper")
> commit 7e9518baed4c ("sched/fair: Move call to list_last_entry() in detach_tasks")
>
> ~~~~~~~~~~
> ~ tbench ~
> ~~~~~~~~~~
>
> NPS1
>
> Clients: tip (5531ecffa4b9)      tip (7e9518baed4c)
>     1    573.26 (0.00 pct)       550.66 (-3.94 pct)
>     2    1131.19 (0.00 pct)      1009.69 (-10.74 pct)
>     4    2100.07 (0.00 pct)      1795.32 (-14.51 pct)
>     8    3809.88 (0.00 pct)      2971.16 (-22.01 pct)
>    16    6560.72 (0.00 pct)      4627.98 (-29.45 pct)
>    32    12203.23 (0.00 pct)     8065.15 (-33.90 pct)
>    64    22389.81 (0.00 pct)     14994.32 (-33.03 pct)
>   128    32449.37 (0.00 pct)     5175.73 (-84.04 pct) *
>   256    58962.40 (0.00 pct)     48763.57 (-17.29 pct)
>   512    59608.71 (0.00 pct)     43780.78 (-26.55 pct)
>  1024    58037.02 (0.00 pct)     40341.84 (-30.48 pct)
>
> NPS2
>
> Clients: tip (5531ecffa4b9)      tip (7e9518baed4c)
>     1    574.20 (0.00 pct)       551.06 (-4.02 pct)
>     2    1131.56 (0.00 pct)      1000.76 (-11.55 pct)
>     4    2132.26 (0.00 pct)      1737.02 (-18.53 pct)
>     8    3812.20 (0.00 pct)      2992.31 (-21.50 pct)
>    16    6457.61 (0.00 pct)      4579.29 (-29.08 pct)
>    32    12263.82 (0.00 pct)     9120.73 (-25.62 pct)
>    64    22224.11 (0.00 pct)     14918.58 (-32.87 pct)
>   128    33040.38 (0.00 pct)     20830.61 (-36.95 pct)
>   256    56547.25 (0.00 pct)     47708.18 (-15.63 pct)
>   512    56220.67 (0.00 pct)     43721.79 (-22.23 pct)
>  1024    56048.88 (0.00 pct)     40920.49 (-26.99 pct)
>
> NPS4
>
> Clients: tip (5531ecffa4b9)      tip (7e9518baed4c)
>     1    575.50 (0.00 pct)       549.22 (-4.56 pct)
>     2    1138.70 (0.00 pct)      1000.08 (-12.17 pct)
>     4    2070.66 (0.00 pct)      1794.78 (-13.32 pct)
>     8    3811.70 (0.00 pct)      3008.50 (-21.07 pct)
>    16    6312.80 (0.00 pct)      4804.71 (-23.88 pct)
>    32    11418.14 (0.00 pct)     9156.57 (-19.80 pct)
>    64    19671.16 (0.00 pct)     14901.45 (-24.24 pct)
>   128    30258.53 (0.00 pct)     20771.20 (-31.35 pct)
>   256    55838.10 (0.00 pct)     47033.88 (-15.76 pct)
>   512    55586.44 (0.00 pct)     43429.01 (-21.87 pct)
>  1024    56370.35 (0.00 pct)     39271.27 (-30.33 pct)
>
> * Note: Ignore the data point as tbench runs into ACPI idle driver issue
> (https://lore.kernel.org/lkml/20220921063638.2489-1-kprateek.nayak@amd.com/)
>
> When bisecting on tip:sched/core, I found the offending commit to be the
> following merge commit:
>
> o commit: 53aa930dc4ba ("Merge branch 'sched/warnings' into sched/core, to pick up WARN_ON_ONCE() conversion commit")
>
> This regression was also observed on Linus' tree and started between
> v5.19 and v6.0-rc1. Bisecting on Linus' tree led us to the following
> merge commit as the offending commit:
>
> o commit: f86d1fbbe785 ("Merge tag 'net-next-6.0' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next")
>
> Bisecting the problem on netdev/net-next between the changes that went in
> v6.0-rc1 led me to the following commit as the offending commit:
>
> o commit: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
>
> This change was tracked back to the series "net: reduce
> tcp_memory_allocated inflation"
> (https://lore.kernel.org/netdev/20220609063412.2205738-1-eric.dumazet@gmail.com/)
>
> The commit 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
> possible") alone does not make sense as it assumes that the reclaims are
> less expensive as a result of per-cpu reserves implemented in
>
> o commit: 0defbb0af775 ("net: add per_cpu_fw_alloc field to struct proto")
> o commit: 3cd3399dd7a8 ("net: implement per-cpu reserves for memory_allocated")
>
> which is part of this series. Following are the results of tbench and
> netperf after applying the series on Linus's tree on top of last
> good commit:
>
> good: 526942b8134c ("Merge tag 'ata-5.20-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata")
>
> On dual socket AMD 3rd Generation EPYC Processor
> (2 x 64C/128T AMD EPYC 7713) in NPS1 mode:
>
> ~~~~~~~~~~
> ~ tbench ~
> ~~~~~~~~~~
>
> Clients:      good                 good + series
>     1    574.93 (0.00 pct)       554.42 (-3.56 pct)
>     2    1135.60 (0.00 pct)      1034.76 (-8.87 pct)
>     4    2117.29 (0.00 pct)      1796.97 (-15.12 pct)
>     8    3799.57 (0.00 pct)      3020.87 (-20.49 pct)
>    16    6129.79 (0.00 pct)      4536.99 (-25.98 pct)
>    32    11630.67 (0.00 pct)     8674.74 (-25.41 pct)
>    64    20895.77 (0.00 pct)     14417.26 (-31.00 pct)
>   128    31989.55 (0.00 pct)     20611.47 (-35.56 pct)
>   256    56388.57 (0.00 pct)     48822.72 (-13.41 pct)
>   512    59326.33 (0.00 pct)     43960.03 (-25.90 pct)
>  1024    58281.10 (0.00 pct)     41256.18 (-29.21 pct)
>
> ~~~~~~~~~~~
> ~ netperf ~
> ~~~~~~~~~~~
>
> - netperf-udp
>
> kernel                     good                   good + series
> Hmean     send-64         346.45 (   0.00%)      346.53 (   0.02%)
> Hmean     send-128        688.39 (   0.00%)      688.53 (   0.02%)
> Hmean     send-256       1355.60 (   0.00%)     1358.59 (   0.22%)
> Hmean     send-1024      5314.81 (   0.00%)     5302.48 (  -0.23%)
> Hmean     send-2048      9757.81 (   0.00%)     9996.26 *   2.44%*
> Hmean     send-3312     15033.99 (   0.00%)    15289.91 (   1.70%)
> Hmean     send-4096     16009.90 (   0.00%)    16441.11 *   2.69%*
> Hmean     send-8192     25039.37 (   0.00%)    24316.10 (  -2.89%)
> Hmean     send-16384    46928.16 (   0.00%)    47746.29 (   1.74%)
> Hmean     recv-64         346.45 (   0.00%)      346.53 (   0.02%)
> Hmean     recv-128        688.39 (   0.00%)      688.53 (   0.02%)
> Hmean     recv-256       1355.60 (   0.00%)     1358.59 (   0.22%)
> Hmean     recv-1024      5314.80 (   0.00%)     5302.47 (  -0.23%)
> Hmean     recv-2048      9757.76 (   0.00%)     9996.25 *   2.44%*
> Hmean     recv-3312     15033.95 (   0.00%)    15289.83 (   1.70%)
> Hmean     recv-4096     16009.84 (   0.00%)    16441.05 *   2.69%*
> Hmean     recv-8192     25039.12 (   0.00%)    24315.81 (  -2.89%)
> Hmean     recv-16384    46927.59 (   0.00%)    47746.12 (   1.74%)
>
> - netperf-tcp
>
> kernel                good                   good + series
> Hmean     64        1846.16 (   0.00%)     1795.84 *  -2.73%*
> Hmean     128       3583.91 (   0.00%)     3448.49 *  -3.78%*
> Hmean     256       6803.96 (   0.00%)     6427.55 *  -5.53%*
> Hmean     1024     21474.74 (   0.00%)    17722.92 * -17.47%*
> Hmean     2048     32904.31 (   0.00%)    28104.16 * -14.59%*
> Hmean     3312     42468.33 (   0.00%)    35616.94 * -16.13%*
> Hmean     4096     45453.37 (   0.00%)    38130.18 * -16.11%*
> Hmean     8192     54372.39 (   0.00%)    47438.78 * -12.75%*
> Hmean     16384    61173.73 (   0.00%)    55459.64 *  -9.34%*
>
> On dual socket 3rd Generation Intel Xeon Scalable Processor
> (2 x 32C/64T Intel Xeon Platinum 8362):
>
> ~~~~~~~~~~
> ~ tbench ~
> ~~~~~~~~~~
>
> Clients:     good                  good + series
>     1    424.31 (0.00 pct)       399.00 (-5.96 pct)
>     2    844.12 (0.00 pct)       797.10 (-5.57 pct)
>     4    1667.07 (0.00 pct)      1543.72 (-7.39 pct)
>     8    3289.42 (0.00 pct)      3036.96 (-7.67 pct)
>    16    6611.76 (0.00 pct)      6095.99 (-7.80 pct)
>    32    12760.69 (0.00 pct)     11451.82 (-10.25 pct)
>    64    17750.13 (0.00 pct)     15796.17 (-11.00 pct)
>   128    15282.56 (0.00 pct)     14492.78 (-5.16 pct)
>   256    36000.91 (0.00 pct)     31496.12 (-12.51 pct)
>   512    35020.84 (0.00 pct)     28975.34 (-17.26 pct)
>
> ~~~~~~~~~~~
> ~ netperf ~
> ~~~~~~~~~~~
>
> - netperf-udp
>
> kernel                     good                   good + series
> Hmean     send-64         234.69 (   0.00%)      232.32 *  -1.01%*
> Hmean     send-128        471.02 (   0.00%)      469.08 *  -0.41%*
> Hmean     send-256        934.75 (   0.00%)      914.79 *  -2.14%*
> Hmean     send-1024      3594.09 (   0.00%)     3562.71 *  -0.87%*
> Hmean     send-2048      6625.58 (   0.00%)     6720.12 *   1.43%*
> Hmean     send-3312     10843.34 (   0.00%)    10818.02 *  -0.23%*
> Hmean     send-4096     12291.20 (   0.00%)    12329.75 *   0.31%*
> Hmean     send-8192     19017.73 (   0.00%)    19348.73 *   1.74%*
> Hmean     send-16384    34952.23 (   0.00%)    34886.12 *  -0.19%*
> Hmean     recv-64         234.69 (   0.00%)      232.32 *  -1.01%*
> Hmean     recv-128        471.02 (   0.00%)      469.08 *  -0.41%*
> Hmean     recv-256        934.75 (   0.00%)      914.79 *  -2.14%*
> Hmean     recv-1024      3594.09 (   0.00%)     3562.71 *  -0.87%*
> Hmean     recv-2048      6625.58 (   0.00%)     6720.12 *   1.43%*
> Hmean     recv-3312     10843.34 (   0.00%)    10817.95 *  -0.23%*
> Hmean     recv-4096     12291.20 (   0.00%)    12329.75 *   0.31%*
> Hmean     recv-8192     19017.72 (   0.00%)    19348.73 *   1.74%*
> Hmean     recv-16384    34952.23 (   0.00%)    34886.12 *  -0.19%*
>
> - netperf-tcp
>
> kernel                good                   good + series
> Hmean     64        2032.37 (   0.00%)     1979.42 *  -2.61%*
> Hmean     128       3951.42 (   0.00%)     3789.31 *  -4.10%*
> Hmean     256       7295.39 (   0.00%)     6989.24 *  -4.20%*
> Hmean     1024     19844.93 (   0.00%)    18863.06 *  -4.95%*
> Hmean     2048     27493.40 (   0.00%)    25395.34 *  -7.63%*
> Hmean     3312     33224.91 (   0.00%)    30145.59 *  -9.27%*
> Hmean     4096     35082.60 (   0.00%)    31510.58 * -10.18%*
> Hmean     8192     39842.02 (   0.00%)    36776.27 *  -7.69%*
> Hmean     16384    44765.12 (   0.00%)    41373.83 *  -7.58%*
>
> On the Zen3 system, running
> perf record -a -e ibs_op//pp --raw-samples -- ./tbench_32_clients.sh
> following are the reports from kernel based on:
>
> o good (11483.6 MB/sec)
>
>    3.54%  swapper          [kernel.vmlinux]          [k] acpi_processor_ffh_cstate_enter
>    2.01%  tbench_srv       [kernel.vmlinux]          [k] copy_user_generic_string
>    1.59%  tbench           [kernel.vmlinux]          [k] net_rx_action
>    1.58%  tbench_srv       [kernel.vmlinux]          [k] net_rx_action
>    1.46%  swapper          [kernel.vmlinux]          [k] psi_group_change
>    1.45%  tbench_srv       [kernel.vmlinux]          [k] read_tsc
>    1.43%  tbench           [kernel.vmlinux]          [k] read_tsc
>    1.24%  tbench           [kernel.vmlinux]          [k] copy_user_generic_string
>    1.15%  swapper          [kernel.vmlinux]          [k] check_preemption_disabled
>    1.10%  tbench           [kernel.vmlinux]          [k] __entry_text_start
>    1.10%  tbench           [kernel.vmlinux]          [k] tcp_ack
>    1.00%  tbench_srv       [kernel.vmlinux]          [k] tcp_ack
>    0.95%  tbench           [kernel.vmlinux]          [k] psi_group_change
>    0.94%  swapper          [kernel.vmlinux]          [k] read_tsc
>    0.93%  tbench_srv       [kernel.vmlinux]          [k] psi_group_change
>    0.91%  swapper          [kernel.vmlinux]          [k] menu_select
>    0.87%  swapper          [kernel.vmlinux]          [k] __switch_to
>
> o good + series (7903.55 MB/sec)
>
>    3.66%  tbench_srv       [kernel.vmlinux]          [k] tcp_cleanup_rbuf
>    3.31%  tbench           [kernel.vmlinux]          [k] tcp_cleanup_rbuf
>    3.30%  tbench           [kernel.vmlinux]          [k] tcp_recvmsg_locked
>    3.16%  tbench_srv       [kernel.vmlinux]          [k] tcp_recvmsg_locked
>    2.76%  swapper          [kernel.vmlinux]          [k] acpi_processor_ffh_cstate_enter
>    2.10%  tbench           [kernel.vmlinux]          [k] tcp_ack_update_rtt
>    2.05%  tbench_srv       [kernel.vmlinux]          [k] copy_user_generic_string
>    2.04%  tbench_srv       [kernel.vmlinux]          [k] tcp_ack_update_rtt
>    1.84%  tbench           [kernel.vmlinux]          [k] check_preemption_disabled
>    1.47%  tbench           [kernel.vmlinux]          [k] __sk_mem_reduce_allocated
>    1.25%  tbench_srv       [kernel.vmlinux]          [k] __sk_mem_reduce_allocated
>    1.23%  tbench_srv       [kernel.vmlinux]          [k] check_preemption_disabled
>    1.11%  swapper          [kernel.vmlinux]          [k] psi_group_change
>    1.10%  tbench           [kernel.vmlinux]          [k] copy_user_generic_string
>    0.95%  tbench           [kernel.vmlinux]          [k] entry_SYSCALL_64
>    0.87%  swapper          [kernel.vmlinux]          [k] check_preemption_disabled
>    0.85%  tbench           [kernel.vmlinux]          [k] read_tsc
>    0.84%  tbench_srv       [kernel.vmlinux]          [k] read_tsc
>    0.82%  swapper          [kernel.vmlinux]          [k] __switch_to
>    0.81%  tbench           [kernel.vmlinux]          [k] __mod_memcg_state
>    0.76%  tbench           [kernel.vmlinux]          [k] psi_group_change
>
> On Intel system, running
> perf record -a -e cycles:ppp -- ./tbench_32_clients.sh
> following are the reports from kernel based on:
>
> o good (12561 MB/sec)
>
>   20.62%  swapper          [kernel.vmlinux]          [k] mwait_idle_with_hints.constprop.0
>    1.55%  tbench_srv       [kernel.vmlinux]          [k] copy_user_enhanced_fast_string
>    1.37%  swapper          [kernel.vmlinux]          [k] psi_group_change
>    0.89%  swapper          [kernel.vmlinux]          [k] check_preemption_disabled
>    0.86%  tbench           tbench                    [.] child_run
>    0.84%  tbench           [kernel.vmlinux]          [k] nft_do_chain
>    0.83%  tbench_srv       [kernel.vmlinux]          [k] nft_do_chain
>    0.79%  tbench_srv       [kernel.vmlinux]          [k] strncpy
>    0.77%  tbench           [kernel.vmlinux]          [k] strncpy
>
> o good + series (11213 MB/sec):
>
>   19.11%  swapper          [kernel.vmlinux]          [k] mwait_idle_with_hints.constprop.0
>    1.90%  tbench_srv       [kernel.vmlinux]          [k] __sk_mem_reduce_allocated
>    1.86%  tbench           [kernel.vmlinux]          [k] __sk_mem_reduce_allocated
>    1.40%  tbench_srv       [kernel.vmlinux]          [k] copy_user_enhanced_fast_string
>    1.31%  swapper          [kernel.vmlinux]          [k] psi_group_change
>    0.86%  tbench           tbench                    [.] child_run
>    0.83%  tbench_srv       [kernel.vmlinux]          [k] check_preemption_disabled
>    0.82%  swapper          [kernel.vmlinux]          [k] check_preemption_disabled
>    0.80%  tbench           [kernel.vmlinux]          [k] check_preemption_disabled
>    0.78%  tbench           [kernel.vmlinux]          [k] nft_do_chain
>    0.78%  tbench_srv       [kernel.vmlinux]          [k] update_sd_lb_stats.constprop.0
>    0.77%  tbench_srv       [kernel.vmlinux]          [k] nft_do_chain
>
> I've inlined some comments below.
>
> On 6/9/2022 12:04 PM, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Currently, tcp_memory_allocated can hit tcp_mem[] limits quite fast.
> >
> > Each TCP socket can forward allocate up to 2 MB of memory, even after
> > flow became less active.
> >
> > 10,000 sockets can have reserved 20 GB of memory,
> > and we have no shrinker in place to reclaim that.
> >
> > Instead of trying to reclaim the extra allocations in some places,
> > just keep sk->sk_forward_alloc values as small as possible.
> >
> > This should not impact performance too much now we have per-cpu
> > reserves: Changes to tcp_memory_allocated should not be too frequent.
> >
> > For sockets not using SO_RESERVE_MEM:
> >  - idle sockets (no packets in tx/rx queues) have zero forward alloc.
> >  - non idle sockets have a forward alloc smaller than one page.
> >
> > Note:
> >
> >  - Removal of SK_RECLAIM_CHUNK and SK_RECLAIM_THRESHOLD
> >    is left to MPTCP maintainers as a follow up.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  include/net/sock.h           | 29 ++---------------------------
> >  net/core/datagram.c          |  3 ---
> >  net/ipv4/tcp.c               |  7 -------
> >  net/ipv4/tcp_input.c         |  4 ----
> >  net/ipv4/tcp_timer.c         | 19 ++++---------------
> >  net/iucv/af_iucv.c           |  2 --
> >  net/mptcp/protocol.c         |  2 +-
> >  net/sctp/sm_statefuns.c      |  2 --
> >  net/sctp/socket.c            |  5 -----
> >  net/sctp/stream_interleave.c |  2 --
> >  net/sctp/ulpqueue.c          |  4 ----
> >  11 files changed, 7 insertions(+), 72 deletions(-)
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index cf288f7e9019106dfb466be707d34dacf33b339c..0063e8410a4e3ed91aef9cf34eb1127f7ce33b93 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -1627,19 +1627,6 @@ static inline void sk_mem_reclaim_final(struct sock *sk)
> >       sk_mem_reclaim(sk);
> >  }
> >
> > -static inline void sk_mem_reclaim_partial(struct sock *sk)
> > -{
> > -     int reclaimable;
> > -
> > -     if (!sk_has_account(sk))
> > -             return;
> > -
> > -     reclaimable = sk->sk_forward_alloc - sk_unused_reserved_mem(sk);
> > -
> > -     if (reclaimable > (int)PAGE_SIZE)
> > -             __sk_mem_reclaim(sk, reclaimable - 1);
> > -}
> > -
> >  static inline void sk_mem_charge(struct sock *sk, int size)
> >  {
> >       if (!sk_has_account(sk))
> > @@ -1647,29 +1634,17 @@ static inline void sk_mem_charge(struct sock *sk, int size)
> >       sk->sk_forward_alloc -= size;
> >  }
> >
> > -/* the following macros control memory reclaiming in sk_mem_uncharge()
> > +/* the following macros control memory reclaiming in mptcp_rmem_uncharge()
> >   */
> >  #define SK_RECLAIM_THRESHOLD (1 << 21)
> >  #define SK_RECLAIM_CHUNK     (1 << 20)
> >
> >  static inline void sk_mem_uncharge(struct sock *sk, int size)
> >  {
> > -     int reclaimable;
> > -
> >       if (!sk_has_account(sk))
> >               return;
> >       sk->sk_forward_alloc += size;
> > -     reclaimable = sk->sk_forward_alloc - sk_unused_reserved_mem(sk);
> > -
> > -     /* Avoid a possible overflow.
> > -      * TCP send queues can make this happen, if sk_mem_reclaim()
> > -      * is not called and more than 2 GBytes are released at once.
> > -      *
> > -      * If we reach 2 MBytes, reclaim 1 MBytes right now, there is
> > -      * no need to hold that much forward allocation anyway.
> > -      */
> > -     if (unlikely(reclaimable >= SK_RECLAIM_THRESHOLD))
> > -             __sk_mem_reclaim(sk, SK_RECLAIM_CHUNK);
> > +     sk_mem_reclaim(sk);
>
> Following are the difference in the count of call to few functions
> between the good and the bad kernel when running tbench with
> 32 clients on both machines:
>
> o AMD Zen3 Machine
>
>         +-------------------------+------------------+---------------+
>         | Kernel                  |            Good  | Good + Series |
>         +-------------------------+------------------+---------------+
>         | Benchmark Result (MB/s) |         11227.9  |        7458.7 |
>         | __sk_mem_reclaim        |             197  |      65293205 | *
>         | skb_release_head_state  |       607219812  |     406127581 |
>         | tcp_ack_update_rtt      |       297442779  |     198937384 |
>         | tcp_cleanup_rbuf        |       892648815  |     596972242 |
>         | tcp_recvmsg_locked      |       594885088  |     397874278 |
>         +-------------------------+------------------+---------------+
>
> o Intel Xeon Machine
>
>         +-------------------------+------------------+---------------+
>         | Kernel                  |            Good  | Good + Series |
>         +-------------------------+------------------+---------------+
>         | Benchmark Result (MB/s) |         11584.9  |       10509.7 |
>         | __sk_mem_reclaim        |             198  |      91139810 | *
>         | skb_release_head_state  |       623382197  |     566914077 |
>         | tcp_ack_update_rtt      |       305357022  |     277699272 |
>         | tcp_cleanup_rbuf        |       916296601  |     833239328 |
>         | tcp_recvmsg_locked      |       610713561  |     555398063 |
>         +-------------------------+------------------+---------------+
>
> As we see, there is a sharp increase in the number of times __sk_mem_reclaim
> is called. I believe we might be doing a reclaim too often and the overhead
> is adding up.
>
> Following is the kstack for most calls to __sk_mem_reclaim taken on
> the AMD Zen3 system using bpftrace on good + series when running
> 32 tbench clients:
> (Found by running: bpftrace -e 'kprobe:__sk_mem_reclaim { @[kstack] = count(); }')
>
> @[
>     __sk_mem_reclaim+1
>     tcp_rcv_established+377
>     tcp_v4_do_rcv+348
>     tcp_v4_rcv+3286
>     ip_protocol_deliver_rcu+33
>     ip_local_deliver_finish+128
>     ip_local_deliver+111
>     ip_rcv+373
>     __netif_receive_skb_one_core+138
>     __netif_receive_skb+21
>     process_backlog+150
>     __napi_poll+51
>     net_rx_action+335
>     __softirqentry_text_start+259
>     do_softirq.part.0+164
>     __local_bh_enable_ip+135
>     ip_finish_output2+413
>     __ip_finish_output+156
>     ip_finish_output+46
>     ip_output+120
>     ip_local_out+94
>     __ip_queue_xmit+391
>     ip_queue_xmit+21
>     __tcp_transmit_skb+2771
>     tcp_write_xmit+914
>     __tcp_push_pending_frames+55
>     tcp_push+264
>     tcp_sendmsg_locked+697
>     tcp_sendmsg+45
>     inet_sendmsg+67
>     sock_sendmsg+98
>     __sys_sendto+286
>     __x64_sys_sendto+36
>     do_syscall_64+92
>     entry_SYSCALL_64_after_hwframe+99
> ]: 28986799
>
> >
> >  [..snip..]
> >
>
> If this is expected based on the tradeoff this series makes, I'll
> continue using the latest baseline numbers for testing. Please let
> me know if there is something obvious that I might have missed.
>
> If you would like me to gather any data on the test systems,
> I'll be happy to get it for you.
> --
> Thanks and Regards,
> Prateek

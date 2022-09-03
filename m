Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9DC5ABBEC
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 02:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiICAxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 20:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiICAxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 20:53:31 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E06CE42C4
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 17:53:30 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-334dc616f86so30183197b3.8
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 17:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=YzGwuPC5+2LUd58CYzBnZFUmYP6VpeM2jTshaS3SzQA=;
        b=OGSBQA8OP35gsDi4YwrIYXi2kfHC4smFdDRDg9pB33iFkfhAYodmxqgYfVlxHrKpON
         CC9pZgfGDaRkXG8uFnL/AacRlnF0hXyYFvriuoUBCI5/PEhBAD51MzpQRFnrd3S/4Mt0
         0EJgz5mukVu7LuW/t1DqoCPuLV8wRFzvrUiriTWtiuCmatPnPr8xG3C77OJxwBloE8YN
         rUmaHRKUpnqMPpe8qvPj4GUu0xc7luLgycoSYg62LPmd9Vs0x7cZchNgnnsiQopWiRV5
         c1KFbHMWyhEVzfhWe1Il7fgS5DOnl+RGjKS8Ah3P+WAGE4UgGJOXIu05Y0BEKOE625OC
         n8Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=YzGwuPC5+2LUd58CYzBnZFUmYP6VpeM2jTshaS3SzQA=;
        b=wOxdZA0NF0l0f7ryEt+cklXgZRUsyjyTx2/mU0ONelMM9+FD+oIUz0S4dFq/GRtfOp
         yrSRi9gXzYHysY88rB4sGyaox1gMpki5YQoaDqRMU31zAHHBg0PgjqUWUHJPoHC5lzjv
         XOJZfob6SczTbEpbfA1DrOq16oeTXsp6vlZWcwV1RVvv91G7l7lakNJ+DTmoCSPTi4lv
         aAo0ILUzy3fZ0pFE2VUZepaATwykjGRScIiS1AmWwKIguNmeWgoIxhsNATS87Ag+VMHp
         d8IZFZLjhBSRa0m+0oQHumGQF8THwPLGvQfAsQT4sWcle1n75jHtEeAQoc+zQzykXRbf
         /N+Q==
X-Gm-Message-State: ACgBeo0t+pE+jFrsy5fvHapFXpPXFtwwKCI4noy92bLKrPLXk6PdjTnH
        SxwsImVk/dCdqRdywYRn84+hHc1yWiwGDW9r9AGtjBa1dvA=
X-Google-Smtp-Source: AA6agR4wdqYxy5ALvoJ9bmntBDwhapbhXy46Q5gwqAyvWDENhartaxzDCHn/VeCjSWxAxvlx/homoZYmg4EQCkTQEww=
X-Received: by 2002:a0d:f045:0:b0:324:55ec:6595 with SMTP id
 z66-20020a0df045000000b0032455ec6595mr29974518ywe.255.1662166409403; Fri, 02
 Sep 2022 17:53:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220901221216.14973-1-kuniyu@amazon.com> <20220903004420.91740-1-kuniyu@amazon.com>
In-Reply-To: <20220903004420.91740-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Sep 2022 17:53:18 -0700
Message-ID: <CANn89iJ4Ehbb2M_ZF0EVUUCSwrN2iqxYro78+UZeYDbaCdZBvg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 3/5] tcp: Access &tcp_hashinfo via net.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 2, 2022 at 5:44 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Kuniyuki Iwashima <kuniyu@amazon.com>
> Date:   Thu, 1 Sep 2022 15:12:16 -0700
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Thu, 1 Sep 2022 14:30:43 -0700
> > > On Thu, Sep 1, 2022 at 2:25 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > From:   Paolo Abeni <pabeni@redhat.com>
> > >
> > > > > /Me is thinking aloud...
> > > > >
> > > > > I'm wondering if the above has some measurable negative effect for
> > > > > large deployments using only the main netns?
> > > > >
> > > > > Specifically, are net->ipv4.tcp_death_row and net->ipv4.tcp_death_row-
> > > > > >hashinfo already into the working set data for established socket?
> > > > > Would the above increase the WSS by 2 cache-lines?
> > > >
> > > > Currently, the death_row and hashinfo are touched around tw sockets or
> > > > connect().  If connections on the deployment are short-lived or frequently
> > > > initiated by itself, that would be host and included in WSS.
> > > >
> > > > If the workload is server and there's no active-close() socket or
> > > > connections are long-lived, then it might not be included in WSS.
> > > > But I think it's not likely than the former if the deployment is
> > > > large enough.
> > > >
> > > > If this change had large impact, then we could revert fbb8295248e1
> > > > which converted net->ipv4.tcp_death_row into pointer for 0dad4087a86a
> > > > that tried to fire a TW timer after netns is freed, but 0dad4087a86a
> > > > has already reverted.
> > >
> > >
> > > Concern was fast path.
> > >
> > > Each incoming packet does a socket lookup.
> > >
> > > Fetching hashinfo (instead of &tcp_hashinfo) with a dereference of a
> > > field in 'struct net' might inccurr a new cache line miss.
> > >
> > > Previously, first cache line of tcp_info was enough to bring a lot of
> > > fields in cpu cache.
> >
> > Ok, let me test on that if there could be regressions.
>
> I tested tcp_hashinfo vs tcp_death_row->hashinfo with super_netperf
> and collected HW cache-related metrics with perf.
>
> After the patch the number of L1 miss seems to increase, but the
> instructions per cycle also increases, and cache miss rate did not
> change.  Also, there was not performance regression for netperf.
>
>
> Tested:
>
> # cat perf_super_netperf
> echo 0 > /proc/sys/kernel/nmi_watchdog
> echo 3 > /proc/sys/vm/drop_caches
>
> perf stat -a \
>      -e cycles,instructions,cache-references,cache-misses,bus-cycles \
>      -e L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores \
>      -e dTLB-loads,dTLB-load-misses \
>      -e LLC-loads,LLC-load-misses,LLC-stores \
>      ./super_netperf $(($(nproc) * 2)) -H 10.0.0.142 -l 60 -fM
>
> echo 1 > /proc/sys/kernel/nmi_watchdog
>
>
> Before:
>
> # ./perf_super_netperf
> 2929.81
>
>  Performance counter stats for 'system wide':
>
>    494,002,600,338      cycles                                                        (23.07%)
>    241,230,662,890      instructions              #    0.49  insn per cycle           (30.76%)
>      6,303,603,008      cache-references                                              (38.45%)
>      1,421,440,332      cache-misses              #   22.550 % of all cache refs      (46.15%)
>      4,861,179,308      bus-cycles                                                    (46.15%)
>     65,410,735,599      L1-dcache-loads                                               (46.15%)
>     12,647,247,339      L1-dcache-load-misses     #   19.34% of all L1-dcache accesses  (30.77%)
>     32,912,656,369      L1-dcache-stores                                              (30.77%)
>     66,015,779,361      dTLB-loads                                                    (30.77%)
>         81,293,994      dTLB-load-misses          #    0.12% of all dTLB cache accesses  (30.77%)
>      2,946,386,949      LLC-loads                                                     (30.77%)
>        257,223,942      LLC-load-misses           #    8.73% of all LL-cache accesses  (30.77%)
>      1,183,820,461      LLC-stores                                                    (15.38%)
>
>       62.132250590 seconds time elapsed
>

This test will not be able to see a difference really...

What is needed is to measure the latency when nothing at all is in the caches.

Vast majority of real world TCP traffic is light or moderate.
Packets are received and cpu has to bring X cache lines into L1 in
order to process one packet.

We slowly are increasing X over time :/

pahole is your friend, more than a stress-test.

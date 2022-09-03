Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF865ABC59
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 04:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiICCaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 22:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiICCao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 22:30:44 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F336C58D5
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 19:30:43 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-344f8f691e2so18792087b3.2
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 19:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=HdsxrjhK3+D1NA+b7tl3AjIjMGOt1f/Z62xLatzQtUQ=;
        b=WjPLFD8op94lI8AueASg5nWPoe4fJ+yp6oN+2ZvPXfDFkHfcrH4RRcfViQSooeW4id
         ztskPDqMR5SuNg9YHduEhMFukfi9XGNiHOOaK3uwhBvViab/rCtBWY5DVHGTGobkg1T0
         1osb3C+hlrXLnKoQ5yIB7vkt39Fkyz2WmGhlM/epOoTYkAMOASer/eVzJtMftK6Ws3Vd
         tXJ/XuiRl1zJzJiW+2RCIN/tkO+rpiNw/OvvL32tqn+fIfemf6I8Q1jepaNN0CgxsBRd
         dz6kUlfy8gDc1quKRc7PHxXZUseOFlCb1asjACKjFWzh4J4gsD9li0i+HpNXPRAQdLef
         y2FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=HdsxrjhK3+D1NA+b7tl3AjIjMGOt1f/Z62xLatzQtUQ=;
        b=ymIUAfthxMUkBXhZzJrOLQi+mfyjcp4MwWrrOZfsmgbXAPE/c7wBeX8g4/TGfx4t1P
         azUSnPyaZyY3YQ1wUgnJRq0tDoqGbWbj5x+lOs4gBM4uB2xq59iGr45pIK7DIdJxQyRm
         B8pnysENobbG6sgBIAxqsqsUmIPHP1V+lDY1hOe4zpfjG9/q4xxMIZ++cDlz7zcLJlzm
         w0jv7zDYx7slpGvCqXtVjzuHYb+9ZAVGGHI/gk7YLxw89Ct0poStlTi0SRAcC5pJPMYf
         BylFsVw0EcclLi1vIF9CnUDUt8rBongqHZ6YhfzbeZAeQy7em4OGdpdlWRa1QUWeffKD
         c4lw==
X-Gm-Message-State: ACgBeo36c104J0RUtfs/X8GNLtmNMbD8sYjxwi0ebnLBRQ5UIVpU5i5q
        Zza4W9R7sLanYnRWyI5quPL2XAoKQZlqrlZhBi0T1D0Byc0=
X-Google-Smtp-Source: AA6agR5kPNCIvTzGU+CwWQ9o7zLP8G8b9skbwr9ZObv4irNsbQHftCJynhmQVhyBqbyANdX9ua7Z8uqeseS/DXLRhoY=
X-Received: by 2002:a81:4fce:0:b0:344:fba8:cb88 with SMTP id
 d197-20020a814fce000000b00344fba8cb88mr3256140ywb.278.1662172242384; Fri, 02
 Sep 2022 19:30:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220903011243.93195-1-kuniyu@amazon.com> <20220903014420.94641-1-kuniyu@amazon.com>
In-Reply-To: <20220903014420.94641-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Sep 2022 19:30:31 -0700
Message-ID: <CANn89iLHKRZU_+vdQAf-RYn5gDxRN4-9_k4wn5N7xAzadGH=EA@mail.gmail.com>
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

On Fri, Sep 2, 2022 at 6:44 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Kuniyuki Iwashima <kuniyu@amazon.com>
> Date:   Fri, 2 Sep 2022 18:12:43 -0700
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Fri, 2 Sep 2022 17:53:18 -0700
> > > On Fri, Sep 2, 2022 at 5:44 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > From:   Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > Date:   Thu, 1 Sep 2022 15:12:16 -0700
> > > > > From:   Eric Dumazet <edumazet@google.com>
> > > > > Date:   Thu, 1 Sep 2022 14:30:43 -0700
> > > > > > On Thu, Sep 1, 2022 at 2:25 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > > >
> > > > > > > From:   Paolo Abeni <pabeni@redhat.com>
> > > > > >
> > > > > > > > /Me is thinking aloud...
> > > > > > > >
> > > > > > > > I'm wondering if the above has some measurable negative effect for
> > > > > > > > large deployments using only the main netns?
> > > > > > > >
> > > > > > > > Specifically, are net->ipv4.tcp_death_row and net->ipv4.tcp_death_row-
> > > > > > > > >hashinfo already into the working set data for established socket?
> > > > > > > > Would the above increase the WSS by 2 cache-lines?
> > > > > > >
> > > > > > > Currently, the death_row and hashinfo are touched around tw sockets or
> > > > > > > connect().  If connections on the deployment are short-lived or frequently
> > > > > > > initiated by itself, that would be host and included in WSS.
> > > > > > >
> > > > > > > If the workload is server and there's no active-close() socket or
> > > > > > > connections are long-lived, then it might not be included in WSS.
> > > > > > > But I think it's not likely than the former if the deployment is
> > > > > > > large enough.
> > > > > > >
> > > > > > > If this change had large impact, then we could revert fbb8295248e1
> > > > > > > which converted net->ipv4.tcp_death_row into pointer for 0dad4087a86a
> > > > > > > that tried to fire a TW timer after netns is freed, but 0dad4087a86a
> > > > > > > has already reverted.
> > > > > >
> > > > > >
> > > > > > Concern was fast path.
> > > > > >
> > > > > > Each incoming packet does a socket lookup.
> > > > > >
> > > > > > Fetching hashinfo (instead of &tcp_hashinfo) with a dereference of a
> > > > > > field in 'struct net' might inccurr a new cache line miss.
> > > > > >
> > > > > > Previously, first cache line of tcp_info was enough to bring a lot of
> > > > > > fields in cpu cache.
> > > > >
> > > > > Ok, let me test on that if there could be regressions.
> > > >
> > > > I tested tcp_hashinfo vs tcp_death_row->hashinfo with super_netperf
> > > > and collected HW cache-related metrics with perf.
> > > >
> > > > After the patch the number of L1 miss seems to increase, but the
> > > > instructions per cycle also increases, and cache miss rate did not
> > > > change.  Also, there was not performance regression for netperf.
> > > >
> > > >
> > > > Tested:
> > > >
> > > > # cat perf_super_netperf
> > > > echo 0 > /proc/sys/kernel/nmi_watchdog
> > > > echo 3 > /proc/sys/vm/drop_caches
> > > >
> > > > perf stat -a \
> > > >      -e cycles,instructions,cache-references,cache-misses,bus-cycles \
> > > >      -e L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores \
> > > >      -e dTLB-loads,dTLB-load-misses \
> > > >      -e LLC-loads,LLC-load-misses,LLC-stores \
> > > >      ./super_netperf $(($(nproc) * 2)) -H 10.0.0.142 -l 60 -fM
> > > >
> > > > echo 1 > /proc/sys/kernel/nmi_watchdog
> > > >
> > > >
> > > > Before:
> > > >
> > > > # ./perf_super_netperf
> > > > 2929.81
> > > >
> > > >  Performance counter stats for 'system wide':
> > > >
> > > >    494,002,600,338      cycles                                                        (23.07%)
> > > >    241,230,662,890      instructions              #    0.49  insn per cycle           (30.76%)
> > > >      6,303,603,008      cache-references                                              (38.45%)
> > > >      1,421,440,332      cache-misses              #   22.550 % of all cache refs      (46.15%)
> > > >      4,861,179,308      bus-cycles                                                    (46.15%)
> > > >     65,410,735,599      L1-dcache-loads                                               (46.15%)
> > > >     12,647,247,339      L1-dcache-load-misses     #   19.34% of all L1-dcache accesses  (30.77%)
> > > >     32,912,656,369      L1-dcache-stores                                              (30.77%)
> > > >     66,015,779,361      dTLB-loads                                                    (30.77%)
> > > >         81,293,994      dTLB-load-misses          #    0.12% of all dTLB cache accesses  (30.77%)
> > > >      2,946,386,949      LLC-loads                                                     (30.77%)
> > > >        257,223,942      LLC-load-misses           #    8.73% of all LL-cache accesses  (30.77%)
> > > >      1,183,820,461      LLC-stores                                                    (15.38%)
> > > >
> > > >       62.132250590 seconds time elapsed
> > > >
> > >
> > > This test will not be able to see a difference really...
> > >
> > > What is needed is to measure the latency when nothing at all is in the caches.
> > >
> > > Vast majority of real world TCP traffic is light or moderate.
> > > Packets are received and cpu has to bring X cache lines into L1 in
> > > order to process one packet.
> > >
> > > We slowly are increasing X over time :/
> > >
> > > pahole is your friend, more than a stress-test.
> >
> > Here's pahole result on my local build.  As Paolo said, we
> > need 2 cachelines for tcp_death_row and the hashinfo?
> >
> > How about moving hashinfo as the first member of struct
> > inet_timewait_death_row and convert it to just struct
> > instead of pointer so that we need 1 cache line to read
> > hashinfo?
>
> Like this.
>
> $ pahole -EC netns_ipv4 vmlinux
> struct netns_ipv4 {
>         struct inet_timewait_death_row {
>                 struct inet_hashinfo * hashinfo __attribute__((__aligned__(64)));        /*     0     8 */
>                 /* typedef refcount_t */ struct refcount_struct {
>                         /* typedef atomic_t */ struct {
>                                 int counter;                                             /*     8     4 */
>                         } refs; /*     8     4 */
>                 } tw_refcount; /*     8     4 */
>                 int                sysctl_max_tw_buckets;                                /*    12     4 */
>         } tcp_death_row __attribute__((__aligned__(64))) __attribute__((__aligned__(64))); /*     0    64 */
>
>         /* XXX last struct has 48 bytes of padding */
>
>         /* --- cacheline 1 boundary (64 bytes) --- */
> ...
> } __attribute__((__aligned__(64)));
>
>
> ---8<---
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index 6320a76cefdc..dee53193d258 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -32,16 +32,15 @@ struct ping_group_range {
>  struct inet_hashinfo;
>
>  struct inet_timewait_death_row {
> -       refcount_t              tw_refcount;
> -
>         struct inet_hashinfo    *hashinfo ____cacheline_aligned_in_smp;
> +       refcount_t              tw_refcount;

This would be very bad. tw_refcount would share a cache line with hashinfo.

false sharing is more problematic than a cache line miss in read mode.

>         int                     sysctl_max_tw_buckets;
>  };
>
>  struct tcp_fastopen_context;
>
>  struct netns_ipv4 {
> -       struct inet_timewait_death_row *tcp_death_row;
> +       struct inet_timewait_death_row tcp_death_row;
>
>  #ifdef CONFIG_SYSCTL
>         struct ctl_table_header *forw_hdr;
> ---8<---
>

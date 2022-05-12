Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC3C52581F
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349139AbiELXKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343976AbiELXKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:10:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB57D1FCC7;
        Thu, 12 May 2022 16:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 267E4CE2A77;
        Thu, 12 May 2022 23:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B61C385B8;
        Thu, 12 May 2022 23:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652397031;
        bh=AOiw8wF4PdvBa3YU1oidYvIy6PmC88xLHJ48WAyDw/g=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=fOjNoVb2DXO/8uT9kYs+2duTISnPYmvsKGh1NfBbeYk8RoEHe2vPQ4I2faPjYGWZ6
         GhU6GCNVWXgCqIzCdsDqL1dcNFYqrSJUnFvAmJAIpzZYLTYolsTMC5/zt0SOi5YJs3
         d1/tOilo94RhD9qzHPZLq/8r99XYbyVoa6P6ZfDN/G26PCjjp+gPBBaude5RJEhAQF
         s7VmBmNdeKhfgXu2M7Gk829iXDp8N5U5Nh8qIRw0G8NIw/R0QLqEyobvR00yAEZGLp
         mtue47JeO3OBaocT/qfyB0Y5/YBj+0OmnO3V1P/diGGr4IQDqFh0fRY+d7OrQ3J8Uf
         CFkoxRfGXu/Ag==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 1635E5C051B; Thu, 12 May 2022 16:10:31 -0700 (PDT)
Date:   Thu, 12 May 2022 16:10:31 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Marco Elver <elver@google.com>, Liu Jian <liujian56@huawei.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] tcp: Add READ_ONCE() to read tcp_orphan_count
Message-ID: <20220512231031.GT1790663@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220512103322.380405-1-liujian56@huawei.com>
 <CANn89iJ7Lo7NNi4TrpKsaxzFrcVXdgbyopqTRQEveSzsDL7CFA@mail.gmail.com>
 <CANpmjNPRB-4f3tUZjycpFVsDBAK_GEW-vxDbTZti+gtJaEx2iw@mail.gmail.com>
 <CANn89iKJ+9=ug79V_bd8LSsLaSu0VLtzZdDLC87rcvQ6UYieHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKJ+9=ug79V_bd8LSsLaSu0VLtzZdDLC87rcvQ6UYieHQ@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 02:31:48PM -0700, Eric Dumazet wrote:
> On Thu, May 12, 2022 at 2:18 PM Marco Elver <elver@google.com> wrote:
> 
> >
> > I guess the question is, is it the norm that per_cpu() retrieves data
> > that can legally be modified concurrently, or not. If not, and in most
> > cases it's a bug, the annotations should be here.
> >
> > Paul, was there any guidance/documentation on this, but I fail to find
> > it right now? (access-marking.txt doesn't say much about per-CPU
> > data.)
> 
> Normally, whenever we add a READ_ONCE(), we are supposed to add a comment.

I am starting to think that comments are even more necessary for unmarked
accesses to shared variables, with the comments setting out why the
compiler cannot mess things up.  ;-)

> We could make an exception for per_cpu_once(), because the comment
> would be centralized
> at per_cpu_once() definition.

This makes a lot of sense to me.

> We will be stuck with READ_ONCE() in places we are using
> per_cpu_ptr(), for example
> in dev_fetch_sw_netstats()

If this is strictly statistics, data_race() is another possibility.
But it does not constrain the compiler at all.

							Thanx, Paul

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1461c2d9dec8099a9a2d43a704b4c6cb0375f480..b66470291d7b7e6c33161093d71e40587f9ed838
> 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10381,10 +10381,13 @@ void dev_fetch_sw_netstats(struct
> rtnl_link_stats64 *s,
>                 stats = per_cpu_ptr(netstats, cpu);
>                 do {
>                         start = u64_stats_fetch_begin_irq(&stats->syncp);
> -                       tmp.rx_packets = stats->rx_packets;
> -                       tmp.rx_bytes   = stats->rx_bytes;
> -                       tmp.tx_packets = stats->tx_packets;
> -                       tmp.tx_bytes   = stats->tx_bytes;
> +                       /* These values can change under us.
> +                        * READ_ONCE() pair with too many write sides...
> +                        */
> +                       tmp.rx_packets = READ_ONCE(stats->rx_packets);
> +                       tmp.rx_bytes   = READ_ONCE(stats->rx_bytes);
> +                       tmp.tx_packets = READ_ONCE(stats->tx_packets);
> +                       tmp.tx_bytes   = READ_ONCE(stats->tx_bytes);
>                 } while (u64_stats_fetch_retry_irq(&stats->syncp, start));
> 
>                 s->rx_packets += tmp.rx_packets;

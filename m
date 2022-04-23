Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4299950C88F
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 11:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbiDWJ2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 05:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbiDWJ17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 05:27:59 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF54887B5
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 02:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jRLDdGh10La+kmGF9pSQLVQ56P1yssnaMAv9h7hTeZU=; b=Zj75KAo74RnSmZSZZ5BWV/Atll
        N+IdN+H4kN4v/ULQWaitLNGVXVLzlDRx8b6MxyQpLKYMIVxxQ4YsCNQiVlPDJLnM8bMawi4zrtidj
        54K0Xym7adnoFb7Be6LenIYripJsg606/nOapAfa0RzKYDWxMFMMmtbWw4/Pr3Yp1tp2z++NQdiTz
        J/Korzz62x8duoYwGevRV6+efD5C9qb10iLz9y/KFgIA/CBUlN7iQkSjxXCtHmixX2QaaCaL7jNa6
        Ldp2jRPmbT8qJ2QCfipK41JpzadfndhmCg3lfgrwFZWsGnqZGHAO80oD37dC95j1hv2ker4di+0N/
        +f9Qiwow==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niC0P-007xnC-Tb; Sat, 23 Apr 2022 09:24:42 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 79B979861AE; Sat, 23 Apr 2022 11:24:39 +0200 (CEST)
Date:   Sat, 23 Apr 2022 11:24:39 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net] net: Use this_cpu_inc() to increment net->core_stats
Message-ID: <20220423092439.GY2731@worktop.programming.kicks-ass.net>
References: <YmFjdOp+R5gVGZ7p@linutronix.de>
 <CANn89iKjSmnTSzzHdnP-HEYMajrz+MOrjFooaMFop4Vo43kLdg@mail.gmail.com>
 <YmGLkz+dIBb5JjFF@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmGLkz+dIBb5JjFF@linutronix.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 06:51:31PM +0200, Sebastian Andrzej Siewior wrote:
> On 2022-04-21 09:06:05 [-0700], Eric Dumazet wrote:
> > On Thu, Apr 21, 2022 at 7:00 AM Sebastian Andrzej Siewior
> > <bigeasy@linutronix.de> wrote:
> > >
> > 
> > >                 for_each_possible_cpu(i) {
> > >                         core_stats = per_cpu_ptr(p, i);
> > > -                       storage->rx_dropped += local_read(&core_stats->rx_dropped);
> > > -                       storage->tx_dropped += local_read(&core_stats->tx_dropped);
> > > -                       storage->rx_nohandler += local_read(&core_stats->rx_nohandler);
> > > +                       storage->rx_dropped += core_stats->rx_dropped;
> > > +                       storage->tx_dropped += core_stats->tx_dropped;
> > > +                       storage->rx_nohandler += core_stats->rx_nohandler;
> > 
> > I think that one of the reasons for me to use  local_read() was that
> > it provided what was needed to avoid future syzbot reports.
> 
> syzbot report due a plain read of a per-CPU variable which might be
> modified?
> 
> > Perhaps use READ_ONCE() here ?
> > 
> > Yes, we have many similar folding loops that are  simply assuming
> > compiler won't do stupid things.
> 
> I wasn't sure about that and added PeterZ to do some yelling here just
> in case. And yes, we have other sites doing exactly that. In
>    Documentation/core-api/this_cpu_ops.rst
> there is nothing about remote-READ-access (only that there should be no
> writes (due to parallel this_cpu_inc() on the local CPU)). I know that a
> 32bit write can be optimized in two 16bit writes in certain cases but a
> read is a read.
> PeterZ? :)

Eric is right. READ_ONCE() is 'required' to ensure the compiler doesn't
split the load and KCSAN konws about these things.

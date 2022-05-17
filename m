Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C7C52ACB6
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 22:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351263AbiEQU2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 16:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbiEQU2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 16:28:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D122252B08;
        Tue, 17 May 2022 13:28:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DCAF616E6;
        Tue, 17 May 2022 20:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC815C385B8;
        Tue, 17 May 2022 20:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652819308;
        bh=ZWAkpabVz1HDAQwuEJZ+QuSTkMhXnE1CAPhGyAj51Ss=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Ts4NTFOo/kHz9JMr2Fjsr2lkkw8k/l0758yDk0sN7oPbZqvEZqkjdvpmL8ZM9xmDp
         RG4O205n7i9ptfMGSg3yqzh8fUtf+5XuW6ciYND3iRM4lH009UCCw+kElJiQ9T1fW3
         f0hUc5r7UrrHT3VIyMa1tWwR9CObW304HPy9cUzWkVqTpez7T4mln14Vg5XiBWIGGB
         c1FuhSDJH3itVCB6MoVbjv3/aSkAP0CEzRR24jeWxqvV5w6cZvzKz2YxyUTHQogIDW
         aXXRussQ3bhTTpS6zQGSd1zwLj/tIxap7U7nFX3ai5huB0dRlKmy+cNiam6Ijzd4d7
         5X8Q688Oy+v+A==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 4C9335C086D; Tue, 17 May 2022 13:28:28 -0700 (PDT)
Date:   Tue, 17 May 2022 13:28:28 -0700
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
Message-ID: <20220517202828.GF1790663@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220512103322.380405-1-liujian56@huawei.com>
 <CANn89iJ7Lo7NNi4TrpKsaxzFrcVXdgbyopqTRQEveSzsDL7CFA@mail.gmail.com>
 <CANpmjNPRB-4f3tUZjycpFVsDBAK_GEW-vxDbTZti+gtJaEx2iw@mail.gmail.com>
 <CANn89iKJ+9=ug79V_bd8LSsLaSu0VLtzZdDLC87rcvQ6UYieHQ@mail.gmail.com>
 <20220512231031.GT1790663@paulmck-ThinkPad-P17-Gen-1>
 <CANn89iKiTiGwMvV6K+Zbr_9+knaR-x1N3tOeMX+2No2=4zn6pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKiTiGwMvV6K+Zbr_9+knaR-x1N3tOeMX+2No2=4zn6pA@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 04:43:20PM -0700, Eric Dumazet wrote:
> On Thu, May 12, 2022 at 4:10 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Thu, May 12, 2022 at 02:31:48PM -0700, Eric Dumazet wrote:
> > > On Thu, May 12, 2022 at 2:18 PM Marco Elver <elver@google.com> wrote:
> > >
> > > >
> > > > I guess the question is, is it the norm that per_cpu() retrieves data
> > > > that can legally be modified concurrently, or not. If not, and in most
> > > > cases it's a bug, the annotations should be here.
> > > >
> > > > Paul, was there any guidance/documentation on this, but I fail to find
> > > > it right now? (access-marking.txt doesn't say much about per-CPU
> > > > data.)
> > >
> > > Normally, whenever we add a READ_ONCE(), we are supposed to add a comment.
> >
> > I am starting to think that comments are even more necessary for unmarked
> > accesses to shared variables, with the comments setting out why the
> > compiler cannot mess things up.  ;-)
> >
> > > We could make an exception for per_cpu_once(), because the comment
> > > would be centralized
> > > at per_cpu_once() definition.
> >
> > This makes a lot of sense to me.
> >
> > > We will be stuck with READ_ONCE() in places we are using
> > > per_cpu_ptr(), for example
> > > in dev_fetch_sw_netstats()
> >
> > If this is strictly statistics, data_race() is another possibility.
> > But it does not constrain the compiler at all.
> 
> Statistics are supposed to be monotonically increasing ;)
> 
> Some SNMP agents would be very confused if they could observe 'garbage' there.
> 
> I sense that we are going to add thousands of READ_ONCE() soon :/

Indeed, adding READ_ONCE() instances can be annoying.  Then again, it
can also be annoying to have to debug the problems that sometimes arise
from omitting them where they are needed.

							Thanx, Paul

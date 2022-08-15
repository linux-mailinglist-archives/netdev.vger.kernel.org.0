Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC5159319A
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243054AbiHOPRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242993AbiHOPRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:17:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EECD27B28;
        Mon, 15 Aug 2022 08:16:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 559C0CE10F8;
        Mon, 15 Aug 2022 15:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CE9C433D6;
        Mon, 15 Aug 2022 15:16:52 +0000 (UTC)
Date:   Mon, 15 Aug 2022 11:16:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <thoiland@redhat.com>, Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
Message-ID: <20220815111658.58d75672@gandalf.local.home>
In-Reply-To: <CAADnVQLhHm-gxJXTbWxJN0fFGW_dyVV+5D-JahVA1Wrj2cGu7g@mail.gmail.com>
References: <20191211123017.13212-1-bjorn.topel@gmail.com>
        <20191211123017.13212-3-bjorn.topel@gmail.com>
        <20220815101303.79ace3f8@gandalf.local.home>
        <CAADnVQLhHm-gxJXTbWxJN0fFGW_dyVV+5D-JahVA1Wrj2cGu7g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Aug 2022 07:31:23 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > When I heard that ftrace was broken by BPF I thought it was something
> > unique they were doing, but unfortunately, I didn't investigate what they
> > were doing at the time.  
> 
> ftrace is still broken and refusing to accept the fact doesn't make it
> non-broken.

I extended Jiri's patch to make it work again.

> 
> > Then they started sending me patches to hide fentry locations from ftrace.
> > And even telling me that fentry != ftrace  
> 
> It sounds that you've invented nop5 and kernel's ability
> to replace nop5 with a jump or call.

Actually I did invent it.

   https://lore.kernel.org/lkml/20080210072109.GR4100@elte.hu/


I'm the one that introduced the code to convert mcount into the 5 byte nop,
and did the research and development to make it work at run time. I had one
hiccup along the way that caused the e1000e network card breakage.

The "daemon" approach was horrible, and then I created the recordmcount.pl
perl script to accomplish the same thing at compile time.

> ftrace should really stop trying to own all of the kernel text rewrites.
> It's in the way. Like this case.

It's not trying to own all modifications (static_calls is not ftrace). But
the code at the start of functions with fentry does belong to it.

> 
> >    https://lore.kernel.org/all/CAADnVQJTT7h3MniVqdBEU=eLwvJhEKNLSjbUAK4sOrhN=zggCQ@mail.gmail.com/
> >
> > Even though fentry was created for ftrace
> >
> >    https://lore.kernel.org/lkml/1258720459.22249.1018.camel@gandalf.stny.rr.com/
> >
> > and all the work with fentry was for the ftrace infrastructure. Ftrace
> > takes a lot of care for security and use cases for other users (like
> > live kernel patching). But BPF has the NIH syndrome, and likes to own
> > everything and recreate the wheel so that they have full control.
> >  
> > > of the trampoline. One dispatcher instance currently supports up to 64
> > > dispatch points. A user creates a dispatcher with its corresponding
> > > trampoline with the DEFINE_BPF_DISPATCHER macro.  
> >
> > Anyway, this patch just looks like a re-implementation of static_calls:  
> 
> It was implemented long before static_calls made it to the kernel
> and it's different. Please do your home work.

Long before? This code made it into the kernel in Dec 2019. Yes static calls
finally made it into the kernel in 2020, but it was first introduced in
October 2018:

  https://lore.kernel.org/all/20181006015110.653946300@goodmis.org/

If you had Cc'd us on this patch, we could have collaborated and come up
with something that would have worked for you.

It took time to get in because we don't just push our features in, we make
sure that they are generic and work for others, and is secure and robust.

I sent a proof of concept, Josh took over, Linus had issues, and finally
Peter pushed it through the gate. It's a long process, but we don't break
others code while doing it!

-- Steve

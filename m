Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC48944E9FB
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhKLP2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhKLP2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:28:16 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74811C0613F5
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 07:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PcLdz4lRZUGKKpIupg7p0GTxBM/SPhX6ahCCs6/fNKY=; b=CRX/bFoW4yerG+xbLr0VgmwVCn
        KjuvzZ19U/uzLLxxs9hWL5E9pbxjCJzvZI5SUCU3ptvkteEpVNcK6+AVRY2xvV/SSzxW4rhaxhmJJ
        5oaEs/QGn7yOaEQDjiwiIY8GIQAVVIqoO0Y7KGV+iNecd5lJIwuHJNRtAOhaVAipp09jJexlU7YT9
        BvBkFolMGjuRQhshydzWt5iFUWfG8LlHitr8oPyDHrEJDj054GweJDQbl7des/t+BgmN6yE1cFGwF
        KMA4A7Mt1jclgad4DkdWuWo1paku3tLhOpAFh7JXLxm6BObw/QlF8T18vuonPbU/vI4pk1H6fuf5d
        7C0oi3Dg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mlYQX-00FeD7-Sz; Fri, 12 Nov 2021 15:25:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 43BB330001C;
        Fri, 12 Nov 2021 16:25:17 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E32E62BAEA085; Fri, 12 Nov 2021 16:25:16 +0100 (CET)
Date:   Fri, 12 Nov 2021 16:25:16 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v1] x86/csum: rewrite csum_partial()
Message-ID: <YY6HXBK7UN4YqBJm@hirez.programming.kicks-ass.net>
References: <20211111181025.2139131-1-eric.dumazet@gmail.com>
 <CAKgT0UdmECakQTinbTagiG4PWfaniP_GP6T3rLvWdP+mVrB4xw@mail.gmail.com>
 <CANn89iJAakUCC6UuUHSozT9wz7_rrgrRq3dv+hXJ1FL_DCZHyA@mail.gmail.com>
 <YY4wPgyt65Q6WOdK@hirez.programming.kicks-ass.net>
 <CANn89iJNvxatTTcHvzNKuUu2HyNfH=O7XesA3pHUwfn4Qy=pJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJNvxatTTcHvzNKuUu2HyNfH=O7XesA3pHUwfn4Qy=pJQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 06:21:38AM -0800, Eric Dumazet wrote:
> On Fri, Nov 12, 2021 at 1:13 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Thu, Nov 11, 2021 at 02:30:50PM -0800, Eric Dumazet wrote:
> > > > For values 7 through 1 I wonder if you wouldn't be better served by
> > > > just doing a single QWORD read and a pair of shifts. Something along
> > > > the lines of:
> > > >     if (len) {
> > > >         shift = (8 - len) * 8;
> > > >         temp64 = (*(unsigned long)buff << shift) >> shift;
> > > >         result += temp64;
> > > >         result += result < temp64;
> > > >     }
> > >
> > > Again, KASAN will not be happy.
> >
> > If you do it in asm, kasan will not know, so who cares :-) as long as
> > the load is aligned, loading beyond @len shouldn't be a problem,
> > otherwise there's load_unaligned_zeropad().
> 
> OK, but then in this case we have to align buff on qword boundary,
> or risk crossing page boundary.

Read the above, use load_unaligned_zeropad(), it's made for exactly that
case.

Slightly related, see:

  https://lkml.kernel.org/r/20211110101326.141775772@infradead.org

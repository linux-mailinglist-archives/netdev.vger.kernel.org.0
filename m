Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72352EE742
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbhAGUxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:53:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbhAGUxj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:53:39 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9406B2311E;
        Thu,  7 Jan 2021 20:52:57 +0000 (UTC)
Date:   Thu, 7 Jan 2021 15:52:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [BUG] from x86: Support kmap_local() forced debugging
Message-ID: <20210107155256.7af2505e@gandalf.local.home>
In-Reply-To: <CAHk-=wh+KfbJ4Wrz4A+hFRRj7ZYWysz9L8s-BosC3bhV6vN-nQ@mail.gmail.com>
References: <20201118194838.753436396@linutronix.de>
        <20201118204007.169209557@linutronix.de>
        <20210106180132.41dc249d@gandalf.local.home>
        <CAHk-=wh2895wXEXYtb70CTgW+UR7jfh6VFhJB_bOrF0L7UKoEg@mail.gmail.com>
        <20210106174917.3f8ad0d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+FuTSevLSxZkNLdJPHqRRksxZmnPc1qFBYJeBx26WsA4A1M7A@mail.gmail.com>
        <CA+FuTScQ9afdnQ3E1mqdeyJ-sOq=2Dm9c1XDN8mnzbEig8iMXA@mail.gmail.com>
        <CAHk-=wh+KfbJ4Wrz4A+hFRRj7ZYWysz9L8s-BosC3bhV6vN-nQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 11:47:02 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Jan 6, 2021 at 8:45 PM Willem de Bruijn <willemb@google.com> wrote:
> >
> > But there are three other kmap_atomic callers under net/ that do not
> > loop at all, so assume non-compound pages. In esp_output_head,
> > esp6_output_head and skb_seq_read. The first two directly use
> > skb_page_frag_refill, which can allocate compound (but not
> > __GFP_HIGHMEM) pages, and the third can be inserted with
> > netfilter xt_string in the path of tcp transmit skbs, which can also
> > have compound pages. I think that these could similarly access
> > data beyond the end of the kmap_atomic mapped page. I'll take
> > a closer look.  
> 
> Thanks.
> 
> Note that I have flushed my random one-liner patch from my system, and
> expect to get a proper fix through the normal networking pulls.
> 
> And _if_ the networking people feel that my one-liner was the proper
> fix, you can use it and add my sign-off if you want to, but it really
> was more of a "this is the quick ugly fix for testing" rather than
> anything else.
> 

Please add:

  Link: https://lore.kernel.org/linux-mm/20210106180132.41dc249d@gandalf.local.home/
  Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

And if you take Linus's patch, please add my:

  Tested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

and if you come up with another patch, please send it to me for testing.

Thanks!

-- Steve

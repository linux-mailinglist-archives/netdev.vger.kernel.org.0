Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD24A81D6
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 14:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbfIDMHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 08:07:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:33924 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729316AbfIDMHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 08:07:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AA79EB66A;
        Wed,  4 Sep 2019 12:07:07 +0000 (UTC)
Date:   Wed, 4 Sep 2019 14:07:07 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Qian Cai <cai@lca.pw>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190904120707.GU3838@dhcp22.suse.cz>
References: <229ebc3b-1c7e-474f-36f9-0fa603b889fb@gmail.com>
 <20190903132231.GC18939@dhcp22.suse.cz>
 <1567525342.5576.60.camel@lca.pw>
 <20190903185305.GA14028@dhcp22.suse.cz>
 <1567546948.5576.68.camel@lca.pw>
 <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV>
 <20190904070042.GA11968@jagdpanzerIV>
 <20190904082540.GI3838@dhcp22.suse.cz>
 <1567598357.5576.70.camel@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567598357.5576.70.camel@lca.pw>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 04-09-19 07:59:17, Qian Cai wrote:
> On Wed, 2019-09-04 at 10:25 +0200, Michal Hocko wrote:
> > On Wed 04-09-19 16:00:42, Sergey Senozhatsky wrote:
> > > On (09/04/19 15:41), Sergey Senozhatsky wrote:
> > > > But the thing is different in case of dump_stack() + show_mem() +
> > > > some other output. Because now we ratelimit not a single printk() line,
> > > > but hundreds of them. The ratelimit becomes - 10 * $$$ lines in 5 seconds
> > > > (IOW, now we talk about thousands of lines).
> > > 
> > > And on devices with slow serial consoles this can be somewhat close to
> > > "no ratelimit". *Suppose* that warn_alloc() adds 700 lines each time.
> > > Within 5 seconds we can call warn_alloc() 10 times, which will add 7000
> > > lines to the logbuf. If printk() can evict only 6000 lines in 5 seconds
> > > then we have a growing number of pending logbuf messages.
> > 
> > Yes, ratelimit is problematic when the ratelimited operation is slow. I
> > guess that is a well known problem and we would need to rework both the
> > api and the implementation to make it work in those cases as well.
> > Essentially we need to make the ratelimit act as a gatekeeper to an
> > operation section - something like a critical section except you can
> > tolerate more code executions but not too many. So effectively
> > 
> > 	start_throttle(rate, number);
> > 	/* here goes your operation */
> > 	end_throttle();
> > 
> > one operation is not considered done until the whole section ends.
> > Or something along those lines.
> > 
> > In this particular case we can increase the rate limit parameters of
> > course but I think that longterm we need a better api.
> 
> The problem is when a system is under heavy memory pressure, everything is
> becoming slower, so I don't know how to come up with a sane default for rate
> limit parameters as a generic solution that would work for every machine out
> there. Sure, it is possible to set a limit as low as possible that would work
> for the majority of systems apart from people may complain that they are now
> missing important warnings, but using __GFP_NOWARN in this code would work for
> all systems. You could even argument there is even a separate benefit that it
> could reduce the noise-level overall from those build_skb() allocation failures
> as it has a fall-back mechanism anyway.

As Vlastimil already pointed out, __GFP_NOWARN would hide that reserves
might be configured too low.
-- 
Michal Hocko
SUSE Labs

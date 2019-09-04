Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77932A7DD0
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 10:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfIDIZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 04:25:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:41322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726358AbfIDIZm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 04:25:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6FFC6AE89;
        Wed,  4 Sep 2019 08:25:41 +0000 (UTC)
Date:   Wed, 4 Sep 2019 10:25:40 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Qian Cai <cai@lca.pw>, Eric Dumazet <eric.dumazet@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190904082540.GI3838@dhcp22.suse.cz>
References: <6109dab4-4061-8fee-96ac-320adf94e130@gmail.com>
 <1567178728.5576.32.camel@lca.pw>
 <229ebc3b-1c7e-474f-36f9-0fa603b889fb@gmail.com>
 <20190903132231.GC18939@dhcp22.suse.cz>
 <1567525342.5576.60.camel@lca.pw>
 <20190903185305.GA14028@dhcp22.suse.cz>
 <1567546948.5576.68.camel@lca.pw>
 <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV>
 <20190904070042.GA11968@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904070042.GA11968@jagdpanzerIV>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 04-09-19 16:00:42, Sergey Senozhatsky wrote:
> On (09/04/19 15:41), Sergey Senozhatsky wrote:
> > But the thing is different in case of dump_stack() + show_mem() +
> > some other output. Because now we ratelimit not a single printk() line,
> > but hundreds of them. The ratelimit becomes - 10 * $$$ lines in 5 seconds
> > (IOW, now we talk about thousands of lines).
> 
> And on devices with slow serial consoles this can be somewhat close to
> "no ratelimit". *Suppose* that warn_alloc() adds 700 lines each time.
> Within 5 seconds we can call warn_alloc() 10 times, which will add 7000
> lines to the logbuf. If printk() can evict only 6000 lines in 5 seconds
> then we have a growing number of pending logbuf messages.

Yes, ratelimit is problematic when the ratelimited operation is slow. I
guess that is a well known problem and we would need to rework both the
api and the implementation to make it work in those cases as well.
Essentially we need to make the ratelimit act as a gatekeeper to an
operation section - something like a critical section except you can
tolerate more code executions but not too many. So effectively

	start_throttle(rate, number);
	/* here goes your operation */
	end_throttle();

one operation is not considered done until the whole section ends.
Or something along those lines.

In this particular case we can increase the rate limit parameters of
course but I think that longterm we need a better api.
-- 
Michal Hocko
SUSE Labs

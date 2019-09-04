Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27939A7C17
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 08:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbfIDGy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 02:54:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:45228 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727499AbfIDGy6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 02:54:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ABD1DACFA;
        Wed,  4 Sep 2019 06:54:56 +0000 (UTC)
Date:   Wed, 4 Sep 2019 08:54:55 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Qian Cai <cai@lca.pw>, Eric Dumazet <eric.dumazet@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190904065455.GE3838@dhcp22.suse.cz>
References: <1567177025-11016-1-git-send-email-cai@lca.pw>
 <6109dab4-4061-8fee-96ac-320adf94e130@gmail.com>
 <1567178728.5576.32.camel@lca.pw>
 <229ebc3b-1c7e-474f-36f9-0fa603b889fb@gmail.com>
 <20190903132231.GC18939@dhcp22.suse.cz>
 <1567525342.5576.60.camel@lca.pw>
 <20190903185305.GA14028@dhcp22.suse.cz>
 <1567546948.5576.68.camel@lca.pw>
 <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190904064144.GA5487@jagdpanzerIV>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 04-09-19 15:41:44, Sergey Senozhatsky wrote:
> On (09/04/19 08:15), Michal Hocko wrote:
> > > If you look at the original report, the failed allocation dump_stack() is,
> > > 
> > >  <IRQ>
> > >  warn_alloc.cold.43+0x8a/0x148
> > >  __alloc_pages_nodemask+0x1a5c/0x1bb0
> > >  alloc_pages_current+0x9c/0x110
> > >  allocate_slab+0x34a/0x11f0
> > >  new_slab+0x46/0x70
> > >  ___slab_alloc+0x604/0x950
> > >  __slab_alloc+0x12/0x20
> > >  kmem_cache_alloc+0x32a/0x400
> > >  __build_skb+0x23/0x60
> > >  build_skb+0x1a/0xb0
> > >  igb_clean_rx_irq+0xafc/0x1010 [igb]
> > >  igb_poll+0x4bb/0xe30 [igb]
> > >  net_rx_action+0x244/0x7a0
> > >  __do_softirq+0x1a0/0x60a
> > >  irq_exit+0xb5/0xd0
> > >  do_IRQ+0x81/0x170
> > >  common_interrupt+0xf/0xf
> > >  </IRQ>
> > > 
> > > Since it has no __GFP_NOWARN to begin with, it will call,
> 
> I think that DEFAULT_RATELIMIT_INTERVAL and DEFAULT_RATELIMIT_BURST
> are good when we ratelimit just a single printk() call, so the ratelimit
> is "max 10 kernel log lines in 5 seconds".

I am sorry, I could have been more explicit when CCing you. Sure the
ratelimit is part of the problem. But I was more interested in the
potential livelock (infinite loop) mentioned by Qian Cai. It is not
important whether we generate one or more lines of output from the
softirq context as long as the printk generates more irq processing
which might end up doing the same. Is this really possible?
-- 
Michal Hocko
SUSE Labs

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1393FA7B60
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 08:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbfIDGPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 02:15:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:33342 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726589AbfIDGPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 02:15:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8055DACB4;
        Wed,  4 Sep 2019 06:15:02 +0000 (UTC)
Date:   Wed, 4 Sep 2019 08:15:01 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Qian Cai <cai@lca.pw>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190904061501.GB3838@dhcp22.suse.cz>
References: <1567177025-11016-1-git-send-email-cai@lca.pw>
 <6109dab4-4061-8fee-96ac-320adf94e130@gmail.com>
 <1567178728.5576.32.camel@lca.pw>
 <229ebc3b-1c7e-474f-36f9-0fa603b889fb@gmail.com>
 <20190903132231.GC18939@dhcp22.suse.cz>
 <1567525342.5576.60.camel@lca.pw>
 <20190903185305.GA14028@dhcp22.suse.cz>
 <1567546948.5576.68.camel@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1567546948.5576.68.camel@lca.pw>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc printk maintainers

On Tue 03-09-19 17:42:28, Qian Cai wrote:
> > > I suppose what happens is those skb_build() allocations are from softirq,
> > > and
> > > once one of them failed, it calls printk() which generates more interrupts.
> > > Hence, the infinite loop.
> > 
> > Please elaborate more.
> > 
> 
> If you look at the original report, the failed allocation dump_stack() is,
> 
>  <IRQ>
>  warn_alloc.cold.43+0x8a/0x148
>  __alloc_pages_nodemask+0x1a5c/0x1bb0
>  alloc_pages_current+0x9c/0x110
>  allocate_slab+0x34a/0x11f0
>  new_slab+0x46/0x70
>  ___slab_alloc+0x604/0x950
>  __slab_alloc+0x12/0x20
>  kmem_cache_alloc+0x32a/0x400
>  __build_skb+0x23/0x60
>  build_skb+0x1a/0xb0
>  igb_clean_rx_irq+0xafc/0x1010 [igb]
>  igb_poll+0x4bb/0xe30 [igb]
>  net_rx_action+0x244/0x7a0
>  __do_softirq+0x1a0/0x60a
>  irq_exit+0xb5/0xd0
>  do_IRQ+0x81/0x170
>  common_interrupt+0xf/0xf
>  </IRQ>
> 
> Since it has no __GFP_NOWARN to begin with, it will call,
> 
> printk
>   vprintk_default
>     vprintk_emit
>       wake_up_klogd
>         irq_work_queue
>           __irq_work_queue_local
>             arch_irq_work_raise
>               apic->send_IPI_self(IRQ_WORK_VECTOR)
>                 smp_irq_work_interrupt
>                   exiting_irq
>                     irq_exit
> 
> and end up processing pending net_rx_action softirqs again which are plenty due
> to connected via ssh etc.
-- 
Michal Hocko
SUSE Labs

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 865E763EE5
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 03:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfGJBSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 21:18:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:50994 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726218AbfGJBSY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 21:18:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8F6FDAE62;
        Wed, 10 Jul 2019 01:18:23 +0000 (UTC)
Date:   Wed, 10 Jul 2019 10:18:16 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] [PATCH net-next 16/16] qlge: Refill empty buffer queues
 from wq
Message-ID: <20190710011816.GA13881@f1>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-16-bpoirier@suse.com>
 <DM6PR18MB2697EC53399F214EC3DFC4ABABFD0@DM6PR18MB2697.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR18MB2697EC53399F214EC3DFC4ABABFD0@DM6PR18MB2697.namprd18.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/27 14:18, Manish Chopra wrote:
> > -----Original Message-----
> > From: Benjamin Poirier <bpoirier@suse.com>
> > Sent: Monday, June 17, 2019 1:19 PM
> > To: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> > NIC-Dev@marvell.com>; netdev@vger.kernel.org
> > Subject: [EXT] [PATCH net-next 16/16] qlge: Refill empty buffer queues from
> > wq
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > When operating at mtu 9000, qlge does order-1 allocations for rx buffers in
> > atomic context. This is especially unreliable when free memory is low or
> > fragmented. Add an approach similar to commit 3161e453e496 ("virtio: net
> > refill on out-of-memory") to qlge so that the device doesn't lock up if there
> > are allocation failures.
> > 
[...]
> > +
> > +static void ql_update_buffer_queues(struct rx_ring *rx_ring, gfp_t gfp,
> > +				    unsigned long delay)
> > +{
> > +	bool sbq_fail, lbq_fail;
> > +
> > +	sbq_fail = !!qlge_refill_bq(&rx_ring->sbq, gfp);
> > +	lbq_fail = !!qlge_refill_bq(&rx_ring->lbq, gfp);
> > +
> > +	/* Minimum number of buffers needed to be able to receive at least
> > one
> > +	 * frame of any format:
> > +	 * sbq: 1 for header + 1 for data
> > +	 * lbq: mtu 9000 / lb size
> > +	 * Below this, the queue might stall.
> > +	 */
> > +	if ((sbq_fail && QLGE_BQ_HW_OWNED(&rx_ring->sbq) < 2) ||
> > +	    (lbq_fail && QLGE_BQ_HW_OWNED(&rx_ring->lbq) <
> > +	     DIV_ROUND_UP(9000, LARGE_BUFFER_MAX_SIZE)))
> > +		/* Allocations can take a long time in certain cases (ex.
> > +		 * reclaim). Therefore, use a workqueue for long-running
> > +		 * work items.
> > +		 */
> > +		queue_delayed_work_on(smp_processor_id(),
> > system_long_wq,
> > +				      &rx_ring->refill_work, delay);
> >  }
> > 
> 
> This is probably going to mess up when at the interface load time (qlge_open()) allocation failure occurs, in such cases we don't really want to re-try allocations
> using refill_work but rather simply fail the interface load.

Why would you want to turn a recoverable failure into a fatal failure?

In case of allocation failure at ndo_open time, allocations are retried
later from a workqueue. Meanwhile, the device can use the available rx
buffers (if any could be allocated at all).

> Just to make sure here in such cases it shouldn't lead to kernel panic etc. while completing qlge_open() and
> leaving refill_work executing in background. Or probably handle such allocation failures from the napi context and schedule refill_work from there.
> 

I've just tested allocation failures at open time and didn't find
problems; with mtu 9000, using bcc, for example:
tools/inject.py -P 0.5 -c 100 alloc_page "should_fail_alloc_page(gfp_t gfp_mask, unsigned int order) (order == 1) => qlge_refill_bq()"

What exact scenario do you have in mind that's going to lead to
problems? Please try it out and describe it precisely.

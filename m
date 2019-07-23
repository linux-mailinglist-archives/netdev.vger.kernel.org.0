Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B1A71B39
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 17:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390805AbfGWPOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 11:14:48 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41108 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390789AbfGWPOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 11:14:46 -0400
Received: from [66.61.193.110] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hpwUv-0004qL-B6; Tue, 23 Jul 2019 11:14:39 -0400
Date:   Tue, 23 Jul 2019 11:14:31 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 10/12] drop_monitor: Add packet alert mode
Message-ID: <20190723151431.GA8419@localhost.localdomain>
References: <20190722183134.14516-1-idosch@idosch.org>
 <20190722183134.14516-11-idosch@idosch.org>
 <20190723124340.GA10377@hmswarspite.think-freely.org>
 <20190723141625.GA8972@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723141625.GA8972@splinter>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 05:16:25PM +0300, Ido Schimmel wrote:
> On Tue, Jul 23, 2019 at 08:43:40AM -0400, Neil Horman wrote:
> > On Mon, Jul 22, 2019 at 09:31:32PM +0300, Ido Schimmel wrote:
> > > +static void net_dm_packet_work(struct work_struct *work)
> > > +{
> > > +	struct per_cpu_dm_data *data;
> > > +	struct sk_buff_head list;
> > > +	struct sk_buff *skb;
> > > +	unsigned long flags;
> > > +
> > > +	data = container_of(work, struct per_cpu_dm_data, dm_alert_work);
> > > +
> > > +	__skb_queue_head_init(&list);
> > > +
> > > +	spin_lock_irqsave(&data->drop_queue.lock, flags);
> > > +	skb_queue_splice_tail_init(&data->drop_queue, &list);
> > > +	spin_unlock_irqrestore(&data->drop_queue.lock, flags);
> > > +
> > These functions are all executed in a per-cpu context.  While theres nothing
> > wrong with using a spinlock here, I think you can get away with just doing
> > local_irqsave and local_irq_restore.
> 
> Hi Neil,
> 
> Thanks a lot for reviewing. I might be missing something, but please
> note that this function is executed from a workqueue and therefore the
> CPU it is running on does not have to be the same CPU to which 'data'
> belongs to. If so, I'm not sure how I can avoid taking the spinlock, as
> otherwise two different CPUs can modify the list concurrently.
> 
Ah, my bad, I was under the impression that the schedule_work call for
that particular work queue was actually a call to schedule_work_on,
which would have affined it to a specific cpu.  That said, looking at
it, I think using schedule_work_on was my initial intent, as the work
queue is registered per cpu.  And converting it to schedule_work_on
would allow you to reduce the spin_lock to a faster local_irqsave

Otherwise though, this looks really good to me
Neil

> > 
> > Neil
> > 
> > > +	while ((skb = __skb_dequeue(&list)))
> > > +		net_dm_packet_report(skb);
> > > +}
> 

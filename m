Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E9F17F44C
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgCJKE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:04:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25529 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726202AbgCJKE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 06:04:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583834667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=75XxGyBhGZpid39HG6bYXkzzrDloQi7n8AN38dznEDk=;
        b=QYcZhDF8QmO66fCrkohEMmQh5geofrymyc+1E6fyBderGWdQhTDhatLm1AV5DSAZ3XSLrW
        iyitPhNhdFqj+VTgMqh347gnyyg0O7YUEuMdCR8kRdHmca+uY5M9XDdFQBBnPQpRA/W4YY
        yjljpNjlWOURUVr3J/8YLxA3kLE5C+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-Yk3ILf66OTui2CrcAVJf3A-1; Tue, 10 Mar 2020 06:04:23 -0400
X-MC-Unique: Yk3ILf66OTui2CrcAVJf3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34B80DBC5;
        Tue, 10 Mar 2020 10:04:21 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 623C94D701;
        Tue, 10 Mar 2020 10:04:14 +0000 (UTC)
Date:   Tue, 10 Mar 2020 11:04:12 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        brouer@redhat.com, Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH] page_pool: use irqsave/irqrestore to protect ring
 access.
Message-ID: <20200310110412.66b60677@carbon>
In-Reply-To: <9b09170da05fb59bde7b003be282dfa63edd969e.camel@mellanox.com>
References: <20200309194929.3889255-1-jonathan.lemon@gmail.com>
        <20200309.175534.1029399234531592179.davem@davemloft.net>
        <9b09170da05fb59bde7b003be282dfa63edd969e.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Mar 2020 02:30:34 +0000
Saeed Mahameed <saeedm@mellanox.com> wrote:

> On Mon, 2020-03-09 at 17:55 -0700, David Miller wrote:
> > From: Jonathan Lemon <jonathan.lemon@gmail.com>
> > Date: Mon, 9 Mar 2020 12:49:29 -0700
> >   
> > > netpoll may be called from IRQ context, which may access the
> > > page pool ring.  The current _bh variants do not provide sufficient
> > > protection, so use irqsave/restore instead.
> > > 
> > > Error observed on a modified mlx4 driver, but the code path exists
> > > for any driver which calls page_pool_recycle from napi poll.

Netpoll calls into drivers are problematic, nasty and annoying. Drivers
usually catch netpoll calls via seeing NAPI budget is zero, and handle
the situation inside the driver e.g.[1][2]. (even napi_consume_skb
catch it this way).

[1] https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c#L3179
[2] https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c#L1110

> > > 
> > > WARNING: CPU: 34 PID: 550248 at /ro/source/kernel/softirq.c:161  
> > __local_bh_enable_ip+0x35/0x50
> >  ...  
> > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>  
> > 
> > The netpoll stuff always makes the locking more complicated than it
> > needs to be.  I wonder if there is another way around this issue?
> > 
> > Because IRQ save/restore is a high cost to pay in this critical path.  

Yes, huge NACK from me, this would kill performance. We need to find
another way.


> a printk inside irq context lead to this, so maybe it can be avoided ..
> 
> or instead of checking in_serving_softirq()  change page_pool to
> check in_interrupt() which is more powerful, to avoid ptr_ring locking
> and the complication with netpoll altogether.
> 
> I wonder why Jesper picked in_serving_softirq() in first place, was
> there a specific reason ? or he just wanted it to be as less strict as
> possible ?

I wanted to make it specific that this is optimized for softirq.

I actually think this is a regression we have introduced recently in
combined patches:

 304db6cb7610 ("page_pool: refill page when alloc.count of pool is zero")
 44768decb7c0 ("page_pool: handle page recycle for NUMA_NO_NODE condition")

I forgot that the in_serving_softirq() check was also protecting us
when getting called from netpoll.  The general idea before was that if
the in_serving_softirq() check failed, then we falled-through to
slow-path calling normal alloc_pages_node (regular page allocator).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


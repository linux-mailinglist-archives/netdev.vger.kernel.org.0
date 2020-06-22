Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688B52037FD
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgFVN2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:28:43 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22035 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728164AbgFVN2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 09:28:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592832521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4y6mNPOOEym8w04Pf3sX/tKuWabKGUMvxiFNGB2kiqw=;
        b=gk9X5sCKC33//7q+1xmfaIrqzxZQWUi0UDAdDZR+juGzPRxUuLcjB1kL9fNtGa0Yhx4yCS
        mrcCnUNOjqx6IqemNc8zCVX8XHE0MfjqR9Q9UE/jRQlly5aVp7U9iYgZVgNvOoOx4k226t
        noyUqslxcDghMQ2b09eeeunEizYPPkw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-b0XG_I6mOqGd4uEHQChe-g-1; Mon, 22 Jun 2020 09:28:37 -0400
X-MC-Unique: b0XG_I6mOqGd4uEHQChe-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D3931015DB1;
        Mon, 22 Jun 2020 13:28:36 +0000 (UTC)
Received: from carbon (unknown [10.40.208.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BFDF2C724;
        Mon, 22 Jun 2020 13:28:29 +0000 (UTC)
Date:   Mon, 22 Jun 2020 15:28:28 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH net-next v10 2/3] xen networking: add basic XDP support
 for xen-netfront
Message-ID: <20200622152828.368748ba@carbon>
In-Reply-To: <CAOJe8K28RQuiAKADY2pgad8qAzVXYxYcZnb8m0AJGSZTnAfJqA@mail.gmail.com>
References: <1592817672-2053-1-git-send-email-kda@linux-powerpc.org>
        <1592817672-2053-3-git-send-email-kda@linux-powerpc.org>
        <20200622115804.3c63aba9@carbon>
        <CAOJe8K28RQuiAKADY2pgad8qAzVXYxYcZnb8m0AJGSZTnAfJqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Jun 2020 15:45:46 +0300
Denis Kirjanov <kda@linux-powerpc.org> wrote:

> On 6/22/20, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> >
> > On Mon, 22 Jun 2020 12:21:11 +0300 Denis Kirjanov <kda@linux-powerpc.org>
> > wrote:
> >  
> >> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> >> index 482c6c8..1b9f49e 100644
> >> --- a/drivers/net/xen-netfront.c
> >> +++ b/drivers/net/xen-netfront.c  
> > [...]  
> >> @@ -560,6 +572,65 @@ static u16 xennet_select_queue(struct net_device
> >> *dev, struct sk_buff *skb,
> >>  	return queue_idx;
> >>  }
> >>
> >> +static int xennet_xdp_xmit_one(struct net_device *dev, struct xdp_frame
> >> *xdpf)
> >> +{
> >> +	struct netfront_info *np = netdev_priv(dev);
> >> +	struct netfront_stats *tx_stats = this_cpu_ptr(np->tx_stats);
> >> +	unsigned int num_queues = dev->real_num_tx_queues;
> >> +	struct netfront_queue *queue = NULL;
> >> +	struct xen_netif_tx_request *tx;
> >> +	unsigned long flags;
> >> +	int notify;
> >> +
> >> +	queue = &np->queues[smp_processor_id() % num_queues];
> >> +
> >> +	spin_lock_irqsave(&queue->tx_lock, flags);  
> >
> > Why are you taking a lock per packet (xdp_frame)?  
> Hi Jesper,
> 
> We have to protect shared ring indices.

Sure, I understand we need to protect the rings.

What I'm asking is why are doing this per-packet, and not once for the
entire bulk of packets?

(notice how xennet_xdp_xmit gets a bulk of packets)

> >  
> >> +
> >> +	tx = xennet_make_first_txreq(queue, NULL,
> >> +				     virt_to_page(xdpf->data),
> >> +				     offset_in_page(xdpf->data),
> >> +				     xdpf->len);
> >> +
> >> +	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&queue->tx, notify);
> >> +	if (notify)
> >> +		notify_remote_via_irq(queue->tx_irq);
> >> +
> >> +	u64_stats_update_begin(&tx_stats->syncp);
> >> +	tx_stats->bytes += xdpf->len;
> >> +	tx_stats->packets++;
> >> +	u64_stats_update_end(&tx_stats->syncp);
> >> +
> >> +	xennet_tx_buf_gc(queue);
> >> +
> >> +	spin_unlock_irqrestore(&queue->tx_lock, flags);  
> >
> > Is the irqsave/irqrestore variant really needed here?  
> 
> netpoll also invokes the tx completion handler.

I forgot about netpoll.

The netpoll code cannot call this code path xennet_xdp_xmit /
xennet_xdp_xmit_one, right?

Are the per-CPU ring queue's shared with normal network stack, that can
be called from netpoll code path?

  queue = &np->queues[smp_processor_id() % num_queues];


> >  
> >> +	return 0;
> >> +}
> >> +
> >> +static int xennet_xdp_xmit(struct net_device *dev, int n,
> >> +			   struct xdp_frame **frames, u32 flags)
> >> +{
> >> +	int drops = 0;
> >> +	int i, err;
> >> +
> >> +	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
> >> +		return -EINVAL;
> >> +
> >> +	for (i = 0; i < n; i++) {
> >> +		struct xdp_frame *xdpf = frames[i];
> >> +
> >> +		if (!xdpf)
> >> +			continue;
> >> +		err = xennet_xdp_xmit_one(dev, xdpf);
> >> +		if (err) {
> >> +			xdp_return_frame_rx_napi(xdpf);
> >> +			drops++;
> >> +		}
> >> +	}
> >> +
> >> +	return n - drops;
> >> +}  

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


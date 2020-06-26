Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C3B20B123
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 14:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgFZMJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 08:09:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53356 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727977AbgFZMJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 08:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593173378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kfj92452NJe5JGoCPDDPSwIWIJcAyW+GTwTJT+pmyKU=;
        b=OvhBcGP7W1AHpfJczguUjHPF4QE3wMzmucT4ypsy/NXCU8hJy6kgrkOyvbY9YWCvoQWnw/
        xKXUF9Q7fexVavpwTNuenOjO+UF0vYp0CF4499S6rG+U3u+sp32IMks01f/0JXFfpgNfZU
        h+1MQgoPVd9n5jvbolkt/GQjBv4RuyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-KXY1lvMUPf6UQkRt85xjSQ-1; Fri, 26 Jun 2020 08:09:36 -0400
X-MC-Unique: KXY1lvMUPf6UQkRt85xjSQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9F77800597;
        Fri, 26 Jun 2020 12:09:34 +0000 (UTC)
Received: from carbon (unknown [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D6C6512FE;
        Fri, 26 Jun 2020 12:09:32 +0000 (UTC)
Date:   Fri, 26 Jun 2020 14:09:31 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH net-next v13 2/3] xen networking: add basic XDP support
 for xen-netfront
Message-ID: <20200626140931.2daea960@carbon>
In-Reply-To: <1593171639-8136-3-git-send-email-kda@linux-powerpc.org>
References: <1593171639-8136-1-git-send-email-kda@linux-powerpc.org>
        <1593171639-8136-3-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020 14:40:38 +0300
Denis Kirjanov <kda@linux-powerpc.org> wrote:

> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 482c6c8..91a3b53 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
[...]
> @@ -560,6 +572,67 @@ static u16 xennet_select_queue(struct net_device *dev, struct sk_buff *skb,
>  	return queue_idx;
>  }
>  
> +static int xennet_xdp_xmit_one(struct net_device *dev,
> +			       struct netfront_queue *queue,
> +			       struct xdp_frame *xdpf)
> +{
> +	struct netfront_info *np = netdev_priv(dev);
> +	struct netfront_stats *tx_stats = this_cpu_ptr(np->tx_stats);
> +	struct xen_netif_tx_request *tx;
> +	int notify;
> +
> +	tx = xennet_make_first_txreq(queue, NULL,
> +				     virt_to_page(xdpf->data),
> +				     offset_in_page(xdpf->data),
> +				     xdpf->len);
> +
> +	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&queue->tx, notify);
> +	if (notify)
> +		notify_remote_via_irq(queue->tx_irq);

Is this an expensive operation?

Do you think this can be moved outside the loop?
So that it is called once per bulk.


> +	u64_stats_update_begin(&tx_stats->syncp);
> +	tx_stats->bytes += xdpf->len;
> +	tx_stats->packets++;
> +	u64_stats_update_end(&tx_stats->syncp);
> +
> +	xennet_tx_buf_gc(queue);
> +
> +	return 0;
> +}
> +
> +static int xennet_xdp_xmit(struct net_device *dev, int n,
> +			   struct xdp_frame **frames, u32 flags)
> +{
> +	unsigned int num_queues = dev->real_num_tx_queues;
> +	struct netfront_info *np = netdev_priv(dev);
> +	struct netfront_queue *queue = NULL;
> +	unsigned long irq_flags;
> +	int drops = 0;
> +	int i, err;
> +
> +	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
> +		return -EINVAL;
> +
> +	queue = &np->queues[smp_processor_id() % num_queues];
> +
> +	spin_lock_irqsave(&queue->tx_lock, irq_flags);
> +	for (i = 0; i < n; i++) {
> +		struct xdp_frame *xdpf = frames[i];
> +
> +		if (!xdpf)
> +			continue;
> +		err = xennet_xdp_xmit_one(dev, queue, xdpf);
> +		if (err) {
> +			xdp_return_frame_rx_napi(xdpf);
> +			drops++;
> +		}
> +	}
> +	spin_unlock_irqrestore(&queue->tx_lock, irq_flags);
> +
> +	return n - drops;
> +}


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


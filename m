Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12512F8A8F
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbhAPBse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:48:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAPBse (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 20:48:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EEBA23A50;
        Sat, 16 Jan 2021 01:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610761673;
        bh=eSYqxJ7Nlk8keT0cX+xqu8yB6SMzhWaEO0A7RxLLnDk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EDnb4tQpcqFZtwtiMTa2t7nuGuUzCjU/26F7oNhYSUVV5LartJ/SyZpXKEaOmISbP
         BM8tGT6DZZ/meo8qavCMENlGM53xVLidESWamLqQ2FNPPmG+yCLdODy2pjFjdBcjoL
         bK3++2lUFoCGf4AzQIOHK/1VkrnyNOBY3sWO5IeHn9igi3Qga3NPDTglFuYHTYbksV
         w9XjXQ5Y38H54ZSOZ1/DVQlaDnKzu/95q9ces5tA8agMshKimbFSTNVyo306JuZ7/g
         MDhJFJON3l3SSLtLhKMCGpfBpKFw6242DuAhg4XfHRpBjfS0EjchNKK/Dei3Ke0oXV
         tW8yJjI1zWVFw==
Date:   Fri, 15 Jan 2021 17:47:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        dust.li@linux.alibaba.com
Subject: Re: [PATCH netdev] virtio-net: support XDP_TX when not more queues
Message-ID: <20210115174752.3d2e8109@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <81abae33fc8dbec37ef0061ff6f6fd696b484a3e.1610523188.git.xuanzhuo@linux.alibaba.com>
References: <81abae33fc8dbec37ef0061ff6f6fd696b484a3e.1610523188.git.xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 16:08:57 +0800 Xuan Zhuo wrote:
> The number of queues implemented by many virtio backends is limited,
> especially some machines have a large number of CPUs. In this case, it
> is often impossible to allocate a separate queue for XDP_TX.
> 
> This patch allows XDP_TX to run by reuse the existing SQ with
> __netif_tx_lock() hold when there are not enough queues.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Since reviews are not coming in let me share some of mine.

nit: please put [PATCH net-next] not [PATCH netdev]

> -static struct send_queue *virtnet_xdp_sq(struct virtnet_info *vi)
> +static struct send_queue *virtnet_get_xdp_sq(struct virtnet_info *vi)
>  {
>  	unsigned int qp;
> +	struct netdev_queue *txq;

nit: please order variable declaration lines longest to shortest

> +
> +	if (vi->curr_queue_pairs > nr_cpu_ids) {
> +		qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + smp_processor_id();
> +	} else {
> +		qp = smp_processor_id() % vi->curr_queue_pairs;
> +		txq = netdev_get_tx_queue(vi->dev, qp);
> +		__netif_tx_lock(txq, raw_smp_processor_id());
> +	}
>  
> -	qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + smp_processor_id();
>  	return &vi->sq[qp];
>  }
>  
> +static void virtnet_put_xdp_sq(struct virtnet_info *vi)
> +{
> +	unsigned int qp;
> +	struct netdev_queue *txq;

nit: longest to shortest

> +
> +	if (vi->curr_queue_pairs <= nr_cpu_ids) {
> +		qp = smp_processor_id() % vi->curr_queue_pairs;

Feels a little wasteful to do the modulo calculation twice per packet.

> +		txq = netdev_get_tx_queue(vi->dev, qp);
> +		__netif_tx_unlock(txq);
> +	}
> +}

> +	vi->xdp_enabled = false;
>  	if (prog) {
>  		for (i = 0; i < vi->max_queue_pairs; i++) {
>  			rcu_assign_pointer(vi->rq[i].xdp_prog, prog);
>  			if (i == 0 && !old_prog)
>  				virtnet_clear_guest_offloads(vi);
>  		}
> +		vi->xdp_enabled = true;

is xdp_enabled really needed? can't we do the headroom calculation
based on the program pointer being not NULL? Either way xdp_enabled 
should not temporarily switch true -> false -> true when program 
is swapped.

>  	}
>  
>  	for (i = 0; i < vi->max_queue_pairs; i++) {


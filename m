Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C392F08BF
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 18:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbhAJRdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:33:00 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:59618 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbhAJRc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 12:32:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1610299979; x=1641835979;
  h=references:from:to:cc:subject:in-reply-to:message-id:
   date:mime-version;
  bh=53IswJP02WCUyYLpxxIOy4w+ktMC/JPW0yPsDJAfVR4=;
  b=i5tSpgKlkJ5KNvpVoTEU+69woZxG4lZoWGojAs/Q00niig+Lwqz/BiF0
   x6ThAm/6vFSL6uw9253yLSmAxrjN7SzlYIRcXoDL2MoFJN6Ai3b2V7rKr
   bILbtJrDzssl+HahtiR38qwzB8zwEJ9XauAElH4mNXxjUdvVFuZFb1EQv
   E=;
X-IronPort-AV: E=Sophos;i="5.79,336,1602547200"; 
   d="scan'208";a="76559476"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 10 Jan 2021 17:32:12 +0000
Received: from EX13D28EUC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 54D0FA04CF;
        Sun, 10 Jan 2021 17:32:10 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.162.94) by
 EX13D28EUC002.ant.amazon.com (10.43.164.254) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 10 Jan 2021 17:32:05 +0000
References: <20210109024950.4043819-1-charlie@charlie.bz>
 <20210109024950.4043819-3-charlie@charlie.bz>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Charlie Somerville <charlie@charlie.bz>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mst@redhat.com>,
        <jasowang@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] virtio_net: Implement XDP_FLAGS_NO_TX support
In-Reply-To: <20210109024950.4043819-3-charlie@charlie.bz>
Message-ID: <pj41zlpn2cpukf.fsf@u68c7b5b1d2d758.ant.amazon.com>
Date:   Sun, 10 Jan 2021 19:31:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.94]
X-ClientProxiedBy: EX13D06UWC001.ant.amazon.com (10.43.162.91) To
 EX13D28EUC002.ant.amazon.com (10.43.164.254)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Charlie Somerville <charlie@charlie.bz> writes:

> No send queues will be allocated for XDP filters. Attempts to 
> transmit
> packets when no XDP send queues exist will fail with EOPNOTSUPP.
>
> Signed-off-by: Charlie Somerville <charlie@charlie.bz>
> ---
>  drivers/net/virtio_net.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 508408fbe78f..ed08998765e0 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -485,6 +485,10 @@ static struct send_queue 
> *virtnet_xdp_sq(struct virtnet_info *vi)
>  {
>  	unsigned int qp;
>  
> +	/* If no queue pairs are allocated for XDP use, return 
> NULL */
> +	if (vi->xdp_queue_pairs == 0)
> +		return NULL;
> +
>  	qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + 
>  smp_processor_id();
>  	return &vi->sq[qp];
>  }
> @@ -514,6 +518,11 @@ static int virtnet_xdp_xmit(struct 
> net_device *dev,
>  
>  	sq = virtnet_xdp_sq(vi);
>  
> +	/* No send queue exists if program was attached with 
> XDP_NO_TX */
> +	if (unlikely(!sq)) {
> +		return -EOPNOTSUPP;
> +	}
> +
>  	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
>  		ret = -EINVAL;
>  		drops = n;
> @@ -1464,7 +1473,7 @@ static int virtnet_poll(struct napi_struct 
> *napi, int budget)
>  
>  	if (xdp_xmit & VIRTIO_XDP_TX) {
>  		sq = virtnet_xdp_sq(vi);
> -		if (virtqueue_kick_prepare(sq->vq) && 
> virtqueue_notify(sq->vq)) {
> +		if (sq && virtqueue_kick_prepare(sq->vq) && 
> virtqueue_notify(sq->vq)) {

Is this addition needed ? Seems like we don't set VIRTIO_XDP_TX 
bit in case of virtnet_xdp_xmit() failure, so the surrounding 'if' 
won't be taken.

>  			u64_stats_update_begin(&sq->stats.syncp);
>  			sq->stats.kicks++;
>  			u64_stats_update_end(&sq->stats.syncp);
> @@ -2388,7 +2397,7 @@ static int 
> virtnet_restore_guest_offloads(struct virtnet_info *vi)
...
>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD0A2E1FC8
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 18:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgLWRO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 12:14:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:38286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgLWRO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 12:14:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB84422202;
        Wed, 23 Dec 2020 17:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608743626;
        bh=qmTMa9lSuuSm2XZ5ja0n+u8oUv/CyBev2vPCt8NrB0M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KUE2akLmaK6jET7gtbtiTTeG7yupaxsB8GrZww3vT5gr8mMWtwZXHla+uA7t+/Iu2
         9Kkq35vd6szc1vgcMmtaeApSHdyNytnRn0CN2l3TR/6EAV7G4PMnzvObtKYKa1f7d0
         RDBKba0N6fj9S9jaJPrGkPU5Iq58DUYV5JNrY56dsoK3ukm/+xcIPepNKIJwsLAwk8
         wvKXEADbNiYATYFzfjBcVu0I5rTHHN+cT2LPU45h5kM3nGbp0p6bYkCcbU5eDMmMNl
         j6h2/dW7aGAmESMc813B2hYY9ASMI/ZJpXr7T+3LvGPn/xAIA3I5K7TGdStSMmVJM/
         3Tyw/hYfDC8LA==
Date:   Wed, 23 Dec 2020 09:13:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Dike <jdike@akamai.com>
Cc:     <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH Repost to netdev] virtio_net: Fix recursive call to
 cpus_read_lock()
Message-ID: <20201223091344.1363c061@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201223025421.671-1-jdike@akamai.com>
References: <20201223025421.671-1-jdike@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Dec 2020 21:54:21 -0500 Jeff Dike wrote:
> virtnet_set_channels can recursively call cpus_read_lock if CONFIG_XPS
> and CONFIG_HOTPLUG are enabled.
> 
> The path is:
>     virtnet_set_channels - calls get_online_cpus(), which is a trivial
> wrapper around cpus_read_lock()
>     netif_set_real_num_tx_queues
>     netif_reset_xps_queues_gt
>     netif_reset_xps_queues - calls cpus_read_lock()
> 
> This call chain and potential deadlock happens when the number of TX
> queues is reduced.
> 
> This commit the removes netif_set_real_num_[tr]x_queues calls from
> inside the get/put_online_cpus section, as they don't require that it
> be held.

Fixes: 47be24796c13 ("virtio-net: fix the set affinity bug when CPU IDs are not consecutive")

> Signed-off-by: Jeff Dike <jdike@akamai.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Cc: stable@vger.kernel.org

Queued for stable.

> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 052975ea0af4..e02c7e0f1cf9 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2093,14 +2093,16 @@ static int virtnet_set_channels(struct net_device *dev,
>  
>  	get_online_cpus();
>  	err = _virtnet_set_queues(vi, queue_pairs);
> -	if (!err) {
> -		netif_set_real_num_tx_queues(dev, queue_pairs);
> -		netif_set_real_num_rx_queues(dev, queue_pairs);
> -
> -		virtnet_set_affinity(vi);
> +	if (err){

Added missing space here.

> +		put_online_cpus();
> +		goto err;
>  	}

And applied, thanks!

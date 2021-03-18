Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074493400BC
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 09:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhCRISY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 04:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhCRISR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 04:18:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D6C264EF6;
        Thu, 18 Mar 2021 08:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616055497;
        bh=3E9H2zpeiDX6zhLzzRcdnJAvRLq5r0LmDVSbVqSH5PY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=toPoZYi70tiuUwSJYqo92mplFfSeGWj2ik1yhufFzen5C/HeF0MbGYzDQYB46llDj
         4LCHbAPmBGvIeD6di0GoC+M5803q0r4t7a7AE4k06k3wJYsPf12qD0V3/NrP0ohEZm
         eJB7ZjL4cshxkdRAVtC3mAxMcouDKNP+n9nw1TSU3iTHu6Jx0ODcDbE74ihKmGvwyU
         ahbCDNPeQopboh+9SPM75PGBUTCqAPHat9pW3Q1ZooeY/I/nPHkOs4v5EPkWdOIm8V
         H9L4QuAASoDvtS7+nghvIORXU5tfBT0k/6VE5/7x3T0i/n8IsFmbQkAh/kkDeqLgxU
         qzRWQ90DG0mKA==
Date:   Thu, 18 Mar 2021 10:18:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] virtio_net: replace if (cond) BUG() with BUG_ON()
Message-ID: <YFMMxSHGNxjw29iA@unreal>
References: <1615960635-29735-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615960635-29735-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 01:57:15PM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
>
> ./drivers/net/virtio_net.c:1551:2-5: WARNING: Use BUG_ON instead of if
> condition followed by BUG.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 82e520d..093530b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1545,10 +1545,8 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
>  	else
>  		hdr = skb_vnet_hdr(skb);
>
> -	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
> -				    virtio_is_little_endian(vi->vdev), false,
> -				    0))
> -		BUG();
> +	BUG_ON(virtio_net_hdr_from_skb(skb, &hdr->hdr,  virtio_is_little_endian(vi->vdev),
> +				       false, 0));

This BUG() in virtio isn't supposed to be in the first place.
You should return -EINVAL instead of crashing system.

Thanks

>
>  	if (vi->mergeable_rx_bufs)
>  		hdr->num_buffers = 0;
> --
> 1.8.3.1
>

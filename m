Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC32F39CD3A
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 06:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFFEuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 00:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229630AbhFFEuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Jun 2021 00:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BBA66136D;
        Sun,  6 Jun 2021 04:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622954901;
        bh=xaAcrglNijmjCFRiE7xF8pepjMBrLn/aQY5rCt+Ggk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WrpMwiDMuvUaTuOHiy5T1Dr5GHq+5lJmfe5CN0f5E+Rqn3yieIB4CQjUopy6FhUfd
         B3i9xpfbkVXtEX6Fhpr7G/wtQlTQGTnUxhCootQP3vzTyce6cFtwhTdpSGkV66KesB
         oZ7ON8SdBgHhaC6mS4jrXZKfPQM7bo/rkK5OLDtpL4b16t1ZYrnezkgt7lo9g4EgfK
         BXiFgQ/0ep4eoYeSkCikWa61Z163AuRBH7P3oZWezN1QB+PEejE1a2Dm738QBDUzuS
         OonzJrQo2e5xR1GMbLT0Ctev/hmxAAIfAhDNYPF0RSU9Dg9AwfyKMBgcatV+11SqrC
         MDpcM2J405MXA==
Date:   Sun, 6 Jun 2021 07:48:17 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Xianting Tian <xianting_tian@126.com>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: Re: [PATCH] [v2] virtio_net: Remove BUG() to avoid machine dead
Message-ID: <YLxTkVmD3AD9pVX6@unreal>
References: <1622907060-8417-1-git-send-email-xianting_tian@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622907060-8417-1-git-send-email-xianting_tian@126.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 11:31:00AM -0400, Xianting Tian wrote:
> From: Xianting Tian <xianting.tian@linux.alibaba.com>
> 
> We should not directly BUG() when there is hdr error, it is
> better to output a print when such error happens. Currently,
> the caller of xmit_skb() already did it.
> 
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9b6a4a8..7f11ea4 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1623,7 +1623,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
>  	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
>  				    virtio_is_little_endian(vi->vdev), false,
>  				    0))
> -		BUG();
> +		return -EPROTO;

Yeah, as we discussed, BUG*() macros in non-core code that checks
in-kernel API better to be deleted.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

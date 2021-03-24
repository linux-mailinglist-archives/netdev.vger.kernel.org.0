Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77A7348419
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCXVqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231481AbhCXVqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 17:46:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DE1B61A05;
        Wed, 24 Mar 2021 21:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616622395;
        bh=gI1D/G+1afPaDraNQvsyYcDsNZJRz9RZKiMLdbpSlU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IIqamj3zAm83MWnRkoGXszfcURiq7VFDoh2gRP7WTblidaRl0CTyXYJzIUXtSqi8C
         wcrS1RlmOYGLwMb0/F9oGkM5eG8NMji95u+1gFuOHx5tB1mW43HuRPN6UtzQvjn6Ca
         jXqJjkEhkhlWTAlOORWbKIftzYqrIivtVfDwFF8cZfHRG761KZd1ChatnzG6ktb6U/
         CR0jeW3oEJxbYAs41l49HwxWnf/HTSjUfYSbkUYte8OR7fxvHhJvVelTtv+11HG4tp
         B6ei7AL+zAY4OvH/oHfT+bBTZ9LhmU8VzKwt+byeEZdZGiiTV7WgJnS7bgngdZB2eq
         R2PVzspmBo+Og==
Date:   Wed, 24 Mar 2021 14:46:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH net-next 2/2] net: mhi: proto_mbim: Adjust MTU
 and MRU
Message-ID: <20210324144634.15234869@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1616510707-27210-2-git-send-email-loic.poulain@linaro.org>
References: <1616510707-27210-1-git-send-email-loic.poulain@linaro.org>
        <1616510707-27210-2-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Mar 2021 15:45:07 +0100 Loic Poulain wrote:
> MBIM protocol makes the interface asymmetric, ingress data received
> from MHI is MBIM protocol, that can contain multiple aggregated IP
> packets, while egress data received from network stack is IP protocol.
> 
> Set a default MTU to 1500 (usual network MTU for WWAN), and MRU to 32K
> which is the default size of MBIM-over-MHI packets.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/net/mhi/proto_mbim.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/mhi/proto_mbim.c b/drivers/net/mhi/proto_mbim.c
> index 75b5484..29d8577 100644
> --- a/drivers/net/mhi/proto_mbim.c
> +++ b/drivers/net/mhi/proto_mbim.c
> @@ -26,6 +26,9 @@
>  
>  #define MBIM_NDP16_SIGN_MASK 0x00ffffff
>  
> +#define MHI_MBIM_DEFAULT_MRU 32768
> +#define MHI_MBIM_DEFAULT_MTU 1500
> +
>  struct mbim_context {
>  	u16 rx_seq;
>  	u16 tx_seq;
> @@ -282,6 +285,8 @@ static int mbim_init(struct mhi_net_dev *mhi_netdev)
>  		return -ENOMEM;
>  
>  	ndev->needed_headroom = sizeof(struct mbim_tx_hdr);
> +	ndev->mtu = MHI_MBIM_DEFAULT_MTU;
> +	mhi_netdev->mru = MHI_MBIM_DEFAULT_MRU;
>  
>  	return 0;
>  }

32k + skb overhead will result in rather large contiguous allocation.
Using ~3.5k buffers (basically a page - paddings and skb_shinfo) should
be much more resilient, and still very efficient.

This sort of 32k buffer thing is common for USB, but I thought MHI is
over PCI so there should be no bus considerations once we're above 1k.

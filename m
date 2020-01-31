Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E6714EDCD
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 14:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgAaNsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 08:48:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728614AbgAaNsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 08:48:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=77heQxkPpR1j313BxRvUk+Ag0IcAcRqZAwmlY8oelSk=; b=TIEugwB+DJLbJVsOL7NvEZ8BQ0
        kUUqorMqCOHdGJ2OyIPrZvzj8X0hz8byAyuQfmwhlYVwwKrBp3LYPrTiCUxUcmJxzjpLPLJHE8pjj
        iMso6TTHiNJCyVyz2qk3h3tQwvUbPx8ynzTCZ1gVHjB1FHqXcBWrc+zoBsoxOofPVrQo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ixWfB-0007Nv-Iw; Fri, 31 Jan 2020 14:48:49 +0100
Date:   Fri, 31 Jan 2020 14:48:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, anirudha.sarangi@xilinx.com,
        michal.simek@xilinx.com, gregkh@linuxfoundation.org,
        mchehab+samsung@kernel.org, john.linn@xilinx.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 -next 4/4] net: emaclite: Fix restricted cast warning
 of sparse
Message-ID: <20200131134849.GE9639@lunn.ch>
References: <1580471270-16262-1-git-send-email-radhey.shyam.pandey@xilinx.com>
 <1580471270-16262-5-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580471270-16262-5-git-send-email-radhey.shyam.pandey@xilinx.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 05:17:50PM +0530, Radhey Shyam Pandey wrote:
> Explicitly cast xemaclite_readl return value when it's passed to ntohl.
> Fixes below reported sparse warnings:
> 
> xilinx_emaclite.c:411:24: sparse: sparse: cast to restricted __be32
> xilinx_emaclite.c:420:36: sparse: sparse: cast to restricted __be32
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> index 96e9d21..3273d4f 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> @@ -408,7 +408,8 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data, int maxlen)
>  
>  	/* Get the protocol type of the ethernet frame that arrived
>  	 */
> -	proto_type = ((ntohl(xemaclite_readl(addr + XEL_HEADER_OFFSET +
> +	proto_type = ((ntohl((__force __be32)xemaclite_readl(addr +
> +			XEL_HEADER_OFFSET +
>  			XEL_RXBUFF_OFFSET)) >> XEL_HEADER_SHIFT) &
>  			XEL_RPLR_LENGTH_MASK);
>  
> @@ -417,7 +418,7 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data, int maxlen)
>  	 */
>  	if (proto_type > ETH_DATA_LEN) {
>  		if (proto_type == ETH_P_IP) {
> -			length = ((ntohl(xemaclite_readl(addr +
> +			length = ((ntohl((__force __be32)xemaclite_readl(addr +
>  					XEL_HEADER_IP_LENGTH_OFFSET +
>  					XEL_RXBUFF_OFFSET)) >>
>  					XEL_HEADER_SHIFT) &

If i understand this code correctly, you need the ntohl because you
are poking around inside the packet. All the other uses of
xemaclite_readl() are for descriptors etc.

It would be cleaner if you defined a xemaclite_readlbe32. If you use
ioread32be() it will do the endinness swap for you, so you don't need
the ntohl() and the horrible cast.

    Andrew

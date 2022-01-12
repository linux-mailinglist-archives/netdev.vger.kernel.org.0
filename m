Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE2048CBB7
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356753AbiALTQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:16:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34692 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356830AbiALTPy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 14:15:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=s3FrrVBzNP3mYOSLDaoBDDRgRRIJQGa40R/TxTUgENE=; b=ktmgpNg3FWwxEuklv+ahVU15WY
        og5AFWHQwurm8CMu8LtlQOgJ0pZ/Ih43XHrjDKjyJb+gVpcdlYNeWNEGMHBLevHLo9Dm0nWxD2xQQ
        JBfpt/eFbzYbncIlQSexoZN6d/tIeAKBRUpzuZjpYW9ZRShkm2WevyXVA5O5DjFoZ6l0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n7j68-001E50-P3; Wed, 12 Jan 2022 20:15:52 +0100
Date:   Wed, 12 Jan 2022 20:15:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, radhey.shyam.pandey@xilinx.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, michal.simek@xilinx.com,
        ariane.keller@tik.ee.ethz.ch, daniel@iogearbox.net
Subject: Re: [PATCH net v2 2/9] net: axienet: Wait for PhyRstCmplt after core
 reset
Message-ID: <Yd8o6P6Pp7V7S+oL@lunn.ch>
References: <20220112173700.873002-1-robert.hancock@calian.com>
 <20220112173700.873002-3-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112173700.873002-3-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 11:36:53AM -0600, Robert Hancock wrote:
> When resetting the device, wait for the PhyRstCmplt bit to be set
> in the interrupt status register before continuing initialization, to
> ensure that the core is actually ready. The MgtRdy bit could also be
> waited for, but unfortunately when using 7-series devices, the bit does
> not appear to work as documented (it seems to behave as some sort of
> link state indication and not just an indication the transceiver is
> ready) so it can't really be relied on.
> 
> Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index f950342f6467..f425a8404a9b 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -516,6 +516,16 @@ static int __axienet_device_reset(struct axienet_local *lp)
>  		return ret;
>  	}
>  
> +	/* Wait for PhyRstCmplt bit to be set, indicating the PHY reset has finished */
> +	ret = read_poll_timeout(axienet_ior, value,
> +				value & XAE_INT_PHYRSTCMPLT_MASK,
> +				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
> +				XAE_IS_OFFSET);
> +	if (ret) {
> +		dev_err(lp->dev, "%s: timeout waiting for PhyRstCmplt\n", __func__);
> +		return ret;
> +	}
> +

Is this bit guaranteed to be clear before you start waiting for it?

   Andrew

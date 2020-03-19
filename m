Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEE1B18BBD8
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgCSQFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:05:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45402 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727212AbgCSQFJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 12:05:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zJnEspx9nUpxqY4oZ6sWyqjLedPnwb/JDmykq5Fz/1M=; b=jx/5n7+KC18GCR5gh5RC5Uu7Cq
        Q/sz8HEgxnrFiv8mLmwLAmZ+N1cf43mUrBNqFvCXTMobK/b3lKoUGzXsQUO7zPJbi4NM7P9UXG9qE
        Lz2hUkREitCNlfc7Xcfs36LleSpZrmZvX7vrLnEFVESYmHrfMNHAY8W1GPCBLRJF/6OU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jExfN-0007aG-81; Thu, 19 Mar 2020 17:05:05 +0100
Date:   Thu, 19 Mar 2020 17:05:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/2] net: phy: mscc: RGMII skew delay
 configuration
Message-ID: <20200319160505.GE27807@lunn.ch>
References: <20200319141958.383626-1-antoine.tenart@bootlin.com>
 <20200319141958.383626-3-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319141958.383626-3-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 03:19:58PM +0100, Antoine Tenart wrote:
> This patch adds support for configuring the RGMII skew delays in Rx and
> Tx. The Rx and Tx skews are set based on the interface mode. By default
> their configuration is set to the default value in hardware (0.2ns);
> this means the driver do not rely anymore on the bootloader
> configuration.
> 
> Then based on the interface mode being used, a 2ns delay is added:
> - RGMII_ID adds it for both Rx and Tx.
> - RGMII_RXID adds it for Rx.
> - RGMII_TXID adds it for Tx.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> ---
>  drivers/net/phy/mscc/mscc.h      | 14 ++++++++++++++
>  drivers/net/phy/mscc/mscc_main.c | 29 +++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> index d1b8bbe8acca..25729302714c 100644
> --- a/drivers/net/phy/mscc/mscc.h
> +++ b/drivers/net/phy/mscc/mscc.h
> @@ -161,6 +161,20 @@ enum rgmii_rx_clock_delay {
>  /* Extended Page 2 Registers */
>  #define MSCC_PHY_CU_PMD_TX_CNTL		  16
>  
> +#define MSCC_PHY_RGMII_SETTINGS		  18
> +#define RGMII_SKEW_RX_POS		  1
> +#define RGMII_SKEW_TX_POS		  4
> +
> +/* RGMII skew values, in ns */
> +#define VSC8584_RGMII_SKEW_0_2		  0
> +#define VSC8584_RGMII_SKEW_0_8		  1
> +#define VSC8584_RGMII_SKEW_1_1		  2
> +#define VSC8584_RGMII_SKEW_1_7		  3
> +#define VSC8584_RGMII_SKEW_2_0		  4
> +#define VSC8584_RGMII_SKEW_2_3		  5
> +#define VSC8584_RGMII_SKEW_2_6		  6
> +#define VSC8584_RGMII_SKEW_3_4		  7

  
> +static void vsc8584_rgmii_set_skews(struct phy_device *phydev)
> +{
> +	u32 skew_rx, skew_tx;
> +
> +	/* We first set the Rx and Tx skews to their default value in h/w
> +	 * (0.2 ns).
> +	 */
> +	skew_rx = VSC8584_RGMII_SKEW_0_2;
> +	skew_tx = VSC8584_RGMII_SKEW_0_2;

Hi Antoine

Does this mean it is impossible to have a skew of 0ns?

     Andrew

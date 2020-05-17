Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289381D6C7B
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgEQTom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:44:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36214 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgEQTom (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 15:44:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=klnIB520JPvFCBhFD7rLT04dOGbq1hTV4TrhiVlI73o=; b=c8FqKy4gt6oKPWRvjgpkGvKULC
        Ct/j23EqoF+1NcrGidYwmU/VH3OvIUaNT0o9blk6qYDn5AtC1qlpczTviSNHHmtc4fZiuFyFEjFKt
        tY5TDiH8Fsph66Ubm6WnA8xVZYlts7Sk63qy9v3KXP74+dka0sCrroK/OpiMAOvHBXU4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jaPDD-002YgU-Sv; Sun, 17 May 2020 21:44:39 +0200
Date:   Sun, 17 May 2020 21:44:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V6 09/20] net: ks8851: Use 16-bit read of RXFC register
Message-ID: <20200517194439.GG606317@lunn.ch>
References: <20200517003354.233373-1-marex@denx.de>
 <20200517003354.233373-10-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517003354.233373-10-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 02:33:43AM +0200, Marek Vasut wrote:
> The RXFC register is the only one being read using 8-bit accessors.
> To make it easier to support the 16-bit accesses used by the parallel
> bus variant of KS8851, use 16-bit accessor to read RXFC register as
> well as neighboring RXFCTR register.
> 
> Remove ks8851_rdreg8() as it is not used anywhere anymore.
> 
> There should be no functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>
> ---
> V2: No change
> V3: No change
> V4: Drop the NOTE from the comment, the performance is OK
> V5: No change
> V6: No change
> ---
>  drivers/net/ethernet/micrel/ks8851.c | 17 +----------------
>  1 file changed, 1 insertion(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
> index 1b81340e811f..e2e75041e931 100644
> --- a/drivers/net/ethernet/micrel/ks8851.c
> +++ b/drivers/net/ethernet/micrel/ks8851.c
> @@ -236,21 +236,6 @@ static void ks8851_rdreg(struct ks8851_net *ks, unsigned op,
>  		memcpy(rxb, trx + 2, rxl);
>  }
>  
> -/**
> - * ks8851_rdreg8 - read 8 bit register from device
> - * @ks: The chip information
> - * @reg: The register address
> - *
> - * Read a 8bit register from the chip, returning the result
> -*/
> -static unsigned ks8851_rdreg8(struct ks8851_net *ks, unsigned reg)
> -{
> -	u8 rxb[1];
> -
> -	ks8851_rdreg(ks, MK_OP(1 << (reg & 3), reg), rxb, 1);
> -	return rxb[0];
> -}
> -
>  /**
>   * ks8851_rdreg16 - read 16 bit register from device
>   * @ks: The chip information
> @@ -470,7 +455,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
>  	unsigned rxstat;
>  	u8 *rxpkt;
>  
> -	rxfc = ks8851_rdreg8(ks, KS_RXFC);
> +	rxfc = (ks8851_rdreg16(ks, KS_RXFCTR) >> 8) & 0xff;
>  
>  	netif_dbg(ks, rx_status, ks->netdev,
>  		  "%s: %d packets\n", __func__, rxfc);

Hi Marek

This is the patch which i think it causing most problems. So why not
add accessors ks8851_rd_rxfc_spi() and ks8851_rd_rxfc_par(), each
doing which is optimal for each?

      Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8591447BC53
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 10:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235964AbhLUJA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 04:00:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36758 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233983AbhLUJA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 04:00:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vVRni0bR12c2JVjkK5XJ084xSenLxxeOYAyg4nuubiY=; b=YBZEyQ5GZsk0DI+cRwgS94D86Z
        7TTmau/QW0vdZpClSnlSsuBkoWxlWkdAjy0B87Fpd8DQiNXZ2HrVCLBvYgrhlln+pPbBUgnNZPFut
        5kJz/7n3mX7R0BsxsqgxCZIISh8hzG+WjGcLYqiY++6o3forMrzBcsnkPTYMqvnmWLLE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzb0r-00H70g-Ng; Tue, 21 Dec 2021 10:00:49 +0100
Date:   Tue, 21 Dec 2021 10:00:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: phy: micrel: Adding interrupt support for
 Link up/Link down in LAN8814 Quad phy
Message-ID: <YcGXwQ63DFzdpSoj@lunn.ch>
References: <20211221070502.14811-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221070502.14811-1-Divya.Koppera@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 12:35:02PM +0530, Divya Koppera wrote:
> This patch add support for Link up or Link down
> interrupt support in LAN8814 Quad phy.
> 
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 71 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 44a24b99c894..46931020ef84 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -66,6 +66,23 @@
>  #define KSZ8081_LMD_SHORT_INDICATOR		BIT(12)
>  #define KSZ8081_LMD_DELTA_TIME_MASK		GENMASK(8, 0)
>  
> +/* Lan8814 general Interrupt control/status reg in GPHY specific block. */
> +#define LAN8814_INTC				0x18
> +#define LAN8814_INTC_LINK_DOWN			BIT(2)
> +#define LAN8814_INTC_LINK_UP			BIT(0)
> +#define LAN8814_INTC_LINK			(LAN8814_INTC_LINK_UP |\
> +						 LAN8814_INTC_LINK_DOWN)
> +
> +#define LAN8814_INTS				0x1B
> +#define LAN8814_INTS_LINK_DOWN			BIT(2)
> +#define LAN8814_INTS_LINK_UP			BIT(0)
> +#define LAN8814_INTS_LINK			(LAN8814_INTS_LINK_UP |\

I've never seen an interrupt controller where the interrupt control
bits and the interrupt status bits are different. So just define the
two interesting bits as LAN8814_INT_LINK_DOWN and LAN8814_INT_LINK_UP
and share them across the two registers.

Otherwise this looks good.

    Andrew

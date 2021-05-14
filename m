Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669DB380A5D
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 15:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbhENN0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 09:26:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40250 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230075AbhENN0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 09:26:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bKrIdux+WQDhbsuj/L6O78Gu9Fpi7TdC9aFvwWVLPns=; b=Uu7s+m0wpC6i6cokaQjN2ujZPy
        46SprCmSQxX+gHsLgzdWIUPaC9JeDRtKNZh9U+08/n3Uf2SG6hGMEmCcbC5UHLqBXrzd48DFJ2NaX
        XzWrdLAk3WP9OOzcX1jfQqypi2sbqw70RFOrOweG/bdCxUOUElNSDsOjni+IxUiSisNM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhXo3-004BmE-AI; Fri, 14 May 2021 15:24:43 +0200
Date:   Fri, 14 May 2021 15:24:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v3] net: phy: add driver for Motorcomm yt8511 phy
Message-ID: <YJ56G23e930pg4Iv@lunn.ch>
References: <20210514115826.3025223-1-pgwipeout@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514115826.3025223-1-pgwipeout@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 07:58:26AM -0400, Peter Geis wrote:
> Add a driver for the Motorcomm yt8511 phy that will be used in the
> production Pine64 rk3566-quartz64 development board.
> It supports gigabit transfer speeds, rgmii, and 125mhz clk output.

Thanks for adding RGMII support.

> +#define PHY_ID_YT8511		0x0000010a

No OUI in the PHY ID?

Humm, the datasheet says it defaults to zero. That is not very
good. This could be a source of problems in the future, if some other
manufacture also does not use an OUI.

> +/* RX Delay enabled = 1.8ns 1000T, 8ns 10/100T */
> +#define YT8511_DELAY_RX		BIT(0)
> +
> +/* TX Delay is bits 7:4, default 0x5
> + * Delay = 150ps * N - 250ps, Default = 500ps
> + */
> +#define YT8511_DELAY_TX		(0x5 << 4)

> +
> +	switch (phydev->interface) {
> +	case PHY_INTERFACE_MODE_RGMII:
> +		val &= ~(YT8511_DELAY_RX | YT8511_DELAY_TX);
> +		break;

This is not correct. YT8511_DELAY_TX will only mask the 2 bits in 0x5,
not all the bits in 7:4. And since the formula is

Delay = 150ps * N - 250ps

setting N to 0 is not what you want. You probably want N=2, so you end up with 50ps

> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +		val |= YT8511_DELAY_RX | YT8511_DELAY_TX;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +		val &= ~(YT8511_DELAY_TX);
> +		val |= YT8511_DELAY_RX;

The delay should be around 2ns. For RX you only have 1.8ns, which is
probably good enough. But for TX you have more flexibility. You are
setting it to the default of 500ps which is too small. I would suggest
1.85ns, N=14, so it is the same as RX.

I also wonder about bits 15:12 of PHY EXT ODH: Delay and driver
strength CFG register.

	 Andrew

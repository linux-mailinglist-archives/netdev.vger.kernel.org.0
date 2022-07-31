Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62228585F44
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 16:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiGaObR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 10:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGaObQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 10:31:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF4765FB;
        Sun, 31 Jul 2022 07:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tC9r4oVZgcMaGiiUSFNsXQd1XmrYl3tfqTOi1U1v8R8=; b=Sfk7rQDkt5zbohJXnWs0UeLejw
        0DnLZYTf+/12xv6rYD9jl9RlV5VLLLP7oO3jn7ZFCXms6d3U8kIrPXkdYpIsRxSn3iPDug5zKptS0
        QQVzx5BBEz5YCBBYIsmz7XaEF0fuMb4+1P+u4jSBodfmlGI2IFXihgpDiBmhEEk/VCgw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oI9xq-00C5Ym-Mx; Sun, 31 Jul 2022 16:30:42 +0200
Date:   Sun, 31 Jul 2022 16:30:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] net: phy: Add driver for Motorcomm yt8521 gigabit
 ethernet
Message-ID: <YuaSEpglXWbxQbAy@lunn.ch>
References: <20220727070827.1162-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727070827.1162-1-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 03:08:27PM +0800, Frank wrote:
> patch v4:
>  Hi Andrew,Jakub
>  Thanks very much and based on your comments we modified the patch v4 as below.
> 
>  We evaluated the Marvell 10G driver and at803x you suggested. The 2 drivers
>  implement SFP module attach/detach functions and we think these functions do
>  not help yt8521 to do UTP/Fiber register space arbitration which you may
>  concern in previous patch.
> 
>  Yt8521 can detect utp/fiber media link status automatically. For the case of
>  both media are connected, driver arbitrates the priority of the media (by
>  default, driver takes fiber as higher priority) and report the media status
>  to up layer(MAC).
> 
> patch v3:
>  Hi Andrew
>  Thanks and based on your comments we modified the patch as below.
> 
> > It is generally not that simple. Fibre, you probably want 1000BaseX,
> > unless the fibre module is actually copper, and then you want
> > SGMII. So you need something to talk to the fibre module and ask it
> > what it is. That something is phylink. Phylink does not support both
> > copper and fibre at the same time for one MAC.
> 
>  yes, you said it and for MAC, it does not support copper and Fiber at same time.
>  but from Physical Layer, you know, sometimes both Copper and Fiber cables are
>  connected. in this case, Phy driver should do arbitration and report to MAC
>  which media should be used and Link-up.
>  This is the reason that the driver has a "polling mode", and by default, also
>  this driver takes fiber as first priority which matches phy chip default behavior.
> 
> 
> patch v2:
>  Hi Andrew, Russell King, Peter,
>  Thanks and based on your comments we modified the patch as below.
>  
> > So there's only two possible pages that can be used in the extended
> >register space?
>  
>  Yes,there is only two register space (utp and fiber).
>  
> > > +/* Extended Register's Data Register */
> > > +#define YTPHY_PAGE_DATA                                0x1F
> >
> > These are defined exactly the same way as below. Please reuse code
> > where possible.
>  
>  Yes, code will be reuse, but "YT8511_PAGE" need to be rename like
>  "YTPHY_PAGE_DATA",as it is common register for yt phys.
>  
> 
> patch v1:
>  Add a driver for the motorcomm yt8521 gigabit ethernet phy. We have verified
>  the driver on StarFive VisionFive development board, which is developed by
>  Shanghai StarFive Technology Co., Ltd.. On the board, yt8521 gigabit ethernet
>  phy works in utp mode, RGMII interface, supports 1000M/100M/10M speeds, and
>  wol(magic package).
> 
> Signed-off-by: Frank <Frank.Sae@motor-comm.com>
> ---
>  MAINTAINERS                 |    1 +
>  drivers/net/phy/Kconfig     |    2 +-
>  drivers/net/phy/motorcomm.c | 1170 ++++++++++++++++++++++++++++++++++-
>  3 files changed, 1170 insertions(+), 3 deletions(-)

This is not the correct way to format the commit message. All the text
you have above will end up in the commit. Please put all discussion
after the --- .


> +	/* If it is reset, need to wait for the reset to complete */
> +	if (set == BMCR_RESET) {
> +		while (max_cnt--) {
> +			/* unlock mdio bus during sleep */
> +			phy_unlock_mdio_bus(phydev);
> +			usleep_range(1000, 1100);
> +			phy_lock_mdio_bus(phydev);
> +
> +			ret = __phy_read(phydev, MII_BMCR);
> +			if (ret < 0)
> +				goto err_restore_page;
> +
> +			if (!(ret & BMCR_RESET))
> +				return phy_restore_page(phydev, old_page, 0);
> +		}
> +		if (max_cnt <= 0)
> +			ret = -ETIME;

ETIMEDOUT.

	Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C8D54FC97
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 19:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383328AbiFQR4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 13:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383290AbiFQRz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 13:55:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2ED34DF50;
        Fri, 17 Jun 2022 10:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yamxGimFedRfbjaJTX3NRQVcrOGow7Ua11mmd/uCfD4=; b=gbd9+eJy3es3vmNYw+JU56cefa
        ZBh+H7aPRju7DZ49ekW8rfpU0E+Sur/kdbSd/zU5YMyh++Az80x7+ss5wfS1uyQFEnANWIWrpvB6E
        LgB9mRb12jeUmKrVUlki9Xzj0Q+3VOkIMe8hcb+tDIpVbhZETZaxZZd1qbxuyN6iZAT0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o2GCI-007Ktp-Cw; Fri, 17 Jun 2022 19:55:54 +0200
Date:   Fri, 17 Jun 2022 19:55:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com
Subject: Re: [PATCH] net: dp83822: disable false carrier interrupt
Message-ID: <YqzAKguRaxr74oXh@lunn.ch>
References: <20220617134611.695690-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617134611.695690-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 03:46:11PM +0200, Enguerrand de Ribaucourt wrote:
> When unplugging an Ethernet cable, false carrier events were produced by
> the PHY at a very high rate. Once the false carrier counter full, an
> interrupt was triggered every few clock cycles until the cable was
> replugged. This resulted in approximately 10k/s interrupts.
> 
> Since the false carrier counter (FCSCR) is never used, we can safely
> disable this interrupt.
> 
> In addition to improving performance, this also solved MDIO read
> timeouts I was randomly encountering with an i.MX8 fec MAC because of
> the interrupt flood. The interrupt count and MDIO timeout fix were
> tested on a v5.4.110 kernel.
> 
> Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
> ---
>  drivers/net/phy/dp83822.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
> index e6ad3a494d32..95ef507053a6 100644
> --- a/drivers/net/phy/dp83822.c
> +++ b/drivers/net/phy/dp83822.c
> @@ -230,7 +230,6 @@ static int dp83822_config_intr(struct phy_device *phydev)
>  			return misr_status;
>  
>  		misr_status |= (DP83822_RX_ERR_HF_INT_EN |
> -				DP83822_FALSE_CARRIER_HF_INT_EN |

Does the same problem exist for RX_ERR_HF_INT ? That appears to be
that the RX error counter has reached half full. I don't see anything
using register 0x15.

      Andrew

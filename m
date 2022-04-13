Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBAE4FFE1F
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 20:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237801AbiDMStF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 14:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236436AbiDMStE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 14:49:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CED5A171
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 11:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=Y6t5N8MzYncTkXVlzsGvcPsJP6YwDj/8y2OkZnIUu58=; b=28
        5jY1hgn7lBeBI232t3RlScmszDRpotJCd/XKvfGpz9dvbBj6uFE1zw8CKzrZSNCfkjCuhQ2RKdPTE
        EoVZZ9680xsCT2jOV9GRGiT5wQRJ10UtZNmH4BV9fFmAo+p4dE2cB4VWyqfqoybe7yYUfd7fR9e0e
        ueawaTXPa8EvF3M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nei0e-00FiDw-Ka; Wed, 13 Apr 2022 20:46:32 +0200
Date:   Wed, 13 Apr 2022 20:46:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/3] net: dsa: mv88e6xxx: use BMSR_ANEGCOMPLETE bit
 for filling an_complete
Message-ID: <YlcaiKD1zcM6ztsK@lunn.ch>
References: <Ylb/vEWXHOmQ7sFd@shell.armlinux.org.uk>
 <E1negFc-005tSn-BX@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1negFc-005tSn-BX@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 05:53:52PM +0100, Russell King wrote:
> From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>

Hi Russell

Does git am parse that correctly? At least it is something
Jakub/DaveM/Paolo needs to keep an eye on when they accept the series.

> 
> Commit ede359d8843a ("net: dsa: mv88e6xxx: Link in pcs_get_state() if AN
> is bypassed") added the ability to link if AN was bypassed, and added
> filling of state->an_complete field, but set it to true if AN was
> enabled in BMCR, not when AN was reported complete in BMSR.
> 
> This was done because for some reason, when I wanted to use BMSR value
> to infer an_complete, I was looking at BMSR_ANEGCAPABLE bit (which was
> always 1), instead of BMSR_ANEGCOMPLETE bit.
> 
> Use BMSR_ANEGCOMPLETE for filling state->an_complete.
> 
> Fixes: ede359d8843a ("net: dsa: mv88e6xxx: Link in pcs_get_state() if AN is bypassed")
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/dsa/mv88e6xxx/serdes.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
> index 7b37d45bc9fb..1a19c5284f2c 100644
> --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> @@ -50,22 +50,17 @@ static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
>  }
>  
>  static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
> -					  u16 ctrl, u16 status, u16 lpa,
> +					  u16 bmsr, u16 lpa, u16 status,
>  					  struct phylink_link_state *state)
>  {
>  	state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
> +	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
>  
>  	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
>  		/* The Spped and Duplex Resolved register is 1 if AN is enabled

It looks like there is a typ0 here for speed.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

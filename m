Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7244F6B86
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbiDFUnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbiDFUni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:43:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FD23ADADC;
        Wed,  6 Apr 2022 12:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ORv4dJXN80Th/q40FVaI67o8XfB5vIQ9EZXpu4hyhXg=; b=q7DawJNk/HZkkATayfSOPv1TC5
        DoH1XABIMXvnea3Ws49UeUNkAfsud61fPnjlT4mduqcgQI08UXUJkrfsPnQa/RpVNrzvxVt5t7yfE
        HKJVB9CHB8xr2BuaxatOQ8E60ZSj9Lw9UBzZX1z7beFtuSGtPnSJxev0a6K3nQrthW2Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncAsu-00EVVe-Rz; Wed, 06 Apr 2022 21:00:04 +0200
Date:   Wed, 6 Apr 2022 21:00:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Potin Lai <potin.lai@quantatw.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Patrick Williams <patrick@stwcx.xyz>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RESEND v2 3/3] net: mdio: aspeed: Add c45 support
Message-ID: <Yk3jNJMjMPj7NM8r@lunn.ch>
References: <20220406170055.28516-1-potin.lai@quantatw.com>
 <20220406170055.28516-4-potin.lai@quantatw.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406170055.28516-4-potin.lai@quantatw.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 01:00:55AM +0800, Potin Lai wrote:
> Add Clause 45 support for Aspeed mdio driver.
> 
> Signed-off-by: Potin Lai <potin.lai@quantatw.com>
> ---
>  drivers/net/mdio/mdio-aspeed.c | 35 ++++++++++++++++++++++++++++++----
>  1 file changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
> index 5becddb56117..4236ba78aa65 100644
> --- a/drivers/net/mdio/mdio-aspeed.c
> +++ b/drivers/net/mdio/mdio-aspeed.c
> @@ -21,6 +21,10 @@
>  #define   ASPEED_MDIO_CTRL_OP		GENMASK(27, 26)
>  #define     MDIO_C22_OP_WRITE		0b01
>  #define     MDIO_C22_OP_READ		0b10
> +#define     MDIO_C45_OP_ADDR		0b00
> +#define     MDIO_C45_OP_WRITE		0b01
> +#define     MDIO_C45_OP_PREAD		0b10
> +#define     MDIO_C45_OP_READ		0b11
>  #define   ASPEED_MDIO_CTRL_PHYAD	GENMASK(25, 21)
>  #define   ASPEED_MDIO_CTRL_REGAD	GENMASK(20, 16)
>  #define   ASPEED_MDIO_CTRL_MIIWDATA	GENMASK(15, 0)
> @@ -100,15 +104,37 @@ static int aspeed_mdio_write_c22(struct mii_bus *bus, int addr, int regnum,
>  
>  static int aspeed_mdio_read_c45(struct mii_bus *bus, int addr, int regnum)
>  {
> -	/* TODO: add c45 support */
> -	return -EOPNOTSUPP;
> +	int rc;
> +	u8 c45_dev = (regnum >> 16) & 0x1F;
> +	u16 c45_addr = regnum & 0xFFFF;

Sorry, missed it the first time. You should use reverse christmass
tree here. Just move rc to last.

>  static int aspeed_mdio_write_c45(struct mii_bus *bus, int addr, int regnum,
>  				 u16 val)
>  {
> -	/* TODO: add c45 support */
> -	return -EOPNOTSUPP;
> +	int rc;
> +	u8 c45_dev = (regnum >> 16) & 0x1F;
> +	u16 c45_addr = regnum & 0xFFFF;

Same here.

     Andrew

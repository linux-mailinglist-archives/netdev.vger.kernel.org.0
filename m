Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B826B511757
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbiD0MGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 08:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbiD0MGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 08:06:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D61B52E4F;
        Wed, 27 Apr 2022 05:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4UVJKftZs87yAdJTdb6rVoACninShQjDA63KmfqqPBE=; b=ym6xRf2BFw6M0trBK4VpQVaGpg
        bKpKuck5U9y+iGwFLrpo8t+SfTZ14S6UlGboDaxzLK8yTw3sXYEPOAEpCynjQoN5kqzn5dIzo41MP
        /qmEGqZH7ppnB+lD2gEO65yVCtgOyC92mkuIGe2oU/u7WJ9By2vxB6jiANHkbEsqAd5w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njgNr-0006YM-Mh; Wed, 27 Apr 2022 14:03:03 +0200
Date:   Wed, 27 Apr 2022 14:03:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 5/7] usbnet: smsc95xx: Forward PHY interrupts to
 PHY driver to avoid polling
Message-ID: <Ymkw9xHKdGYaHV5K@lunn.ch>
References: <cover.1651037513.git.lukas@wunner.de>
 <276a1b50cf9fcca5168ca2770a863cb56069a277.1651037513.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <276a1b50cf9fcca5168ca2770a863cb56069a277.1651037513.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -606,11 +616,20 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
>  	intdata = get_unaligned_le32(urb->transfer_buffer);
>  	netif_dbg(dev, link, dev->net, "intdata: 0x%08X\n", intdata);
>  
> +	/* USB interrupts are received in softirq (tasklet) context.
> +	 * Switch to hardirq context to make genirq code happy.
> +	 */
> +	local_irq_save(flags);
> +	__irq_enter_raw();
> +
>  	if (intdata & INT_ENP_PHY_INT_)
> -		;
> +		generic_handle_domain_irq(pdata->irqdomain, PHY_HWIRQ);
>  	else
>  		netdev_warn(dev->net, "unexpected interrupt, intdata=0x%08X\n",
>  			    intdata);

Ah, O.K, forget my previous comment. Maybe add something to the commit
message that the ; will soon be replaced by a call to actually handle
the interrupt.

	Andrew

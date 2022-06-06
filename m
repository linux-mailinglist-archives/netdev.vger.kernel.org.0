Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB7C53DF6C
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 03:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349016AbiFFBlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 21:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiFFBlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 21:41:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7AA4C7AB;
        Sun,  5 Jun 2022 18:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Q0Xbk+5N4jdonj8TGEWVhZcRq5R6ZRawe1Jsg0ytdcs=; b=WwGVSWA08+9mWAAqTPwLZhnxcO
        VykEmpY4L3+PoFbHlPYnGxmSmL442vdI1hyrpWW3xDX3Uc8FWpnDIA0Dv3RjO4eMVpE4jQ18QLgwf
        h+zF0TRJH71ai4+PO7bVVxabQh9AHHp113cThGzz0qi7wVWEvi1GchVuo+J1VagkJ5IE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ny1jd-005hNw-Ia; Mon, 06 Jun 2022 03:40:49 +0200
Date:   Mon, 6 Jun 2022 03:40:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        netdev@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH net] net: phy: Don't trigger state machine while in
 suspend
Message-ID: <Yp1bIdwLjiLftWgW@lunn.ch>
References: <688f559346ea747d3b47a4d16ef8277e093f9ebe.1653556322.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <688f559346ea747d3b47a4d16ef8277e093f9ebe.1653556322.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (phy_interrupt_is_valid(phydev)) {
> +		phydev->irq_suspended = 0;
> +		synchronize_irq(phydev->irq);
> +
> +		/* Rerun interrupts which were postponed by phy_interrupt()
> +		 * because they occurred during the system sleep transition.
> +		 */
> +		if (phydev->irq_rerun) {
> +			phydev->irq_rerun = 0;
> +			enable_irq(phydev->irq);
> +			irq_wake_thread(phydev->irq, phydev);
> +		}
> +	}

As i said in a previous thread, PHY interrupts are generally level,
not edge. So when you call enable_irq(phydev->irq), doesn't it
immediately fire? You need to first call the handler, and then
re-enable the interrupt.

      Andrew

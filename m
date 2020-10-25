Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D4F2980C3
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 09:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768236AbgJYISK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 04:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1768204AbgJYISF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 04:18:05 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90853C0613CE;
        Sun, 25 Oct 2020 01:18:05 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id B917322EE3;
        Sun, 25 Oct 2020 09:17:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1603613881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HbXAuisRkbCjpst8/x7U7SZEv2Tpc4KYDd1+sDc2lys=;
        b=d4l/vB6nvsFp8wUk9aRedzg8d2KlhKTW9CZTrvxFr6PCM2O1iRBB6TErtsdclvGCK8paTK
        aRLDGK0+PcRzhzdBGk4LQ5O8jXZEqB2G1ebFB+Db9fGnob0DZk3lmDAcgZ84Xu51EM1EMI
        OLFQ1NVp5qlf36Rq2z8fFbfxgJYKPm0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 25 Oct 2020 09:17:58 +0100
From:   Michael Walle <michael@walle.cc>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Dan Murphy <dmurphy@ti.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Willy Liu <willy.liu@realtek.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: Re: [RFC net-next 0/5] net: phy: add support for shared interrupts
In-Reply-To: <20201024121412.10070-1-ioana.ciornei@nxp.com>
References: <20201024121412.10070-1-ioana.ciornei@nxp.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <1b7a22ba10ed5d63743c045a182ce5f9@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-10-24 14:14, schrieb Ioana Ciornei:
> - Every PHY driver gains a .handle_interrupt() implementation that, for
>   the most part, would look like below:
> 
> 	irq_status = phy_read(phydev, INTR_STATUS);
> 	if (irq_status < 0) {
> 		phy_error(phydev);
> 		return IRQ_NONE;
> 	}
> 
> 	if (irq_status == 0)
> 		return IRQ_NONE;
> 
> 	phy_trigger_machine(phydev);
> 
> 	return IRQ_HANDLED;

Would it make sense to provide this (default) version inside the core?
Simple PHY drivers then just could set the callback to this function.
(There must be some property for the INTR_STATUS, which is likely to
be different between different PHYs, though).

-michael

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377C05827A6
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 15:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiG0N0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 09:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiG0N0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 09:26:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5974324086;
        Wed, 27 Jul 2022 06:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mgBlxw3zoFf3ZyCaTXfuTNRiZgDv+TxjgdIc10s0/eI=; b=lrE3GVppvUINE6sTnPwE27jG18
        yj7BTz0ZW5YjqGc3ley97AxbPT1Rv7V3Qj1TMEPoexfUfZMhylJJUxhuy+ryLH8rUY1m88HuB0nH7
        zVxoBE+tkXWx/3IfR0mfRXCjzUuiBt3zwvGGeXbdbKlUe8olKTh9XN5vX/TZJumbOiN0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oGh3T-00Bg6P-4Q; Wed, 27 Jul 2022 15:26:27 +0200
Date:   Wed, 27 Jul 2022 15:26:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     d.michailidis@fungible.com, davem@davemloft.net,
        devicetree@vger.kernel.org, edumazet@google.com,
        geert+renesas@glider.be, geert@linux-m68k.org,
        gerhard@engleder-embedded.com, joel@jms.id.au,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        l.stelmach@samsung.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, robh+dt@kernel.org, stefan.wahren@i2se.com,
        stephen@networkplumber.org, wellslutw@gmail.com
Subject: Re: [net-next,v2,2/3] net: ethernet: adi: Add ADIN1110 support
Message-ID: <YuE9AxMmw4+/9Joy@lunn.ch>
References: <Yt76W+MbeHucJj0f@lunn.ch>
 <20220727132612.31445-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727132612.31445-1-alexandru.tachici@analog.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 04:26:12PM +0300, alexandru.tachici@analog.com wrote:
> > > +static irqreturn_t adin1110_irq(int irq, void *p)
> > > +{
> > > +	struct adin1110_priv *priv = p;
> > > +	u32 status1;
> > > +	u32 val;
> > > +	int ret;
> > > +	int i;
> > > +
> > > +	mutex_lock(&priv->lock);
> > 
> > The MDIO bus operations are using the same lock. MDIO can be quite
> > slow. Do you really need mutual exclusion between MDIO and interrupts?
> > What exactly is this lock protecting?
> > 
> >   Andrew
> 
> Hi Andrew,
> 
> Thanks for all the help here.
> 
> With this lock I am mainly protecting SPI read/writes. The hardware doesn't expose the MDIO pins.
> In order to read/write a PHY reg, there has to be a SPI read/write to the device, the same
> line where the MAC is programmed and ethernet frames are sent/received, not very efficient I know.

Have you profiled adin1110_mdio_read()?

You could hold the mutex for the "write the clause 22 read command",
and then release it. And then take the mutex in
adin1110_read_mdio_acc(). That will allow for example the interrupt
handler to jump in between polls, etc.

If all you are protecting is SPI read/writes, i wonder if you even
need this mutex, the SPI core has one as well.

	Andrew

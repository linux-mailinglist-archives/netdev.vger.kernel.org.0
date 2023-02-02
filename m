Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949B46883A6
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 17:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbjBBQFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 11:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbjBBQFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 11:05:12 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4864567796
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 08:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=df3WH6w7xzk6z5b2o4rlg36TXJz8gwQ1HT8g8AaBEfM=; b=ersZC+6Mf0PRnCw60fNRB4rssE
        vkCy9HpRBth7tOsApVylNE4PgsY5V5ASNGRcnXcrEFjP8BKGlIZlEArJvxOqMb1womwMGG+rzUsge
        dpQA5RbhYdbzILWGUBmwxfiIqEua5MlPea6VylDavnEa11+QrdBEQIbmQT7AbSNiJCeg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNc57-003uWh-GB; Thu, 02 Feb 2023 17:05:01 +0100
Date:   Thu, 2 Feb 2023 17:05:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Valek, Andrej" <andrej.valek@siemens.com>
Cc:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DSA mv88e6xxx_probe
Message-ID: <Y9vfLYtio1fbZvfW@lunn.ch>
References: <cf6fb63cdce40105c5247cdbcb64c1729e19d04a.camel@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf6fb63cdce40105c5247cdbcb64c1729e19d04a.camel@siemens.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 03:18:37PM +0000, Valek, Andrej wrote:
> Hello everyone!
> 
> I have a switch mv88e6085 which is connected via MDIO bus to iMX.8 SoC.
> 
> Switch is not being detected during booting because the address is
> different (due to uninitialized PINs from DTB). The problem is, that
> switch has to be reset during boot phase, but it isn't.
> 
> So I would like to ask you maybe a generic question about
> devm_gpiod_get_optional function inside mv88e6xxx_probe.
> 
> Is this "chip->reset = devm_gpiod_get_optional(dev, "reset",
> GPIOD_OUT_LOW);" line really do the reset? Because from the lines below
> looks like, but the reset pulse hasn't been made. Measured with scope.
> 
> > chip->reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
> > if (IS_ERR(chip->reset))
> >	goto out;
> >
> > if (chip->reset)
> >	usleep_range(1000, 2000);
> 
> So it should wait, but for what?

The current code is designed to take a switch held in reset out of
reset. It does not perform an actual reset.

If you need a real reset, you probably need to call
mv88e6xxx_hardware_reset(chip), not usleep().

However, a reset can be a slow operation, specially if the EEPROM is
full of stuff. So we want to avoid two resets if possible.

The MDIO bus itself has DT descriptions for a GPIO reset. See
Documentation/devicetree/bindings/net/mdio.yaml

You might be able to use this to perform the power on reset of the
switch. That advantage of that is it won't slow down the probe of
everybody elses switches which have correct pin strapping.

	Andrew

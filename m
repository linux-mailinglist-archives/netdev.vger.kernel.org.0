Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE576A84B3
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 15:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjCBO4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 09:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjCBO4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 09:56:46 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5596D532B7;
        Thu,  2 Mar 2023 06:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pKceL3KJW3PgeIN/qIwk7feEkC0lS+FRtyxxuMpmlv0=; b=0BHCWj1x9/kBByiHX6Cgjurwo7
        K+nR6WpnhLo+qPJAZh7p3qr7J/v/qBw4CvzHOeDiMMdznMW4qLhby4w3Z7eKLBmvcJWF1oZlk+j62
        BZ0TjbAYuBEStzsbQ7I+AJZqlqB0fdeBTWDXI7zJfzqyCvaemgLHqFM5N496kXhxwzS0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pXkLa-006Jct-5g; Thu, 02 Mar 2023 15:55:54 +0100
Date:   Thu, 2 Mar 2023 15:55:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: intel-xway: remove LED
 configuration
Message-ID: <ZAC4+kjSxLtxMZDR@lunn.ch>
References: <20230302141651.377261-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302141651.377261-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 03:16:51PM +0100, Michael Walle wrote:
> For this PHY, the LEDs can either be configured through an attached
> EEPROM or if not available, the PHY offers sane default modes. Right now,
> the driver will configure to a mode just suitable for one configuration
> (although there is a bold claim that "most boards have just one LED").
> I'd argue, that as long as there is no configuration through other means
> (like device tree), the driver shouldn't configure anything LED related
> so that the PHY is using either the modes configured by the EEPROM or
> the power-on defaults.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> I know there is ongoing work on the device tree, but even then, my
> argument holds, if there is no config in the device tree, the driver
> shouldn't just use "any" configuration when there are means by the
> hardware to configure the LEDs.
> 
> Not just as an RFC because netdev is closed, but also to get other
> opinions. Not to be applied.

I would suggest you CC: the two people responsible for adding this
code:

    Signed-off-by: John Crispin <john@phrozen.org>
    Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

So i guess this came from OpenWRT? Maybe they can tell us if this
change is going to cause regressions.

I would say there is no right defaults for LEDs, whatever you do will
be wrong for somebody. And the way this driver sets the LEDs has been
there since the first commit. This is its decision of what the default
should be. So i'm leaning towards rejecting your definition of what
the default should be.

There is progress on controlling PHY LEDs via /sysfs. So i think you
should wait until Christian and I get the API between the core and the
PHY driver stable, and then help us by implementing support in the
intel-xway.

	Andrew

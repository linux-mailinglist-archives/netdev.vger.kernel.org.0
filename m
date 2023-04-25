Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA0C6EE9C2
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbjDYViV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjDYViU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:38:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3389CB224
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sC2qPh2W0f8RqNvwpddiCxnUlVlMBGMTtuu+m+UFgJk=; b=DXYa6i0yv4eXCk8Nj/8BYgKRlT
        5spujIfsfdrQWXC78sBYZWlYynq1ixblQ5++SND/UZTy/MMwk2u2lBCLFwIYW0JA6KOY47zaprNPr
        B98lTwKSK7144Ex4rKjTqyw8PR0O/6+OanJJFLQynIWrRoL+GcAPJdcetSKwWBJ+4UZY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prQMZ-00BE35-Aw; Tue, 25 Apr 2023 23:38:15 +0200
Date:   Tue, 25 Apr 2023 23:38:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next] net: phy: drop PHYLIB_LEDS knob
Message-ID: <ce81b985-ebcf-46f7-b773-50e42d2d10e7@lunn.ch>
References: <c783f6b8d8cc08100b13ce50a1330913dd95dbce.1682457539.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c783f6b8d8cc08100b13ce50a1330913dd95dbce.1682457539.git.pabeni@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:19:11PM +0200, Paolo Abeni wrote:
> commit 4bb7aac70b5d ("net: phy: fix circular LEDS_CLASS dependencies")
> solved a build failure, but introduces a new config knob with a default
> 'y' value: PHYLIB_LEDS.
> 
> The latter is against the current new config policy. The exception
> was raised to allow the user to catch bad configurations without led
> support.
> 
> Anyway the current definition of PHYLIB_LEDS does not fit the above
> goal: if LEDS_CLASS is disabled, the new config will be available
> only with PHYLIB disabled, too.
> 
> Instead of building a more complex and error-prone dependency definition
> it looks simpler and more in line with the mentioned policies use
> IS_REACHABLE(CONFIG_LEDS_CLASS) instead of the new symbol.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> @Andrew, @Arnd: the rationale here is to avoid the new config knob=y,
> which caused in the past a few complains from Linus. In this case I
> think the raised exception is not valid, for the reason mentioned above.
> 
> If you have different preferences or better solutions to address that,
> please voice them :)

Arnd did mention making it an invisible option. That would have the
advantage of keeping the hundreds of randcomfig builds which have been
done. How much time do you have now to do that before sending Linus
the pull request?

> ---
>  drivers/net/phy/Kconfig      | 9 ---------
>  drivers/net/phy/phy_device.c | 2 +-
>  2 files changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 2f3ddc446cbb..f83420b86794 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -44,15 +44,6 @@ config LED_TRIGGER_PHY
>  		<Speed in megabits>Mbps OR <Speed in gigabits>Gbps OR link
>  		for any speed known to the PHY.
>  
> -config PHYLIB_LEDS
> -	bool "Support probing LEDs from device tree"

I don't know Kconfig to well, but i think you just need to remove the
text, just keep the bool.

-       bool "Support probing LEDs from device tree"
+       bool

	Andrew

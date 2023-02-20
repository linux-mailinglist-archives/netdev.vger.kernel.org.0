Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9636E69D0CD
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbjBTPnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjBTPnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:43:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426AD93D2;
        Mon, 20 Feb 2023 07:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=80918lFX+Pp/23Z7JOwnNIJjshra43iXopn10jUf1II=; b=Ne6+6/MQOlVtolNJLEtjbbpTdD
        EQGV42bBOR0R5QW4+5+4k9tr7yVG/lX+CMP7OmxI2EOl78Rr2xD3AgoEGADtm1RqQp/jbf8yPB5iO
        XDXLbPyZl+T9a2LAECDtY+pmTLyIuaPgjBesvJBs29Wv78li1VJOs/GvyZ30swEPp5HI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pU8KC-005WKl-AW; Mon, 20 Feb 2023 16:43:32 +0100
Date:   Mon, 20 Feb 2023 16:43:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v1 3/4] net: phy: do not force EEE support
Message-ID: <Y/OVJFn6UrMZuiaG@lunn.ch>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
 <20230220135605.1136137-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220135605.1136137-4-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 02:56:04PM +0100, Oleksij Rempel wrote:
> With following patches:
> commit 9b01c885be36 ("net: phy: c22: migrate to genphy_c45_write_eee_adv()")
> commit 5827b168125d ("net: phy: c45: migrate to genphy_c45_write_eee_adv()")
> 
> we set the advertisement to potentially supported values. This behavior
> may introduce new regressions on systems where EEE was disabled by
> default (BIOS or boot loader configuration or by other ways.)
> 
> At same time, with this patches, we would overwrite EEE advertisement
> configuration made over ethtool.
> 
> To avoid this issues, we need to cache initial and ethtool advertisement
> configuration and store it for later use.

This is good. I started adding phy_supports_eee() which MAC drivers
can call to say they support EEE. To help with that i also added
advertising_eee, which i initialise to 0. I've not get all the code in
place, but i was thinking to populate advertising_eee with
supported_eee when phy_supports_eee() is called, and add
genphy_c45_an_config_eee_aneg() or similar to be called during
phy_start(). So it look like you have implemented more than 1/2 of
what i wanted to do :-)

     Andrew

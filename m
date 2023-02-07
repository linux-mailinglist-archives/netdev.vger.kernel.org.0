Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4963068CBB0
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 02:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjBGBGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 20:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjBGBFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 20:05:54 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356E434C1E;
        Mon,  6 Feb 2023 17:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Kxgr1Z+G7gEE1M9r6++laPaamK40cZIEw/H+lncP1PM=; b=4zZHJVYQpVwmLV0hD9lEw5sI7O
        KoK+b2mWoTseGq6EWYfuQCXIX77rxAlXHVpdje7RWVRepY+yy/dptbfLpA4aiXgzQ4XWGKkEqrtqj
        Y+FBGh4lHoso5KiC3FcjN/iNk3l1GczFnCFBROM09n8MXQs2NvZwuPDjlGVydQcpK5DI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pPCQa-004Fla-MG; Tue, 07 Feb 2023 02:05:44 +0100
Date:   Tue, 7 Feb 2023 02:05:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v5 09/23] net: phy: start using
 genphy_c45_ethtool_get/set_eee()
Message-ID: <Y+Gj6PObDZ+zJSSG@lunn.ch>
References: <20230206135050.3237952-1-o.rempel@pengutronix.de>
 <20230206135050.3237952-10-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206135050.3237952-10-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 02:50:36PM +0100, Oleksij Rempel wrote:
> All preparations are done. Now we can start using new functions and remove
> the old code.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

This change looks correct, in that it just replaces code with other
equivalent code.

But looking at it, i started to wonder about locking. I don't see
phydev->lock held anywhere. But it does access members of phydev, in
particular speed and duplex. If the PHY state machine is running at
the same time, and phy_read_status() is called, those members can
contain invalid information.

So i think another patch is needed to add locking to these two
functions.

Otherwise:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462004D8C1F
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 20:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238927AbiCNTP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 15:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237636AbiCNTP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 15:15:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D03139155
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 12:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mSSUaYbQ1VnRZ4JXOVwJVDcxJQfpxZdcY3F4unMe6hM=; b=ZpweBrft6UaCgnYueOeYH3SRPG
        64VLyKhD1Tx5eWG4spBhcWNfymZegzm94aGB7JAENPL6c0VH78ByvrET4Q8k/B3hfwKH2oRfOS76f
        tf+Y87KDxzod6y+9Men8SwTAVsdAOZAw7vAR70azlYM0XUDsQ2fqpJppf4aar1e/G01E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nTq9M-00AnkL-HK; Mon, 14 Mar 2022 20:14:36 +0100
Date:   Mon, 14 Mar 2022 20:14:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <Yi+UHF37rb0URSwb@lunn.ch>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de>
 <20220314184234.GA556@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314184234.GA556@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 07:42:34PM +0100, Lukas Wunner wrote:
> [cc += Heiner Kallweit, Andrew Lunn]
> 
> On Thu, Mar 10, 2022 at 12:38:20PM +0100, Oleksij Rempel wrote:
> > On Thu, Mar 10, 2022 at 12:25:08PM +0100, Oliver Neukum wrote:
> > > I got bug reports that 2c9d6c2b871d ("usbnet: run unbind() before
> > > unregister_netdev()")
> > > is causing regressions.
> 
> I would like to see this reverted as well.  For obvious reasons,
> the order in usbnet_disconnect() should be the inverse of
> usbnet_probe().  Since 2c9d6c2b871d, that's no longer the case.
> 
> 
> > > Rather than simply reverting it,
> > > it seems to me that the call needs to be split. One in the old place
> > > and one in the place you moved it to.
> 
> I disagree.  The commit message claims that the change is necessary
> because phy_disconnect() fails if called with phydev->attached_dev == NULL.

The only place i see which sets phydev->attached_dev is
phy_attach_direct(). So if phydev->attached_dev is NULL, the PHY has
not been attached, and hence there is no need to call
phy_disconnect().

	Andrew

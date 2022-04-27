Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2A4511D9D
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239690AbiD0P21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239573AbiD0P2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:28:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93BF31ED60;
        Wed, 27 Apr 2022 08:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=f5CQYKHGPQAXOM4+HTY6bUhY3XHwoWllAgkeyCISNuw=; b=iOnsFc3n/CedGvAVbG/MCJG+aw
        BA7V+T8jDObpjLaRAI7tXLMAy89oc2KX9N6acHg1RT0hDgiwcU8g9OiQUREsgeES+NoInx0EaUXe2
        qcfPIdqA8zwnK7gekPaE97IlBVH0ScZaSguB/z11rMSCoGnNBP8w/2SeXtfL2qcqThZQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njjX8-0008Oi-1c; Wed, 27 Apr 2022 17:24:50 +0200
Date:   Wed, 27 Apr 2022 17:24:50 +0200
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
Subject: Re: [PATCH net] usbnet: smsc95xx: Fix deadlock on runtime resume
Message-ID: <YmlgQhauzZ/tkX/v@lunn.ch>
References: <6710d8c18ff54139cdc538763ba544187c5a0cee.1651041411.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6710d8c18ff54139cdc538763ba544187c5a0cee.1651041411.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 08:41:49AM +0200, Lukas Wunner wrote:
> Commit 05b35e7eb9a1 ("smsc95xx: add phylib support") amended
> smsc95xx_resume() to call phy_init_hw().  That function waits for the
> device to runtime resume even though it is placed in the runtime resume
> path, causing a deadlock.

Hi Lukas

You have looked at this code, tried a few different things, so this is
probably a dumb question.

Do you actually need to call phy_init_hw()?

mdio_bus_phy_resume() will call phy_init_hw(). So long as you first
resume the MAC and then the PHY, shouldn't this just work?

       Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827F0AF970
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfIKJtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:49:40 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56652 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfIKJtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 05:49:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vaHXFo8WzUG4noo64CSvhnxEJuxaupS9Ne4VzxeBXvU=; b=tIxXzBxP3R/J6OLjsZCZQQDYH
        X0bF9Ws1qcLhJZMsWYnEndd1pLaMT6BAm9jClNB8/5Ta512qwuGbhV2AQ8mRMzVws2QiiA6ZEFmCr
        lyh50/yULPZoT810E0nlxEBlKn3Ym0Ap7EqGf7ARkAQt54Ws2CTdPMKa711SzHjGd7OrDG51SJHUv
        k1Nd+NOd3kZmJ7g/naIFotTRrDTMYtgraqEv/4G6VuzXbnvT16w2+o2fqp0rr3QSeDKlEhxirmfSG
        sYQ5xt/9WkfyU9cfaHnWQbjkjzKoCwxPj27AbrdRy1YoWqz4pFIDM0nm+JT/dpakM8s970R+KkP0L
        m1ixRPRTw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42316)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i7zFk-0005Zd-Rz; Wed, 11 Sep 2019 10:49:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i7zFh-0003qo-Cd; Wed, 11 Sep 2019 10:49:29 +0100
Date:   Wed, 11 Sep 2019 10:49:29 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 04/11] net: phylink: switch to using
 fwnode_gpiod_get_index()
Message-ID: <20190911094929.GV13294@shell.armlinux.org.uk>
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
 <20190911075215.78047-5-dmitry.torokhov@gmail.com>
 <20190911092514.GM2680@smile.fi.intel.com>
 <20190911093914.GT13294@shell.armlinux.org.uk>
 <20190911094619.GN2680@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911094619.GN2680@smile.fi.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 12:46:19PM +0300, Andy Shevchenko wrote:
> On Wed, Sep 11, 2019 at 10:39:14AM +0100, Russell King - ARM Linux admin wrote:
> > On Wed, Sep 11, 2019 at 12:25:14PM +0300, Andy Shevchenko wrote:
> > > On Wed, Sep 11, 2019 at 12:52:08AM -0700, Dmitry Torokhov wrote:
> > > > Instead of fwnode_get_named_gpiod() that I plan to hide away, let's use
> > > > the new fwnode_gpiod_get_index() that mimics gpiod_get_index(), bit
> > > > works with arbitrary firmware node.
> > > 
> > > I'm wondering if it's possible to step forward and replace
> > > fwnode_get_gpiod_index by gpiod_get() / gpiod_get_index() here and
> > > in other cases in this series.
> > 
> > No, those require a struct device, but we have none.  There are network
> > drivers where there is a struct device for the network complex, but only
> > DT nodes for the individual network interfaces.  So no, gpiod_* really
> > doesn't work.
> 
> In the following patch the node is derived from struct device. So, I believe
> some cases can be handled differently.

phylink is not passed a struct device - it has no knowledge what the
parent device is.

In any case, I do not have "the following patch".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

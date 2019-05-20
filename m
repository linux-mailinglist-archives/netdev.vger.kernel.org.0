Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 959712405E
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 20:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbfETSbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 14:31:55 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51456 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfETSbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 14:31:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=c/Bn5Idb+LIgPZGPBqPg7U1SO1IQPZMc5NTSC6fIngU=; b=y0YXyYxwGeSWCTGKZKkF+sk/7
        s6IjbYB3CWKZ5t097NRa/o2+AMQ0hY9tVBNpNo7wPSIpRuI9oHqreQc5kXEV1+gdlL6U5lLA2VSgT
        3ct6o/aV1Ct05wFsCgeh9jtwtFUhH9l762n/q4TUg1xy7mEaVTor+Ue32xmpnZ7AxAXmpRNFBE6Xd
        3AjATKukLWQvxcBT7LMghzlA44LU4JxB6N0MbTO7BhvQ0UzAVMVl3vcfR3u25VJgILs7QNK9jVDpk
        63nI9o26jEO/Wkdnbc0LtzxNQi2y908lmR1j78VBirRQWylxAeww1zzjd4ZFzyVhtVlZ2QlQs9n38
        A5hD2/o3A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52550)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hSn4f-0004W0-Cf; Mon, 20 May 2019 19:31:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hSn4d-00057y-Jg; Mon, 20 May 2019 19:31:47 +0100
Date:   Mon, 20 May 2019 19:31:47 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: phylink: support for link gpio
 interrupt
Message-ID: <20190520183147.rq67lmrfci7kcal3@shell.armlinux.org.uk>
References: <20190520152134.qyka5t7c2i7drk4a@shell.armlinux.org.uk>
 <E1hSk6y-0000vs-Pj@rmk-PC.armlinux.org.uk>
 <a1bde03d-cd12-3f77-8e93-eed276f2bbdb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1bde03d-cd12-3f77-8e93-eed276f2bbdb@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 11:22:21AM -0700, Florian Fainelli wrote:
> On 5/20/19 8:22 AM, Russell King wrote:
> > Add support for using GPIO interrupts with a fixed-link GPIO rather than
> > polling the GPIO every second and invoking the phylink resolution.  This
> > avoids unnecessary calls to mac_config().
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Just one comment, see below:
> 
> [snip]
> 
> > -	if (pl->link_an_mode == MLO_AN_FIXED && !IS_ERR(pl->link_gpio))
> > -		del_timer_sync(&pl->link_poll);
> > +	del_timer_sync(&pl->link_poll);
> 
> Removing a timer that was only set-up if pl->link_an_mode ==
> MLO_AN_FIXED probably does not hurt, but this breaks symmetry a bit here.

The reason for this change is because that is no longer the only case
that the timer would be running.  The timer will be running if either
of the following are true:

1. We are in fixed mode, and we have a get_fixed_state function
   registered.
2. We are in fixed mode, and have a GPIO, but are unable to get an
   interrupt for it.

It's way simpler and less error-prone to just delete the timer here,
rather than trying to keep track of whether we armed it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DE41FD76B
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 23:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgFQVgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 17:36:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45002 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgFQVgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 17:36:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jlfje-0011mH-Tr; Wed, 17 Jun 2020 23:36:42 +0200
Date:   Wed, 17 Jun 2020 23:36:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Dejin Zheng <zhengdejin5@gmail.com>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Groeneveld <kgroeneveld@gmail.com>
Subject: Re: [PATCH net v1] net: phy: smsc: fix printing too many logs
Message-ID: <20200617213642.GE240559@lunn.ch>
References: <20200617153340.17371-1-zhengdejin5@gmail.com>
 <20200617161925.GE205574@lunn.ch>
 <20200617175039.GA18631@nuc8i5>
 <20200617184334.GA240559@lunn.ch>
 <20200617202450.GX1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617202450.GX1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 09:24:50PM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Jun 17, 2020 at 08:43:34PM +0200, Andrew Lunn wrote:
> > You have explained what the change does. But not why it is
> > needed. What exactly is happening. To me, the key thing is
> > understanding why we get -110, and why it is not an actual error we
> > should be reporting as an error. That is what needs explaining.
> 
> The patch author really ought to be explaining this... but let me
> have a go.  It's worth pointing out that the comments in the file
> aren't good English either, so don't really describe what is going
> on.
> 
> When this PHY is in EDPD mode, it doesn't always detect a connected
> cable.  The workaround for it involves, when the link is down, and
> at each read_status() call:
> 
> - disable EDPD mode, forcing the PHY out of low-power mode
> - waiting 640ms to see if we have any energy detected from the media
> - re-enable entry to EDPD mode
> 
> This is presumably enough to allow the PHY to notice that a cable is
> connected, and resume normal operations to negotiate with the partner.
> 
> The problem is that when no media is detected, the 640ms wait times
> out (as it should, we don't want to wait forever) and the kernel
> prints a warning.

Hi Russell

Yes, that is what i was thinking. 

There probably should be a comment added just to prevent somebody
swapping it back to phy_read_poll_timeout(). It is not clear that
-ETIMEOUT is expected under some conditions.

	  Andrew

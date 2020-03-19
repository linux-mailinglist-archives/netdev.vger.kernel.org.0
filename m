Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4108818AEE6
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 10:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgCSJGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 05:06:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44650 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgCSJGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 05:06:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PFj90DtW8fOKoWs5XlSZHKi6lzo60GHHLfDWi1eH0VQ=; b=iMdAUVYVb1cpJDl7vMXfbscGmE
        5cGbTDGXXvNn+/5ZJv8ptNK34b5K39D39BYCoF0tde5m9QhNx6ynbuuVlJL1xriKWQIF1Hqmp+QW+
        T5vKYflHTcfGm1OqmeAUK/TjmkMcoHDqwuNqTbzv25UXO2ckw3jtxXh90tnCAJ7wISuA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jEr8S-0005SH-3k; Thu, 19 Mar 2020 10:06:40 +0100
Date:   Thu, 19 Mar 2020 10:06:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: add and use phy_check_downshift
Message-ID: <20200319090640.GB20761@lunn.ch>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
 <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
 <20200318232159.GA25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318232159.GA25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 11:21:59PM +0000, Russell King - ARM Linux admin wrote:
> On Wed, Mar 18, 2020 at 10:29:01PM +0100, Heiner Kallweit wrote:
> > So far PHY drivers have to check whether a downshift occurred to be
> > able to notify the user. To make life of drivers authors a little bit
> > easier move the downshift notification to phylib. phy_check_downshift()
> > compares the highest mutually advertised speed with the actual value
> > of phydev->speed (typically read by the PHY driver from a
> > vendor-specific register) to detect a downshift.
> 
> My personal position on this is that reporting a downshift will be
> sporadic at best, even when the link has negotiated slower.
> 
> The reason for this is that either end can decide to downshift.  If
> the remote partner downshifts, then the local side has no idea that
> a downshift occurred, and can't report that the link was downshifted.
> 
> So, is it actually useful to report these events?

It is better than nothing.

We get one end reporting a downshift, and the peer reporting a slower
than expected negotiated link speed. Combined that gives a good clue.

I also want to start merging cable diagnostics soon. There is enough
of netlink ethtool in place to allow this.

And the same netlink ethool will allow us to extend the API and report
downshift in the ethtool output, not just a kernel message.

	  Andrew

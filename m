Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC0014A97
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 15:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfEFNLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 09:11:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55747 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbfEFNLA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 09:11:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8kK7MDK5OvSv4G2AfixGougja6HPpqlMJjQr3v6Sgpc=; b=uEbhgm1sSG6gWS7iLGepNldkwJ
        41KMrLsQaPfWo2P5dsH31dPwEg5Xx0uWOgwIODTzBveiNkRjUHNEdZ9kiheqZSTjb7I+8yl3XRQ50
        45X230U+eoNnGh5hGyF9TLAkP8grO02RwwdDPlTjPamjkIUX7xN14lhWm3Jspm93byq0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hNdOT-0004pw-Mq; Mon, 06 May 2019 15:10:57 +0200
Date:   Mon, 6 May 2019 15:10:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: Decoupling phy_device from net_device (was "Re: [PATCH] net:
 dsa: fixed-link interface is reporting SPEED_UNKNOWN")
Message-ID: <20190506131057.GB15291@lunn.ch>
References: <20190411230139.13160-1-olteanv@gmail.com>
 <3661ec3f-1a13-26d8-f7dc-7a73ac210f08@gmail.com>
 <a10e3ef7-2928-8865-c463-f9edc7261410@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a10e3ef7-2928-8865-c463-f9edc7261410@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 01:00:49AM +0300, Vladimir Oltean wrote:
> On 4/12/19 8:57 PM, Heiner Kallweit wrote:
> >On 12.04.2019 01:01, Vladimir Oltean wrote:
> >>With Heiner's recent patch "b6163f194c69 net: phy: improve
> >>genphy_read_status", the phydev->speed is now initialized by default to
> >>SPEED_UNKNOWN even for fixed PHYs. This is not necessarily bad, since it
> >>is not correct to call genphy_config_init() and genphy_read_status() for
> >>a fixed PHY.
> >>
> >What do you mean with "it is not correct"? Whether the calls are always
> >needed may be a valid question, but it's not forbidden to use these calls
> >with a fixed PHY. Actually in phylib polling mode genphy_read_status is
> >called every second also for a fixed PHY. swphy emulates all relevant
> >PHY registers.
> >
> >>This dates back all the way to "39b0c705195e net: dsa: Allow
> >>configuration of CPU & DSA port speeds/duplex" (discussion thread:
> >>https://www.spinics.net/lists/netdev/msg340862.html).
> >>
> >>I don't seem to understand why these calls were necessary back then, but
> >>removing these calls seemingly has no impact now apart from preventing
> >>the phydev->speed that was set in of_phy_register_fixed_link() from
> >>getting overwritten.

As Florian said, if you have patches, please post them and we will
consider them.

But i think we also need to take a step back and consider the big
picture. There has been a lot of work recently to support multi-G
PHYs. It is clear we soon need to make changes to fixed-link. It only
supports up to 1G. But we have use cases where we need multi-G fixed
links.

We could also consider making the tie to the MAC much stronger. We
have been encouraging MAC driver writers to make use of the
ndev->phylib pointer. We could even enforce that, and use
container_of() to determine the MAC associated to a PHY.

	Andrew

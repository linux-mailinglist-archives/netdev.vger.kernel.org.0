Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9E62C4210
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 15:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgKYOSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 09:18:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49438 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729793AbgKYOSh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 09:18:37 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1khvck-008n5A-KP; Wed, 25 Nov 2020 15:18:22 +0100
Date:   Wed, 25 Nov 2020 15:18:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [PATCH net-next v2 0/2] Add support for DSFP transceiver type
Message-ID: <20201125141822.GI2075216@lunn.ch>
References: <1606123198-6230-1-git-send-email-moshe@mellanox.com>
 <20201124011459.GD2031446@lunn.ch>
 <20201124131608.1b884063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <98319caa-de5f-6f5e-9c9e-ee680e5abdc0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98319caa-de5f-6f5e-9c9e-ee680e5abdc0@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> OK, we will add API options to select bank and page to read any specific
> page the user selects. So advanced user will use it get the optional pages
> he needs, but what about non advanced user who wants to use the current API
> with a current script for DSFP EEPROM. Isn't it better that he will get the
> 5 mandatory pages then keep it not supported ?

Users using ethtool will not see a difference. They get a dump of what
ethtool knows how to decode. It should try the netlink API first, and
then fall back to the old ioctl interface.

If i was implementing the ethtool side of it, i would probably do some
sort of caching system. We know page 0 should always exist, so
pre-load that into the cache. Try the netlink API first. If that
fails, use the ioctl interface. If the ioctl is used, put everything
returned into the cache. The decoder can then start decoding, see what
bits are set indicating other pages should be available. Ask for them
from the cache. The netlink API can go fetch them and load them into
the cache. If they cannot be loaded return ENODEV, and the decoder has
to skip what it wanted to decode. If you do it correctly, the decoder
should not care about ioctl vs netlink.

I can do a follow up patch for the generic SFP code in
drivers/net/phy, once you have done the first implementation. But i
only have a limited number of SFPs and most are 1G only. Russell King
can hopefully test with his collection.

     Andrew

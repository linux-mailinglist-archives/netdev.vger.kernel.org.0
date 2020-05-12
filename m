Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AD81CFD68
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 20:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbgELShp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 14:37:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbgELShp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 14:37:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ufeokk8l7hSaLGTDg3N7R5AfsEhxXksaL7wPbnpA7cs=; b=uvUW7RHmJoZtXbxZcIkao+l0Gq
        xbCqZcHgENaKOn49L7K+Lwf1pwXnzRY+jIZUBOw/CO7cy4M5GGp73vZv76HulOnN0qh01Qo/+lhrA
        kK9oiF+HeM62Jdd3apEYJE6ujxyfVZK+vMNyaNa21lTfTclZ/PZjHN9gyjVFCbhKpjBs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYZmc-00218y-G2; Tue, 12 May 2020 20:37:38 +0200
Date:   Tue, 12 May 2020 20:37:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Doug Berger <opendmb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: ethernet: validate pause autoneg
 setting
Message-ID: <20200512183738.GD453318@lunn.ch>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-2-git-send-email-opendmb@gmail.com>
 <20200512004714.GD409897@lunn.ch>
 <ae63b295-b6e3-6c34-c69d-9e3e33bf7119@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae63b295-b6e3-6c34-c69d-9e3e33bf7119@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 11:31:39AM -0700, Doug Berger wrote:
> On 5/11/2020 5:47 PM, Andrew Lunn wrote:
> > On Mon, May 11, 2020 at 05:24:07PM -0700, Doug Berger wrote:
> >> A comment in uapi/linux/ethtool.h states "Drivers should reject a
> >> non-zero setting of @autoneg when autoneogotiation is disabled (or
> >> not supported) for the link".
> >>
> >> That check should be added to phy_validate_pause() to consolidate
> >> the code where possible.
> >>
> >> Fixes: 22b7d29926b5 ("net: ethernet: Add helper to determine if pause configuration is supported")
> > 
> > Hi Doug
> > 
> > If this is a real fix, please submit this to net, not net-next.
> > 
> >    Andrew
> > 
> This was intended as a fix, but I thought it would be better to keep it
> as part of this set for context and since net-next is currently open.

My real question is, do you think this should be back ported in
stable?  If so, it should be against net. If this is only intended for
new kernels, don't add a Fixes: tag.

> Personally, I'm actually not that fond of this change since it can
> easily be a source of confusion with the ethtool interface because the
> link autonegotiation and the pause autonegotiation are controlled by
> different commands.
> 
> Since the ethtool -A command performs a read/modify/write of pause
> parameters, you can get strange results like these:
> # ethtool -s eth0 speed 100 duplex full autoneg off
> # ethtool -A eth0 tx off
> Cannot set device pause parameters: Invalid argument
> #
> Because, the get read pause autoneg as enabled and only the tx_pause
> member of the structure was updated.

We can at least improve the error message when using netlink
ethtool. Using extack, we can pass back a string, saying why this
configuration is invalid, that link autoneg is off.

	Andrew

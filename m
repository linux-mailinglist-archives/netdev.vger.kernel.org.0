Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4148245BC82
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 13:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243641AbhKXMbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 07:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:42106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245506AbhKXM2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 07:28:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DA6061269;
        Wed, 24 Nov 2021 12:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637756227;
        bh=4Bwn5rvzFaQX6/M2Ep7RPrdvX/Thgii4YOdsQ3DDAGs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GmhRSa6/MuM56Kz+5NAzjuJN+IAHQHehfqMjrwDF6Nmi3aepqRMFsZJnLxjkCaLZ0
         875Lh6WjSpmBYpFf9DT1DC4T3KoGBuObUdboOFslbdOtor6+DHCd3AML5pk8c/mFGg
         pesH0n4e1Z4P8irpmmi+IE5oTUb5iwuXE3VYBY8xEyYZiC/gW7//srJ+WfKARRCQbs
         MFY10CLu6hSm+n62EeVtgdRLu/AGg6RejjppL2tD7zcElpzHUoYfDgdMrqDi36aU34
         Nots5+nhir9dunFyzmBOIeqZuUpviycPfbFQZnORxXCoo3rjnzJLSPO0dg8i/N3N7n
         tTCCAslARt4iQ==
Date:   Wed, 24 Nov 2021 13:17:03 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net
Subject: Re: [PATCH net-next v2 4/8] net: phylink: update
 supported_interfaces with modes from fwnode
Message-ID: <20211124131703.30176315@thinkpad>
In-Reply-To: <20211124120441.i7735czjm5k3mkwh@skbuf>
References: <20211123164027.15618-1-kabel@kernel.org>
        <20211123164027.15618-5-kabel@kernel.org>
        <20211123212441.qwgqaad74zciw6wj@skbuf>
        <20211123232713.460e3241@thinkpad>
        <20211123225418.skpnnhnrsdqrwv5f@skbuf>
        <YZ4cRWkEO+l1W08u@shell.armlinux.org.uk>
        <20211124120441.i7735czjm5k3mkwh@skbuf>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 14:04:41 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Wed, Nov 24, 2021 at 11:04:37AM +0000, Russell King (Oracle) wrote:
> > On Wed, Nov 24, 2021 at 12:54:18AM +0200, Vladimir Oltean wrote:  
> > > This implies that when you bring up a board and write the device tree
> > > for it, you know that PHY mode X works without ever testing it. What if
> > > it doesn't work when you finally add support for it? Now you already
> > > have one DT blob in circulation. That's why I'm saying that maybe it
> > > could be better if we could think in terms that are a bit more physical
> > > and easy to characterize.  
> > 
> > However, it doesn't solve the problem. Let's take an example.
> > 
> > The 3310 supports a mode where it runs in XAUI/5GBASE-R/2500BASE-X/SGMII
> > depending on the negotiated media parameters.
> > 
> > XAUI is four lanes of 3.125Gbaud.
> > 5GBASE-R is one lane of 5.15625Gbaud.
> > 
> > Let's say you're using this, and test the 10G speed using XAUI,
> > intending the other speeds to work. So you put in DT that you support
> > four lanes and up to 5.15625Gbaud.  
> 
> Yes, see, the blame's on you if you do that.You effectively declared
> that the lane is able of sustaining a data rate higher than you've
> actually had proof it does (5.156 vs 3.125).

But the blame is on the DT writer in the same way if they declare
support for a PHY mode that wasn't tested. (Or at least self-tests with
PRBS patterns at given frequency.)

> The reason why I'm making this suggestion is because I think it lends
> itself better to the way in which hardware manufacturers work.
> A hobbyist like me has no choice than to test the highest data rate when
> determining what frequency to declare in the DT (it's the same thing for
> spi-max-frequency and other limilar DT properties, really), but hardware
> people have simulations based on IBIS-AMI models, they can do SERDES
> self-tests using PRBS patterns, lots of stuff to characterize what
> frequency a lane is rated for, without actually speaking any Ethernet
> protocol on it. In fact there are lots of people who can do this stuff
> (which I know mostly nothing about) with precision without even knowing
> how to even type a simple "ls" inside a Linux shell.
>
> > Later, you discover that 5GBASE-R doesn't work because there's an
> > electrical issue with the board. You now have DT in circulation
> > which doesn't match the capabilities of the hardware.
> > 
> > How is this any different from the situation you describe above?
> > To me, it seems to be exactly the same problem.  
> 
> To err is human, of course. But one thing I think we learned from the
> old implementation of phylink_validate is that it gets very tiring to
> keep adding PHY modes, and we always seem to miss some. When that array
> will be described in DT, it could be just a tad more painful to maintain.

The thing is that we will still need the `phy-mode` property, it can't
be deprecated IMO. There are non-SerDes modes, like rgmii, which may
use different pins than SerDes modes.
There may theoretically also be a SoC or PHY where the lanes for XAUI
do not share pins with the lane of 2500base-x, and this lane may not be
wired. Tis true that I don't know of any such hardware and it probably
does not and will not exist, but we don't know that for sure and this is
a case where your proposal will fail and the phy-mode extension would
work nicely.

Maybe we need opinions from other people here.

Marek

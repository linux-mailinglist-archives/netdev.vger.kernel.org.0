Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4328855931
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfFYUmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:42:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59456 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfFYUmC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 16:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Yqc4vT4415VkqyQ2Zqhlm7NzOXhoJ6B6XpmxOaJIoGI=; b=xMpeGzpmHMbEU3WkmL7jnCkNTm
        f7+XoXiiO2CO+5ZdfZlDfKBytPSYATwmYXMuT7MP/rJDEplXLxEnMQ+M6L/HH0QW1gBF6BAg9U96/
        IFCcsT4dpEJHmqoeFKHF5/CUURXjSb7jQA/mR4SJndTI3tJqBNbacBssWdzNwxvr/0jY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfsGC-0000mO-Nt; Tue, 25 Jun 2019 22:41:48 +0200
Date:   Tue, 25 Jun 2019 22:41:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Santos <daniel.santos@pobox.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, vivien.didelot@gmail.com,
        frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
Message-ID: <20190625204148.GB27733@lunn.ch>
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-2-opensource@vdorst.com>
 <20190624153950.hdsuhrvfd77heyor@shell.armlinux.org.uk>
 <20190625113158.Horde.pCaJOVUsgyhYLd5Diz5EZKI@www.vdorst.com>
 <20190625121030.m5w7wi3rpezhfgyo@shell.armlinux.org.uk>
 <1ad9f9a5-8f39-40bd-94bb-6b700f30c4ba@pobox.com>
 <20190625190246.GA27733@lunn.ch>
 <4fc51dc4-0eec-30d7-86d1-3404819cf6fe@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4fc51dc4-0eec-30d7-86d1-3404819cf6fe@pobox.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 02:27:55PM -0500, Daniel Santos wrote:
> On 6/25/19 2:02 PM, Andrew Lunn wrote:
> >> But will there still be a mechanism to ignore link partner's advertising
> >> and force these parameters?
> > >From man 1 ethtool:
> >
> >        -a --show-pause
> >               Queries the specified Ethernet device for pause parameter information.
> >
> >        -A --pause
> >               Changes the pause parameters of the specified Ethernet device.
> >
> >            autoneg on|off
> >                   Specifies whether pause autonegotiation should be enabled.
> >
> >            rx on|off
> >                   Specifies whether RX pause should be enabled.
> >
> >            tx on|off
> >                   Specifies whether TX pause should be enabled.
> >
> > You need to check the driver to see if it actually implements this
> > ethtool call, but that is how it should be configured.
> >
> > 	Andrew
> >
> Thank you Andrew,
> 
> So in this context, my question is the difference between "enabling" and
> "forcing".  Here's that register for the mt7620 (which has an mt7530 on
> its die): https://imgur.com/a/pTk0668  I believe this is also what René
> is seeking clarity on?

Lets start with normal operation. If the MAC supports pause or asym
pause, it calls phy_support_sym_pause() or phy_support_asym_pause().
phylib will then configure the PHY to advertise pause as appropriate.
Once auto-neg has completed, the results of the negotiation are set in
phydev. So phdev->pause and phydev->asym_pause. The MAC callback is
then used to tell the MAC about the autoneg results. The MAC should be
programmed using the values in phdev->pause and phydev->asym_pause.

For ethtool, the MAC driver needs to implement .get_pauseparam and
.set_pauseparam. The set_pauseparam needs to validate the settings,
using phy_validate_pause(). If valid, phy_set_asym_pause() is used to
tell the PHY about the new configuration. This will trigger a new
auto-neg if auto-neg is enabled, and the results will be passed back
in the usual way. If auto-neg is disabled, or pause auto-neg is
disabled, the MAC should configure pause directly based on the
settings passed.

Looking at the data sheet page, you want FORCE_MODE_Pn set. You never
want the MAC directly talking to the PHY. Bad things will happen.
Then use FORCE_RX_FC_Pn and FORCE_TX_Pn to reflect phydev->pause and
phydev->asym_pause.

The same idea applies when using phylink.

    Andrew

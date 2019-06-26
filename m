Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC94955DFB
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 03:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfFZBxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 21:53:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60352 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfFZBxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 21:53:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kMI+jbwLjwcHDwbzOcT0DV6XCOAjiyVP6LoQDg6R71A=; b=1XdnwPWnx3QNsuu/0jY9gzb+eY
        soZ3A8P7JyBW8LNe9dfvK/Qxp0MMJjbFBKf1RKfib4Xl08piQUH9rwz1HhqALqsEyejPRA5u7PUNt
        jW6aLRAjU3cF10YUZl2FoDXAaeZ+hO8A6CR8mRj3ObZOZW3//AvVDnif0t99vfsfAlRk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfx7C-0006TO-DH; Wed, 26 Jun 2019 03:52:50 +0200
Date:   Wed, 26 Jun 2019 03:52:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        sean.wang@mediatek.com, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, matthias.bgg@gmail.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        frank-w@public-files.de, netdev <netdev@vger.kernel.org>,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
Message-ID: <20190626015250.GH17872@lunn.ch>
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-2-opensource@vdorst.com>
 <20190624153950.hdsuhrvfd77heyor@shell.armlinux.org.uk>
 <6f80325d-4b42-6174-e050-48626f7a3662@gmail.com>
 <20190625215329.5ubixxiwprnubwmv@shell.armlinux.org.uk>
 <CA+h21hqK0VMtHpZ6eka9ESuMhsFTw2mx+c0GYmxq4_G_YmiVpg@mail.gmail.com>
 <20190625225759.zztqgnwtk4v7milp@shell.armlinux.org.uk>
 <CA+h21hq_w8-96ehKYxcziSq1TjOjoKduZ+pB3umBfjODaKWd+A@mail.gmail.com>
 <CA+h21hrsosGVQczMWy1+WfyNGZCpeMFerUwvWb-z+TTjrSOP1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrsosGVQczMWy1+WfyNGZCpeMFerUwvWb-z+TTjrSOP1Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 02:13:25AM +0300, Vladimir Oltean wrote:
> On Wed, 26 Jun 2019 at 02:10, Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Wed, 26 Jun 2019 at 01:58, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Wed, Jun 26, 2019 at 01:14:59AM +0300, Vladimir Oltean wrote:
> > > > On Wed, 26 Jun 2019 at 00:53, Russell King - ARM Linux admin
> > > > <linux@armlinux.org.uk> wrote:
> > > > >
> > > > > On Tue, Jun 25, 2019 at 11:24:01PM +0300, Vladimir Oltean wrote:
> > > > > > Hi Russell,
> > > > > >
> > > > > > On 6/24/19 6:39 PM, Russell King - ARM Linux admin wrote:
> > > > > > > This should be removed - state->link is not for use in mac_config.
> > > > > > > Even in fixed mode, the link can be brought up/down by means of a
> > > > > > > gpio, and this should be dealt with via the mac_link_* functions.
> > > > > > >
> > > > > >
> > > > > > What do you mean exactly that state->link is not for use, is that true in
> > > > > > general?
> > > > >
> > > > > Yes.  mac_config() should not touch it; it is not always in a defined
> > > > > state.  For example, if you set modes via ethtool (the
> > > > > ethtool_ksettings_set API) then state->link will probably contain
> > > > > zero irrespective of the true link state.
> > > > >
> > > >
> > > > Experimentally, state->link is zero at the same time as state->speed
> > > > is -1, so just ignoring !state->link made sense. This is not in-band
> > > > AN. What is your suggestion? Should I proceed to try and configure the
> > > > MAC for SPEED_UNKNOWN?
> > >
> > > What would you have done with a PHY when the link is down, what speed
> > > would you have configured in the phylib adjust_link callback?  phylib
> > > also sets SPEED_UNKNOWN/DUPLEX_UNKNOWN when the link is down.
> > >
> >
> > With phylib, I'd make the driver ignore the speed and do nothing.
> > With phylink, I'd make the core not call mac_config.
> > But what happened is I saw phylink call mac_config anyway, said
> > 'weird' and proceeded to ignore it as I would have for phylib.
> > I'm just not understanding your position - it seems like you're
> > implying there's a bug in phylink and the function call with
> > MLO_AN_FIXED, state->link=0 and state->speed=-1 should not have taken
> 
> I meant MLO_AN_PHY, sorry.

The MAC could go into a low power mode.

    Andrew

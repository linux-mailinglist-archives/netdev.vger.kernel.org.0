Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3AC22E40B
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 04:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgG0CjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 22:39:23 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:52280 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgG0CjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 22:39:23 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A831D2A9;
        Mon, 27 Jul 2020 04:39:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1595817560;
        bh=kWNbLlpkGYbhWzpmWDluy7C+R9HcO0xNCY7PJaab3DM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OoGUim3Kz1JkoIVhqrjfIqjHL9GHdB9Bvh0C3TouzXSnKL0vgTOwTmS7Pc6AFn5Ey
         tuPXY33weibKvTV4Lw7QHNRYFCVdN3xIcR98edgOs5V08l3ZZBNKzR+WG4jxkB1NEe
         9vGRkJ4QnogUbTL7ulB5hF4FCqONlvqGKZJQyLR0=
Date:   Mon, 27 Jul 2020 05:39:13 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Chris Healy <cphealy@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
Message-ID: <20200727023913.GC23988@pendragon.ideasonboard.com>
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
 <20200727012354.GT28704@pendragon.ideasonboard.com>
 <20200727020631.GW28704@pendragon.ideasonboard.com>
 <20200727021432.GM1661457@lunn.ch>
 <20200727023310.GA23988@pendragon.ideasonboard.com>
 <CAFXsbZrf11Nj4rzLJfisPr-fFo-+stt-G3-XQ_Mwus_2z0nsAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFXsbZrf11Nj4rzLJfisPr-fFo-+stt-G3-XQ_Mwus_2z0nsAg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris,

On Sun, Jul 26, 2020 at 07:35:51PM -0700, Chris Healy wrote:
> Hi Laurent,
> 
> I have the exact same copper PHY.  I just reverted a patch specific to
> this PHY and went from broken to working.  Give this a try:
> 
> git revert bcf3440c6dd78bfe5836ec0990fe36d7b4bb7d20

Reverting this on top of v5.8-rc6 (without any revert of FEC commits)
fixes the issue too.

> On Sun, Jul 26, 2020 at 7:33 PM Laurent Pinchart wrote:
> > On Mon, Jul 27, 2020 at 04:14:32AM +0200, Andrew Lunn wrote:
> > > On Mon, Jul 27, 2020 at 05:06:31AM +0300, Laurent Pinchart wrote:
> > > > On Mon, Jul 27, 2020 at 04:24:02AM +0300, Laurent Pinchart wrote:
> > > > > On Mon, Apr 27, 2020 at 10:08:04PM +0800, Fugang Duan wrote:
> > > > > > This reverts commit 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef.
> > > > > >
> > > > > > The commit breaks ethernet function on i.MX6SX, i.MX7D, i.MX8MM,
> > > > > > i.MX8MQ, and i.MX8QXP platforms. Boot yocto system by NFS mounting
> > > > > > rootfs will be failed with the commit.
> > > > >
> > > > > I'm afraid this commit breaks networking on i.MX7D for me :-( My board
> > > > > is configured to boot over NFS root with IP autoconfiguration through
> > > > > DHCP. The DHCP request goes out, the reply it sent back by the server,
> > > > > but never noticed by the fec driver.
> > > > >
> > > > > v5.7 works fine. As 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef was merged
> > > > > during the v5.8 merge window, I suspect something else cropped in
> > > > > between 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef and this patch that
> > > > > needs to be reverted too. We're close to v5.8 and it would be annoying
> > > > > to see this regression ending up in the released kernel. I can test
> > > > > patches, but I'm not familiar enough with the driver (or the networking
> > > > > subsystem) to fix the issue myself.
> > > >
> > > > If it can be of any help, I've confirmed that, to get the network back
> > > > to usable state from v5.8-rc6, I have to revert all patches up to this
> > > > one. This is the top of my branch, on top of v5.8-rc6:
> > > >
> > > > 5bbe80c9efea Revert "net: ethernet: fec: Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO""
> > > > 5462896a08c1 Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO"
> > > > 824a82e2bdfa Revert "net: ethernet: fec: move GPR register offset and bit into DT"
> > > > bfe330591cab Revert "net: fec: disable correct clk in the err path of fec_enet_clk_enable"
> > > > 109958cad578 Revert "net: ethernet: fec: prevent tx starvation under high rx load"
> > >
> > > OK.
> > >
> > > What PHY are you using? A Micrel?
> >
> > KSZ9031RNXIA
> >
> > > And which DT file?
> >
> > It's out of tree.
> >
> > &fec1 {
> >         pinctrl-names = "default";
> >         pinctrl-0 = <&pinctrl_enet1>;
> >         assigned-clocks = <&clks IMX7D_ENET1_TIME_ROOT_SRC>,
> >                           <&clks IMX7D_ENET1_TIME_ROOT_CLK>;
> >         assigned-clock-parents = <&clks IMX7D_PLL_ENET_MAIN_100M_CLK>;
> >         assigned-clock-rates = <0>, <100000000>;
> >         phy-mode = "rgmii";
> >         phy-handle = <&ethphy0>;
> >         phy-reset-gpios = <&gpio1 13 GPIO_ACTIVE_LOW>;
> >         phy-supply = <&reg_3v3_sw>;
> >         fsl,magic-packet;
> >         status = "okay";
> >
> >         mdio {
> >                 #address-cells = <1>;
> >                 #size-cells = <0>;
> >
> >                 ethphy0: ethernet-phy@0 {
> >                         reg = <1>;
> >                 };
> >
> >                 ethphy1: ethernet-phy@1 {
> >                         reg = <2>;
> >                 };
> >         };
> > };
> >
> > I can provide the full DT if needed.

-- 
Regards,

Laurent Pinchart

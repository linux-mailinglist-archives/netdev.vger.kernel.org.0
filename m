Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4447722E401
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 04:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgG0CdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 22:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgG0CdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 22:33:23 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7238C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 19:33:22 -0700 (PDT)
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 883752A9;
        Mon, 27 Jul 2020 04:33:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1595817198;
        bh=BpwMQJZT3f5JKIw+i1X5oyLas85YawWPS5RThF+VZlU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LTu3186X+t+vQEu0c224BXSgV4SwuCCH5hY1Juey4PgwDRp8tJ2WGuqAq9Eg0M48T
         HpDXFa+wpoaGW+BEjFNuL4T0oqwTfGtY374MGpQ1UKmBqoWaJRtQ91N/9HQKxhi/wV
         UMxomVB/C7xlwRQuwTp5MJ/IeAbs4OXfE15Hbi+c=
Date:   Mon, 27 Jul 2020 05:33:10 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Fugang Duan <fugang.duan@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org, cphealy@gmail.com,
        martin.fuzzey@flowbird.group
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
Message-ID: <20200727023310.GA23988@pendragon.ideasonboard.com>
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
 <20200727012354.GT28704@pendragon.ideasonboard.com>
 <20200727020631.GW28704@pendragon.ideasonboard.com>
 <20200727021432.GM1661457@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200727021432.GM1661457@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Jul 27, 2020 at 04:14:32AM +0200, Andrew Lunn wrote:
> On Mon, Jul 27, 2020 at 05:06:31AM +0300, Laurent Pinchart wrote:
> > On Mon, Jul 27, 2020 at 04:24:02AM +0300, Laurent Pinchart wrote:
> > > On Mon, Apr 27, 2020 at 10:08:04PM +0800, Fugang Duan wrote:
> > > > This reverts commit 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef.
> > > > 
> > > > The commit breaks ethernet function on i.MX6SX, i.MX7D, i.MX8MM,
> > > > i.MX8MQ, and i.MX8QXP platforms. Boot yocto system by NFS mounting
> > > > rootfs will be failed with the commit.
> > > 
> > > I'm afraid this commit breaks networking on i.MX7D for me :-( My board
> > > is configured to boot over NFS root with IP autoconfiguration through
> > > DHCP. The DHCP request goes out, the reply it sent back by the server,
> > > but never noticed by the fec driver.
> > > 
> > > v5.7 works fine. As 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef was merged
> > > during the v5.8 merge window, I suspect something else cropped in
> > > between 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef and this patch that
> > > needs to be reverted too. We're close to v5.8 and it would be annoying
> > > to see this regression ending up in the released kernel. I can test
> > > patches, but I'm not familiar enough with the driver (or the networking
> > > subsystem) to fix the issue myself.
> > 
> > If it can be of any help, I've confirmed that, to get the network back
> > to usable state from v5.8-rc6, I have to revert all patches up to this
> > one. This is the top of my branch, on top of v5.8-rc6:
> > 
> > 5bbe80c9efea Revert "net: ethernet: fec: Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO""
> > 5462896a08c1 Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO"
> > 824a82e2bdfa Revert "net: ethernet: fec: move GPR register offset and bit into DT"
> > bfe330591cab Revert "net: fec: disable correct clk in the err path of fec_enet_clk_enable"
> > 109958cad578 Revert "net: ethernet: fec: prevent tx starvation under high rx load"
> 
> OK.
> 
> What PHY are you using? A Micrel?

KSZ9031RNXIA

> And which DT file?

It's out of tree.

&fec1 {
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_enet1>;
        assigned-clocks = <&clks IMX7D_ENET1_TIME_ROOT_SRC>,
                          <&clks IMX7D_ENET1_TIME_ROOT_CLK>;
        assigned-clock-parents = <&clks IMX7D_PLL_ENET_MAIN_100M_CLK>;
        assigned-clock-rates = <0>, <100000000>;
        phy-mode = "rgmii";
        phy-handle = <&ethphy0>;
        phy-reset-gpios = <&gpio1 13 GPIO_ACTIVE_LOW>;
        phy-supply = <&reg_3v3_sw>;
        fsl,magic-packet;
        status = "okay";

        mdio {
                #address-cells = <1>;
                #size-cells = <0>;

                ethphy0: ethernet-phy@0 {
                        reg = <1>;
                };

                ethphy1: ethernet-phy@1 {
                        reg = <2>;
                };
        };
};

I can provide the full DT if needed. 

-- 
Regards,

Laurent Pinchart

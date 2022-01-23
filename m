Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A75497273
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 16:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237522AbiAWP1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 10:27:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49588 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbiAWP1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jan 2022 10:27:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=CDXH3slO3ImdP5p+Qxn309qZZbRCzo4mZK6/h2SqEPI=; b=Px
        ZodgiK3xqJxqUn06GVYRp3qh+CtF8LPumMDL3kOpW4O4W3gNg5pi68ozY97QXkzF7BxLCCy7rsf1R
        4SMD2uklnSJO0yWmyQH/1VY8fA87yX4XLuvpRYlus34qOGJpai14qqxUGABTzu9GHIibeL9gXhk3y
        hjTSY1hcs0wAOwM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nBelc-002OC8-St; Sun, 23 Jan 2022 16:26:56 +0100
Date:   Sun, 23 Jan 2022 16:26:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Siddhant Gupta <siddhantgupta416@gmail.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, linux-mips@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, openwrt-devel@lists.openwrt.org,
        erkin.bozoglu@xeront.com
Subject: Re: MT7621 SoC Traffic Won't Flow on RGMII2 Bus/2nd GMAC
Message-ID: <Ye1zwIFUa5LPQbQm@lunn.ch>
References: <83a35aa3-6cb8-2bc4-2ff4-64278bbcd8c8@arinc9.com>
 <CALW65jZ4N_YRJd8F-uaETWm1Hs3rNcy95csf++rz7vTk8G8oOg@mail.gmail.com>
 <02ecce91-7aad-4392-c9d7-f45ca1b31e0b@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <02ecce91-7aad-4392-c9d7-f45ca1b31e0b@arinc9.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 11:33:04AM +0300, Arınç ÜNAL wrote:
> Hey Deng,
> 
> On 23/01/2022 09:51, DENG Qingfang wrote:
> > Hi,
> > 
> > Do you set the ethernet pinmux correctly?
> > 
> > &ethernet {
> >      pinctrl-names = "default";
> >      pinctrl-0 = <&rgmii1_pins &rgmii2_pins &mdio_pins>;
> > };
> 
> This fixed it! We did have &rgmii2_pins on the gmac1 node (it was originally
> on external_phy) so we never thought to investigate the pinctrl
> configuration further! Turns out &rgmii2_pins needs to be defined on the
> ethernet node instead.

PHYs are generally external, so pinmux on them makes no sense. PHYs in
DT are not devices in the usual sense, so i don't think the driver
core will handle pinmux for them, even if you did list them.

This could be interesting for the DT compliance checker. Ideally we
want it to warn if it finds a pinmux configuration in a PHY node.

It also sounds like you had them somewhere else wrong?

     Andrew

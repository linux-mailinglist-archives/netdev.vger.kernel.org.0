Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49AE51226E3
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfLQIo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:44:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56712 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfLQIo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 03:44:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lM97wh2yMUbIcDn5kzF0SHEiJXh+HNYHQbKcDQfi62M=; b=FniXI4tRdy0k0FLN9WIY2BpkQn
        y278yFM8/+GXlThcYKNcg5GtJIdTpg1IFj5IxtBIT9BZxTDahYF6xZTmZ2QoBZRyfXvEQA7HBW9wK
        HooSz8mnch7NIpu0xWd5zDWefDWJmYklI0S+i1pOgGsEbIS+sFd2bQ63hJp1k9Phm708=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ih8Si-00023F-RF; Tue, 17 Dec 2019 09:44:12 +0100
Date:   Tue, 17 Dec 2019 09:44:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jay Cliburn <jcliburn@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Burton <paul.burton@mips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        James Hogan <jhogan@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v4 2/5] dt-bindings: net: dsa: qca,ar9331 switch
 documentation
Message-ID: <20191217084412.GB6994@lunn.ch>
References: <20191022055743.6832-1-o.rempel@pengutronix.de>
 <20191022055743.6832-3-o.rempel@pengutronix.de>
 <20191023003543.GE5707@lunn.ch>
 <20191029073419.gjr4y7qsxx2javuf@pengutronix.de>
 <20191215145714.i22b5ndusnxo2rxy@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191215145714.i22b5ndusnxo2rxy@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I spend some tine on investigating and testing it. So, the result is
> pretty simple. It looks like *MII lines of ethernet controller GMAC0 and
> MAC of switch port5 are just connected together and wired to the PHY4.
> Something like this:
> 
> GMAC1-->switch--mac5-+--->phy4
>                      ^
> GMAC0---------------/
> 
> 
> So, both of MACs can be enabled at same time and introduce resource
> conflict. If one is enabled, other one should be set in to reset mode.
> 
> The questions are:
> - how this can be reflected in devicetree?
> - how this can be properly implemented in kernel?

That is, er, interesting.

So in device tree, i would use a phy-handle in GMAC1 or GMAC0 to point
to phy4. I don't think there is anything you can do in DT to prevent
both GMAC0 and GMAC1 having a phandle to phy4, other than adding a
comment in the binding. You could ask Rob if DT schema provides any
sorts of checks like this? But i doubt it.

In the driver, it would be good to check if two MACs try to connect to
one PHY. This in general should not happen, so maybe you can add a
check to the core, in phylib and/or phylink. Just watch out for
cpsw. It connects two PHYs to one MAC. Just don't make the assumption
one MAC and one PHY is correct, everything else is wrong.

    Andrew

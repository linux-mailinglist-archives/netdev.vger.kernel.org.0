Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA94228370
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 17:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgGUPTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 11:19:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47460 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgGUPTF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 11:19:05 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxu2b-006BeL-Vc; Tue, 21 Jul 2020 17:18:49 +0200
Date:   Tue, 21 Jul 2020 17:18:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Gregory Clement <gregory.clement@bootlin.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 3/3] phy: armada-38x: fix NETA lockup when repeatedly
 switching speeds
Message-ID: <20200721151849.GR1339445@lunn.ch>
References: <20200721143756.GT1605@shell.armlinux.org.uk>
 <E1jxtRj-0003Tz-CG@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jxtRj-0003Tz-CG@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 03:40:43PM +0100, Russell King wrote:
> The mvneta hardware appears to lock up in various random ways when
> repeatedly switching speeds between 1G and 2.5G, which involves
> reprogramming the COMPHY.  It is not entirely clear why this happens,
> but best guess is that reprogramming the COMPHY glitches mvneta clocks
> causing the hardware to fail.  It seems that rebooting resolves the
> failure, but not down/up cycling the interface alone.
> 
> Various other approaches have been tried, such as trying to cleanly
> power down the COMPHY and then take it back through the power up
> initialisation, but this does not seem to help.
> 
> It was finally noticed that u-boot's last step when configuring a
> COMPHY for "SGMII" mode was to poke at a register described as
> "GBE_CONFIGURATION_REG", which is undocumented in any external
> documentation.  All that we have is the fact that u-boot sets a bit
> corresponding to the "SGMII" lane at the end of COMPHY initialisation.
> 
> Experimentation shows that if we clear this bit prior to changing the
> speed, and then set it afterwards, mvneta does not suffer this problem
> on the SolidRun Clearfog when switching speeds between 1G and 2.5G.
> 
> This problem was found while script-testing phylink.
> 
> This fix also requires the corresponding change to DT to be effective.
> See "ARM: dts: armada-38x: fix NETA lockup when repeatedly switching
> speeds".
> 
> Fixes: 14dc100b4411 ("phy: armada38x: add common phy support")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

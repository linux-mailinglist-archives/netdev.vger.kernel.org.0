Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4556D2B31B6
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 02:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgKOBCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 20:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgKOBCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 20:02:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDACEC0613D1;
        Sat, 14 Nov 2020 17:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hcJd+0gBC4ggI1CJ0CF5JxBf9S+Caac0TAqY+TSKgv0=; b=ZPxrrpRJPPDkHjS0nl3X6rE8P
        fFPiB3zOcFSxA6I9SjqXFljBDIf/FmRnLiKFiL9DUA+WiuobM8Yz9GTeeE4dTYYqVJnNge2Cn0ASH
        6BIkB+Q1GixtdtI7BYmcgrb06o6h/w6vB+nf4nwjaoQev7NjQNBZn/54eYQWOj4NiujyVyKzAzf6g
        usI7aMl2QMEi/EFKL6tLxqAiNpjbiI2JnuoWJLCY0iEGKwvqpHPXZt+7uSrQpUjNr9eqSWyQeTZ4R
        fS756FQDhRrI5KgkL4Js32S7ulIJAzzxFmoG4CLVvPsomHQbYoSVfP+1mLr7/feVcoJtL6ymJge8E
        sjEYBlj2Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59784)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ke6RH-0006CO-F9; Sun, 15 Nov 2020 01:02:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ke6RF-0005v0-Lw; Sun, 15 Nov 2020 01:02:41 +0000
Date:   Sun, 15 Nov 2020 01:02:41 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        Michal Hrusecki <Michal.Hrusecky@nic.cz>,
        Tomas Hlavacek <tomas.hlavacek@nic.cz>,
        =?utf-8?B?QmVkxZlpY2hhIEtvxaFhdHU=?= <bedrich.kosata@nic.cz>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: mvneta: Fix validation of 2.5G HSGMII
 without comphy
Message-ID: <20201115010241.GF1551@shell.armlinux.org.uk>
References: <20201115004151.12899-1-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201115004151.12899-1-afaerber@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 01:41:51AM +0100, Andreas Färber wrote:
> Commit 1a642ca7f38992b086101fe204a1ae3c90ed8016 (net: ethernet: mvneta:
> Add 2500BaseX support for SoCs without comphy) added support for 2500BaseX.
> 
> In case a comphy is not provided, mvneta_validate()'s check
>   state->interface == PHY_INTERFACE_MODE_2500BASEX
> could never be true (it would've returned with empty bitmask before),
> so that 2500baseT_Full and 2500baseX_Full do net get added to the mask.

This makes me nervous. It was intentional that if there is no comphy
configured in DT for SoCs such as Armada 388, then there is no support
to switch between 1G and 2.5G speed. Unfortunately, the configuration
of the comphy is up to the board to do, not the SoC .dtsi, so we can't
rely on there being a comphy on Armada 388 systems.

So, one of the side effects of this patch is it incorrectly opens up
the possibility of allowing 2.5G support on Armada 388 without a comphy
configured.

We really need a better way to solve this; just relying on the lack of
comphy and poking at a register that has no effect on Armada 388 to
select 2.5G speed while allowing 1G and 2.5G to be arbitarily chosen
doesn't sound like a good idea to me.

Clearly there are differences in mvneta hardware in different SoCs.
Maybe they should have used different compatibles, so the driver can
know which variant of the hardware it is dealing with, rather than
relying on presence/lack of comphy.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

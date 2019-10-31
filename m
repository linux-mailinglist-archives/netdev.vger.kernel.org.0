Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7AD9EB0EF
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 14:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfJaNOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 09:14:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43426 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbfJaNOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 09:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fP9y1MyobR9LBQS3/+/u5S3jxf/euej87CPQY3fQ98M=; b=2GW6IDfx8WHRmwC44L+6j5EMbd
        Hd+WelbrNRp+h6HiJ49DSvvtL2JKTWtKaKCrHom4vsAE0+LHxkn2SD33wIDjFsmMSbheoD/B3cRiy
        pKuqpWqMrp96Py6W18Sf2oZ099zC4D6CZkqMsLF5AgLu57se2325srz0XD9HprZPhKvw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iQAH6-0000TM-F3; Thu, 31 Oct 2019 14:14:04 +0100
Date:   Thu, 31 Oct 2019 14:14:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Priit Laes <plaes@plaes.org>
Cc:     linux-sunxi@googlegroups.com, wens@csie.org,
        netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com
Subject: Re: sun7i-dwmac: link detection failure with 1000Mbit parters
Message-ID: <20191031131404.GK10555@lunn.ch>
References: <20191030202117.GA29022@plaes.org>
 <20191031130422.GJ10555@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031130422.GJ10555@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 02:04:22PM +0100, Andrew Lunn wrote:
> On Wed, Oct 30, 2019 at 08:21:17PM +0000, Priit Laes wrote:
> > Heya!
> > 
> > I have noticed that with sun7i-dwmac driver (OLinuxino Lime2 eMMC), link
> > detection fails consistently with certain 1000Mbit partners (for example Huawei
> > B525s-23a 4g modem ethernet outputs and RTL8153-based USB3.0 ethernet dongle),
> > but the same hardware works properly with certain other link partners (100Mbit GL AR150
> > for example).
> 
> Hi Pritt
> 
> What PHY is used? And what happens if you use the specific PHY driver,
> not the generic PHY driver?

Schematics of the board are here:

https://github.com/OLIMEX/OLINUXINO/blob/master/HARDWARE/A20-OLinuXino-LIME2/1.%20Latest%20hardware%20revision/A20-OLinuXino-Lime2_Rev_K2_COLOR.pdf

So it has a KSZ9031. The micrel driver supports that device. And there
is a patch which might be relevant:

ommit 3aed3e2a143c9619f4c8d0a3b8fe74d7d3d79c93
Author: Antoine Tenart <antoine.tenart@bootlin.com>
Date:   Tue Apr 16 12:10:20 2019 +0200

    net: phy: micrel: add Asym Pause workaround
    
    The Micrel KSZ9031 PHY may fail to establish a link when the Asymmetric
    Pause capability is set. This issue is described in a Silicon Errata
    (DS80000691D or DS80000692D), which advises to always disable the
    capability. This patch implements the workaround by defining a KSZ9031
    specific get_feature callback to force the Asymmetric Pause capability
    bit to be cleared.
    
    This fixes issues where the link would not come up at boot time, or when
    the Asym Pause bit was set later on.
    
    Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
    Reviewed-by: Andrew Lunn <andrew@lunn.ch>
    Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>


Please test using the Micrel PHY driver and see if that solves your
problem.

	Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF541F1CF3
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 18:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgFHQIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 12:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730357AbgFHQIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 12:08:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB631C08C5C2;
        Mon,  8 Jun 2020 09:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7VoRl6qQlPxAENq4swBjnhUVEexaLc0WppnAtA1JmcY=; b=0WRHvJzJToSgd8Xjgr1TW5lNh
        f6sbLcPfQYlR930Di+98noAUh6OtZQe7W6tdF6mQgk3nI3Of8xrxCVr8ots3PjNSAuSaGxDPlB5+a
        UZ3dzCTg/NReHWAwOA/J1G49dKJtwWy8u0XbEGN/XncsysEekP+B5WOP0+96wJ2SmnwIWBov2+QLY
        PeEfH4tSH0f4AZfr8n16AhQaXDXP/8lpYc4QjE+MpNYTG5fygyCk4ISApJJ/VXtWutflbFMcbPhoB
        WYDkjXyaopMoJI+WASx25CpQynsHz75ghL4IRBZmFlCn/uV1SkeUnMCGTxjsge7bQRG4NsdRY9ZhC
        dOQyVdQhQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:51000)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jiKJf-0000c8-OJ; Mon, 08 Jun 2020 17:08:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jiKJd-0002CW-W7; Mon, 08 Jun 2020 17:08:02 +0100
Date:   Mon, 8 Jun 2020 17:08:01 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: ethernet: mvneta: add support for 2.5G DRSGMII mode
Message-ID: <20200608160801.GO1551@shell.armlinux.org.uk>
References: <20200608074716.9975-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608074716.9975-1-s.hauer@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 09:47:16AM +0200, Sascha Hauer wrote:
> The Marvell MVNETA Ethernet controller supports a 2.5 Gbps SGMII mode
> called DRSGMII.
> 
> This patch adds a corresponding phy-mode string 'drsgmii' and parses it
> from DT. The MVNETA then configures the SERDES protocol value
> accordingly.
> 
> It was successfully tested on a MV78460 connected to a FPGA.

Digging around, this is Armada XP?  Which SoCs is this mode supported?
There's no mention of DRSGMII in the A38x nor A37xx documentation which
are later than Armada XP.

What exactly is "drsgmii"?  It can't be "double-rate" SGMII because that
would give you 2Gbps max instead of the 1Gbps, but this gives 2.5Gbps,
so I'm really not sure using "drsgmii" is a good idea.  It may be what
Marvell call it, but we really need to know if there's some vendor
neutral way to refer to it.

> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  .../devicetree/bindings/net/ethernet-controller.yaml       | 1 +
>  drivers/net/ethernet/marvell/mvneta.c                      | 7 ++++++-
>  include/linux/phy.h                                        | 3 +++
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> This patch has already been sent 3 years ago here:
> https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20170123142206.5390-1-jlu@pengutronix.de/
> Since then the driver has evolved a lot. 2.5Gbps is properly configured in the
> MAC now.

Nevertheless, adding a new interface mode needs properly documenting to
describe exactly what it is - see Documentation/networking/phy.rst, the
section "PHY interface modes".  The above point about "what is this"
illustrates why we need these documented.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up

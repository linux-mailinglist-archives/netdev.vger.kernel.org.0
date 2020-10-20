Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E7C2943F9
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 22:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438555AbgJTUjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 16:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438551AbgJTUjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 16:39:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BC7C0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 13:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fuxxsrciUIzMSzPVxiGoV35E3p/hSz0E14CFYpg5NRg=; b=Gm3eQMR3uFnJlyjlzXhYbCsLJ
        jTxLleOTcAaGM8DSLlG16Oue43EJg9LEiu3jN1K4hrk9nAk72Y9Crf0gRAm9WBD1LomAjC6esD8Xc
        XGORNMw1HlGWOxC9IBWioia0QcBdiJxUWOAzWzZhMQjqvza1IsL/lPedsYyT0n0C+OwUkr3ow1eio
        5FQVtkgJfHKO9P1pzNwjxjXl08H4AU/FIHBWzmD0dCOhYWOqP0Z4aVyQWNFegYktekGwutPcYZlVW
        YIvp/nRSTIEUNLL4yV12uuPzfqGwmPRbLNiwuxiNhcKM++xBc0DQuNWaFAIfFtRTs+9aP/ll37WFw
        wL2wTeAEg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48804)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kUyQ7-0007xa-0L; Tue, 20 Oct 2020 21:39:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kUyQ3-0005ay-7X; Tue, 20 Oct 2020 21:39:43 +0100
Date:   Tue, 20 Oct 2020 21:39:43 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: add special handling of Finisar
 modules with 88E1111
Message-ID: <20201020203943.GF1551@shell.armlinux.org.uk>
References: <20201020191048.756652-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020191048.756652-1-robert.hancock@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 01:10:48PM -0600, Robert Hancock wrote:
> The Finisar FCLF8520P2BTL 1000BaseT SFP module uses a Marvel 88E1111 PHY
> with a modified PHY ID. Add support for this ID using the 88E1111
> methods.
> 
> By default these modules do not have 1000BaseX auto-negotiation enabled,
> which is not generally desirable with Linux networking drivers. Add
> handling to enable 1000BaseX auto-negotiation when these modules are
> used in 1000BaseX mode. Also, some special handling is required to ensure
> that 1000BaseT auto-negotiation is enabled properly when desired.
> 
> Based on existing handling in the AMD xgbe driver and the information in
> the Finisar FAQ:
> https://www.finisar.com/sites/default/files/resources/an-2036_1000base-t_sfp_faqreve1.pdf

Just one further point...

> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/phy/marvell.c   | 99 ++++++++++++++++++++++++++++++++++++-
>  include/linux/marvell_phy.h |  3 ++
>  2 files changed, 101 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 5aec673a0120..49392d15035c 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -80,8 +80,11 @@
>  #define MII_M1111_HWCFG_MODE_FIBER_RGMII	0x3
>  #define MII_M1111_HWCFG_MODE_SGMII_NO_CLK	0x4
>  #define MII_M1111_HWCFG_MODE_RTBI		0x7
> +#define MII_M1111_HWCFG_MODE_COPPER_1000BX_AN	0x8

I would suggest using MII_M1111_HWCFG_MODE_COPPER_1000X_AN, as there
is a 1000BASE-BX.

>  #define MII_M1111_HWCFG_MODE_COPPER_RTBI	0x9
>  #define MII_M1111_HWCFG_MODE_COPPER_RGMII	0xb
> +#define MII_M1111_HWCFG_MODE_COPPER_1000BX_NOAN 0xc

Same here.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

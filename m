Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644A329731C
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 18:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751252AbgJWQEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 12:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbgJWQEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 12:04:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B898DC0613CE;
        Fri, 23 Oct 2020 09:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nP204JPHYv2lIktmHXLyNM4CJDtb90Rek/v0k/seczY=; b=Wv2auy9VPeruERNhrxtO42vdU
        tMZX0QoIE/1/ZwcTyl8tPa9eoAyFfidy1ziHc8h/w7UenJB126YTZUPTllqJNdfH7jcplWt3JYSEJ
        xdMVz3Emrz4AG1of3Xd3QGb2FTdDJcn/jSgtzsjV3KT7Ec/eKV4+K6tQ/bSWcdHjutNBLrlytJ82c
        wdC5zLUb0U8OH7eGJ555wHaGba0VWCnzISROS75h+8sxdcG1sSnHYJ1tm9fvm0P1PKFKCSjb38CBh
        nrCars6iaVDGpJMNt8hbeUBiwxQrdSUJO7tGzlABHLPzNa58YIVELfHMfeIC4msrXIagJQcA5YX84
        M5hL1yhmA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50034)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kVzXr-0003ez-A0; Fri, 23 Oct 2020 17:03:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kVzXn-00007r-B6; Fri, 23 Oct 2020 17:03:55 +0100
Date:   Fri, 23 Oct 2020 17:03:55 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     andrew@lunn.ch, nicolas.ferre@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, inux-kernel@vger.kernel.org,
        mparab@cadence.com
Subject: Re: [PATCH v4] net: macb: add support for high speed interface
Message-ID: <20201023160355.GF1551@shell.armlinux.org.uk>
References: <1603467547-27604-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603467547-27604-1-git-send-email-pthombar@cadence.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 05:39:07PM +0200, Parshuram Thombare wrote:
> This patch adds support for 10GBASE-R interface to the linux driver for
> Cadence's ethernet controller.
> This controller has separate MAC's and PCS'es for low and high speed paths.
> High speed PCS supports 100M, 1G, 2.5G, 5G and 10G through rate adaptation
> implementation. However, since it doesn't support auto negotiation, linux
> driver is modified to support 10GBASE-R instead of USXGMII. 
> 
> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>

Thanks, this mostly looks good - only one comment.

> @@ -588,6 +670,13 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
>  	if (old_ctrl ^ ctrl)
>  		macb_or_gem_writel(bp, NCFGR, ctrl);
>  
> +	if (bp->phy_interface == PHY_INTERFACE_MODE_10GBASER) {
> +		gem_writel(bp, NCFGR, GEM_BIT(PCSSEL) |
> +			   (gem_readl(bp, NCFGR) & ~GEM_BIT(SGMIIEN)));
> +		gem_writel(bp, NCR, gem_readl(bp, NCR) |
> +			   GEM_BIT(ENABLE_HS_MAC));
> +	}

If we configure 10GBASE-R, then you clear the SGMIIEN bit and then
enable the HS MAC. Can we go back to non-10GBASE-R after that? Should
the code reverse those actions here?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

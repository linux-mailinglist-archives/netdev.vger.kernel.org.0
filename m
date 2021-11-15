Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14080451641
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345553AbhKOVRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350418AbhKOUXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:23:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5E7C079780
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rO40oQ3O9yVpjfN38ey7A4JW/711UQ4OKFfu46UmQ6Y=; b=iGSzQ0Uys9TL1OCJO6bs7LFel3
        OpPr9a7+qHjDvg/HwqqQrVCvOkqTxkVh0Xiu869gLaJa8/53mwrAEzeYSBzKrpmoI4TKTNcA94bSK
        chzc/38j1ZjOnhUzRdIdossVIALnGQfA2t9Qn6JoV6UhO7f1nrAfByywsoGrUDBQdk287OH/d5MyM
        dKtzMYPWNgLdY2H82TEHCp6IlueJ+Za0XTt62Xjz92gQp2R2HCK/l+9wQL7zQvgKGm262hUQKqQND
        iYKKjfnQl9NjgfjitwPNl/mZ3H5OxPGr7426nvIoLd+nQjB0UlmpdtcbCOlaW7onOV45dcE8EzhRT
        tOfbH5wQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55640)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mmiJc-00086U-LB; Mon, 15 Nov 2021 20:10:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mmiJa-0001Iu-MV; Mon, 15 Nov 2021 20:10:54 +0000
Date:   Mon, 15 Nov 2021 20:10:54 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phylink: add generic validate
 implementation
Message-ID: <YZK+zvONUjtWe0HA@shell.armlinux.org.uk>
References: <YZIvnerLwnMkxx3p@shell.armlinux.org.uk>
 <E1mmYmp-006nOe-Gs@rmk-PC.armlinux.org.uk>
 <YZK6863Q8m5RgY9D@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZK6863Q8m5RgY9D@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 08:54:27PM +0100, Andrew Lunn wrote:
> Hi Russell
> 
> > +	case PHY_INTERFACE_MODE_TBI:
> > +	case PHY_INTERFACE_MODE_MOCA:
> > +	case PHY_INTERFACE_MODE_RTBI:
> 
> For some reason, i think one of these can do 2.5G. But i cannot
> remember where i have seen this. Maybe b53?

I asked Florian about MoCA, who said "1G, and then the MoCA Ethernet
adaptation layer will do what it can" - I did trip over some
information that suggests that could do 2.5G.

However, none of the drivers I've converted make use of these, so if
these interface modes need other speeds added, it won't be a problem
just yet and can be addressed later.

I haven't addressed DSA yet - DSA drivers don't have the same signature
for their validate() implementations, so it is harder to have a generic
implementation there without more wrapping. It would also need changing
the phylink_get_interfaces method introduced last time around since DSA
drivers need to set both the supported_interfaces and mac_capabilities
members in phylink_config. So this rules out b53 conversion for the
moment, but it would be really nice to also have DSA drivers converted.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

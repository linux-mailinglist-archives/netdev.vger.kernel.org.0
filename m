Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D41A2AD9DF
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731147AbgKJPNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732437AbgKJPNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 10:13:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CD9C0613CF;
        Tue, 10 Nov 2020 07:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TgTFgxJfzLUks9m+Ot71tdDMXIEqIRGy/HpQQYEbMkU=; b=dcP6Yw+XlJ3bRAR4nQbgPDXzF
        3wy6uK7qbXMfoSgowUgfBDuSkQwTLSH1cv63nRWPz7gTMTvl6jd/z2QsijKqrDTp5b4ue63Lr5/oz
        RD4dBzFOr7kThWXavU/0A2NplwIuWlvnPO9wTbS5QzUaYHw6dIVFtm4FHo9A8pmyuNn5plcQjH/Nc
        DGjvgoVesscn8gKOQbXxxlfGBjHPnV21FDI7csl82OpXZ9FhWnvqOyr66UWy7vgYtsBlPi+Z5Hb3t
        pvX7Xc9f7YmTvVbSzaxmjcLVMum2vc3ym2kd4wGt5JasXnGSzkaCJc8Y5AX7tZtFEXa3vTgUEQoGH
        tay2drG9w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57982)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kcVKE-0001EE-1v; Tue, 10 Nov 2020 15:12:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kcVKC-0001Y1-9R; Tue, 10 Nov 2020 15:12:48 +0000
Date:   Tue, 10 Nov 2020 15:12:48 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH] phy: phylink: Fix CuSFP issue in phylink
Message-ID: <20201110151248.GA1551@shell.armlinux.org.uk>
References: <20201110100642.2153-1-bjarni.jonasson@microchip.com>
 <20201110102552.GZ1551@shell.armlinux.org.uk>
 <87blg5qou5.fsf@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blg5qou5.fsf@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 03:16:34PM +0100, Bjarni Jonasson wrote:
> 
> Russell King - ARM Linux admin writes:
> 
> > On Tue, Nov 10, 2020 at 11:06:42AM +0100, Bjarni Jonasson wrote:
> >> There is an issue with the current phylink driver and CuSFPs which
> >> results in a callback to the phylink validate function without any
> >> advertisement capabilities.  The workaround (in this changeset)
> >> is to assign capabilities if a 1000baseT SFP is identified.
> >
> > How does this happen?  Which PHY is being used?
> 
> This occurs just by plugging in the CuSFP.
> None of the CuSFPs we have tested are working.
> This is a dump from 3 different CuSFPs, phy regs 0-3:
> FS SFP: 01:40:79:49 
> HP SFP: 01:40:01:49
> Marvel SFP: 01:40:01:49
> This was working before the delayed mac config was implemented (in dec
> 2019).

You're dumping PHY registers 0 and 1 there, not 0 through 3, which
the values confirm. I don't recognise the format either. PHY registers
are always 16-bit.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

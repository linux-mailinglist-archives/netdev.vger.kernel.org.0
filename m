Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B810455878
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245419AbhKRKCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 05:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245401AbhKRKCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 05:02:25 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A418C061764;
        Thu, 18 Nov 2021 01:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XSzI0hxUCG6rROg2YuT5S/lnEZyhlyFPWKDzxXoo5Dk=; b=qbeKC7UBBqkkXKRHyxe1GUqcVm
        vhWgOhMX91jnQMHprsWDlgmaFTv9OuRoZmlD0uQClmTf2GSLFcVN42NZXOiGCncw6bea2lM3x0M45
        8oUtugUbryc3DWQw1w8LiwHIRUDnFkN2eg6Z+nOr2+NAjr4IWZWa6i+C9E5Lqz+5V/Md+6kv0y5bW
        vB1zVpYIul781eK3YkpXx3J+ZrRedtxKow++omRFEe3iSdzoyqmBkO/AF2PJcrFz9qk68aOgOZ2/Z
        oMjnSJX4evdefMDm0RfoWlpBMi9F9SE7Xy8+gRBOfulYTOmLtR5Qz0jJ9T5ciVrjK/iWo0Tp8Hs6g
        iXsT6+XQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55708)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mneCN-0002mO-CP; Thu, 18 Nov 2021 09:59:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mneCL-0003pb-Hy; Thu, 18 Nov 2021 09:59:17 +0000
Date:   Thu, 18 Nov 2021 09:59:17 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        p.zabel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] net: lan966x: add port module support
Message-ID: <YZYj9fwCeWdIZJOt@shell.armlinux.org.uk>
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
 <20211117091858.1971414-4-horatiu.vultur@microchip.com>
 <YZTRUfvPPu5qf7mE@shell.armlinux.org.uk>
 <20211118095703.owsb2nen5hb5vjz2@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118095703.owsb2nen5hb5vjz2@soft-dev3-1.localhost>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 10:57:03AM +0100, Horatiu Vultur wrote:
> > > +static void decode_sgmii_word(u16 lp_abil, struct lan966x_port_status *status)
> > > +{
> > > +     status->an_complete = true;
> > > +     if (!(lp_abil & LPA_SGMII_LINK)) {
> > > +             status->link = false;
> > > +             return;
> > > +     }
> > > +
> > > +     switch (lp_abil & LPA_SGMII_SPD_MASK) {
> > > +     case LPA_SGMII_10:
> > > +             status->speed = SPEED_10;
> > > +             break;
> > > +     case LPA_SGMII_100:
> > > +             status->speed = SPEED_100;
> > > +             break;
> > > +     case LPA_SGMII_1000:
> > > +             status->speed = SPEED_1000;
> > > +             break;
> > > +     default:
> > > +             status->link = false;
> > > +             return;
> > > +     }
> > > +     if (lp_abil & LPA_SGMII_FULL_DUPLEX)
> > > +             status->duplex = DUPLEX_FULL;
> > > +     else
> > > +             status->duplex = DUPLEX_HALF;
> > > +}
> > 
> > The above mentioned function will also handle SGMII as well.
> 
> I noticed that you have phylink_decode_sgmii_work(), so I will try to
> export it also.

Another approach would be to split phylink_mii_c22_pcs_decode_state()
so that the appropriate decode function is selected depending on the
interface state, which may be a better idea.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

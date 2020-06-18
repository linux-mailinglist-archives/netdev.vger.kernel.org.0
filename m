Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073BF1FFB4B
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 20:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgFRStU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 14:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727788AbgFRStU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 14:49:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C36C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 11:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=D3pYGlGjSTkPxKPFPv8KdtyiRKYJMJKHaNYlKitb2kQ=; b=i3ajUSrukFA/d5E1ICPdoj4WC
        +e/XIuCqcsS7YvOfIzs1WNX+ntrQX12c5rBFEcErGReTvpl+8jSZxfDlGAfVl8jxUHAC/+0e1vj7i
        IxuHAWCSSoPwDS1HhT3hCYwE/5rAGVcEPHuMLPqtmMwWi6MlslOfUfTFLS19lk1y9Kdh1rnCUUmty
        Dhdsq/qREoECf2D4jmw9qyiNtfKuEq0bMt5PO44Mea1MSj/sJky0PwNwdPxwaV81sThzgyXWCcf5T
        uZEEPxaaZOH8CEmw4A6BA+r5qO5MAxt/7rDFk+fkHXFvz8y79cpCaMgWuMeIis2EZXly3mKQRWUtQ
        RwL02+Usg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58800)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlzb6-0005Wg-Pi; Thu, 18 Jun 2020 19:49:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlzb2-0004vu-UA; Thu, 18 Jun 2020 19:49:08 +0100
Date:   Thu, 18 Jun 2020 19:49:08 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Helmut Grohne <helmut.grohne@intenta.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200618184908.GH1551@shell.armlinux.org.uk>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
 <20200617112153.GB28783@laureti-dev>
 <20200617114025.GQ1551@shell.armlinux.org.uk>
 <20200617115201.GA30172@laureti-dev>
 <20200617120809.GS1551@shell.armlinux.org.uk>
 <20200618081433.GA22636@laureti-dev>
 <20200618084554.GY1551@shell.armlinux.org.uk>
 <91866c2b-77ea-c175-d672-a9ca937835bd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91866c2b-77ea-c175-d672-a9ca937835bd@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 11:06:43AM -0700, Florian Fainelli wrote:
> 
> 
> On 6/18/2020 1:45 AM, Russell King - ARM Linux admin wrote:
> > On Thu, Jun 18, 2020 at 10:14:33AM +0200, Helmut Grohne wrote:
> >> On Wed, Jun 17, 2020 at 02:08:09PM +0200, Russell King - ARM Linux admin wrote:
> >>> With a fixed link, we could be in either a MAC-to-PHY or MAC-to-MAC
> >>> setup; we just don't know.  However, we don't have is access to the
> >>> PHY (if it exists) in the fixed link case to configure it for the
> >>> delay.
> >>
> >> Let me twist that a little: We may have access to the PHY, but we don't
> >> always have access. When we do have access, we have a separate device
> >> tree node with another fixed-link and another phy-mode. For fixed-links,
> >> we specify the phy-mode for each end.
> > 
> > If you have access to the PHY, you shouldn't be using fixed-link. In
> > any case, there is no support for a fixed-link specification at the
> > PHY end in the kernel.  The PHY binding doc does not allow for this
> > either.
> > 
> >>> In the MAC-to-MAC RGMII setup, where neither MAC can insert the
> >>> necessary delay, the only way to have a RGMII conformant link is to
> >>> have the PCB traces induce the necessary delay. That errs towards
> >>> PHY_INTERFACE_MODE_RGMII for this case.
> >>
> >> Yes.
> >>
> >>> However, considering the MAC-to-PHY RGMII fixed link case, where the
> >>> PHY may not be accessible, and may be configured with the necessary
> >>> delay, should that case also use PHY_INTERFACE_MODE_RGMII - clearly
> >>> that would be as wrong as using PHY_INTERFACE_MODE_RGMII_ID would
> >>> be for the MAC-to-MAC RGMII with PCB-delays case.
> >>
> >> If you take into account that the PHY has a separate node with phy-mode
> >> being rgmii-id, it makes a lot more sense to use rgmii for the phy-mode
> >> of the MAC. So I don't think it is that clear that doing so is wrong.
> > 
> > The PHY binding document does not allow for this, neither does the
> > kernel.
> > 
> >> In an earlier discussion Florian Fainelli said:
> >> https://patchwork.ozlabs.org/project/netdev/patch/20190410005700.31582-19-olteanv@gmail.com/#2149183
> >> | fixed-link really should denote a MAC to MAC connection so if you have
> >> | "rgmii-id" on one side, you would expect "rgmii" on the other side
> >> | (unless PCB traces account for delays, grrr).
> >>
> >> For these reasons, I still think that rgmii would be a useful
> >> description for the fixed-link to PHY connection where the PHY adds the
> >> delay.
> > 
> > I think Florian is wrong; consider what it means when you have a
> > fixed-link connection between a MAC and an inaccessible PHY and
> > the link as a whole is operating in what we would call "rgmii-id"
> > mode if the PHY were accessible.
> > 
> > Taking Florian's stance, it basically means that DT no longer
> > describes the hardware, but how we have chosen to interpret the
> > properties in _one_ specific case in a completely different way
> > to all the other cases.
> 
> How do you ensure that a MAC to MAC connection using RGMII actually
> works if you do not provide a 'phy-mode' for both sides right now?
> 
> Yes this is more of a DT now describes a configuration choice rather
> than the hardware but given that Ethernet MACs are usually capable of
> supporting all 4 possible RGMII modes, how do you propose to solve the
> negotiation of the appropriate RGMII mode here?

This is actually answered by yourself below.

> >>> So, I think a MAC driver should not care about the specific RGMII
> >>> mode being asked for in any case, and just accept them all.
> >>
> >> I would like to agree to this. However, the implication is that when you
> >> get your delays wrong, your driver silently ignores you and you never
> >> notice your mistake until you see no traffic passing and wonder why.
> > 
> > So explain to me this aspect of your reasoning:
> > 
> > - If the link is operating in non-fixed-link mode, the rgmii* PHY modes
> >   describe the delay to be applied at the PHY end.
> > - If the link is operating in fixed-link mode, the rgmii* PHY modes
> >   describe the delay to be applied at the MAC end.
> > 
> > That doesn't make sense, and excludes properly describing a MAC-to-
> > inaccessible-PHY setup.
> 
> The point with a fixed link is that it does not matter what is the other
> end, it could be a MAC, it could be a PHY, it could go nowhere, it just
> does not matter, the only thing that you can know is you configure your
> side of the fixed link.

That is *exactly* my point.

Today, with a PHY on the other end, the four RGMII modes tell you how
the PHY is to be configured, not the MAC.  The documentation states
this.

So, why should a fixed-link be any different?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

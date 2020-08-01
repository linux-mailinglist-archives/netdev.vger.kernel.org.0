Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B742352E8
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 17:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgHAPLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 11:11:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38248 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgHAPLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 11:11:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k1tAB-007oRo-SY; Sat, 01 Aug 2020 17:11:07 +0200
Date:   Sat, 1 Aug 2020 17:11:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vikas Singh <vikas.singh@puresoftware.com>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Kuldip Dwivedi <kuldip.dwivedi@puresoftware.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Vikas Singh <vikas.singh@nxp.com>
Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Message-ID: <20200801151107.GK1712415@lunn.ch>
References: <1595938400-13279-1-git-send-email-vikas.singh@puresoftware.com>
 <1595938400-13279-3-git-send-email-vikas.singh@puresoftware.com>
 <20200728130001.GB1712415@lunn.ch>
 <CADvVLtXVVfU3-U8DYPtDnvGoEK2TOXhpuE=1vz6nnXaFBA8pNA@mail.gmail.com>
 <20200731153119.GJ1712415@lunn.ch>
 <CADvVLtUrZDGqwEPO_ApCWK1dELkUEjrH47s1CbYEYOH9XgZMRg@mail.gmail.com>
 <20200801094132.GH1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801094132.GH1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 01, 2020 at 10:41:32AM +0100, Russell King - ARM Linux admin wrote:
> On Sat, Aug 01, 2020 at 09:52:52AM +0530, Vikas Singh wrote:
> > Hi Andrew,
> > 
> > Please refer to the "fman" node under
> > linux/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> > I have two 10G ethernet interfaces out of which one is of fixed-link.
> 
> Please do not top post.
> 
> How does XGMII (which is a 10G only interface) work at 1G speed?  Is
> what is in DT itself a hack because fixed-phy doesn't support 10G
> modes?

My gut feeling is there is some hack going on here, which is why i'm
being persistent at trying to understand what is actually going on
here.

So Vikas, as Russell pointed out, fixed-link is limited to 1G. It
seems odd you are running a 10G link at 1G. It is also unclear what
you have on the other end of that fixed link? Is it an SFP and you are
afraid of the work needed to get phylink working with ACPI? Is it an
Ethernet switch, and you are afraid of the work needed to get DSA
working with ACPI?

Looking at
https://www.nxp.com/docs/en/quick-reference-guide/LS1046AQRS.pdf

I see a XFI/2-5G SGMII port connected to a PHY, which i guess is

       ethernet@f0000 { /* 10GEC1 */
                phy-handle = <&aqr106_phy>;
                phy-connection-type = "xgmii";
        };

and
                aqr106_phy: ethernet-phy@0 {
                        compatible = "ethernet-phy-ieee802.3-c45";
                        interrupts = <0 131 4>;
                        reg = <0x0>;
                };

Which leaves an XFI interface connected to a retimer and then to an
SFP cage? Is this where you are using fixed-link?

	Andrew

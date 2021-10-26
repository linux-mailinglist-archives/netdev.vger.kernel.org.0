Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BFB43B993
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 20:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238301AbhJZSao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 14:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238297AbhJZSao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 14:30:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C90C061767
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 11:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OgmzkZRSnKunikB0quMEklFj//K7ytKANQPkXEF+CTU=; b=isdjWn+kop/o1bBPGQUHM01JwJ
        F+vp/VuONMyrFMRs6+YBtsWUxuhZT3ucqvVDgvKrDGy1kbiknFZqQkwthlR36gRTWpJ3yGjKW7IPf
        UQYAb89w6sl4LjcSxlBQnY15AyswOkKGSiDPj+I+K6r6loAMpihG+Jrugm+ty8UC2hWoV8K2reCpu
        3iflC3x32JqP+ejuV05VSYi5dkTsinGUJqAO7O5tt/8F2Eevn7wBEZselg2NpwABk2gnLNg25gDau
        ks/Zt//sl9wimkSFHhbph2RD0banMYdkGOS7Pd7BHRmBRWoiRcxVsbhsEkvTGgkrbTVvZsHBmZBXI
        GhfZk5DA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55326)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mfRBI-0005fT-Az; Tue, 26 Oct 2021 19:28:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mfRBF-0006yC-G0; Tue, 26 Oct 2021 19:28:13 +0100
Date:   Tue, 26 Oct 2021 19:28:13 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
Message-ID: <YXhIvQiTTiHrmrBm@shell.armlinux.org.uk>
References: <20211025172405.211164-1-sean.anderson@seco.com>
 <YXcfRciQWl9t3E5Y@shell.armlinux.org.uk>
 <5e946ab6-94fe-e760-c64b-5abaf8ac9068@seco.com>
 <a0c6edd9-3057-45cf-ef2d-6d54a201c9b2@microchip.com>
 <YXg1F7cGOEjd2a+c@shell.armlinux.org.uk>
 <61d9f92e-78d8-5d14-50d1-1ed886ec0e17@seco.com>
 <YXg/DP2d1UM831+c@shell.armlinux.org.uk>
 <b911cfcc-1c6f-1092-3803-6a57f785bde1@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b911cfcc-1c6f-1092-3803-6a57f785bde1@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 01:49:03PM -0400, Sean Anderson wrote:
> On 10/26/21 1:46 PM, Russell King (Oracle) wrote:
> > On Tue, Oct 26, 2021 at 01:28:15PM -0400, Sean Anderson wrote:
> > > Actually, according to the Zynq UltraScale+ Devices Register Reference
> > > [1], the PCS does not support 10/100. So should SGMII even fall through
> > > here?
> > > 
> > > [1] https://www.xilinx.com/html_docs/registers/ug1087/gem___pcs_control.html
> > 
> > Hmm. That brings with it fundamental question: if the PCS supports 1G
> > only, does it _actually_ support Cisco SGMII, or does it only support
> > 1000base-X?
> > 
> 
> Of course, in the technical reference manual [1], they say
> 
> > The line rate is 1 Gb/s as SGMII hardwired to function at 1 Gb/s only.
> > However, the data transfer rate can be forced down to 100 Mb/s or 10
> > Mb/s if the link partner is not capable.
> 
> which sounds like the normal byte-repetition of SGMII...
> 
> And they also talk about how the autonegotiation timeout and control words are different.

This document looks a little comical. "GEM supports the serial gigabit
media-independent interface (SGMII, 1000BASE-SX and 1000BASE-LX) at
1000 Gb/s using the PS-GTR interface."

So:
a) it supports terabyte speeds?
b) it provides an optical connection direct from the SoC?
   (the L and S in 1000BASE-X refer to the laser wavelength!)

They really should just be saying "1000BASE-X" rather than specifying
an optical standard, but lets ignore that fundamental mistake for now.

In the section "SGMII, 1000BASE-SX, or 1000BASE-LX" it says:

"When bit [27] (SGMII mode) in the network configuration register
(GEM(0:3).network_config[sgmii_mode_enable]) is set, it changes the
behavior of the auto-negotiation advertisement and link partner ability
registers to meet the requirements of SGMII. Additionally, the time
duration of the link timer is reduced from 10ms to 1.6ms."

That bodes well for Cisco SGMII support, but it says nothing about how
that affects the PCS registers themselves.

As you say above, it goes on to say:

"The line rate is 1 Gb/s as SGMII hardwired to function at 1 GB/s
only."

That statement is confused. Cisco SGMII and 1000Base-X actually operate
at 1.25Gbaud line rate due to the 4B5B encoding on the Serdes. However,
the underlying data rate is 1Gbps, with 100 and 10Mbps achieved by
symbol replication of only the data portions of the packet transfer.
This replication does not, however, apply to non-data symbols though.

I suppose they _could_ have implemented Cisco SGMII by having the PCS
fixed in 1G mode, and then replicate the data prior to the PCS. That
would be rather peculiar though, and I'm not sure whether that could
work for the non-data symbols. I suppose it depends whether they just
slow down the transmission rate into the PCS, or do only data portion
replication before the PCS.


I've also just found the register listing in HTML form (so less
searchable than a PDF), and the PCS register listing only shows
1000base-X layout for the advertisement and link partner registers.
It seems to make no mention of "SGMII" mode.

So we have an open question: do 10 and 100M speeds actually work on
GEM, and if they do, how does one program it to operate at these
speeds. Currently, the driver seems to change bits in NCFGR to change
speed, and also reconfigure the transmit clock rate.

Going back to the first point I mentioned above, how much should we
take from these documents as actually being correct? Should we not
assume anything, but instead just experiment with the hardware and
see what works.

For example, are the two speed bits in the PCS control register
really read-only when in Cisco SGMII mode, or can they be changed -
and if they can be changed, does that have an effect on the ethernet
link?

Hmm, this seems to have uncovered more questions...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

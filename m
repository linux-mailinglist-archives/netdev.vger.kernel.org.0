Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA4711295D5
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 13:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLWMHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 07:07:40 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40054 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfLWMHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 07:07:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=F4tsb7PW4zFpLC7EOtPGBjzINEMkMbZx84q7LYNGooU=; b=yH6GtR7yflOVtImr6967Co3ay
        d/XaiswbaRJM3OuRqi0NE9HKd8IsJ52tPrIY7E2O4ue3anmycFXy/SGKOk/Ql59kNTV6toiEE6zIm
        a3AyfVRXR/PSM4J6Nk4/cXpNmMiGVu1XLi4gPOYtiIKgDAXRXlQjPGPryqK5EYIUVA84LWkxI2ZbH
        4R1bG7dwh562RIRwjx0PQ04Ut6aDiZK/KByd8pvPqOW7KTMA56JtlIxTaMZLHrw5vYSBtAmp1PAa2
        U2m4767DABblYab+CcLmAG/gObQlCdrhggGkm7ZATXZdj8GIlxynVy8ZNVfLCZLnxb1WVe2n+g8og
        +sLm/q9PQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:52756)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ijMUo-0001hB-GO; Mon, 23 Dec 2019 12:07:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ijMUl-0000n5-47; Mon, 23 Dec 2019 12:07:31 +0000
Date:   Mon, 23 Dec 2019 12:07:31 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Message-ID: <20191223120730.GO25745@shell.armlinux.org.uk>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 06:32:51PM +0000, Madalin Bucur wrote:
> 10GBase-R could be used as a common nominator but just as well 10G and
> remove the rest while we're at it. There are/may be differences in
> features, differences in the way the HW is configured (the most
> important aspect) and one should be able to determine what interface
> type is in use to properly configure the HW. SFI does not have the CDR
> function in the PMD, relying on the PMA signal conditioning vs the XFI
> that requires this in the PMD.

I've now found a copy of INF-8077i on the net, which seems to be the
document that defines XFI. The definition in there seems to be very
similar to SFI in that it is an electrical specification, not a
protocol specification, and, just like SFI, it defines the electrical
characteristics at the cage, not at the serdes. Therefore, the effects
of the board layout come into play to achieve compliance with XFI.

Just like SFI, XFI can be used with multiple different underlying
protocols. I quote:

  "The XFI interface is designed to support SONET OC-192,
  IEEE.Std-802.3ae, 10GFC and G.709(OTU-2) applications."

Therefore, to describe 10GBASE-R as "XFI" is most definitely incorrect.
10GBASE-R is just _one_ protocol that can be run over XFI, but it is
not the only one.

As for CDR, INF-8077i says:

  "The XFP module shall include a Signal Conditioner based on CDR (Clock
  Data Recovery) technology for complete regeneration."

Whereas for SFP modules, SFF-8472 revision 11.4 added optional support
for CDR on the modules.

In any case, the CDR is a matter for the module itself, not for the
host, so it seems that isn't relevent.

Everything that I've said concerning SFI in my previous email (in date
order), and why we should not be defining that as a phy_interface_t
seems to also apply to XFI from what I've read in INF-8077i, and it
seems my original decision that we should not separately define
XFI and SFI from 10GBASE-R is well founded.

Given that meeting these electrical characteristics involves the
effects of the board, and it is impractical for a board to switch
between different electrical characteristics at runtime (routing serdes
lanes to both a SFP+ and XFP cage is impractical due to reflections on
unterminated paths) I really don't see any reason why we need two
different phy_interface_t definitions for these.  As mentioned, the
difference between XFI and SFI is electrical, and involves the board
layout, which is a platform specific issue.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

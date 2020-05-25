Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD16C1E183B
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387888AbgEYXat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgEYXas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:30:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEE1C061A0E;
        Mon, 25 May 2020 16:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=U1Ygj3xrhTKKUdcGnGrhi0Eqb0ZBnKIT+SrxZH8LzP8=; b=nVwxpcLFDDiMw8ugil1Y/JY82
        e4LhWefOQaoHrpw/MZsIu+JMG6MXLWJ03SxtjzklRxAbMhJiTslUyk/EZG3iv4Q6gn+jGaEEDP94X
        rw8yPG8M8N0zDTqCuDo1iaBPzMj8YMO8tOhB9L1Al1XyejOjjV4zpajlPv6YGtC/HbE31Uk9cAEbm
        lBgt4d5UtFxtvda5HX0j+kxPpr+iHFBnb2pHY80z9j9u20dy00j67gi6P3txDrxWngD0MAZnMWLRx
        WQ6goX5R9/I+0QZPIe8PXwAtl10LT0LOtLJFrjXamroOcVFzdJqTy1BK2o3QU89ZEBvfDMxG6Hlru
        528jMUWqA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36976)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdMYM-0006Er-8o; Tue, 26 May 2020 00:30:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdMYK-0004mb-BB; Tue, 26 May 2020 00:30:40 +0100
Date:   Tue, 26 May 2020 00:30:40 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/11] net: phy: Handle c22 regs presence better
Message-ID: <20200525233040.GS1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-5-jeremy.linton@arm.com>
 <20200523183731.GZ1551@shell.armlinux.org.uk>
 <f85e4d86-ff58-0ed2-785b-c51626916140@arm.com>
 <20200525100612.GM1551@shell.armlinux.org.uk>
 <63ca13e3-11ea-3ddf-e1c7-90597d4a5f8c@arm.com>
 <20200525220127.GO1551@shell.armlinux.org.uk>
 <bcffde0b-d87f-b615-7484-5d25ade1fb48@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcffde0b-d87f-b615-7484-5d25ade1fb48@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 06:16:18PM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/25/20 5:01 PM, Russell King - ARM Linux admin wrote:
> > On Mon, May 25, 2020 at 04:51:16PM -0500, Jeremy Linton wrote:
> > > So, my goals here have been to first, not break anything, and then do a
> > > slightly better job finding phy's that are (mostly?) responding correctly to
> > > the 802.3 spec. So we can say "if you hardware is ACPI conformant, and you
> > > have IEEE conformant phy's you should be ok". So, for your example phy, I
> > > guess the immediate answer is "use DT" or "find a conformant phy", or even
> > > "abstract it in the firmware and use a mailbox interface".
> > 
> > You haven't understood.  The PHY does conform for most of the MMDs,
> > but there are a number that do not conform.
> > 
> 
> Maybe I should clarify. This set is still terminating the search for a valid
> MMD device list on the first MMD that responds. It then probes the same ID
> registers of the flagged MMDs as before. What has changed is that we search
> higher into the MMD address space for a device list. So previously if a
> device didn't respond to MMD0-8 it was ignored. Now it needs to fail all of
> 0-31 to be ignored. Similarly for the ID's, if we find what appears to be a
> valid MMD device list, then we will probe not only the original 1-8 MMDs for
> IDs, but 1-31 MMDs for IDs.

Clarification is not required; I understand what you're doing, but you
are not understanding my points.

For the 88x3310, your change means that the list of IDs for this PHY
will not only 0x002b09aX, 0x01410daX (the official IDs), but also
0x00000000 and 0xfffe0000 from MMD 30 and 31 respectively, which are
not real IDs.  That's two incorrect IDs that should actually not be
there.

Here's what the first few registers from MMD 30 and 31 look like on
this PHY:

MMD30:
 Addr  Data
 0000  0000 0000 0000 0000 0000 0000 0000 0000
 0008  0000 0000 0000 0000 0000 0000 0000 0000
 0010  0000 0000 0000 0000 0000 0000 0000 0000

MMD31:
 0000  fffe 0000 fffe 0000 fffe 0000 fffe 0000
 0008  fffe 0000 fffe 0000 fffe 0000 fffe 0000
 0010  fffe 0000 fffe 0000 fffe 0000 fffe 0000

We've got away with it so far on several counts:
1. The code doesn't probe that high for IDs.
2. We have no driver that may match those IDs.

You're taking away (1), so now all it takes is for condition (2) to
be broken, and we can end up with a regression if another driver
appears that may match using those.

So, I would suggest that you avoid reading IDs from MMD 30/31, or
maybe only read the ID from MMDs > 8 if register 8 indicates that
there is a device present at that MMD.  That would be compliant
with IEEE 802.3, preserve our existing behaviour, while allowing
us to expand the IDs that we probe for to have a better chance of
only detecting truely valid IDs.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up

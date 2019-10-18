Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28EFEDC5F0
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 15:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410267AbfJRNX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 09:23:29 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35062 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729109AbfJRNX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 09:23:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2I14EvOX2/1YnVDZjctaYDorbM75GscvFA5/hP5DpAA=; b=rOpFFVhhA5dU5sq2tPyWkoU4r
        ONWyHlxMyffZC9FmlbwjGtx6ZekPv/BDv5nJJXffZlrF4W0xxkGCeWmEIDgDsCgBospckf3zJx6Mb
        s7Qy+1SqbAFkwVww6Noxr2tn8zp7rJFTIAADL/mZK2sltIF6YKp12GqNjbVCgReaOYfKcgelJwGyT
        9KLn/p32DeNsBrssgk6OTAmuVPsN93Tr1C5LVBLBmUNRitktMyiVPb0K+DYOiOfjAuKMnJ3tI2PkC
        rYrGxq08+zwpcqt2+bhQHxZfUp54Istdb4CEYyY5EF/uUvywTzG5Fr7HR4d84VfFPSQuFDMUmQpG2
        ecXptpUyA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:44306)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iLSDx-0007mG-4C; Fri, 18 Oct 2019 14:23:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iLSDs-0000kn-NL; Fri, 18 Oct 2019 14:23:16 +0100
Date:   Fri, 18 Oct 2019 14:23:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next 2/2] net: phy: Add ability to debug RGMII
 connections
Message-ID: <20191018132316.GI25745@shell.armlinux.org.uk>
References: <20191015224953.24199-1-f.fainelli@gmail.com>
 <20191015224953.24199-3-f.fainelli@gmail.com>
 <4feb3979-1d59-4ad3-b2f1-90d82cfbdf54@gmail.com>
 <c4244c9a-28cb-7e37-684d-64e6cdc89b67@gmail.com>
 <CA+h21hrLHe2n0OxJyCKTU0r7mSB1zK9ggP1-1TCednFN_0rXfg@mail.gmail.com>
 <20191018130121.GK4780@lunn.ch>
 <CA+h21hoPrwcgz-q=UROAu0PC=6JbKtbdPhJtZg5ge32_2xJ3TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoPrwcgz-q=UROAu0PC=6JbKtbdPhJtZg5ge32_2xJ3TQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 04:09:30PM +0300, Vladimir Oltean wrote:
> Hi Andrew,
> 
> On Fri, 18 Oct 2019 at 16:01, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > Well, that's the tricky part. You're sending a frame out, with no
> > > guarantee you'll get the same frame back in. So I'm not sure that any
> > > identifiers put inside the frame will survive.
> > > How do the tests pan out for you? Do you actually get to trigger this
> > > check? As I mentioned, my NIC drops the frames with bad FCS.
> >
> > My experience is, the NIC drops the frame and increments some the
> > counter about bad FCS. I do very occasionally see a frame delivered,
> > but i guess that is 1/65536 where the FCS just happens to be good by
> > accident. So i think some other algorithm should be used which is
> > unlikely to be good when the FCS is accidentally good, or just check
> > the contents of the packet, you know what is should contain.
> >
> > Are there any NICs which don't do hardware FCS? Is that something we
> > realistically need to consider?
> >
> > > Yes, but remember, nobody guarantees that a frame with DMAC
> > > ff:ff:ff:ff:ff:ff on egress will still have it on its way back. Again,
> > > this all depends on how you plan to manage the rx-all ethtool feature.
> >
> > Humm. Never heard that before. Are you saying some NICs rewrite the
> > DMAN?
> >
> 
> I'm just trying to understand the circumstances under which this
> kernel thread makes sense.
> Checking for FCS validity means that the intention was to enable the
> reception of frames with bad FCS.
> Bad FCS after bad RGMII setup/hold times doesn't mean there's a small
> guy in there who rewrites the checksum. It means that frame octets get
> garbled. All octets are just as likely to get garbled, including the
> SFD, preamble, DMAC, etc.
> All I'm saying is that, if the intention of the patch is to actually
> process the FCS of frames before and after, then it should actually
> put the interface in promiscuous mode, so that frames with a
> non-garbled SFD and preamble can still be received, even though their
> DMAC was the one that got garbled.

Isn't the point of this to see which RGMII setting results in a working
setup?

So, is it not true that what we're after is receiving a _correct_ frame
that corresponds to the frame that was sent out?

Hence, if the DMAC got changed, it's irrelevent whether we received the
packet or not - since "no packet" || "changed packet" = fail.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

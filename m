Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BBB1F080F
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 20:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgFFSCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 14:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbgFFSCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 14:02:42 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44515C03E96A;
        Sat,  6 Jun 2020 11:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NJhlR4+WiJBwNpZXlmYHSzeB9Vumm+QMS05LPSMQ8W0=; b=PiF8ahIlOe4jylvw849EtKiqSH
        9JcGTsmywkSW6kWStvK607Gx24AHUMh64b+BPAXB3NOz2mUOW2rR29lD6M8xLGSC1n23yuHvWa4cM
        SPGXz9IGVEveB5YdSBJAQ8FKakBbkFp9xP+QRzWGtSLQKA92MAyR0B58OlNU6yf5GHDr4j1D7B/c9
        q7BBCd50HKQVP+zAbDcom0C3AKR6CpOPGU6KZ0kUMupqXLb3lVAiA2zLamYw7AmTYkue5jC+gfYJe
        i4CtvsYsGmRNKlEUCdfwzUo5BOaDTVQczyyntMfMroEL81hgEBl4jSFBGjG/Na3zdBDjrYjcU+if8
        C+4AqsEQ==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jhd9P-0001VU-U9; Sat, 06 Jun 2020 19:02:35 +0100
Date:   Sat, 6 Jun 2020 19:02:35 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: qca8k: introduce SGMII configuration
 options
Message-ID: <20200606180235.GO311@earth.li>
References: <cover.1591380105.git.noodles@earth.li>
 <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
 <20200605183843.GB1006885@lunn.ch>
 <20200606074916.GM311@earth.li>
 <20200606083741.GK1551@shell.armlinux.org.uk>
 <20200606105909.GN311@earth.li>
 <20200606134356.GM1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606134356.GM1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 06, 2020 at 02:43:56PM +0100, Russell King - ARM Linux admin wrote:
> On Sat, Jun 06, 2020 at 11:59:09AM +0100, Jonathan McDowell wrote:
> > So the device in question is a 7 port stand alone switch chip. There's a
> > single SGMII port which is configurable between port 0 + 6 (they can
> > also be configure up as RGMII, while the remaining 5 ports have their
> > own phys).
> > 
> > It sounds like there's a strong preference to try and auto configure
> > things as much as possible, so I should assume the CPU port is in MAC
> > mode, and anything not tagged as a CPU port is talking to a PHY/BASEX.
> > 
> > I assume I can use PHY_INTERFACE_MODE_1000BASEX on the
> > phylink_mac_config call to choose BASEX?
> 
> Yes, but from what you've mentioned above, I think I need to ensure that
> there's a proper understanding here.
> 
> 1000BASE-X is the IEEE 802.3 defined 1G single lane Serdes protocol.
> SGMII is different; it's a vendor derivative of 1000BASE-X which has
> become a de-facto standard.
> 
> Both are somewhat compatible with each other; SGMII brings with it
> additional data replication to achieve 100M and 10M speeds, while
> keeping the link running at 1.25Gbaud.  In both cases, there is a
> 16-bit "configuration" word that is passed between the partners.
> 
> 1000BASE-X uses this configuration word to advertise the abilities of
> each end, which is limited to duplex and pause modes only.  This you
> get by specifying the phy-mode="1000base-x" and
> managed="in-band-status" in DT.
> 
> SGMII uses this configuration word for the media side to inform the
> system side which mode it wishes to operate the link: the speed and
> duplex.  Some vendors extend it to include EEE parameters as well,
> or pause modes.  You get this via phy-mode="sgmii" and
> managed="in-band-status" in DT.
> 
> Then there are variants where the configuration word is not present.
> In this case, the link has to be manually configured, and without the
> configuration word, SGMII operating at 1G is compatible with
> 1000base-X operating at 1G.  Fixed-link can be used for this, although
> fixed-link will always report that the link is up at the moment; that
> may change in the future, it's something that is being looked into at
> the moment.

The hardware I'm using has the switch connected to the CPU via the SGMII
link, and all instances I can find completely disable inband
configuration for that case. However the data sheet has an SGMII control
register which allows configuration of the various auto-negotiation
parameters (as well as whether we're base-x or sgmii) so I think the
full flexibility is there.

I've got an initial port over to using phylink and picking up the
parameters that way (avoiding any device tree option changes) that seems
to be working, but I'll do a bit more testing before sending out a v2
RFC.

J.

-- 
/-\                             | There are always at least two ways
|@/  Debian GNU/Linux Developer |     to program the same thing.
\-                              |

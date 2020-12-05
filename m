Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C492CF80E
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 01:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbgLEAlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 19:41:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730759AbgLEAln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 19:41:43 -0500
Date:   Fri, 4 Dec 2020 16:41:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607128863;
        bh=9/6pfRIoYoOooYa3hcRTcuyTY/K+fIEH07B1O/UF45s=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=YP+ygCNGWS0sEwMr4+UgQlaSLVuCCijlkNIZ6etzAdCZUDoMVTs43nJCpKYSjbqlg
         YjobQWLoIKzqbRVdX8Q9sLk53DzhhSCyshcFl69QVNRilz+y6Ky5EIFLzEj6CrOOJk
         A8DrFgG0AugfTU1/3NaE4QA9Y9G/ffh+Tb5ufhhQrLjrVFZqsehTdr5A1Mcib1uTfd
         eOqoCpwHbZ6pHRFQJ5IG98/DSIVAre4qMUu1fzRKIGiJKlJILBnUT1sGiITEjU5b0g
         7i4sxm4F+weN1N7AiYzzuaw3v4bWRdUngR8+MtcWt90qHvNdHGgncUjvYTsuExxOrH
         LO1g5Zc8IOFAw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH v2 net] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Message-ID: <20201204164101.67d3d370@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204192310.al6fhkbarhbjng3a@skbuf>
References: <20201204175125.1444314-1-vladimir.oltean@nxp.com>
        <20201204100021.0b026725@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201204181250.t5d4hc7wis7pzqa2@skbuf>
        <20201204105516.1237a690@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201204192310.al6fhkbarhbjng3a@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 19:23:11 +0000 Vladimir Oltean wrote:
> > > > What's the expected poll time? maybe it's not that bad to busy wait?
> > > > Clearly nobody noticed the issue in 2 years (you mention lockdep so
> > > > not a "real" deadlock) which makes me think the wait can't be that long?  
> > >
> > > Not too much, but the sleep is there.
> > > Also, all 3 of ocelot/felix/seville are memory-mapped devices. But I
> > > heard from Alex a while ago that he intends to add support for a switch
> > > managed over a slow bus like SPI, and to use the same regmap infrastructure.
> > > That would mean that this problem would need to be resolved anyway.  
> >
> > So it's MMIO but the other end is some firmware running on the device?  
> 
> No. It's always register-based access, just that in some cases the
> registers are directly memory-mapped for Linux, while in other cases
> they are beyond an SPI bus. But there isn't any firmware in any case.

I see, so ocelot_mact_wait_for_completion() waits for some hardware
engine to process the command? It looked like FW is hiding behind that
register at a glance. 100ms sounds very high for hardware processing.

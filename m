Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6CD1E6409
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391221AbgE1Odl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 May 2020 10:33:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:60110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391207AbgE1Odk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 10:33:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 18420AD09;
        Thu, 28 May 2020 14:33:37 +0000 (UTC)
Date:   Thu, 28 May 2020 16:33:35 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-Id: <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
In-Reply-To: <20200528135608.GU1551@shell.armlinux.org.uk>
References: <20200528121121.125189-1-tbogendoerfer@suse.de>
        <20200528130738.GT1551@shell.armlinux.org.uk>
        <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
        <20200528135608.GU1551@shell.armlinux.org.uk>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 14:56:08 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Thu, May 28, 2020 at 03:17:33PM +0200, Thomas Bogendoerfer wrote:
> > On Thu, 28 May 2020 14:07:38 +0100
> > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > 
> > > On Thu, May 28, 2020 at 02:11:21PM +0200, Thomas Bogendoerfer wrote:
> > > > Commit d14e078f23cc ("net: marvell: mvpp2: only reprogram what is necessary
> > > >  on mac_config") disabled auto negotiation bypass completely, which breaks
> > > > platforms enabling bypass via firmware (not the best option, but it worked).
> > > > Since 1000BaseX/2500BaseX ports neither negotiate speed nor duplex mode
> > > > we could enable auto negotiation bypass to get back information about link
> > > > state.
> > > 
> > > Thanks, but your commit is missing some useful information.
> > > 
> > > Which platforms have broken?
> > 
> > it's an Ambedded MARS-400
> >  
> > > Can you describe the situation where you require this bit to be set?
> > 
> > as I have no exact design details I'm just talking about what I can see
> > on that platform. It looks like the switch connecting the internal nodes
> > doesn't run autoneg on the internal links. So the link to the internal
> > nodes will never come up. These links are running 2500BaseX so speed/duplex
> > is clean and by enabling bypass I'll get a proper link state, too.
> > 
> > > We should not be enabling bypass mode as a matter of course, it exists
> > > to work around broken setups which do not send the control word.
> > 
> > if you call it a broken setup I'm fine, but this doesn't solve the problem,
> > which exists now. What would be your solution ?
> 
> What I was after was additional information about the problem, so
> that we can start thinking about how to deal with the AN bypass bit
> in a sensible way.
> 
> How is the connection between the switch and network interface
> described?  I don't think I see a .dts file in mainline for this
> platform.

below is the dts part for the two network interfaces. The switch to
the outside has two ports, which correlate to the two internal ports.
And the switch propagates the link state of the external ports to
the internal ports.

Thomas.

&cp0_eth1 {
        status = "okay";
        phy-mode = "2500base-x";
        mac-address = [00 00 00 00 00 01];
        interrupts = <41 IRQ_TYPE_LEVEL_HIGH>,
        <45 IRQ_TYPE_LEVEL_HIGH>,
        <49 IRQ_TYPE_LEVEL_HIGH>,
        <53 IRQ_TYPE_LEVEL_HIGH>,
        <57 IRQ_TYPE_LEVEL_HIGH>,
        <61 IRQ_TYPE_LEVEL_HIGH>,
        <65 IRQ_TYPE_LEVEL_HIGH>,
        <69 IRQ_TYPE_LEVEL_HIGH>,
        <73 IRQ_TYPE_LEVEL_HIGH>,
        <127 IRQ_TYPE_LEVEL_HIGH>;
        interrupt-names = "hif0", "hif1", "hif2",
        "hif3", "hif4", "hif5", "hif6", "hif7",
        "hif8", "link";
        port-id = <2>;
        gop-port-id = <3>;
        managed = "in-band-status";
};

&cp0_eth2 {
        status = "okay";
        phy-mode = "2500base-x";
        mac-address = [00 00 00 00 00 02];
        interrupts = <40 IRQ_TYPE_LEVEL_HIGH>,
        <44 IRQ_TYPE_LEVEL_HIGH>,
        <48 IRQ_TYPE_LEVEL_HIGH>,
        <52 IRQ_TYPE_LEVEL_HIGH>,
        <56 IRQ_TYPE_LEVEL_HIGH>,
        <60 IRQ_TYPE_LEVEL_HIGH>,
        <64 IRQ_TYPE_LEVEL_HIGH>,
        <68 IRQ_TYPE_LEVEL_HIGH>,
        <72 IRQ_TYPE_LEVEL_HIGH>,
        <128 IRQ_TYPE_LEVEL_HIGH>;
        interrupt-names = "hif0", "hif1", "hif2",
        "hif3", "hif4", "hif5", "hif6", "hif7",
        "hif8", "link";
        port-id = <1>;
        gop-port-id = <2>;
        managed = "in-band-status";
};


-- 
SUSE Software Solutions Germany GmbH
HRB 36809 (AG Nürnberg)
Geschäftsführer: Felix Imendörffer

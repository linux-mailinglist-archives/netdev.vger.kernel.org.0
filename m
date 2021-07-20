Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17CE3CFEED
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 18:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhGTPbk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Jul 2021 11:31:40 -0400
Received: from foss.arm.com ([217.140.110.172]:33954 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240646AbhGTPYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 11:24:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AAA731B;
        Tue, 20 Jul 2021 09:05:08 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3EB343F694;
        Tue, 20 Jul 2021 09:05:07 -0700 (PDT)
Date:   Tue, 20 Jul 2021 17:04:26 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     nic_swsd@realtek.com, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sayanta Pattanayak <sayanta.pattanayak@arm.com>
Subject: Re: [PATCH v2] r8169: Avoid duplicate sysfs entry creation error
Message-ID: <20210720170426.3bc4ce21@slackpad.fritz.box>
In-Reply-To: <bb2e4938-0a7c-1b02-25f5-5615d3a1b1c7@gmail.com>
References: <20210624154945.19177-1-andre.przywara@arm.com>
        <bb2e4938-0a7c-1b02-25f5-5615d3a1b1c7@gmail.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Jun 2021 20:41:25 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

Hi Heiner,

> On 24.06.2021 17:49, Andre Przywara wrote:
> > From: Sayanta Pattanayak <sayanta.pattanayak@arm.com>
> > 
> > When registering the MDIO bus for a r8169 device, we use the PCI B/D/F
> > specifier as a (seemingly) unique device identifier.
> > However the very same BDF number can be used on another PCI segment,
> > which makes the driver fail probing:
> > 
> > [ 27.544136] r8169 0002:07:00.0: enabling device (0000 -> 0003)
> > [ 27.559734] sysfs: cannot create duplicate filename '/class/mdio_bus/r8169-700'
> > ....…
> > [ 27.684858] libphy: mii_bus r8169-700 failed to register
> > [ 27.695602] r8169: probe of 0002:07:00.0 failed with error -22
> > 
> > Add the segment number to the device name to make it more unique.
> > 
> > This fixes operation on an ARM N1SDP board, where two boards might be
> > connected together to form an SMP system, and all on-board devices show
> > up twice, just on different PCI segments.
> > 
> > Signed-off-by: Sayanta Pattanayak <sayanta.pattanayak@arm.com>
> > [Andre: expand commit message, use pci_domain_nr()]
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> > Now compile-tested on ARM, arm64, ppc64, sparc64, mips64, hppa, x86-64,
> > i386.
> >   
> Good. Patch is missing the net vs. net-next annotation, therefore the
> remaining question is whether to treat this as a fix. Seems nobody but
> you was affected so far, therefore handling it as an improvement should
> be fine as well.
> 
> If you need this change on previous kernel versions:
> Add net annotation and add a Fixes tag (I think when driver was switched
> to phylib with 4.19). Else add a net-next annotation.

Many thanks for the instructions! I decided to mark it as a fix, since
the problem is definitely there. I guess it just was not reported since
multiple RTL8169 devices are not often used in big systems with
multiple PCIe segments, and even if, there might be no collisions, by
sheer luck and virtue of a favourable bus enumeration.

Let me know if you disagree. At least I would like to see it in v5.10.y.

Sending v3 with the proper annotation in a minute.

Cheers,
Andre

> 
> See the following link for details:
> https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt
> 
> > Changes v1 ... v2:
> > - use pci_domain_nr() wrapper to fix compilation on various arches
> > 
> >  drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> > index 2c89cde7da1e..5f7f0db7c502 100644
> > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > +++ b/drivers/net/ethernet/realtek/r8169_main.c
> > @@ -5086,7 +5086,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
> >  	new_bus->priv = tp;
> >  	new_bus->parent = &pdev->dev;
> >  	new_bus->irq[0] = PHY_MAC_INTERRUPT;
> > -	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x", pci_dev_id(pdev));
> > +	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x-%x",
> > +		 pci_domain_nr(pdev->bus), pci_dev_id(pdev));
> >  
> >  	new_bus->read = r8169_mdio_read_reg;
> >  	new_bus->write = r8169_mdio_write_reg;
> >   
> 


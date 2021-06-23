Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11ACC3B22AA
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFWVqm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 23 Jun 2021 17:46:42 -0400
Received: from foss.arm.com ([217.140.110.172]:40480 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229850AbhFWVql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 17:46:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37E921042;
        Wed, 23 Jun 2021 14:44:23 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2077F3F694;
        Wed, 23 Jun 2021 14:44:22 -0700 (PDT)
Date:   Wed, 23 Jun 2021 22:43:59 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     nic_swsd@realtek.com, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sayanta Pattanayak <sayanta.pattanayak@arm.com>
Subject: Re: [PATCH] r8169: Avoid duplicate sysfs entry creation error
Message-ID: <20210623224359.5b1912d1@slackpad.fritz.box>
In-Reply-To: <1c26684c-d3eb-92b9-b93f-4dd02b47603e@gmail.com>
References: <20210622125206.1437-1-andre.przywara@arm.com>
        <1c26684c-d3eb-92b9-b93f-4dd02b47603e@gmail.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Jun 2021 21:48:14 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

Hi Heiner,

> On 22.06.2021 14:52, Andre Przywara wrote:
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
> > [Andre: expand commit message]
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> > index 2c89cde7da1e..209dee295ce2 100644
> > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > +++ b/drivers/net/ethernet/realtek/r8169_main.c
> > @@ -5086,7 +5086,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
> >  	new_bus->priv = tp;
> >  	new_bus->parent = &pdev->dev;
> >  	new_bus->irq[0] = PHY_MAC_INTERRUPT;
> > -	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x", pci_dev_id(pdev));
> > +	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x-%x",
> > +		 pdev->bus->domain_nr, pci_dev_id(pdev));
> >    
> I think you saw the error mail from kernel test robot.
> You have to use pci_domain_nr() instead of member domain_nr directly.

Yeah, thanks, I figured already. I actually missed test-compiling for
x86 :-(

Will send v2 ASAP.

Cheers,
Andre

> 
> >  	new_bus->read = r8169_mdio_read_reg;
> >  	new_bus->write = r8169_mdio_write_reg;
> >   
> 


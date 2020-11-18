Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE6B2B8141
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 16:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgKRPzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:55:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbgKRPzy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 10:55:54 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfPoF-007kUQ-6D; Wed, 18 Nov 2020 16:55:51 +0100
Date:   Wed, 18 Nov 2020 16:55:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     David Thompson <davthompson@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net-next v3] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <20201118155551.GD1800835@lunn.ch>
References: <1605654870-14859-1-git-send-email-davthompson@nvidia.com>
 <20201118030950.GB1804098@lunn.ch>
 <CH2PR12MB3895318D3802419175BA42C3D7E10@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB3895318D3802419175BA42C3D7E10@CH2PR12MB3895.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes mlxbf_gige_mdio_handle_phy_interrupt is used to check whether
> the interrupt is coming from GPIO12 (which is set in HW as the PHY
> INT_N pin). There is one HW interrupt line (here defined as
> MLXBF_GIGE_PHY_INT_N) shared among all the GPIOs and other
> components (like I2C).

So this is the key thing here. You have an interrupt controller, where
as the PHY subsystem wants a plain interrupt. Give the PHY subsystem a
plain interrupt, and it will do all the calls to configure the PHY,
enable interrupts in the PHY etc.

There is nothing stopping you have an interrupt controller inside an
Ethernet driver, or any other sort of driver. Take for example:

https://elixir.bootlin.com/linux/v5.10-rc4/source/drivers/net/dsa/mv88e6xxx/chip.c#L127

The Marvell Ethernet switches also have an interrupt
controller. Actually they have two nested controllers. This code
registers an irq domain with the linux core, so that the individual
interrupt sources can be used as just plain old Linux interrupts. The
irqdomain is responsible to masking and unmasking interrupts, in the
interrupt controller.

The end user of these interrupts, then just request them in the usual
way:

https://elixir.bootlin.com/linux/v5.10-rc4/source/drivers/net/dsa/mv88e6xxx/global1_atu.c#L419

So in your case, map the PHY interrupt in this domain, and pass it to
the PHY subsystem.

    Andrew

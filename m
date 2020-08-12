Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA019243084
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 23:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgHLVeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 17:34:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51434 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVeE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 17:34:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k5yNl-009BqP-Bv; Wed, 12 Aug 2020 23:34:01 +0200
Date:   Wed, 12 Aug 2020 23:34:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     David Thompson <dthompson@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Asmaa Mnebhi <Asmaa@mellanox.com>
Subject: Re: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Message-ID: <20200812213401.GI2141651@lunn.ch>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
 <20200731174222.GE1748118@lunn.ch>
 <CH2PR12MB3895E054D1E00168D9FFB2F0D7450@CH2PR12MB3895.namprd12.prod.outlook.com>
 <20200811200652.GD2141651@lunn.ch>
 <CH2PR12MB3895636714ECACC888869058D7420@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB3895636714ECACC888869058D7420@CH2PR12MB3895.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Asmaa

Please wrap your emails at about 75 characters.

> So let me explain further and would greatly appreciate your input.

> Technically, when this driver gets loaded, we shouldn't need the interrupt when bringing up the link for the first time, do we?
> Correct me if I am wrong, "phy_start" should bring up the link. Phy_start calls phy_start_aneg, which eventually calls phy_check_link_status.
> phy_check_link_status , reads the link state bit of the BMSR register (only twice),  and based on that determines whether to bring up/down the link. In our case, that bit is still 0 when the read is donw. A little bit later, it gets set to 1.
> 
> This is why polling works in this case. Phy_start fails to bring up the link but the polling eventually bring it up. If we choose to use the interrupt, we should make sure that the 
> Interrupt is enabled a little bit after phy_start, otherwise, it would just be wasted.

When the PHY is connected to the MAC, phy_request_interrupt() is
called. That sets up the SoC side of the interrupt, so that
phy_interrupt() will be called on interrupt. It then calls
phy_enable_interrupts()->phy_config_interrupt() which calls into the
PHY driver to enable interrupts within the PHY.  It is then expected
that the PHY interrupts whenever there is a change in link status.

Sometime later phy_start() will be called which should kick off an
autoneg. That should result in the link going up, maybe 1.5 seconds
later if the link peer is present, maybe later if there is no
peer. The link up will trigger an interrupt, and the new status will
be read. If the link goes down, the interrupt should also trigger, and
the status will be updated.

   Andrew

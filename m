Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8814B34E10
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 18:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfFDQyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 12:54:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55478 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbfFDQyy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 12:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IHacWH+Djcp8BYpbuXs0K9bY3/ohwLLhjauRh5MYdPA=; b=yaYxGNFKsMUGznjTQV1vU714tU
        lrJPNhWCV17xJ8y4/sbtYEb/J0aSmqyB9T+xQgEUX8kbIh9uieic5bHLygZCNhyo/LtE62D3KB7jB
        f7MWfYKaeQzgm9P59Qa261x313LOizoMU0V6U3catLeYw/F4H+KsBFyhuN5XZJW9tX7s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYCi4-0006RX-Oh; Tue, 04 Jun 2019 18:54:52 +0200
Date:   Tue, 4 Jun 2019 18:54:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2] net: phy: xilinx: add Xilinx PHY driver
Message-ID: <20190604165452.GU19627@lunn.ch>
References: <1559603524-18288-1-git-send-email-hancock@sedsystems.ca>
 <d8c22bc3-0a20-2c24-88bb-b1f5f8cc907a@gmail.com>
 <7684776f-2bec-e9e2-1a79-dbc3e9844f7e@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7684776f-2bec-e9e2-1a79-dbc3e9844f7e@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So it seems like what is missing is the ability of genphy_config_init to
> detect the bits in the extended status register for 1000Base-X and add
> the corresponding mode flags. It appears bit 15 for 1000Base-X full
> duplex is standardized in 802.3 Clause 22, so I would expect Linux
> should be able to detect that and add it as a supported mode for the
> PHY. genphy_config_init is dealing with the "legacy" 32-bit mode masks
> that have no bit for 1000BaseX though.. how is that intended to work?

Hi Robert

I think you are looking at an old genphy_config_init(). The u32 has
been replaced. Adding:

#define ESTATUS_1000_XFULL      0x8000  /* Can do 1000BX Full          */
#define ESTATUS_1000_XHALF      0x4000  /* Can do 1000BT Half          */

and

                if (val & ESTATUS_1000_XFULL)
                        linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
                                         features);

should not be a problem.

       Andrew
  

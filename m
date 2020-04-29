Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0454C1BDFB6
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 15:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgD2N4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 09:56:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59312 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727807AbgD2N4R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 09:56:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lsl27Mlg7G/ECMNhQVfGG90+ab5xfwND9PAQgH/V4W0=; b=MApuiRS9UbZpd5ZUjvMiUqvSQW
        ftNVC1kMm1O+HYJid96UCzVS+LXt8CNpCXfrt7nUFejsNFSKlAWgfWF6Nq+obrP4QQgYmR4OutzXa
        Qp2A1ABgJwf/5P0yL6MUguhzHSjbGLrxwBXd8Qi/lWrGlXJRzY86uY6q7ebpgKqfo12M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTnC5-000GGL-Ol; Wed, 29 Apr 2020 15:56:09 +0200
Date:   Wed, 29 Apr 2020 15:56:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Badel, Laurent" <LaurentBadel@eaton.com>
Cc:     "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: Re: [PATCH 1/2] Revert commit
 1b0a83ac04e383e3bed21332962b90710fcf2828
Message-ID: <20200429135609.GJ30459@lunn.ch>
References: <CH2PR17MB3542FD48AB01562BF812A948DFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CH2PR17MB3542FD48AB01562BF812A948DFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 09:03:32AM +0000, Badel, Laurent wrote:
> ﻿Description: This patch reverts commit 1b0a83ac04e3 
> ("net: fec: add phy_reset_after_clk_enable() support")
> which produces undesirable behavior when PHY interrupts are enabled.
> 
> Rationale: the SMSC LAN8720 (and possibly other chips) is known
> to require a reset after the external clock is enabled. Calls to
> phy_reset_after_clk_enable() in fec_main.c have been introduced in 
> commit 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")
> to handle the chip reset after enabling the clock.
> However, this breaks when interrupts are enabled because
> the reset reverts the configuration of the PHY interrupt mask to default
> (in addition it also reverts the "energy detect" mode setting).
> As a result the driver does not receive the link status change
> and other notifications resulting in loss of connectivity. 
> 
> Proposed solution: revert commit 1b0a83ac04e3 and bring the reset 
> before the PHY configuration by adding it to phy_init_hw() [phy_device.c].
> 
> Test results: using an iMX28-EVK-based board, these 2 patches successfully
> restore network interface functionality when interrupts are enabled.
> Tested using both linux-5.4.23 and latest mainline (5.6.0) kernels.
> 
> Fixes: 1b0a83ac04e383e3bed21332962b90710fcf2828 ("net: fec: add phy_reset_after_clk_enable() support")
> Signed-off-by: Laurent Badel <laurentbadel@eaton.com>

Hi Laurent

Please also read https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt

       Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2911C14200E
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 21:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgASUvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 15:51:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46196 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728682AbgASUvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 15:51:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LsGWUihwaAVRXCio4bkLWcKVxSomCGiW0iPSq0q6tOQ=; b=w6LKLdRzYTAvT0a1qRIKNHa4rT
        2plERugGKZC+NB/OP3+RAgcJmy2l31if6nnHqAPA0ivIqNmq1gPSmvatOqRRKn0Mfzy7kvRhrl83Z
        jD82zCwvDEetkyoOF5QR6YEUKga8J2W4hSgu//xHf9q2rTshTIjk5TTkSnevGX1i9HJg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1itHXA-0005P9-0a; Sun, 19 Jan 2020 21:51:00 +0100
Date:   Sun, 19 Jan 2020 21:50:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: phy: add generic ndo_do_ioctl handler
 phy_do_ioctl
Message-ID: <20200119205059.GD17720@lunn.ch>
References: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
 <20200119161240.GA17720@lunn.ch>
 <97389eb0-fc7f-793b-6f84-730e583c00e9@googlemail.com>
 <20200119175109.GB17720@lunn.ch>
 <c1f7d8ce-2bc2-5141-9f28-a659d2af4e10@gmail.com>
 <20200119185035.GC17720@lunn.ch>
 <82737a2f-b6c1-943e-42a2-d42d87212457@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82737a2f-b6c1-943e-42a2-d42d87212457@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Speaking for r8169:
> If interface is up and cable detached, then it runtime-suspends
> and goes into PCI D3 (chip and MDIO bus not accessible).
> But ndev is "running" and PHY is attached.

Hi Heiner

And how does it get out of this state? I assume the PHY interrupts
when the link is established. Is phylib handling this interrupt? If
so, when phylib accesses the MDIO bus, the bus needs to be runtime PM
aware. And if the bus is runtime PM aware, the IOCTL handler should
work, when the device is runtime suspended.  If the MAC is handling
this interrupt, and it is the MAC interrupt handler which is run-time
unsuspending, then the ioctl handler is not going to work unless it
also runtime unsuspends.

	Andrew

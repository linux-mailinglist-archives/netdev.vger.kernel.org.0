Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1D83509F
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfFDUHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:07:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56094 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfFDUHS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 16:07:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HuvLUbtmBHUZPl0mq/LjxghE0uHiPUwcLZrysWzlJMQ=; b=bq2icEV/VfCPsiNY1Qz1ahjUo/
        WjdqznO9g9r/+PX3/DUNaJnJ1AxE9RPZsCJ87J+L5QpZ8iaxhUEX2/37ZzpZzGe/q8tU/EVOe2tdj
        zxVHE2GtRvxRRnodv7edbN4RkreWN/7rrbk4fjAsJUHhBXjAcYO0DN3QrKDlyl9uxnG8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYFiD-0007nm-Fu; Tue, 04 Jun 2019 22:07:13 +0200
Date:   Tue, 4 Jun 2019 22:07:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
Message-ID: <20190604200713.GV19627@lunn.ch>
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 10:58:41PM +0300, Vladimir Oltean wrote:
> Hi,
> 
> I've been wondering what is the correct approach to cut the Ethernet link
> when the user requests it to be administratively down (aka ip link set dev
> eth0 down).
> Most of the Ethernet drivers simply call phy_stop or the phylink equivalent.
> This leaves an Ethernet link between the PHY and its link partner.
> The Freescale gianfar driver (authored by Andy Fleming who also authored the
> phylib) does a phy_disconnect here. It may seem a bit overkill, but of the
> extra things it does, it calls phy_suspend where most PHY drivers set the
> BMCR_PDOWN bit. Only this achieves the intended purpose of also cutting the
> link partner's link on 'ip link set dev eth0 down'.

Hi Vladimir

Heiner knows the state machine better than i. But when we transition
to PHY_HALTED, as part of phy_stop(), it should do a phy_suspend().

   Andrew

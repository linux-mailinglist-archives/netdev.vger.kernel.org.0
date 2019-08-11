Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C135F8929B
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 18:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfHKQbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 12:31:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfHKQbK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 12:31:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lozDe2KJhIZbEGQBfmlQNXhoJltngcT+6KrAJ7pHjU0=; b=y8xe1vCIbnoaJUi+9k8+FHNKe0
        xmZz6pGIaArP2t6zvIo7fcabjWTH6JZVjl+a4OSS9SFMmgI57ryRebUmrEOHziyz+M6NYGxB9YNIC
        om+/lQntAlqUi7jhH/OZdwGE9jqIeEPGGdSEOaPpvZ7q9hxv2FDk/OgDjDv0XaJ8UW5w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwqkN-0004Bz-Ao; Sun, 11 Aug 2019 18:31:07 +0200
Date:   Sun, 11 Aug 2019 18:31:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <festevam@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [BUG] fec mdio times out under system stress
Message-ID: <20190811163107.GE14290@lunn.ch>
References: <20190811133707.GC13294@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811133707.GC13294@shell.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 11, 2019 at 02:37:07PM +0100, Russell King - ARM Linux admin wrote:
> Hi Fabio,
> 
> When I woke up this morning, I found that one of the Hummingboards
> had gone offline (as in, lost network link) during the night.
> Investigating, I find that the system had gone into OOM, and at
> that time, triggered an unrelated:
> 
> [4111697.698776] fec 2188000.ethernet eth0: MDIO read timeout
> [4111697.712996] MII_DATA: 0x6006796d
> [4111697.729415] MII_SPEED: 0x0000001a
> [4111697.745232] IEVENT: 0x00000000
> [4111697.745242] IMASK: 0x0a8000aa
> [4111698.002233] Atheros 8035 ethernet 2188000.ethernet-1:00: PHY state change RUNNING -> HALTED
> [4111698.009882] fec 2188000.ethernet eth0: Link is Down
> 
> This is on a dual-core iMX6.
> 
> It looks like the read actually completed (since MII_DATA contains
> the register data) but we somehow lost the interrupt (or maybe
> received the interrupt after wait_for_completion_timeout() timed
> out.)

Hi Russell

The timeout is quite short,

#define FEC_MII_TIMEOUT         30000 /* us */

Looking at the Vybrid datasheet, there does not appear to be any way
to determine if the hardware is busy other than waiting for the
interrupt. There is no 'busy' bit which gets cleared on completion.

So about the only option is to make the timeout bigger.

   Andrew

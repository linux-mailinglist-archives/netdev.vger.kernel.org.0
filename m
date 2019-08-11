Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAE81892A9
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 18:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfHKQo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 12:44:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51334 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfHKQo0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 12:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TUcPvdon//cRSTNaWWbwC4+UhxIzQPVa/qaFVB2nzoo=; b=Ct70SbppQ1TFQY+VVbKLFZPGUK
        Z/BYxeHlpx0IxYzjtXD+/cJf+0EE4vVWDjiisTrNSS4ggIFouIghmcSLX0YESu4YUv5YbWStYOOto
        Lod9doT6ZCkVmoEMhTvag1I3SkgNwi6Acef3bWdlsmc0C4D1EFANdIcJucrn5uP+I+cA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwqxC-0004Fo-Fq; Sun, 11 Aug 2019 18:44:22 +0200
Date:   Sun, 11 Aug 2019 18:44:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <festevam@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [BUG] fec mdio times out under system stress
Message-ID: <20190811164422.GF14290@lunn.ch>
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

> Maybe phylib should retry a number of times - but with read-sensitive
> registers, if the read has already completed successfully, and its
> just a problem with the FEC MDIO hardware, that could cause issues.

Hi Russell

At the bus level, MDIO cannot fail. The bits get clocked out, and the
bits get clocked in. There is no way for the PHY to stretch the clock
as I2C slaves can. There is nothing like the USB NACK, try again
later.

If something fails, it fails at a higher level, which means it is a
driver issue. In this case, the interrupt got delayed, after the timer
interrupt.

The FEC is also quite unusual in using an interrupt. Most MDIO drivers
poll. And if time gets 'stretched' because the system is too busy,
generally, the right thing happens anyway.

So i don't think it is phylib job to work around this issue.

   Andrew

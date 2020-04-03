Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDB819D725
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390787AbgDCNGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:06:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46482 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbgDCNGA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Apr 2020 09:06:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kfWSDIagbtyE24zBzSd4Wi6BEjjkOuCZzFGWsd96K8M=; b=tpibQXHxHXhTwILqRgiYnGoWXY
        2I8M/hc36uFRuM61QLxUpnpYQRMdQIVg7x9+UdgzNxr2JJEIENJc3Irs3UWdHWHi4eZ9dOxsEhv9E
        j92HXm26NX6dQNEra4C0t9c7x6JbLbl58ldc7Cq2ouUZiIJEXnCxRF+CLyO6Y973Hca8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jKM16-000naW-ON; Fri, 03 Apr 2020 15:05:48 +0200
Date:   Fri, 3 Apr 2020 15:05:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1] net: phy: micrel: kszphy_resume(): add delay after
 genphy_resume() before accessing PHY registers
Message-ID: <20200403130548.GD114745@lunn.ch>
References: <20200403075325.10205-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403075325.10205-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 03, 2020 at 09:53:25AM +0200, Oleksij Rempel wrote:
> After the power-down bit is cleared, the chip internally triggers a
> global reset. According to the KSZ9031 documentation, we have to wait at
> least 1ms for the reset to finish.
> 
> If the chip is accessed during reset, read will return 0xffff, while
> write will be ignored. Depending on the system performance and MDIO bus
> speed, we may or may not run in to this issue.
> 
> This bug was discovered on an iMX6QP system with KSZ9031 PHY and
> attached PHY interrupt line. If IRQ was used, the link status update was
> lost. In polling mode, the link status update was always correct.
> 
> The investigation showed, that during a read-modify-write access, the
> read returned 0xffff (while the chip was still in reset) and
> corresponding write hit the chip _after_ reset and triggered (due to the
> 0xffff) another reset in an undocumented bit (register 0x1f, bit 1),
> resulting in the next write being lost due to the new reset cycle.
> 
> This patch fixes the issue by adding a 1...2 ms sleep after the
> genphy_resume().
> 
> Fixes: 836384d2501d ("net: phy: micrel: Add specific suspend")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Hi Oleksij

Please in future set the subject to [PATCH net v1] to indicate this is
a fix.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA91619114E
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgCXNku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:40:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54454 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbgCXNku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uRf8ofosAVV+2HpIIxy+2T25i84wUEcrYiHqS9WyV00=; b=LA+IJa2bRHrK/h8xVdBiOaa/nv
        Kqf9S3ikB0EaIILneLrAnc3ZB4yNfsJ6JCkG7e3/mT7FgZilA6i8cy67UuL/IaGktG08b0+TlO/MB
        Nq2HnK0UFoTKe+MpyZRK7MbFC/GfiF3ivUgHQJErCfX+OjsjFcmikTajOe02X/B/g6pM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGjnT-0002Ld-CI; Tue, 24 Mar 2020 14:40:47 +0100
Date:   Tue, 24 Mar 2020 14:40:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, antoine.tenart@bootlin.com
Subject: Re: [PATCH net-next] net: phy: mscc: consolidate a common RGMII
 delay implementation
Message-ID: <20200324134047.GY3819@lunn.ch>
References: <20200324124837.21556-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324124837.21556-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 02:48:37PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It looks like the VSC8584 PHY driver is rolling its own RGMII delay
> configuration code, despite the fact that the logic is mostly the same.
> 
> In fact only the register layout and position for the RGMII controls has
> changed. So we need to adapt and parameterize the PHY-dependent bit
> fields when calling the new generic function.

Nice.

> -static void vsc8584_rgmii_set_skews(struct phy_device *phydev)
> -{
> -	u32 skew_rx, skew_tx;
> -
> -	/* We first set the Rx and Tx skews to their default value in h/w
> -	 * (0.2 ns).
> -	 */

I like seeing this comment. It makes it clear that
PHY_INTERFACE_MODE_RGMII does not actually mean 0ns, but 0.2ns.  It
also makes it clear that if PHY_INTERFACE_MODE_RGMII_ID,
PHY_INTERFACE_MODE_RGMII_RXID or PHY_INTERFACE_MODE_RGMII_TXID is not
given, the delay is set to something. We have had PHY drivers which
get this wrong and leave the bootloader/strapping value in place.

So if you can keep the comment in some form, that would be good.

Thanks
	Andrew

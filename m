Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79871E95B5
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgEaEvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEaEvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:51:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DE2C05BD43;
        Sat, 30 May 2020 21:51:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B4C0E128FE1E8;
        Sat, 30 May 2020 21:51:04 -0700 (PDT)
Date:   Sat, 30 May 2020 21:51:02 -0700 (PDT)
Message-Id: <20200530.215102.921642191346859546.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     sergei.shtylyov@cogentembedded.com, kuba@kernel.org,
        andrew@lunn.ch, linux@rempel-privat.de,
        philippe.schenker@toradex.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        kazuya.mizuguchi.ks@renesas.com, grygorii.strashko@ti.com,
        wsa+renesas@sang-engineering.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] ravb: Mask PHY mode to avoid inserting delays twice
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529122540.31368-1-geert+renesas@glider.be>
References: <20200529122540.31368-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 21:51:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Fri, 29 May 2020 14:25:40 +0200

> Until recently, the Micrel KSZ9031 PHY driver ignored any PHY mode
> ("RGMII-*ID") settings, but used the hardware defaults, augmented by
> explicit configuration of individual skew values using the "*-skew-ps"
> DT properties.  The lack of PHY mode support was compensated by the
> EtherAVB MAC driver, which configures TX and/or RX internal delay
> itself, based on the PHY mode.
> 
> However, now the KSZ9031 driver has gained PHY mode support, delays may
> be configured twice, causing regressions.  E.g. on the Renesas
> Salvator-X board with R-Car M3-W ES1.0, TX performance dropped from ca.
> 400 Mbps to 0.1-0.3 Mbps, as measured by nuttcp.
> 
> As internal delay configuration supported by the KSZ9031 PHY is too
> limited for some use cases, the ability to configure MAC internal delay
> is deemed useful and necessary.  Hence a proper fix would involve
> splitting internal delay configuration in two parts, one for the PHY,
> and one for the MAC.  However, this would require adding new DT
> properties, thus breaking DTB backwards-compatibility.
> 
> Hence fix the regression in a backwards-compatibility way, by letting
> the EtherAVB driver mask the PHY mode when it has inserted a delay, to
> avoid the PHY driver adding a second delay.  This also fixes messages
> like:
> 
>     Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: *-skew-ps values should be used only with phy-mode = "rgmii"
> 
> as the PHY no longer sees the original RGMII-*ID mode.
> 
> Solving the issue by splitting configuration in two parts can be handled
> in future patches, and would require retaining a backwards-compatibility
> mode anyway.
> 
> Fixes: bcf3440c6dd78bfe ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied to net-next, thank you.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 481A219E13F
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 01:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgDCXFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 19:05:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgDCXFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 19:05:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B547B121938E3;
        Fri,  3 Apr 2020 16:05:08 -0700 (PDT)
Date:   Fri, 03 Apr 2020 16:05:07 -0700 (PDT)
Message-Id: <20200403.160507.1105430274883121139.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        david@protonic.nl, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        philippe.schenker@toradex.com, linux@armlinux.org.uk
Subject: Re: [PATCH v1] net: phy: micrel: kszphy_resume(): add delay after
 genphy_resume() before accessing PHY registers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200403075325.10205-1-o.rempel@pengutronix.de>
References: <20200403075325.10205-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Apr 2020 16:05:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Fri,  3 Apr 2020 09:53:25 +0200

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

Applied and queued up for -stable, thank you.

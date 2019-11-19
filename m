Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E2D101066
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 01:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfKSA62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 19:58:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51926 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfKSA61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 19:58:27 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3231215048162;
        Mon, 18 Nov 2019 16:58:27 -0800 (PST)
Date:   Mon, 18 Nov 2019 16:58:26 -0800 (PST)
Message-Id: <20191118.165826.1141859219100186291.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: avoid matching all-ones clause 45
 PHY IDs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1iVhtV-0007hp-Ew@rmk-PC.armlinux.org.uk>
References: <E1iVhtV-0007hp-Ew@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 16:58:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Fri, 15 Nov 2019 20:08:37 +0000

> We currently match clause 45 PHYs using any ID read from a MMD marked
> as present in the "Devices in package" registers 5 and 6.  However,
> this is incorrect.  45.2 says:
> 
>   "The definition of the term package is vendor specific and could be
>    a chip, module, or other similar entity."
> 
> so a package could be more or less than the whole PHY - a PHY could be
> made up of several modules instantiated onto a single chip such as the
> Marvell 88x3310, or some of the MMDs could be disabled according to
> chip configuration, such as the Broadcom 84881.
> 
> In the case of Broadcom 84881, the "Devices in package" registers
> contain 0xc000009b, meaning that there is a PHYXS present in the
> package, but all registers in MMD 4 return 0xffff.  This leads to our
> matching code incorrectly binding this PHY to one of our generic PHY
> drivers.
> 
> This patch changes the way we determine whether to attempt to match a
> MMD identifier, or use it to request a module - if the identifier is
> all-ones, then we skip over it. When reading the identifiers, we
> initialise phydev->c45_ids.device_ids to all-ones, only reading the
> device ID if the "Devices in package" registers indicates we should.
> 
> This avoids the generic drivers incorrectly matching on a PHY ID of
> 0xffffffff.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thanks.

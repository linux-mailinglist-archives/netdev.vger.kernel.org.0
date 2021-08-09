Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEDA3E4753
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 16:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbhHIORC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 10:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbhHIORB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 10:17:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D958C0613D3;
        Mon,  9 Aug 2021 07:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=D8/i3ET5VXTfKdXr5AovFWuXvAt8S5q6TsZVbHBUl2o=; b=FQPqCuusjbdarU0d1SoXdE+fa
        m39+5zINzDSvd2bQ+DsNurZSMWxZjbl0/qqAqRoqCM7Hzu/A5cJUVK2DWuvUrKD2YXEX6Fw0ckKsz
        8kC8/mRzPslpsRZY+bVNNiFkTJZrTwFFOLDfv6svyxHxJ+gQRUirgy5/AHvP6AXAU0LP8FzCfZ9OA
        tkcXKfgzsRc5tsChWA03DgvAide/Y3sdERK/xJ/Am3UyTKsAi7MuRvwC6QjucrH6eJFKySy7Xfntg
        FjPtcseuYs5zqIJKR+qfKLeacRKdAsZtSTiS103lRZ/AdM2cU1LWFP74XmMU6F5k8wnaqLNgBV9Lx
        mRlYNPcYw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47114)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mD64x-0005ms-2v; Mon, 09 Aug 2021 15:16:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mD64v-0001FH-FO; Mon, 09 Aug 2021 15:16:33 +0100
Date:   Mon, 9 Aug 2021 15:16:33 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Ivan T. Ivanov" <iivanov@suse.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: leds: Trigger leds only if PHY speed is known
Message-ID: <20210809141633.GT22278@shell.armlinux.org.uk>
References: <20210716141142.12710-1-iivanov@suse.de>
 <YPGjnvB92ajEBKGJ@lunn.ch>
 <162646032060.16633.4902744414139431224@localhost>
 <20210719152942.GQ22278@shell.armlinux.org.uk>
 <162737250593.8289.392757192031571742@localhost>
 <162806599009.5748.14837844278631256325@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162806599009.5748.14837844278631256325@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 11:33:10AM +0300, Ivan T. Ivanov wrote:
> I have sent new patch[1] which I think is proper fix for this.
> 
> [1] https://lore.kernel.org/netdev/20210804081339.19909-1-iivanov@suse.de/T/#u

Thanks.

I haven't reviewed the driver, but the patch itself LGTM from the
point of view that phy_read_status() should definitely only be
called with phydev->lock held.

I think we also need the "Doing it all yourself" section in
Documentation/networking/phy.rst fixed to specify that if you
call this function, you must be holding phydev->lock.

Lastly, I'm wondering how many other places call phy_read_status()
without holding phydev->lock - sounds like something that needs a
kernel-wide review, and then possibly we should introduce a lockdep
check for this in phy_read_status() to catch any new introductions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

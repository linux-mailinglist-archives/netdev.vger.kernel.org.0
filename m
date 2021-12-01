Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C82F464400
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345855AbhLAAmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:42:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60636 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345842AbhLAAmj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 19:42:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=608yLKex6XYgV+g/m4R7ht8LzMMA5ClHN0ihJzPay4E=; b=eqc1n/z0ERx0FVdWXF0KvBKBOj
        QIncAsAjaXMecwZ1XG9uOlMGD3QQQCDEth1cFK/EbqEstavyoICzJUAi0acnU9GR9sobW4rIxID9y
        gydq3iHrW0GFWDRRc+gra468Dz2AvKi4pBXB/8hc9VSxjtpqFFEteI1cJGc2a3ocp0X4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msDe9-00F9tw-0y; Wed, 01 Dec 2021 01:38:53 +0100
Date:   Wed, 1 Dec 2021 01:38:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Yinbo Zhu <zhuyinbo@loongson.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled
 code in modules.alias
Message-ID: <YabEHd+Z5SPAhAT5@lunn.ch>
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
 <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
 <YaYPMOJ/+OXIWcnj@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaYPMOJ/+OXIWcnj@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> However, this won't work for PHY devices created _before_ the kernel
> has mounted the rootfs, whether or not they end up being used. So,
> every PHY mentioned in DT will be created before the rootfs is mounted,
> and none of these PHYs will have their modules loaded.

Hi Russell

I think what you are saying here is, if the MAC or MDIO bus driver is
built in, the PHY driver also needs to be built in?

If the MAC or MDIO bus driver is a module, it means the rootfs has
already been mounted in order to get these modules. And so the PHY
driver as a module will also work.

> I believe this is the root cause of Yinbo Zhu's issue.

You are speculating that in Yinbo Zhu case, the MAC driver is built
in, the PHY is a module. The initial request for the firmware fails.
Yinbo Zhu would like udev to try again later when the modules are
available.

> What we _could_ do is review all device trees and PHY drivers to see
> whether DT modaliases are ever used for module loading. If they aren't,
> then we _could_ make the modalias published by the kernel conditional
> on the type of mdio device - continue with the DT approach for non-PHY
> devices, and switch to the mdio: scheme for PHY devices. I repeat, this
> can only happen if no PHY drivers match using the DT scheme, otherwise
> making this change _will_ cause a regression.

Take a look at
drivers/net/mdio/of_mdio.c:whitelist_phys[] and the comment above it.

So there are some DT blobs out there with compatible strings for
PHYs. I've no idea if they actually load that way, or the standard PHY
mechanism is used.

	Andrew

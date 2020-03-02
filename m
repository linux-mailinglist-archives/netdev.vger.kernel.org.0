Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4971761B0
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 18:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgCBR6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 12:58:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41602 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgCBR6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 12:58:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WpKyjECZo9+0yn++WZklBBBgzh8mJlsrDow9rZ76U+g=; b=jAFV6CUd9CG7R8eUymfFUC9paF
        LGsEmsz7ZqdWXc74+tYuzstbQob+EonjVdUhEhyf7TdsqzFPCgCTU4KTRm7zJAvl/6E8/NmQznobL
        LGRUGTBqh816r0+9vGc3LNK06NzkQEO6m9PDjFVOMwC4oQZvYpmwbS7Rhrp2SZeyUtv0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j8pKJ-0007Ef-R8; Mon, 02 Mar 2020 18:57:59 +0100
Date:   Mon, 2 Mar 2020 18:57:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dajun Jin <adajunjin@gmail.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        frowand.list@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] drivers/of/of_mdio.c:fix of_mdiobus_register()
Message-ID: <20200302175759.GD24912@lunn.ch>
References: <20200301165018.GN6305@lunn.ch>
 <20200302172919.31425-1-adajunjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302172919.31425-1-adajunjin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dajun

> This is my test in Xilinx zcu106 board.
> 
> dts is liks this:
> ethernet@ff0e0000 {
>     compatible = "cdns,zynqmp-gem", "cdns,gem";
>     status = "okay";
>     ...
>     
>     phy@0 {
>         ti,rx-internal-delay = <0x8>;
>         ti,tx-internal-delay = <0xa>;
>         ti,fifo-depth = <0x1>;
>         ti,rxctrl-strap-worka;
>         linux,phandle = <0x12>;
>         phandle = <0x12>;
>     };
> };
> 
> then when borad is booting,the dmesg is like this:
> [    4.600035] mdio_bus ff0e0000.ethernet-ffffffff: /amba/ethernet@ff0e0000/phy@0 has invalid PHY address
> [    4.600050] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 0
> [    4.602076] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 1
> [    4.603849] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 2
> [    4.605574] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 4
> [    4.607312] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 5
> ...
> [    4.636155] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 28
> [    4.637335] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 29
> [    4.638504] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 30
> [    4.639666] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 31

For a single PHY without a reg properties, it should do the right
thing. But it will go wrong if there are multiple PHYs without reg
properties. In that case, the break helps.

However, as the comment suggests, you really should have a reg
property.

Please make the commit message better, and then i will give a
reviewed-by.

Thanks
	Andrew

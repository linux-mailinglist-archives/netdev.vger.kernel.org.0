Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5420654FC61
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 19:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383031AbiFQRmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 13:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383023AbiFQRmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 13:42:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B401262E;
        Fri, 17 Jun 2022 10:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=A8Lpm+VKx6UyD3nSKQXXVM+v4T9BhuK7cZwcj8Hlvag=; b=5pCs/wlhFz4VnuJiT/ZV3X6Ic8
        7LU9k/eme9ZquIsBOYJKfujtn/q1Z/ltq4gLEF+ZP6smKvgRGBdE0c5i9ZdpkqDPoirMZqaCnK57G
        XoTu0MGcSdHjSnJ9gC96w+efkRWQJA+MwBZbO9bsA3LEWwLL7feY6DmFVQnjd2YAI040=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o2Fz6-007KpD-0Z; Fri, 17 Jun 2022 19:42:16 +0200
Date:   Fri, 17 Jun 2022 19:42:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/1] net: phy: at803x: fix NULL pointer
 dereference on AR9331 PHY
Message-ID: <Yqy896zbieUEAD0E@lunn.ch>
References: <20220617045943.3618608-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617045943.3618608-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 06:59:43AM +0200, Oleksij Rempel wrote:
> Latest kernel will explode on the PHY interrupt config, since it depends
> now on allocated priv. So, run probe to allocate priv to fix it.
> 
>  ar9331_switch ethernet.1:10 lan0 (uninitialized): PHY [!ahb!ethernet@1a000000!mdio!switch@10:00] driver [Qualcomm Atheros AR9331 built-in PHY] (irq=13)
>  CPU 0 Unable to handle kernel paging request at virtual address 0000000a, epc == 8050e8a8, ra == 80504b34
>          ...
>  Call Trace:
>  [<8050e8a8>] at803x_config_intr+0x5c/0xd0
>  [<80504b34>] phy_request_interrupt+0xa8/0xd0
>  [<8050289c>] phylink_bringup_phy+0x2d8/0x3ac
>  [<80502b68>] phylink_fwnode_phy_connect+0x118/0x130
>  [<8074d8ec>] dsa_slave_create+0x270/0x420
>  [<80743b04>] dsa_port_setup+0x12c/0x148
>  [<8074580c>] dsa_register_switch+0xaf0/0xcc0
>  [<80511344>] ar9331_sw_probe+0x370/0x388
>  [<8050cb78>] mdio_probe+0x44/0x70
>  [<804df300>] really_probe+0x200/0x424
>  [<804df7b4>] __driver_probe_device+0x290/0x298
>  [<804df810>] driver_probe_device+0x54/0xe4
>  [<804dfd50>] __device_attach_driver+0xe4/0x130
>  [<804dcb00>] bus_for_each_drv+0xb4/0xd8
>  [<804dfac4>] __device_attach+0x104/0x1a4
>  [<804ddd24>] bus_probe_device+0x48/0xc4
>  [<804deb44>] deferred_probe_work_func+0xf0/0x10c
>  [<800a0ffc>] process_one_work+0x314/0x4d4
>  [<800a17fc>] worker_thread+0x2a4/0x354
>  [<800a9a54>] kthread+0x134/0x13c
>  [<8006306c>] ret_from_kernel_thread+0x14/0x1c
> 
> Same Issue would affect some other PHYs (QCA8081, QCA9561), so fix it
> too.
> 
> Fixes: 3265f4218878 ("net: phy: at803x: add fiber support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

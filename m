Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2E1644250
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbiLFLnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiLFLnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:43:08 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD30FB7F
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 03:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fn2994NVnPPwcrod3UljTzuyzolBUgmBvvsZZmE+6z4=; b=G4rogoF9o6dn/8+KueGYGow0Lx
        oi+MALkiLhBpaqck/Ls9DachjGvnDW1EC2DDWnevMm+AkmIwrjWFylOr1AUMuGHwQ5WIg4qKJfmMc
        G/riSZUVfXF621BAovi/Gzj34m/gtT1kmqWObttIxBv+m/cMIV3n8pmvniHFD0dvJ1LOiuLihknvg
        Y3+1fFYEzg0k/0UpLNeYolpm7QZZc8QAuKM9Q0R+mkJf42b4EDIFNgQAvAshP71nXiwU6x99/3BYK
        7YUrY/8yfxlostKAK6QWTrMAAhHn0Qy7RPCXaBlhmocyXOlsZ6jZkHYzqMLCKidaF8UOOV94nO1vL
        cLrp/KSQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35596)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p2WLZ-0007rl-P2; Tue, 06 Dec 2022 11:42:49 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p2WLM-0008Af-F9; Tue, 06 Dec 2022 11:42:36 +0000
Date:   Tue, 6 Dec 2022 11:42:36 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Zeng Heng <zengheng4@huawei.com>
Cc:     hkallweit1@gmail.com, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, liwei391@huawei.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: mdio: fix unbalanced fwnode reference count in
 mdio_device_release()
Message-ID: <Y48qrNjmRT7iIx1Z@shell.armlinux.org.uk>
References: <20221203073441.3885317-1-zengheng4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221203073441.3885317-1-zengheng4@huawei.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 03, 2022 at 03:34:41PM +0800, Zeng Heng wrote:
> There is warning report about of_node refcount leak
> while probing mdio device:
> 
> OF: ERROR: memory leak, expected refcount 1 instead of 2,
> of_node_get()/of_node_put() unbalanced - destroy cset entry:
> attach overlay node /spi/soc@0/mdio@710700c0/ethernet@4
> 
> In of_mdiobus_register_device(), we increase fwnode refcount
> by fwnode_handle_get() before associating the of_node with
> mdio device, but it has never been decreased in normal path.
> Since that, in mdio_device_release(), it needs to call
> fwnode_handle_put() in addition instead of calling kfree()
> directly.
> 
> After above, just calling mdio_device_free() in the error handle
> path of of_mdiobus_register_device() is enough to keep the
> refcount balanced.
> 
> Fixes: a9049e0c513c ("mdio: Add support for mdio drivers.")
> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Yang Yingliang <yangyingliang@huawei.com>

LGTM, thanks!

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

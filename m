Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0682865287A
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 22:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbiLTVjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 16:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiLTVjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 16:39:20 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1A413CEF;
        Tue, 20 Dec 2022 13:39:18 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 9A5241671;
        Tue, 20 Dec 2022 22:39:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1671572355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gJ8vPJvhmfQd+HsvkLEHJ78qftKzWXZ2mSV54HXT5wg=;
        b=I313p0n4IxiCSWvUmqw6tY2FxgeiJfjDq/2SbCCQu6aQPYPAwtC+6M3NMcFFCJ63F32UKZ
        4FpsWHE/QV69n8nWHgFvtVjZfleutHUEOcSL5uQMPqNk7+27v33EHQYyPM8B1CAAfnANul
        L8PUrHxGjewN6f4OuVWtBthvVm65v1WuyrEi+fCaal0BrcqpLQ50tKxBEZ1hZWL4FuVIYW
        xGBSf4t/9SxKXIX9N5l0RFhkzx6qSvpDNPgfHITOc/0rYCYXltX2KzUdsNGqKIsL9LXHFM
        Gss+xfl+bGyPrMiah9RzLYsWUuwgqgFRWuCVnl7mjdLERdlXwe3E2GNJWl9VdQ==
MIME-Version: 1.0
Date:   Tue, 20 Dec 2022 22:39:15 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/4] net: phy: mxl-gpy: disable interrupts on
 GPY215 by default
In-Reply-To: <Y6G5phSGSPk+7Dgj@lunn.ch>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-5-michael@walle.cc> <Y4pHCQrDbXXmOT+A@lunn.ch>
 <69e0468cf192455fd2dc7fc93194a8ff@walle.cc> <Y4uzYVSRiE9feD01@lunn.ch>
 <34dc81b01930e594ca4773ddb8c24160@walle.cc> <Y6G5phSGSPk+7Dgj@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <28c24c43a758fcbc0a648f676a6d7524@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-12-20 14:33, schrieb Andrew Lunn:
>> > > > I think a better place for this test is in gpy_config_intr(), return
>> > > > -EOPNOTSUPP. phy_enable_interrupts() failing should then cause
>> > > > phy_request_interrupt() to use polling.
>> > >
>> > > Which will then print a warning, which might be misleading.
>> > > Or we disable the warning if -EOPNOTSUPP is returned?
>> >
>> > Disabling the warning is the right thing to do.
>> 
>> There is more to this. .config_intr() is also used in
>> phy_init_hw() and phy_drv_supports_irq(). The latter would
>> still return true in our case. I'm not sure that is correct.
>> 
>> After trying your suggestion, I'm still in favor of somehow
>> tell the phy core to force polling mode during probe() of the
>> driver.
> 
> The problem is that the MAC can set the interrupt number after the PHY
> probe has been called. e.g.
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c#L524
> 
> The interrupt needs to be set by the time the PHY is connected to the
> MAC, which is often in the MAC open method, much later than the PHY
> probe.

Ok, then phydev->irq should be updated within the phy_attach_direct().
Something like the following:

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e865be3d7f01..c6c5830f5214 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1537,6 +1537,14 @@ int phy_attach_direct(struct net_device *dev, 
struct phy_device *phydev,

         phydev->interrupts = PHY_INTERRUPT_DISABLED;

+       /* PHYs can request to use poll mode even though they have an
+        * associated interrupt line. This could be the case if they
+        * detect a broken interrupt handling.
+        */
+       if (phydev->drv->force_polling_mode &&
+           phydev->drv->force_polling_mode(phydev))
+               phydev->irq = PHY_POLL;
+
         /* Port is set to PORT_TP by default and the actual PHY driver 
will set
          * it to different value depending on the PHY configuration. If 
we have
          * the generic PHY driver we can't figure it out, thus set the 
old

That callback could be too specifc, I don't know. We could also have
phydev->drv->pre_attach() which then can update the phydev->irq itself.

Btw. the phy_attached_info() in the stmmac seems to be a leftover
from before the phylink conversion. phylink will print a similar info
but when the PHY is actually attached.

-michael

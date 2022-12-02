Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E219F640DAE
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbiLBSog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbiLBSnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:43:46 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32F9E2ABF;
        Fri,  2 Dec 2022 10:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wYScWJRTbZ+Jo4q46g59cBC6C79TnJL57TW21p2LlK8=; b=XCrX21p1lFdgoWEka+Vo2zvWh2
        hv/4fOJtdJzFhbx4LVzVHc6UuOoMb3yFAcXdYusVQm06cH6/RxdZTWG482md+6crHUDhph/ElmTWp
        Hg1TArPDttvVQ4Xs/y0NTiSAcB5rKHw8TpTxO2gbopkIRb/3VR+xAXDHHDL+JlmmMjso=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1AzJ-004Cu4-3m; Fri, 02 Dec 2022 19:42:17 +0100
Date:   Fri, 2 Dec 2022 19:42:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
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
Message-ID: <Y4pHCQrDbXXmOT+A@lunn.ch>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-5-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202151204.3318592-5-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 04:12:04PM +0100, Michael Walle wrote:
> The interrupts on the GPY215B and GPY215C are broken and the only viable
> fix is to disable them altogether. There is still the possibilty to
> opt-in via the device tree.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/phy/mxl-gpy.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
> index 20e610dda891..edb8cd8313b0 100644
> --- a/drivers/net/phy/mxl-gpy.c
> +++ b/drivers/net/phy/mxl-gpy.c
> @@ -12,6 +12,7 @@
>  #include <linux/mutex.h>
>  #include <linux/phy.h>
>  #include <linux/polynomial.h>
> +#include <linux/property.h>
>  #include <linux/netdevice.h>
>  
>  /* PHY ID */
> @@ -290,6 +291,10 @@ static int gpy_probe(struct phy_device *phydev)
>  	phydev->priv = priv;
>  	mutex_init(&priv->mbox_lock);
>  
> +	if (gpy_has_broken_mdint(phydev) &&
> +	    !device_property_present(dev, "maxlinear,use-broken-interrupts"))
> +		phydev->irq = PHY_POLL;
> +

I'm not sure of ordering here. It could be phydev->irq is set after
probe. The IRQ is requested as part of phy_connect_direct(), which is
much later.

I think a better place for this test is in gpy_config_intr(), return
-EOPNOTSUPP. phy_enable_interrupts() failing should then cause
phy_request_interrupt() to use polling.

	Andrew

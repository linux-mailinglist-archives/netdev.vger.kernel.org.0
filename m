Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5CD4FB73E
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245581AbiDKJWx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 11 Apr 2022 05:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344147AbiDKJWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:22:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8B3329B8
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:20:08 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ndqD4-0003hy-BW; Mon, 11 Apr 2022 11:19:46 +0200
Received: from [2a0a:edc0:0:900:1d::4e] (helo=lupine)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ndqCz-002MLK-V5; Mon, 11 Apr 2022 11:19:40 +0200
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ndqCx-00040Q-Qs; Mon, 11 Apr 2022 11:19:39 +0200
Message-ID: <8470f6029703a29bd7c384f489da0c7936c44cc7.camel@pengutronix.de>
Subject: Re: [PATCH RESEND v3 2/3] net: mdio: add reset control for Aspeed
 MDIO
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Andrew Jeffery <andrew@aj.id.au>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Rob Herring <robh+dt@kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Cc:     BMC-SW@aspeedtech.com
Date:   Mon, 11 Apr 2022 11:19:39 +0200
In-Reply-To: <667280e7-526d-4002-9dff-389f6b35ac2f@www.fastmail.com>
References: <20220407075734.19644-1-dylan_hung@aspeedtech.com>
         <20220407075734.19644-3-dylan_hung@aspeedtech.com>
         <667280e7-526d-4002-9dff-389f6b35ac2f@www.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mo, 2022-04-11 at 09:50 +0930, Andrew Jeffery wrote:
> 
> On Thu, 7 Apr 2022, at 17:27, Dylan Hung wrote:
> > Add reset assertion/deassertion for Aspeed MDIO.  There are 4 MDIO
> > controllers embedded in Aspeed AST2600 SOC and share one reset control
> > register SCU50[3].  To work with old DT blobs which don't have the reset
> > property, devm_reset_control_get_optional_shared is used in this change.
> > 
> > Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> > Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/net/mdio/mdio-aspeed.c | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
> > index e2273588c75b..1afb58ccc524 100644
> > --- a/drivers/net/mdio/mdio-aspeed.c
> > +++ b/drivers/net/mdio/mdio-aspeed.c
> > @@ -3,6 +3,7 @@
> > 
> >  #include <linux/bitfield.h>
> >  #include <linux/delay.h>
> > +#include <linux/reset.h>
> >  #include <linux/iopoll.h>
> >  #include <linux/mdio.h>
> >  #include <linux/module.h>
> > @@ -37,6 +38,7 @@
> > 
> >  struct aspeed_mdio {
> >  	void __iomem *base;
> > +	struct reset_control *reset;
> >  };
> > 
> >  static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
> > @@ -120,6 +122,12 @@ static int aspeed_mdio_probe(struct platform_device *pdev)
> >  	if (IS_ERR(ctx->base))
> >  		return PTR_ERR(ctx->base);
> > 
> > +	ctx->reset = devm_reset_control_get_optional_shared(&pdev->dev, NULL);
> > +	if (IS_ERR(ctx->reset))
> > +		return PTR_ERR(ctx->reset);
> > +
> > +	reset_control_deassert(ctx->reset);
> > +
> >  	bus->name = DRV_NAME;
> >  	snprintf(bus->id, MII_BUS_ID_SIZE, "%s%d", pdev->name, pdev->id);
> >  	bus->parent = &pdev->dev;
> > @@ -129,6 +137,7 @@ static int aspeed_mdio_probe(struct platform_device *pdev)
> >  	rc = of_mdiobus_register(bus, pdev->dev.of_node);
> >  	if (rc) {
> >  		dev_err(&pdev->dev, "Cannot register MDIO bus!\n");
> > +		reset_control_assert(ctx->reset);
> >  		return rc;
> >  	}
> > 
> > @@ -139,7 +148,11 @@ static int aspeed_mdio_probe(struct platform_device *pdev)
> > 
> >  static int aspeed_mdio_remove(struct platform_device *pdev)
> >  {
> > -	mdiobus_unregister(platform_get_drvdata(pdev));
> > +	struct mii_bus *bus = (struct mii_bus *)platform_get_drvdata(pdev);
> > +	struct aspeed_mdio *ctx = bus->priv;
> > +
> > +	reset_control_assert(ctx->reset);
> 
> Isn't this unnecessary because you've used the devm_ variant to acquire 
> the reset?

No, this is correct. deassert/assert needs to be balanced, and the
reset_control_deassert() call in aspeed_mdio_probe() is not devres
managed.

regards
Philipp

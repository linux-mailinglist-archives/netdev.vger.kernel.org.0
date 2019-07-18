Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0DB6D24D
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 18:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390945AbfGRQr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 12:47:57 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57005 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbfGRQr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 12:47:57 -0400
Received: from kresse.hi.pengutronix.de ([2001:67c:670:100:1d::2a])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1ho9ZS-00060j-3f; Thu, 18 Jul 2019 18:47:54 +0200
Message-ID: <1563468471.2676.36.camel@pengutronix.de>
Subject: Re: [PATCH] net: fec: generate warning when using deprecated phy
 reset
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Sven Van Asbroeck <thesven73@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 18 Jul 2019 18:47:51 +0200
In-Reply-To: <20190718143428.2392-1-TheSven73@gmail.com>
References: <20190718143428.2392-1-TheSven73@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::2a
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Donnerstag, den 18.07.2019, 10:34 -0400 schrieb Sven Van Asbroeck:
> Allowing the fec to reset its PHY via the phy-reset-gpios
> devicetree property is deprecated. To improve developer
> awareness, generate a warning whenever the deprecated
> property is used.

Not really a fan of this. This will cause existing DTs, which are
provided by the firmware in an ideal world and may not change at the
same rate as the kernel, to generate a warning with new kernels. Not
really helpful from the user experience point of view.

Regards,
Lucas

> Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 38f10f7dcbc3..00e1b5e4ef71 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3244,6 +3244,12 @@ static int fec_reset_phy(struct platform_device *pdev)
> >  	else if (!gpio_is_valid(phy_reset))
> >  		return 0;
>  
> > +	/* Recommended way to provide a PHY reset:
> > +	 * - create a phy devicetree node, and link it to its fec (phy-handle)
> > +	 * - add your reset gpio to the phy devicetree node
> > +	 */
> > +	dev_warn(&pdev->dev, "devicetree: phy-reset-gpios is deprecated\n");
> +
> >  	err = of_property_read_u32(np, "phy-reset-post-delay", &phy_post_delay);
> >  	/* valid reset duration should be less than 1s */
> >  	if (!err && phy_post_delay > 1000)

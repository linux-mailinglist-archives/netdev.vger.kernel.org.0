Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA335519DB4
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 13:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348601AbiEDLRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 07:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348017AbiEDLRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 07:17:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC79E1570A
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 04:13:54 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nmCx5-0007x1-WD; Wed, 04 May 2022 13:13:52 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nmCx5-0000lH-72; Wed, 04 May 2022 13:13:51 +0200
Date:   Wed, 4 May 2022 13:13:51 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: imx6sx: Regression on FEC with KSZ8061
Message-ID: <20220504111351.GA2812@pengutronix.de>
References: <CAOMZO5BwYSgMZYHJcxV9bLcSQ2jjdFL47qr8o8FUj75z8SdhrQ@mail.gmail.com>
 <CAOMZO5AJRTfja47xGG6nzLdC7Bdr=r5K0FVCcgMvN05XSb7LhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOMZO5AJRTfja47xGG6nzLdC7Bdr=r5K0FVCcgMvN05XSb7LhA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:12:32 up 34 days, 23:42, 79 users,  load average: 0.19, 0.23,
 0.20
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 07:48:56AM -0300, Fabio Estevam wrote:
> On Wed, May 4, 2022 at 7:24 AM Fabio Estevam <festevam@gmail.com> wrote:
> >
> > Hi,
> >
> > On an imx6sx-based board, the Ethernet is functional on 5.10.
> >
> > The board has a KSZ8061 Ethernet PHY.
> >
> > After moving to kernel 5.15 or 5.17, the Ethernet is no longer functional:
> >
> > # udhcpc -i eth0
> > udhcpc: started, v1.35.0
> > 8<--- cut here ---
> > Unable to handle kernel NULL pointer dereference at virtual address 00000008
> > pgd = f73cef4e
> > [00000008] *pgd=00000000
> > Internal error: Oops: 5 [#1] SMP ARM
> > Modules linked in:
> > CPU: 0 PID: 196 Comm: ifconfig Not tainted 5.15.37-dirty #94
> > Hardware name: Freescale i.MX6 SoloX (Device Tree)
> > PC is at kszphy_config_reset+0x10/0x114
> 
> By adding this change, we can see that priv is NULL:
> 
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -508,8 +508,12 @@ static int kszphy_nand_tree_disable(struct phy_device *phyd
> ev)
>  /* Some config bits need to be set again on resume, handle them here. */
>  static int kszphy_config_reset(struct phy_device *phydev)
>  {
> -       struct kszphy_priv *priv = phydev->priv;
>         int ret;
> +       struct kszphy_priv *priv = phydev->priv;
> +       if (!priv) {
> +               pr_err("*********** priv is NULL\n");
> +               return -ENOMEM;
> +       }

Hm.. KSZ8061 do not calls probe, so priv is not allocated.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

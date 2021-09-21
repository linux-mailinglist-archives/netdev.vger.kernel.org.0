Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4802413603
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 17:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhIUPSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 11:18:46 -0400
Received: from ciao.gmane.io ([116.202.254.214]:38430 "EHLO ciao.gmane.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233821AbhIUPSp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 11:18:45 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2021 11:18:45 EDT
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <gl-netdev-2@m.gmane-mx.org>)
        id 1mShRP-0006tp-BD
        for netdev@vger.kernel.org; Tue, 21 Sep 2021 17:12:15 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Subject: Re: [net-next PATCH 1/1] drivers: net: dsa: qca8k: fix sgmii with some specific switch revision
Date:   Tue, 21 Sep 2021 18:02:30 +0300
Message-ID: <4p8p1i-pce.ln1@banana.localnet>
References: <20210920164745.30162-1-ansuelsmth@gmail.com> <20210920164745.30162-2-ansuelsmth@gmail.com>
User-Agent: tin/2.4.5-20201224 ("Glen Albyn") (Linux/5.10.0-8-armmp-lpae (armv7l))
Cc:     linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gmane.linux.network Ansuel Smith <ansuelsmth@gmail.com> wrote:
> Enable sgmii pll, tx driver and rx chain only on switch revision 1. This
> is not needed on later revision and with qca8327 cause the sgmii
> connection to not work at all. This is a case with some router that use
> the qca8327 switch and have the cpu port 0 using a sgmii connection.
> Without this, routers with this specific configuration won't work as the
> ports won't be able to communicate with the cpu port with the result of
> no traffic.

> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index bda5a9bf4f52..efeed8094865 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1227,8 +1227,14 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>                 if (ret)
>                         return;
>  
> -               val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
> -                       QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
> +               /* SGMII PLL, TX driver and RX chain is only needed in
> +                * switch revision 1, later revision doesn't need this.
> +                */
> +               if (priv->switch_revision == 1)
> +                       val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
> +                              QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
> +               else
> +                       val |= QCA8K_SGMII_EN_SD;
maybe better

+               val |= QCA8K_SGMII_EN_SD;
+               /* SGMII PLL, TX driver and RX chain is only needed in
+                * switch revision 1, later revision doesn't need this.
+                */
+               if (priv->switch_revision == 1)
+                       val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
+                              QCA8K_SGMII_EN_TX;

without else branch ?

>                 if (dsa_is_cpu_port(ds, port)) {
>                         /* CPU port, we're talking to the CPU MAC, be a PHY */



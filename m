Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4652373357
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhEEAyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:54:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53478 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhEEAyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 20:54:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1le5mg-002Z4j-Sp; Wed, 05 May 2021 02:53:02 +0200
Date:   Wed, 5 May 2021 02:53:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 10/20] net: dsa: qca8k: add priority
 tweak to qca8337 switch
Message-ID: <YJHsbsOFri8iHIcV@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-10-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-10-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 12:29:04AM +0200, Ansuel Smith wrote:
> The port 5 of the ar8337 have some problem in flood condition. The
> original legacy driver had some specific buffer and priority settings
> for the different port suggested by the QCA switch team. Add this
> missing settings to improve switch stability under load condition.
> The packet priority tweak and the rx delay is specific to qca8337.
> Limit this changes to qca8337 as now we also support 8327 switch.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 54 +++++++++++++++++++++++++++++++++++++++--
>  drivers/net/dsa/qca8k.h | 24 ++++++++++++++++++
>  2 files changed, 76 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 17c6fd4afa7d..9e034c445085 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -783,7 +783,12 @@ static int
>  qca8k_setup(struct dsa_switch *ds)
>  {
>  	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
> +	const struct qca8k_match_data *data;
>  	int ret, i;
> +	u32 mask;
> +
> +	/* get the switches ID from the compatible */
> +	data = of_device_get_match_data(priv->dev);

You have already done this once in probe. Either store data in qca8k_priv,
or add the id to qca8K_priv.

   Andrew   

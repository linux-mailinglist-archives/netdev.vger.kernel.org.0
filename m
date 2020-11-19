Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341CF2B88FF
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgKSAUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:20:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36908 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbgKSAUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:20:49 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfXgt-007pVA-MJ; Thu, 19 Nov 2020 01:20:47 +0100
Date:   Thu, 19 Nov 2020 01:20:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 05/11] net: dsa: microchip: ksz8795: use mib_cnt where
 possible
Message-ID: <20201119002047.GI1804098@lunn.ch>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-6-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220357.22292-6-m.grzeschik@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:03:51PM +0100, Michael Grzeschik wrote:
> The variable mib_cnt is assigned with TOTAL_SWITCH_COUNTER_NUM. This
> value can also be derived from the array size of mib_names. This patch
> uses this calculated value instead, removes the extra define and uses
> mib_cnt everywhere possible instead of the static define
> TOTAL_SWITCH_COUNTER_NUM.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz8795.c     | 8 ++++----
>  drivers/net/dsa/microchip/ksz8795_reg.h | 3 ---
>  2 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 04a571bde7e6a4f..6ddba2de2d3026e 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -23,7 +23,7 @@
>  
>  static const struct {
>  	char string[ETH_GSTRING_LEN];
> -} mib_names[TOTAL_SWITCH_COUNTER_NUM] = {
> +} mib_names[] = {
>  	{ "rx_hi" },
>  	{ "rx_undersize" },
>  	{ "rx_fragments" },
> @@ -656,7 +656,7 @@ static void ksz8795_get_strings(struct dsa_switch *ds, int port,
>  {
>  	int i;
>  
> -	for (i = 0; i < TOTAL_SWITCH_COUNTER_NUM; i++) {
> +	for (i = 0; i < dev->mib_cnt; i++) {
>  		memcpy(buf + i * ETH_GSTRING_LEN, mib_names[i].string,
>  		       ETH_GSTRING_LEN);
>  	}
> @@ -1236,7 +1236,7 @@ static int ksz8795_switch_init(struct ksz_device *dev)
>  	dev->port_mask |= dev->host_mask;
>  
>  	dev->reg_mib_cnt = KSZ8795_COUNTER_NUM;
> -	dev->mib_cnt = TOTAL_SWITCH_COUNTER_NUM;
> +	dev->mib_cnt = ARRAY_SIZE(mib_names);

Hi Michael

I think it would be better to just use ARRAY_SIZE(mib_names)
everywhere. It is one less hoop to jump through when looking for array
overruns, etc.

	Andrew

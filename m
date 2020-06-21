Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942E8202BC9
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 19:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgFURf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 13:35:26 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51339 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730454AbgFURfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 13:35:25 -0400
Received: from webmail.gandi.net (webmail21.sd4.0x35.net [10.200.201.21])
        (Authenticated sender: foss@0leil.net)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPA id E58781C0002;
        Sun, 21 Jun 2020 17:35:20 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 21 Jun 2020 19:35:20 +0200
From:   Quentin Schulz <foss@0leil.net>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v3 6/8] net: phy: mscc: timestamping and PHC
 support
In-Reply-To: <20200619122300.2510533-7-antoine.tenart@bootlin.com>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
 <20200619122300.2510533-7-antoine.tenart@bootlin.com>
Message-ID: <7520915d32e185d2ca29f085b988d55e@0leil.net>
X-Sender: foss@0leil.net
User-Agent: Roundcube Webmail/1.3.8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Antoine,

On 2020-06-19 14:22, Antoine Tenart wrote:
[...]
> @@ -999,9 +1553,35 @@ int vsc8584_ptp_probe(struct phy_device *phydev)
>  	if (!vsc8531->ptp)
>  		return -ENOMEM;
> 
> +	mutex_init(&vsc8531->phc_lock);
>  	mutex_init(&vsc8531->ts_lock);
> 
> +	/* Retrieve the shared load/save GPIO. Request it as non exclusive as
> +	 * the same GPIO can be requested by all the PHYs of the same 
> package.
> +	 * Ths GPIO must be used with the phc_lock taken (the lock is shared

Typo + wrong lock named in the comment, instead:

	 * This GPIO must be used with the gpio_lock taken (the lock is shared

Though technically both are taken when access to the GPIO is requested 
AFAICT.

Also on another note, maybe we could actually make vsc8531->base_addr be 
a part
of vsc85xx_shared_private structure.

We would still need to compute it to pass it to devm_phy_package_join 
but it can
easily be returned by vsc8584_get_base_addr instead of the current void 
and it'd
put all the things used for all PHYs in the package at the same place.

Thanks,
Quentin

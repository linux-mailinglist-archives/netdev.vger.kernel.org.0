Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C90226CFE8
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 02:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgIQAYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 20:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgIQAYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 20:24:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A07FC06178A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 17:24:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15C2613C7832A;
        Wed, 16 Sep 2020 17:07:45 -0700 (PDT)
Date:   Wed, 16 Sep 2020 17:24:31 -0700 (PDT)
Message-Id: <20200916.172431.1209926962987220938.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net 5/7] net: mscc: ocelot: error checking when calling
 ocelot_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915182229.69529-6-olteanv@gmail.com>
References: <20200915182229.69529-1-olteanv@gmail.com>
        <20200915182229.69529-6-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 16 Sep 2020 17:07:45 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 15 Sep 2020 21:22:27 +0300

> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index 99872f1b7460..91a915d0693f 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -1000,7 +1000,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
>  	ocelot->vcap = vsc7514_vcap_props;
>  
> -	ocelot_init(ocelot);
> +	err = ocelot_init(ocelot);
> +	if (err)
> +		return err;
> +

This also leaks the OF device 'ports' object.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72352584016
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiG1Nep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbiG1NeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:34:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02545C944;
        Thu, 28 Jul 2022 06:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vCqrvet6dCc77Cb9rHa2pnl3kSuxrb+8oqBck3Ux1rM=; b=j1vbRd+bJlXi7oFa0OXV58WTbG
        o3eDs/eq2AcqlDlD9q9epFFovpIID4QIJGj4p4uR8JnB7IALter7AEXG7WEkzjiNT1i+eUbxZQZcz
        /l4a+4IWlq7VyXRrSPD4P/ncILOBR82nTdOYQjmYP/ONsPMbl5xs0ekkqDd7iDd2/CpA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oH3eV-00BoC0-NC; Thu, 28 Jul 2022 15:34:11 +0200
Date:   Thu, 28 Jul 2022 15:34:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v1 1/1] net: dsa: microchip: KSZ9893: do not write to
 not supported Output Clock Control Register
Message-ID: <YuKQU1tqn9jWwtTb@lunn.ch>
References: <20220728131852.41518-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728131852.41518-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 03:18:52PM +0200, Oleksij Rempel wrote:
> KSZ9893 compatible chips do not have "Output Clock Control Register 0x0103".
> So, avoid writing to it.
> 
> Fixes: 462d525018f0 ("net: dsa: microchip: move ksz_chip_data to ksz_common")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz9477.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 5dff6c3279bb..c73bb6d383ad 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -198,6 +198,10 @@ int ksz9477_reset_switch(struct ksz_device *dev)
>  	ksz_write32(dev, REG_SW_PORT_INT_MASK__4, 0x7F);
>  	ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);
>  
> +	/* KSZ9893 compatible chips do not support refclk configuration */
> +	if (dev->chip_id == KSZ9893_CHIP_ID)
> +		return 0;
> +

Do you actually want to return -EINVAL? I assume this is being driven
by a DT property? And that property is not valid for this chip. So we
want to let the DT writer know. Question is, is there a backwards
compatibility issue? If this has always been silently ignored, and
there are DT with this property, do we want to break them.

      Andrew

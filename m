Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E8D583FEC
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbiG1NZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbiG1NZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:25:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECB732045;
        Thu, 28 Jul 2022 06:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=peZ+13VgmLg1pDFTO+fq8ryBpDliOWbSHN81NMjexw0=; b=ORrgfgodViWK5Uxl3mST9lVpLX
        zJlKUu7oAHHRWhZH9i7vAj0jgfPeaXdtw7TWdHF6x7akxEFQ/0l+u1uJE1e2ydfT1MSahrOtiKQwC
        g7bKpUgQxfCqt5CJkSSoLc1KW5/jcE9HfnFXRDip/YFfsaCRSjCkPqaB6VrJZHEG9mfs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oH3WB-00Bo9r-QO; Thu, 28 Jul 2022 15:25:35 +0200
Date:   Thu, 28 Jul 2022 15:25:35 +0200
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
Subject: Re: [PATCH net v1 1/1] net: dsa: microchip: don't try do read Gbit
 registers on non Gbit chips
Message-ID: <YuKOTzS89D2+O8Ye@lunn.ch>
References: <20220728131725.40492-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728131725.40492-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 03:17:25PM +0200, Oleksij Rempel wrote:
> Do not try to read not existing or wrong register on chips without
> GBIT_SUPPORT.
> 
> Fixes: c2e866911e25 ("net: dsa: microchip: break KSZ9477 DSA driver into two files")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz9477.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index c73bb6d383ad..f6bbd9646c85 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -316,7 +316,13 @@ void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
>  			break;
>  		}
>  	} else {
> -		ksz_pread16(dev, addr, 0x100 + (reg << 1), &val);
> +		/* No gigabit support.  Do not read wrong registers. */
> +		if (!(dev->features & GBIT_SUPPORT) &&
> +		    (reg == MII_CTRL1000 || reg == MII_ESTATUS ||
> +		     reg == MII_STAT1000))

Does this actually happen?

If i remember this code correctly, it tries to make the oddly looking
PHY look like a normal PHY. phylib is then used to drive the PHY?

If i have that correct, why is phylib trying to read these registers?
It should know there is no 1G support, and should skip them.

   Andrew

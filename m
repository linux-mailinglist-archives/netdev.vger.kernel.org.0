Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B14629A0E
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 16:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391663AbfEXO1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 10:27:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56108 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390885AbfEXO1c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 10:27:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Qg8YPqC0sLWiiM2apj3tRNk0cAK9VGI3Riy94bmfmbk=; b=NH9RDoNq1BbwA3D+/zz9k9LOFC
        HaPaDOrD60MJ7EjI/YPI7N2i2XgqptON4aeWgXA1l9aqzwW5VC75rEz3KMQAzpdTpjwgfNHTLJlqI
        Wwa58E47QFJAFtiSYhkYhkCAxLzdU80uaQE4922ZLA8DuZ2cOmxtA9HgRkBPyHX8Cfko=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hUBAO-0001b5-N0; Fri, 24 May 2019 16:27:28 +0200
Date:   Fri, 24 May 2019 16:27:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] net: dsa: add support for mv88e6250
Message-ID: <20190524142728.GL2979@lunn.ch>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-6-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524085921.11108-6-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -4841,6 +4910,10 @@ static const struct of_device_id mv88e6xxx_of_match[] = {
>  		.compatible = "marvell,mv88e6190",
>  		.data = &mv88e6xxx_table[MV88E6190],
>  	},
> +	{
> +		.compatible = "marvell,mv88e6250",
> +		.data = &mv88e6xxx_table[MV88E6250],
> +	},
>  	{ /* sentinel */ },
>  };

Ah, yes. I had not thought about that. A device at address 0 would be
found, but a device at address 16 would be missed.

Please add this compatible string to Documentation/devicetree/bindings/net/dsa/marvell.txt 

> +++ b/drivers/net/dsa/mv88e6xxx/global1.c
> @@ -182,6 +182,25 @@ int mv88e6185_g1_reset(struct mv88e6xxx_chip *chip)
>  	return mv88e6185_g1_wait_ppu_polling(chip);
>  }
>  
> +int mv88e6250_g1_reset(struct mv88e6xxx_chip *chip)
> +{
> +	u16 val;
> +	int err;
> +
> +	/* Set the SWReset bit 15 */
> +	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_CTL1, &val);
> +	if (err)
> +		return err;
> +
> +	val |= MV88E6XXX_G1_CTL1_SW_RESET;
> +
> +	err = mv88e6xxx_g1_write(chip, MV88E6XXX_G1_CTL1, val);
> +	if (err)
> +		return err;
> +
> +	return mv88e6xxx_g1_wait_init_ready(chip);
> +}

It looks like you could refactor mv88e6352_g1_reset() to call
this function, and then mv88e6352_g1_wait_ppu_polling(chip);

Otherwise, this looks good.

   Andrew

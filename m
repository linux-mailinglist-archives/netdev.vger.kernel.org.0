Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEBB598404
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245007AbiHRNVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244983AbiHRNVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:21:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A67B02BE
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9cGh2ER/Au3/OZvvPSLcccIUklh8624t9m45GnAToNQ=; b=LN7NBjrOVJmqpxBv7rqd574Yzk
        Rc8//iHpGxPIK1FuUvkMzpsAXEWnhh4D42slt4tSu5Be5fE4MRcwZ1afp7duFy3VBQjlnv8R4r1RJ
        yz6HC1XJqlTIGe2NVV+GreMwi8oVmpRgcG3S0LhUhAu8etM/mB8cwhcEqHT7TmLmEdp0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOfSw-00DkCT-NU; Thu, 18 Aug 2022 15:21:42 +0200
Date:   Thu, 18 Aug 2022 15:21:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC net-next PATCH 2/3] mv88e6xxx: Implement remote management
 support (RMU)
Message-ID: <Yv485js8cFGZapIQ@lunn.ch>
References: <20220818102924.287719-1-mattias.forsblad@gmail.com>
 <20220818102924.287719-3-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818102924.287719-3-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
>  {
> +	int ret = 0;
> +
>  	if (chip->info->ops->rmu_disable)
> -		return chip->info->ops->rmu_disable(chip);
> +		ret = chip->info->ops->rmu_disable(chip);
>  
> -	return 0;
> +	if (chip->info->ops->rmu_enable) {
> +		ret += chip->info->ops->rmu_enable(chip);
> +		ret += mv88e6xxx_rmu_init(chip);

EINVAL + EOPNOTSUPP = hard to find error code/bug.

I've not looked at rmu_enable() yet, but there are restrictions about
what ports can be used with RMU. So you have to assume some boards use
the wrong port for the CPU or upstream DSA port, and so will need to
return an error code. But such an error code should not be fatal, MDIO
can still be used.

> +	}
> +
> +	return ret;
>  }
>  
> +int mv88e6085_g1_rmu_enable(struct mv88e6xxx_chip *chip)
> +{
> +	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
> +	int upstream_port = -1;
> +
> +	upstream_port = dsa_switch_upstream_port(chip->ds);
> +	dev_err(chip->dev, "RMU: Enabling on port %d", upstream_port);

dev_dbg()

> +	if (upstream_port < 0)
> +		return -1;

EOPNOTSUPP.

> +
> +	switch (upstream_port) {
> +	case 9:
> +		val = MV88E6085_G1_CTL2_RM_ENABLE;
> +		break;
> +	case 10:
> +		val = MV88E6085_G1_CTL2_RM_ENABLE | MV88E6085_G1_CTL2_P10RM;
> +		break;

Does 6085 really have 10 ports? It does!

> +	default:
> +		break;

return -EOPNOTSUPP.

> +	}
> +
> +	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6085_G1_CTL2_P10RM |
> +				      MV88E6085_G1_CTL2_RM_ENABLE, val);
> +}
> +
>  int mv88e6352_g1_rmu_disable(struct mv88e6xxx_chip *chip)
>  {
>  	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6352_G1_CTL2_RMU_MODE_MASK,
>  				      MV88E6352_G1_CTL2_RMU_MODE_DISABLED);
>  }
>  
> +int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip)
> +{
> +	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
> +	int upstream_port;
> +
> +	upstream_port = dsa_switch_upstream_port(chip->ds);
> +	dev_err(chip->dev, "RMU: Enabling on port %d", upstream_port);
> +	if (upstream_port < 0)
> +		return -1;
> +
> +	switch (upstream_port) {
> +	case 4:
> +		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_4;
> +		break;
> +	case 5:
> +		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_5;
> +		break;
> +	case 6:
> +		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_6;
> +		break;
> +	default:
> +		break;

Same comments as above.


> diff --git a/drivers/net/dsa/mv88e6xxx/rmu.c b/drivers/net/dsa/mv88e6xxx/rmu.c
> new file mode 100644
> index 000000000000..ac68eef12521
> --- /dev/null
> +++ b/drivers/net/dsa/mv88e6xxx/rmu.c
> @@ -0,0 +1,256 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Marvell 88E6xxx Switch Remote Management Unit Support
> + *
> + * Copyright (c) 2022 Mattias Forsblad <mattias.forsblad@gmail.com>
> + *
> + */
> +
> +#include "rmu.h"
> +#include "global1.h"
> +
> +#define MAX_RMON 64
> +#define RMON_REPLY 2
> +
> +#define RMU_REQ_GET_ID                 1
> +#define RMU_REQ_DUMP_MIB               2
> +
> +#define RMU_RESP_FORMAT_1              0x0001
> +#define RMU_RESP_FORMAT_2              0x0002
> +
> +#define RMU_RESP_CODE_GOT_ID           0x0000
> +#define RMU_RESP_CODE_DUMP_MIB         0x1020

These should all go into rmu.h. Please also follow the naming
convention, add the MV88E6XXX_ prefix.


> +
> +int mv88e6xxx_inband_rcv(struct dsa_switch *ds, struct sk_buff *skb, int seq_no)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct mv88e6xxx_port *port;
> +	__be16 *prodnum;
> +	__be16 *format;
> +	__be16 *code;
> +	__be32 *mib_data;
> +	u8 pkt_dev;
> +	u8 pkt_prt;
> +	int i;

Reverse christmass tree.

> +
> +	if (!skb || !chip)
> +		return 0;

We generally don't do this sort of defensive programming. Can these be
NULL?

> +
> +	/* Extract response data */
> +	format = (__be16 *)&skb->data[0];

You have no idea of the alignment of data, so you should not cast it
to a pointer type and dereference it. Take a look at the unaligned
helpers.

> +	if (*format != htons(RMU_RESP_FORMAT_1) && (*format != htons(RMU_RESP_FORMAT_2))) {
> +		dev_err(chip->dev, "RMU: received unknown format 0x%04x", *format);

rate limit all error messages please.

> +		goto out;
> +	}
> +
> +	code = (__be16 *)&skb->data[4];
> +	if (*code == ntohs(0xffff)) {
> +		netdev_err(skb->dev, "RMU: error response code 0x%04x", *code);
> +		goto out;
> +	}
> +
> +	pkt_dev = skb->data[6] & 0x1f;

Please replace all these magic numbers with #define in rmu.h.

> +	if (pkt_dev >= DSA_MAX_SWITCHES) {
> +		netdev_err(skb->dev, "RMU: response from unknown chip %d\n", *code);
> +		goto out;
> +	}

That is a good first step, but it is not sufficient to prove the
switch actually exists.

> +
> +	/* Check sequence number */
> +	if (seq_no != chip->rmu.seq_no) {
> +		netdev_err(skb->dev, "RMU: wrong seqno received %d, expected %d",
> +			   seq_no, chip->rmu.seq_no);
> +		goto out;
> +	}
> +
> +	/* Check response code */
> +	switch (chip->rmu.request_cmd) {

Maybe a non-issue, i've not looked hard enough: What is the
relationship between ds passed to this function and pkt_dev? Does ds
belong to pkt_dev, or is ds the chip connected to the host? There are
a few boards with multiple chip in a tree, so we need to get this
mapping correct. This is something i can test sometime later, i have
such boards.

> +	case RMU_REQ_GET_ID: {
> +		if (*code == RMU_RESP_CODE_GOT_ID) {
> +			prodnum = (__be16 *)&skb->data[2];
> +			chip->rmu.got_id = *prodnum;
> +			dev_info(chip->dev, "RMU: received id OK with product number: 0x%04x\n",
> +				 chip->rmu.got_id);
> +		} else {
> +			dev_err(chip->dev,
> +				"RMU: unknown response for GET_ID format 0x%04x code 0x%04x",
> +				*format, *code);
> +		}
> +		break;
> +	}
> +	case RMU_REQ_DUMP_MIB:
> +		if (*code == RMU_RESP_CODE_DUMP_MIB) {
> +			pkt_prt = (skb->data[7] & 0x78) >> 3;
> +			mib_data = (__be32 *)&skb->data[12];
> +			port = &chip->ports[pkt_prt];
> +			if (!port) {
> +				dev_err(chip->dev, "RMU: illegal port number in response: %d\n",
> +					pkt_prt);
> +				goto out;
> +			}
> +
> +			/* Copy whole array for further
> +			 * processing according to chip type
> +			 */
> +			for (i = 0; i < MAX_RMON; i++)
> +				port->rmu_raw_stats[i] = mib_data[i];

This needs some more thought, which i don't have time for right now.

     Andrew

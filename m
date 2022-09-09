Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7819F5B2BB1
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 03:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiIIBgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 21:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiIIBgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 21:36:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26419C8CF
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 18:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+oLShqtOajXShJ0Jbs2uhU1yRkUaNfAMrAQhdrdX3Bo=; b=QxLnf9x5+Y2Kq3N3pcI/7m4U0G
        7kHORB4ucNf9NGQzC+lVkO4ZNFPh1w/A1vMjm8GPIMhBV4DxI19ewQ1fpOnzzXN8/NCV6aQIMTwCQ
        jgMTedG3H93CTM46PTawBRQzeRqswYJjPNt+wJYKfNCGH0IaVVjUYTs7DqkMpbRmK40Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oWSwI-00G1xe-Dx; Fri, 09 Sep 2022 03:36:14 +0200
Date:   Fri, 9 Sep 2022 03:36:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v7 4/6] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Message-ID: <YxqYjoZeGhYIZ29b@lunn.ch>
References: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
 <20220908132109.3213080-5-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908132109.3213080-5-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -410,6 +422,9 @@ struct mv88e6xxx_chip {
>  
>  	/* Bridge MST to SID mappings */
>  	struct list_head msts;
> +
> +	/* RMU resources */
> +	struct mv88e6xxx_rmu rmu;
>  };
>  
>  struct mv88e6xxx_bus_ops {
> @@ -805,4 +820,8 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
>  
>  int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap);
>  
> +static inline bool mv88e6xxx_rmu_available(struct mv88e6xxx_chip *chip)
> +{
> +	return chip->rmu.master_netdev ? 1 : 0;
> +}
>  #endif /* _MV88E6XXX_CHIP_H */
> diff --git a/drivers/net/dsa/mv88e6xxx/rmu.c b/drivers/net/dsa/mv88e6xxx/rmu.c
> new file mode 100644
> index 000000000000..00526972014b
> --- /dev/null
> +++ b/drivers/net/dsa/mv88e6xxx/rmu.c
> @@ -0,0 +1,353 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Marvell 88E6xxx Switch Remote Management Unit Support
> + *
> + * Copyright (c) 2022 Mattias Forsblad <mattias.forsblad@gmail.com>
> + *
> + */
> +
> +#include <asm/unaligned.h>
> +#include "rmu.h"
> +#include "global1.h"
> +
> +#define MV88E6XXX_DSA_HLEN	4
> +
> +#define MV88E6XXX_RMU_MAX_RMON			64
> +
> +#define MV88E6XXX_RMU_WAIT_TIME_MS		20
> +
> +static const u8 rmu_dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };
> +
> +#define MV88E6XXX_RMU_L2_BYTE1_RESV_VAL		0x3e
> +#define MV88E6XXX_RMU				1
> +#define MV88E6XXX_RMU_PRIO			6
> +#define MV88E6XXX_RMU_RESV2			0xf
> +
> +#define MV88E6XXX_SOURCE_PORT			GENMASK(6, 3)
> +#define MV88E6XXX_SOURCE_DEV			GENMASK(5, 0)
> +#define MV88E6XXX_CPU_CODE_MASK			GENMASK(7, 6)
> +#define MV88E6XXX_TRG_DEV_MASK			GENMASK(4, 0)
> +#define MV88E6XXX_RMU_CODE_MASK			GENMASK(1, 1)
> +#define MV88E6XXX_RMU_PRIO_MASK			GENMASK(7, 5)
> +#define MV88E6XXX_RMU_L2_BYTE1_RESV		GENMASK(7, 2)
> +#define MV88E6XXX_RMU_L2_BYTE2_RESV		GENMASK(3, 0)
> +
> +#define MV88E6XXX_RMU_REQ_GET_ID		1
> +#define MV88E6XXX_RMU_REQ_DUMP_MIB		2
> +
> +#define MV88E6XXX_RMU_REQ_FORMAT_GET_ID		0x0000
> +#define MV88E6XXX_RMU_REQ_FORMAT_SOHO		0x0001
> +#define MV88E6XXX_RMU_REQ_PAD			0x0000
> +#define MV88E6XXX_RMU_REQ_CODE_GET_ID		0x0000
> +#define MV88E6XXX_RMU_REQ_CODE_DUMP_MIB		0x1020
> +#define MV88E6XXX_RMU_REQ_DATA			0x0000
> +
> +#define MV88E6XXX_RMU_REQ_DUMP_MIB_PORT_MASK	GENMASK(4, 0)
> +
> +#define MV88E6XXX_RMU_RESP_FORMAT_1		0x0001
> +#define MV88E6XXX_RMU_RESP_FORMAT_2		0x0002
> +#define MV88E6XXX_RMU_RESP_ERROR		0xffff
> +
> +#define MV88E6XXX_RMU_RESP_CODE_GOT_ID		0x0000
> +#define MV88E6XXX_RMU_RESP_CODE_DUMP_MIB	0x1020
> +
> +struct rmu_header {
> +	u16 format;
> +	u16 prodnr;
> +	u16 code;
> +} __packed;
> +
> +struct dump_mib_resp {
> +	struct rmu_header rmu_header;
> +	u8 devnum;
> +	u8 portnum;
> +	u32 timestamp;
> +	u32 mib[MV88E6XXX_RMU_MAX_RMON];
> +} __packed;

I would mode all the #defines at least into rmu.h. If you look at the
other .c files, few have any #defines in them, all the registers
definitions are in the .h file.

> +static int mv88e6xxx_rmu_send_wait(struct mv88e6xxx_chip *chip, int port,
> +				   const char *req, int req_len,
> +				   char *resp, unsigned int resp_len)

If you make these void *, not char * ....

> +	ret = mv88e6xxx_rmu_send_wait(chip, port, (const char *)req, sizeof(req),
> +				      (char *)&resp, sizeof(resp));

you can avoid the casts here.

> +{
> +	struct dsa_port *dp;
> +	struct sk_buff *skb;
> +	unsigned char *data;
> +	unsigned int len;
> +	int ret = 0;
> +
> +	dp = dsa_to_port(chip->ds, port);
> +	if (!dp)
> +		return 0;

-EINVAL ?

> +
> +	skb = netdev_alloc_skb(chip->rmu.master_netdev, 64);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	/* Take height for an eventual EDSA header */
> +	skb_reserve(skb, 2 * ETH_HLEN + 4);
> +	skb_reset_network_header(skb);
> +
> +	/* Insert RMU request message */
> +	data = skb_put(skb, req_len);
> +	memcpy(data, req, req_len);
> +
> +	mv88e6xxx_rmu_create_l2(skb, dp);
> +
> +	mutex_lock(&chip->rmu.mutex);
> +
> +	ret = dsa_switch_inband_tx(dp->ds, skb, NULL, MV88E6XXX_RMU_WAIT_TIME_MS);
> +	if (ret < 0)
> +		dev_err(chip->dev, "RMU: timeout waiting for request (%pe) on port %d\n",
> +			ERR_PTR(ret), port);
> +
> +	len = min(resp_len, chip->rmu.resp->len);
> +	memcpy(resp, chip->rmu.resp->data, len);

Are you sure it is safe to do this when dsa_switch_inband_tx()
returned an error. It is probably better to have a goto out; to jump
over the copy.

The min can also result in problems. There has been issues in USB
recently where a combination of a fuzzer and checker for accessing
uninitialized memory has shown problems in code this like. Say the
called expects there to be 16 bytes as response, but the packet only
contains 6. If it does not check the actual number of bytes returned,
it can go off the end of what was actually received and start
interpreting junk.

So if chip->rmu.resp->len < resp_len when i would return -EMSGSIZE.

That should result in safer code.

If chip->rmu.resp->len > resp_len then just copy as many bytes are
requested.

> +	kfree_skb(chip->rmu.resp);
> +	chip->rmu.resp = NULL;
> +
> +	mutex_unlock(&chip->rmu.mutex);
> +
> +	return ret > 0 ? 0 : ret;
> +}
> +
> +static int mv88e6xxx_rmu_get_id(struct mv88e6xxx_chip *chip, int port)
> +{
> +	const u16 req[4] = { MV88E6XXX_RMU_REQ_FORMAT_GET_ID,
> +			     MV88E6XXX_RMU_REQ_PAD,
> +			     MV88E6XXX_RMU_REQ_CODE_GET_ID,
> +			     MV88E6XXX_RMU_REQ_DATA};
> +	struct rmu_header resp;
> +	int ret = -1;
> +	u16 format;
> +	u16 code;
> +
> +	ret = mv88e6xxx_rmu_send_wait(chip, port, (const char *)req, sizeof(req),
> +				      (char *)&resp, sizeof(resp));
> +	if (ret) {
> +		dev_dbg(chip->dev, "RMU: error for command GET_ID %pe\n", ERR_PTR(ret));
> +		return ret;
> +	}
> +
> +	/* Got response */
> +	format = get_unaligned_be16(&resp.format);
> +	code = get_unaligned_be16(&resp.code);

You don't need get_unaligned_be16() etc here, because resp is a stack
variable, it is guaranteed to be aligned. You only need to use these
helpers when you have no idea about alignment, like data in an skb.

> +
> +	if (format != MV88E6XXX_RMU_RESP_FORMAT_1 &&
> +	    format != MV88E6XXX_RMU_RESP_FORMAT_2 &&
> +	    code != MV88E6XXX_RMU_RESP_CODE_GOT_ID) {
> +		net_dbg_ratelimited("RMU: received unknown format 0x%04x code 0x%04x",
> +				    format, code);
> +		return -EIO;
> +	}
> +
> +	chip->rmu.prodnr = get_unaligned_be16(&resp.prodnr);
> +
> +	return 0;
> +}
> +
> +static void mv88e6xxx_rmu_stats_get(struct mv88e6xxx_chip *chip, int port, uint64_t *data)

I would split this into a separate patch. Add the core RMU handling in
one patch, and then add users of it one patch at a time. There is too
much going on in this patch, and it is not obviously correct.

> +{
> +	u16 req[4] = { MV88E6XXX_RMU_REQ_FORMAT_SOHO,
> +		       MV88E6XXX_RMU_REQ_PAD,
> +		       MV88E6XXX_RMU_REQ_CODE_DUMP_MIB,
> +		       MV88E6XXX_RMU_REQ_DATA};
> +	struct dump_mib_resp resp;
> +	struct mv88e6xxx_port *p;
> +	u8 resp_port;
> +	u16 format;
> +	u16 code;
> +	int ret;
> +	int i;
> +
> +	/* Populate port number in request */
> +	req[3] = FIELD_PREP(MV88E6XXX_RMU_REQ_DUMP_MIB_PORT_MASK, port);
> +
> +	ret = mv88e6xxx_rmu_send_wait(chip, port, (const char *)req, sizeof(req),
> +				      (char *)&resp, sizeof(resp));
> +	if (ret) {
> +		dev_dbg(chip->dev, "RMU: error for command DUMP_MIB %pe port %d\n",
> +			ERR_PTR(ret), port);
> +		return;
> +	}

I'm surprised this is a void function, since mv88e6xxx_rmu_send_wait()
etc can return an error.

> +	for (i = 0; i < MV88E6XXX_RMU_MAX_RMON; i++)
> +		p->rmu_raw_stats[i] = get_unaligned_be32(&resp.mib[i]);
> +
> +	/* Update MIB for port */
> +	if (chip->info->ops->stats_get_stats)
> +		chip->info->ops->stats_get_stats(chip, port, data);
> +}
> +
> +void mv88e6xxx_master_change(struct dsa_switch *ds, const struct net_device *master,
> +			     bool operational)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct dsa_port *cpu_dp;
> +	int port;
> +	int ret;
> +
> +	cpu_dp = master->dsa_ptr;
> +	port = dsa_towards_port(ds, cpu_dp->ds->index, cpu_dp->index);
> +
> +	mv88e6xxx_reg_lock(chip);
> +
> +	if (operational && chip->info->ops->rmu_enable) {
> +		if (!chip->info->ops->rmu_enable(chip, port)) {

You should probably differentiate on the error here. -EOPNOTSUPP you
want to handle different to other errors, which are fatal.

> +			dev_dbg(chip->dev, "RMU: Enabled on port %d", port);
> +			chip->rmu.master_netdev = (struct net_device *)master;
> +
> +			/* Check if chip is alive */
> +			ret = mv88e6xxx_rmu_get_id(chip, port);
> +			if (!ret)
> +				goto out;
> +
> +			chip->smi_ops = chip->rmu.rmu_ops;
> +
> +		} else {
> +			dev_err(chip->dev, "RMU: Unable to enable on port %d", port);

Don't you need a goto out; here?

> +		}
> +	}
> +
> +	chip->smi_ops = chip->rmu.smi_ops;
> +	chip->rmu.master_netdev = NULL;
> +	if (chip->info->ops->rmu_disable)
> +		chip->info->ops->rmu_disable(chip);

I would probably pull this function apart, break it up into helpers,
to make the flow simpler.

> +
> +out:
> +	mv88e6xxx_reg_unlock(chip);
> +}
> +
> +static int mv88e6xxx_validate_mac(struct dsa_switch *ds, struct sk_buff *skb)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	unsigned char *ethhdr;
> +
> +	/* Check matching MAC */
> +	ethhdr = skb_mac_header(skb);
> +	if (!ether_addr_equal(chip->rmu.master_netdev->dev_addr, ethhdr)) {
> +		dev_dbg_ratelimited(ds->dev, "RMU: mismatching MAC address for request. Rx %pM expecting %pM\n",
> +				    ethhdr, chip->rmu.master_netdev->dev_addr);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +void mv88e6xxx_decode_frame2reg_handler(struct net_device *dev, struct sk_buff *skb)
> +{
> +	struct dsa_port *dp = dev->dsa_ptr;
> +	struct dsa_switch *ds = dp->ds;
> +	struct mv88e6xxx_chip *chip;
> +	int source_device;
> +	u8 *dsa_header;
> +	u8 seqno;
> +
> +	/* Decode Frame2Reg DSA portion */
> +	dsa_header = skb->data - 2;
> +
> +	source_device = FIELD_GET(MV88E6XXX_SOURCE_DEV, dsa_header[0]);
> +	ds = dsa_switch_find(ds->dst->index, source_device);
> +	if (!ds) {
> +		net_err_ratelimited("RMU: Didn't find switch with index %d", source_device);
> +		return;
> +	}
> +
> +	if (mv88e6xxx_validate_mac(ds, skb))
> +		return;
> +
> +	chip = ds->priv;
> +	seqno = dsa_header[3];
> +	if (seqno != chip->rmu.seqno) {
> +		net_err_ratelimited("RMU: wrong seqno received. Was %d, expected %d",
> +				    seqno, chip->rmu.seqno);
> +		return;
> +	}
> +
> +	/* Pull DSA L2 data */
> +	skb_pull(skb, MV88E6XXX_DSA_HLEN);
> +
> +	/* Make an copy for further processing in initiator */
> +	chip->rmu.resp = skb_copy(skb, GFP_ATOMIC);
> +	if (!chip->rmu.resp)
> +		return;

I think this should be in the other order. First see if there is
anybody interested in the skb, then make a copy of it.

> +
> +	dsa_switch_inband_complete(ds, NULL);
> +}
> +
> +int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
> +{
> +	mutex_init(&chip->rmu.mutex);
> +
> +	/* Remember original ops for restore */
> +	chip->rmu.smi_ops = chip->smi_ops;
> +
> +	/* Change rmu ops with our own pointer */
> +	chip->rmu.rmu_ops = (struct mv88e6xxx_bus_ops *)chip->rmu.smi_ops;

Why do you need a cast? In general, casts are wrong, it suggests your
types are wrong.

> +	chip->rmu.rmu_ops->get_rmon = mv88e6xxx_rmu_stats_get;
> +
> +	if (chip->info->ops->rmu_disable)
> +		return chip->info->ops->rmu_disable(chip);

Why is a setup function calling disable?

    Andrew

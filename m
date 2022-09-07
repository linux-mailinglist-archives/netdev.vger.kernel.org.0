Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD155B0FC8
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 00:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiIGWZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 18:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIGWZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 18:25:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654A3580BE
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 15:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VPgBbxro/obVls0UgQr6yrKuEA92eZJSluRQh7NPjSM=; b=N4ACXGtUGuBkQTywlZXFxbRICj
        chSGBlclB9wmcxiyX0ccMCPoM8LqQPTlE8A5lizY9WkF0wdX6Hd9U/JalMeyupA5jFwlOLjKqeblp
        1ucwQSb79o7sosXNz5OO9ovKF4D9HksGQesIpDqWxWDjCAk2098CpbRNzlaaYixFmmzk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oW3U4-00FuJm-Q3; Thu, 08 Sep 2022 00:25:24 +0200
Date:   Thu, 8 Sep 2022 00:25:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v5 4/6] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Message-ID: <YxkaVCYTKCLtReGB@lunn.ch>
References: <20220907072950.2329571-1-mattias.forsblad@gmail.com>
 <20220907072950.2329571-5-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907072950.2329571-5-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mv88e6xxx_rmu_get_id(struct mv88e6xxx_chip *chip, int port)
> +{
> +	const u8 get_id[8] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

Please add some #defines for these.

I'm also not sure this is the natural format for these messages. It
appears they are built from u16, not u8.

> +	int ret = -1;
> +
> +	if (chip->rmu.got_id)
> +		return 0;

get_id is supposed to be the first command you send it. So i would
actually this as part of initialising RMU. If it fails, you can then
fallback to MDIO for everything. That would also mean you don't need
mv88e6xxx_rmu_stats_get() or any other user of RMU to have a call to
mv88e6xxx_rmu_get_id().

> +
> +	ret = mv88e6xxx_rmu_send_wait(chip, port, MV88E6XXX_RMU_REQ_GET_ID, get_id, 8);
> +	if (ret) {
> +		dev_dbg(chip->dev, "RMU: error for command GET_ID %pe\n", ERR_PTR(ret));
> +		return ret;
> +	}

This is not really the API i was expecting. A classic RPC would have
both the in and the out parameters here. So i would of expected this
call more like:

u16 req = [ MV88E6XXX_RMU_REQ_FORMAT_0, MV88E6XXX_RMU_PAD, MV88E6XXX_RMU_REQ_GET_ID];
u16 res[3];

	ret = mv88e6xxx_rmu_send_wait(chip, port, req, sizeof(req),
	                              &res, sizeof(res));
	if (ret) {
		dev_dbg(chip->dev, "RMU: error for command GET_ID %pe\n", ERR_PTR(ret));
		return ret;
	}

	if (res[0] != MV88E6XXX_RMU_RESP_FORMAT_1 ||
	    res[2] != MV88E6XXX_RMU_REQ_GET_ID) {
	    dev_dbg(chip->dev, "RMU: Bad responce ...");
	    return -EIO;
	}

	id = res[1];

mv88e6xxx_rmu_send_wait() should do the copy into the response buffer,
or return an negative value if the response is too big for the buffer.

> +static int mv88e6xxx_rmu_stats_get(struct mv88e6xxx_chip *chip, int port, uint64_t *data)
> +{
> +	u8 dump_mib[8] = { 0x00, 0x01, 0x00, 0x00, 0x10, 0x20, 0x00, 0x00 };
> +	int ret;
> +
> +	ret = mv88e6xxx_rmu_get_id(chip, port);
> +	if (ret)
> +		return ret;
> +
> +	/* Send a GET_MIB command */
> +	dump_mib[7] = port;
> +	ret = mv88e6xxx_rmu_send_wait(chip, port, MV88E6XXX_RMU_REQ_DUMP_MIB, dump_mib, 8);
> +	if (ret) {
> +		dev_dbg(chip->dev, "RMU: error for command DUMP_MIB %pe port %d\n",
> +			ERR_PTR(ret), port);
> +		return ret;
> +	}

Here there is an odd disconnect. I don't see how the response from the
switch gets into *data. A classic RPC structure would help with that.

> +
> +	/* Update MIB for port */
> +	if (chip->info->ops->stats_get_stats)
> +		return chip->info->ops->stats_get_stats(chip, port, data);
> +
> +	return 0;
> +}

> +void mv88e6xxx_decode_frame2reg_handler(struct net_device *dev, struct sk_buff *skb)
> +{
> +	struct dsa_port *dp = dev->dsa_ptr;
> +	struct dsa_switch *ds = dp->ds;
> +	struct mv88e6xxx_chip *chip;
> +	int source_device;
> +	u8 *dsa_header;
> +	u16 format;
> +	u16 code;
> +	u8 seqno;
> +
> +	if (mv88e6xxx_validate_mac(ds, skb))
> +		return;
> +
> +	/* Decode Frame2Reg DSA portion */
> +	dsa_header = skb->data - 2;
> +
> +	source_device = FIELD_GET(MV88E6XXX_SOURCE_DEV, dsa_header[0]);
> +	ds = dsa_switch_find(ds->dst->index, source_device);
> +	if (!ds) {
> +		net_dbg_ratelimited("RMU: Didn't find switch with index %d", source_device);
> +		return;
> +	}
> +
> +	chip = ds->priv;
> +	seqno = dsa_header[3];
> +	if (seqno != chip->rmu.inband_seqno) {
> +		net_dbg_ratelimited("RMU: wrong seqno received. Was %d, expected %d",
> +				    seqno, chip->rmu.inband_seqno);
> +		return;
> +	}
> +
> +	/* Pull DSA L2 data */
> +	skb_pull(skb, MV88E6XXX_DSA_HLEN);
> +
> +	format = get_unaligned_be16(&skb->data[0]);
> +	if (format != MV88E6XXX_RMU_RESP_FORMAT_1 &&
> +	    format != MV88E6XXX_RMU_RESP_FORMAT_2) {
> +		net_dbg_ratelimited("RMU: received unknown format 0x%04x", format);
> +		return;
> +	}
> +
> +	code = get_unaligned_be16(&skb->data[4]);
> +	if (code == MV88E6XXX_RMU_RESP_ERROR) {
> +		net_dbg_ratelimited("RMU: error response code 0x%04x", code);
> +		return;

I don't think you can just discard on errors like this. Ideally you want
mv88e6xxx_rmu_send_wait() to return -EIO to indicate there has been
some sort of error.

Also, this is pretty bad, so i would use net_err_ratelimited().

      Andrew

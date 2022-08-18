Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A9659835B
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 14:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244162AbiHRMoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 08:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243899AbiHRMoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 08:44:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB24B3E777
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 05:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eLawVMZRZwmZrxZogw6/TLj5oPCCoxyyFWQmFvKWKeY=; b=xTIGW6bO3rER4zHGdTC/Qd7qz1
        Q9gPEFSnqQk80ujnN0X3wd4RF68WjnvtrjUmBDrhsui0irvKMLmq3fa2cdm6PwyLgRtqfvZc/FBS8
        U+ER5BnqkoJeOPi0e4f/victkp32UAKZd4Y/RLRNzTYB1/LEumtZKykWAGR5Vvzt8nb0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOesY-00Dk2B-9w; Thu, 18 Aug 2022 14:44:06 +0200
Date:   Thu, 18 Aug 2022 14:44:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC net-next PATCH 1/3] dsa: Add ability to handle RMU frames.
Message-ID: <Yv40FjX9WTx8aBih@lunn.ch>
References: <20220818102924.287719-1-mattias.forsblad@gmail.com>
 <20220818102924.287719-2-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818102924.287719-2-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dsa_inband_rcv_ll(struct sk_buff *skb, struct net_device *dev)
> +{
> +	int source_device, source_port;
> +	struct dsa_switch *ds;
> +	u8 *dsa_header;
> +	int rcv_seqno;
> +	int ret = 0;
> +
> +	if (!dev || !dev->dsa_ptr)
> +		return 0;
> +
> +	ds = dev->dsa_ptr->ds;
> +
> +	dsa_header = skb->data - 2;
> +
> +	source_device = dsa_header[0] & 0x1f;
> +	source_port = (dsa_header[1] >> 3) & 0x1f;
> +	ds = dsa_switch_find(ds->dst->index, source_device);

You should never trust anything you receive from the network. Always
validate it. ds could be a NULL pointer here, if source_device is
bad. source_port could also be invalid. Hum, source port is not
actually used?

We send RMU frames with a specific destination MAC address. Can we
validate the destination address for frames we receive.

> +
> +	/* Get rcv seqno */
> +	rcv_seqno = dsa_header[3];
> +
> +	skb_pull(skb, DSA_HLEN);
> +
> +	if (ds->ops && ds->ops->inband_receive(ds, skb, rcv_seqno))
> +		netdev_err(dev, "DSA inband: error decoding packet");

rate limit this print, so as to avoid the possibility of a DoS.

     Andrew

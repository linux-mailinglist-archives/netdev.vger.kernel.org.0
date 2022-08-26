Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84315A2FEA
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 21:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiHZT1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 15:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiHZT1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 15:27:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC14CD789
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 12:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cde1O3Th/GUrEfq65oztIeFDUVUEEa/xla2gDx8iQdE=; b=oyW6MeMmXfwbrRdpACY9vX8sDH
        CQkgP7a4qWGRQ//xj4+ziUgHP0oYKwavOh6/7sOqt9syP5vGSp9eede5vBu+I8nMqC6I292Re1FI2
        gXzuRVi5lCd5JbwThNXX2NT9Xu9gEXF/At1jmYdx7dFSDQfEhVgkrYycqEePOeG+squQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRez7-00EiXz-7V; Fri, 26 Aug 2022 21:27:17 +0200
Date:   Fri, 26 Aug 2022 21:27:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 1/3] dsa: Implement RMU layer in DSA
Message-ID: <YwkelQ7NWgNU2+xm@lunn.ch>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
 <20220826063816.948397-2-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826063816.948397-2-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 08:38:14AM +0200, Mattias Forsblad wrote:
> Support handling of layer 2 part for RMU frames which is
> handled in-band with other DSA traffic.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  include/net/dsa.h             |   7 +++
>  include/uapi/linux/if_ether.h |   1 +
>  net/dsa/tag_dsa.c             | 109 +++++++++++++++++++++++++++++++++-
>  3 files changed, 114 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index f2ce12860546..54f7f3494f84 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -92,6 +92,7 @@ struct dsa_switch;
>  struct dsa_device_ops {
>  	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
>  	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
> +	int (*inband_xmit)(struct sk_buff *skb, struct net_device *dev, int seq_no);
>  	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
>  			     int *offset);
>  	int (*connect)(struct dsa_switch *ds);
> @@ -1193,6 +1194,12 @@ struct dsa_switch_ops {
>  	void	(*master_state_change)(struct dsa_switch *ds,
>  				       const struct net_device *master,
>  				       bool operational);
> +
> +	/*
> +	 * RMU operations
> +	 */
> +	int (*inband_receive)(struct dsa_switch *ds, struct sk_buff *skb,
> +			int seq_no);
>  };

Hi Mattias

Vladimer pointed you towards the qca driver, in a comment for your
RFC. qca already has support for switch commands via Ethernet frames.

The point he was trying to make is that you should look at that
code. The concept of executing a command via an Ethernet frame, and
expecting a reply via an Ethernet frame is generic. The format of
those frames is specific to the switch. We want the generic parts to
look the same for all switches. If possible, we want to implement it
once in the dsa core, so all switch drivers share it. Less code,
better tested code, less bugs, easier maintenance.

Take a look at qca_tagger_data. Please use the same mechanism with
mv88e6xxx. But also look deeper. What else can be shared? You need a
buffer to put the request in, you need to send it, you need to wait
for the reply, you need to pass the results to the driver, you need to
free that buffer afterwards. That should all be common. Look at these
parts in the qca driver. Can you make them generic, move them into the
DSA core? Are there other parts which could be shared?

    Andrew



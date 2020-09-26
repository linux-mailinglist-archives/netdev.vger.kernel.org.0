Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD84279BCD
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 20:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbgIZSNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 14:13:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57032 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgIZSNl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 14:13:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMEhX-00GIdR-L3; Sat, 26 Sep 2020 20:13:39 +0200
Date:   Sat, 26 Sep 2020 20:13:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v2 net-next 06/16] net: dsa: add a generic procedure for
 the flow dissector
Message-ID: <20200926181339.GE3883417@lunn.ch>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
 <20200926173108.1230014-7-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926173108.1230014-7-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +void dsa_tag_generic_flow_dissect(const struct sk_buff *skb, __be16 *proto,
> +				  int *offset)
> +{
> +	const struct dsa_device_ops *ops = skb->dev->dsa_ptr->tag_ops;
> +	int tag_len = ops->overhead;
> +
> +	*offset = tag_len;
> +	*proto = ((__be16 *)skb->data)[(tag_len / 2) - 1];
> +}
> +EXPORT_SYMBOL(dsa_tag_generic_flow_dissect);

If you look where this is used:

#if IS_ENABLED(CONFIG_NET_DSA)
                if (unlikely(skb->dev && netdev_uses_dsa(skb->dev) &&
                             proto == htons(ETH_P_XDSA))) {
                        const struct dsa_device_ops *ops;
                        int offset = 0;

                        ops = skb->dev->dsa_ptr->tag_ops;
                        if (ops->flow_dissect &&
                            !ops->flow_dissect(skb, &proto, &offset)) {
                                hlen -= offset;
                                nhoff += offset;
                        }
                }
#endif

We have already done ops = skb->dev->dsa_ptr->tag_ops once. But since
it is in a different compilation unit, the optimise has no idea about
this. So building on my last comment, it would be nice to make this an
inline function to help out the optimiser.

       Andrew

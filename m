Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138F1279BC0
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 20:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgIZSFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 14:05:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57010 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgIZSFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 14:05:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMEZt-00GIZB-0W; Sat, 26 Sep 2020 20:05:45 +0200
Date:   Sat, 26 Sep 2020 20:05:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v2 net-next 06/16] net: dsa: add a generic procedure for
 the flow dissector
Message-ID: <20200926180545.GD3883417@lunn.ch>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
 <20200926173108.1230014-7-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926173108.1230014-7-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 08:30:58PM +0300, Vladimir Oltean wrote:
> For all DSA formats that don't use tail tags, it looks like behind the
> obscure number crunching they're all doing the same thing: locating the
> real EtherType behind the DSA tag. Nonetheless, this is not immediately
> obvious, so create a generic helper for those DSA taggers that put the
> header before the EtherType.

This is interesting, and opens up the possibility of an optimisation on
the hot path.

net/core/flow_dissector.c:

bool __skb_flow_dissect(const struct net *net,
                        const struct sk_buff *skb,
                        struct flow_dissector *flow_dissector,
                        void *target_container,
                        void *data, __be16 proto, int nhoff, int hlen,
                        unsigned int flags)
{
...

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

Given spectra and meltdown etc, jumping through a pointer is expensive
and we try to avoid it on the hot path. Given most of the taggers are
going to use the generic version, maybe add a test here, is
ops->flow_dissect the generic version, and if so, call it directly,
rather than go through the pointer. Or only set ops->flow_dissect if
the generic version cannot be used.

    Andrew

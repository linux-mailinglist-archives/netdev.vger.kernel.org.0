Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEA82EE80A
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 22:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbhAGV5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 16:57:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55880 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbhAGV5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 16:57:03 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxdGV-00Gkzs-9H; Thu, 07 Jan 2021 22:56:19 +0100
Date:   Thu, 7 Jan 2021 22:56:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, krishna.c.sudi@intel.com
Subject: Re: [PATCH 11/18] net: iosm: encode or decode datagram
Message-ID: <X/eDg7jNQ6/VIY5K@lunn.ch>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
 <20210107170523.26531-12-m.chetan.kumar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107170523.26531-12-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Pass the DL packet to the netif layer. */
> +static int mux_net_receive(struct iosm_mux *ipc_mux, int if_id,
> +			   struct iosm_wwan *wwan, u32 offset, u8 service_class,
> +			   struct sk_buff *skb)
> +{
> +	/* for "zero copy" use clone */
> +	struct sk_buff *dest_skb = skb_clone(skb, GFP_ATOMIC);
> +
> +	if (!dest_skb)
> +		return -1;
> +
> +	skb_pull(dest_skb, offset);
> +
> +	skb_set_tail_pointer(dest_skb, dest_skb->len);
> +
> +	/* Goto the start of the Ethernet header. */
> +	skb_push(dest_skb, ETH_HLEN);
> +
> +	/* map session to vlan */
> +	__vlan_hwaccel_put_tag(dest_skb, htons(ETH_P_8021Q), if_id + 1);

Well, that explains a bit, my comments on the netdev patch. So there
is no Ethernet header on the 'wire'. This is not an Ethernet device at
all.

More in the documentation patch...

	Andrew


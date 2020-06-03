Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4871ED17B
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 15:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgFCNwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 09:52:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34978 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgFCNwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 09:52:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CjJrBLLGDjJJFbdq98VPVt7HGTKXttT7jLG8SR4YksM=; b=jVHhPxb4D/PkHML7Kdzscnkv6e
        I1wladEdRWrrc+iB1VFMU6NXqlXZekT5V32LgauWEyHJnpHG+uxAyXTJA/XBXj77EdowZRL2HsoIt
        swKkZ1obbTX6aswbYx95jT30F9LRhNndeekovhZK+eD48ddBJ87lC6N/qdohvTuVF5GU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jgToy-0043gu-Ig; Wed, 03 Jun 2020 15:52:44 +0200
Date:   Wed, 3 Jun 2020 15:52:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>
Subject: Re: [net-next PATCH 1/5] net: dsa: tag_rtl4_a: Implement Realtek 4
 byte A tag
Message-ID: <20200603135244.GA869823@lunn.ch>
References: <20200602205456.2392024-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602205456.2392024-1-linus.walleij@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
> +				     struct net_device *dev,
> +				     struct packet_type *pt)
> +{
> +	u16 protport;
> +	__be16 *p;
> +	u16 etype;
> +	u8 flags;
> +	u8 *tag;
> +	u8 prot;
> +	u8 port;
> +
> +	if (unlikely(!pskb_may_pull(skb, RTL4_A_HDR_LEN)))
> +		return NULL;
> +
> +	/* The RTL4 header has its own custom Ethertype 0x8899 and that
> +	 * starts right at the beginning of the packet, after the src
> +	 * ethernet addr. Apparantly skb->data always points 2 bytes in,
> +	 * behind the Ethertype.
> +	 */
> +	tag = skb->data - 2;
> +	p = (__be16 *)tag;
> +	etype = ntohs(*p);
> +	if (etype != RTL4_A_ETHERTYPE) {
> +		/* Not custom, just pass through */
> +		netdev_dbg(dev, "non-realtek ethertype 0x%04x\n", etype);
> +		return skb;
> +	}
> +	p = (__be16 *)(tag + 2);
> +	protport = ntohs(*p);
> +	/* The 4 upper bits are the protocol */
> +	prot = (protport >> RTL4_A_PROTOCOL_SHIFT) & 0x0f;
> +	if (prot != RTL4_A_PROTOCOL_RTL8366RB) {
> +		netdev_err(dev, "unknown realtek protocol 0x%01x\n", prot);
> +		return NULL;
> +	}
> +	netdev_dbg(dev, "realtek protocol 0x%02x\n", prot);
> +	port = protport & 0xff;
> +	netdev_dbg(dev, "realtek port origin 0x%02x\n", port);
> +
> +	/* Remove RTL4 tag and recalculate checksum */
> +	skb_pull_rcsum(skb, RTL4_A_HDR_LEN);
> +
> +	/* Move ethernet DA and SA in front of the data */
> +	memmove(skb->data - ETH_HLEN,
> +		skb->data - ETH_HLEN - RTL4_A_HDR_LEN,
> +		2 * ETH_ALEN);
> +
> +	skb->dev = dsa_master_find_slave(dev, 0, port);
> +	if (!skb->dev) {
> +		netdev_dbg(dev, "could not find slave for port %d\n", port);
> +		return NULL;
> +	}
> +	netdev_dbg(skb->dev, "forwarded packet to slave port %d\n", port);
> +
> +	skb->offload_fwd_mark = 1;
> +
> +	return skb;
> +}

Hi Linus

Do you think you are passed basic debug/reverse engineering? There are
a lot of netdev_dbg() statements here. It would be nice to remove most
of them, if you think the code is stable.

Is there any hint in OpenRRPC that tags can be used in the other
direction? Where is spanning tree performed? In the switch, or by the
host? That is one example where the host needs to be able to
send/receive frames on specific ports.

       Andrew

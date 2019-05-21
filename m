Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA35B2594C
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfEUUmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:42:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42497 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfEUUmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 16:42:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v07IDtrhP8rBRauUbH2j9HfnbVLSptQI3OSMGfOdn9I=; b=N3dswUt/ArUfxNcW9Z8tYaXKJP
        lfKY+G/b9WigUauotTv6C9Y3wk25IwUh2D2rtMmsPa5HuepteAhItHB9/IzW002jcjMj7x6cjFTWr
        Nf5tPGhlCLzywaLcUzWmf66IXjWQOV4G7ne6foxsbk3bdqcSN0X3ZdKXP9QALJj0IkDo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTBaE-0006cU-FR; Tue, 21 May 2019 22:42:02 +0200
Date:   Tue, 21 May 2019 22:42:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, cphealy@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC net-next 9/9] net: dsa: mv88e6xxx: setup RMU bus
Message-ID: <20190521204202.GP22024@lunn.ch>
References: <20190521193004.10767-1-vivien.didelot@gmail.com>
 <20190521193004.10767-10-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521193004.10767-10-vivien.didelot@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	ether_addr_copy(eth_dest_addr, dest_addr); /* Marvell broadcast or switch MAC */
> +	ether_addr_copy(eth_src_addr, dev->dev_addr);
> +	dsa_tag[0] = 0x40 | (chip->ds->index & 0x1f); /* From_CPU */
> +	dsa_tag[1] = 0xfa;
> +	dsa_tag[2] = 0xf;
> +	dsa_tag[3] = ++chip->rmu_sequence_num;
> +	*eth_ethertype = htons(ETH_P_EDSA); /* User defined, useless really */
> +
> +	req = skb_put(skb, sizeof(*req));
> +	req->format = htons(MV88E6XXX_RMU_REQUEST_FORMAT_SOHO);
> +	req->pad = 0x0000;
> +	req->code = htons(code);

Hi Vivien

When i looked at this before, i had a different idea how to do this.

The EthType you put into this header is also used in the reply. So we
could define an ETH_P_RMU. It is then possible to get the stack to
pass all frames for an ether type to a handler. e.g the batman code:

int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
                                   struct net *net, const char *iface_name)
{
        struct batadv_priv *bat_priv;
        struct net_device *soft_iface, *master;
        __be16 ethertype = htons(ETH_P_BATMAN);

        hard_iface->batman_adv_ptype.type = ethertype;
        hard_iface->batman_adv_ptype.func = batadv_batman_skb_recv;
        hard_iface->batman_adv_ptype.dev = hard_iface->net_dev;
        dev_add_pack(&hard_iface->batman_adv_ptype);

So i would let the tag driver take off the {E}DSA header and pass the
frame to the stack, and the stack can then identify the frame and pass
it to the switch driver. I think it makes the split between tag code
and switch code cleaner.

       Andrew

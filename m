Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFF828FED3
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 09:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404286AbgJPHFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 03:05:13 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:43405 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404197AbgJPHFM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 03:05:12 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CCHGV5KJGzN0hg;
        Fri, 16 Oct 2020 09:05:06 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CCHGN0Vmkz2TTNh;
        Fri, 16 Oct 2020 09:05:00 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.49) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 16 Oct
 2020 09:04:38 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Vishal Kulkarni <vishal@chelsio.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ptp: get rid of IPV4_HLEN() and OFF_IHL macros
Date:   Fri, 16 Oct 2020 09:04:38 +0200
Message-ID: <2135183.8zsl8bQRyA@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <939828b0-846c-9e10-df31-afcb77b1150a@gmail.com>
References: <20201014115805.23905-1-ceggers@arri.de> <20201015033648.GA24901@hoboy> <939828b0-846c-9e10-df31-afcb77b1150a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.49]
X-RMX-ID: 20201016-090500-4CCHGN0Vmkz2TTNh-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, 15 October 2020, 18:56:41 CEST, Florian Fainelli wrote:
> Having recently helped someone with a bug that involved using
> IPV4_HLEN() instead of ip_hdr() in a driver's transmit path (so with the
> transport header correctly set), it would probably help if we could make
> IPV4_HLEN()'s semantics clearer with converting it to a static inline
> function and put asserts in there about what the transport and MAC
> header positions should be.
IPV4_HLEN() is only used for PTP. Is there any way to use "normal" 
infrastructure as in the rest of the network stack? It looks like PTP code 
typically has to look into multiple network layers (mac, network, transport) 
at places these layers may not be processed yet (at least in RX direction).

> At the very least, creating a new function, like this maybe in
> include/linux/ip.h might help:
> 
> static inline u8 __ip_hdr_len(const struct sk_buff *skb)
> {
> 	const struct iphdr *ip_hdr = (const struct iphdr *)(skb->data);
> 
> 	return ip_hdr->ihl << 2;
> }
Is there any reason using skb->data instead of skb_network_header()? Debugging 
through my DSA driver showed that ...

- for TX (called by dsa_slave_xmit), skb->data is set to the MAC header
(skb->head+0x02), whilst skb->network_header is correctly set to 0x10 
(skb->mac_header+14).
- for TX, skb->transport_header is 0xffff, so udp_hdr() cannot be used

- for RX (called by dsa_switch_rcv), skb->data is set to skb->head+0x50, which 
is identical to skb->network_header
- for RX, skb->transport_header ist set equal to skb->network_header, so 
udp_hdr() can also not be used.

Best regards
Christian




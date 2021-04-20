Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EE33651C1
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 07:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhDTFPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 01:15:33 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:43264 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhDTFPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 01:15:33 -0400
Received: from think.home (224.110.78.83.dynamic.wline.res.cust.swisscom.ch [83.78.110.224])
        by mail.strongswan.org (Postfix) with ESMTPSA id EF823401B1;
        Tue, 20 Apr 2021 07:15:00 +0200 (CEST)
Message-ID: <f14da35f8cfa4b8f888dadfe4c9ebcd031d8e870.camel@strongswan.org>
Subject: Re: [PATCH net-next] net: xdp: Update pkt_type if generic XDP
 changes unicast MAC
From:   Martin Willi <martin@strongswan.org>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Tue, 20 Apr 2021 07:15:00 +0200
In-Reply-To: <87tuo2gwbj.fsf@toke.dk>
References: <20210419141559.8611-1-martin@strongswan.org>
         <87tuo2gwbj.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for your comments.

> >  	eth = (struct ethhdr *)xdp->data;
> > +	orig_host = ether_addr_equal_64bits(eth->h_dest, skb->dev->dev_addr);
> 
> ether_addr_equal_64bits() seems to assume that the addresses passed to 
> it are padded to be 8 bytes long, which is not the case for eth->h_dest.
> AFAICT the only reason the _64bits variant works for multicast is that
> it happens to be only checking the top-most bit, but unless I'm missing
> something you'll have to use the boring old ether_addr_equal() here, no?

This is what eth_type_trans() uses below, so I assumed it is safe to
use. Isn't that working on the same data?

Also, the destination address in Ethernet is followed by the source
address, so two extra bytes in the source are used as padding. These
are then shifted out by ether_addr_equal_64bits(), no?

> > +		skb->pkt_type = PACKET_HOST;
> >  		skb->protocol = eth_type_trans(skb, skb->dev);
> >  	}
> 
> Okay, so this was a bit confusing to me at fist glance:
> eth_type_trans() will reset the type, but not back to PACKET_HOST. So
> this works, just a bit confusing :)

Indeed. I considered changing eth_type_trans() to always reset
pkt_type, but I didn't want to take the risk for any side effects.

Thanks!
Martin


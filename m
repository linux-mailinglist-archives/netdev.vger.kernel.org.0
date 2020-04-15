Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4B71A99B6
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 11:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405813AbgDOJ4g convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Apr 2020 05:56:36 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34981 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405625AbgDOJ4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 05:56:34 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-O4a6NApUPCew4uQ1HtO3dg-1; Wed, 15 Apr 2020 05:56:25 -0400
X-MC-Unique: O4a6NApUPCew4uQ1HtO3dg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C37D3800D5B;
        Wed, 15 Apr 2020 09:56:23 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-112-35.ams2.redhat.com [10.36.112.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EECB35DA66;
        Wed, 15 Apr 2020 09:56:21 +0000 (UTC)
Date:   Wed, 15 Apr 2020 11:56:20 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec] esp6: support ipv6 nexthdrs process for beet gso
 segment
Message-ID: <20200415095620.GA3778335@bistromath.localdomain>
References: <ba8d9777f2da2906e744cace0836dc579190ccd7.1586509561.git.lucien.xin@gmail.com>
 <7607f06c9a9f39d8a4581dd76e6e6e5314ad2968.1586509651.git.lucien.xin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <7607f06c9a9f39d8a4581dd76e6e6e5314ad2968.1586509651.git.lucien.xin@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-10, 17:07:31 +0800, Xin Long wrote:
> For beet mode, when it's ipv6 inner address with nexthdrs set,
> the packet format might be:
> 
>     ----------------------------------------------------
>     | outer  |     | dest |     |      |  ESP    | ESP |
>     | IP6 hdr| ESP | opts.| TCP | Data | Trailer | ICV |
>     ----------------------------------------------------
> 
> Before doing gso segment in xfrm6_beet_gso_segment(), it should
> skip all nexthdrs and get the real transport proto, and set
> transport_header properly.
> 
> This patch is to fix it by simply calling ipv6_skip_exthdr()
> in xfrm6_beet_gso_segment().
> 
> Fixes: 7f9e40eb18a9 ("esp6: add gso_segment for esp6 beet mode")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/ipv6/esp6_offload.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
> index b828508..021f58c 100644
> --- a/net/ipv6/esp6_offload.c
> +++ b/net/ipv6/esp6_offload.c
> @@ -173,7 +173,7 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
>  	struct xfrm_offload *xo = xfrm_offload(skb);
>  	struct sk_buff *segs = ERR_PTR(-EINVAL);
>  	const struct net_offload *ops;
> -	int proto = xo->proto;
> +	u8 proto = xo->proto;
>  
>  	skb->transport_header += x->props.header_len;
>  
> @@ -184,7 +184,13 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
>  		proto = ph->nexthdr;
>  	}
>  
> -	if (x->sel.family != AF_INET6) {
> +	if (x->sel.family == AF_INET6) {
> +		int offset = skb_transport_offset(skb);
> +		__be16 frag;
> +
> +		offset = ipv6_skip_exthdr(skb, offset, &proto, &frag);
> +		skb->transport_header += offset;

This seems a bit wrong: we start with offset = transport_offset, then
ipv6_skip_exthdr adds the size of the extension headers to it.

In a simple case where there's no extension header, ipv6_skip_exthdr
returns offset. Now we add offset to skb->transport_header, so
transport_header is increased, but it shouldn't have changed.

What am I missing?

Thanks.

-- 
Sabrina


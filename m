Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022022A99F2
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 17:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgKFQ6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 11:58:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727346AbgKFQ6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 11:58:17 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 284B722227;
        Fri,  6 Nov 2020 16:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604681896;
        bh=ZOhpQrGkysnR0zhbfGv/Uw62MYH96CEITd9x/ZjVJjA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=soQtDGhv29A0VWI+1Useda5E5mQSiwVbE8ECjO8iNvLjEYfRE5QD6i512YCeAtqga
         GlNOkp1C6EitLSJN/8W8zTtRTT+KjBKZNzOpUMolI4H3cXnQVxXoqdHYXHV5CIIMFq
         9NMtwwfaBQMY3BPlvZz63iJuaK+cEMuWzL4ZgwUE=
Date:   Fri, 6 Nov 2020 08:58:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net v2] ipv6/netfilter: Discard first fragment not
 including all headers
Message-ID: <20201106085815.603de8d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106130803.12354-1-geokohma@cisco.com>
References: <20201106130803.12354-1-geokohma@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 14:08:03 +0100 Georg Kohmann wrote:
> diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
> index c8cf1bb..e6173f5 100644
> --- a/net/ipv6/reassembly.c
> +++ b/net/ipv6/reassembly.c
> @@ -325,7 +325,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
>  	const struct ipv6hdr *hdr =3D ipv6_hdr(skb);
>  	struct net *net =3D dev_net(skb_dst(skb)->dev);
>  	__be16 frag_off;
> -	int iif, offset;
> +	int iif;
>  	u8 nexthdr;
> =20
>  	if (IP6CB(skb)->flags & IP6SKB_FRAGMENTED)
> @@ -362,24 +362,11 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
>  	 * the source of the fragment, with the Pointer field set to zero.
>  	 */
>  	nexthdr =3D hdr->nexthdr;
> -	offset =3D ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &=
frag_off);
> -	if (offset >=3D 0) {
> -		/* Check some common protocols' header */
> -		if (nexthdr =3D=3D IPPROTO_TCP)
> -			offset +=3D sizeof(struct tcphdr);
> -		else if (nexthdr =3D=3D IPPROTO_UDP)
> -			offset +=3D sizeof(struct udphdr);
> -		else if (nexthdr =3D=3D IPPROTO_ICMPV6)
> -			offset +=3D sizeof(struct icmp6hdr);
> -		else
> -			offset +=3D 1;
> -
> -		if (!(frag_off & htons(IP6_OFFSET)) && offset > skb->len) {
> -			__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
> -					IPSTATS_MIB_INHDRERRORS);
> -			icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
> -			return -1;
> -		}
> +	if (!ipv6_frag_validate(skb, skb_transport_offset(skb), &nexthdr)) {
> +		__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
> +				IPSTATS_MIB_INHDRERRORS);
> +		icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
> +		return -1;
>  	}

net/ipv6/reassembly.c: In function =E2=80=98ipv6_frag_rcv=E2=80=99:
net/ipv6/reassembly.c:327:9: warning: unused variable =E2=80=98frag_off=E2=
=80=99 [-Wunused-variable]
  327 |  __be16 frag_off;
      |         ^~~~~~~~

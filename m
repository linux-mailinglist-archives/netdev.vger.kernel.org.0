Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E441E1BAFCB
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgD0Uw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbgD0Uw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 16:52:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 606522070B;
        Mon, 27 Apr 2020 20:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588020776;
        bh=p5RSh53pkxKLb3GRpXAsI7q8krt7jS1T3KPnqUokVrQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1+/4jTIsbraeaekPuSRFcV4psC850aI/wFwrJZK7xyxp+uE+iSVKP7Cs3SRKSrH8O
         gAqhcQrYhGAvgne8Pt9qRfXqC4UUzmhFFf6hmtO/fYsJa4CGhlhdAAEOKWSED5gRdx
         0nquQ/xMbiVtzDIJO2Bxg3Ypjg/DO08YQmeoP7iI=
Date:   Mon, 27 Apr 2020 13:52:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic
 skb handler
Message-ID: <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200427204208.2501-1-Jason@zx2c4.com>
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
        <20200427204208.2501-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Apr 2020 14:42:08 -0600 Jason A. Donenfeld wrote:
> A user reported that packets from wireguard were possibly ignored by XDP
> [1]. Apparently, the generic skb xdp handler path seems to assume that
> packets will always have an ethernet header, which really isn't always
> the case for layer 3 packets, which are produced by multiple drivers.
> This patch fixes the oversight. If the mac_len is 0, then we assume
> that it's a layer 3 packet, and in that case prepend a pseudo ethhdr to
> the packet whose h_proto is copied from skb->protocol, which will have
> the appropriate v4 or v6 ethertype. This allows us to keep XDP programs'
> assumption correct about packets always having that ethernet header, so
> that existing code doesn't break, while still allowing layer 3 devices
> to use the generic XDP handler.
>=20
> [1] https://lore.kernel.org/wireguard/M5WzVK5--3-2@tuta.io/
>=20
> Reported-by: Adhipati Blambangan <adhipati@tuta.io>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  net/core/dev.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 77c154107b0d..3bc9a96bc808 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4510,9 +4510,9 @@ static u32 netif_receive_generic_xdp(struct sk_buff=
 *skb,
>  	u32 metalen, act =3D XDP_DROP;
>  	__be16 orig_eth_type;
>  	struct ethhdr *eth;
> +	u32 mac_len =3D ~0;
>  	bool orig_bcast;
>  	int hlen, off;
> -	u32 mac_len;
> =20
>  	/* Reinjected packets coming from act_mirred or similar should
>  	 * not get XDP generic processing.
> @@ -4544,6 +4544,12 @@ static u32 netif_receive_generic_xdp(struct sk_buf=
f *skb,
>  	 * header.
>  	 */
>  	mac_len =3D skb->data - skb_mac_header(skb);
> +	if (!mac_len) {
> +		eth =3D skb_push(skb, sizeof(struct ethhdr));
> +		eth_zero_addr(eth->h_source);
> +		eth_zero_addr(eth->h_dest);
> +		eth->h_proto =3D skb->protocol;
> +	}
>  	hlen =3D skb_headlen(skb) + mac_len;
>  	xdp->data =3D skb->data - mac_len;
>  	xdp->data_meta =3D xdp->data;
> @@ -4611,6 +4617,8 @@ static u32 netif_receive_generic_xdp(struct sk_buff=
 *skb,
>  		kfree_skb(skb);
>  		break;
>  	}
> +	if (!mac_len)
> +		skb_pull(skb, sizeof(struct ethhdr));

Is this going to work correctly with XDP_TX? presumably wireguard
doesn't want the ethernet L2 on egress, either? And what about
redirects?

I'm not sure we can paper over the L2 differences between interfaces.
Isn't user supposed to know what interface the program is attached to?
I believe that's the case for cls_bpf ingress, right?

>  	return act;
>  }


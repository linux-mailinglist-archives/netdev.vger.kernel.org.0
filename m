Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5B51C7E37
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 01:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgEFXzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 19:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728455AbgEFXzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 19:55:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C84242075E;
        Wed,  6 May 2020 23:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588809319;
        bh=kFA7tmZ9KvvmujeChrMjCoGvU8oILrHLrA/ujaVd4iI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=obNQGgVZdPm76J3vIkg65yFgvEy3uHLVICyXPf82B2WV7jS04f38j1zjbzywnyNLg
         fBfK/R08T2cL/osANB+SygXmcukKEqdwLgK19iVpReVKWyKF4Z3QUCEUpdMqzY3VUj
         CeBbgcBU++6YiZKic86CARYgv95TssMYjz8+KuVE=
Date:   Wed, 6 May 2020 16:55:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] net: bpf: permit redirect from L3 to L2 devices at
 near max mtu
Message-ID: <20200506165517.140d39ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200506233259.112545-1-zenczykowski@gmail.com>
References: <20200420231427.63894-1-zenczykowski@gmail.com>
        <20200506233259.112545-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 May 2020 16:32:59 -0700 Maciej =C5=BBenczykowski wrote:
> From: Maciej =C5=BBenczykowski <maze@google.com>
>=20
> __bpf_skb_max_len(skb) is used from:
>   bpf_skb_adjust_room
>   __bpf_skb_change_tail
>   __bpf_skb_change_head
>=20
> but in the case of forwarding we're likely calling these functions
> during receive processing on ingress and bpf_redirect()'ing at
> a later point in time to egress on another interface, thus these
> mtu checks are for the wrong device (input instead of output).
>=20
> This is particularly problematic if we're receiving on an L3 1500 mtu
> cellular interface, trying to add an L2 header and forwarding to
> an L3 mtu 1500 mtu wifi/ethernet device (which is thus L2 1514).
>=20
> The mtu check prevents us from adding the 14 byte ethernet header prior
> to forwarding the packet.
>=20
> After the packet has already been redirected, we'd need to add
> an additional 2nd ebpf program on the target device's egress tc hook,
> but then we'd also see non-redirected traffic and have no easy
> way to tell apart normal egress with ethernet header packets
> from forwarded ethernet headerless packets.
>=20
> Credits to Alexei Starovoitov for the suggestion on how to 'fix' this.
>=20
> This probably should be further fixed up *somehow*, just
> not at all clear how.  This does at least make things work.
>=20
> Cc: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> ---
>  net/core/filter.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7d6ceaa54d21..811aba77e24b 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3159,8 +3159,20 @@ static int bpf_skb_net_shrink(struct sk_buff *skb,=
 u32 off, u32 len_diff,
> =20
>  static u32 __bpf_skb_max_len(const struct sk_buff *skb)
>  {
> -	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
> -			  SKB_MAX_ALLOC;
> +	if (skb->dev) {
> +		unsigned short header_len =3D skb->dev->hard_header_len;
> +
> +		/* HACK: Treat 0 as ETH_HLEN to allow redirect while
> +		 * adding ethernet header from an L3 (tun, rawip, cellular)
> +		 * to an L2 device (tap, ethernet, wifi)
> +		 */
> +		if (!header_len)
> +			header_len =3D ETH_HLEN;
> +
> +		return skb->dev->mtu + header_len;
> +	} else {
> +		return SKB_MAX_ALLOC;
> +	}
>  }
> =20
>  BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,

I thought we have established that checking device MTU (m*T*u)=20
at ingress makes a very limited amount of sense, no?

Shooting from the hip here, but won't something like:

    if (!skb->dev || skb->tc_at_ingress)
        return SKB_MAX_ALLOC;
    return skb->dev->mtu + skb->dev->hard_header_len;

Solve your problem?

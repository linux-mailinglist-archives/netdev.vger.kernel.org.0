Return-Path: <netdev+bounces-3328-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA3570677F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:05:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF7D61C20CB1
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063792C74B;
	Wed, 17 May 2023 12:05:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B339A211C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F93C433EF;
	Wed, 17 May 2023 12:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684325122;
	bh=tLjZ7ckrsMNDk4LYWBWsbt0pfuLaBIg0ftCtOX5fLSo=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=miICk41lV01G9Unq7I962vxb+dCBVl93n3+fWzlPGmUwNHTIb39QKI45jYvPKIoG7
	 YArhMTYTcblnnUMm9vj1jt+pp090WiORj3+kUgpN6wMOq7Vjg1extyfM3CSsZW42Ne
	 YAQKPtwpp40f7cXmmbKPBFyOcVplKBOERP2niSv70S79c/XmIQq9mjs6adWHR169jJ
	 6lUqWXaSGKfQ3n6Q3b9NFVBGexqQS9xpm3rWu0ch/2/Ad59n0CpWklG6USC0gZTyj0
	 6oVBOSocA/eWexW0Sk1FSUyMQPK/kxx6q+GDcmRl/RmwmEbCWiMrGAf5uZ4OE3HHtg
	 CRQAZCTPOnyDg==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <485035ec-90f2-77fe-a3c5-21a0a40b111e@ovn.org>
References: <20230511093456.672221-1-atenart@kernel.org> <fe2f6594-b330-bc5b-55a5-8e1686a2eac1@redhat.com> <CANn89i+R4fdkbQr1u2L-upJobSM3aQOpGi6Kbbix_HPkkovnpA@mail.gmail.com> <2d54b3f5-d8c6-6009-a05a-e5bb2deafeda@redhat.com> <e45f3257-dc5c-3bcd-2de4-64f478ebb470@ovn.org> <11ece947-a839-0026-b272-7fb07bcaf1bb@redhat.com> <168413833063.4854.12088632353537054947@kwain> <7c7fc244-012c-7760-a62e-7c31242d489a@ovn.org> <168422260272.35976.12561298456115365259@kwain> <485035ec-90f2-77fe-a3c5-21a0a40b111e@ovn.org>
Subject: Re: [PATCH net-next 4/4] net: skbuff: fix l4_hash comment
From: Antoine Tenart <atenart@kernel.org>
Cc: i.maximets@ovn.org, davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
To: Dumitru Ceara <dceara@redhat.com>, Eric Dumazet <edumazet@google.com>, Ilya Maximets <i.maximets@ovn.org>
Date: Wed, 17 May 2023 14:05:19 +0200
Message-ID: <168432511934.5394.6542526478980736820@kwain>

Quoting Ilya Maximets (2023-05-16 23:25:19)
> On 5/16/23 09:36, Antoine Tenart wrote:
> >=20
> > What about "indicates hash was set by layer 4 stack and provides a
> > uniform distribution over flows"? Or/and we should we also add a
> > disclaimer like "no guarantee on how the hash was computed"?
>=20
> I'm still not sure this is correct.  Is a NIC driver part of layer 4
> stack?

Offloading logic with L4 fields for csum, RSS, etc; we can argue it does
something at L4. What about this: "Provides a uniform distribution over
L4 flows"? I does look better than the previous proposal IMHO.

> And there are lots of other inconsistencies around skb hash.  The followi=
ng
> is probably the most colorful that I found:
>=20
>    skb_set_hash(skb, tcp_rsk(req)->txhash, PKT_HASH_TYPE_L4);

>  * Hash types refer to the protocol layer addresses which are used to
>  * construct a packet's hash. The hashes are used to differentiate or ide=
ntify
>  * flows of the protocol layer for the hash type. Hash types are either
>  * layer-2 (L2), layer-3 (L3), or layer-4 (L4).
>  *
>  * Properties of hashes:
>  *
>  * 1) Two packets in different flows have different hash values
>  * 2) Two packets in the same flow should have the same hash value

> enum pkt_hash_types {
>         PKT_HASH_TYPE_L4,       /* Input: src_IP, dst_IP, src_port, dst_p=
ort */
> };
>=20
> Here we see that PKT_HASH_TYPE_L4 supposed to use particular fields
> as an input.

If we strictly follow the above, do all NIC provide a L4 hash using only
the above fields (src_IP, dst_IP, src_port, dst_port)? Having a quick
look I'm pretty sure no, both 4 and 5-tuple can be used. What is
important is at what level the distribution is.

So yes strictly speaking the above PKT_HASH_TYPE_L4 use can be a little
surprising, but to me it's a shortcut or a missing update. For perfect
correctness we could use
__skb_set_hash(skb, tcp_rsk(req)->txhash, false, true) FWIW.

Even l4_hash w/o taking the rnd case into account does not guarantee a
stable hash for the lifetime of a flow; what happens if packets from the
same flow are received on two NICs using different keys and/or algs?
Being computed from L4 fields does not mean it is stable. If the stable
property is needed, the hash has to be computed locally. And then comes
the other topic of caching it for reuse and potential sharing across
different consumers, sure.

Now, I'll let some time to give a chance for others to chime in.

Thanks,
Antoine


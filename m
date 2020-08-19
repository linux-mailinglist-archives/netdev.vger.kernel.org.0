Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C793249698
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgHSHIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:08:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41874 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728052AbgHSHIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:08:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597820896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vu8HMBRz/cvUQPdI+DHONr8PVdBMzXN6JvGtbrgRhTU=;
        b=jN2UGkBgdN1hlPQ6MH54OYbEHkd5JfgtwA0rQjPwe3KGZ56qbSTed5hoaadWUQyw5N09EQ
        qjTnoZJZlDATnQJ5s61eEudiWYodqGoqOimCreTYEUkx7hmhsMxZAr9eEsyja/cGcQlrHa
        y2uiy6s2I6nDLTooVHSw98HBJuCE/LM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-T_TcvgBOOlSHlgYJqSf25A-1; Wed, 19 Aug 2020 03:08:13 -0400
X-MC-Unique: T_TcvgBOOlSHlgYJqSf25A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F00A1084C84;
        Wed, 19 Aug 2020 07:08:10 +0000 (UTC)
Received: from carbon (unknown [10.40.208.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 972FF100AE55;
        Wed, 19 Aug 2020 07:07:57 +0000 (UTC)
Date:   Wed, 19 Aug 2020 09:07:56 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Thomas Ptacek <thomas@sockpuppet.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>, brouer@redhat.com
Subject: Re: [PATCH net v6] net: xdp: account for layer 3 packets in generic
 skb handler
Message-ID: <20200819090756.07f76eb9@carbon>
In-Reply-To: <20200815074102.5357-1-Jason@zx2c4.com>
References: <20200814.135546.2266851283177227377.davem@davemloft.net>
        <20200815074102.5357-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 Aug 2020 09:41:02 +0200
"Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> A user reported that packets from wireguard were possibly ignored by XDP
> [1]. Another user reported that modifying packets from layer 3
> interfaces results in impossible to diagnose drops.
>=20
> Apparently, the generic skb xdp handler path seems to assume that
> packets will always have an ethernet header, which really isn't always
> the case for layer 3 packets, which are produced by multiple drivers.
> This patch fixes the oversight. If the mac_len is 0 and so is
> hard_header_len, then we know that the skb is a layer 3 packet, and in
> that case prepend a pseudo ethhdr to the packet whose h_proto is copied
> from skb->protocol, which will have the appropriate v4 or v6 ethertype.
> This allows us to keep XDP programs' assumption correct about packets
> always having that ethernet header, so that existing code doesn't break,
> while still allowing layer 3 devices to use the generic XDP handler.
>=20
> We push on the ethernet header and then pull it right off and set
> mac_len to the ethernet header size, so that the rest of the XDP code
> does not need any changes. That is, it makes it so that the skb has its
> ethernet header just before the data pointer, of size ETH_HLEN.
>=20
> Previous discussions have included the point that maybe XDP should just
> be intentionally broken on layer 3 interfaces, by design, and that layer
> 3 people should be using cls_bpf. However, I think there are good
> grounds to reconsider this perspective:
>=20
> - Complicated deployments wind up applying XDP modifications to a
>   variety of different devices on a given host, some of which are using
>   specialized ethernet cards and other ones using virtual layer 3
>   interfaces, such as WireGuard. Being able to apply one codebase to
>   each of these winds up being essential.
>=20
> - cls_bpf does not support the same feature set as XDP, and operates at
>   a slightly different stage in the networking stack. You may reply,
>   "then add all the features you want to cls_bpf", but that seems to be
>   missing the point, and would still result in there being two ways to
>   do everything, which is not desirable for anyone actually _using_ this
>   code.
>=20
> - While XDP was originally made for hardware offloading, and while many
>   look disdainfully upon the generic mode, it nevertheless remains a
>   highly useful and popular way of adding bespoke packet
>   transformations, and from that perspective, a difference between layer
>   2 and layer 3 packets is immaterial if the user is primarily concerned
>   with transformations to layer 3 and beyond.
>=20
> - It's not impossible to imagine layer 3 hardware (e.g. a WireGuard PCIe
>   card) including eBPF/XDP functionality built-in. In that case, why
>   limit XDP as a technology to only layer 2? Then, having generic XDP
>   work for layer 3 would naturally fit as well.
>=20
> [1] https://lore.kernel.org/wireguard/M5WzVK5--3-2@tuta.io/
>=20
> Reported-by: Thomas Ptacek <thomas@sockpuppet.org>
> Reported-by: Adhipati Blambangan <adhipati@tuta.io>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>=20
> I had originally dropped this patch, but the issue kept coming up in
> user reports, so here's a v4 of it. Testing of it is still rather slim,
> but hopefully that will change in the coming days.
>=20
> Changes v5->v6:
> - The fix to the skb->protocol changing case is now in a separate
>   stand-alone patch, and removed from this one, so that it can be
>   evaluated separately.
>=20
> Changes v4->v5:
> - Rather than tracking in a messy manner whether the skb is l3, we just
>   do the check once, and then adjust the skb geometry to be identical to
>   the l2 case. This simplifies the code quite a bit.
> - Fix a preexisting bug where the l2 header remained attached if
>   skb->protocol was updated.
>=20
> Changes v3->v4:
> - We now preserve the same logic for XDP_TX/XDP_REDIRECT as before.
> - hard_header_len is checked in addition to mac_len.
>=20
>  net/core/dev.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 151f1651439f..79c15f4244e6 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4630,6 +4630,18 @@ static u32 netif_receive_generic_xdp(struct sk_buf=
f *skb,
>  	 * header.
>  	 */
>  	mac_len =3D skb->data - skb_mac_header(skb);
> +	if (!mac_len && !skb->dev->hard_header_len) {
> +		/* For l3 packets, we push on a fake mac header, and then
> +		 * pull it off again, so that it has the same skb geometry
> +		 * as for the l2 case.
> +		 */
> +		eth =3D skb_push(skb, ETH_HLEN);
> +		eth_zero_addr(eth->h_source);
> +		eth_zero_addr(eth->h_dest);
> +		eth->h_proto =3D skb->protocol;
> +		__skb_pull(skb, ETH_HLEN);
> +		mac_len =3D ETH_HLEN;
> +	}

You are consuming a little bit of the headroom here.

>  	hlen =3D skb_headlen(skb) + mac_len;
>  	xdp->data =3D skb->data - mac_len;
>  	xdp->data_meta =3D xdp->data;

The XDP-prog is allowed to change eth->h_proto.  Later (in code) we
detect this and update skb->protocol with the new protocol.

What will happen if my XDP-prog adds a VLAN header?

The selftest tools/testing/selftests/bpf/test_xdp_vlan.sh test these
situations.  You can use it as an example, and write/construct a test
that does the same for your Wireguard devices.  As minimum you need to
provide such a selftest together with this patch.

Generally speaking, IMHO generic-XDP was a mistake, because it is hard
to maintain and slows down the development of XDP.  (I have a number of
fixes in my TODO backlog for generic-XDP).  Adding this will just give
us more corner-cases that need to be maintained.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


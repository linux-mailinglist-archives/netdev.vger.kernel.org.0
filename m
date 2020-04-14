Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAC61A7755
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 11:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437653AbgDNJ14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 05:27:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34512 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437642AbgDNJ1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 05:27:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586856472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b2na7fFYukqaNl3oBpUZYO35R5zJtHu/2rI7qsg59To=;
        b=YLBH8bD7I8E272wnkGUrb3HiylC2p2RJhll5BIHzxzRPoEzK2LoSms8lhoZHBiHpa1pC7o
        /7AO3iKj64BCRhZl2N9JTveTscpAHkG1EPie2m/3Oeat03ijvyI9NeKCaV1r+jsu1C1wDr
        YZeGCaNptBvUA5JoTTQ9Hrq3uc9XPMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-C_PBPnITO4iRxW5YKE-H3g-1; Tue, 14 Apr 2020 05:27:48 -0400
X-MC-Unique: C_PBPnITO4iRxW5YKE-H3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FC27102C863;
        Tue, 14 Apr 2020 09:27:47 +0000 (UTC)
Received: from ovpn-113-222.ams2.redhat.com (ovpn-113-222.ams2.redhat.com [10.36.113.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD66311D2CA;
        Tue, 14 Apr 2020 09:27:44 +0000 (UTC)
Message-ID: <f097781778f6c54a0e4fea31d6e925504280f42c.camel@redhat.com>
Subject: Re: [PATCH v3] net: UDP repair mode for retrieving the send queue
 of corked UDP socket
From:   Paolo Abeni <pabeni@redhat.com>
To:     =?UTF-8?Q?Le=C5=9Fe?= Doru =?UTF-8?Q?C=C4=83lin?= 
        <lesedorucalin01@gmail.com>, Leon Romanovsky <leon@kernel.org>,
        netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Date:   Tue, 14 Apr 2020 11:27:43 +0200
In-Reply-To: <20200414090925.GA10402@white>
References: <20200414090925.GA10402@white>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm sorry for the late feedback, but I have a few comments...

On Tue, 2020-04-14 at 12:09 +0300, Le=C5=9Fe Doru C=C4=83lin wrote:
> In this year's edition of GSoC, there is a project idea for CRIU to add=
=20
> support for checkpoint/restore of cork-ed UDP sockets. But to add it, t=
he
> kernel API needs to be extended.
>=20
> This is what this patch does. It adds UDP "repair mode" for UDP sockets=
 in=20
> a similar approach to the TCP "repair mode", but only the send queue is
> necessary to be retrieved. So the patch extends the recv and setsockopt=
=20
> syscalls. Using UDP_REPAIR option in setsockopt, caller can set the soc=
ket
> in repair mode. If it is setted, the recv/recvfrom/recvmsg will receive=
 the
> write queue and the destination of the data. As in the TCP mode, to cha=
nge=20
> the repair mode requires the CAP_NET_ADMIN capability and to receive da=
ta=20
> the caller is obliged to use the MSG_PEEK flag.
>=20
> Signed-off-by: Lese Doru Calin <lesedorucalin01@gmail.com>
> ---
[...]
@@ -1739,6 +1763,12 @@ int udp_recvmsg(struct sock *sk, struct msghdr *ms=
g, size_t len, int noblock,
>  	if (flags & MSG_ERRQUEUE)
>  		return ip_recv_error(sk, msg, len, addr_len);
> =20
> +	if (unlikely(up->repair)) {
> +		if (!peeking)
> +			return -EPERM;
> +		goto recv_sndq;
> +	}

If the code deduplication suggested below applies, perhaps you can
avoid the 'goto' statement and keep the 'repair' related code isolated
in a single place.

[...]

>=20
>  	cond_resched();
>  	msg->msg_flags &=3D ~MSG_TRUNC;
>  	goto try_again;
> +
> +recv_sndq:
> +	off =3D sizeof(struct iphdr) + sizeof(struct udphdr);
> +	if (sin) {
> +		fl4 =3D &inet->cork.fl.u.ip4;
> +		sin->sin_family =3D AF_INET;
> +		sin->sin_port =3D fl4->fl4_dport;
> +		sin->sin_addr.s_addr =3D fl4->daddr;
> +		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
> +		*addr_len =3D sizeof(*sin);

Here the BPF_CGROUP_UDP4_RECVMSG hook is not invoked, why?

Perhaps you can reduce code duplication moving the esisting sin addr
handling to an helper, taking addr and port as arguments, and re-using
it here.

[...]

> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 7d4151747340..ec653f9fce2d 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -250,6 +250,28 @@ struct sock *udp6_lib_lookup(struct net *net, cons=
t struct in6_addr *saddr, __be
>  EXPORT_SYMBOL_GPL(udp6_lib_lookup);
>  #endif
> =20
> +static int udp6_peek_sndq(struct sock *sk, struct msghdr *msg, int off=
, int len)
> +{
> +	int copy, copied =3D 0, err =3D 0;
> +	struct sk_buff *skb;
> +
> +	skb_queue_walk(&sk->sk_write_queue, skb) {
> +		copy =3D len - copied;
> +		if (copy > skb->len - off)
> +			copy =3D skb->len - off;
> +
> +		err =3D skb_copy_datagram_msg(skb, off, msg, copy);
> +		if (err)
> +			break;
> +
> +		copied +=3D copy;
> +
> +		if (len <=3D copied)
> +			break;
> +	}
> +	return err ?: copied;
> +}
> +

This looks identical to the v4 version to me. If so, you could re-use
the same helper, exporting it.

Cheers,

Paolo


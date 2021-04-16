Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EB83624DA
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 18:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbhDPQAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 12:00:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238229AbhDPQAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 12:00:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618588784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j0Noy42xRVFwBW3CXwI/6RmKT0VukU9Fhy0p6cBigX8=;
        b=HvfG6U+7V33i2Nz9V0g96BxHlJ2pN85tb/nrq7v1yplTOzM7JQNHX9fCJO3F41VzEAM1t8
        xZUrwttz4E/92IYgtC6QKncxQvupUPJUCsbCeQpJya5y9D2KwEbomuoFeQ3ndiC2WDmG/b
        nIwMsI168/DX1zsNfC46MSLxZuA6uc0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-PpuuUFbSOqCqmGTvkXkJmg-1; Fri, 16 Apr 2021 11:59:42 -0400
X-MC-Unique: PpuuUFbSOqCqmGTvkXkJmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16277107ACCD;
        Fri, 16 Apr 2021 15:59:41 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90B0913470;
        Fri, 16 Apr 2021 15:59:31 +0000 (UTC)
Date:   Fri, 16 Apr 2021 17:59:29 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     brouer@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next] veth: check for NAPI instead of xdp_prog
 before xmit of XDP frame
Message-ID: <20210416175929.35c3c389@carbon>
In-Reply-To: <20210416154745.238804-1-toke@redhat.com>
References: <20210416154745.238804-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 17:47:45 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> The recent patch that tied enabling of veth NAPI to the GRO flag also has
> the nice side effect that a veth device can be the target of an
> XDP_REDIRECT without an XDP program needing to be loaded on the peer
> device. However, the patch adding this extra NAPI mode didn't actually
> change the check in veth_xdp_xmit() to also look at the new NAPI pointer,
> so let's fix that.
>=20
> Fixes: 6788fa154546 ("veth: allow enabling NAPI even without XDP")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  drivers/net/veth.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Very happy to see this strange requirement of loading an xdp_prog on
the veth peer (inside the netns) being lifted.  Multiple people/users
have hit this issue and complained.  Thanks for the followup to fix
this! :-)

> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 15b2e3923c47..bdb7ce3cb054 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -486,11 +486,10 @@ static int veth_xdp_xmit(struct net_device *dev, in=
t n,
> =20
>  	rcv_priv =3D netdev_priv(rcv);
>  	rq =3D &rcv_priv->rq[veth_select_rxq(rcv)];
> -	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on receive
> -	 * side. This means an XDP program is loaded on the peer and the peer
> -	 * device is up.
> +	/* The napi pointer is set if NAPI is enabled, which ensures that
> +	 * xdp_ring is initialized on receive side and the peer device is up.
>  	 */
> -	if (!rcu_access_pointer(rq->xdp_prog))
> +	if (!rcu_access_pointer(rq->napi))
>  		goto out;
> =20
>  	max_len =3D rcv->mtu + rcv->hard_header_len + VLAN_HLEN;



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


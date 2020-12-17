Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1F22DD4F9
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 17:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgLQQMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 11:12:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21533 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726012AbgLQQMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 11:12:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608221473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o8uqzEh2yDZGv6IQSU+LjpuBTK7ef37k28xQm9V5cVU=;
        b=dy5ittGms+M1TezcCrjOhcqazq7bSzrzfCq9NSi+ewOfVU3td0wJHZ6KFHhOIcSDmeIBIv
        IEyvn9u2uVlqOxalVMvgnXYjJJnQDjuCd48utkkB0lqaTRUvSkEF6lTXcn+FaC1mZihUek
        qXZ6HohhJwOk1ycKjWWt8W9f7PL86cU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-gCYFofFyOOeBqe0aNRY3YA-1; Thu, 17 Dec 2020 11:11:09 -0500
X-MC-Unique: gCYFofFyOOeBqe0aNRY3YA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BC851005513;
        Thu, 17 Dec 2020 16:11:07 +0000 (UTC)
Received: from carbon (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7E651C92F;
        Thu, 17 Dec 2020 16:10:58 +0000 (UTC)
Date:   Thu, 17 Dec 2020 17:10:57 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V8 5/8] bpf: drop MTU check when doing TC-BPF
 redirect to ingress
Message-ID: <20201217171057.734c79d8@carbon>
In-Reply-To: <20201217154655.42e89d08@carbon>
References: <160650034591.2890576.1092952641487480652.stgit@firesoul>
        <160650040292.2890576.17040975200628427127.stgit@firesoul>
        <af28e4e7-8089-b252-3927-a962b98ad7b8@iogearbox.net>
        <20201217154655.42e89d08@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 15:46:55 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index d6125cfc49c3..4673afe59533 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -2083,13 +2083,21 @@ static const struct bpf_func_proto bpf_csum_l=
evel_proto =3D {
> > >  =20
> > >   static inline int __bpf_rx_skb(struct net_device *dev, struct sk_bu=
ff *skb)
> > >   {
> > > -	return dev_forward_skb(dev, skb);
> > > +	int ret =3D ____dev_forward_skb(dev, skb, false);
> > > +
> > > +	if (likely(!ret)) {
> > > +		skb->protocol =3D eth_type_trans(skb, dev);
> > > +		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> > > +		ret =3D netif_rx(skb);   =20
> >=20
> > Why netif_rx() and not netif_rx_internal() as in dev_forward_skb() orig=
inally?
> > One extra call otherwise. =20
>=20
> This is because the function below calls netif_rx(), which is just
> outside patch-diff-window.  Thus, it looked wrong/strange to call
> netif_rx_internal(), but sure I can use netif_rx_internal() instead.

Well, when building I found that we obviously cannot call
netif_rx_internal() as this is filter.c, else we get a build error:

net/core/filter.c:2091:9: error: implicit declaration of function =E2=80=98=
netif_rx_internal=E2=80=99 [-Werror=3Dimplicit-function-declaration]
 2091 |   ret =3D netif_rx_internal(skb);
      |         ^~~~~~~~~~~~~~~~~

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C5A6EC055
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 16:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjDWOVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 10:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjDWOV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 10:21:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A041702
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 07:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682259624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oalj8UvYCHWtG0w/MWnC3lE9ZP+shcr1ycBlVQbj5bo=;
        b=TvTRud7Me8UUri1Mq3SvEohde1iFZ2EBmar6qyXGhNSjyoYbjkrEvkX3/YBppmx4Gr2EMJ
        DbsCTuxJjX2xy4u/6S6JI3czQE/4y18QP6J59X9IDOi5dPAyIHiKS+vrpCcc+kflZWyJwg
        u05/+SvnbgSdqCMKozR8HR32eIBi6y0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-kil2FYvUP_2QHep2qUPYBg-1; Sun, 23 Apr 2023 10:20:21 -0400
X-MC-Unique: kil2FYvUP_2QHep2qUPYBg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f171d38db3so20097065e9.0
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 07:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682259620; x=1684851620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oalj8UvYCHWtG0w/MWnC3lE9ZP+shcr1ycBlVQbj5bo=;
        b=J4UIJHNiveiDTzshFOa3gPaSxhVoxwnES7tcKyLIWZnTgWlPpjx7OzMjlvpIYYgI87
         bcfBEQA4oghrcdOL/8p9Lbq3GEErK+wQDjAwDjQB7kUhir+5WhUo1lIFbGFPNKmC2N5d
         VKeplWNg4VV+WnGwbDNec7q45chVkqDi09G2tbF4VFnMoyGRI7NmPK+7Khea+IAYFXZd
         LwpfT+0xUC1YYsrUnuC1wi7FyaROdFMTqzXJRfARoy20KlmydqjGRf5fF92cUmKV5qFm
         dzCyKwqdN9guhwKYDcIHGYs3FHa0tecxvDHkLWO01zlIlNwaT1t+QLEwcIulVsUnUK5y
         T0pA==
X-Gm-Message-State: AAQBX9fVmdX3GHFCJzmE5L+h5WUzOx84KqoP9rdgdrRyjajx7B7Bk3y/
        SU0AzhaZbZvd/vOTlSOAEOd/n04WfDCSrZ4hVBqz+7ZY5PmEFe8c4TP7hN34MmubfI7RTIgQ+Ve
        6V/NZ/hWR7kLATUudZ1cioqlw
X-Received: by 2002:a7b:cb88:0:b0:3f1:7136:dd45 with SMTP id m8-20020a7bcb88000000b003f17136dd45mr5671744wmi.30.1682259619898;
        Sun, 23 Apr 2023 07:20:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350bgLLfhOD7mVreoPPp6Uc2hu+viu2sH3u6/MwfWWGclrxhqLMrwkE7Vsq3laWZZoQGaZ1Xj/Q==
X-Received: by 2002:a7b:cb88:0:b0:3f1:7136:dd45 with SMTP id m8-20020a7bcb88000000b003f17136dd45mr5671727wmi.30.1682259619434;
        Sun, 23 Apr 2023 07:20:19 -0700 (PDT)
Received: from localhost (77-32-99-124.dyn.eolo.it. [77.32.99.124])
        by smtp.gmail.com with ESMTPSA id t13-20020a7bc3cd000000b003f173c566b5sm9802698wmj.5.2023.04.23.07.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 07:20:18 -0700 (PDT)
Date:   Sun, 23 Apr 2023 16:20:46 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hawk@kernel.org,
        john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH v2 net-next 1/2] net: veth: add page_pool for page
 recycling
Message-ID: <ZEU+vospFdm08IeE@localhost.localdomain>
References: <cover.1682188837.git.lorenzo@kernel.org>
 <6298f73f7cc7391c7c4a52a6a89b1ae21488bda1.1682188837.git.lorenzo@kernel.org>
 <4f008243-49d0-77aa-0e7f-d20be3a68f3c@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mkr+ZXA+8ovhJ2bC"
Content-Disposition: inline
In-Reply-To: <4f008243-49d0-77aa-0e7f-d20be3a68f3c@huawei.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mkr+ZXA+8ovhJ2bC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2023/4/23 2:54, Lorenzo Bianconi wrote:
> >  struct veth_priv {
> > @@ -727,17 +729,20 @@ static int veth_convert_skb_to_xdp_buff(struct ve=
th_rq *rq,
> >  			goto drop;
> > =20
> >  		/* Allocate skb head */
> > -		page =3D alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> > +		page =3D page_pool_dev_alloc_pages(rq->page_pool);
> >  		if (!page)
> >  			goto drop;
> > =20
> >  		nskb =3D build_skb(page_address(page), PAGE_SIZE);
>=20
> If page pool is used with PP_FLAG_PAGE_FRAG, maybe there is some addition=
al
> improvement for the MTU 1500B case, it seem a 4K page is able to hold two=
 skb.
> And we can reduce the memory usage too, which is a significant saving if =
page
> size is 64K.

please correct if I am wrong but I think the 1500B MTU case does not fit in=
 the
half-page buffer size since we need to take into account VETH_XDP_HEADROOM.
In particular:

- VETH_BUF_SIZE =3D 2048
- VETH_XDP_HEADROOM =3D 256 + 2 =3D 258
- max_headsize =3D SKB_WITH_OVERHEAD(VETH_BUF_SIZE - VETH_XDP_HEADROOM) =3D=
 1470

Even in this case we will need the consume a full page. In fact, performanc=
es
are a little bit worse:

MTU 1500: tcp throughput ~ 8.3Gbps

Do you agree or am I missing something?

Regards,
Lorenzo

>=20
>=20
> >  		if (!nskb) {
> > -			put_page(page);
> > +			page_pool_put_full_page(rq->page_pool, page, true);
> >  			goto drop;
> >  		}
> > =20
> >  		skb_reserve(nskb, VETH_XDP_HEADROOM);
> > +		skb_copy_header(nskb, skb);
> > +		skb_mark_for_recycle(nskb);
> > +
> >  		size =3D min_t(u32, skb->len, max_head_size);
> >  		if (skb_copy_bits(skb, 0, nskb->data, size)) {
> >  			consume_skb(nskb);
> > @@ -745,7 +750,6 @@ static int veth_convert_skb_to_xdp_buff(struct veth=
_rq *rq,
> >  		}
> >  		skb_put(nskb, size);
> > =20
> > -		skb_copy_header(nskb, skb);
> >  		head_off =3D skb_headroom(nskb) - skb_headroom(skb);
> >  		skb_headers_offset_update(nskb, head_off);
> > =20
> > @@ -754,7 +758,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth=
_rq *rq,
> >  		len =3D skb->len - off;
> > =20
> >  		for (i =3D 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
> > -			page =3D alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> > +			page =3D page_pool_dev_alloc_pages(rq->page_pool);
> >  			if (!page) {
> >  				consume_skb(nskb);
> >  				goto drop;
> > @@ -1002,11 +1006,37 @@ static int veth_poll(struct napi_struct *napi, =
int budget)
> >  	return done;
> >  }
> > =20
> > +static int veth_create_page_pool(struct veth_rq *rq)
> > +{
> > +	struct page_pool_params pp_params =3D {
> > +		.order =3D 0,
> > +		.pool_size =3D VETH_RING_SIZE,
>=20
> It seems better to allocate different poo_size according to
> the mtu, so that the best proformance is achiced using the
> least memory?
>=20

--mkr+ZXA+8ovhJ2bC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZEU+uwAKCRA6cBh0uS2t
rPCEAQCdvP7xMeAT6EECHwKs4KNQFTb8o9qQ6OBWBVOjCOajWQD+Ncp/sgeLiXYE
txzpeg0mM8IXqWgXWQMxpc3dfmP7CgU=
=LBJp
-----END PGP SIGNATURE-----

--mkr+ZXA+8ovhJ2bC--


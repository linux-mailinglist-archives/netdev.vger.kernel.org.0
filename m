Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986E76EBAEE
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 20:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjDVSth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 14:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVStg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 14:49:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BF51BC2;
        Sat, 22 Apr 2023 11:49:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50ED860B46;
        Sat, 22 Apr 2023 18:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18918C433D2;
        Sat, 22 Apr 2023 18:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682189374;
        bh=1+FEEfPCpHgqgxaKFK9rJZjjJ/r9izFLNveUx2UBpBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SNVPdQHhNSYGpHdSNi811JFtrjNoXKxV+KdyzbjlnmhQ+Vk9vlm1lXMZz6AiPrkhq
         gknHLC0KcTXr4TYxtaU7+Ah0dVQXBMCfqymzYMt8wMaX5WfooARRoFoyoiOpRPvn2J
         VdmF+50XHxNd8wimas7A4UqK6oUqbWNTlg8sm8dU20ewgBsxgf9GntLOike0UBGCY+
         cUZrn1BV+5ce1eCyxAmLf2e7A0dLfep5uQMdJSdq/VsAdTAhFyQ25AvThJxkegyuPb
         BxOrRCUHzXyTC0DgUGE4sqMUV2GE6svfkYLLCY7FlvJvR7KxXklbMUQdT8j8V1b6Y6
         yZX5yudZqpRlg==
Date:   Sat, 22 Apr 2023 20:49:58 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, mtahhan@redhat.com, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next 1/2] net: veth: add page_pool for page recycling
Message-ID: <ZEQsViN6HI+S6Y2O@localhost.localdomain>
References: <cover.1681987376.git.lorenzo@kernel.org>
 <b1c7efdc33221fdb588995b385415d68b149aa73.1681987376.git.lorenzo@kernel.org>
 <20230421202230.2fa44cca@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2KhKs9Cd6PNq3dI5"
Content-Disposition: inline
In-Reply-To: <20230421202230.2fa44cca@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2KhKs9Cd6PNq3dI5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, 20 Apr 2023 13:16:21 +0200 Lorenzo Bianconi wrote:
> > @@ -727,17 +729,21 @@ static int veth_convert_skb_to_xdp_buff(struct ve=
th_rq *rq,
> >  			goto drop;
> > =20
> >  		/* Allocate skb head */
> > -		page =3D alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> > +		if (rq->page_pool)
>=20
> There's some condition under which we can get to XDP enabled but no
> pool?

ack, since we destroy the page_pool after disabling the rq napi we can get =
rid
of 'if (rq->page_pool)' checks here.

>=20
> > +			page =3D page_pool_dev_alloc_pages(rq->page_pool);
> >  		if (!page)
> >  			goto drop;
> > =20
> >  		nskb =3D build_skb(page_address(page), PAGE_SIZE);
> >  		if (!nskb) {
> > -			put_page(page);
> > +			page_pool_put_full_page(rq->page_pool, page, false);
>=20
> You can recycle direct, AFAIU the basic rule of thumb is that it's
> always safe to recycle direct from the context which allocates from
> the pool.

ack, I will fix it.

>=20
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
> > @@ -745,16 +751,17 @@ static int veth_convert_skb_to_xdp_buff(struct ve=
th_rq *rq,
> >  		}
> >  		skb_put(nskb, size);
> > =20
> > -		skb_copy_header(nskb, skb);
> >  		head_off =3D skb_headroom(nskb) - skb_headroom(skb);
> >  		skb_headers_offset_update(nskb, head_off);
> > =20
> >  		/* Allocate paged area of new skb */
> >  		off =3D size;
> >  		len =3D skb->len - off;
> > +		page =3D NULL;
>=20
> Why do you clear the page pointer?

since we do not need 'if (rq->page_pool)' checks anymore we can get rid of =
it.

Regards,
Lorenzo

>=20
> --=20
> pw-bot: cr

--2KhKs9Cd6PNq3dI5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZEQsUgAKCRA6cBh0uS2t
rESuAP44Wr6coVyn+UdOvE78VG8i3ceTHsbtfUPVkTvzEL1GZAD/V2PP7pDyPj2j
N0fjVV5MmDNwsefINtd58A0h0lzY6go=
=fcg8
-----END PGP SIGNATURE-----

--2KhKs9Cd6PNq3dI5--

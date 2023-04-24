Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF48A6ECC96
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjDXNHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjDXNHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:07:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D863C0F
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 06:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682341595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iZ/r3ZkrDG4aN0u6gY1fYmzZgpmxtz5yHltyLrI2IGU=;
        b=eUErIm72mzP3v5kZP3KwSmjxZ1/d6t+OW0UPVKRn9KADCJb5OHdgpqAeMDJRBcRXhsQVGA
        gvpsU8FqXpOp6c4WH4F2tw6QOdOSMmByfPGrMv6xrZNaigKg8nrKIEu/jKM/766A7AceBl
        hExXksmxtWu9TaLPg6DKroEDkHaU1zE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-KX8gvUMyPXmnVlRHRYIWGw-1; Mon, 24 Apr 2023 09:06:31 -0400
X-MC-Unique: KX8gvUMyPXmnVlRHRYIWGw-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3f0a12ab268so5732571cf.1
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 06:06:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682341591; x=1684933591;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZ/r3ZkrDG4aN0u6gY1fYmzZgpmxtz5yHltyLrI2IGU=;
        b=lEk4FAZbpP192SbNC732QUajsopdyjAKNie9c5+mEgm4q8cljfpmb2tWbuipWvRPuf
         R7xLK9XAo8xp+JmuxuA/cZHT+MFiZecyuqZmQmV35iLJBxyShAMS1mrhHTjP6aOXvEQK
         Gu5pJo9KLPHseLZsaXL9e2X4F2LRNiKkw9dOi9PERS6S6+rxSgmmgpP27sJOTA5ndf2j
         zYt5K4TSh0b0q8LO/mpRU1T8ndPnJE+G0W9gmwi3/yKDGI0Cab1TexJNp16LPNUEqkzj
         Mgoi0toTbf84+DuLwKVQkpNWlcgMFNR8VCUL4ng/a0GiWiNXAB5patGGzNeq/v5VoFDC
         W5yQ==
X-Gm-Message-State: AAQBX9e7DgBpK4ax1Z+NKN6oUhAogf4gVwOZScqTcoF4v2FcOXjNX9O8
        JVy1iDmdVU0iLGflGRinkpQlTWtBAuolewMbFvcSPmxpb8OmHOOC60H3MayLIQkdbAKKwHVc3tx
        98c2Wh1pC7c/9tRBk
X-Received: by 2002:ac8:5e0f:0:b0:3ba:2203:6c92 with SMTP id h15-20020ac85e0f000000b003ba22036c92mr24686018qtx.10.1682341590997;
        Mon, 24 Apr 2023 06:06:30 -0700 (PDT)
X-Google-Smtp-Source: AKy350ajl7JpwOEMUxG1TZcF1iORQi3zhYrsE5BaSo2oA8LOgt6YHMWpTf8zTzdGm69OWy4Vb/1NQQ==
X-Received: by 2002:ac8:5e0f:0:b0:3ba:2203:6c92 with SMTP id h15-20020ac85e0f000000b003ba22036c92mr24685988qtx.10.1682341590702;
        Mon, 24 Apr 2023 06:06:30 -0700 (PDT)
Received: from localhost (77-32-99-124.dyn.eolo.it. [77.32.99.124])
        by smtp.gmail.com with ESMTPSA id d18-20020ac84e32000000b003e6a1bf26a4sm3572786qtw.64.2023.04.24.06.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 06:06:30 -0700 (PDT)
Date:   Mon, 24 Apr 2023 15:06:58 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hawk@kernel.org,
        john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH v2 net-next 1/2] net: veth: add page_pool for page
 recycling
Message-ID: <ZEZ+8pKEDLR6xc2R@localhost.localdomain>
References: <cover.1682188837.git.lorenzo@kernel.org>
 <6298f73f7cc7391c7c4a52a6a89b1ae21488bda1.1682188837.git.lorenzo@kernel.org>
 <4f008243-49d0-77aa-0e7f-d20be3a68f3c@huawei.com>
 <ZEU+vospFdm08IeE@localhost.localdomain>
 <3c78f045-aa8e-22a5-4b38-ab271122a79e@huawei.com>
 <ZEZJHCRsBVQwd9ie@localhost.localdomain>
 <0c1790dc-dbeb-8664-64ca-1f71e6c4f3a9@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kKeQxf66xWTG+3ot"
Content-Disposition: inline
In-Reply-To: <0c1790dc-dbeb-8664-64ca-1f71e6c4f3a9@huawei.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kKeQxf66xWTG+3ot
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2023/4/24 17:17, Lorenzo Bianconi wrote:
> >> On 2023/4/23 22:20, Lorenzo Bianconi wrote:
> >>>> On 2023/4/23 2:54, Lorenzo Bianconi wrote:
> >>>>>  struct veth_priv {
> >>>>> @@ -727,17 +729,20 @@ static int veth_convert_skb_to_xdp_buff(struc=
t veth_rq *rq,
> >>>>>  			goto drop;
> >>>>> =20
> >>>>>  		/* Allocate skb head */
> >>>>> -		page =3D alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> >>>>> +		page =3D page_pool_dev_alloc_pages(rq->page_pool);
> >>>>>  		if (!page)
> >>>>>  			goto drop;
> >>>>> =20
> >>>>>  		nskb =3D build_skb(page_address(page), PAGE_SIZE);
> >>>>
> >>>> If page pool is used with PP_FLAG_PAGE_FRAG, maybe there is some add=
itional
> >>>> improvement for the MTU 1500B case, it seem a 4K page is able to hol=
d two skb.
> >>>> And we can reduce the memory usage too, which is a significant savin=
g if page
> >>>> size is 64K.
> >>>
> >>> please correct if I am wrong but I think the 1500B MTU case does not =
fit in the
> >>> half-page buffer size since we need to take into account VETH_XDP_HEA=
DROOM.
> >>> In particular:
> >>>
> >>> - VETH_BUF_SIZE =3D 2048
> >>> - VETH_XDP_HEADROOM =3D 256 + 2 =3D 258
> >>
> >> On some arch the NET_IP_ALIGN is zero.
> >>
> >> I suppose XDP_PACKET_HEADROOM are for xdp_frame and data_meta, it seems
> >> xdp_frame is only 40 bytes for 64 bit arch and max size of metalen is =
32
> >> as xdp_metalen_invalid() suggest, is there any other reason why we need
> >> 256 bytes here?
> >=20
> > XDP_PACKET_HEADROOM must be greater than (40 + 32)B because you may wan=
t push
> > new data at the beginning of the xdp_buffer/xdp_frame running
> > bpf_xdp_adjust_head() helper.
> > I think 256B has been selected for XDP_PACKET_HEADROOM since it is 4 ca=
chelines
> > (but I can be wrong).
> > There was a discussion in the past to reduce XDP_PACKET_HEADROOM to 192=
B but
> > this is not merged yet and it is not related to this series. We can add=
ress
> > your comments in a follow-up patch when XDP_PACKET_HEADROOM series is m=
erged.
>=20
> It worth mentioning that the performance gain in this patch is at the cos=
t of
> more memory usage, at most of VETH_RING_SIZE(256) + PP_ALLOC_CACHE_SIZE(1=
28)
> pages is used.

I would say the memory footprint is not so significative compared to the
performance improvement (>=3D 15%) in this particular case. In particular I=
 think
in most of the cases we will recycle into ptr_ring:
- 4K pages: 256*4KB ~ 1MB
- 64K pages: 256*64KB ~ 16MB

Regards,
Lorenzo

>=20
> IMHO, it seems better to limit the memory usage as much as possible, or p=
rovide a
> way to disable/enable page pool for user.
>=20

--kKeQxf66xWTG+3ot
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZEZ+7gAKCRA6cBh0uS2t
rAIBAP4zxAvFyGZfMupL0bhlkfyAzH8YNNECW2PmWFT/FXLLcgEAuomvZ5GpbQor
ws1CFwugPN2085Vc6d2nhBl8/P+KyQw=
=itEH
-----END PGP SIGNATURE-----

--kKeQxf66xWTG+3ot--


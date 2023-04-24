Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BA06EC88C
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 11:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbjDXJRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 05:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjDXJRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 05:17:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252FAE4B
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 02:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682327811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OOLaU++cN0JupiCmd2yyryZfyq6J4szaekNpgpM2HQc=;
        b=c/K7pXaU6yqNkK0AuXCEMerdzrgDcPuBha8y2XGrFudYF3Alwb+MWlrRiFRFCmeqqKbKve
        Jh/FX9KK1dIt+4NH9r9jVzhEUFrRKyYCM4qDdS6E632i6a8M7+9AoS26IHf4ozb+caXGnY
        T58iYB2AbXqioDanphDzqEm0+pEHyZE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-IdddHvqUOJegD5Fm3UdNNQ-1; Mon, 24 Apr 2023 05:16:49 -0400
X-MC-Unique: IdddHvqUOJegD5Fm3UdNNQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f18b63229bso28521275e9.0
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 02:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682327808; x=1684919808;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OOLaU++cN0JupiCmd2yyryZfyq6J4szaekNpgpM2HQc=;
        b=XTGIGjyI2sjtn57rWwOcn5ca97u/pFR5ldCjoCq+KhSac0ZnYDERBneHY1ba/eZ1KD
         PvGaRhDcL3YsUPsc0R2Gwi4vwcnOH88A6zc4+eAnBCwpIktwZdhXa1JCZ884BH/Vf767
         WAcQ63YVNw7xM89bq3OCXyFUQQjztSnvD/59/M6wVPG9s4V0lwQzs1sOWBSru57367Aq
         uhbCjPG0uOfJxEOTu/1BtLG9APyBFazKp84pUCyBWEvD5cpAD9ELEwZYAehMkKC5Htj6
         CBHc7cCms8aaMX0RCZYAS+f1KdaWVSv+BNYQ6eR0GteB6DT7bQSQDLCgYpuASaC5q92y
         L7yA==
X-Gm-Message-State: AAQBX9dkXGUQwaroFmAKV4Kjt25/R7KX8Run7Ihya+iqfbUPiQlZ4p5H
        lnjV8ViuykI3JZu+TQI7zZCBF5IS/kPiKjNOk0/g+j829+NDPZp31DltH2hU0LznGc0KVDXbyEE
        aJ7jboUZlNQ1rQVsQ
X-Received: by 2002:a05:600c:1ca8:b0:3f1:7382:b59a with SMTP id k40-20020a05600c1ca800b003f17382b59amr8037646wms.15.1682327808279;
        Mon, 24 Apr 2023 02:16:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350bBqS/KzqRiQ7MMETrEit3S+6Gq/Xn6728Mt7GN/5xj2CU9xcYe65Be7PSaTvqqYV52P6LjDw==
X-Received: by 2002:a05:600c:1ca8:b0:3f1:7382:b59a with SMTP id k40-20020a05600c1ca800b003f17382b59amr8037621wms.15.1682327807873;
        Mon, 24 Apr 2023 02:16:47 -0700 (PDT)
Received: from localhost (77-32-99-124.dyn.eolo.it. [77.32.99.124])
        by smtp.gmail.com with ESMTPSA id m18-20020a7bcb92000000b003f24f245f57sm2861354wmi.42.2023.04.24.02.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 02:16:47 -0700 (PDT)
Date:   Mon, 24 Apr 2023 11:17:16 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hawk@kernel.org,
        john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH v2 net-next 1/2] net: veth: add page_pool for page
 recycling
Message-ID: <ZEZJHCRsBVQwd9ie@localhost.localdomain>
References: <cover.1682188837.git.lorenzo@kernel.org>
 <6298f73f7cc7391c7c4a52a6a89b1ae21488bda1.1682188837.git.lorenzo@kernel.org>
 <4f008243-49d0-77aa-0e7f-d20be3a68f3c@huawei.com>
 <ZEU+vospFdm08IeE@localhost.localdomain>
 <3c78f045-aa8e-22a5-4b38-ab271122a79e@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3/evO59xRVKF5uu+"
Content-Disposition: inline
In-Reply-To: <3c78f045-aa8e-22a5-4b38-ab271122a79e@huawei.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3/evO59xRVKF5uu+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2023/4/23 22:20, Lorenzo Bianconi wrote:
> >> On 2023/4/23 2:54, Lorenzo Bianconi wrote:
> >>>  struct veth_priv {
> >>> @@ -727,17 +729,20 @@ static int veth_convert_skb_to_xdp_buff(struct =
veth_rq *rq,
> >>>  			goto drop;
> >>> =20
> >>>  		/* Allocate skb head */
> >>> -		page =3D alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> >>> +		page =3D page_pool_dev_alloc_pages(rq->page_pool);
> >>>  		if (!page)
> >>>  			goto drop;
> >>> =20
> >>>  		nskb =3D build_skb(page_address(page), PAGE_SIZE);
> >>
> >> If page pool is used with PP_FLAG_PAGE_FRAG, maybe there is some addit=
ional
> >> improvement for the MTU 1500B case, it seem a 4K page is able to hold =
two skb.
> >> And we can reduce the memory usage too, which is a significant saving =
if page
> >> size is 64K.
> >=20
> > please correct if I am wrong but I think the 1500B MTU case does not fi=
t in the
> > half-page buffer size since we need to take into account VETH_XDP_HEADR=
OOM.
> > In particular:
> >=20
> > - VETH_BUF_SIZE =3D 2048
> > - VETH_XDP_HEADROOM =3D 256 + 2 =3D 258
>=20
> On some arch the NET_IP_ALIGN is zero.
>=20
> I suppose XDP_PACKET_HEADROOM are for xdp_frame and data_meta, it seems
> xdp_frame is only 40 bytes for 64 bit arch and max size of metalen is 32
> as xdp_metalen_invalid() suggest, is there any other reason why we need
> 256 bytes here?

XDP_PACKET_HEADROOM must be greater than (40 + 32)B because you may want pu=
sh
new data at the beginning of the xdp_buffer/xdp_frame running
bpf_xdp_adjust_head() helper.
I think 256B has been selected for XDP_PACKET_HEADROOM since it is 4 cachel=
ines
(but I can be wrong).
There was a discussion in the past to reduce XDP_PACKET_HEADROOM to 192B but
this is not merged yet and it is not related to this series. We can address
your comments in a follow-up patch when XDP_PACKET_HEADROOM series is merge=
d.

Regards,
Lorenzo

>=20
> > - max_headsize =3D SKB_WITH_OVERHEAD(VETH_BUF_SIZE - VETH_XDP_HEADROOM)=
 =3D 1470
> >=20
> > Even in this case we will need the consume a full page. In fact, perfor=
mances
> > are a little bit worse:
> >=20
> > MTU 1500: tcp throughput ~ 8.3Gbps
> >=20
> > Do you agree or am I missing something?
> >=20
> > Regards,
> > Lorenzo
>=20

--3/evO59xRVKF5uu+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZEZJGQAKCRA6cBh0uS2t
rO1YAP0b/ukzdC69Ik8Aurwu2ZhsLqlpb/h4VC2lo6R4c1+FEAEA4YnkRaXXcorN
sXbmJndOLuBVdUAh2og9OuV/eP8bcgY=
=g7RL
-----END PGP SIGNATURE-----

--3/evO59xRVKF5uu+--


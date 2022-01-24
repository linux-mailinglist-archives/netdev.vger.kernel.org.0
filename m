Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A801497E09
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 12:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237601AbiAXLcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 06:32:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237234AbiAXLcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 06:32:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643023926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qORMnoIdgKPzaKMb6YWMbi2BpiXpkDZcr/xPk+9njEw=;
        b=RisK8b27MWALvW7aE8fwyK5165hPJBeG7Q13Ei6xkp1rGtbunMmhJG2Ye+FnirPa8C+swD
        n2ygv3nBQMw/PREAKRXOo77Vx9l61WsNjjljA4nfZw4yfrd0BpBigT3Xh2ROEpkBVq5HGE
        I1TyGrEBkasilOJJKJI73j8eDZ7/vRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-CSH3-giRNCe3megBcHYkmA-1; Mon, 24 Jan 2022 06:32:02 -0500
X-MC-Unique: CSH3-giRNCe3megBcHYkmA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE2B4814243;
        Mon, 24 Jan 2022 11:32:01 +0000 (UTC)
Received: from localhost (unknown [10.39.195.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CF3410589B1;
        Mon, 24 Jan 2022 11:31:50 +0000 (UTC)
Date:   Mon, 24 Jan 2022 11:31:49 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v1] vhost: cache avail index in vhost_enable_notify()
Message-ID: <Ye6OJdi2M1EBx7b3@stefanha-x1.localdomain>
References: <20220114090508.36416-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MUPe2nEeErvXt6ea"
Content-Disposition: inline
In-Reply-To: <20220114090508.36416-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--MUPe2nEeErvXt6ea
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 14, 2022 at 10:05:08AM +0100, Stefano Garzarella wrote:
> In vhost_enable_notify() we enable the notifications and we read
> the avail index to check if new buffers have become available in
> the meantime.
>=20
> We are not caching the avail index, so when the device will call
> vhost_get_vq_desc(), it will find the old value in the cache and
> it will read the avail index again.

I think this wording is clearer because we do keep a cached the avail
index value, but the issue is we don't update it:
s/We are not caching the avail index/We do not update the cached avail
index value/

>=20
> It would be better to refresh the cache every time we read avail
> index, so let's change vhost_enable_notify() caching the value in
> `avail_idx` and compare it with `last_avail_idx` to check if there
> are new buffers available.
>=20
> Anyway, we don't expect a significant performance boost because
> the above path is not very common, indeed vhost_enable_notify()
> is often called with unlikely(), expecting that avail index has
> not been updated.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v1:
> - improved the commit description [MST, Jason]
> ---
>  drivers/vhost/vhost.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..07363dff559e 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2543,8 +2543,9 @@ bool vhost_enable_notify(struct vhost_dev *dev, str=
uct vhost_virtqueue *vq)
>  		       &vq->avail->idx, r);
>  		return false;
>  	}
> +	vq->avail_idx =3D vhost16_to_cpu(vq, avail_idx);
> =20
> -	return vhost16_to_cpu(vq, avail_idx) !=3D vq->avail_idx;
> +	return vq->avail_idx !=3D vq->last_avail_idx;

vhost_vq_avail_empty() has a fast path that's missing in
vhost_enable_notify():

  if (vq->avail_idx !=3D vq->last_avail_idx)
      return false;

--MUPe2nEeErvXt6ea
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmHujiUACgkQnKSrs4Gr
c8j4FQgAqGNimsQXmBYd5xvOIaFAPOU7K643vUM2nqHYrdNnPg2GVtVXiyulBb0N
gyajwW3HtC/CjTsb0mTXhAeHHiHJ+0ImiFGCsPrYhwwDQE9fK9QTwVNW0P++Suc1
yvHSZtUCHzoy9MxvTtfzPGFFZvyCnFCAM+VR3mTPvV6d5X9kM1iMMb4SOMP3eEJ5
Sr56/F6EgVy6IRHk5jw4b50dv/PXGkemVBToPYM1lJKpk6QItPkhO1Oz6cju47+l
/sEYr52mKCa+j4HT4wg9cOZQwrP9FzDmr41yDHQsz/4hLllTilrz4WxiwMU5hUsc
HGd9PcRpzj36BwxUcI3kzjr6yf9Sjw==
=t889
-----END PGP SIGNATURE-----

--MUPe2nEeErvXt6ea--


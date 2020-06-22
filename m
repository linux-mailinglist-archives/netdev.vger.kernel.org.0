Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5327120344C
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgFVKCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:02:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34443 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727973AbgFVKCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592820122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N35KV1I58jEeqp0kFFqDBICZ46ggu9j0UFA6KwOX1CQ=;
        b=JtMdcMuk/TN04Du3tyLqHF9NDh6w3pKZ4JvVaKpfHyu1EI4ocR6s1i4T7isY8miOXQTEYS
        rtI8jdTmb841XMCRWuNf1g/9T1sCzpSjtFeGgLKRm8m+PJmEF0hLR50Bu9c52voBSIcZJB
        xW+SdO4O2773RG/h7SZyd5FyaMMLqdM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-Bemg7nuROgGN_hYEPBEvZQ-1; Mon, 22 Jun 2020 06:01:52 -0400
X-MC-Unique: Bemg7nuROgGN_hYEPBEvZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5113B8014D4;
        Mon, 22 Jun 2020 10:01:51 +0000 (UTC)
Received: from localhost (ovpn-115-184.ams2.redhat.com [10.36.115.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8D651C94D;
        Mon, 22 Jun 2020 10:01:47 +0000 (UTC)
Date:   Mon, 22 Jun 2020 11:01:46 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     mst@redhat.com, kvm list <kvm@vger.kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC v9 09/11] vhost/scsi: switch to buf APIs
Message-ID: <20200622100146.GC6675@stefanha-x1.localdomain>
References: <20200619182302.850-1-eperezma@redhat.com>
 <20200619182302.850-10-eperezma@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200619182302.850-10-eperezma@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sHrvAb52M6C8blB9"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--sHrvAb52M6C8blB9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2020 at 08:23:00PM +0200, Eugenio P=E9rez wrote:
> @@ -1139,9 +1154,9 @@ vhost_scsi_send_tmf_reject(struct vhost_scsi *vs,
>  =09iov_iter_init(&iov_iter, READ, &vq->iov[vc->out], vc->in, sizeof(rsp)=
);
> =20
>  =09ret =3D copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
> -=09if (likely(ret =3D=3D sizeof(rsp)))
> -=09=09vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
> -=09else
> +=09if (likely(ret =3D=3D sizeof(rsp))) {
> +=09=09vhost_scsi_signal_noinput(&vs->dev, vq, &vc->buf);
> +=09} else
>  =09=09pr_err("Faulted on virtio_scsi_ctrl_tmf_resp\n");
>  }

The curly brackets are not necessary, but the patch still looks fine:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--sHrvAb52M6C8blB9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7wgYoACgkQnKSrs4Gr
c8iU0wgAsLU1H/KwuKf6yqFN/L0od7nMvZEId3V8dwQBJLUc48Mxam6NlNI0Y/Fb
fY8+U4GIN38UTCj3sWf9KwU/jUVxdwtFHljPNcdDG4IRARU9bLZ1Z8XDrPvXqx0L
SiXWJRPbZhCS0vSKlStWVPsiKhntXocPX805bya3z0B5ix5U3TjfEWjmJnMtq8Vm
RrJGKjF8TYNLCXbJWmeFCKIzZ9HNkaPlZ8X3yb7J5xoPtf7wzxoRdFXbDeJPlMsa
JTN2jd6r8TRyN5zWukPwYe3Q5vX1QfVtCcZwNY9Iwys45cn7AoZrwhEMtDqaJCkN
0VZfJdyLT6+w8Ns35FIqT9XGxccMMw==
=yt/w
-----END PGP SIGNATURE-----

--sHrvAb52M6C8blB9--


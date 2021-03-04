Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8BB32D87D
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 18:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhCDRSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 12:18:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30135 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231270AbhCDRRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 12:17:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614878177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SY3y/fjQ9gcJBSAM3ZTh/kWFdCD5EKEzVNMAsrCAGpU=;
        b=hbl1h6YKessYnMibtP0E4P8FuM0vhtkwCryIuht5jbeBloy2BcfcSwwDtty1PLdVbIEpOh
        vBMdEhIElONlrnid2D76jWudQn3PDdyDnCNx6H+aYye6hGdUB7S3HAUSbB9wkn1L5sZSZS
        S437msiAPYwZ1CGUnW2skCZaUjXHPdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-h9RhXSbPOKGq3Iq6rZJaxg-1; Thu, 04 Mar 2021 12:16:13 -0500
X-MC-Unique: h9RhXSbPOKGq3Iq6rZJaxg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 361B592535;
        Thu,  4 Mar 2021 17:16:09 +0000 (UTC)
Received: from localhost (ovpn-114-199.ams2.redhat.com [10.36.114.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B78EF19645;
        Thu,  4 Mar 2021 17:15:55 +0000 (UTC)
Date:   Thu, 4 Mar 2021 17:15:54 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: vhost-scsi: remove redundant
 initialization of variable ret
Message-ID: <YEEVypxRJloK/CRk@stefanha-x1.localdomain>
References: <20210303134339.67339-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="O/Mw4/hwfMu4pg68"
Content-Disposition: inline
In-Reply-To: <20210303134339.67339-1-colin.king@canonical.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--O/Mw4/hwfMu4pg68
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 03, 2021 at 01:43:39PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> The variable ret is being initialized with a value that is never read
> and it is being updated later with a new value.  The initialization is
> redundant and can be removed.
>=20
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/vhost/scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Which kernel version is this patch based on?

If it's a fix for a patch that hasn't landed yet, please indicate this.
A "Fixes: ..." tag should be added to this patch as well.

I looked at linux.git/master commit f69d02e37a85645aa90d18cacfff36dba370f79=
7 and see this:

  static int __init vhost_scsi_init(void)
  {
          int ret =3D -ENOMEM;

          pr_debug("TCM_VHOST fabric module %s on %s/%s"
                  " on "UTS_RELEASE"\n", VHOST_SCSI_VERSION, utsname()->sys=
name,
                  utsname()->machine);

          /*
           * Use our own dedicated workqueue for submitting I/O into
           * target core to avoid contention within system_wq.
           */
          vhost_scsi_workqueue =3D alloc_workqueue("vhost_scsi", 0, 0);
          if (!vhost_scsi_workqueue)
                  goto out;

We need ret's initialization value here ^

          ret =3D vhost_scsi_register();
          if (ret < 0)
                  goto out_destroy_workqueue;

          ret =3D target_register_template(&vhost_scsi_ops);
          if (ret < 0)
                  goto out_vhost_scsi_deregister;

          return 0;

  out_vhost_scsi_deregister:
          vhost_scsi_deregister();
  out_destroy_workqueue:
          destroy_workqueue(vhost_scsi_workqueue);
  out:
          return ret;
  };


>=20
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index d16c04dcc144..9129ab8187fd 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -2465,7 +2465,7 @@ static const struct target_core_fabric_ops vhost_sc=
si_ops =3D {
> =20
>  static int __init vhost_scsi_init(void)
>  {
> -	int ret =3D -ENOMEM;
> +	int ret;
> =20
>  	pr_debug("TCM_VHOST fabric module %s on %s/%s"
>  		" on "UTS_RELEASE"\n", VHOST_SCSI_VERSION, utsname()->sysname,
> --=20
> 2.30.0
>=20

--O/Mw4/hwfMu4pg68
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBBFcoACgkQnKSrs4Gr
c8gNDQgAxM4D7kpB9RqQmwD/pZXfh57rpPDY0uHmPrBOq7MKsTXUfM1+n3cqcck5
qp5XiRpnP8mgoJ374YNyayk8ce7uB5z24/A56unCdzgC5cPPPmxvckd7RvG/3aTS
cKAUbh+I1wNWJCcbzJS/aGI/VOtMRHC3XoWGvXRA8N+FaeCRvyR+I7jyj+iTIeW+
hZNlQPI5da9WIcsUKyhq3963CdDjCuudTFIQNP8/EhsimQiWgt4DIqc+yJP+H2ny
Ai1LQxhQskm7QSAnVZz9QhfWdnF5HUK+46Dy0xeO3OzbgeHJBN2y32g1d+5kL1kj
hL+eyNKX93GZqvoeq8Lh7RVfhQkmFQ==
=yn4t
-----END PGP SIGNATURE-----

--O/Mw4/hwfMu4pg68--


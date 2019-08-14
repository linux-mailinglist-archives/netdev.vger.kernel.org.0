Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B448D782
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfHNP5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:57:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbfHNP5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 11:57:01 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7B34413A82;
        Wed, 14 Aug 2019 15:57:01 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-57.rdu2.redhat.com [10.10.112.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 18AB781E27;
        Wed, 14 Aug 2019 15:56:59 +0000 (UTC)
Message-ID: <53b40b359d18dd73a6cf264aa8013d33547b593f.camel@redhat.com>
Subject: Re: [PATCH net-next 1/5] RDS: Re-add pf/sol access via sysctl
From:   Doug Ledford <dledford@redhat.com>
To:     Gerd Rausch <gerd.rausch@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Date:   Wed, 14 Aug 2019 11:56:57 -0400
In-Reply-To: <e0397d30-7405-a7af-286c-fe76887caf0a@oracle.com>
References: <e0397d30-7405-a7af-286c-fe76887caf0a@oracle.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-uUWdoCCJ1ECep/mp9jWF"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 14 Aug 2019 15:57:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-uUWdoCCJ1ECep/mp9jWF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-08-13 at 11:20 -0700, Gerd Rausch wrote:
> From: Andy Grover <andy.grover@oracle.com>
> Date: Tue, 24 Nov 2009 15:35:51 -0800
>=20
> Although RDS has an official PF_RDS value now, existing software
> expects to look for rds sysctls to determine it. We need to maintain
> these for now, for backwards compatibility.
>=20
> Signed-off-by: Andy Grover <andy.grover@oracle.com>
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
>  net/rds/sysctl.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>=20
> diff --git a/net/rds/sysctl.c b/net/rds/sysctl.c
> index e381bbcd9cc1..9760292a0af4 100644
> --- a/net/rds/sysctl.c
> +++ b/net/rds/sysctl.c
> @@ -49,6 +49,13 @@ unsigned int  rds_sysctl_max_unacked_bytes =3D (16 <<
> 20);
> =20
>  unsigned int rds_sysctl_ping_enable =3D 1;
> =20
> +/*
> + * We have official values, but must maintain the sysctl interface
> for existing
> + * software that expects to find these values here.
> + */
> +static int rds_sysctl_pf_rds =3D PF_RDS;
> +static int rds_sysctl_sol_rds =3D SOL_RDS;
> +
>  static struct ctl_table rds_sysctl_rds_table[] =3D {
>  	{
>  		.procname       =3D "reconnect_min_delay_ms",
> @@ -68,6 +75,20 @@ static struct ctl_table rds_sysctl_rds_table[] =3D {
>  		.extra1		=3D &rds_sysctl_reconnect_min_jiffies,
>  		.extra2		=3D &rds_sysctl_reconnect_max,
>  	},
> +	{
> +		.procname       =3D "pf_rds",
> +		.data		=3D &rds_sysctl_pf_rds,
> +		.maxlen         =3D sizeof(int),
> +		.mode           =3D 0444,
> +		.proc_handler   =3D &proc_dointvec,
> +	},
> +	{
> +		.procname       =3D "sol_rds",
> +		.data		=3D &rds_sysctl_sol_rds,
> +		.maxlen         =3D sizeof(int),
> +		.mode           =3D 0444,
> +		.proc_handler   =3D &proc_dointvec,
> +	},
>  	{
>  		.procname	=3D "max_unacked_packets",
>  		.data		=3D &rds_sysctl_max_unacked_packets,

Good Lord...RDS was taken into the kernel in Feb of 2009, so over 10
years ago.  The patch to put PF_RDS/AF_RDS/SOL_RDS was taken into
include/linux/socket.h Feb 26, 2009.  The RDS ports were allocated by
IANA on Feb 27 and May 20, 2009.  And you *still* have software that
needs this?  The only software that has ever used RDS was Oracle
software.  I would have expected you guys to update your source code to
do the right thing long before now.  In fact, I would expect you were
ready to retire all of the legacy software that needs this by now.  As
of today, does your current build of Oracle software still require this,
or have you at least fixed it up in your modern builds?

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-uUWdoCCJ1ECep/mp9jWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl1UL0kACgkQuCajMw5X
L93ophAAw3TK/JcdYvqs2yP2wP8HKL87nzD18xu3M6UeWfUQkZtW1u9Ag5zFGbf1
L3Z437/z8FJZldEUawZnA+3kecrYE/Ln03+WFQ51K00TVpJ8VJ8p1rwNESsYZT+C
gYVW5vCOZ+Ko9bbGXiugT8Kho1WbHvpJTXqgO5Uc3aZH/hvemCrwYXns8wbdIVvs
3Y/HA7NmlTbECHpdauo0YEcAAsDeqIJjFJJImnjkW4AJo+HJPZZDibhmwf0pNU/Q
8MVOd/5KvnTR7Cf0X+2hjW7XjCsfyelrCo1GCsUuJm85ji02zgAM/INwJXFxjd9M
s3XfBuWW+QawUzwocGkDECCMv0fA25CSZAy5jwoe2wbMnApQmI/c2eiTxs9ZbX4p
1nbA0FKCezS4CUmFe8umM+1au9El2HYa/puob7E5YzXezkz9QRdvK36xAtO4Si2z
KzwFY0pZuHDzk5uvLbNSbqGNMx3EP2JPpZyN0WpT+Ll8MizAw1/MiT4V5On1Kt74
Gh9CCl3WT+d4WrTw6apwPRDrzAsVcrEgV/leF2n+YTVmTNiIJOgfg3s1xx1ccDn3
qna9Eqg1kJ2XZ1tmBsRd/b3Dmn25JRt2dOasGTIUYttXwUXWjbaMOs5SS4WlG5sc
tAZLJECY2e7jADI5CQgp59DpJWN+N1o73YYWOJywYXI69jWjg90=
=25/J
-----END PGP SIGNATURE-----

--=-uUWdoCCJ1ECep/mp9jWF--


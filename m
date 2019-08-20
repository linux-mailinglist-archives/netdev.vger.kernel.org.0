Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98BE696458
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbfHTP2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:28:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbfHTP2J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 11:28:09 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82781300CB2C;
        Tue, 20 Aug 2019 15:28:09 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-63.rdu2.redhat.com [10.10.112.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B95427C46;
        Tue, 20 Aug 2019 15:28:08 +0000 (UTC)
Message-ID: <f3de2e40f1bc2eb219d3056ee954747db90dbbb4.camel@redhat.com>
Subject: Re: [PATCH 1/1] net: rds: add service level support in rds-info
From:   Doug Ledford <dledford@redhat.com>
To:     Zhu Yanjun <yanjun.zhu@oracle.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Date:   Tue, 20 Aug 2019 11:28:05 -0400
In-Reply-To: <1566262341-18165-1-git-send-email-yanjun.zhu@oracle.com>
References: <1566262341-18165-1-git-send-email-yanjun.zhu@oracle.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-e1JIyRDS9U1lSW/9G6r/"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 20 Aug 2019 15:28:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-e1JIyRDS9U1lSW/9G6r/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-08-19 at 20:52 -0400, Zhu Yanjun wrote:
> diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
> index fd6b5f6..cba368e 100644
> --- a/include/uapi/linux/rds.h
> +++ b/include/uapi/linux/rds.h
> @@ -250,6 +250,7 @@ struct rds_info_rdma_connection {
>         __u32           rdma_mr_max;
>         __u32           rdma_mr_size;
>         __u8            tos;
> +       __u8            sl;
>         __u32           cache_allocs;
>  };
> =20
> @@ -265,6 +266,7 @@ struct rds6_info_rdma_connection {
>         __u32           rdma_mr_max;
>         __u32           rdma_mr_size;
>         __u8            tos;
> +       __u8            sl;
>         __u32           cache_allocs;
>  };
> =20

This is a user space API break (as was the prior patch mentioned
below)...

> The commit fe3475af3bdf ("net: rds: add per rds connection cache
> statistics") adds cache_allocs in struct rds_info_rdma_connection
> as below:
> struct rds_info_rdma_connection {
> ...
>         __u32           rdma_mr_max;
>         __u32           rdma_mr_size;
>         __u8            tos;
>         __u32           cache_allocs;
>  };
> The peer struct in rds-tools of struct rds_info_rdma_connection is as
> below:
> struct rds_info_rdma_connection {
> ...
>         uint32_t        rdma_mr_max;
>         uint32_t        rdma_mr_size;
>         uint8_t         tos;
>         uint8_t         sl;
>         uint32_t        cache_allocs;
> };

Why are the user space rds tools not using the kernel provided abi
files?

In order to know if this ABI breakage is safe, we need to know what
versions of rds-tools are out in the wild and have their own headers
that we need to match up with.  Are there any versions of rds-tools that
actually use the kernel provided headers?  Are there any other users of
uapi/linux/rds.h besides rds-tools?

Once the kernel and rds-tools package are in sync, rds-tools needs to be
modified to use the kernel header and proper ABI maintenance needs to be
started.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-e1JIyRDS9U1lSW/9G6r/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl1cEYYACgkQuCajMw5X
L90K3g/+NqrGpIkwSa/o0tTfPws2rYXVY9FYj8njM4Amzc8wHxfuWGLuE4f5E6xV
fW8zS68FAW/gVCWLA4Ov6xN9mfXtl8eUBYxjYYOcyV231RKXKKTRjS6smCHsjpxz
4mbUIqVdy21GHD2N15j4FmBwFYTosIbYbeuQ/SJdsaHe6lQyXSGyc1pRXpUifZj1
L0bI0ku1bPeCivy4SF5UQMyDPiIi0S45+zmRNRaBiuA8mYfy7KrCpGRmnXzOEhqg
vE9csER9SJm67H912YjqWSVyAZPpM3Pj43sOYfHXTi681eZpwSJn8SPxzjiWGHJ/
msLR+kmUzd0n+b0bZOta2NTFlancXDocdj/+DBGJ9JeUH4ZQJZLpO/j44N7aZYZv
GsUf/X00toTxXS+0Jw6gG55bS4OmF6GoW4oZ8T5G49Ov+nXLlLlCdWpe4frkKJvq
bVOIvPU/6GRHa+/WO+wdRKw8zzYT0G1TqI+DKA09aYp1+1z1VFPmf8Xr18yCZmnx
JT2HKltKT+6lxTDePm9bRfHYk/bRGcWHT1+v/syYMvngQmDAolcrz6ZPLi5lNI2I
Y8/bI2y7QeQR2W9I4XE5n1+Xu6DcHFEe6IElVzAOY3N0zzkAlxYfIDl5x5ND3+a4
G07CltbubOAzTkmku4TQmqKt7M11CAG/wr5CoqKTmUh716gXPqI=
=dkWJ
-----END PGP SIGNATURE-----

--=-e1JIyRDS9U1lSW/9G6r/--


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952A043ADA
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388687AbfFMPYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388244AbfFMPYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 11:24:13 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F3BD42F8BFD;
        Thu, 13 Jun 2019 15:24:12 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-63.rdu2.redhat.com [10.10.112.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AF0619C67;
        Thu, 13 Jun 2019 15:24:11 +0000 (UTC)
Message-ID: <33dc8df3cb95e76c906ddb88041ba974bbe73a1c.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/2] ipoib: correcly show a VF hardware
 address
From:   Doug Ledford <dledford@redhat.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        mkubecek@suse.cz
Date:   Thu, 13 Jun 2019 11:24:09 -0400
In-Reply-To: <20190613142003.129391-3-dkirjanov@suse.com>
References: <20190613142003.129391-1-dkirjanov@suse.com>
         <20190613142003.129391-3-dkirjanov@suse.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-HdDD15E8H0DGo1j/KQ/U"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 13 Jun 2019 15:24:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-HdDD15E8H0DGo1j/KQ/U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-06-13 at 16:20 +0200, Denis Kirjanov wrote:
> in the case of IPoIB with SRIOV enabled hardware
> ip link show command incorrecly prints
> 0 instead of a VF hardware address. To correcly print the address
> add a new field to specify an address length.
>=20
> Before:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0 MAC 00:00:00:00:00:00, spoof checking off, link-state
> disable,
> trust off, query_rss off
> ...
> After:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
> checking off, link-state disable, trust off, query_rss off
>=20
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 9b5e11d3fb85..04ea7db08e87 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1998,6 +1998,7 @@ static int ipoib_get_vf_config(struct
> net_device *dev, int vf,
>  		return err;
> =20
>  	ivf->vf =3D vf;
> +	memcpy(ivf->mac, dev->dev_addr, dev->addr_len);
> =20
>  	return 0;
>  }

I'm ok with the patch, but your commit message does not match what the
patch does at all.  You need to correct the commit message.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
2FDD

--=-HdDD15E8H0DGo1j/KQ/U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl0CapkACgkQuCajMw5X
L91/aA/+MR47RawkBMXJ/bSYCXW7AvbOUTMjz2UQxIf0GZmzzIrRgjlgMJEwpCRm
/67/5C9MWE4T6rvcWKm0CgRnTj60iywwAUerkZ78u3n02Kw5gf9QvP73vXcQKKhB
D802Nv2+cFjFsyDSyYnDsR+AhKVuTizufIJ6O6x7DIKT/6nzSF9+Wsu55TbRZ8bv
HSCODKg8rrjzony1YQEJhzG75INnHPzo7sp5U3pofn1CaddwmLpTQS6UPIfd7FvR
hk92P8Vgjj6PK11twdWXgv7CZCKvqnqdbfaLMd/Ty3GJ7CxVBxwy1ynRvPu2KVu/
Z6tCgNv5Q8sp0hwguoEgmXXf2Wxr94cPafzLTor1oRMLQFlZHTkmKcS5djnl/3ee
pVVa97Dg+qDZc6a58kiZ5A/Cpa5Sn7ECxPNCz+NmMdU39FwVYGaWxLQMeDYG07XJ
pOINrrIsEFBMZZ7vPchHbFUCZPB/yKtOkL39jZW5z4+hrFscAT67eiQgaO+9KjYU
UZAYxTPLVkR7ffQRGMeVt+FwNq00Id3XxaHCrnh5tHMQbxiTmTHielZmadGaM6/Y
tiWvtR1wVYqGKBQ+tn8mKi0937mL+PP+2/D1+7nxe/Nqh1fwGoevz70m7EJRA6ny
mQ4lopbC2xmu75oQdMs22IF6KdLIWQNvbwOaXcRjIWQxFyhFMJ4=
=InDf
-----END PGP SIGNATURE-----

--=-HdDD15E8H0DGo1j/KQ/U--


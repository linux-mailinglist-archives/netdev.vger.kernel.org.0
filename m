Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B24CA96999
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbfHTTlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:41:36 -0400
Received: from sauhun.de ([88.99.104.3]:39934 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbfHTTlg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 15:41:36 -0400
Received: from localhost (p54B333DC.dip0.t-ipconnect.de [84.179.51.220])
        by pokefinder.org (Postfix) with ESMTPSA id 98ACD2C3014;
        Tue, 20 Aug 2019 21:41:33 +0200 (CEST)
Date:   Tue, 20 Aug 2019 21:41:29 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, sergei.shtylyov@cogentembedded.com,
        niklas.soderlund@ragnatech.se, horms@verge.net.au,
        magnus.damm@gmail.com, geert@glider.be
Subject: Re: [PATCH v3] ravb: implement MTU change while device is up
Message-ID: <20190820194129.jttuef4ghsx7rihf@katana>
References: <1566327686-8996-1-git-send-email-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cgoffdb52q5udzhz"
Content-Disposition: inline
In-Reply-To: <1566327686-8996-1-git-send-email-uli+renesas@fpond.eu>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cgoffdb52q5udzhz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Uli,

thanks for the patch.

On Tue, Aug 20, 2019 at 09:01:26PM +0200, Ulrich Hecht wrote:
> Uses the same method as various other drivers: shut the device down,
> change the MTU, then bring it back up again.
>=20
> Tested on Renesas D3 Draak and M3-W Salvator-X boards.
>=20
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
> Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Are these reviews left from v2? If so, I'd prefer to see them given
again because the logic was changed in v3.

> ---
>=20
> Hi!
>=20
> This revision reverts the MTU change if re-opening the device fails.
>=20
> CU
> Uli
>=20
>=20
>  drivers/net/ethernet/renesas/ravb_main.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ether=
net/renesas/ravb_main.c
> index ef8f089..402bcec 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1810,12 +1810,24 @@ static int ravb_do_ioctl(struct net_device *ndev,=
 struct ifreq *req, int cmd)
> =20
>  static int ravb_change_mtu(struct net_device *ndev, int new_mtu)
>  {
> +	unsigned int old_mtu =3D ndev->mtu;
> +
>  	if (netif_running(ndev))
> -		return -EBUSY;
> +		ravb_close(ndev);
> =20
>  	ndev->mtu =3D new_mtu;
>  	netdev_update_features(ndev);
> =20
> +	if (netif_running(ndev)) {
> +		int err =3D ravb_open(ndev);
> +
> +		if (err) {
> +			ndev->mtu =3D old_mtu;
> +			netdev_update_features(ndev);
> +			return err;
> +		}
> +	}
> +
>  	return 0;
>  }
> =20
> --=20
> 2.7.4
>=20

--cgoffdb52q5udzhz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl1cTOQACgkQFA3kzBSg
KbaVxg/+MOiU6g0MIwCeXx0omuh6adqORTwA1p9olho8DkSi+io1Ftkwg6TXrXG/
GsvwZpW32A7f4tXTuXI7Q1vpUOj4FvxO/1TmsIkfAAU7dpve74VRE8DCfh3oQ47Z
d8IHkrcpWhvVZLcapWJ5ze2Uz9yt6MDVqgyhtA+RlNYwfJK3m350lhR5rHJUmF3+
0JVIGgeohig8jhALUr/sbEOqGSxD/rdQb8lkyFXdeF7zWETxvhd5Kg1kvu+90zM+
NdAZp68qbea/xJRr3gVU8DW3LYzJ+3yT4nfpw6doCMgfU0Wz8C8gMFnWi7XE+YsG
Do6Yi4NWiQ39V9ZzGnWS1ho4fwB1aKCRuoCAgTi46uvU/0m02U7BE7qN6L7v221g
minYy8ZaGUvLrgUbVulgOWFkMkJEui6OuJGZjv7W17XxtCgVCEUsVIKiyasra25T
I2gjF7bKYQ/4UHk0ISqg+Q/pgJpuqXM+6lODF1b6QNlyJKnkhxAnOfsc8RYRwp/G
WGKbHVLR7wU4RLJeQTZ4Oz14khBJXe7z2ZTIotjpZ1zCaw8aMWzN3O86iUXeh+vB
3OE9fRPCmA3OVs44Ug5ajxtpBVe/hoapHUjcW7AobEnhzcf++V05DjQLiCytXQj5
o5x/712JIIrfcaClq27X16xF5nquPwwlAkX1fZ5dhpcg/T8Tx4E=
=RfBo
-----END PGP SIGNATURE-----

--cgoffdb52q5udzhz--

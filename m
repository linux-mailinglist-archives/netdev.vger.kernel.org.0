Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581AD33FC2E
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 01:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhCRAW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 20:22:59 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50197 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhCRAWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 20:22:38 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F175L1t6Dz9sW5;
        Thu, 18 Mar 2021 11:22:29 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616026950;
        bh=fUNm5nsTmJbb/LA9qfxZfL2ehsv3SnIPO3IcMpOAQeU=;
        h=Date:From:To:Cc:Subject:From;
        b=h3MTzyx5Z6OKNK+j/VGeAhL20bhlpOubHaHhdkzcIjFKQZeFYbmreYDcio2+LVfWp
         z0P2TgTT9sGss8qwkoUYbBix4Q/H6yvbA0tOvkBZo+6Nw+Q4mPwiMbtS4r6a1jSx0v
         F9sBVJHy122nvO+ZCLXc1OtNo3t4n27CWk3yoQhzoYt4CqUtlh9UhDCEYAsEcBSfgt
         LL6JJR97PmMxo9iSxt8NcPFSD8nbLXmmL0Zdulndj0LHR5lMLfQw13KbZHre+7z51g
         rh3q+xt/P6NoGICqQpxpmhdbEWr5YzHoDs2ha0tTYdRQ9S60n4NljD5TVgHf9vfSjF
         4qtOD/QV7snYg==
Date:   Thu, 18 Mar 2021 11:22:26 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210318112226.331beab9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/XJm9SaulWTFxoLmTZi2g.lB";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/XJm9SaulWTFxoLmTZi2g.lB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/pensando/ionic/ionic_txrx.c

between commit:

  d2c21422323b ("ionic: linearize tso skb with too many frags")

from the net tree and commit:

  f37bc3462e80 ("ionic: optimize fastpath struct usage")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 4087311f7082,03e00a6c413a..000000000000
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@@ -1077,19 -1082,16 +1082,18 @@@ static int ionic_tx(struct ionic_queue=20
 =20
  static int ionic_tx_descs_needed(struct ionic_queue *q, struct sk_buff *s=
kb)
  {
- 	int sg_elems =3D q->lif->qtype_info[IONIC_QTYPE_TXQ].max_sg_elems;
  	struct ionic_tx_stats *stats =3D q_to_tx_stats(q);
 +	int ndescs;
  	int err;
 =20
 -	/* If TSO, need roundup(skb->len/mss) descs */
 +	/* Each desc is mss long max, so a descriptor for each gso_seg */
  	if (skb_is_gso(skb))
 -		return (skb->len / skb_shinfo(skb)->gso_size) + 1;
 +		ndescs =3D skb_shinfo(skb)->gso_segs;
 +	else
 +		ndescs =3D 1;
 =20
- 	if (skb_shinfo(skb)->nr_frags <=3D sg_elems)
 -	/* If non-TSO, just need 1 desc and nr_frags sg elems */
+ 	if (skb_shinfo(skb)->nr_frags <=3D q->max_sg_elems)
 -		return 1;
 +		return ndescs;
 =20
  	/* Too many frags, so linearize */
  	err =3D skb_linearize(skb);

--Sig_/XJm9SaulWTFxoLmTZi2g.lB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBSnUIACgkQAVBC80lX
0GzusQf/cp8auZp9Tm5VS6+lEbYfLLX2UR4s+rvgCTni1HZ3oSTkbdLe9BS5ASGh
7wWkSveIKkt5OLm7vVA1w8EcROaAXgf2nI+RUhOag1X7FWAhwSuDiMyx9eB6eaEh
DzpH/uB+0Affx7gNhbj8q0zDI1vL3UhItCwStOdJETfEQT/iHX1iNLDKVOSlqpnu
0RajT2Hed+o9ZLprxhq41FLXyN/lXICNkTs9FK1UnPrKt6u683J4sTiYTYM4+9Ty
eGi2EAIFNECx8bTA+ieEiMwF1oyqmhbTv1tbmzE/9GisUysiFA926EugiF1jRZaH
NOxVq3o728pYJ1SVDB8fl9kYyIbuCQ==
=SfxJ
-----END PGP SIGNATURE-----

--Sig_/XJm9SaulWTFxoLmTZi2g.lB--

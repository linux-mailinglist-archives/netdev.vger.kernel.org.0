Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDAF19717E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 02:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgC3AmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 20:42:16 -0400
Received: from ozlabs.org ([203.11.71.1]:36583 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbgC3AmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 20:42:15 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48rDDz6MhVz9sPR;
        Mon, 30 Mar 2020 11:42:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1585528933;
        bh=B8g4PRJs5T7Ukzd8/GATXCt5GgL5C9WTKDYNobskixI=;
        h=Date:From:To:Cc:Subject:From;
        b=FWuUrmSwHX8w33pVQE9Y7fCySl2ycaPHMXPTPSvXApgtRJY+gZ8NAYSy2FLeD6v+R
         qiSRX6HB4u8bjYj/XDyj1MXHVco03AsqT9C/SQNPiE4n12wnUUu7kdfnPfV2tRtOa4
         b+lBTzSLhwYdiCTKLIJ//ZIWrW9ZD+v4JHwlRj9vnMPRliFNCc9uJNaeHD8bmiNdA/
         SjhKe5rx2B9FkXCpvLvIYzwaa6LC7Jf4D2H9xGMUOw3VB+6FhkA+mlXjvDgM1RDqLJ
         tJ1yutxNGupoD+F9xe4soswNhcOb+ZB0GccMSyEUVxY0AVBva3Mss6xb24zS8n9WvU
         CfA+L6bbFygQQ==
Date:   Mon, 30 Mar 2020 11:42:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: linux-next: manual merge of the crypto tree with the net-next tree
Message-ID: <20200330114209.1c7d5d11@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qU/dK2yDyZMdgSQ7Jl4PJ7B";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/qU/dK2yDyZMdgSQ7Jl4PJ7B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the crypto tree got a conflict in:

  drivers/crypto/chelsio/chcr_core.c

between commit:

  34aba2c45024 ("cxgb4/chcr : Register to tls add and del callback")

from the net-next tree and commit:

  53351bb96b6b ("crypto: chelsio/chcr - Fixes a deadlock between rtnl_lock =
and uld_mutex")

from the crypto tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/crypto/chelsio/chcr_core.c
index 0015810214a9,7e24c4881c34..000000000000
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@@ -35,12 -35,12 +35,16 @@@ static int chcr_uld_state_change(void *
 =20
  static chcr_handler_func work_handlers[NUM_CPL_CMDS] =3D {
  	[CPL_FW6_PLD] =3D cpl_fw6_pld_handler,
 +#ifdef CONFIG_CHELSIO_TLS_DEVICE
 +	[CPL_ACT_OPEN_RPL] =3D chcr_ktls_cpl_act_open_rpl,
 +	[CPL_SET_TCB_RPL] =3D chcr_ktls_cpl_set_tcb_rpl,
 +#endif
  };
 =20
+ #ifdef CONFIG_CHELSIO_IPSEC_INLINE
+ static void update_netdev_features(void);
+ #endif /* CONFIG_CHELSIO_IPSEC_INLINE */
+=20
  static struct cxgb4_uld_info chcr_uld_info =3D {
  	.name =3D DRV_MODULE_NAME,
  	.nrxq =3D MAX_ULD_QSETS,
@@@ -204,15 -204,6 +207,11 @@@ static void *chcr_uld_add(const struct=20
  	}
  	u_ctx->lldi =3D *lld;
  	chcr_dev_init(u_ctx);
- #ifdef CONFIG_CHELSIO_IPSEC_INLINE
- 	if (lld->crypto & ULP_CRYPTO_IPSEC_INLINE)
- 		chcr_add_xfrmops(lld);
- #endif /* CONFIG_CHELSIO_IPSEC_INLINE */
 +
 +#ifdef CONFIG_CHELSIO_TLS_DEVICE
 +	if (lld->ulp_crypto & ULP_CRYPTO_KTLS_INLINE)
 +		chcr_enable_ktls(padap(&u_ctx->dev));
 +#endif
  out:
  	return u_ctx;
  }

--Sig_/qU/dK2yDyZMdgSQ7Jl4PJ7B
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6BQGEACgkQAVBC80lX
0Gy00Af7B/b3nw/o6e9EgWEMNQxR9lOCdBNHvqWAAJNvrfmCBzVywCrYNm+uhPav
6n0SU54O7MdSkvL5pJZKjCMQmAYqZw54qzEwMo0JDddvTd5kvrIF/wIK8GFA0zBF
5aVe7R+IIeRSALpt65TMCptq6h+mRruorPhii7ugeOvRLcwLeSoLis/3BgsqrJ7x
S/9dDG9rivrKDudiXqLmkTvklRvhH+KcJM8TmtDXzN+b7bQzksa1SA2YcEv6rUNN
fDUThDqFBQ/yxF9IeD90SiQlnr9cF8Ux0iP1oKyp0dNNNAUF+Pwfc6mOkemZrev1
Pl8TJbuZl7IeIpSX/ftIgvUvqFVkcQ==
=J2Dh
-----END PGP SIGNATURE-----

--Sig_/qU/dK2yDyZMdgSQ7Jl4PJ7B--

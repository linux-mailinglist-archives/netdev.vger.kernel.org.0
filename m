Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246BE3CCBDC
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 02:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbhGSAyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 20:54:44 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:52091 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233530AbhGSAym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 20:54:42 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GSjwD2stzz9sRf;
        Mon, 19 Jul 2021 10:51:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1626655902;
        bh=SmOQ1yrThLkTVeJ5jlo9RWwKgnEmPbixTf/sBetw5EA=;
        h=Date:From:To:Cc:Subject:From;
        b=sSIm38iQ5mDjFfpTn+S0Or0UMrOOfG9blitMhdkzDRIsiDjfT50Ul9gFfiVJG7UVu
         R/RKa+yMADKc+MLHpktkjYbPBOWMFvXT4MdaWV7/kOqUd8BKQAkoEtVXdxP9kU0pyU
         mSFAuvG3flOsDB1Eo9m+Pv2lqXEmcCi8fgLFwV/6UHYUZKfkcnXPQpAgCK1soAzoCX
         YmGWg/6+TC1X+I5OrGYkUXWKE+F8JpD/AxrqggSWKvlliuoY25BHyOZosz0ceYfpvL
         j+WHASIpdKjrIMrweDDkJlmkJYs1JXwBiAXJqPlwUT4j0ewvg9HHhahfWLKq+XKHrW
         QeeburEQdu+0A==
Date:   Mon, 19 Jul 2021 10:51:38 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Cody Haas <chaas@riotgames.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Lisa Watanabe <lwatanabe@riotgames.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Zvi Effron <zeffron@riotgames.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210719105138.2426741b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/tbaoWTj/FgoKmq9_RejeweE";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/tbaoWTj/FgoKmq9_RejeweE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/bpf/test_run.c

between commit:

  5e21bb4e8125 ("bpf, test: fix NULL pointer dereference on invalid expecte=
d_attach_type")

from the net tree and commit:

  47316f4a3053 ("bpf: Support input xdp_md context in BPF_PROG_TEST_RUN")

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

diff --cc net/bpf/test_run.c
index 1cc75c811e24,cda8375bbbaf..000000000000
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@@ -697,15 -756,24 +756,27 @@@ int bpf_prog_test_run_xdp(struct bpf_pr
  	struct netdev_rx_queue *rxqueue;
  	struct xdp_buff xdp =3D {};
  	u32 retval, duration;
+ 	struct xdp_md *ctx;
  	u32 max_data_sz;
  	void *data;
- 	int ret;
+ 	int ret =3D -EINVAL;
 =20
 +	if (prog->expected_attach_type =3D=3D BPF_XDP_DEVMAP ||
 +	    prog->expected_attach_type =3D=3D BPF_XDP_CPUMAP)
 +		return -EINVAL;
- 	if (kattr->test.ctx_in || kattr->test.ctx_out)
- 		return -EINVAL;
+ 	ctx =3D bpf_ctx_init(kattr, sizeof(struct xdp_md));
+ 	if (IS_ERR(ctx))
+ 		return PTR_ERR(ctx);
+=20
+ 	if (ctx) {
+ 		/* There can't be user provided data before the meta data */
+ 		if (ctx->data_meta || ctx->data_end !=3D size ||
+ 		    ctx->data > ctx->data_end ||
+ 		    unlikely(xdp_metalen_invalid(ctx->data)))
+ 			goto free_ctx;
+ 		/* Meta data is allocated from the headroom */
+ 		headroom -=3D ctx->data;
+ 	}
 =20
  	/* XDP have extra tailroom as (most) drivers use full page */
  	max_data_sz =3D 4096 - headroom - tailroom;

--Sig_/tbaoWTj/FgoKmq9_RejeweE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmD0zJoACgkQAVBC80lX
0GwqOQgAhhIjnZxsNIulTAgCbUTi7bmTRXkBcabxW2Pyxv1XSyXC9TTgJAqFJvVR
zpvfmOVJAbVuEeur08Xn+yeafXkxS8qA9XPCeuCYf71bw/Drzqu//wOWLurFcizT
7j4HbxaaigoyNG+XbIwA2bCjB2fsi6PU4vYK5eh1WxTydQDS48mx+F7CbyJP3SYs
tb3JdY5UGDVN7Oqh/HoShgP9dJXxARALccqXXrLztEX90wlAYf7BVe19PVxnpB1B
/oqRdliy7GF7ZE3rlheHmTakwKuUA2oqj95BI5Fhp/Nn547Okrq8VbFcKe2cI5Im
dBTK1tV54BQGdW4kn6y6InZ4s3HewQ==
=mnov
-----END PGP SIGNATURE-----

--Sig_/tbaoWTj/FgoKmq9_RejeweE--

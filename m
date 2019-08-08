Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F07E85851
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 04:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389560AbfHHCxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 22:53:31 -0400
Received: from ozlabs.org ([203.11.71.1]:35857 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbfHHCxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 22:53:31 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 463tGw3FLXz9s7T;
        Thu,  8 Aug 2019 12:53:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565232808;
        bh=/PuKtT7hVEGOuEdR+eb2Zo3CrrUaO63bl10cgsb8BH4=;
        h=Date:From:To:Cc:Subject:From;
        b=h2J8ojQiYVX+SIFRiezM7ePsVtjVQwzWzFA0f9xnHmsBVnu6Fsaz2F2RMt4X+z++0
         C84YjQH/VGCZXtzn0W6H7l+JDtcKvsASqlS63+WBijsGT/Z4v6op/oIfRAAD/WbX5+
         kF2VMypPt4quEdbIJ7DJu4SDt8tUIBRhKTu/JhnGUagOJMezxE9rD6jt1/ichXiG1m
         mU275Hk37Hjy19kgIUugnWW8Ze3Q4csh6zHOVlmJY8opVj6ZGMbA5+3BhVdj86jAhn
         1rOzaMHqhE3LF1GQ1Vr5mqLvSbKDG3HZi9DRY62yJmiawXDEa+akB9XNDxI26JwxzN
         7X25Qy+eMoyWQ==
Date:   Thu, 8 Aug 2019 12:53:26 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Subject: linux-next: manual merge of the bpf-next tree with Linus' tree
Message-ID: <20190808125326.614065d6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/t965bQleaCIqT2n30_GaWGl";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/t965bQleaCIqT2n30_GaWGl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  tools/lib/bpf/libbpf.c

between commit:

  1d4126c4e119 ("libbpf: sanitize VAR to conservative 1-byte INT")

from Linus' tree and commit:

  b03bc6853c0e ("libbpf: convert libbpf code to use new btf helpers")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/lib/bpf/libbpf.c
index 2b57d7ea7836,3abf2dd1b3b5..000000000000
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@@ -1370,22 -1374,16 +1372,21 @@@ static void bpf_object__sanitize_btf(st
 =20
  	for (i =3D 1; i <=3D btf__get_nr_types(btf); i++) {
  		t =3D (struct btf_type *)btf__type_by_id(btf, i);
- 		kind =3D BTF_INFO_KIND(t->info);
 =20
- 		if (!has_datasec && kind =3D=3D BTF_KIND_VAR) {
+ 		if (!has_datasec && btf_is_var(t)) {
  			/* replace VAR with INT */
  			t->info =3D BTF_INFO_ENC(BTF_KIND_INT, 0, 0);
 -			t->size =3D sizeof(int);
 -			*(int *)(t + 1) =3D BTF_INT_ENC(0, 0, 32);
 +			/*
 +			 * using size =3D 1 is the safest choice, 4 will be too
 +			 * big and cause kernel BTF validation failure if
 +			 * original variable took less than 4 bytes
 +			 */
 +			t->size =3D 1;
- 			*(int *)(t+1) =3D BTF_INT_ENC(0, 0, 8);
- 		} else if (!has_datasec && kind =3D=3D BTF_KIND_DATASEC) {
++			*(int *)(t + 1) =3D BTF_INT_ENC(0, 0, 8);
+ 		} else if (!has_datasec && btf_is_datasec(t)) {
  			/* replace DATASEC with STRUCT */
- 			struct btf_var_secinfo *v =3D (void *)(t + 1);
- 			struct btf_member *m =3D (void *)(t + 1);
+ 			const struct btf_var_secinfo *v =3D btf_var_secinfos(t);
+ 			struct btf_member *m =3D btf_members(t);
  			struct btf_type *vt;
  			char *name;
 =20

--Sig_/t965bQleaCIqT2n30_GaWGl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1LjqYACgkQAVBC80lX
0GyyZQf9HpGsTBYYj/EbUlYjBJQiYNKf3nilJ36/aZKDUa9R6wBu3tHu6p24zRRh
cSvwL8hit9tcUZOI1t4OyVh64mlW8GRxE5kKu0722dxRnSMQx7Td3LTA6inrlCCV
CnJRlEoCHpP7vITbo+0cwVhJt+OR4k4/GEAf/mZVqZAwoXMsUZkC6LY30aKWDJfc
3TzURLuzemJSJvZAsNOXDHevUM++t+01n1iq+3Y6bf9grOyQc9NI732GKTTxOPEE
FpNhnSp8H24r2yBiuIgJqHSNAwZy/03TUtiijE8xomQZoIWOUn10BL4d2tnP/kpn
kU6k1xWsopkhAi54Z0ebJcEEjpDLWA==
=cXek
-----END PGP SIGNATURE-----

--Sig_/t965bQleaCIqT2n30_GaWGl--

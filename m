Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239F562730E
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 23:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbiKMWuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 17:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiKMWuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 17:50:12 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9163FD1F;
        Sun, 13 Nov 2022 14:50:09 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4N9SLz2SKLz4xYV;
        Mon, 14 Nov 2022 09:50:02 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668379804;
        bh=zDOsngkfXlRy4ZJSgGeBHh2499G+gL1UNyWeAO9sNtc=;
        h=Date:From:To:Cc:Subject:From;
        b=IldIgoii4uuNzU0TqRsRMRO03FJWsO4khqkOLOqW4B5J6PNY77ERVKrFrpUFFdL+6
         hqKfU+8bY89Dx8tPiXmQOx0NjgwNtvzkrdDuTbOv6qlpiTnAvBVEQ/3s7DVMZB8LpB
         bFpN87Gwud6Cpznk27e2dsk3aWzxSU/ic41T5V06bOd5ItIwTt8RSfbV4QyRMy+DFP
         Uqh3hxrd9fiuCj9NPGnxCaeCIESH3n+EZr4ZmEOj55nEEo+RFXytDAD+mmvQalKFyH
         3hBPcN7bh77PMvPxSI8Bg8NjzwcoL/x0mAkRfpzs29bPLk5ESD/FY/AVmuMLx9xFC7
         P/hzJZa4QuUeQ==
Date:   Mon, 14 Nov 2022 09:50:00 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Xu Kuohai <xukuohai@huawei.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20221114095000.67a73239@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/bHXgZWadrbE1hGpq3kgqFTE";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/bHXgZWadrbE1hGpq3kgqFTE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/linux/bpf.h

between commit:

  1f6e04a1c7b8 ("bpf: Fix offset calculation error in __copy_map_value and =
zero_map_value")

from the net tree and commits:

  aa3496accc41 ("bpf: Refactor kptr_off_tab into btf_record")
  f71b2f64177a ("bpf: Refactor map->off_arr handling")

from the net-next tree.

I fixed it up (I think - see below) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/linux/bpf.h
index c1bd1bd10506,798aec816970..000000000000
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@@ -311,13 -356,14 +356,14 @@@ static inline void bpf_obj_memcpy(struc
  		return;
  	}
 =20
- 	for (i =3D 0; i < map->off_arr->cnt; i++) {
- 		u32 next_off =3D map->off_arr->field_off[i];
+ 	for (i =3D 0; i < foffs->cnt; i++) {
+ 		u32 next_off =3D foffs->field_off[i];
+ 		u32 sz =3D next_off - curr_off;
 =20
- 		memcpy(dst + curr_off, src + curr_off, next_off - curr_off);
- 		curr_off =3D next_off + map->off_arr->field_sz[i];
+ 		memcpy(dst + curr_off, src + curr_off, sz);
 -		curr_off +=3D foffs->field_sz[i];
++		curr_off =3D next_off + foffs->field_sz[i];
  	}
- 	memcpy(dst + curr_off, src + curr_off, map->value_size - curr_off);
+ 	memcpy(dst + curr_off, src + curr_off, size - curr_off);
  }
 =20
  static inline void copy_map_value(struct bpf_map *map, void *dst, void *s=
rc)
@@@ -340,13 -386,19 +386,19 @@@ static inline void bpf_obj_memzero(stru
  		return;
  	}
 =20
- 	for (i =3D 0; i < map->off_arr->cnt; i++) {
- 		u32 next_off =3D map->off_arr->field_off[i];
+ 	for (i =3D 0; i < foffs->cnt; i++) {
+ 		u32 next_off =3D foffs->field_off[i];
+ 		u32 sz =3D next_off - curr_off;
 =20
- 		memset(dst + curr_off, 0, next_off - curr_off);
- 		curr_off =3D next_off + map->off_arr->field_sz[i];
+ 		memset(dst + curr_off, 0, sz);
 -		curr_off +=3D foffs->field_sz[i];
++		curr_off =3D next_off + foffs->field_sz[i];
  	}
- 	memset(dst + curr_off, 0, map->value_size - curr_off);
+ 	memset(dst + curr_off, 0, size - curr_off);
+ }
+=20
+ static inline void zero_map_value(struct bpf_map *map, void *dst)
+ {
+ 	bpf_obj_memzero(map->field_offs, dst, map->value_size);
  }
 =20
  void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,

--Sig_/bHXgZWadrbE1hGpq3kgqFTE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNxdJkACgkQAVBC80lX
0Gzq6wf/eNATYNqwjnk4fLLPJt+g4zBHX+ZjAMCY94pjLo9u/kuK36i1de4i2GUI
96eQrGNkDR3wuJMGjn6J0YNpQcDYi82fS0Ed886xdGwZvo9MICqxRB5c3zPkIvhe
VPmmDURxJT4COxdU09Bxs23VGgUw5sW9dUhk/mvMOPONDxJiN9WUhp9Xj1ItIjgQ
CpMJCrSDCWe7G1ifVM6YZ37Qm8Njj8Gn0dreNUVYXZ5qCQ+DfHEov5otQGx12Y6a
g3DYjOoE3IoqufvcejP5V0A37WlLRfS7+zo2CE+7umsfDH30myIvd1SLwYIUvRx1
LV+xbQiEbsXsRTD1SALYf1gFotkzuA==
=LXYp
-----END PGP SIGNATURE-----

--Sig_/bHXgZWadrbE1hGpq3kgqFTE--

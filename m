Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D0E101052
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 01:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfKSAnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 19:43:43 -0500
Received: from ozlabs.org ([203.11.71.1]:58343 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbfKSAnn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 19:43:43 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47H6Wc0jffz9sPT;
        Tue, 19 Nov 2019 11:43:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1574124220;
        bh=xMxw573KD5jDq42n3/8r5oPhgnATMUQil1KgKEsaq6k=;
        h=Date:From:To:Cc:Subject:From;
        b=Astlrpt6b8XGpP7RNqEGM0Z5G2fdpwvY4t3Mz1z8TYVrTGepZcB8are8BrslzOOOD
         Vla9pNoaA8YURXDbSvaSSzeTcYhtLtkWjqYqmR1T1bNKwZeeq5vgIHnnPTgbsBJ8ei
         nnBvyvBCvUghTfEYxiX1GX7xgFisxJo0JQLpollXxSRKiex8LdGlOAKJkFBmyXRLlG
         BlDM4BB0ZOS/Rnh8G2mvGePQ6WauAouMsmZkGIx5bg6G36doAEk+DSi/ZNwDfKm1g2
         q1pj/NwWBl+zEFiRZS+PSyYdQ39ApNEsIeDbvphU2i1TtvWdJAxMBhY1rPmMibjfNI
         IdKFLcATuJAsg==
Date:   Tue, 19 Nov 2019 11:43:33 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@intel.com>, Andrii Nakryiko <andriin@fb.com>
Subject: linux-next: manual merge of the bpf-next tree with Linus' tree
Message-ID: <20191119114333.757f8429@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/eTLoDxRxjWpc6AMDcATFG0N";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/eTLoDxRxjWpc6AMDcATFG0N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got conflicts in:

  include/linux/bpf.h
  kernel/bpf/syscall.c

between commit:

  ff1c08e1f74b ("bpf: Change size to u64 for bpf_map_{area_alloc, charge_in=
it}()")

from Linus' tree and commit:

  fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")

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

diff --cc include/linux/bpf.h
index 464f3f7e0b7a,e913dd5946ae..000000000000
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@@ -688,7 -798,8 +798,8 @@@ int bpf_map_charge_init(struct bpf_map_
  void bpf_map_charge_finish(struct bpf_map_memory *mem);
  void bpf_map_charge_move(struct bpf_map_memory *dst,
  			 struct bpf_map_memory *src);
 -void *bpf_map_area_alloc(size_t size, int numa_node);
 -void *bpf_map_area_mmapable_alloc(size_t size, int numa_node);
 +void *bpf_map_area_alloc(u64 size, int numa_node);
++void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
  void bpf_map_area_free(void *base);
  void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
 =20
diff --cc kernel/bpf/syscall.c
index d447b5e343bf,bac3becf9f90..000000000000
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@@ -127,7 -127,7 +127,7 @@@ static struct bpf_map *find_and_alloc_m
  	return map;
  }
 =20
- void *bpf_map_area_alloc(u64 size, int numa_node)
 -static void *__bpf_map_area_alloc(size_t size, int numa_node, bool mmapab=
le)
++static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
  {
  	/* We really just want to fail instead of triggering OOM killer
  	 * under memory pressure, therefore we set __GFP_NORETRY to kmalloc,
@@@ -142,10 -142,8 +142,11 @@@
  	const gfp_t flags =3D __GFP_NOWARN | __GFP_ZERO;
  	void *area;
 =20
 +	if (size >=3D SIZE_MAX)
 +		return NULL;
 +
- 	if (size <=3D (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
+ 	/* kmalloc()'ed memory can't be mmap()'ed */
+ 	if (!mmapable && size <=3D (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
  		area =3D kmalloc_node(size, GFP_USER | __GFP_NORETRY | flags,
  				    numa_node);
  		if (area !=3D NULL)
@@@ -157,6 -159,16 +162,16 @@@
  					   flags, __builtin_return_address(0));
  }
 =20
 -void *bpf_map_area_alloc(size_t size, int numa_node)
++void *bpf_map_area_alloc(u64 size, int numa_node)
+ {
+ 	return __bpf_map_area_alloc(size, numa_node, false);
+ }
+=20
 -void *bpf_map_area_mmapable_alloc(size_t size, int numa_node)
++void *bpf_map_area_mmapable_alloc(u64 size, int numa_node)
+ {
+ 	return __bpf_map_area_alloc(size, numa_node, true);
+ }
+=20
  void bpf_map_area_free(void *area)
  {
  	kvfree(area);

--Sig_/eTLoDxRxjWpc6AMDcATFG0N
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3TOrUACgkQAVBC80lX
0GzhIAf8CSu6s2K7IPHLOZSz4ZsJ2Q9LTU1JDb0hFFJ+Ve4dg1fH1ZbyAoS/3ha6
oG6QV1jtvtgzTbroCajhZCQiT45+d/bc4Io6s5X27YqO1c6hyjodNk2CsLIrtYeN
ZST2bwjZxqX9ohwlQNEQsmnamBAHuBZrE676e8mBb56TQYKnHwN6nv2VxDPA7qNi
bIYx6HmWMhvf5XV2zGvh3JroBCKL0jB6uXoRxPogb6ZX4uELTME4zBBc5EaCzjLz
I02N/rxWdhZnmL7Vn3fL1do+TR4CGTXeOo7JasSXl+9Kxtebr2naThcd+I79qITn
iZAG4finVHbpghB8TpN+ljqgWI6tWA==
=UlaO
-----END PGP SIGNATURE-----

--Sig_/eTLoDxRxjWpc6AMDcATFG0N--

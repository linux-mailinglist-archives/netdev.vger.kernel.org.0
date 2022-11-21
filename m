Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3752263182B
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 02:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiKUB13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 20:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiKUB11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 20:27:27 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9C81A3B4;
        Sun, 20 Nov 2022 17:27:11 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NFqW06L00z4x1V;
        Mon, 21 Nov 2022 12:27:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668994029;
        bh=HerYTWiDjrKgErD/W+bw3Gvh7wqbDTpztgWNxqrNuo4=;
        h=Date:From:To:Cc:Subject:From;
        b=G6VBGpLwCaGsdy/1h/JWjvRpjbJzHZqLzww+yjhQioE3bmnn2QW9dhY0YfdpnqpQw
         XZaqDytpGawypuyV8sRl9BDyhnFaGZ3QFtBddeq7rvdHnNhtbBpzuEaZDULDcece3D
         7dCzGH6lJpZm6XCoRxlAV3SuV3RHxpiln43mjlIKUwrzghsSH8z65LqqDMr6He3dLq
         dP2sAyZnLb45uJ9TJsVGrAgpkfjdPGALG9kmLWWrgeZBhMtbAxKRWLSH7HBjyuI5c2
         tm2fRBcjoxYcRd+r30DnCf/iudYQlIUkOH5iwfWpGoAEeZYF8hBgtNLVDrmNuVimZf
         nIHAzsJESgW1w==
Date:   Mon, 21 Nov 2022 12:27:07 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>,
        Kang Minchul <tegongkang@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20221121122707.44d1446a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/X6VBSmPQXqhsNkiUe4x65gI";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/X6VBSmPQXqhsNkiUe4x65gI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  tools/lib/bpf/ringbuf.c

between commit:

  927cbb478adf ("libbpf: Handle size overflow for ringbuf mmap")

from the bpf tree and commit:

  b486d19a0ab0 ("libbpf: checkpatch: Fixed code alignments in ringbuf.c")

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

diff --cc tools/lib/bpf/ringbuf.c
index 6af142953a94,51808c5f0014..000000000000
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@@ -128,13 -128,9 +128,13 @@@ int ring_buffer__add(struct ring_buffe
  	/* Map read-only producer page and data pages. We map twice as big
  	 * data size to allow simple reading of samples that wrap around the
  	 * end of a ring buffer. See kernel implementation for details.
- 	 * */
+ 	 */
 -	tmp =3D mmap(NULL, rb->page_size + 2 * info.max_entries, PROT_READ,
 -		   MAP_SHARED, map_fd, rb->page_size);
 +	mmap_sz =3D rb->page_size + 2 * (__u64)info.max_entries;
 +	if (mmap_sz !=3D (__u64)(size_t)mmap_sz) {
 +		pr_warn("ringbuf: ring buffer size (%u) is too big\n", info.max_entries=
);
 +		return libbpf_err(-E2BIG);
 +	}
 +	tmp =3D mmap(NULL, (size_t)mmap_sz, PROT_READ, MAP_SHARED, map_fd, rb->p=
age_size);
  	if (tmp =3D=3D MAP_FAILED) {
  		err =3D -errno;
  		ringbuf_unmap_ring(rb, r);

--Sig_/X6VBSmPQXqhsNkiUe4x65gI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmN60+sACgkQAVBC80lX
0Gz1hQf/c0ZKzIjRRzagDvsnuBXW3BurfQsJXye+LzneX3vZheR7vIpmy1f7GKE4
jwgZwTArbIGnktRzD6/KilY/WM1TJTrSLqO5NBLJygET7aIyBe5NlURIR1kTLKVD
o3yGTEptzvmNh2q3fpfvb1MQAyLZ8QF0btXiFAFJ71RpH/OqvlaRzu636RsQySX4
MhvQuFIalZ7vzSqC9fS89dwQJDVk63gUcVEetA+icGJnjp455zxotC7I/Xs20n0z
z8cuMmBcy4o3cjoOw44IeBvjS1nJaJ/quN6iXoBFlcwRaM4V4sC1+MZ4kaK5pV+H
6xV0W7ox3vaXgzEuBX84BCCpccmayw==
=unmT
-----END PGP SIGNATURE-----

--Sig_/X6VBSmPQXqhsNkiUe4x65gI--

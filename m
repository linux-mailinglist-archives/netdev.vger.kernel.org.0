Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048591F4A1C
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 01:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgFIXaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 19:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgFIXaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 19:30:21 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A35C05BD1E;
        Tue,  9 Jun 2020 16:30:21 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49hRDm2cmSz9sRR;
        Wed, 10 Jun 2020 09:30:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591745416;
        bh=lTqyPH1IXzHOL7YNp6Xf9Boc2LGwLLUlsKJcuVTbVIc=;
        h=Date:From:To:Cc:Subject:From;
        b=T4pD86Zp/YjSKhnt56tra6AT0I67mQbEqxqlxmPN0eV92XdWPIBLMM2+vKCL41aTa
         w/jfvQsoMFJBvnxUNBy1IW/GgSU4bOQXeELXANkpo9NeoNJaC0JdwSSGt6e/voa4tz
         2BvMy+qQaMdcx5KB/jS+WgliBj4+I2z7hXSgvnK81Er8lBwkgIqfRewqVs4JzPhdDu
         C119QGFU4U3CQ7reqjRLP5xFsxbJRW8NCbYOv79nNV34FZxn1L7Lo5nOfH+n9452Kb
         lF/LZpNvj8A8O1x+AxRa3WJRc2o8MPzXP1iRGcHiFXbffVFDoGTstehHKmuzTaLQ8K
         G/AlXmxN8FbLg==
Date:   Wed, 10 Jun 2020 09:30:12 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjun Roy <arjunroy@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-ID: <20200610093012.13391de8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_WFzV36PO8JK65ZVN9wu=UP";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/_WFzV36PO8JK65ZVN9wu=UP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got a conflict in:

  net/ipv4/tcp.c

between commit:

  d8ed45c5dcd4 ("mmap locking API: use coccinelle to convert mmap_sem rwsem=
 call sites")

from Linus' tree and commit:

  3763a24c727e ("net-zerocopy: use vm_insert_pages() for tcp rcv zerocopy")

from the net tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/ipv4/tcp.c
index 27716e4932bc,ecbba0abd3e5..000000000000
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@@ -1762,7 -1796,9 +1796,9 @@@ static int tcp_zerocopy_receive(struct=20
 =20
  	sock_rps_record_flow(sk);
 =20
+ 	tp =3D tcp_sk(sk);
+=20
 -	down_read(&current->mm->mmap_sem);
 +	mmap_read_lock(current->mm);
 =20
  	vma =3D find_vma(current->mm, address);
  	if (!vma || vma->vm_start > address || vma->vm_ops !=3D &tcp_vm_ops) {
@@@ -1817,17 -1863,27 +1863,27 @@@
  			zc->recv_skip_hint -=3D remaining;
  			break;
  		}
- 		ret =3D vm_insert_page(vma, address + length,
- 				     skb_frag_page(frags));
- 		if (ret)
- 			break;
+ 		pages[pg_idx] =3D skb_frag_page(frags);
+ 		pg_idx++;
  		length +=3D PAGE_SIZE;
- 		seq +=3D PAGE_SIZE;
  		zc->recv_skip_hint -=3D PAGE_SIZE;
  		frags++;
+ 		if (pg_idx =3D=3D PAGE_BATCH_SIZE) {
+ 			ret =3D tcp_zerocopy_vm_insert_batch(vma, pages, pg_idx,
+ 							   &curr_addr, &length,
+ 							   &seq, zc);
+ 			if (ret)
+ 				goto out;
+ 			pg_idx =3D 0;
+ 		}
+ 	}
+ 	if (pg_idx) {
+ 		ret =3D tcp_zerocopy_vm_insert_batch(vma, pages, pg_idx,
+ 						   &curr_addr, &length, &seq,
+ 						   zc);
  	}
  out:
 -	up_read(&current->mm->mmap_sem);
 +	mmap_read_unlock(current->mm);
  	if (length) {
  		WRITE_ONCE(tp->copied_seq, seq);
  		tcp_rcv_space_adjust(sk);

--Sig_/_WFzV36PO8JK65ZVN9wu=UP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7gG4QACgkQAVBC80lX
0GyCnwf6ApvtS2bOp659IILBedqzBUQSqVTYXYtsSNhbQclLg3tUdHFHmrPYRDVE
Ki/w1uhDK9vG0ZzZnLselpQDcDI0acNEb2RZ8Y4CjCQHqB+QmSHoEvAzEJGn/YUg
DQLHLzKCWftRf555QJfBzm8vk+jZIzE6v0k6BsMfLLRdGLDX68dQ6w0/SyN9Ex1I
M1cvRqSSrIvHQdkl3y4BgTuC1DXOiFD3k2xMtwgGZUQ4N1oY7zyOcl6aydoJO4X7
wTAQXNdAWRWrMISkTE2zd9ziWyNYu3xuqQIRAGuczq0VzvsPjjFrRXWRa9HRCOeo
YLV7f8coF9/mtZnyw/BYv1pq175lZw==
=x2XT
-----END PGP SIGNATURE-----

--Sig_/_WFzV36PO8JK65ZVN9wu=UP--

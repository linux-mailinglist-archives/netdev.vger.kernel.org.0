Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDAA2CEABF
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 10:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgLDJUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 04:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgLDJUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 04:20:51 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB474C061A4F;
        Fri,  4 Dec 2020 01:20:10 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CnRxf2ZMXz9sWt;
        Fri,  4 Dec 2020 20:20:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607073607;
        bh=bAsk8n7gqFwKjHWwsHSOXYDy5wkPoQQyApSqZbNhf4E=;
        h=Date:From:To:Cc:Subject:From;
        b=COBC7McCpEGqFC/wJt6Ji1ZUxqSBbcsgMDiH0OSauzjbuvowuzHXDpraMKu0hK4vo
         O7oTfw65+pxvnA2eT5Qa3+Y9Lijmwh52qTME9LTd1w40IfgIwnA7S6hZ2tD9Dez3E4
         fAEigSI2laov23FS/NMJYNdM+nLBx2sTJFXlNdSpHCJJIUtLDu4yenyNtBCW0k8M7l
         vFUqArdK1JxBKBJvRW+RSGjJYoQzLbhbqz8tEzOKrsRYFY8IhhVjhPBUo1zuG5TTl2
         gypIgfpy9vd78mZbvxThAwnqPxMtI0nasSwYOBeqbKAhwiBI0vn8OypJV9k24Gm9Yf
         DsI/GZ4c5blEA==
Date:   Fri, 4 Dec 2020 20:20:05 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Alex Shi <alex.shi@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Roman Gushchin <guro@fb.com>,
        Shakeel Butt <shakeelb@google.com>
Subject: linux-next: manual merge of the akpm-current tree with the bpf-next
 tree
Message-ID: <20201204202005.3fb1304f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+K=st_HCMWn3JpH6IhaFwtk";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/+K=st_HCMWn3JpH6IhaFwtk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm-current tree got conflicts in:

  include/linux/memcontrol.h
  mm/memcontrol.c

between commit:

  bcfe06bf2622 ("mm: memcontrol: Use helpers to read page's memcg data")

from the bpf-next tree and commits:

  6771a349b8c3 ("mm/memcg: remove incorrect comment")
  c3970fcb1f21 ("mm: move lruvec stats update functions to vmstat.h")

from the akpm-current tree.

I fixed it up (see below - I used the latter version of memcontrol.h)
and can carry the fix as necessary. This is now fixed as far as
linux-next is concerned, but any non trivial conflicts should be
mentioned to your upstream maintainer when your tree is submitted for
merging.  You may also want to consider cooperating with the maintainer
of the conflicting tree to minimise any particularly complex conflicts.

I also added this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 4 Dec 2020 19:53:40 +1100
Subject: [PATCH] fixup for "mm: move lruvec stats update functions to vmsta=
t.h"

conflict against "mm: memcontrol: Use helpers to read page's memcg data"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/memcontrol.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6f5733779927..3b6db4e906b5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -851,16 +851,17 @@ void __mod_lruvec_page_state(struct page *page, enum =
node_stat_item idx,
 			     int val)
 {
 	struct page *head =3D compound_head(page); /* rmap on tail pages */
+	struct mem_cgroup *memcg =3D page_memcg(head);
 	pg_data_t *pgdat =3D page_pgdat(page);
 	struct lruvec *lruvec;
=20
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!head->mem_cgroup) {
+	if (!memcg) {
 		__mod_node_page_state(pgdat, idx, val);
 		return;
 	}
=20
-	lruvec =3D mem_cgroup_lruvec(head->mem_cgroup, pgdat);
+	lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
 	__mod_lruvec_state(lruvec, idx, val);
 }
=20
--=20
2.29.2

--=20
Cheers,
Stephen Rothwell

diff --cc include/linux/memcontrol.h
index 320369c841f5,ff02f831e7e1..000000000000
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
diff --cc mm/memcontrol.c
index 7535042ac1ec,c9a5dce4343d..000000000000
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@@ -2880,9 -2984,9 +2975,9 @@@ static void cancel_charge(struct mem_cg
 =20
  static void commit_charge(struct page *page, struct mem_cgroup *memcg)
  {
 -	VM_BUG_ON_PAGE(page->mem_cgroup, page);
 +	VM_BUG_ON_PAGE(page_memcg(page), page);
  	/*
- 	 * Any of the following ensures page->mem_cgroup stability:
+ 	 * Any of the following ensures page's memcg stability:
  	 *
  	 * - the page lock
  	 * - LRU isolation
@@@ -6977,11 -7012,10 +6997,10 @@@ void mem_cgroup_migrate(struct page *ol
  		return;
 =20
  	/* Page cache replacement: new page already charged? */
 -	if (newpage->mem_cgroup)
 +	if (page_memcg(newpage))
  		return;
 =20
- 	/* Swapcache readahead pages can get replaced before being charged */
 -	memcg =3D oldpage->mem_cgroup;
 +	memcg =3D page_memcg(oldpage);
  	if (!memcg)
  		return;
 =20

--Sig_/+K=st_HCMWn3JpH6IhaFwtk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/J/0UACgkQAVBC80lX
0GykHAf9ENaQyGwvRrQbXCkHZza/eM9habEfZViXxqugniIt/xpHxIioPAu5LIyi
zBMYr+/rGhg8EOtuDFNGoRmjP9YUU6Q6714o9arCHE1uO7edQVK20jCthVF1MwTR
IfJ3hCAj9h/hj5VS5U5TACTMAoCXYcdbQW/PzCVf65Uz29XVnOwQDR2BkjiGZ/g3
7nao9ycs8AR3C8yFkoyXQ7V4p1c8KKafgbYSGQ/tVPmWQg47pAkL0WZK+9+6sgcK
yhhoW88ZE3bcn3tFmYXsAf2XIGiIesoLfNyIvygPkso8YIXtVBtzfZjLAkG2mQHS
lv9G2Hc03BoO7ey4wydgqJyvl/339g==
=QOWV
-----END PGP SIGNATURE-----

--Sig_/+K=st_HCMWn3JpH6IhaFwtk--

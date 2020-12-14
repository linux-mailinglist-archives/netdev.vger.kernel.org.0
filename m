Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4892D91AE
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 03:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731299AbgLNCPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 21:15:52 -0500
Received: from ozlabs.org ([203.11.71.1]:43523 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgLNCPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 21:15:32 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CvQ2C1vMzz9sTg;
        Mon, 14 Dec 2020 13:14:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607912088;
        bh=F7ozDfBvF5sC6cB5ykdOGoUMbeZLYwoJfidyTcOnZTg=;
        h=Date:From:To:Cc:Subject:From;
        b=sVsePjZ5FtheNLkzNUo93gPuuPtnyjxL3a7pQ+QiFdqYbuxtpm5uVeYMLpwmSblYH
         1WR3TU2BGJW+KhaWe2fFG1rufL+fqTRim1/yNWZEDCGgYwSKworJKzJIhzmyQ91czz
         3cudbQ0j1SgXH7gmPCR3PiBS62HUkDovAax6a37M1RWc15hCjDRdCM3Wwiq6JPXIxz
         e6puEibtlIiU58gMuQOBzNcNEMwEU92WcwCG0fEM9JUV4X1LspO3M36+dQMwVjU4Gz
         /zSLak3vgSJbvbK2ovgUYMXRKFx1DXNq46FzQw0/Z9AZFjMFhSYyyu5FlRsQZEe01a
         n7ZrSR8K/y6IQ==
Date:   Mon, 14 Dec 2020 13:14:38 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Steve French <stfrench@microsoft.com>
Cc:     Samuel Cabrero <scabrero@suse.de>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20201214131438.7c9b2f30@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/tX+H/0dhwPC_iLEBlEhCfZi";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/tX+H/0dhwPC_iLEBlEhCfZi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/cifs/cifs_swn.c: In function 'cifs_swn_notify':
fs/cifs/cifs_swn.c:450:4: error: implicit declaration of function 'nla_strl=
cpy'; did you mean 'nla_strscpy'? [-Werror=3Dimplicit-function-declaration]
  450 |    nla_strlcpy(name, info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME],
      |    ^~~~~~~~~~~
      |    nla_strscpy

Caused by commit

  872f69034194 ("treewide: rename nla_strlcpy to nla_strscpy.")

interacting with commit

  27228d73f4d2 ("cifs: Set witness notification handler for messages from u=
serspace daemon")

from the cifs tree.

I have applied the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 14 Dec 2020 13:09:27 +1100
Subject: [PATCH] fixup for "treewide: rename nla_strlcpy to nla_strscpy."

conflicting with

"cifs: Set witness notification handler for messages from userspace daemon"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/cifs/cifs_swn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index 642c9eedc8ab..d762d442dfa5 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -447,7 +447,7 @@ int cifs_swn_notify(struct sk_buff *skb, struct genl_in=
fo *info)
 		int state;
=20
 		if (info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME]) {
-			nla_strlcpy(name, info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME],
+			nla_strscpy(name, info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME],
 					sizeof(name));
 		} else {
 			cifs_dbg(FYI, "%s: missing resource name attribute\n", __func__);
--=20
2.29.2

--=20
Cheers,
Stephen Rothwell

--Sig_/tX+H/0dhwPC_iLEBlEhCfZi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/Wyo4ACgkQAVBC80lX
0GzBywf8D8XRKEEUmkHnvrq/xW6WBfsU2Pdk3b0zDC4onI/gJHyfCkO6XyHV9I4o
KXG+CRBjG/IIZYOeA9aGx8Q4EhiZnZwM/5IccjOOvzFZAagdejMHRYXEHX3Ozray
znW1RTQ7ysO/UBVistZZ+cWyvUGHoJzgUjmpm7axh75zAUEC4jtN35TNjVKMuiN3
2pobSeGN8DCJMVnXApaLGf+XJJnXpDUOiYlKzjsafR7QHdeR40Wij5MfU73/KF5q
VYqctZLfpuQMoYm+pcN6j4jwE/+Tx+jVEdgKRiB3LhoQRMHeANY11nV6/k5PiZHU
nwBG2oFvPwWf1gU904LeBwMro0cSJQ==
=UsjC
-----END PGP SIGNATURE-----

--Sig_/tX+H/0dhwPC_iLEBlEhCfZi--

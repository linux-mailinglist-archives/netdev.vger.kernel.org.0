Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2917B2C98D2
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 09:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgLAIIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 03:08:32 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:39811 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbgLAIIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 03:08:32 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4ClZTd1gxvz9s1l;
        Tue,  1 Dec 2020 19:07:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1606810069;
        bh=OidLWJFFOmo7ZgrNn5TNWAZxfnkfVBDpo8lzfpGX9NM=;
        h=Date:From:To:Cc:Subject:From;
        b=fVs26v09ueuSabThLyTPrqNxhQbEdiNKM3KtB8y/pOlYyb/OIY5Ob0ZE79ojhKKdg
         rSupt68xPltqPTNZrHfpiDf3V240VDG5mJzQddJTTHm4NxfCO6C6TzQsY5oElzhIrj
         Xw9zydZtaSollBd51lWh0Nze3QiXbA0pmc/Z2VJduX/1dLehyMlWgPFW1+avxCg9cZ
         TBU2O1VMUK4Hc6j8QiM0KwfKCgxzJLhIvPYj2vXcUSUXIONBXQlSMb1Qa4vV+VF8SE
         RtvOJRhK0/6Bd7VWSv+HZimapKaruxec4tgASnyUxzWREaq4bD1CgEf3RHNP8paJIN
         bJrky0bXJVDxg==
Date:   Tue, 1 Dec 2020 19:07:46 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20201201190746.7d3357fb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2V=SWCXRVJSnD8j_MDHjg4e";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/2V=SWCXRVJSnD8j_MDHjg4e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (x86_64
allnoconfig) failed like this:

In file included from fs/select.c:32:
include/net/busy_poll.h: In function 'sk_mark_napi_id_once':
include/net/busy_poll.h:150:36: error: 'const struct sk_buff' has no member=
 named 'napi_id'
  150 |  __sk_mark_napi_id_once_xdp(sk, skb->napi_id);
      |                                    ^~

Caused by commit

  b02e5a0ebb17 ("xsk: Propagate napi_id to XDP socket Rx path")

sk_buff only has a napi_id if defined(CONFIG_NET_RX_BUSY_POLL) ||
defined(CONFIG_XPS).

I have applied the following patch for today.

=46rom bd2a1a4a773c1f306460b4309b12cad245a5edad Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 1 Dec 2020 19:02:58 +1100
Subject: [PATCH] fix for "xsk: Propagate napi_id to XDP socket Rx path"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/net/busy_poll.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 45b3e04b99d3..07a88f592e72 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -147,7 +147,9 @@ static inline void __sk_mark_napi_id_once_xdp(struct so=
ck *sk, unsigned int napi
 static inline void sk_mark_napi_id_once(struct sock *sk,
 					const struct sk_buff *skb)
 {
+#ifdef CONFIG_NET_RX_BUSY_POLL
 	__sk_mark_napi_id_once_xdp(sk, skb->napi_id);
+#endif
 }
=20
 static inline void sk_mark_napi_id_once_xdp(struct sock *sk,
--=20
2.29.2

--=20
Cheers,
Stephen Rothwell

--Sig_/2V=SWCXRVJSnD8j_MDHjg4e
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/F+dIACgkQAVBC80lX
0Gz+wwf9FU3qShc6Cm3SZ8N4z0kYV2+D2yPgetgKxKZPGaKnLpgJmxXAD7LwfCx7
vYc0k3CQLlPOwxmsUF0F4czsuIMLBda+fwubR5Lq7Nu9aqjuaPib6zgTMx7EwwbP
itzlo/qNGKEFRVcRQeNsDzRYix+mGA/GkAFdNQ44k4ANsqcgc2IdKCQpvq4kWijZ
vMzY9iXV7RmrtzFkQCHK/Ohyt3M7GwwBr9ru7J5vF1F4m1ve1IpbkE7KZrV9tsy/
B0Yt2ThaUP80Y0MrS1Ign2lfabZgnr/RbVI0DbVm4tzoWWQEruNpg9jdjHxc0g7u
g6DqtMpVYyzbW/5aXecWDiOWMBvrFg==
=m2mW
-----END PGP SIGNATURE-----

--Sig_/2V=SWCXRVJSnD8j_MDHjg4e--

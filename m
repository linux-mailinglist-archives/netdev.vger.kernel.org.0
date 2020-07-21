Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0197A22756D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGUCMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgGUCMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:12:05 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C580C061794;
        Mon, 20 Jul 2020 19:12:05 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B9htT5dGWz9sRN;
        Tue, 21 Jul 2020 12:12:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595297522;
        bh=UTMv+LohAVeywtSQA4FJ44hILUvS4URELTHwDgunZt8=;
        h=Date:From:To:Cc:Subject:From;
        b=c22E8E5HIC4DH3WJUNji8RqUUvIiGX9ksWu8ovjnSMB4VhCsU2/r45p0JL8kim0RJ
         slR+IIZuiuAlnT4DNRsx4thuOcy7L3V93ixcO2/BK1k251gE7S4fzRQPq75pMd35MV
         SUZIbcy+5A3RHdOCostUc5p6VWXMGkBKMAxL4sk0h1Q1ftgTtOoTPymTW3enzg3Afn
         dGXK0dIwa/Q5b2UMcyumF9oB4x0sYUNnrbHZYIrb39oXdcaHcf+uyDZGTaHEH1ttn0
         x+GU/MtH+ozULaa7gSvtru+GNRia2OKzIbfmK0SI7TNIdJdbWO2z/vYFyLEWgvatJd
         n7LQ2jW/TQsig==
Date:   Tue, 21 Jul 2020 12:12:00 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20200721121200.60ce87fb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/NmcyHySB4QEYmS7SkHXyhmQ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/NmcyHySB4QEYmS7SkHXyhmQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  include/linux/filter.h

between commit:

  4d295e546115 ("net: simplify cBPF setsockopt compat handling")

from the net-next tree and commits:

  e9ddbb7707ff ("bpf: Introduce SK_LOOKUP program type with a dedicated att=
ach point")
  1559b4aa1db4 ("inet: Run SK_LOOKUP BPF program on socket lookup")
  1122702f0267 ("inet6: Run SK_LOOKUP BPF program on socket lookup")

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

diff --cc include/linux/filter.h
index 4d049c8e1fbe,8252572db918..000000000000
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@@ -1276,6 -1278,151 +1276,153 @@@ struct bpf_sockopt_kern=20
  	s32		retval;
  };
 =20
+ struct bpf_sk_lookup_kern {
+ 	u16		family;
+ 	u16		protocol;
+ 	struct {
+ 		__be32 saddr;
+ 		__be32 daddr;
+ 	} v4;
+ 	struct {
+ 		const struct in6_addr *saddr;
+ 		const struct in6_addr *daddr;
+ 	} v6;
+ 	__be16		sport;
+ 	u16		dport;
+ 	struct sock	*selected_sk;
+ 	bool		no_reuseport;
+ };
+=20
+ extern struct static_key_false bpf_sk_lookup_enabled;
+=20
+ /* Runners for BPF_SK_LOOKUP programs to invoke on socket lookup.
+  *
+  * Allowed return values for a BPF SK_LOOKUP program are SK_PASS and
+  * SK_DROP. Their meaning is as follows:
+  *
+  *  SK_PASS && ctx.selected_sk !=3D NULL: use selected_sk as lookup result
+  *  SK_PASS && ctx.selected_sk =3D=3D NULL: continue to htable-based sock=
et lookup
+  *  SK_DROP                           : terminate lookup with -ECONNREFUS=
ED
+  *
+  * This macro aggregates return values and selected sockets from
+  * multiple BPF programs according to following rules in order:
+  *
+  *  1. If any program returned SK_PASS and a non-NULL ctx.selected_sk,
+  *     macro result is SK_PASS and last ctx.selected_sk is used.
+  *  2. If any program returned SK_DROP return value,
+  *     macro result is SK_DROP.
+  *  3. Otherwise result is SK_PASS and ctx.selected_sk is NULL.
+  *
+  * Caller must ensure that the prog array is non-NULL, and that the
+  * array as well as the programs it contains remain valid.
+  */
+ #define BPF_PROG_SK_LOOKUP_RUN_ARRAY(array, ctx, func)			\
+ 	({								\
+ 		struct bpf_sk_lookup_kern *_ctx =3D &(ctx);		\
+ 		struct bpf_prog_array_item *_item;			\
+ 		struct sock *_selected_sk =3D NULL;			\
+ 		bool _no_reuseport =3D false;				\
+ 		struct bpf_prog *_prog;					\
+ 		bool _all_pass =3D true;					\
+ 		u32 _ret;						\
+ 									\
+ 		migrate_disable();					\
+ 		_item =3D &(array)->items[0];				\
+ 		while ((_prog =3D READ_ONCE(_item->prog))) {		\
+ 			/* restore most recent selection */		\
+ 			_ctx->selected_sk =3D _selected_sk;		\
+ 			_ctx->no_reuseport =3D _no_reuseport;		\
+ 									\
+ 			_ret =3D func(_prog, _ctx);			\
+ 			if (_ret =3D=3D SK_PASS && _ctx->selected_sk) {	\
+ 				/* remember last non-NULL socket */	\
+ 				_selected_sk =3D _ctx->selected_sk;	\
+ 				_no_reuseport =3D _ctx->no_reuseport;	\
+ 			} else if (_ret =3D=3D SK_DROP && _all_pass) {	\
+ 				_all_pass =3D false;			\
+ 			}						\
+ 			_item++;					\
+ 		}							\
+ 		_ctx->selected_sk =3D _selected_sk;			\
+ 		_ctx->no_reuseport =3D _no_reuseport;			\
+ 		migrate_enable();					\
+ 		_all_pass || _selected_sk ? SK_PASS : SK_DROP;		\
+ 	 })
+=20
+ static inline bool bpf_sk_lookup_run_v4(struct net *net, int protocol,
+ 					const __be32 saddr, const __be16 sport,
+ 					const __be32 daddr, const u16 dport,
+ 					struct sock **psk)
+ {
+ 	struct bpf_prog_array *run_array;
+ 	struct sock *selected_sk =3D NULL;
+ 	bool no_reuseport =3D false;
+=20
+ 	rcu_read_lock();
+ 	run_array =3D rcu_dereference(net->bpf.run_array[NETNS_BPF_SK_LOOKUP]);
+ 	if (run_array) {
+ 		struct bpf_sk_lookup_kern ctx =3D {
+ 			.family		=3D AF_INET,
+ 			.protocol	=3D protocol,
+ 			.v4.saddr	=3D saddr,
+ 			.v4.daddr	=3D daddr,
+ 			.sport		=3D sport,
+ 			.dport		=3D dport,
+ 		};
+ 		u32 act;
+=20
+ 		act =3D BPF_PROG_SK_LOOKUP_RUN_ARRAY(run_array, ctx, BPF_PROG_RUN);
+ 		if (act =3D=3D SK_PASS) {
+ 			selected_sk =3D ctx.selected_sk;
+ 			no_reuseport =3D ctx.no_reuseport;
+ 		} else {
+ 			selected_sk =3D ERR_PTR(-ECONNREFUSED);
+ 		}
+ 	}
+ 	rcu_read_unlock();
+ 	*psk =3D selected_sk;
+ 	return no_reuseport;
+ }
+=20
+ #if IS_ENABLED(CONFIG_IPV6)
+ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
+ 					const struct in6_addr *saddr,
+ 					const __be16 sport,
+ 					const struct in6_addr *daddr,
+ 					const u16 dport,
+ 					struct sock **psk)
+ {
+ 	struct bpf_prog_array *run_array;
+ 	struct sock *selected_sk =3D NULL;
+ 	bool no_reuseport =3D false;
+=20
+ 	rcu_read_lock();
+ 	run_array =3D rcu_dereference(net->bpf.run_array[NETNS_BPF_SK_LOOKUP]);
+ 	if (run_array) {
+ 		struct bpf_sk_lookup_kern ctx =3D {
+ 			.family		=3D AF_INET6,
+ 			.protocol	=3D protocol,
+ 			.v6.saddr	=3D saddr,
+ 			.v6.daddr	=3D daddr,
+ 			.sport		=3D sport,
+ 			.dport		=3D dport,
+ 		};
+ 		u32 act;
+=20
+ 		act =3D BPF_PROG_SK_LOOKUP_RUN_ARRAY(run_array, ctx, BPF_PROG_RUN);
+ 		if (act =3D=3D SK_PASS) {
+ 			selected_sk =3D ctx.selected_sk;
+ 			no_reuseport =3D ctx.no_reuseport;
+ 		} else {
+ 			selected_sk =3D ERR_PTR(-ECONNREFUSED);
+ 		}
+ 	}
+ 	rcu_read_unlock();
+ 	*psk =3D selected_sk;
+ 	return no_reuseport;
+ }
+ #endif /* IS_ENABLED(CONFIG_IPV6) */
+=20
 +int copy_bpf_fprog_from_user(struct sock_fprog *dst, void __user *src, in=
t len);
 +
  #endif /* __LINUX_FILTER_H__ */

--Sig_/NmcyHySB4QEYmS7SkHXyhmQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8WTvAACgkQAVBC80lX
0GxLMQf+OyuUUt2hCYprT08GHMUBVcfrGxq5KOJW20Y7QB2Ap9E/OT0Se0sfh+RJ
L8vdkBbrnLNWkBnhT+n1ONOSYY7tsxdE2VYGGg1Eh1LQ+gayvdqOJ8n6OczeDLgY
opdUtxhq0UZM8hltxtOGFP3ymXaAmEfdv2VEvLBLK8gbrsB7i7ZDifgPJISCNk/1
hzu/9N0KWkadJxTdUuQBmsN2evi8I75j/YzLyymqXVQqHCVfA7XePoLih+WNeV0O
0AxltZGJKv5H6gafEVPXJ3fMQ9i6ZUl3VfyvqrLMWddyhnxePzqv3UF3GH+Nx7u3
9rI0ARYd6/6twZcVAfl/NO5FPVA1Xw==
=QTH6
-----END PGP SIGNATURE-----

--Sig_/NmcyHySB4QEYmS7SkHXyhmQ--

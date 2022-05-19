Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0784752C970
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 03:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbiESBvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 21:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiESBvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 21:51:51 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3A021257;
        Wed, 18 May 2022 18:51:49 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L3XsH4DVhz4xY2;
        Thu, 19 May 2022 11:51:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1652925108;
        bh=D07LJEmp8GTuMAs4nLawTfL98Oq5BP1Xqtz3iZsm+iA=;
        h=Date:From:To:Cc:Subject:From;
        b=IvZoR4pNXDjGzFFDy8zWh2QhYqV21hSX6UsaVEj2eH30yTgZtbyFs8Z7/Vx3GprCP
         XAjHrCOhAJdOR3M4IbRP2UPKZY+vZWLtqbbnPFHHZMpgv06LgoBlAw3uDUZnZc8Fkk
         lES0CAb7WVtXH4zGicGyVOkE+pYsVxToqxJrCXIpHSQrPSmFZSiD1e7QWiCXIxhMLJ
         4WOY/wjRtUsjXJzAiuwajyXo1k/HNFCqQDoVIqFQYMJH4xcZ/2yRIp7PXIyw0TVx1y
         lmu2QulDGNRmIb1wlpNi24V0zkt82DXYh6lbn7St3CSpPe3gmTEyJrljKKubOUBppr
         Y7CztuL64G6AQ==
Date:   Thu, 19 May 2022 11:51:46 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220519115146.751c3a37@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WiHatR1G1_fNr4E3eBjRM9V";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/WiHatR1G1_fNr4E3eBjRM9V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  net/mptcp/options.c

between commit:

  ba2c89e0ea74 ("mptcp: fix checksum byte order")

from the net tree and commits:

  1e39e5a32ad7 ("mptcp: infinite mapping sending")
  ea66758c1795 ("tcp: allow MPTCP to update the announced window")

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

diff --cc net/mptcp/options.c
index b548cec86c9d,ac3b7b8a02f6..000000000000
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@@ -1234,13 -1236,53 +1236,53 @@@ static void mptcp_set_rwin(struct tcp_s
  	subflow =3D mptcp_subflow_ctx(ssk);
  	msk =3D mptcp_sk(subflow->conn);
 =20
- 	ack_seq =3D READ_ONCE(msk->ack_seq) + tp->rcv_wnd;
+ 	ack_seq =3D READ_ONCE(msk->ack_seq);
+ 	rcv_wnd_new =3D ack_seq + tp->rcv_wnd;
+=20
+ 	rcv_wnd_old =3D atomic64_read(&msk->rcv_wnd_sent);
+ 	if (after64(rcv_wnd_new, rcv_wnd_old)) {
+ 		u64 rcv_wnd;
+=20
+ 		for (;;) {
+ 			rcv_wnd =3D atomic64_cmpxchg(&msk->rcv_wnd_sent, rcv_wnd_old, rcv_wnd_=
new);
+=20
+ 			if (rcv_wnd =3D=3D rcv_wnd_old)
+ 				break;
+ 			if (before64(rcv_wnd_new, rcv_wnd)) {
+ 				MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_RCVWNDCONFLICTUPDATE);
+ 				goto raise_win;
+ 			}
+ 			MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_RCVWNDCONFLICT);
+ 			rcv_wnd_old =3D rcv_wnd;
+ 		}
+ 		return;
+ 	}
+=20
+ 	if (rcv_wnd_new !=3D rcv_wnd_old) {
+ raise_win:
+ 		win =3D rcv_wnd_old - ack_seq;
+ 		tp->rcv_wnd =3D min_t(u64, win, U32_MAX);
+ 		new_win =3D tp->rcv_wnd;
 =20
- 	if (after64(ack_seq, READ_ONCE(msk->rcv_wnd_sent)))
- 		WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
+ 		/* Make sure we do not exceed the maximum possible
+ 		 * scaled window.
+ 		 */
+ 		if (unlikely(th->syn))
+ 			new_win =3D min(new_win, 65535U) << tp->rx_opt.rcv_wscale;
+ 		if (!tp->rx_opt.rcv_wscale &&
+ 		    sock_net(ssk)->ipv4.sysctl_tcp_workaround_signed_windows)
+ 			new_win =3D min(new_win, MAX_TCP_WINDOW);
+ 		else
+ 			new_win =3D min(new_win, (65535U << tp->rx_opt.rcv_wscale));
+=20
+ 		/* RFC1323 scaling applied */
+ 		new_win >>=3D tp->rx_opt.rcv_wscale;
+ 		th->window =3D htons(new_win);
+ 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_RCVWNDSHARED);
+ 	}
  }
 =20
 -u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum=
 sum)
 +__sum16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __=
wsum sum)
  {
  	struct csum_pseudo_header header;
  	__wsum csum;
@@@ -1265,17 -1307,7 +1307,17 @@@ static __sum16 mptcp_make_csum(const st
  				 ~csum_unfold(mpext->csum));
  }
 =20
 +static void put_len_csum(u16 len, __sum16 csum, void *data)
 +{
 +	__sum16 *sumptr =3D data + 2;
 +	__be16 *ptr =3D data;
 +
 +	put_unaligned_be16(len, ptr);
 +
 +	put_unaligned(csum, sumptr);
 +}
 +
- void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
+ void mptcp_write_options(struct tcphdr *th, __be32 *ptr, struct tcp_sock =
*tp,
  			 struct mptcp_out_options *opts)
  {
  	const struct sock *ssk =3D (const struct sock *)tp;
@@@ -1350,9 -1382,12 +1392,12 @@@
  			put_unaligned_be32(mpext->subflow_seq, ptr);
  			ptr +=3D 1;
  			if (opts->csum_reqd) {
+ 				/* data_len =3D=3D 0 is reserved for the infinite mapping,
+ 				 * the checksum will also be set to 0.
+ 				 */
 -				put_unaligned_be32(mpext->data_len << 16 |
 -						   (mpext->data_len ? mptcp_make_csum(mpext) : 0),
 -						   ptr);
 +				put_len_csum(mpext->data_len,
- 					     mptcp_make_csum(mpext),
++					     (mpext->data_len ? mptcp_make_csum(mpext) : 0),
 +					     ptr);
  			} else {
  				put_unaligned_be32(mpext->data_len << 16 |
  						   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);

--Sig_/WiHatR1G1_fNr4E3eBjRM9V
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKForIACgkQAVBC80lX
0Gx7eAf8DzrN9ps49uCra8kaEq7DMunsQ/fM2XuSi9e27adkOkTVQOZ41LgF/Z2f
2Ux55eIY/gPuhUjtmVk55cGxhHPOjjL40uIyxMK8VkFE1/ry2Pvto4NcNHif5mw5
WLW3VXtDubOfg2LddmSsAeFsoyI4EAaixgEwzUWQF6Lz6A5+f4nWgWLm2mIRAwil
xXCntOJGsY8nFGWZVOruf8CaEowhTNEx/RVpybhdtk31oPmLC3Yk070AjE2HeQ0S
1ShJYrt9uiaKU+lM8dYbW8Jeu45m5XL4V1uR6s+3JYu9RpCk2ylbZU7WshaQhzXp
z6zM/XiRG7F8rXiGt47r9Ip+vqreSg==
=/xcF
-----END PGP SIGNATURE-----

--Sig_/WiHatR1G1_fNr4E3eBjRM9V--

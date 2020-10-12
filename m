Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B207A28AC43
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 04:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgJLCpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 22:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgJLCpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 22:45:21 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B0FC0613CE;
        Sun, 11 Oct 2020 19:45:20 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C8jhX2zbJz9sS8;
        Mon, 12 Oct 2020 13:45:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1602470716;
        bh=mjGtmYaiKrM7DLhsF4b+HYazmeMtTIacQOJRXpDBvpI=;
        h=Date:From:To:Cc:Subject:From;
        b=bVRi1MSXDXH5opTzDVEHsoktz0RWKHHd/VxvQ/rHIJbkFBEHTxG5tpFWCQQdj5ss2
         1k0r4pD6WOK+Sqpxabu3oD6Fh7GJ7qAGa43enl4k9v/e+UnU/uBjFiq5MeM9s4EV2T
         l3suINV5zQVhkN6FpXCHE2FlOqDtY5Qq7UyFWJQgHfGgPpEflcgE1C0QAEYDUbetNw
         nT3w3XCbxMdhN93aJ8iOJvU9KRZb0/iaACG2nbvXxi+DLoWOHhgBOES7BDNMXyN7NS
         cD+qT66s8j4RkksrJLvZkvfp/dbE9eDSr3tqT249blaA8MbgWVgdoLY1pBGjuUP2c6
         GkXcYXKg7vUnw==
Date:   Mon, 12 Oct 2020 13:45:10 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20201012134510.51c0bd0a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/1.iFEXTbGlrHy2jUC.WPk+G";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/1.iFEXTbGlrHy2jUC.WPk+G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/mptcp/protocol.h

between commit:

  d582484726c4 ("mptcp: fix fallback for MP_JOIN subflows")

from the net tree and commit:

  d0876b2284cf ("mptcp: add the incoming RM_ADDR support")

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

diff --cc net/mptcp/protocol.h
index 972463642690,aa0ab18d2e57..000000000000
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@@ -203,9 -211,10 +212,11 @@@ struct mptcp_sock=20
  	bool		fully_established;
  	bool		rcv_data_fin;
  	bool		snd_data_fin_enable;
 +	bool		use_64bit_ack; /* Set when we received a 64-bit DSN */
  	spinlock_t	join_list_lock;
  	struct work_struct work;
+ 	struct sk_buff  *ooo_last_skb;
+ 	struct rb_root  out_of_order_queue;
  	struct list_head conn_list;
  	struct list_head rtx_queue;
  	struct list_head join_list;
@@@ -294,9 -309,10 +311,9 @@@ struct mptcp_subflow_context=20
  		map_valid : 1,
  		mpc_map : 1,
  		backup : 1,
- 		data_avail : 1,
  		rx_eof : 1,
 -		use_64bit_ack : 1, /* Set when we received a 64-bit DSN */
  		can_ack : 1;	    /* only after processing the remote a key */
+ 	enum mptcp_data_avail data_avail;
  	u32	remote_nonce;
  	u64	thmac;
  	u32	local_nonce;
@@@ -349,11 -365,13 +366,14 @@@ void mptcp_subflow_fully_established(st
  				     struct mptcp_options_received *mp_opt);
  bool mptcp_subflow_data_available(struct sock *sk);
  void __init mptcp_subflow_init(void);
 +void mptcp_subflow_reset(struct sock *ssk);
+ void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how);
+ void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
+ 		       struct mptcp_subflow_context *subflow,
+ 		       long timeout);
 =20
  /* called with sk socket lock held */
- int __mptcp_subflow_connect(struct sock *sk, int ifindex,
- 			    const struct mptcp_addr_info *loc,
+ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info=
 *loc,
  			    const struct mptcp_addr_info *remote);
  int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock=
);
 =20

--Sig_/1.iFEXTbGlrHy2jUC.WPk+G
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+DwzYACgkQAVBC80lX
0Gyjqwf+IGWQv9QTFfZKE05vuR5QVtzxP81b1PiK4YBeiKNQPrpKHBp8MH1Hm1eo
eNhTEEyYv2XClkTSw3R/QAxawOpa4OZMupjXNGhjryt+q5fFZaJPX7M/GgJiFiW/
rtH8amipgxuZ/rqY8IhNrzmbV6YgcyfnTrYL557MfpnbCVuzWXSmgYE0rWv713RP
qXoWjX3LCCNpQ1uADLxIIBnj5dXQN06l9gWm1HYux0JjdDbXj9z6p+jWY4SrExtM
6A981XJK5A0e7f8OMticnK+h6RMuSK8CCJELC8ZFF3G124h8xdWwEkVK1EmYqVMw
uBftf3ZEqxHKYWr8jB5jfS1wA7DDkA==
=pU71
-----END PGP SIGNATURE-----

--Sig_/1.iFEXTbGlrHy2jUC.WPk+G--

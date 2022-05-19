Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A1E52C980
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 03:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbiESB6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 21:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiESB6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 21:58:41 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD62D413A;
        Wed, 18 May 2022 18:58:40 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L3Y1B2zjtz4xXk;
        Thu, 19 May 2022 11:58:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1652925518;
        bh=Xw76F4P8i2rMVvKg6i2Qurks8SCLOUckM1T1wqdLhDg=;
        h=Date:From:To:Cc:Subject:From;
        b=J+5Vlu5KfkB5IKUYXcsTgOrHFiYSvY4IGIrT6MEcfs++zHGYkFNb74tyevuQNsu6v
         W3v/jbl3bMixwal7FtokLT9azhuOQKPPm5CRdzZjhzubMXZG0Qyn4MlamPAYxQwe+e
         3aIgpjT0Nr8V0y8ypl2Yxx3XeSCkOXbxOP9pV+EUHB88p2xOvZImzW7K7S0nvli28d
         WumdzkxPdvkN0y1qGavt6R9TFDV4lFTzK+6QZaA+skDJXfPFIc3/WIW3IhsbHqaAyT
         KZkhSgdbYqFUUdPxJRIPlmIoO6pYEANHa0ihyu9t7LYtp95hm5YLqvX4d2/8IkFZKT
         1MYN9ih6fkfyg==
Date:   Thu, 19 May 2022 11:58:37 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220519115837.380bb8d4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/3Cou6DXn76CFBv1L8HsG9aa";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/3Cou6DXn76CFBv1L8HsG9aa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/mptcp/subflow.c

between commit:

  ae66fb2ba6c3 ("mptcp: Do TCP fallback on early DSS checksum failure")

from the net tree and commits:

  0348c690ed37 ("mptcp: add the fallback check")
  f8d4bcacff3b ("mptcp: infinite mapping receiving")

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

diff --cc net/mptcp/subflow.c
index be76ada89d96,6d59336a8e1e..000000000000
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@@ -1218,35 -1215,45 +1230,45 @@@ no_data
  	return false;
 =20
  fallback:
- 	/* RFC 8684 section 3.7. */
- 	if (subflow->send_mp_fail) {
- 		if (mptcp_has_another_subflow(ssk)) {
- 			while ((skb =3D skb_peek(&ssk->sk_receive_queue)))
- 				sk_eat_skb(ssk, skb);
+ 	if (!__mptcp_check_fallback(msk)) {
+ 		/* RFC 8684 section 3.7. */
+ 		if (subflow->send_mp_fail) {
+ 			if (mptcp_has_another_subflow(ssk) ||
+ 			    !READ_ONCE(msk->allow_infinite_fallback)) {
+ 				ssk->sk_err =3D EBADMSG;
+ 				tcp_set_state(ssk, TCP_CLOSE);
+ 				subflow->reset_transient =3D 0;
+ 				subflow->reset_reason =3D MPTCP_RST_EMIDDLEBOX;
+ 				tcp_send_active_reset(ssk, GFP_ATOMIC);
+ 				while ((skb =3D skb_peek(&ssk->sk_receive_queue)))
+ 					sk_eat_skb(ssk, skb);
+ 			} else {
+ 				WRITE_ONCE(subflow->mp_fail_response_expect, true);
+ 				/* The data lock is acquired in __mptcp_move_skbs() */
+ 				sk_reset_timer((struct sock *)msk,
+ 					       &((struct sock *)msk)->sk_timer,
+ 					       jiffies + TCP_RTO_MAX);
+ 			}
+ 			WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
+ 			return true;
  		}
- 		ssk->sk_err =3D EBADMSG;
- 		tcp_set_state(ssk, TCP_CLOSE);
- 		subflow->reset_transient =3D 0;
- 		subflow->reset_reason =3D MPTCP_RST_EMIDDLEBOX;
- 		tcp_send_active_reset(ssk, GFP_ATOMIC);
- 		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
- 		return true;
- 	}
 =20
- 	if (!subflow_can_fallback(subflow)) {
- 		/* fatal protocol error, close the socket.
- 		 * subflow_error_report() will introduce the appropriate barriers
- 		 */
- 		ssk->sk_err =3D EBADMSG;
- 		tcp_set_state(ssk, TCP_CLOSE);
- 		subflow->reset_transient =3D 0;
- 		subflow->reset_reason =3D MPTCP_RST_EMPTCP;
- 		tcp_send_active_reset(ssk, GFP_ATOMIC);
- 		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
- 		return false;
 -		if ((subflow->mp_join || subflow->fully_established) && subflow->map_da=
ta_len) {
++		if (!subflow_can_fallback(subflow) && subflow->map_data_len) {
+ 			/* fatal protocol error, close the socket.
+ 			 * subflow_error_report() will introduce the appropriate barriers
+ 			 */
+ 			ssk->sk_err =3D EBADMSG;
+ 			tcp_set_state(ssk, TCP_CLOSE);
+ 			subflow->reset_transient =3D 0;
+ 			subflow->reset_reason =3D MPTCP_RST_EMPTCP;
+ 			tcp_send_active_reset(ssk, GFP_ATOMIC);
+ 			WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
+ 			return false;
+ 		}
+=20
+ 		__mptcp_do_fallback(msk);
  	}
 =20
- 	__mptcp_do_fallback(msk);
  	skb =3D skb_peek(&ssk->sk_receive_queue);
  	subflow->map_valid =3D 1;
  	subflow->map_seq =3D READ_ONCE(msk->ack_seq);

--Sig_/3Cou6DXn76CFBv1L8HsG9aa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKFpE0ACgkQAVBC80lX
0Gw1XQf+L3Oj0Wu7tN3OrMyWOXQt+Dhkm6nhxOmN6iRa2H+cfnlhFwGO3ovugDDx
0pqTvjWv4n0GTaKaJwlzHJV3zseDGlp6O5uc07j1W8R/NwACAsdAP8v+Ps6EbByX
9FPYCv6WzUNLfjRT+RIbZv94Ls5cqlMfgNgAHDGBLizZHQjAWahg8Yhhvs9RTIep
uLJBJ7qw3q0y38zwKoVFq8AnO+UOsyPI3pv9j2tUpToz79JgUdH/sMUp2dGxyzLy
vAOedHip23jbww8+uaoYtcRmWFO3CqePfCWZ9T0Awhld4t6vCdhcbLK5HNSlPiEI
uyV5hJ2FXAygrJ+G9hFiq34h6aOUzQ==
=igHh
-----END PGP SIGNATURE-----

--Sig_/3Cou6DXn76CFBv1L8HsG9aa--

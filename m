Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70806285693
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 04:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgJGCIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 22:08:20 -0400
Received: from ozlabs.org ([203.11.71.1]:34679 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgJGCIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 22:08:20 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C5d694KBLz9sSG;
        Wed,  7 Oct 2020 13:08:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1602036497;
        bh=JYAiyTM40zSDyus2/9je1I8wA9ZePbLcDmG6dt6zgZM=;
        h=Date:From:To:Cc:Subject:From;
        b=MQlXzIWxh/0l9yS3Y0Dps2P9aaFA3lb9ZG5eD4icw1vzS1k+9L8t1IfpdvzI5O89R
         a20IqV3Ebw6mUmuFmgg+kKJzct2IwjB232xXswIp+r+gv/qAewlKvi+tUAmUemeTex
         9nmx4moCsk0zDIk7lSdjk4LS7sV2ZRbgXHdTt0YBMKP8kwZd10FlCOp80IPho1RMZl
         Vvi3SuGov4rFDKlGJk/R6LuXlSSq9sNLtsjPQNPsLLz6EcYfjLAf8zAw+N+wXZwdWk
         /v99AFqB4Fgtmclf6w3cvG3ZZGSgpXjeanIHDna9uem4WZix5jK0PtwdXKEd/ftnXd
         dOfalmLXTR7Ug==
Date:   Wed, 7 Oct 2020 13:08:13 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20201007130813.2f00ceba@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9/UCw1UskAGq1UFgDWqi.=5";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/9/UCw1UskAGq1UFgDWqi.=5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/rxrpc/conn_event.c

between commit:

  fa1d113a0f96 ("rxrpc: Fix some missing _bh annotations on locking conn->s=
tate_lock")

from the net tree and commit:

  245500d853e9 ("rxrpc: Rewrite the client connection manager")

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

diff --cc net/rxrpc/conn_event.c
index 64ace2960ecc,0628dad2bdea..000000000000
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@@ -339,8 -341,8 +341,8 @@@ static int rxrpc_process_event(struct r
  		if (ret < 0)
  			return ret;
 =20
- 		spin_lock(&conn->channel_lock);
+ 		spin_lock(&conn->bundle->channel_lock);
 -		spin_lock(&conn->state_lock);
 +		spin_lock_bh(&conn->state_lock);
 =20
  		if (conn->state =3D=3D RXRPC_CONN_SERVICE_CHALLENGING) {
  			conn->state =3D RXRPC_CONN_SERVICE;
@@@ -349,12 -351,12 +351,12 @@@
  				rxrpc_call_is_secure(
  					rcu_dereference_protected(
  						conn->channels[loop].call,
- 						lockdep_is_held(&conn->channel_lock)));
+ 						lockdep_is_held(&conn->bundle->channel_lock)));
  		} else {
 -			spin_unlock(&conn->state_lock);
 +			spin_unlock_bh(&conn->state_lock);
  		}
 =20
- 		spin_unlock(&conn->channel_lock);
+ 		spin_unlock(&conn->bundle->channel_lock);
  		return 0;
 =20
  	default:

--Sig_/9/UCw1UskAGq1UFgDWqi.=5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl99Iw0ACgkQAVBC80lX
0GySKAf+OrlyC+PiBSf0QBPmc1ryZgoGmTfP+mmhZP98simciFZHZimmbtx2PRp6
R0NMSN7Jc81+8yf8G4tjZV401Cy7r3jMN8kDc3o9HLud//RYkK3DhObdLAmOccjh
Y3KCEqOd6FWy4hPJyqKfS1tiqxIY/AmMFXQRt9+YieFc8O4WsiPCo7usR+MjyEQV
V1ktMPgO9n5sveHSzrJluLagXYzJOnGlyLaY7e/nv3rcQi7vo6nznwmSWafLZMnk
JAnFNbRMpJODCXxDr/CSk/f0OGxtZq72+uQc7P60JiTc2BQKlsQD6bJVaau8z++O
fqt4tgpcT6sWUtuP8SJDf/t0Meg7fA==
=/ooz
-----END PGP SIGNATURE-----

--Sig_/9/UCw1UskAGq1UFgDWqi.=5--

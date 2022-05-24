Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D4E532054
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 03:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbiEXBoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 21:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiEXBoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 21:44:21 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA747092B;
        Mon, 23 May 2022 18:44:20 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L6cSB4Vjxz4xYY;
        Tue, 24 May 2022 11:44:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1653356655;
        bh=nOHRLgVCMvcJflPH5QlQEy42qO/vMFVCr0/3VzWgpQg=;
        h=Date:From:To:Cc:Subject:From;
        b=bUHvLJATj/H+PYuPKJDhh5JXS4HEpE5NDmFx3ctQpYU68xoKOVIYXDkZ3GlqIFIR7
         4DACAW3di9bjGzxvERUYiTPN5tZPv9JHNXLTjWe/WhAUGAsPQ4fnjTcRq+0TlKK2nK
         pOimqO/GTGXqaxWaonT8DAedRDmp22JBPQoDkqM/Tv+139m7vXU9RUJTpogtNylZVC
         H2b6MuesMZO3iPbDYxio2FuakAXgnHiIydMuvdP1uySFtgWt53Yl8fvgiChUeUeq5k
         5dXvNEs0gkcDXnN4cD5HiMIes+tPyaPJld7Ai0sC2s5ZSRX1aRFkX063U9y5mRXYhR
         C+5ch935yoA+w==
Date:   Tue, 24 May 2022 11:44:08 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        liuyacan <liuyacan@corp.netease.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220524114408.4bf1af38@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Zk89goQck+R.n2x3uj1nBJb";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Zk89goQck+R.n2x3uj1nBJb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/smc/af_smc.c

between commit:

  75c1edf23b95 ("net/smc: postpone sk_refcnt increment in connect()")

from the net tree and commit:

  3aba103006bc ("net/smc: align the connect behaviour with TCP")

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

diff --cc net/smc/af_smc.c
index d3de54b70c05,5f70642a8044..000000000000
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@@ -1564,9 -1584,11 +1584,11 @@@ static int smc_connect(struct socket *s
  	if (rc && rc !=3D -EINPROGRESS)
  		goto out;
 =20
- 	if (smc->use_fallback)
 -	sock_hold(&smc->sk); /* sock put in passive closing */
+ 	if (smc->use_fallback) {
+ 		sock->state =3D rc ? SS_CONNECTING : SS_CONNECTED;
  		goto out;
+ 	}
 +	sock_hold(&smc->sk); /* sock put in passive closing */
  	if (flags & O_NONBLOCK) {
  		if (queue_work(smc_hs_wq, &smc->connect_work))
  			smc->connect_nonblock =3D 1;

--Sig_/Zk89goQck+R.n2x3uj1nBJb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKMOGgACgkQAVBC80lX
0GzjqggAofBaqfeYFlkPgPQg6oj4xhagsdVwWACKLcyiO+y6E9+fl+loxSz4Nzbq
rjbtv6gaDwd/1OUJL19sF/mZ3yINTgbORZjqXUVPlCvYwybrjSD8sb6vr2t0EIP4
VeDevAqepIDcRptSyJe/dumKogOwW23YYCEDD8UK7Z528WWjR/EMsUFmaAhEDAKQ
HS4Jkh0JMDaOxZuPK1Jmv4rpcNAfuxXj4caE8AlzsI0/D8q3CiKyAEvwBnRJCV2o
HtQZBPwOFBtrTZ880kODlI8IvHLL3a9aw6YL5Bfo+Gh1dv2Z7Ut6RUf7Zd7lgZx4
qA+OJ9SbfiXGaUXg2Qc0AsMnIKm3WQ==
=LOHp
-----END PGP SIGNATURE-----

--Sig_/Zk89goQck+R.n2x3uj1nBJb--

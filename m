Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAC74D0CA8
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344185AbiCHAMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344131AbiCHAMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:12:13 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DAA37022;
        Mon,  7 Mar 2022 16:10:47 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KCG1w4KWpz4xvZ;
        Tue,  8 Mar 2022 11:10:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646698245;
        bh=iCc7WGqpMMXHLsEb4wHBI2GkdKkCV+OSxpSWkMIBTYY=;
        h=Date:From:To:Cc:Subject:From;
        b=JwmUJjud7iCrNTUYEcGIQldPHSYsP8JtH01Uh1w+emR6fwtrHmErBj+7LcMa3IEwR
         D12JzmVKtlVbZyHLUXGBHUOcp4wbMvgirUhhZk251gGWe+unwiFYoyub0D/8hy7yuN
         eIy+eBjLvcU2Exx427Rl1Odex0rtvF7M8Et6CSWtwSg7nip4/LK4F0spzVBA7T2V9d
         1d7dDm0ZsShxJS8syirQf5J4FI06LftVlqqr7KfEFD8xqRtYIR5mO3qhxkV25QD5I7
         LReAWcGCG3nF4qi/P9E0Z5awfX5/QgOCMGc6Oqmny4/+AOahzwpntwtS/HqPdCyM/K
         bie2dHKzmtvXA==
Date:   Tue, 8 Mar 2022 11:10:43 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: linux-next: manual merge of the net-next tree with the
 staging.current tree
Message-ID: <20220308111043.1018a59d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/kqz183InSqHJBsAYyJUDYub";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/kqz183InSqHJBsAYyJUDYub
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/staging/gdm724x/gdm_lte.c

between commit:

  fc7f750dc9d1 ("staging: gdm724x: fix use after free in gdm_lte_rx()")

from the staging.current tree and commit:

  4bcc4249b4cf ("staging: Use netif_rx().")

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

diff --cc drivers/staging/gdm724x/gdm_lte.c
index 0d8d8fed283d,2587309da766..000000000000
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@@ -76,10 -76,9 +76,10 @@@ static void tx_complete(void *arg
 =20
  static int gdm_lte_rx(struct sk_buff *skb, struct nic *nic, int nic_type)
  {
 -	int ret;
 +	int ret, len;
 =20
 +	len =3D skb->len + ETH_HLEN;
- 	ret =3D netif_rx_ni(skb);
+ 	ret =3D netif_rx(skb);
  	if (ret =3D=3D NET_RX_DROP) {
  		nic->stats.rx_dropped++;
  	} else {

--Sig_/kqz183InSqHJBsAYyJUDYub
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmImnwMACgkQAVBC80lX
0GwyxwgAnquv2V3vkBKq9jW3/OUDq739TUPLq4opdFRHIawwN+xJJ/yLt050eod+
WmHwX7uHNPNCgjs9vCB5IHkiCG6yw5nBFXexW3TbiQWHssGtcN1cJj/9BiGfDVtl
xsKRUWCIOjpa3V8OoeQ6ZO8AuYA/Ic5b8ez/cKjOQddDde8mSN9DFuKJp3EU417+
9GMF6SBOSbXnOtla5/kYV4/go0xzQ1DC6uBW/qPB6WJGALNxiPeZhPiu9E1eaV7F
pGn+uXBkdADovcM61YhC/zLTkxC2mYmquVNxkoFvV9ZvyqhRnpgDn6Un+BtSnzFk
vxyhLBsO3+BR7V1ujvlYAK2EofnmPQ==
=plsM
-----END PGP SIGNATURE-----

--Sig_/kqz183InSqHJBsAYyJUDYub--

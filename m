Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A4E47A587
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 08:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237773AbhLTHvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 02:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237770AbhLTHvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 02:51:43 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FEFC061574;
        Sun, 19 Dec 2021 23:51:43 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JHWxl5ghrz4xhk;
        Mon, 20 Dec 2021 18:51:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1639986701;
        bh=7GT5K7fTmP/eSqxd6nW54pCiS62Wq1ex91Uw0pBJJf8=;
        h=Date:From:To:Cc:Subject:From;
        b=OWXiiSFzW2PhZn0NNeMzqmWpSN32rmZYpaHtWHLj107fpmoT/Ke/fQH/eNXLPDPYc
         vo04ViptNOaN+iKUs+SQIU86wvSKACricyu64cGAY6uDrjGnu7j8H4TqjQOArSQI6i
         9K4hQqonSLThQ71b0An53ndC0invuts5riionVNNazs+Vo0cEExU1VVnU8m/8vxYjP
         VsrcRpanC8TlIptJ4o0xPv30Whh+Z/Mg7ifZB1jk+odn4lKefuG5La42DpL7CcmvgT
         Cy7e58f6pY6G4vtxABhnhcdQXqWpdIJKHsGsqxnQwMPZQrD1X2sGqQxC0p0pVnaVhm
         JQan4FqrqGqbw==
Date:   Mon, 20 Dec 2021 18:51:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Wei Liu <wei.liu@kernel.org>, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: linux-next: manual merge of the hyperv tree with the net-next tree
Message-ID: <20211220185139.034d8e15@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/i2X==Lei54qKdGx+3=x1b/C";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/i2X==Lei54qKdGx+3=x1b/C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the hyperv tree got a conflict in:

  drivers/net/hyperv/netvsc.c

between commit:

  e9268a943998 ("hv_netvsc: Use bitmap_zalloc() when applicable")

from the net-next tree and commit:

  63cd06c67a2f ("net: netvsc: Add Isolation VM support for netvsc driver")

from the hyperv tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/hyperv/netvsc.c
index 5086cd07d1ed,ea2d867121d5..000000000000
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@@ -153,9 -153,22 +153,22 @@@ static void free_netvsc_device(struct r
  	int i;
 =20
  	kfree(nvdev->extension);
- 	vfree(nvdev->recv_buf);
- 	vfree(nvdev->send_buf);
+=20
+ 	if (nvdev->recv_original_buf) {
+ 		hv_unmap_memory(nvdev->recv_buf);
+ 		vfree(nvdev->recv_original_buf);
+ 	} else {
+ 		vfree(nvdev->recv_buf);
+ 	}
+=20
+ 	if (nvdev->send_original_buf) {
+ 		hv_unmap_memory(nvdev->send_buf);
+ 		vfree(nvdev->send_original_buf);
+ 	} else {
+ 		vfree(nvdev->send_buf);
+ 	}
+=20
 -	kfree(nvdev->send_section_map);
 +	bitmap_free(nvdev->send_section_map);
 =20
  	for (i =3D 0; i < VRSS_CHANNEL_MAX; i++) {
  		xdp_rxq_info_unreg(&nvdev->chan_table[i].xdp_rxq);
@@@ -336,7 -349,9 +349,8 @@@ static int netvsc_init_buf(struct hv_de
  	struct net_device *ndev =3D hv_get_drvdata(device);
  	struct nvsp_message *init_packet;
  	unsigned int buf_size;
 -	size_t map_words;
  	int i, ret =3D 0;
+ 	void *vaddr;
 =20
  	/* Get receive buffer area. */
  	buf_size =3D device_info->recv_sections * device_info->recv_section_size;

--Sig_/i2X==Lei54qKdGx+3=x1b/C
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHANgsACgkQAVBC80lX
0GwP+wf8CcfNfxiR91qe3oV15Vjmxyod7GirwV6/ShesS094jNppYZmCyF2GJJYU
qjiSw76vEvnLvM9up+zT30JRSrROD/QzKpApmtfK64v1qV+5DtuUK0PFgp9+jcrx
GbSl2/XuDRJ2BT7EXfGMtV+6gOdMr/4ca40k/s4TZlwz4CSIJDJVR+GtyGyY712l
1zIiI8a6ahtP1+shykgDcxpT3MOwGaMm09YOLv89EWq3Td7Ah8JcGYs5STF718aO
vXgTMSm84MOFhatxNfKzb+FWttRvxK3/59OdVXhFXu8IfDNqJMFAy+9sQSjam/v7
0LYyVh1YHIkp1mIuQDYtjME7ViyMhA==
=oj++
-----END PGP SIGNATURE-----

--Sig_/i2X==Lei54qKdGx+3=x1b/C--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251F21221C4
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 02:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfLQB5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 20:57:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36600 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbfLQB5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 20:57:42 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih27I-0007JG-LN; Tue, 17 Dec 2019 01:57:40 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih27I-0008Cw-7g; Tue, 17 Dec 2019 01:57:40 +0000
Date:   Tue, 17 Dec 2019 01:57:40 +0000
From:   Ben Hutchings <ben@decadent.org.uk>
To:     netdev@vger.kernel.org
Cc:     GR-Linux-NIC-Dev@marvell.com,
        Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH net] net: qlogic: Fix error paths in ql_alloc_large_buffers()
Message-ID: <20191217015740.GA31381@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ql_alloc_large_buffers() has the usual RX buffer allocation
loop where it allocates skbs and maps them for DMA.  It also
treats failure as a fatal error.

There are (at least) three bugs in the error paths:

1. ql_free_large_buffers() assumes that the lrg_buf[] entry for the
first buffer that couldn't be allocated will have .skb =3D=3D NULL.
But the qla_buf[] array is not zero-initialised.

2. ql_free_large_buffers() DMA-unmaps all skbs in lrg_buf[].  This is
incorrect for the last allocated skb, if DMA mapping failed.

3. Commit 1acb8f2a7a9f ("net: qlogic: Fix memory leak in
ql_alloc_large_buffers") added a direct call to dev_kfree_skb_any()
after the skb is recorded in lrg_buf[], so ql_free_large_buffers()
will double-free it.

The bugs are somewhat inter-twined, so fix them all at once:

* Clear each entry in qla_buf[] before attempting to allocate
  an skb for it.  This goes half-way to fixing bug 1.
* Set the .skb field only after the skb is DMA-mapped.  This
  fixes the rest.

Fixes: 1357bfcf7106 ("qla3xxx: Dynamically size the rx buffer queue ...")
Fixes: 0f8ab89e825f ("qla3xxx: Check return code from pci_map_single() ...")
Fixes: 1acb8f2a7a9f ("net: qlogic: Fix memory leak in ql_alloc_large_buffer=
s")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This is compile-tested only, unfortunately.  But if it's correct, it
needs to go to stable.

Ben.

 drivers/net/ethernet/qlogic/qla3xxx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/q=
logic/qla3xxx.c
index b4b8ba00ee01..986f26578d34 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2756,6 +2756,9 @@ static int ql_alloc_large_buffers(struct ql3_adapter =
*qdev)
 	int err;
=20
 	for (i =3D 0; i < qdev->num_large_buffers; i++) {
+		lrg_buf_cb =3D &qdev->lrg_buf[i];
+		memset(lrg_buf_cb, 0, sizeof(struct ql_rcv_buf_cb));
+
 		skb =3D netdev_alloc_skb(qdev->ndev,
 				       qdev->lrg_buffer_len);
 		if (unlikely(!skb)) {
@@ -2766,11 +2769,7 @@ static int ql_alloc_large_buffers(struct ql3_adapter=
 *qdev)
 			ql_free_large_buffers(qdev);
 			return -ENOMEM;
 		} else {
-
-			lrg_buf_cb =3D &qdev->lrg_buf[i];
-			memset(lrg_buf_cb, 0, sizeof(struct ql_rcv_buf_cb));
 			lrg_buf_cb->index =3D i;
-			lrg_buf_cb->skb =3D skb;
 			/*
 			 * We save some space to copy the ethhdr from first
 			 * buffer
@@ -2792,6 +2791,7 @@ static int ql_alloc_large_buffers(struct ql3_adapter =
*qdev)
 				return -ENOMEM;
 			}
=20
+			lrg_buf_cb->skb =3D skb;
 			dma_unmap_addr_set(lrg_buf_cb, mapaddr, map);
 			dma_unmap_len_set(lrg_buf_cb, maplen,
 					  qdev->lrg_buffer_len -

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl34Ng8ACgkQ57/I7JWG
EQnrURAAktiYl1Y5C107OiELke07AMNieraO6+3rzDF/Kcc9Q2xV7Yua9vSuGHeU
cnlybYKcL5s9vUNK5MKiSoWZ3xu/S3NexhXoimrxxbr5V2zQCILfRldGVoz+Og71
hPaRe36YxgwMKMXGMj8RFFxcV3Al+LfbBmsYvpwVA8LdlOS8yv1a0dvagFKCHX0Y
PaMXim3bvNjEHYWYkbvgqKGc6qna06c99cgMnLIzzE5CrkZeT9qA1XWx7uFk0x1+
mEF2WkNKILwCOXao5JXI+5U29Ou9gKstZ3BZeS33W5V1Qf46fDVceaHd2eY0tkWF
vaABl1vVB6DNK2RDTOQEbrAlfZnrUsPe8ziqraUK3fGa8yMJUHji8VUX6e3RCqm+
XP4eemkWgEs9ctWsytFD4KP2or5mg8pepLp9n5Z8sU0Ks/k+TqlyMICr6q/JfFg1
GCGR/zAHXlmGalqK55uzP1SSPxQNG9o8wunsxrtlm21qYuq/0I/AWEfNrLaOf1vl
Tm/lIe+VA1WoW7SFt1IjmP1v3egUOaou6DaFlc7wdHd6Wu6uQcZDkt8T/cztYe8r
Ofok6dsVkxO46pUiYmgMIqFwBNBS3OQ6rQs8v2GYMk4tN7Q1q5mR3821ABFwMcN9
AJNzoDpTck81BGTo8W+8sDDR6yix6VIidud+mtGdg98yf2T5zVY=
=tuja
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--

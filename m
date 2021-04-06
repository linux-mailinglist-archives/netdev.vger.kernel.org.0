Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B012C354EF5
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 10:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244546AbhDFIsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 04:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbhDFIs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 04:48:28 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A451C06174A;
        Tue,  6 Apr 2021 01:48:19 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FF1Q71N5vz9sW1;
        Tue,  6 Apr 2021 18:48:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1617698897;
        bh=ABsHGZMGOlwHdAHhwJmAPXIrNxN9GB+9+e8gemhSckg=;
        h=Date:From:To:Cc:Subject:From;
        b=lG0v4aYszpO37QFTERoEeotcZl75jQRPSk7enz2n4IT6zxM1/DJyAGUD/sWiJ4HF+
         nRQatVtm+yGyLdwakqgFTCysIvufVTTV9Sfl8dco0o4bt7HBIkD5WAoDsEBgAq2sFq
         AHoOq0LCH/sTy5nH3azlCEiGbWUuhOCi8iE+F+gq9FGvC5j0jaR6KPYdqeTsmB+Jft
         nxsWvB4rTjEa8lj6kQp8qP/eGjJ51tjjjFH8a0d6iIVEkuUXFgr9Bekl4iCS8ewYUG
         cJABoJU1YESx5+GGrpdKwMvAmd7mXhrLVWA4TzQDdHLov2AVZ8gBUlOpsP4+z+NEdp
         ioctRvXra6SAA==
Date:   Tue, 6 Apr 2021 18:48:14 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: linux-next: manual merge of the tty tree with the net-next tree
Message-ID: <20210406184814.3c958f51@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/npdE0yttFZu5qg/EyUARnil";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/npdE0yttFZu5qg/EyUARnil
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tty tree got a conflict in:

  net/nfc/nci/uart.c

between commit:

  d3295869c40c ("net: nfc: Fix spelling errors in net/nfc module")

from the net-next tree and commit:

  c2a5a45c0276 ("net: nfc: nci: drop nci_uart_ops::recv_buf")

from the tty tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/nfc/nci/uart.c
index 6af5752cde09,9958b37d8f9d..000000000000
--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@@ -229,6 -229,72 +229,72 @@@ static void nci_uart_tty_wakeup(struct=20
  	nci_uart_tx_wakeup(nu);
  }
 =20
+ /* -- Default recv_buf handler --
+  *
+  * This handler supposes that NCI frames are sent over UART link without =
any
+  * framing. It reads NCI header, retrieve the packet size and once all pa=
cket
+  * bytes are received it passes it to nci_uart driver for processing.
+  */
+ static int nci_uart_default_recv_buf(struct nci_uart *nu, const u8 *data,
+ 				     int count)
+ {
+ 	int chunk_len;
+=20
+ 	if (!nu->ndev) {
+ 		nfc_err(nu->tty->dev,
+ 			"receive data from tty but no NCI dev is attached yet, drop buffer\n");
+ 		return 0;
+ 	}
+=20
+ 	/* Decode all incoming data in packets
+ 	 * and enqueue then for processing.
+ 	 */
+ 	while (count > 0) {
+ 		/* If this is the first data of a packet, allocate a buffer */
+ 		if (!nu->rx_skb) {
+ 			nu->rx_packet_len =3D -1;
+ 			nu->rx_skb =3D nci_skb_alloc(nu->ndev,
+ 						   NCI_MAX_PACKET_SIZE,
+ 						   GFP_ATOMIC);
+ 			if (!nu->rx_skb)
+ 				return -ENOMEM;
+ 		}
+=20
+ 		/* Eat byte after byte till full packet header is received */
+ 		if (nu->rx_skb->len < NCI_CTRL_HDR_SIZE) {
+ 			skb_put_u8(nu->rx_skb, *data++);
+ 			--count;
+ 			continue;
+ 		}
+=20
+ 		/* Header was received but packet len was not read */
+ 		if (nu->rx_packet_len < 0)
+ 			nu->rx_packet_len =3D NCI_CTRL_HDR_SIZE +
+ 				nci_plen(nu->rx_skb->data);
+=20
+ 		/* Compute how many bytes are missing and how many bytes can
+ 		 * be consumed.
+ 		 */
+ 		chunk_len =3D nu->rx_packet_len - nu->rx_skb->len;
+ 		if (count < chunk_len)
+ 			chunk_len =3D count;
+ 		skb_put_data(nu->rx_skb, data, chunk_len);
+ 		data +=3D chunk_len;
+ 		count -=3D chunk_len;
+=20
 -		/* Chcek if packet is fully received */
++		/* Check if packet is fully received */
+ 		if (nu->rx_packet_len =3D=3D nu->rx_skb->len) {
+ 			/* Pass RX packet to driver */
+ 			if (nu->ops.recv(nu, nu->rx_skb) !=3D 0)
+ 				nfc_err(nu->tty->dev, "corrupted RX packet\n");
+ 			/* Next packet will be a new one */
+ 			nu->rx_skb =3D NULL;
+ 		}
+ 	}
+=20
+ 	return 0;
+ }
+=20
  /* nci_uart_tty_receive()
   *
   *     Called by tty low level driver when receive data is

--Sig_/npdE0yttFZu5qg/EyUARnil
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBsIE4ACgkQAVBC80lX
0GwlhAf/YRzh8ybiW4d+jTnsrvJbLwgzdhAIFx9mdQYrTJgmEdSanCbPkhrP2+TB
SqH2o5C4d4fRKxsa7GL8boMjnNz2EjCTwCMxXD0sSp7geJsSUKhMeAi2APiXfqfE
t8CogoVAdXDBX4o3UFw5XMK1f89oQgO7QlDQJAzJr4XNVXSzi3CrBaApkjoxRJuF
ntadA8Cw8y4ReoC8z5AOrlOLW0eqQ6mtzj4RYaQn+Fku/JWfsQnW5uG424EGFFsi
EtM9GYCc6koP+B0ZoGuBUyQWXUE3hm73U3YsZ18279NbiYSt1XHiHMeDk4RSxweF
w8J+F7HoG/fxqjnBf357arRMxtcLZw==
=fLcA
-----END PGP SIGNATURE-----

--Sig_/npdE0yttFZu5qg/EyUARnil--

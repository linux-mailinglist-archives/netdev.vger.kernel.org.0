Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B58341163
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 01:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbhCSARB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 20:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhCSAQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 20:16:59 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB6FC06174A;
        Thu, 18 Mar 2021 17:16:58 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F1kwQ1ynCz9sVb;
        Fri, 19 Mar 2021 11:16:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616113015;
        bh=rGb+OlL120TU6VUsasYJ7KMDZZQBFctFwRjV/8knuLw=;
        h=Date:From:To:Cc:Subject:From;
        b=Bq3nNEL6Q2CX3BQTJ7nQjaklcUdJ55BG2tjqayjpd6Cu4L11a4wsa6QAnRkRxf61c
         BPQO/UAhdG9iea870KWVJoJ/DxAX3vXOJU+mK6JkcUBGw/rUClHLDSJ0bA3MP9QzVN
         HBkz+M7uCfpX9A6tmxGe2Dr2MNCF0qqIEboypL+bzfCkNCPLSRwEMEzp1V89HNbp9D
         +pbJDzKIbOdXQcIBGiTSjEqaE9wNH6nhWg1wogKL8JLHfiTZbxOSymos0Qfzmr9imv
         5OZkSeQd9oYRWxKbprgE2oqHHXAiWmsKusWwSZTBuiOMM9OMj76v6eu9mtp3SchYzB
         INVL2KUd1Hoig==
Date:   Fri, 19 Mar 2021 11:16:52 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Piotr Krysiuk <piotras@gmail.com>, Yonghong Song <yhs@fb.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210319111652.474c0939@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8_22xNXcrJvBbPa8M6GaNXh";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/8_22xNXcrJvBbPa8M6GaNXh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  kernel/bpf/verifier.c

between commits:

  b5871dca250c ("bpf: Simplify alu_limit masking for pointer arithmetic")
  1b1597e64e1a ("bpf: Add sanity check for upper ptr_limit")

from the net tree and commit:

  69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")

from the net-next tree.

I fixed it up (see below - but it may need more work on the new
"return" starement from the latter commit) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc kernel/bpf/verifier.c
index 44e4ec1640f1,f9096b049cd6..000000000000
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@@ -5876,10 -6056,22 +6060,23 @@@ static int retrieve_ptr_limit(const str
  		if (mask_to_left)
  			*ptr_limit =3D MAX_BPF_STACK + off;
  		else
 -			*ptr_limit =3D -off;
 -		return 0;
 +			*ptr_limit =3D -off - 1;
 +		return *ptr_limit >=3D max ? -ERANGE : 0;
+ 	case PTR_TO_MAP_KEY:
+ 		/* Currently, this code is not exercised as the only use
+ 		 * is bpf_for_each_map_elem() helper which requires
+ 		 * bpf_capble. The code has been tested manually for
+ 		 * future use.
+ 		 */
+ 		if (mask_to_left) {
+ 			*ptr_limit =3D ptr_reg->umax_value + ptr_reg->off;
+ 		} else {
+ 			off =3D ptr_reg->smin_value + ptr_reg->off;
+ 			*ptr_limit =3D ptr_reg->map_ptr->key_size - off;
+ 		}
+ 		return 0;
  	case PTR_TO_MAP_VALUE:
 +		max =3D ptr_reg->map_ptr->value_size;
  		if (mask_to_left) {
  			*ptr_limit =3D ptr_reg->umax_value + ptr_reg->off;
  		} else {

--Sig_/8_22xNXcrJvBbPa8M6GaNXh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBT7XQACgkQAVBC80lX
0GxB0Qf5AeqEwFrlK/NGQNVYfPF7gbYVNlA0hgi3D0Y/NElOl78CO5FwAdZCX83+
hJDv2Rj4Dn4CeTFhYzfVqbdI74ghMc+kBPuskJTUc8Zp8/nVHH8pJJUopUYfONwp
HCLaKbNtTYkN4H5p0yXT0E6Bbg8UNKIr3vLeofj/yfzgWGqU1dBClIUCGvQgvFOp
F/ImZnmhDpl3g0koq99TAcXstlEeUmrczlfeiJgBrjAumfPPpoK9d14Dwtrz6AVe
vc8dWlfmMo3sQss/jL8SVvkdOE05r17r4mwNQ/8qxcRBvacpLJHXO62ylA/UfSCx
iHQxRlS3Gc4R4qjJtQNgQVPQSuKqBg==
=TjyD
-----END PGP SIGNATURE-----

--Sig_/8_22xNXcrJvBbPa8M6GaNXh--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D08942B07F
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 01:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbhJLXog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 19:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235374AbhJLXof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 19:44:35 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F584C061570;
        Tue, 12 Oct 2021 16:42:33 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HTXJk266mz4xbG;
        Wed, 13 Oct 2021 10:42:29 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1634082151;
        bh=g9acJh//zlovuSmdbUhopLOLW62cBs3iOTzYjACtTqQ=;
        h=Date:From:To:Cc:Subject:From;
        b=Fof5WC+kXiyiIj2IyCZkIQT0yrm5XRjecB+xTiqg2PDQhNPU11L7j4HcbtIsYUqyv
         dxg0cfc5osUl3bK8VJU5hKh8Y/KHfPG2qNTy/8BHKpOOvmkVKzN3Uat14pw7Xo6yfG
         T4ZXHMuE4WTYA24gFmD68KrwkkyqCrjYlWlkyEdNc0ib5VVPBCfznS7CaeltTJJxa1
         ITNFwgE4TOWIQV0os46COtdId/b7A8EjDhdLYhufsH13r3oQTRuPm3NtM0Dg0BF1+F
         A5KGmXzhlVGsPy1i8HaBOpbxqvImPMFALTW8jiHeR/17RcZzJHU/rfklcfPM6LPHSV
         +yYNOeD1hUOhw==
Date:   Wed, 13 Oct 2021 10:42:27 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Justin Iurman <justin.iurman@uliege.be>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20211013104227.62c4d3af@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//f_UyyKbk9=yHhyogGrIfxM";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_//f_UyyKbk9=yHhyogGrIfxM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/net/ioam6.sh

between commit:

  7b1700e009cc ("selftests: net: modify IOAM tests for undef bits")

from the net tree and commit:

  bf77b1400a56 ("selftests: net: Test for the IOAM encapsulation with IPv6")

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

diff --cc tools/testing/selftests/net/ioam6.sh
index a2489ec398fe,90700303d8a9..000000000000
--- a/tools/testing/selftests/net/ioam6.sh
+++ b/tools/testing/selftests/net/ioam6.sh
@@@ -465,31 -529,21 +529,36 @@@ out_bits(
    local tmp=3D${bit2size[22]}
    bit2size[22]=3D$(( $tmp + ${#ALPHA[9]} + ((4 - (${#ALPHA[9]} % 4)) % 4)=
 ))
 =20
+   [ "$1" =3D "encap" ] && mode=3D"$1 tundst db01::1" || mode=3D"$1"
+   [ "$1" =3D "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 up
+=20
    for i in {0..22}
    do
-     ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace \
-            prealloc type ${bit2type[$i]} ns 123 size ${bit2size[$i]} \
+     ip -netns ioam-node-alpha route change db01::/64 encap ioam6 mode $mo=
de \
+            trace prealloc type ${bit2type[$i]} ns 123 size ${bit2size[$i]=
} \
 -           dev veth0
 +           dev veth0 &>/dev/null
 +
 +    local cmd_res=3D$?
 +    local descr=3D"${desc/<n>/$i}"
 =20
 -    run_test "out_bit$i" "${desc/<n>/$i} ($1 mode)" ioam-node-alpha \
 +    if [[ $i -ge 12 && $i -le 21 ]]
 +    then
 +      if [ $cmd_res !=3D 0 ]
 +      then
 +        npassed=3D$((npassed+1))
 +        log_test_passed "$descr"
 +      else
 +        nfailed=3D$((nfailed+1))
 +        log_test_failed "$descr"
 +      fi
 +    else
-       run_test "out_bit$i" "$descr" ioam-node-alpha ioam-node-beta \
-              db01::2 db01::1 veth0 ${bit2type[$i]} 123
++      run_test "out_bit$i" "$descr ($1 mode)" ioam-node-alpha \
+            ioam-node-beta db01::2 db01::1 veth0 ${bit2type[$i]} 123
 +    fi
    done
 =20
+   [ "$1" =3D "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 down
+=20
    bit2size[22]=3D$tmp
  }
 =20
@@@ -560,15 -629,21 +644,21 @@@ in_bits(
    local tmp=3D${bit2size[22]}
    bit2size[22]=3D$(( $tmp + ${#BETA[9]} + ((4 - (${#BETA[9]} % 4)) % 4) ))
 =20
+   [ "$1" =3D "encap" ] && mode=3D"$1 tundst db01::1" || mode=3D"$1"
+   [ "$1" =3D "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 up
+=20
 -  for i in {0..22}
 +  for i in {0..11} {22..22}
    do
-     ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace \
-            prealloc type ${bit2type[$i]} ns 123 size ${bit2size[$i]} dev =
veth0
+     ip -netns ioam-node-alpha route change db01::/64 encap ioam6 mode $mo=
de \
+            trace prealloc type ${bit2type[$i]} ns 123 size ${bit2size[$i]=
} \
+            dev veth0
 =20
-     run_test "in_bit$i" "${desc/<n>/$i}" ioam-node-alpha ioam-node-beta \
-            db01::2 db01::1 veth0 ${bit2type[$i]} 123
+     run_test "in_bit$i" "${desc/<n>/$i} ($1 mode)" ioam-node-alpha \
+            ioam-node-beta db01::2 db01::1 veth0 ${bit2type[$i]} 123
    done
 =20
+   [ "$1" =3D "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 down
+=20
    bit2size[22]=3D$tmp
  }
 =20

--Sig_//f_UyyKbk9=yHhyogGrIfxM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFmHWMACgkQAVBC80lX
0Gz8GggAif3I9bSftU2N4q8XOukWrh3nos0k0mbbdBDVs+SCODVqZisLz9axgkcv
l0u1giiB8/Is2OtQY39nNOufKhMd2IP2H/ox/3Hg1aabzURImpNXS6wq7mzCfAdV
j+Hwk9720wapv3wh8hzd9IcxBu9i58vzXJtAB3Pau+MO5pIBSvbYoz2YvJG3xXKe
Sx11sTrdn4EWjtswH29OZFvAin1EyyDzXbaW/qT3MKaR27/UgH+qijt3lFli4Ji2
GLv3mnUHB+UK9AF27UTOAdVCCnCqtKwB7/KsemJ7YMsoemPXmHw3crXrrQzNy6mX
33uANzLpJlFj1mBUakCt666BEP+A/Q==
=1deu
-----END PGP SIGNATURE-----

--Sig_//f_UyyKbk9=yHhyogGrIfxM--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4844D9ABD
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 12:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348086AbiCOL6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 07:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbiCOL6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 07:58:43 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E6C517F4;
        Tue, 15 Mar 2022 04:57:32 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KHsN95Qmkz4xv5;
        Tue, 15 Mar 2022 22:57:29 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1647345450;
        bh=Ak7hK5d/JM+xbamjqXCyzPd0/RbHwnu/7DSW2JD3+Cc=;
        h=Date:From:To:Cc:Subject:From;
        b=ap7qU96dQqXD5/iVZAfDmixyRtT0mCedTYWrOx223TAdieIVwXyriuzAQcjO9ywun
         HNvyYOzeTaeUzG7yQuNu0pykG813P+sO1MOftnKOju+6RZ0o5cSUo4nNh54LjLY3lA
         gOb+x76/sKefZGoJt1jEar4f/180RpDcfIHoSH2TmhTJDofvmVYvSWBDoRsY3/fjT2
         RKezs/UFsRDoD02pQbwNqRHfW3L2F2budxIapfAUyI/MRRSvRF2/TWKOU0ImnL4RUk
         EsFAvf2wfal7/sloo8FM29ZhvJdg2P47LnM/wtsHFm3cSD7lUt0/NUmAcYcHyeB3Rz
         uf0BJzjY4ZR1Q==
Date:   Tue, 15 Mar 2022 22:57:29 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, Hao Luo <haoluo@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the akpm-current tree with the bpf-next
 tree
Message-ID: <20220315225729.241ca3e6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/MDZB=SmDbWOFFH5rqQ/vIhF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/MDZB=SmDbWOFFH5rqQ/vIhF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm-current tree got a conflict in:

  include/linux/compiler_types.h

between commit:

  6789ab9668d9 ("compiler_types: Refactor the use of btf_type_tag attribute=
.")

from the bpf-next tree and commit:

  a7e15f5aee27 ("Documentation/sparse: add hints about __CHECKER__")

from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/linux/compiler_types.h
index 1bc760ba400c,232dbd97f8b1..000000000000
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@@ -4,13 -4,7 +4,14 @@@
 =20
  #ifndef __ASSEMBLY__
 =20
 +#if defined(CONFIG_DEBUG_INFO_BTF) && defined(CONFIG_PAHOLE_HAS_BTF_TAG) =
&& \
 +	__has_attribute(btf_type_tag)
 +# define BTF_TYPE_TAG(value) __attribute__((btf_type_tag(#value)))
 +#else
 +# define BTF_TYPE_TAG(value) /* nothing */
 +#endif
 +
+ /* sparse defines __CHECKER__; see Documentation/dev-tools/sparse.rst */
  #ifdef __CHECKER__
  /* address spaces */
  # define __kernel	__attribute__((address_space(0)))

--Sig_/MDZB=SmDbWOFFH5rqQ/vIhF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIwfykACgkQAVBC80lX
0GzHIQf/QqiM0VdwCaZUqspSrULS5B3gbqkP7jCJv/5F16W3pUXcqK99DgyM7Jdr
o0wk6qmTVesHvPWsH5Qax+tYGp4ldtwrai+I8347LeFUGF2Yd+hFsmmU7HxwivzW
GQDiCA4eHQr5Ynz9jRDhfyuqqbf/Yo2rRZZbyLoknr+BRdPUfisHhIlIaU3cZF9w
xeS2hevzgO8hxlY6cvSadkvx28DMmJO6rQGYIbGk79Cv0fYp4kzByQ++bz8WDHS/
WE9z/0sPGXaorPtEkbAZmFDaoATwg9rh23MT2Q5bX4SQWfxVgM0293M14BkmQPaU
EbtwWFdzpsA31G5tEzAOilJkp6NI2A==
=Oumu
-----END PGP SIGNATURE-----

--Sig_/MDZB=SmDbWOFFH5rqQ/vIhF--

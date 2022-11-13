Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC076273A0
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 00:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbiKMXw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 18:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiKMXw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 18:52:56 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C95B7C1;
        Sun, 13 Nov 2022 15:52:53 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4N9TlQ74TLz4xYV;
        Mon, 14 Nov 2022 10:52:50 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668383571;
        bh=pUcy/XN+scuJWHAuLv8FG4qKklNNeaoNs6lPTos5qfg=;
        h=Date:From:To:Cc:Subject:From;
        b=nzVKfxz/KExLltII9HC5QfcEp9++WqNqsV7ai+H4kjwA0FZZpJEIRA2bTiW/C2KzJ
         jXxAfzXpA9M8iqOtd1xXi8AVj+LVbfY17pfyDom8wKvDFhnU594GfgGE80JfT0RBtc
         QrRu7IU3Q4fCSt1AN6bAfIMLMfDNpK+NGltqP8ZNMy2JljRShC9a2w1vD2fEmZiO9A
         fAZ8vfPVrcuqiKuN3RlffEn9EAd2BXypj7fmXrqML6EQY8EdkNz7wVtQ8/YVu0Wb/w
         v9uqkGxsG6qmTNoY6o6vMW+XdelsmLxPO2u6kzU4cKx1ZToMqddO6H4V9XzpCmKEqO
         Q0yYlhVHRemlQ==
Date:   Mon, 14 Nov 2022 10:52:49 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Luis Chamberlain <mcgrof@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: linux-next: manual merge of the modules tree with the net-next tree
Message-ID: <20221114105249.4548adbc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aoFZpiC=LfG81oEsRZMBqrm";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/aoFZpiC=LfG81oEsRZMBqrm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the modules tree got a conflict in:

  kernel/trace/ftrace.c

between commit:

  3640bf8584f4 ("ftrace: Add support to resolve module symbols in ftrace_lo=
okup_symbols")

from the net-next tree and commit:

  477f7e48d4f4 ("kallsyms: Delete an unused parameter related to kallsyms_o=
n_each_symbol()")

from the modules tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc kernel/trace/ftrace.c
index 705b990d264d,7a06991624d4..000000000000
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@@ -8257,12 -8257,7 +8257,11 @@@ struct kallsyms_data=20
  	size_t found;
  };
 =20
 +/* This function gets called for all kernel and module symbols
 + * and returns 1 in case we resolved all the requested symbols,
 + * 0 otherwise.
 + */
- static int kallsyms_callback(void *data, const char *name,
- 			     struct module *mod, unsigned long addr)
+ static int kallsyms_callback(void *data, const char *name, unsigned long =
addr)
  {
  	struct kallsyms_data *args =3D data;
  	const char **sym;

--Sig_/aoFZpiC=LfG81oEsRZMBqrm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNxg1EACgkQAVBC80lX
0GzjiAf+OOCN11Mim0zJN8O8jOjiZu7VtagWob7Hg86RyhPIoyZfbY3OqTf9cwMo
ItM1wADuBnsph4OZlsaq6VLnvHqs7CVolmkTjagJ31uck1J0CDVoQLNYn2u8Qyxq
XQBfU2Hhp/QsHS59HYob0gPbM4d9TnL/Alj+V6Ek9XDoMUM5Ujzld4j84jWmYBLF
Y5daIXjxNTyB3ykbEHvGy62m8xo9BfSvdndPj0zqMxqDw8WpgNXY5vxqfEE7S9J1
IXuYujy+KSgqRWnr/ocmQy9e9TuFn+r7VIOcInJZTcr65GABCLJb82at4qE7WHrh
+dzVUgMoPiuLuxoAIW0alrpLJoCnuQ==
=uiQd
-----END PGP SIGNATURE-----

--Sig_/aoFZpiC=LfG81oEsRZMBqrm--

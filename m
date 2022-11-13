Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C975627393
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 00:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbiKMXqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 18:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiKMXqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 18:46:39 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282CBEAF;
        Sun, 13 Nov 2022 15:46:38 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4N9TcC1KJNz4x1V;
        Mon, 14 Nov 2022 10:46:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668383196;
        bh=p9cwpJgX7TeFvxg8QIGt1dTdDdRe10v7vFZ2y90vuDE=;
        h=Date:From:To:Cc:Subject:From;
        b=I0xFcgKAjNfAM+idvtTyKbowjW1pDEnKaBOn3YeTpO/Czwe11EbNmuDkF8N1xiAvl
         ltWsIevL+XtgjziYN2+c00WSmu7xruBxmKy2B6kQ14+XGpi3BkLl++1UhWZqCtjgeJ
         HCZ9eVe1YlSARgqV922MOtgJwE3KPuvWvlkZWyt1OiCsetrc3go3wY/ZCNc2BDpob/
         hXFWTtmT1pe1VQcoEr+Fn7D3007OZY6gWkHbT8/1JZxcoDsLoyssAYQlS89a4a44HT
         hbxfzZNWbsiVrUzXXejs3p8bXEFMXRk1UammIvTAWKC1vsNAF5VymRmbUwZYdqMIfg
         pmBOMPBh05Wgw==
Date:   Mon, 14 Nov 2022 10:46:33 +1100
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
Message-ID: <20221114104633.4961d175@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/bq2TEQpZj0Py2YhvVmkgUAU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/bq2TEQpZj0Py2YhvVmkgUAU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the modules tree got conflicts in:

  include/linux/module.h
  kernel/module/kallsyms.c

between commit:

  73feb8d5fa3b ("kallsyms: Make module_kallsyms_on_each_symbol generally av=
ailable")

from the net-next tree and commit:

  90de88426f3c ("livepatch: Improve the search performance of module_kallsy=
ms_on_each_symbol()")

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

diff --cc include/linux/module.h
index 35876e89eb93,3b312a1fcf59..000000000000
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@@ -879,17 -878,8 +878,17 @@@ static inline bool module_sig_ok(struc
  }
  #endif	/* CONFIG_MODULE_SIG */
 =20
 +#if defined(CONFIG_MODULES) && defined(CONFIG_KALLSYMS)
- int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
- 					     struct module *, unsigned long),
+ int module_kallsyms_on_each_symbol(const char *modname,
+ 				   int (*fn)(void *, const char *, unsigned long),
  				   void *data);
 +#else
- static inline int module_kallsyms_on_each_symbol(int (*fn)(void *, const =
char *,
- 						 struct module *, unsigned long),
- 						 void *data)
++static inline int module_kallsyms_on_each_symbol(const char *modname,
++						 int (*fn)(void *, const char *, unsigned long),
++						 void *data);
 +{
 +	return -EOPNOTSUPP;
 +}
 +#endif  /* CONFIG_MODULES && CONFIG_KALLSYMS */
 =20
  #endif /* _LINUX_MODULE_H */
diff --cc kernel/module/kallsyms.c
index 4523f99b0358,329cef573675..000000000000
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@@ -494,8 -494,9 +494,8 @@@ unsigned long module_kallsyms_lookup_na
  	return ret;
  }
 =20
- int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
- 					     struct module *, unsigned long),
 -#ifdef CONFIG_LIVEPATCH
+ int module_kallsyms_on_each_symbol(const char *modname,
+ 				   int (*fn)(void *, const char *, unsigned long),
  				   void *data)
  {
  	struct module *mod;

--Sig_/bq2TEQpZj0Py2YhvVmkgUAU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNxgdkACgkQAVBC80lX
0GzG4wf/TSAkdLTYlfJm3PL0crKjP0MFUpbC7F0GvWio0p52eC6XDkKub2dGpUIQ
ua54ZzLlXu5emhODl1doR9flyYe2Gj/nBa6KUTsZ4XTj9L2UFlxLZKw/Cbhudjxk
6Qpr6i8Ho7ob1aaGqBvZnf4wS3CNJ9xMA7PLZWThIOdt36H3Ynl2oTBnFDRBt3TZ
zz9819TTJJEfJTodkFDKAf05sF7DiOL7lWlaRaIVuQDzt1RvsGixgQgmw+pmeOAV
j4UF91nEzK21WyKatEcVNhq3aR+O/u7LIrliUAQJs1tPOuLXkFUpGoxgOW8McGNz
O1k1kLVI3mmQC7PwCRQehV15AykTQQ==
=mYNi
-----END PGP SIGNATURE-----

--Sig_/bq2TEQpZj0Py2YhvVmkgUAU--

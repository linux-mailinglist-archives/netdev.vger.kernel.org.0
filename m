Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA62522C62
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 08:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242132AbiEKGdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 02:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240225AbiEKGdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 02:33:09 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD1869B62;
        Tue, 10 May 2022 23:33:07 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KylTV0H1Lz4xXS;
        Wed, 11 May 2022 16:33:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1652250782;
        bh=zfteaCyKXsiowhc6NxU6PfuAwCM7GF0aOkUMghOEiHQ=;
        h=Date:From:To:Cc:Subject:From;
        b=LPN0abuR1FZorftIfaddKrP4pXZfLlrvFNSRbKPRi5Ux6HPmEEjH9fj12Cw83ScCG
         2qslfO/wLn9Lju+GoVzR9MUCNEtq1Yzigo32a37THQtjodx5rCfvTObLmelMQESep4
         DRoBCBYSmFxSgqTrlseApcOi3kLi+z8lboj28RZqlqnkHCIegNFE1GN9PCFPISYLxB
         IuKE5IOeGBeStDJSMj2+E47gOjq+E9zYxB4cipR8YmGJU33Hnd+YzK+VZkLFvIRkkH
         UCpBxKv8J78b60IHrM+rGl2CnyA0MHCpGDMWqnpvkv5K5sG19+w70ZJcWhJqkwHVUz
         GsGVvP4y/gLwg==
Date:   Wed, 11 May 2022 16:33:00 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Wei Xiao <xiaowei66@huawei.com>
Subject: linux-next: manual merge of the sysctl tree with the bpf-next tree
Message-ID: <20220511163300.2647cd22@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qLM32q4gp2woBuGRf4/knqT";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/qLM32q4gp2woBuGRf4/knqT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sysctl tree got a conflict in:

  kernel/trace/ftrace.c

between commit:

  bed0d9a50dac ("ftrace: Add ftrace_lookup_symbols function")

from the bpf-next tree and commit:

  8e4e83b2278b ("ftrace: move sysctl_ftrace_enabled to ftrace.c")

from the sysctl tree.

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
index 07d87c7a525d,1f89039f0feb..000000000000
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@@ -7965,64 -7969,21 +7969,83 @@@ ftrace_enable_sysctl(struct ctl_table *
  	return ret;
  }
 =20
+ static struct ctl_table ftrace_sysctls[] =3D {
+ 	{
+ 		.procname       =3D "ftrace_enabled",
+ 		.data           =3D &ftrace_enabled,
+ 		.maxlen         =3D sizeof(int),
+ 		.mode           =3D 0644,
+ 		.proc_handler   =3D ftrace_enable_sysctl,
+ 	},
+ 	{}
+ };
+=20
+ static int __init ftrace_sysctl_init(void)
+ {
+ 	register_sysctl_init("kernel", ftrace_sysctls);
+ 	return 0;
+ }
+ late_initcall(ftrace_sysctl_init);
+ #endif
++
 +static int symbols_cmp(const void *a, const void *b)
 +{
 +	const char **str_a =3D (const char **) a;
 +	const char **str_b =3D (const char **) b;
 +
 +	return strcmp(*str_a, *str_b);
 +}
 +
 +struct kallsyms_data {
 +	unsigned long *addrs;
 +	const char **syms;
 +	size_t cnt;
 +	size_t found;
 +};
 +
 +static int kallsyms_callback(void *data, const char *name,
 +			     struct module *mod, unsigned long addr)
 +{
 +	struct kallsyms_data *args =3D data;
 +
 +	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_=
cmp))
 +		return 0;
 +
 +	addr =3D ftrace_location(addr);
 +	if (!addr)
 +		return 0;
 +
 +	args->addrs[args->found++] =3D addr;
 +	return args->found =3D=3D args->cnt ? 1 : 0;
 +}
 +
 +/**
 + * ftrace_lookup_symbols - Lookup addresses for array of symbols
 + *
 + * @sorted_syms: array of symbols pointers symbols to resolve,
 + * must be alphabetically sorted
 + * @cnt: number of symbols/addresses in @syms/@addrs arrays
 + * @addrs: array for storing resulting addresses
 + *
 + * This function looks up addresses for array of symbols provided in
 + * @syms array (must be alphabetically sorted) and stores them in
 + * @addrs array, which needs to be big enough to store at least @cnt
 + * addresses.
 + *
 + * This function returns 0 if all provided symbols are found,
 + * -ESRCH otherwise.
 + */
 +int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned =
long *addrs)
 +{
 +	struct kallsyms_data args;
 +	int err;
 +
 +	args.addrs =3D addrs;
 +	args.syms =3D sorted_syms;
 +	args.cnt =3D cnt;
 +	args.found =3D 0;
 +	err =3D kallsyms_on_each_symbol(kallsyms_callback, &args);
 +	if (err < 0)
 +		return err;
 +	return args.found =3D=3D args.cnt ? 0 : -ESRCH;
 +}

--Sig_/qLM32q4gp2woBuGRf4/knqT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJ7WJwACgkQAVBC80lX
0GyteAf8CmR7P5+kBg3EEqGfyzGLxPKdEL3dEJK1S3tAdADHVd4Lwpx1wTu+A3VZ
+41M+0ajKPWheyEl41Yr1N4intKdKW+5l3B2SpZXYZR6Ct8CqJb4TQfWJz/YgMT4
Q9pwX+slZ3wH52YX0rRRHY7xcH8PC++3bWiiIaGW/MMomP5511YkaftFRWgZ2tep
Ufbo7by6hXwQ4AseCkjLr1/pou4xadSO+C9Oj/TOP/KkVQk3buZ3M/oxPsuptnHv
YGzCqt+5MfbGBAILvEdB01wixF+dyYojyTeCD8Awr3InBNWRiBYCKZdxzvesH1UF
GbkjAt/8xPwFCE3YN6nLCnPF5+QTWQ==
=vCeN
-----END PGP SIGNATURE-----

--Sig_/qLM32q4gp2woBuGRf4/knqT--

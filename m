Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19EF57AD76
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 04:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241014AbiGTCAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 22:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240831AbiGTCAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 22:00:03 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A981509CC;
        Tue, 19 Jul 2022 19:00:01 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Lnf664W6Wz4x1T;
        Wed, 20 Jul 2022 11:59:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1658282399;
        bh=bhdoEw1uXwDmJ3zb0O4cMwVb6jyiL7N3GRG/QYEShtw=;
        h=Date:From:To:Cc:Subject:From;
        b=j9b4R22bso+FdS4VOJxxEVkVaV0GMZw0Had6/899iQFPSVHq7YQCWctP/1kq4meJW
         DOMpuPR3wf8ZCgSD4Zel6CrzDErTkrgHuIJMfl/50BD+1+v2v78UlJFGm+rdAY6djg
         S/uxmCEbPP70SMPACjTMjrTEgNK+ATWPh53HZ4/pxiCD9NbZ9UJDRKe/nq1OuN5XPr
         jNnag1EycWXxVfvI4MDRL8Mq5kiH3h6tbqYTD584Zt7SrvmhWLJVWIJybsS/o9zJZa
         nVmdAuLQZe0QUr6ZDyd0XIgfc88tbe6xJh6MzCcT7DAnLaU3JGkhekJTusHrToPt4z
         cDjx/wdF+ttwg==
Date:   Wed, 20 Jul 2022 11:59:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20220720115956.3c27492f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Fv5//JLIpbwn5VwgxshyjFE";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Fv5//JLIpbwn5VwgxshyjFE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ld: warning: discarding dynamic section .glink
ld: warning: discarding dynamic section .plt
ld: linkage table error against `bpf_trampoline_unlink_cgroup_shim'
ld: stubs don't match calculated size
ld: can not build stubs: bad value
ld: kernel/bpf/cgroup.o: in function `.bpf_cgroup_link_release.part.0':
cgroup.c:(.text+0x2fc4): undefined reference to `.bpf_trampoline_unlink_cgr=
oup_shim'
ld: kernel/bpf/cgroup.o: in function `.cgroup_bpf_release':
cgroup.c:(.text+0x33b0): undefined reference to `.bpf_trampoline_unlink_cgr=
oup_shim'
ld: cgroup.c:(.text+0x33c0): undefined reference to `.bpf_trampoline_unlink=
_cgroup_shim'

Caused by commit

  3908fcddc65d ("bpf: fix lsm_cgroup build errors on esoteric configs")

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/Fv5//JLIpbwn5VwgxshyjFE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLXYZwACgkQAVBC80lX
0GzSFQgAnaA2eOiMKp5wZmiIGDSXhtME62YtWbUflrm1QC+qZEpe+GxRevu795R0
VKEl/qmAd2HuBmbL0CX/LiEp1IO4SQQ9u21qxcDyV/F18i8AYkgILz5jr0nV7kDN
CdNhKwjjSTNNkOamEOUO39lz3jyv6nQfD5HDcQ+SDSIBoy+glrNTJKjDN8BXPD3Z
0pEQrTEfbikPE6gEubcfJ1IPA5As2cxJWcFjbv3qRrq445kABxnOD5SymKWkBWAk
qaqK1QOP0rUpZkRQyqMtQV6WFy4fgPRk/fe7SAPzSncJqyc5uJDpt0BVm/u+DGcc
KtwBZJ14lfYb6T0fNFb13svtMfU5Jw==
=AyPS
-----END PGP SIGNATURE-----

--Sig_/Fv5//JLIpbwn5VwgxshyjFE--

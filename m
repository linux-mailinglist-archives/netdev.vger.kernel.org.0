Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEB95AE040
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238671AbiIFGv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbiIFGvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:51:55 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E09472ECF;
        Mon,  5 Sep 2022 23:51:53 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MMGJl3Mjjz4xDK;
        Tue,  6 Sep 2022 16:51:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1662447112;
        bh=jAQSRQbl/FxCWX10tZ95H26D984hSmBHzQXJ/ihW0OY=;
        h=Date:From:To:Cc:Subject:From;
        b=dJ4R4NsjJckjgAZggi4UXjriIkP9DuOScvCDzt6HPX3ZHEOZTGZ3io+Ax1ZMLcBOk
         fwWaaCMAdi28SFLzYcflXQII8GI6Qzx0T104mxr+vkKhuzQCMgEsPdcc9KX2Az30XJ
         1qwIMT7jrE92XzxQ5ShmiRL8tp+MDrVlA5viFLIBX3R6AcZ7ob571dTi9ZcJROfi+X
         Ek5zGwh8HkMAfHAcxkgDkAbXHiXTcv9+AgQvSP4fupoZp+6YI6jVMmRLki9HODEhMu
         hxigyxh1VlkK5PCyj0pMaKOVFVgd1lSGgatWrK1Kd+0a6XgEQCwideOHSC7RqUSmyy
         hDBq6Tko8ujAg==
Date:   Tue, 6 Sep 2022 16:51:31 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Vlastimil Babka <vbabka@suse.cz>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the slab tree
Message-ID: <20220906165131.59f395a9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/oPe39KmfZ5fb/VpMS=68hiI";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/oPe39KmfZ5fb/VpMS=68hiI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the slab tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/bpf/memalloc.c: In function 'bpf_mem_free':
kernel/bpf/memalloc.c:613:33: error: implicit declaration of function '__ks=
ize'; did you mean 'ksize'? [-Werror=3Dimplicit-function-declaration]
  613 |         idx =3D bpf_mem_cache_idx(__ksize(ptr - LLIST_NODE_SZ));
      |                                 ^~~~~~~
      |                                 ksize

Caused by commit

  8dfa9d554061 ("mm/slab_common: move declaration of __ksize() to mm/slab.h=
")

interacting with commit

  7c8199e24fa0 ("bpf: Introduce any context BPF specific memory allocator.")

from the bpf-next tree.

I have reverted the slab tree commit for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/oPe39KmfZ5fb/VpMS=68hiI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMW7fMACgkQAVBC80lX
0Gw5xQf/XxNg8gI2jZ27P7PtnWXdLktWhD5AXMuJIcKk/NrL3rj+rEW570Ft0m2A
DkUHjWtgOvQxYwQz9ie6PuA4mk1nVM3agTkadcLx6hxGn8z7sHr3P3rlSH9Huf+t
CEjgj+xNTI0Ev4tJbISyz2NIkpgyK0kmfirYm4VN6ZWjeYe05M3S+LAfMhxjBq67
VN62CVhi+ALsoiHyk74KLsziJKom6P7PBYEGJzYPbgqpVFCodWlf3cAGOf3W9ktU
7yjlvVa3mAVp0zXmasDZuPVe55mu6VFllE02Gq0q1qBNwTHSbfwC34QLvHvTOKTR
+/5qh8IL24Lzl7JBgTj5KNlllLi1KQ==
=2mSP
-----END PGP SIGNATURE-----

--Sig_/oPe39KmfZ5fb/VpMS=68hiI--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C4A4E1E72
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 01:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343884AbiCUAZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 20:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234559AbiCUAZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 20:25:02 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17215F4A;
        Sun, 20 Mar 2022 17:23:35 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KMFhd2nhGz4xXV;
        Mon, 21 Mar 2022 11:23:28 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1647822210;
        bh=RuuiFlNkjNtu9E3EPgnh5FZnovH/65omnlAq2qT/hAE=;
        h=Date:From:To:Cc:Subject:From;
        b=uRX2XAZr56jSMQwQtqZoDTLdNe7rJglq7RhdzcXUsgZ38Sg4t7ON7KltHsCYHnTeC
         ipOXdBPb+kknLE7W+3W4juszfdxSNfZX3voLaTGKe1sEjxh0FL6ufC2Gh7nzdqODWB
         UW27cjBXbQVXpPvmPC9+uBNFKN3zEMQ6SXodEDTD71Go/jDHlRTGjwY86rlGkGMmpc
         tCMQsbD9bKCCg31YFnao+ko5b9QT+GVsLX8iCzOQFQbq9ktsYN6kmGaQacgZIf33cb
         R3ff1Ota8L9DeG1a+1YnAoseBHRZrHoAClVyrF7+5fmf06x01+QkOuYDuyoPn6QcP4
         0DUUTDxFxsLZg==
Date:   Mon, 21 Mar 2022 11:23:28 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: linux-next: manual merge of the bpf-next tree with the arm tree
Message-ID: <20220321112328.1dce5df9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/SVLHDKxF8CNBt6gcxfeOYSK";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/SVLHDKxF8CNBt6gcxfeOYSK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  arch/arm/include/asm/stacktrace.h

between commit:

  538b9265c063 ("ARM: unwind: track location of LR value in stack frame")

from the arm tree and commit:

  515a49173b80 ("ARM: rethook: Add rethook arm implementation")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/arm/include/asm/stacktrace.h
index 3e78f921b8b2,babed1707ca8..000000000000
--- a/arch/arm/include/asm/stacktrace.h
+++ b/arch/arm/include/asm/stacktrace.h
@@@ -14,10 -14,7 +14,10 @@@ struct stackframe=20
  	unsigned long sp;
  	unsigned long lr;
  	unsigned long pc;
 +
 +	/* address of the LR value on the stack */
 +	unsigned long *lr_addr;
- #ifdef CONFIG_KRETPROBES
+ #if defined(CONFIG_KRETPROBES) || defined(CONFIG_RETHOOK)
  	struct llist_node *kr_cur;
  	struct task_struct *tsk;
  #endif

--Sig_/SVLHDKxF8CNBt6gcxfeOYSK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmI3xYAACgkQAVBC80lX
0Gyy6QgAm6aIs5yr6ctuyzmpFOISt2CgsbDsvX1tdN5PhCRrRAUTKA4KMzEuYiMk
f3aQOSKnS4X/KmzDNyuVeODsHABxsGkFy8fOEnCTYDGThjvO19cJSxWUrcSVwXtM
TZoNU7I8XBo6GSRKy4HVb1NGXdZPJ7DggpuRrSxdr5JLBuhiJIOQbMPElNTnYb9g
B3qHsWEWDF7bjAM4iQlmtvCgCfR+JEctKQg76snBRkeQZw8x+/oQn/BNCI0Pqanz
13jGjaj26U/V1PL/vImnyLZuXDJ21ka+tx/a5OeBDGEKRbaSnF948nKiLE7uXqsz
dfdIA4iPDTtuxS4PPaWgnLQbeRPQ7A==
=dM5E
-----END PGP SIGNATURE-----

--Sig_/SVLHDKxF8CNBt6gcxfeOYSK--

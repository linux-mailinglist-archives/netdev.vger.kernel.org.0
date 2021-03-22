Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35828343785
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 04:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhCVDiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 23:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhCVDhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 23:37:25 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BBFC061574;
        Sun, 21 Mar 2021 20:37:24 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F3gDD5tNLz9sW4;
        Mon, 22 Mar 2021 14:37:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616384241;
        bh=NboGdHwr2S2yktgIAsj1sWo7FDiR55nOnGCfAsfqSN0=;
        h=Date:From:To:Cc:Subject:From;
        b=tAWtxdJBS6Rq8c/dnOSPPIfpARH0lbbZH4N3ONS4zmDlLvfyLS+UZocCTvjDakIZb
         pUY8WVMObFqdWVD2vu0OYh9fIYpdHtGwzElxgXRyiHeIHPAylaMGhl2WVmBA/YqmNt
         5gTlKbioDXxxPdbj1FdrYXkUckCbiWcFu9hUoWA9fj7LMiBRsqVUTA5Gud5YCI0zFT
         G/jQggYEjEJ9Ac0SToLY3l007xXULiZqwZ3bErmEmqfFHHEVVVPNO3ENPwNMmUjAZ6
         Nt/8+YV18Dm0Eqelyf/gc3+TVSw7IM+oB2vnum/ddsmiGK5p2G8ticPiNFr3rZwP+9
         sChwUrHnpkflQ==
Date:   Mon, 22 Mar 2021 14:37:14 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Borislav Petkov <bp@suse.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the tip tree
Message-ID: <20210322143714.494603ed@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LbUHl=Yx3gwlgcoK8Ghzpoc";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/LbUHl=Yx3gwlgcoK8Ghzpoc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

arch/x86/net/bpf_jit_comp.c: In function 'arch_prepare_bpf_trampoline':
arch/x86/net/bpf_jit_comp.c:2015:16: error: 'ideal_nops' undeclared (first =
use in this function)
 2015 |   memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
      |                ^~~~~~~~~~
arch/x86/net/bpf_jit_comp.c:2015:16: note: each undeclared identifier is re=
ported only once for each function it appears in
arch/x86/net/bpf_jit_comp.c:2015:27: error: 'NOP_ATOMIC5' undeclared (first=
 use in this function); did you mean 'GFP_ATOMIC'?
 2015 |   memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
      |                           ^~~~~~~~~~~
      |                           GFP_ATOMIC

Caused by commit

  a89dfde3dc3c ("x86: Remove dynamic NOP selection")

interacting with commit

  b90829704780 ("bpf: Use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BP=
F_TRAMP_F_CALL_ORIG")

from the net tree.

I have applied the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 22 Mar 2021 14:30:37 +1100
Subject: [PATCH] x86: fix up for "bpf: Use NOP_ATOMIC5 instead of
 emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index db50ab14df67..e2b5da5d441d 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2012,7 +2012,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_imag=
e *im, void *image, void *i
 		/* remember return value in a stack for bpf prog to access */
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
 		im->ip_after_call =3D prog;
-		memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
+		memcpy(prog, x86_nops[5], X86_PATCH_SIZE);
 		prog +=3D X86_PATCH_SIZE;
 	}
=20
--=20
2.30.0

--=20
Cheers,
Stephen Rothwell

--Sig_/LbUHl=Yx3gwlgcoK8Ghzpoc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBYEOoACgkQAVBC80lX
0GxY1Af+NcTCrYK0MkKRfs37Ln+5bzKOQWcI7TmiXwp44wN/P9GcD2NdKMisRt0T
cTJ7B7lY4SfDQO/s96yTeVZX9pWqrREGwI8hLwbjWcGU2bqdniKZX1d6NouatdUe
bFSMs6mk76wxNbJLbiWX8thmtkHtsmMg1RZCadPxeYYpWTsAcWNuj6ARvTfDHwcL
aa4SCs/COWCCpeaIVxZFPINqeyzsSwGWZcYjGlbmvhRrjbDle2rrvqSl8X0YLdG/
16+JvxmMy1e+0wSmDZFczF2993l048RCXE87Efnk2kitUzxieP2tCRTRQIkt6Byx
Lor1AvlGGLkpyhhyhjo58dSEqIiohQ==
=howJ
-----END PGP SIGNATURE-----

--Sig_/LbUHl=Yx3gwlgcoK8Ghzpoc--

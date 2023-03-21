Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839756C3DC3
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 23:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjCUWfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 18:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjCUWfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 18:35:41 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFECC4FF12;
        Tue, 21 Mar 2023 15:35:38 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Ph5z92Rq0z4x5Q;
        Wed, 22 Mar 2023 09:35:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1679438134;
        bh=/oDjCLpZZAo6+0F2381aoQIUh5MDRhNocNFZnrdqGqY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kzj7c6Y0Vuw4W+vizDAhLW72UBFu20lLTMoPgDcyTIPe57J+s/AOcdjHI+pQ4sgyY
         i6wEHNOZ1vg/DIcf+JDDlpf9WzcOLi6qcffpvYktugJOmkqiNw6Kmka/MXD0B5ub/0
         CM9ogGIlMdY0bBjj05W5Tl/vjzIe/P/hpiu7wJvAb+AV9Ec3bdUbkDxOi8PyokrHwH
         m9NzVPAwFRzz+jDRGi3sR5WIrIVaWnCVazQhOmHcAPZKflHUMOtaccE3E0f/PWAx5f
         sEbNCLBoS9IlPJ4tYbWC3IOGiIUkWMI+O7eLx9HoRj4gQrrCjlQ+fNtTYcsAzxYLJI
         frIq6UcrLLsyQ==
Date:   Wed, 22 Mar 2023 09:35:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20230322093531.7ac8d09e@canb.auug.org.au>
In-Reply-To: <dca3f426-e3de-207b-51a0-ae272d2b1462@intel.com>
References: <20230320102619.05b80a98@canb.auug.org.au>
        <dca3f426-e3de-207b-51a0-ae272d2b1462@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/0+Um03NOXGSe94ZRNB+vyNz";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/0+Um03NOXGSe94ZRNB+vyNz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 20 Mar 2023 13:07:23 +0100 Alexander Lobakin <aleksander.lobakin@in=
tel.com> wrote:
>
> > After merging the bpf-next tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >=20
> > net/bpf/test_run.c: In function 'frame_was_changed':
> > net/bpf/test_run.c:224:22: error: 'const struct xdp_page_head' has no m=
ember named 'frm'; did you mean 'frame'?
> >   224 |         return head->frm.data !=3D head->orig_ctx.data ||
> >       |                      ^~~
> >       |                      frame
> > net/bpf/test_run.c:225:22: error: 'const struct xdp_page_head' has no m=
ember named 'frm'; did you mean 'frame'?
> >   225 |                head->frm.flags !=3D head->orig_ctx.flags;
> >       |                      ^~~
> >       |                      frame =20
>=20
> The correct solution is to change `frm.` with `frame->`, but I hope the
> BPF maintainers will merge bpf into bpf-next to pick up fixes and
> changes like this :)

Well, that hasn't happened yet, so I will apply the following patch
until it does.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 22 Mar 2023 09:20:26 +1100
Subject: [PATCH] bpf, test_run: fix up for "bpf, test_run: fix &xdp_frame m=
isplacement for LIVE_FRAMES"

ineracting with commit

  e5995bc7e2ba ("bpf, test_run: fix crashes due to XDP frame overwriting/co=
rruption")

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/bpf/test_run.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index af5804d6bff2..c2bab8e20406 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -221,8 +221,8 @@ static bool frame_was_changed(const struct xdp_page_hea=
d *head)
 	 * i.e. has the highest chances to be overwritten. If those two are
 	 * untouched, it's most likely safe to skip the context reset.
 	 */
-	return head->frm.data !=3D head->orig_ctx.data ||
-	       head->frm.flags !=3D head->orig_ctx.flags;
+	return head->frame->data !=3D head->orig_ctx.data ||
+	       head->frame->flags !=3D head->orig_ctx.flags;
 }
=20
 static bool ctx_was_changed(struct xdp_page_head *head)
--=20
2.39.2

--=20
Cheers,
Stephen Rothwell

--Sig_/0+Um03NOXGSe94ZRNB+vyNz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQaMTMACgkQAVBC80lX
0GwS0gf9Er4xVfO0Mlc8mXSX3iApdbtqop58WwP3iKtf+iVbNohzo5aPacIRNZUg
FX6hxwG5qAGOjt6mRtadnWfPjGmXTI26SSd9hu3WGQaUtEOPCBY38KiNinkyA7Am
lRZBQQ9tK1YiRJqOsJPICk2tPNyFoHk9/tVBZWR0RZscEybkIK/4ZrNZ8pej4lmK
CwCMdTAvJSU8To0TaRubx3RNZKgzyTY91svpJqP3SyzmsdIpCrMezA7yEsKPAnLV
vWkUJyS3fHUtLG82Vn1Xo2xxkzACs0prFfe9NTsU8IdF0/dRCJjPlnZNoOg0Y/5U
Efbz1rpDfapBNm9DhYykJWKkUvnesg==
=1KkB
-----END PGP SIGNATURE-----

--Sig_/0+Um03NOXGSe94ZRNB+vyNz--

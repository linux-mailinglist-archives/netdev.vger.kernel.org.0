Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4D9552F1
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 17:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731615AbfFYPIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 11:08:40 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:47238 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730607AbfFYPIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 11:08:39 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id D192272CC58;
        Tue, 25 Jun 2019 18:08:35 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id B92A17CCE32; Tue, 25 Jun 2019 18:08:35 +0300 (MSK)
Date:   Tue, 25 Jun 2019 18:08:35 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] bpf: fix uapi bpf_prog_info fields alignment
Message-ID: <20190625150835.GA24947@altlinux.org>
References: <a5fb2545a0cf151bc443efa10c16c5a4de6f2670.1561460681.git.baruch@tkos.co.il>
 <CAADnVQJ3MPVCL-0x2gDYbUQsrmu8WipnisqXoU8ja4vZ-5nTmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <CAADnVQJ3MPVCL-0x2gDYbUQsrmu8WipnisqXoU8ja4vZ-5nTmA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2019 at 07:16:55AM -0700, Alexei Starovoitov wrote:
> On Tue, Jun 25, 2019 at 4:07 AM Baruch Siach <baruch@tkos.co.il> wrote:
> >
> > Merge commit 1c8c5a9d38f60 ("Merge
> > git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next") undid the
> > fix from commit 36f9814a494 ("bpf: fix uapi hole for 32 bit compat
> > applications") by taking the gpl_compatible 1-bit field definition from
> > commit b85fab0e67b162 ("bpf: Add gpl_compatible flag to struct
> > bpf_prog_info") as is. That breaks architectures with 16-bit alignment
> > like m68k. Embed gpl_compatible into an anonymous union with 32-bit pad
> > member to restore alignment of following fields.
> >
> > Thanks to Dmitry V. Levin his analysis of this bug history.
> >
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> > v2:
> > Use anonymous union with pad to make it less likely to break again in
> > the future.
> > ---
> >  include/uapi/linux/bpf.h       | 5 ++++-
> >  tools/include/uapi/linux/bpf.h | 5 ++++-
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index a8b823c30b43..766eae02d7ae 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3142,7 +3142,10 @@ struct bpf_prog_info {
> >         __aligned_u64 map_ids;
> >         char name[BPF_OBJ_NAME_LEN];
> >         __u32 ifindex;
> > -       __u32 gpl_compatible:1;
> > +       union {
> > +               __u32 gpl_compatible:1;
> > +               __u32 pad;
> > +       };
>=20
> Nack for the reasons explained in the previous thread
> on the same subject.
> Why cannot you go with earlier suggestion of _u32 :31; ?

By the way, why not use aligned types as suggested by Geert?
They are already used for other members of struct bpf_prog_info anyway.

FWIW, we use aligned types for bpf in strace and that approach
proved to be more robust than manual padding.


--=20
ldv

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJdEjjzAAoJEAVFT+BVnCUIuHUQAJ9poEDISeOsjNm0n+eD6K1e
5I13q9FzXE4iUdjLPEWb3O5dzkyM9YE135XEnlFPtUglph8Wx+JH50ojDwan1XpV
EyyQXsD9xjS2ObrdTatz+vgib70F3kiM6Jzu2PQUt19O3UeVcrHCL2tpyvMLrTKA
upgleX5wCUHSDKUfyHjs1vpHyGI8OWwck6l+77HTq+Yemle/fS9VRFy3gGy9Lnub
V9Jo3u8Tc2oPphM05a0jtzLbQ4KEQEMJLbCVudgf/SlQmQvxnC+XLeyzfnVufy/T
jUIWzT4rmBAG1zuvD3nvtDK+jrBMo2yk5113gt/+zT1k0LbuFSNaohZ+QjYLelBQ
qXAuQD8KdpkjGw8Vdm9M3Scj/9m6KGsYsgbaymyaiBiZeWUaME/Z2ll85VnbByXP
jrJ/KBI1XQ/ithVXUf+Xy2nKExM0r5f+XxMF637bTCQroqe1V79olG5A3YTg1Mnh
CLWMIAZU3JxDLiYQZKuGvVcZS3S1Fxb7HHsTskOdHnxGXkoIyXgi/n3SQiKiNcaf
GvEVZLUvIpx+gwsbficp79fXEflv+xfsPj7kys7EJN/qm69Z2wy8VuitIbxIGgDw
dt8A6SUbV0pOPZsQWdrSbsVK0saanvqygeDOjaQhFylpahHwUMEVMZuwjtUVsHx3
9IYQwUmNwDM8PTTeZwUF
=QbMx
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--

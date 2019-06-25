Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BA355387
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 17:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732338AbfFYPgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 11:36:32 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:46954 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730385AbfFYPgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 11:36:32 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id E9C3972CC6C;
        Tue, 25 Jun 2019 18:36:29 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id C5DAF7CCE32; Tue, 25 Jun 2019 18:36:29 +0300 (MSK)
Date:   Tue, 25 Jun 2019 18:36:29 +0300
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
Message-ID: <20190625153629.GB24947@altlinux.org>
References: <a5fb2545a0cf151bc443efa10c16c5a4de6f2670.1561460681.git.baruch@tkos.co.il>
 <CAADnVQJ3MPVCL-0x2gDYbUQsrmu8WipnisqXoU8ja4vZ-5nTmA@mail.gmail.com>
 <20190625150835.GA24947@altlinux.org>
 <CAADnVQJNLk7tAHRHr7V7ugvCX9iCjaH4_vS9YuNWcMpwnA6ZyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <CAADnVQJNLk7tAHRHr7V7ugvCX9iCjaH4_vS9YuNWcMpwnA6ZyA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2019 at 08:19:35AM -0700, Alexei Starovoitov wrote:
> On Tue, Jun 25, 2019 at 8:08 AM Dmitry V. Levin <ldv@altlinux.org> wrote:
> > On Tue, Jun 25, 2019 at 07:16:55AM -0700, Alexei Starovoitov wrote:
> > > On Tue, Jun 25, 2019 at 4:07 AM Baruch Siach <baruch@tkos.co.il> wrot=
e:
> > > >
> > > > Merge commit 1c8c5a9d38f60 ("Merge
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next") undi=
d the
> > > > fix from commit 36f9814a494 ("bpf: fix uapi hole for 32 bit compat
> > > > applications") by taking the gpl_compatible 1-bit field definition =
=66rom
> > > > commit b85fab0e67b162 ("bpf: Add gpl_compatible flag to struct
> > > > bpf_prog_info") as is. That breaks architectures with 16-bit alignm=
ent
> > > > like m68k. Embed gpl_compatible into an anonymous union with 32-bit=
 pad
> > > > member to restore alignment of following fields.
> > > >
> > > > Thanks to Dmitry V. Levin his analysis of this bug history.
> > > >
> > > > Cc: Jiri Olsa <jolsa@kernel.org>
> > > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > > > ---
> > > > v2:
> > > > Use anonymous union with pad to make it less likely to break again =
in
> > > > the future.
> > > > ---
> > > >  include/uapi/linux/bpf.h       | 5 ++++-
> > > >  tools/include/uapi/linux/bpf.h | 5 ++++-
> > > >  2 files changed, 8 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index a8b823c30b43..766eae02d7ae 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -3142,7 +3142,10 @@ struct bpf_prog_info {
> > > >         __aligned_u64 map_ids;
> > > >         char name[BPF_OBJ_NAME_LEN];
> > > >         __u32 ifindex;
> > > > -       __u32 gpl_compatible:1;
> > > > +       union {
> > > > +               __u32 gpl_compatible:1;
> > > > +               __u32 pad;
> > > > +       };
> > >
> > > Nack for the reasons explained in the previous thread
> > > on the same subject.
> > > Why cannot you go with earlier suggestion of _u32 :31; ?
> >
> > By the way, why not use aligned types as suggested by Geert?
> > They are already used for other members of struct bpf_prog_info anyway.
> >
> > FWIW, we use aligned types for bpf in strace and that approach
> > proved to be more robust than manual padding.
>=20
> because __aligned_u64 is used for pointers.

Does the fact that __aligned_u64 is used for pointers mean that
__aligned_u64 should not be used for anything but pointers?


--=20
ldv

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJdEj99AAoJEAVFT+BVnCUIWaMQAMugE0lSCzosjpHwkfbr+FpO
ugG0z+9qdFGMvSWEQp6J7GI+1T/9053u/LoXnmZa3Ax9dOuoiPL/LUnfdlkaZUTb
CRiMMZrxS815klWYdjCsoUxI4uIkMGIeAV55zmL38GnNkQkqUBWNZ2DreXMKqJbL
R6thXTIX0NWZX8gTp9u3Cl7kGzn/rbyM8h3QhfHplIIyZtN0H+Xxrf45GtRWYIiJ
EA13Cha2jnzv+U0ibPp73x424JPSgXwDEXs9TCSzmBN3F/Wa8HB2ZkG5mZeXKTpO
qdCSlmDQeAh/X9swdoXnMdi955V004q7i9p662G1hyOdYCA+uVXbvm5UpqVB9gTG
aO0K7fXyKgXAvebHTbacvVVyw9QyY0uQ/LFUGmJHOtp9z9qGrRy22kG99sWxbno3
L6HzmIS8Uj47yUqGp4Lnad8djAr7K0hQB0dONaBoSY15DwL+iyXvs+BCATajcwz8
yVMEk/MnoBpC5d06AH0AOlxNimCcxxKJC3c/70xQo/XzlddHlzcZunlOHMoMeRZc
U3PkP04kXzsL3sVlWW6uGz21PtEe1BRI26Q118VMf6UMRH0x7Hiq5FQLqpueVJ4Y
JxFtJu1gEzbeL0I4+2LAJ/Cobgx/C369Haq9ey3/xtVpEMAv4GUomL94v7W06F4h
7d5nX5YZ/O5OpF8f+nz7
=nTPx
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--

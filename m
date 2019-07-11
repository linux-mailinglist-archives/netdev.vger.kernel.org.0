Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3B065657
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 14:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbfGKMEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 08:04:30 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37756 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728349AbfGKMEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 08:04:30 -0400
Received: by mail-lf1-f66.google.com with SMTP id c9so3888570lfh.4
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 05:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fIJT5H6LYisrbd6vwnAbhttHQR+HPbOb2XK62GqS1Hw=;
        b=MHpOZCKskoCvtbYHgam0V9As0k81++UdVULTKLpyLcH1oU0/shthaJcSS97lvqKcN0
         TZnB01QXcJlzmc3x0nZeh8A2YzQl6Q2zoct2ZDuOh5d3Waced04J6SZh7moU0lKXgPRj
         +6l+dCjwuoSz/iS3VYY953WTyZ9VZlCvXCvvY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fIJT5H6LYisrbd6vwnAbhttHQR+HPbOb2XK62GqS1Hw=;
        b=YEbJ11XRKBR2wscC/tfJaRCtKAQtiLlofYM2YQdrR5mTNGMH836uz7/w62kN5pKWNs
         a9+hUZYUMMzQJxP6erMciCkkfrWOm4yD85A8+d20gFt+gMznDi9+Lo4M7EVAMnkcPjI7
         MYPI/vuXXv9t9aYCeXruZLFt17gDpLpOnMT8cR5B2hFoXd5IfrMH47XsNl/qJfYpcq3a
         cgf0OGeLkHi6NkI1k49QkkqkAQAhqyFkLqjGqVp5+hm6x/mV1Ezykz4xXQFv86fxs2Da
         UUJQbZhaLUuJBgelKtMnYl0dL6szCWLi35YHIXn+iTbVq818uucdn9VXJkcpyZjkAm8z
         OrIg==
X-Gm-Message-State: APjAAAVxPomuExVCvc8YcdCRLsnU+0XfgDHMQOxS1e83rwsR50b4vPW4
        t/ki+Npwz63suGHL/nSns+yDzOhncMGJR6JtDna6HQ==
X-Google-Smtp-Source: APXvYqyp6HAj1kmAl16bL6nUdA74Usn2n5AVINcaqQABnMYNCnKpl0eo7NEGHvenOcxj4U35c+eZBEfsaPQlyc4rVQ4=
X-Received: by 2002:ac2:47fa:: with SMTP id b26mr1661369lfp.82.1562846668240;
 Thu, 11 Jul 2019 05:04:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-3-krzesimir@kinvolk.io>
 <CAEf4BzYra9njHOB8t6kxRu6n5NJdjjAG541OLt8ci=0zbbcUSg@mail.gmail.com>
In-Reply-To: <CAEf4BzYra9njHOB8t6kxRu6n5NJdjjAG541OLt8ci=0zbbcUSg@mail.gmail.com>
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
Date:   Thu, 11 Jul 2019 14:04:17 +0200
Message-ID: <CAGGp+cGnEBFoPAuhTPa_JFCW6Vbjp2NN0ZPqC3qGfWEXwTyVOQ@mail.gmail.com>
Subject: Re: [bpf-next v3 02/12] selftests/bpf: Avoid a clobbering of errno
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 1:52 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wro=
te:
> >
> > Save errno right after bpf_prog_test_run returns, so we later check
> > the error code actually set by bpf_prog_test_run, not by some libcap
> > function.
> >
> > Changes since v1:
> > - Fix the "Fixes:" tag to mention actual commit that introduced the
> >   bug
> >
> > Changes since v2:
> > - Move the declaration so it fits the reverse christmas tree style.
> >
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Fixes: 832c6f2c29ec ("bpf: test make sure to run unpriv test cases in t=
est_verifier")
> > Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> > ---
> >  tools/testing/selftests/bpf/test_verifier.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testin=
g/selftests/bpf/test_verifier.c
> > index b8d065623ead..3fe126e0083b 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -823,16 +823,18 @@ static int do_prog_test_run(int fd_prog, bool unp=
riv, uint32_t expected_val,
> >         __u8 tmp[TEST_DATA_LEN << 2];
> >         __u32 size_tmp =3D sizeof(tmp);
> >         uint32_t retval;
> > +       int saved_errno;
> >         int err;
> >
> >         if (unpriv)
> >                 set_admin(true);
> >         err =3D bpf_prog_test_run(fd_prog, 1, data, size_data,
> >                                 tmp, &size_tmp, &retval, NULL);
>
> Given err is either 0 or -1, how about instead making err useful right
> here without extra variable?
>
> if (bpf_prog_test_run(...))
>         err =3D errno;

I change it later to bpf_prog_test_run_xattr, which can also return
-EINVAL and then errno is not set. But this one probably should not be
triggered by the test code. So not sure, probably would be better to
keep it as is for consistency?

>
> > +       saved_errno =3D errno;
> >         if (unpriv)
> >                 set_admin(false);
> >         if (err) {
> > -               switch (errno) {
> > +               switch (saved_errno) {
> >                 case 524/*ENOTSUPP*/:
>
> ENOTSUPP is defined in include/linux/errno.h, is there any problem
> with using this in selftests?

I just used whatever there was earlier. Seems like <linux/errno.h> is
not copied to tools include directory.

>
> >                         printf("Did not run the program (not supported)=
 ");
> >                         return 0;
> > --
> > 2.20.1
> >



--=20
Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iago L=
=C3=B3pez Galeiras
Registergericht/Court of registration: Amtsgericht Charlottenburg
Registernummer/Registration number: HRB 171414 B
Ust-ID-Nummer/VAT ID number: DE302207000

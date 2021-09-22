Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717004152EF
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 23:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238145AbhIVVkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 17:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238014AbhIVVj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 17:39:59 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359D7C061574;
        Wed, 22 Sep 2021 14:38:29 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id 194so14620644qkj.11;
        Wed, 22 Sep 2021 14:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SyV2g5p70F83n1ov3tdAnjFS5uqWP0e/z7OmVWJ4YF0=;
        b=YLph8sggXPL2HO8cbP21P7mEISpUU/+t5OMfhTcTkCO77moRFs0NWN03iL93RNBw43
         Z4dz2A4SHW0fh2j7YwvQDcal2u8ITQpHJmCykR+kg6+RiOPo4//4ERENWI6tlUNiV+GO
         vgDVkdtw347M4i4IM4hEiG1/qV3kzni5GKkqc3IfHT9ApgE+6hNo5njdRSVhjCW6tBH4
         8KHEjAjVTxNSya2pktlFk05Yxdn7YO/Kk/o3K5whITdekyzN0FbsbcPkbK70SkNoTceE
         f9Ok8o/yXsECSeInNtLkDh0xkMZ5sclAUYr8oKShcGvXZmAoqgV0OgV+JsOW5GExGDR0
         ZHAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SyV2g5p70F83n1ov3tdAnjFS5uqWP0e/z7OmVWJ4YF0=;
        b=GGkbNMThJotaXSWo+vWQdp9iJ4jWdipSzBncTnBwIlrPa4BIwAyuRGyF1EwsdYxNxf
         Gcn9FkvNUH5I4qHT2yf02b3jpkOwn2UPgcX4YH8Npsf4Eo/qptJ/81bnH/kWauoO2AqC
         uCNH/OtjTk6iJZZ7RtD6BVMNhOxLIJ67Tc0ZmFDHCyMHiiJkcvlQ5RkfbWCXb4ss/h6X
         q8xeXpF/jlJLgULAXnGjnEB9m327IeprdnQiiGKFKs2yinUfOXmSR/Ngy+/F9RE+TO2l
         PrLT/+ZuTYocWalHqcFu4+EvSF4hgesLeN0p57S0HMAq+cA5LOaHvsSCmwtIw8F/v58I
         hppg==
X-Gm-Message-State: AOAM532PhiMY4SW4wqyHRe1MI44GMxzhGR8r0aPCd+XHTR6Do6KvbEt3
        QI7UPtnZrnAKmsW/50oAMtNG5Q8nRjDpxPOTduQ=
X-Google-Smtp-Source: ABdhPJxThtwWJQZf+8T0KS8tQIVhRt0ddybxUdQ8e2uttYAC0sPXi/ZoM1kXstfhp/efqz0UU76Wr5wGzfc60hFScYM=
X-Received: by 2002:a25:47c4:: with SMTP id u187mr1644370yba.225.1632346708354;
 Wed, 22 Sep 2021 14:38:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210922070748.21614-1-falakreyaz@gmail.com> <ef0f23d0-456a-70b0-1ef9-2615a5528278@iogearbox.net>
In-Reply-To: <ef0f23d0-456a-70b0-1ef9-2615a5528278@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 Sep 2021 14:38:17 -0700
Message-ID: <CAEf4Bza6Bsee1i_ypbDogG5MsVFGW9pnatxHCn9PycW9eP2Gkw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: Use sysconf to simplify libbpf_num_possible_cpus
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Muhammad Falak R Wani <falakreyaz@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 2:22 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 9/22/21 9:07 AM, Muhammad Falak R Wani wrote:
> > Simplify libbpf_num_possible_cpus by using sysconf(_SC_NPROCESSORS_CONF)
> > instead of parsing a file.
> > This patch is a part ([0]) of libbpf-1.0 milestone.
> >
> > [0] Closes: https://github.com/libbpf/libbpf/issues/383
> >
> > Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> > ---
> >   tools/lib/bpf/libbpf.c | 17 ++++-------------
> >   1 file changed, 4 insertions(+), 13 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index ef5db34bf913..f1c0abe5b58d 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -10898,25 +10898,16 @@ int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz)
> >
> >   int libbpf_num_possible_cpus(void)
> >   {
> > -     static const char *fcpu = "/sys/devices/system/cpu/possible";
> >       static int cpus;
> > -     int err, n, i, tmp_cpus;
> > -     bool *mask;
> > +     int tmp_cpus;
> >
> >       tmp_cpus = READ_ONCE(cpus);
> >       if (tmp_cpus > 0)
> >               return tmp_cpus;
> >
> > -     err = parse_cpu_mask_file(fcpu, &mask, &n);
> > -     if (err)
> > -             return libbpf_err(err);
> > -
> > -     tmp_cpus = 0;
> > -     for (i = 0; i < n; i++) {
> > -             if (mask[i])
> > -                     tmp_cpus++;
> > -     }
> > -     free(mask);
> > +     tmp_cpus = sysconf(_SC_NPROCESSORS_CONF);
> > +     if (tmp_cpus < 1)
> > +             return libbpf_err(-EINVAL);
>
> This approach is unfortunately broken, see also commit e00c7b216f34 ("bpf: fix
> multiple issues in selftest suite and samples") for more details:

Oh, that predates me. Thanks, Daniel!

Sorry, Muhammad, seems like current implementation is there for a
reason and will have to stay. Thanks a lot for working on this,
though. Hopefully you can help with other issues, though.

[...]

>
> Thanks,
> Daniel
>
> >       WRITE_ONCE(cpus, tmp_cpus);
> >       return tmp_cpus;
> >
>

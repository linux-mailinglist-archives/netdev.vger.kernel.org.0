Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857845141A9
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 07:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238115AbiD2FDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 01:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbiD2FDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 01:03:46 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95C82B19B;
        Thu, 28 Apr 2022 22:00:29 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id f2so8407089ioh.7;
        Thu, 28 Apr 2022 22:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TP9FOM/MARt2Tvknd5/CbQC+6EmkUZ/cjkfr5a5DNsM=;
        b=p1RIC0UWdZbUky9WniEr1CIS+0mf7VJfeHzT+2KRXkz7q5BMIyhW5itqZZMW4WmmL4
         Oj+XOM4135a3zZX70YKL0vYcyerHCnnB35dmRnB5zNW1B2Inpo+86CQQm9qna1H4cOiE
         OaSVkqPajU7HJmUNk6ghdIvYyCev6nE/VZOJ4a2m8ic14ecqK2hfyxHdIHrjP2spBLlZ
         sphfaChR1Sg9C5wuMCYxYUQOp/R7Y2zP0gqD4jwAC3Eop4AN1fv0SIT3b6UMohT1WHHo
         nUAeRSm3U8pnwoJB2IEaveZG3wT8AOQBTBfWPRKfycV3BkklZRMB/7zLriDz3uTmSiQv
         38gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TP9FOM/MARt2Tvknd5/CbQC+6EmkUZ/cjkfr5a5DNsM=;
        b=XTvx0a1xHsRIZTpx8Cmx9Tw4owGNJsdHMLjnu8q+wl8gQk+vc5lDNnFN7XShiRMY0F
         bCIu93yBg5x4tRHjk2ndxepaAZCNV6sX4FmHyPFie3AOT+FGGXVwakZIpwK8UPSAeXVB
         tt1Teqtd3GExfcEcGdik8eAv7PTAqgmTqY5OoTcZ8maGI6I78s6Kc/S2za4kBhZAXir+
         WQKO0o73Cw5LcsGrGZncZr2csz2eQiBFAeTLrc8G7qPzdu1a/jW+NUlnbAEJIyS/uCJT
         d+k8NUnwU2zG5bIhokagZ0rsC4x0qmcrDUKyW+RiDxTABq1ApUxzuksMqcLC7ol8EjoD
         Lwcw==
X-Gm-Message-State: AOAM532XB5uG6nIqsVTXkt/z18XIqO8Mliob+VkBTnduazxdNT2cFVP9
        W1hNr7geToIRYbVoeErrP5XjY9PmpBpyZzB+oBMJYIrB
X-Google-Smtp-Source: ABdhPJw6JoY6N1xDE8Mhbo4JlMICliV45qHxlEK18ALycRMIucAgUFPgQERPtWx+BgZ5hS/GS5ps19tBS6EoEG1RUPs=
X-Received: by 2002:a5d:9316:0:b0:657:a364:ceb with SMTP id
 l22-20020a5d9316000000b00657a3640cebmr6772620ion.63.1651208429196; Thu, 28
 Apr 2022 22:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220428111442.111805-1-larysa.zaremba@intel.com> <b464eae7-2f4d-bb5e-f229-6c95dab774fb@iogearbox.net>
In-Reply-To: <b464eae7-2f4d-bb5e-f229-6c95dab774fb@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 Apr 2022 22:00:18 -0700
Message-ID: <CAEf4BzZWTpZJqUTxPFcMuN+EEQ1S0c1NNNSYtZF19qhB6hwAfQ@mail.gmail.com>
Subject: Re: [PATCH RESEND bpf-next] bpftool: Use sysfs vmlinux when dumping
 BTF by ID
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Larysa Zaremba <larysa.zaremba@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 8:17 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 4/28/22 1:14 PM, Larysa Zaremba wrote:
> > Currently, dumping almost all BTFs specified by id requires
> > using the -B option to pass the base BTF. For most cases
> > the vmlinux BTF sysfs path should work.
> >
> > This patch simplifies dumping by ID usage by attempting to
> > use vmlinux BTF from sysfs, if the first try of loading BTF by ID
> > fails with certain conditions.
> >
> > Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> > Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> > ---
> >   tools/bpf/bpftool/btf.c | 35 ++++++++++++++++++++++++++---------
> >   1 file changed, 26 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> > index a2c665beda87..557f65e2de5c 100644
> > --- a/tools/bpf/bpftool/btf.c
> > +++ b/tools/bpf/bpftool/btf.c
> > @@ -459,6 +459,22 @@ static int dump_btf_c(const struct btf *btf,
> >       return err;
> >   }
> >
> > +static const char sysfs_vmlinux[] = "/sys/kernel/btf/vmlinux";
> > +
> > +static struct btf *get_vmlinux_btf_from_sysfs(void)
> > +{
> > +     struct btf *base;
> > +
> > +     base = btf__parse(sysfs_vmlinux, NULL);
> > +     if (libbpf_get_error(base)) {
> > +             p_err("failed to parse vmlinux BTF at '%s': %ld\n",
> > +                   sysfs_vmlinux, libbpf_get_error(base));
> > +             base = NULL;
> > +     }
>
> Could we reuse libbpf's btf__load_vmlinux_btf() which probes well-known
> locations?

Systems that don't have /sys/kernel/btf/vmlinux exposed definitely
don't support base BTF, so there is no point in trying to find vmlinux
BTF anywhere else (which is only necessary for old kernels). So I
think it should be fine as is, except we shouldn't guess when base BTF
is needed, it should always be for kernel module BTFs only.

>
> > +     return base;
> > +}
> > +
> >   static int do_dump(int argc, char **argv)
> >   {
> >       struct btf *btf = NULL, *base = NULL;
> > @@ -536,18 +552,11 @@ static int do_dump(int argc, char **argv)
> >               NEXT_ARG();
> >       } else if (is_prefix(src, "file")) {
> >               const char sysfs_prefix[] = "/sys/kernel/btf/";
> > -             const char sysfs_vmlinux[] = "/sys/kernel/btf/vmlinux";
> >
> >               if (!base_btf &&
> >                   strncmp(*argv, sysfs_prefix, sizeof(sysfs_prefix) - 1) == 0 &&
> > -                 strcmp(*argv, sysfs_vmlinux) != 0) {
> > -                     base = btf__parse(sysfs_vmlinux, NULL);
> > -                     if (libbpf_get_error(base)) {
> > -                             p_err("failed to parse vmlinux BTF at '%s': %ld\n",
> > -                                   sysfs_vmlinux, libbpf_get_error(base));
> > -                             base = NULL;
> > -                     }
> > -             }
> > +                 strcmp(*argv, sysfs_vmlinux))
> > +                     base = get_vmlinux_btf_from_sysfs();
> >
> >               btf = btf__parse_split(*argv, base ?: base_btf);
> >               err = libbpf_get_error(btf);
> > @@ -593,6 +602,14 @@ static int do_dump(int argc, char **argv)
> >       if (!btf) {
> >               btf = btf__load_from_kernel_by_id_split(btf_id, base_btf);
> >               err = libbpf_get_error(btf);
> > +             if (err == -EINVAL && !base_btf) {
> > +                     btf__free(base);
> > +                     base = get_vmlinux_btf_from_sysfs();
> > +                     p_info("Warning: valid base BTF was not specified with -B option, falling back on standard base BTF (sysfs vmlinux)");
> > +                     btf = btf__load_from_kernel_by_id_split(btf_id, base);
> > +                     err = libbpf_get_error(btf);
> > +             }
> > +
> >               if (err) {
> >                       p_err("get btf by id (%u): %s", btf_id, strerror(err));
> >                       goto done;
> >
>

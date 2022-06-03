Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5436F53D311
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 23:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348102AbiFCVDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 17:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiFCVDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 17:03:20 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC051C938;
        Fri,  3 Jun 2022 14:03:19 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id m25so6353852lji.11;
        Fri, 03 Jun 2022 14:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=opFA97GGrUrFUT9SvfZGm6iux5I1umYstFz0GJmvO1s=;
        b=jOMm80if0JHj8ErxTGfdh03GdgfvdFKd6Rm1alGSNt5XLLhAvf+YxjFXlBjrOPM+IH
         Bqw7cj6W6JWPuTAHSqT8gS9wHeRaefNGImH/RqKb2oufhCm81PGpOqFMpqe2tNbHIm0J
         7zlfwHc8fYGAs/0Ckmg+fGFHk05ZmM4j08cerriR96KFSyR04OgiYMva6Mp2mHLqLMfS
         j//3vwk/QUFUaP7pn0C3CHL9FMbRoL8KozrVyh9d60Dj1+/BpipN+SD6BOoCXt85vwql
         i+uKT08GonypnGrT7ceT0R5CYHMyfes2Oxln2HFd5Ag3DlumcUWfuaI4Jc1agK7EbgdW
         4tSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=opFA97GGrUrFUT9SvfZGm6iux5I1umYstFz0GJmvO1s=;
        b=3RR4+ud4uuGzRwN+mHl8tYSNDJwJQpQYNO+dqwJWZpj1rSx7e673LhNXx+hd0OxVcL
         a5vSLsoOiPtz4G81iCRohwBU+mAUvLDSxMUW9+WFke7w7pfYHMfwft6CbQVQr64CVh4E
         E3jQsVVHQj1j/KQeZZ26BiE03Jdd0Z4mxF7Z0hNm0no6rqA66yG54hcVWjZYMIvfgm6V
         BpmzfM3YHIxtjoY6Gzpx9QPyhXOGtI1WywcHkyADLgAYtQ5vOFJO5R+hlC3PVdz9mK3u
         nKtLwAJ9xQg1cVQsSKJeSkdObzIHgsbMk9YuSUnUpzOiwaIRdAchUEK3vH5vG5CiX26G
         TRlw==
X-Gm-Message-State: AOAM530Cp3qOfktnZs0QVgipBTseqvd6IInkwUhXbGKdzUvs9MxLaIIU
        HNGTUdNHXnZOVlr/bycbcCJnbr1G95BvseVPG/A=
X-Google-Smtp-Source: ABdhPJzmpEZzWq0TOpHSFyPqm8mLnO15YE4hqSuCFi23XZFXNjH9RoA689fYNyTFgdEhQVBfT9Zar6dctkoGXtjQjo8=
X-Received: by 2002:a2e:1f12:0:b0:255:67ae:b655 with SMTP id
 f18-20020a2e1f12000000b0025567aeb655mr10080273ljf.303.1654290197923; Fri, 03
 Jun 2022 14:03:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220530092815.1112406-1-pulehui@huawei.com> <20220530092815.1112406-5-pulehui@huawei.com>
 <a31efed5-a436-49c9-4126-902303df9766@iogearbox.net>
In-Reply-To: <a31efed5-a436-49c9-4126-902303df9766@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 14:03:06 -0700
Message-ID: <CAEf4BzacrRNDDYFR_4GH40+wxff=hCiyxymig6N+NVrM537AAA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/6] libbpf: Unify memory address casting
 operation style
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Pu Lehui <pulehui@huawei.com>, bpf <bpf@vger.kernel.org>,
        linux-riscv@lists.infradead.org,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 2:03 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 5/30/22 11:28 AM, Pu Lehui wrote:
> > The members of bpf_prog_info, which are line_info, jited_line_info,
> > jited_ksyms and jited_func_lens, store u64 address pointed to the
> > corresponding memory regions. Memory addresses are conceptually
> > unsigned, (unsigned long) casting makes more sense, so let's make
> > a change for conceptual uniformity.
> >
> > Signed-off-by: Pu Lehui <pulehui@huawei.com>
> > ---
> >   tools/lib/bpf/bpf_prog_linfo.c | 9 +++++----
> >   1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linfo.c
> > index 5c503096ef43..7beb060d0671 100644
> > --- a/tools/lib/bpf/bpf_prog_linfo.c
> > +++ b/tools/lib/bpf/bpf_prog_linfo.c
> > @@ -127,7 +127,8 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
> >       prog_linfo->raw_linfo = malloc(data_sz);
> >       if (!prog_linfo->raw_linfo)
> >               goto err_free;
> > -     memcpy(prog_linfo->raw_linfo, (void *)(long)info->line_info, data_sz);
> > +     memcpy(prog_linfo->raw_linfo, (void *)(unsigned long)info->line_info,
> > +            data_sz);
>
> Took in patch 1-3, lgtm, thanks! My question around the cleanups in patch 4-6 ...
> there are various other such cases e.g. in libbpf, perhaps makes sense to clean all
> of them up at once and not just the 4 locations in here.

if (void *)(long) pattern is wrong, then I guess the best replacement
should be (void *)(uintptr_t) ?

>
> Thanks,
> Daniel

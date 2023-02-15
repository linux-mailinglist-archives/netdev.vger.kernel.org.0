Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18266974C8
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 04:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbjBODUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 22:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjBODUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 22:20:24 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A940241D6;
        Tue, 14 Feb 2023 19:20:23 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id dr8so44866905ejc.12;
        Tue, 14 Feb 2023 19:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MVTV7J8dNFxFa/D5iy9X5YDRMbmFZSzQ8pjo81gKHQo=;
        b=Et60NALXt1hiBg38fHeOJMzLGMk8qE1QEr1HeBk67urDbk49kIGw0+RTt/wTKbFveE
         DYAKU8LhrqAufzFiA0g44beOI7pbNNoEy9ebDxgn7nM1OZvT5QvjY/j5QBOdUx2vFOIz
         1cXIKZRUUaTNQ6xl+lDmatm0TSBYa+k6aQsawvCkluybZVFDgiqy+Ng/VOkKurtj/D+K
         IpAniTb/ZdRlgd26th1hWdkR78A6RoEFUPnN2YVVtzUsPLF+VakFLkN6U9e7vaN+KsF7
         1JT7LW/UCMPTGYtx/IosvkKgGBetTKLftfxAQ4l2Tu9lk0/XlF/0SNDgZMS8rSimTDSg
         fKGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MVTV7J8dNFxFa/D5iy9X5YDRMbmFZSzQ8pjo81gKHQo=;
        b=3ljY1WgWBHT6qrlRvvLfpmksqOcvDkhNQkjEsX8Jlv/m7mxAqLbXh1JUPd+4BZNj9E
         XJIspra5LZ25Uu3Td4347l5cnc5RIOLPfxwR+6S7PFO3GU8YbSneaY2rMO8SgnzMTUcL
         Y/Ldt9wN5PQ6SGPpJCmngHwcmG8MpetyED9q3cJ/mQGFb0WU6u6Q/tCSuxEz8QxjQdBe
         EKs0f1eLqoFkPS3nP/QSdKPNOm5oQI3br3q3okMiQxRCvNSbQJlidqXpFIAOynt8Lz2k
         W/dmBBMQhLjcINQxiBaCUuvRIKsKpuqmExJgKbe7IUphnxeyheBcQmlClCCpzXef6czT
         lgng==
X-Gm-Message-State: AO0yUKWC3d8jzEMn16XG8oJyfyCJAVTenimnEyW00UbLdJT++frcix1W
        vI7fCGXEYYv8meTbMTYrk0OzsSaradshnuGywSVQOkiRbJY=
X-Google-Smtp-Source: AK7set/CccW0OVkhUL62a/+dY74R81zwPyHhn+FYNX5hOD2OqMauppu9rWASHDXgVNQPxI9RuYgP+B8YdkOD94HoSKk=
X-Received: by 2002:a17:906:bcd5:b0:8ae:9f1e:a1c5 with SMTP id
 lw21-20020a170906bcd500b008ae9f1ea1c5mr346690ejb.3.1676431221799; Tue, 14 Feb
 2023 19:20:21 -0800 (PST)
MIME-Version: 1.0
References: <20230214235051.22938-1-alexei.starovoitov@gmail.com> <Y+xLXcmf1pxl43dn@google.com>
In-Reply-To: <Y+xLXcmf1pxl43dn@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 Feb 2023 19:20:10 -0800
Message-ID: <CAADnVQLCdMMGm1TGDbC5eUSSZWF+-au5cPr1OsKUz=SxM4bnCA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix map_kptr test.
To:     Stanislav Fomichev <sdf@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
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

On Tue, Feb 14, 2023 at 7:02 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On 02/14, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
>
> > The compiler is optimizing out majority of unref_ptr read/writes, so the
> > test
> > wasn't testing much. For example, one could delete '__kptr' tag from
> > 'struct prog_test_ref_kfunc __kptr *unref_ptr;' and the test would
> > still "pass".
>
> > Convert it to volatile stores. Confirmed by comparing bpf asm
> > before/after.
>
> > Fixes: 2cbc469a6fc3 ("selftests/bpf: Add C tests for kptr")
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>
> Acked-by: Stanislav Fomichev <sdf@google.com>
>
> > ---
> >   tools/testing/selftests/bpf/progs/map_kptr.c | 12 +++++++-----
> >   1 file changed, 7 insertions(+), 5 deletions(-)
>
> > diff --git a/tools/testing/selftests/bpf/progs/map_kptr.c
> > b/tools/testing/selftests/bpf/progs/map_kptr.c
> > index eb8217803493..228ec45365a8 100644
> > --- a/tools/testing/selftests/bpf/progs/map_kptr.c
> > +++ b/tools/testing/selftests/bpf/progs/map_kptr.c
> > @@ -62,21 +62,23 @@ extern struct prog_test_ref_kfunc *
> >   bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **p, int a, int
> > b) __ksym;
> >   extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p)
> > __ksym;
>
>
> [..]
>
> > +#define WRITE_ONCE(x, val) ((*(volatile typeof(x) *) &(x)) = (val))
>
> (thinking out loud)
>
> Maybe time for us to put these into some common headers in the
> selftests.
> progs/test_ksyms_btf_null_check.c READ_ONCE as well..

Not quite. There is no READ_ONCE there. Only comment about it :)
But yeah a follow up is necessary, but it's not that simple.
I think it's ok to use WRITE_ONCE here, but
saying it's a generic thing for all bpf programs to use
is not something we can do without defining a BPF memory model.
So it's a whole can of worms that I'd rather not open right now.

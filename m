Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DE344030C
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 21:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhJ2TZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 15:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhJ2TZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 15:25:02 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76F0C061570;
        Fri, 29 Oct 2021 12:22:33 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t7so10761084pgl.9;
        Fri, 29 Oct 2021 12:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AdqiksM5JD7MPWjGC6fxYSJEL+J5tdGKXDFFKZDluhw=;
        b=WhQ3hOIHvrNs8+dZ45XuelU8heL9aHeN7r0glEqlHFL9QwEpR365Tf3+NDQsxiG5dI
         QgWIDIUQ+1YM0zmXvwEnFfuFYLPjcc9PnzHgNSWPRqptnuZpG5vwPft+e0mkZBlt8p7j
         +RQ2cO89NJQfvzOwdmm2AIrdSzC8LPiCbqwMAdEl4mmI3DQJ9yhCrG5nV4qegHVqQk0g
         Dj63Cwt4afc1kunJIk2n0WgGlCcGv9++aKE3fCHRQE5etwLSYgMlEYGhYgbTwaf2VYYz
         iKkufBRL0Rpcq6bVDD2tVZrLsJzM9FE1QUJ/UDTbWR06lokXnb6D6PA4/Vyov4WeasFP
         j2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AdqiksM5JD7MPWjGC6fxYSJEL+J5tdGKXDFFKZDluhw=;
        b=3O4ael2t4IXSUuwJqBThPQtYFmW8QMOcoLpVfBoCGb7ysvUSlsPqF0w5Sea+UQO7M4
         XXc6H74EetbQaeF8Cbibm4NMfJiTqAJF1WjSNQyZ9kZH2kEuDt7gbXJho7UjDa39aSot
         HBzlo1pglI+7x89NlD7kjdF32JkBWsKaiK9mE+iumAp1REkJtp5W4YSOI4uymYLXgjWN
         7bfGIQ/6vEbE5Cm4yism3HDA4/cc65ZXXImznX1RINoEI9LFY7IIYO8wTfTr3+wk5/wK
         ljrX/kCyVhf9Ay4BC9lqGGpvm0U7qOfS0h9ZcljqzeFnrYRvKXhFf6iSaXYerXHR7WPL
         dTsQ==
X-Gm-Message-State: AOAM531eOY0mfBkiqToh7D5Uwk7jlSgu7BA7DCMI3RS3zSGJ+M/pesB3
        kcbbvCJM27UjbvsvdT0do2wT6Ektf1gGnFG13PFUkIe0
X-Google-Smtp-Source: ABdhPJy5t/bNQRKPw4gXY67tjv0CUVsYfdsx9QomMeAb2FoKBQuA7+ZW31NOc91geSea369doAAhcvKnBpzQzVHYNrg=
X-Received: by 2002:a05:6a00:1142:b0:47c:2e92:87a0 with SMTP id
 b2-20020a056a00114200b0047c2e9287a0mr12754626pfm.59.1635535353297; Fri, 29
 Oct 2021 12:22:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211029163102.80290-1-alexei.starovoitov@gmail.com> <2d8df23d-175f-3eb8-3ba4-35659664336c@fb.com>
In-Reply-To: <2d8df23d-175f-3eb8-3ba4-35659664336c@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 29 Oct 2021 12:22:22 -0700
Message-ID: <CAADnVQLvwGMsawF9s3wDw9Gh_HJpCTkHTS=0MHLLy+VqapLUWQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Fix propagation of bounds from 64-bit
 min/max into 32-bit and var_off.
To:     Yonghong Song <yhs@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 11:29 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 10/29/21 9:31 AM, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Before this fix:
> > 166: (b5) if r2 <= 0x1 goto pc+22
> > from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0xffffffff))
> >
> > After this fix:
> > 166: (b5) if r2 <= 0x1 goto pc+22
> > from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0x1))
> >
> > While processing BPF_JLE the reg_set_min_max() would set true_reg->umax_value = 1
> > and call __reg_combine_64_into_32(true_reg).
> >
> > Without the fix it would not pass the condition:
> > if (__reg64_bound_u32(reg->umin_value) && __reg64_bound_u32(reg->umax_value))
> >
> > since umin_value == 0 at this point.
> > Before commit 10bf4e83167c the umin was incorrectly ingored.
> > The commit 10bf4e83167c fixed the correctness issue, but pessimized
> > propagation of 64-bit min max into 32-bit min max and corresponding var_off.
> >
> > Fixes: 10bf4e83167c ("bpf: Fix propagation of 32 bit unsigned bounds from 64 bit bounds")
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>
> See an unrelated nits below.
>
> Acked-by: Yonghong Song <yhs@fb.com>
>
> > ---
> >   kernel/bpf/verifier.c                               | 2 +-
> >   tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
> >   2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 3c8aa7df1773..29671ed49ee8 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -1425,7 +1425,7 @@ static bool __reg64_bound_s32(s64 a)
>
> We have
> static bool __reg64_bound_s32(s64 a)
> {
>          return a > S32_MIN && a < S32_MAX;
> }
>
> Should we change to
>         return a >= S32_MIN && a <= S32_MAX
> ?

Probably, but I haven't investigated that yet.

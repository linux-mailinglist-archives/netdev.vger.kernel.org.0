Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDD9363853
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 00:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbhDRW4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 18:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhDRW4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 18:56:34 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F098C06174A;
        Sun, 18 Apr 2021 15:56:05 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id z13so36021565lfd.9;
        Sun, 18 Apr 2021 15:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JxjfhO2AY1CPT72ISDDMFJ6D6CYExawW3B4Pe3LhqXE=;
        b=SA/94jCZUr1CH3nb/05Kdo7v8LdNWqlE2Ulmw/+bckzo/Wl/YklLeBUXHe20NfVkEz
         84HKRPBryJta+Y9Ic0gQRHPnbPLDD0YREh5B59O4hQCODIQDoEFTH/YY3khcW55ldmHv
         JJzpEiWNX+0TstxlRyKiFV+IGdgpu50EmoaHw/7qbLrL8N5ntcScUMojN1SBGJi4q83X
         mKHDTTwW3GgMfNgzYwWR7qMCtRF4I/njUf5JdQjq7FzkeJE0jkDVjtc201ljDD7+dWdA
         7Q3uYmLVb8zigrwL/VUT3J8u70gUtOubkOkOqBv6h1ivSKScXvq3yecxQeXaT1Cyffll
         revw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JxjfhO2AY1CPT72ISDDMFJ6D6CYExawW3B4Pe3LhqXE=;
        b=skoK5NiDl4i/0sTsGk/6L4sqlUGhOek6x2CEvfUTTBVn9ElzlB+fHrbsPSXHMpEgR5
         7KAVV/3LxtuopBOAljakSz5VIwdLbLFTcS0g2bUsBypnLEZY5WxuWh/BkgswLNuydTV/
         cZtDGeBt9mepmxAcU+oB2xQeI6lB+tcYcxvZ92qhur3HpoRbCg0rJW7gkgE56x29XcUv
         068ykmTlPKKacyHRDecvHCSA4tVauHg5Pqnuc7QC7aptDtt9NaehOsOzn1yIvD0cqdhQ
         pH56/V80Gw2lI6HQf023T//gQg6Guz+lVM2bgKpgbDXCIeL+awGM3JkDnUPgDgshigdt
         wCmw==
X-Gm-Message-State: AOAM532v6ssJJZYd8TWPypERgGZymc6hQPFy7S2CRwLlNTvRlp60muSc
        Ow3OzyKFeEtcXFk+j+OpF6a4w5wEpykVjKA9q68=
X-Google-Smtp-Source: ABdhPJz3J252QmN5dJ/bVBJ6qn9mH0TmeUphfLSV1GMJHlokA5IF8cL1KIOgjlt3jgx7DAzXbTv4DcB9Mj/dhCcN/jQ=
X-Received: by 2002:ac2:510d:: with SMTP id q13mr9423343lfb.75.1618786563281;
 Sun, 18 Apr 2021 15:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210418200249.174835-1-pctammela@mojatatu.com>
In-Reply-To: <20210418200249.174835-1-pctammela@mojatatu.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 18 Apr 2021 15:55:52 -0700
Message-ID: <CAADnVQLJDsnQ1YO9a_pQ-1aTJ1hNKYJXcSHypfzCare-c4HO1A@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix errno code for unsupported batch ops
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 1:03 PM Pedro Tammela <pctammela@gmail.com> wrote:
>
> ENOTSUPP is not a valid userland errno[1], which is annoying for
> userland applications that implement a fallback to iterative, report
> errors via 'strerror()' or both.
>
> The batched ops return this errno whenever an operation
> is not implemented for kernels that implement batched ops.
>
> In older kernels, pre batched ops, it returns EINVAL as the arguments
> are not supported in the syscall.
>
> [1] https://lore.kernel.org/netdev/20200511165319.2251678-1-kuba@kernel.org/
>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  kernel/bpf/syscall.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index fd495190115e..88fe19c0aeb1 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3961,7 +3961,7 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
>  #define BPF_DO_BATCH(fn)                       \
>         do {                                    \
>                 if (!fn) {                      \
> -                       err = -ENOTSUPP;        \
> +                       err = -EOPNOTSUPP;      \

$ git grep EOPNOTSUPP kernel/bpf/|wc -l
11
$ git grep ENOTSUPP kernel/bpf/|wc -l
51

For new code EOPNOTSUPP is better, but I don't think changing all 51 case
is a good idea. Something might depend on it already.

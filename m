Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0538E413DF2
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 01:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhIUXWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 19:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhIUXWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 19:22:19 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5AFC061574;
        Tue, 21 Sep 2021 16:20:50 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id f130so3189604qke.6;
        Tue, 21 Sep 2021 16:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y1TvGa/2v6EnSjxnp0r1HWOSDa8Y16SfdbFLGDrA8LU=;
        b=Wz3TgdYiU7IihXDeb7xvijnbKXH7DTeRZVStGY5+n8K8y4iXFvLk+lBACaoFKbhrmy
         VxZOPA1/3UGFtzvk33yXkPbMsSrfet5adIx2lzY4u+R8Ho9/10yNAc6psE2zWlXsD32k
         WqgdXWUfNkAOIU4hUntBaMrZEeruZcKPMTDjeIaOA6jSI/XQ0vfWkik9FUdKm2spNbQ9
         oZUiwK12Xfmy4BW2Cs1ZhNnf05K35D6OB0QsP1It/gSFtiGkNjg/Iq1vEDJ97RAlwOEz
         ZXRXZJ/uPKzcCLqGodVtVRpAg+lYkp72cEH/KXhIsqtRJrJc6NrRqMVBF09mBTXEEdW4
         DDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y1TvGa/2v6EnSjxnp0r1HWOSDa8Y16SfdbFLGDrA8LU=;
        b=8KyNyFlATp59Fstl1WuSRIgqquOs30KuTNXr2jV2qzQsZ2CDC1vYuJFbX51ceC8ogp
         xL7EYdlkEslBJzDRkm60yawxCn/zyRQCySTa/VNhkhr2O0LOvd5jQa3yrhvyaP3T+q4e
         AgvGDcIq2V1JbDBDXps4JAvBRk8S+8cpmOmH+Oo2qVY7NVGgPjHnFvYC6p1fkqMvi2m8
         o/d89NHegqAafRivjBxhExd2UJ5mu39monPZ2N4xPSZXnDWwN9ddgvTP4GoiF+Rv328u
         hKzyT2qdtKq7IrW208HA/nbN519GzXZMZk1QKWXkfYcWPJuN8runW1nO99vJ8TQP9LKX
         Dm1g==
X-Gm-Message-State: AOAM531BNye1m/kRz1ffGhGFCfWnR4/K35FZG32zseRkUQJUOv08b/yE
        YFwSnjUKndGXkW3YgKBNbVzQd2ORa10afM+ZdYrchPlTSwQ=
X-Google-Smtp-Source: ABdhPJyD641W8Uhgu+4BGRpoK+mVhSsO0s9j5J6DcXOd04+J8I20htq0A80NA1VmRrF7QJw8c7D40aOHPXhLLMcdTE8=
X-Received: by 2002:a25:1bc5:: with SMTP id b188mr40964801ybb.267.1632266449664;
 Tue, 21 Sep 2021 16:20:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210921060434.26732-1-falakreyaz@gmail.com>
In-Reply-To: <20210921060434.26732-1-falakreyaz@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Sep 2021 16:20:38 -0700
Message-ID: <CAEf4Bzau7EdBifN_Y_Y3HVs6Mm_UogytTzjXE+vB+W_HTiprmA@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Use sysconf to simplify libbpf_num_possible_cpus
To:     Muhammad Falak R Wani <falakreyaz@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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

On Mon, Sep 20, 2021 at 11:04 PM Muhammad Falak R Wani
<falakreyaz@gmail.com> wrote:
>
> Simplify libbpf_num_possible_cpus by using sysconf(_SC_NPROCESSORS_CONF)
> instead of parsing a file.
> This patch is a part of libbpf-1.0 milestone.
>
> Reference: https://github.com/libbpf/libbpf/issue/383

I've been asking people to use a reference style like this, so that we
don't confuse this with proper Linux tags. It's also useful to use
"Closes: " keyword to let Github auto-close the issue when this patch
eventually is synced into Github. So in this case I'd phrase
everything as:

"This patch is a part ([0]) of libbpf-1.0 milestone.

  [0] Closes: https://github.com/libbpf/libbpf/issue/383

Please update in the next revision.


Also, keep in mind that we ask to use "[PATCH bpf-next]" prefix when
submitting patches against the bpf-next kernel tree. It makes the
intent clear and our BPF CI system knows which tree to test against.
Thanks.

>
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index da65a1666a5e..1d730b08ee44 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10765,25 +10765,15 @@ int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz)
>
>  int libbpf_num_possible_cpus(void)
>  {
> -       static const char *fcpu = "/sys/devices/system/cpu/possible";
>         static int cpus;
> -       int err, n, i, tmp_cpus;
> -       bool *mask;
> +       int tmp_cpus;
>
>         tmp_cpus = READ_ONCE(cpus);
>         if (tmp_cpus > 0)
>                 return tmp_cpus;
>
> -       err = parse_cpu_mask_file(fcpu, &mask, &n);
> -       if (err)
> -               return libbpf_err(err);
> -
> -       tmp_cpus = 0;
> -       for (i = 0; i < n; i++) {
> -               if (mask[i])
> -                       tmp_cpus++;
> -       }
> -       free(mask);
> +       tmp_cpus = sysconf(_SC_NPROCESSORS_CONF);
> +       /* sysconf sets errno; no need to use libbpf_err */

I'd say it's still a good idea for explicitness and to show that we
didn't forget about it :) Plus, if it actually ever fails, we don't
want to WRITE_ONCE() here, so please follow the same error handling
logic as it was previously with parse_cpu_mask_file.

>
>         WRITE_ONCE(cpus, tmp_cpus);
>         return tmp_cpus;
> --
> 2.17.1
>

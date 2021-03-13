Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA48339ADD
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhCMBcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbhCMBb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 20:31:26 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426A3C061574;
        Fri, 12 Mar 2021 17:31:26 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id x19so27298338ybe.0;
        Fri, 12 Mar 2021 17:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DbE3xDkQ8HktwIoRcbeaiX7gfulPHK+RCelzbpG3B1Q=;
        b=ercgs/VoGb+1NneYMOPK67RWCyGd9m3SluCwWbruOrP1Tj+l9ZP9SXWDSnxu9GlwZF
         E//861xmFlN9+hM4D75juWHdYqvfkDr/aInUfIVZ3/7xzk94fGrXoMwvOxU7nh2Iu3fx
         wP8Nvv5u6b5S/wPi9N/HpvsQF5QSRhWYdI0uFhBVelkstJQnRdFOMVTy7cHxGQ5cEUAE
         sT6kg93RUuc3c/dsda4eM2i+xOGaXW9ErpWqxHDksPGF2Q2eHpqQodA4NNkwm99JkL6i
         9aw4KkIFfUwaXxvkyWnxdaZcYtGG4A2KA1vzK2EGVDQMaApjWXGrKs7TqgEJTeBeE/iy
         cz1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DbE3xDkQ8HktwIoRcbeaiX7gfulPHK+RCelzbpG3B1Q=;
        b=bNMVJK+0+57vliMqT0dlV4FhMsOTJ3HpM9H2EPNMnJSDmhWl8FP2/31kZkk561UiFe
         IqIZmSgorFQdoZeT++eIltkB1TlpOr7lw42qOFArRXMosnZr5gwm/8HwMNEdQsTHx+Vr
         Oas9dkNSBy1KF4I7kB3Gnj6w0FEkPruWAYRqtO3EKm/NyS0D6lEEZGOR7Qmo/w0ts5gX
         vxhCidGme6ia9hskjYCY5V0GZ0lr1RmACv9MGSFlxZICKDz16QO7L08bp2ATjSmt6NlG
         IMDiOj6N854J96rGa2dWi0ljtfUYR9Kp/fllv0TbSsgzw03fKzNTJkqoPferLGRWtaSW
         dxeA==
X-Gm-Message-State: AOAM533mos0nAvQrKV+jFcK74Fmmbsxn1x0bW4yAU/2wYdHOW2ev4t4w
        mtOaXy+kEGxrTBrMfL0yxGhfocUTGYmicok3j2M=
X-Google-Smtp-Source: ABdhPJyXeoVxAmgzYIpZodsgYP9/ZjqK8xFD9rRV3LVPrn4FRaPBV/Kq2OLW+gE0m57vvPFM4MOLCcghwuBjcn32Tbo=
X-Received: by 2002:a25:cc13:: with SMTP id l19mr22707860ybf.260.1615599085306;
 Fri, 12 Mar 2021 17:31:25 -0800 (PST)
MIME-Version: 1.0
References: <20210312214316.132993-1-sultan@kerneltoast.com>
In-Reply-To: <20210312214316.132993-1-sultan@kerneltoast.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Mar 2021 17:31:14 -0800
Message-ID: <CAEf4BzYBj254AtZxjMKdJ_yoP9Exvjuyotc8XZ7AUCLFG9iHLQ@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Use the correct fd when attaching to perf events
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 1:43 PM Sultan Alsawaf <sultan@kerneltoast.com> wrote:
>
> From: Sultan Alsawaf <sultan@kerneltoast.com>
>
> We should be using the program fd here, not the perf event fd.

Why? Can you elaborate on what issue you ran into with the current code?

>
> Fixes: 63f2f5ee856ba ("libbpf: add ability to attach/detach BPF program to perf event")
> Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> ---
>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index d43cc3f29dae..3d20d57d4af5 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -9538,7 +9538,7 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
>         if (!link)
>                 return ERR_PTR(-ENOMEM);
>         link->detach = &bpf_link__detach_perf_event;
> -       link->fd = pfd;
> +       link->fd = prog_fd;
>
>         if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, prog_fd) < 0) {
>                 err = -errno;
> --
> 2.30.2
>

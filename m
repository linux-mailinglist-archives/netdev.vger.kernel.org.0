Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E072F3B08
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406850AbhALTre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406756AbhALTre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:47:34 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E62C061795;
        Tue, 12 Jan 2021 11:46:53 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id o144so3301635ybc.0;
        Tue, 12 Jan 2021 11:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=45DA4vH/D9c7gYWc+sPX522gNKfwVRgZeQ5tT9hcRQo=;
        b=iSfEpB6nullBDGHMzkUIL4Mg1xbmNjQ+3ukI2cEAZgRJjEWC2U1lmlzzctiayjmS5I
         FvSdX/eWz+XH/1k4vE7/wm6LOX08RRxWgLhiyZ3ZdMvvyTjnJAol3p4bYvgWvr3bodaQ
         5wFEoMgjHQzdLrgbrTp8BFxMxqnXrdxYRW3K+TbjWKaB8JIk0ca3JiueznIU3kJCJ3GU
         fwHwXrth5BDAT3Rnbpv8g43efKESLp91jk6BuEd9kWbye/XgsI+2hNTmd4RGzOovquOh
         HmzFHEfFdewWeSFzz+C8oK6OPjMdLL2940ve6EgZ6F3w8NWMhgMcKYXREJ+cY6q/JT+N
         xaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=45DA4vH/D9c7gYWc+sPX522gNKfwVRgZeQ5tT9hcRQo=;
        b=fH4kcu1TSQKcfsEhzUTMMS5bPTZdag4Xr+MZisuLfprp7Eh8Ig/inR/FfO78sOAwRZ
         MDRiqK/LWl4WtC6tiEjdYw2WoCsWpG95nJPglnsK09h7M4P0xdK7ymAPg7ZR5V0YEnYw
         QVvahDBCP4vqjiO6ln2O3tyxAA8ktB5L5CHZ4NwRvLmhnArwJ3OH4vByyJNNjdaDEhMU
         WIDNb9KAPCxxspdz0qN7CX9VHAu0CfbKaj0+m/QdDhhskbhwzE18bsf7mYsJfC3vW8ZK
         k5oUVMefjU/g9ZPEr90mu6hvwE9DDM75ZLDOHRZDTqvYEIVMBg3cTX/oYToDudIr63IT
         LZnA==
X-Gm-Message-State: AOAM531utvPWG5cG32FqgtMypeT+usC0b2FJGEGEiRrzhAopifojtViO
        TEb2pohlqfe1HrZAikzqCw1VlV1ktKaX/wAYU48=
X-Google-Smtp-Source: ABdhPJyg6ovhqg+xDQhRKNU5YXSFgATRKfoACZupNoxS39SiRB6XL+BC/HaI5L5kshdU8ViPPfX5WV4EE+WX7PDFawU=
X-Received: by 2002:a25:9882:: with SMTP id l2mr1400221ybo.425.1610480812991;
 Tue, 12 Jan 2021 11:46:52 -0800 (PST)
MIME-Version: 1.0
References: <20210112091403.10458-1-gilad.reti@gmail.com>
In-Reply-To: <20210112091403.10458-1-gilad.reti@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 Jan 2021 11:46:42 -0800
Message-ID: <CAEf4BzY2ezxxeUbhMy-kw-zRv974JG2NAQ+2g5_rtVSn8EmNcw@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: support PTR_TO_MEM{,_OR_NULL} register spilling
To:     Gilad Reti <gilad.reti@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 1:14 AM Gilad Reti <gilad.reti@gmail.com> wrote:
>
> Add support for pointer to mem register spilling, to allow the verifier
> to track pointer to valid memory addresses. Such pointers are returned
> for example by a successful call of the bpf_ringbuf_reserve helper.
>
> This patch was suggested as a solution by Yonghong Song.
>
> The patch was partially contibuted by CyberArk Software, Inc.
>
> Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier
> support for it")

Surprised no one mentioned this yet. Fixes tag should always be on a
single unwrapped line, however long it is, please fix.


> Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
> ---
>  kernel/bpf/verifier.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 17270b8404f1..36af69fac591 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2217,6 +2217,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
>         case PTR_TO_RDWR_BUF:
>         case PTR_TO_RDWR_BUF_OR_NULL:
>         case PTR_TO_PERCPU_BTF_ID:
> +       case PTR_TO_MEM:
> +       case PTR_TO_MEM_OR_NULL:
>                 return true;
>         default:
>                 return false;
> --
> 2.27.0
>

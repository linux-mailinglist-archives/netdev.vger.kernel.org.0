Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1147D46F1D6
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242933AbhLIR36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242912AbhLIR34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:29:56 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BE7C061353;
        Thu,  9 Dec 2021 09:26:22 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id v64so15348901ybi.5;
        Thu, 09 Dec 2021 09:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rSGhCEpW6oFZLSoL90yonkwQmJggemd7cOz0P3Hw7wQ=;
        b=NP+TLXUbTvx+yci97Q4Z3UXkjvEArPYoSUyx1dPz1TF4FGJKe2uuLW5ptH5KzsV6su
         VCfERZFV1UDrDDSD3/tS+gAsvqrjiNvu8J00kei1RzNS6B+CYDJMT5HmNM9yDETxb7Oc
         ozhsJmQ6B/Cd2Y+XAZqLOSGrHgFd4xNqDgKRk4Ft66VivlScJ//NNYPoh1IOxLTla9XX
         Tu1ihyr1SmCP7WM/cLHNOu64zbZlkpzd9iZ5sIWHKA0cg97IFvBoovEZoDKgaB223fye
         sbivjAFx9txjWPjLcbJbbF/pH228sttehZnC0eE655GDEOIjJfeQ2HJ+mFyX4jn3O7E5
         APCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rSGhCEpW6oFZLSoL90yonkwQmJggemd7cOz0P3Hw7wQ=;
        b=BT3vAcxunOr9pE/Pxqb4qmJC0sM88II16H2/sPSpI/aBbARPcZu9eWa6j2Fi2n5dOB
         6KKCLSORqfEpNuDivuB4xRgEtIqtknxm8lHEWP4U8dWXmqMe2T3RuBqOVZribZV6Dmuh
         OzGIqqfq6PxbNSRCtX4B45CZH9c67nkKcNhkRO8aX7jm57FMTXo25O+xqw6Ss98pZIBb
         eYxBlWtMsiDQtIanJFrbamEUCY0PSUWa2LHBnJ42IK/wDp5j/AkXKyv+qrXItPuoWzgn
         OXYn61Aed1X+OJnclTpmtxCciCy8+ddA0T1HG89mhYM70/KWb2s97Ubg80zkOAk2N21o
         RbbA==
X-Gm-Message-State: AOAM531ZayjiWb9eAEP4GtB5o3BOWdq+Td92Mgp5Wqg4lz39B1BsnYKy
        39Fm2iSEcZY4poHTfCWFAhm40fwj8Pvl63xxsNs=
X-Google-Smtp-Source: ABdhPJwEFK988WUuEzRzJBv+pm4e3nDYT3sdTuDLh/iLI2KLmWEqE6D7kP5kLqLlknWbXBaxPUqrzhCWq+sL6yYQqmY=
X-Received: by 2002:a25:3c9:: with SMTP id 192mr8058827ybd.766.1639070781870;
 Thu, 09 Dec 2021 09:26:21 -0800 (PST)
MIME-Version: 1.0
References: <9eb3216b-a785-9024-0f1d-e5a14dfb025b@linux.alibaba.com>
In-Reply-To: <9eb3216b-a785-9024-0f1d-e5a14dfb025b@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Dec 2021 09:26:10 -0800
Message-ID: <CAEf4BzbtQGnGZTLbTdy1GHK54f5S7YNFQak7BuEfaqGEwqNNJA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Skip the pinning of global data map for
 old kernels.
To:     Shuyi Cheng <chengshuyi@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 9, 2021 at 12:44 AM Shuyi Cheng
<chengshuyi@linux.alibaba.com> wrote:
>
>
> Fix error: "failed to pin map: Bad file descriptor, path:
> /sys/fs/bpf/_rodata_str1_1."
>
> In the old kernel, the global data map will not be created, see [0]. So
> we should skip the pinning of the global data map to avoid
> bpf_object__pin_maps returning error.
>
> [0]: https://lore.kernel.org/bpf/20211123200105.387855-1-andrii@kernel.org
>
> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
> ---
>   tools/lib/bpf/libbpf.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 6db0b5e8540e..d96cf49cebab 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -7884,6 +7884,10 @@ int bpf_object__pin_maps(struct bpf_object *obj,
> const char *path)
>                 char *pin_path = NULL;
>                 char buf[PATH_MAX];
>
> +               if (bpf_map__is_internal(map) &&
> +                   !kernel_supports(obj, FEAT_GLOBAL_DATA))


doing the same check in 3 different places sucks. Let's add "bool
skipped" to struct bpf_map, which will be set in one place (at the map
creation time) and then check during relocation and during pinning?

> +                       continue;
> +
>                 if (path) {
>                         int len;
>
> --
> 2.19.1.6.gb485710b

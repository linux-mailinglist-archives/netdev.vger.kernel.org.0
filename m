Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6B7100B48
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 19:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfKRSRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 13:17:49 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45203 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfKRSRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 13:17:49 -0500
Received: by mail-qt1-f194.google.com with SMTP id 30so21264727qtz.12;
        Mon, 18 Nov 2019 10:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5dV+vT1yib453Y+uFq+lDKeJ8MKDyfgEhpkxE+ur1H4=;
        b=FA2qXle1K57DsDbWGuAC6lkKHFvlDLTHl/NVGT3bysGnVzt1IGcdIjKjI1mf11HjNt
         hvVwk5eAaw2waG93xbStwHYbFLXFiEulJ/WEofRSIfgqg9HkCpzYvYUanXzHg69Y9Soe
         gQr4X3GbQndkoZTQrYSewskWnuXn4OsxQOCSaQiVR5xQbok+E4mwrfj3BbYZcJd65fjy
         S+xILBxTKvrz424+k4L2+bzwpkYtJLDLvFX+XpzQ16TbGYqxiL2J9OKoIvNzGW/ltJaq
         R1lWuFZNoPFEcCXCyDiFUsfNpImOP5ies2PaLXtiUkJYNZjmkGDA/Tb3PXKPN90uh9vu
         lReA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5dV+vT1yib453Y+uFq+lDKeJ8MKDyfgEhpkxE+ur1H4=;
        b=S66WUBT73KQEpGp83337CBDi/UPtFKU202waWJvkZeO5RvAicBXDfPA/KMjdaeF1zt
         7MP4PMTodgZZXu7cTxPMY6L+nQRf+/fz2UmLpFDepy11gmsf7zTsIKTzKqQXAGCoiHHf
         sbDRAqRpXeYL0YezOY9qpx0j1h5geINBJ7ERu6VuNKQ1d35VQ3mGnecbooUBd5luEJ5v
         yv5u7uonKiDxkvMuzseX/8ubn9QM3oRTNBpvHamMDEvdfj63/vmWEZGLOEhBhhDFD9nL
         nAyKh+Vb0RNkksgO3sv3jGPnu37a1UL8Lga4eF2wD9hDOhzewn0m/2VnZtksxKYGtLIv
         Wh0w==
X-Gm-Message-State: APjAAAXjGMROzARwL00mEiqIQd7urJkkSzQMAMAKs9VVQkPLFLsULbna
        HdsVxp757u1sE4B7luelbUj+8jSRunpMRBhVf0Y=
X-Google-Smtp-Source: APXvYqym6fOnp6QLOJBj/8pkQtMTriqysSKGvzlcVJKWtw2ERVdS3PN+EoPjmy+gJm8NnJvgYiqEU3qB3EPBAufk7D4=
X-Received: by 2002:ac8:3fed:: with SMTP id v42mr28115898qtk.171.1574101068165;
 Mon, 18 Nov 2019 10:17:48 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573779287.git.daniel@iogearbox.net> <253496a26ac83e0fe7c830eb27e62ca441a38aff.1573779287.git.daniel@iogearbox.net>
In-Reply-To: <253496a26ac83e0fe7c830eb27e62ca441a38aff.1573779287.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 Nov 2019 10:17:37 -0800
Message-ID: <CAEf4BzZjUvsf6wGuh2JyEBKLOsJD7ihQMwF69CbM3DsR0tN0bg@mail.gmail.com>
Subject: Re: [PATCH rfc bpf-next 5/8] bpf: add jit poke descriptor mock-up for
 jit images
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 5:05 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add initial poke table data structures and management to the BPF
> prog that can later be used by JITs. Also add an instance of poke
> specific data for tail call maps. Plan for later work is to extend
> this also for BPF static keys.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

looks good, just one more minor naming nit

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h    | 20 ++++++++++++++++++++
>  include/linux/filter.h | 10 ++++++++++
>  kernel/bpf/core.c      | 34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 64 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 40337fa0e463..0ff06a0d0058 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -484,6 +484,24 @@ struct bpf_func_info_aux {
>         bool unreliable;
>  };
>
> +enum bpf_jit_poke_reason {
> +       BPF_POKE_REASON_TAIL_CALL,
> +};
> +
> +/* Descriptor of pokes pointing /into/ the JITed image. */
> +struct bpf_jit_poke_descriptor {
> +       void *ip;
> +       union {
> +               struct {
> +                       struct bpf_map *map;
> +                       u32 key;
> +               } tc;

tc is a bit overloaded abbreviation, tail_call would be super-clear, though ;)

> +       };
> +       u8 ip_stable;
> +       u8 adj_off;
> +       u16 reason;
> +};
> +

[...]

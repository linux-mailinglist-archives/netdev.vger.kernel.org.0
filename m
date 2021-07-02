Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5B33BA47E
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 21:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhGBT4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 15:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhGBT4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 15:56:45 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56525C061762;
        Fri,  2 Jul 2021 12:54:12 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id b5so6244487plg.2;
        Fri, 02 Jul 2021 12:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V2rbehZfbjOsbvkL1TBR648VMARxa6al/csz1qm37xc=;
        b=SdHaAXrP4lkSqbRKXEGRNuaDwZOEQ39yV78tV+Ibp1kGl9FIoquN70MTT4Z16BzkAj
         VRjnd7m+UD7YHep2QqCxE6KhcLgPZrL0SVCE+AQLerVfJxn6lyoxzYMGrBURcVtgSz2U
         lJWaCaAcbIK9anYi2oh5Hd7xTZVN82K+GSdHnOmK+HjcywyCPlAJthox+6lFs4K3xXVP
         lOJ5LqXLLve/qM7M3m3sDQnXRIE4e8/tyjVk+ie5Dt4IK4a6vz1hHmdyBThREomKclr+
         Zc1ABlRPrFl8EHQXcNJ9NzmsP+6EoTI8OYOC7bXnc4D2Vlp4Y+8Q04yweY9BuOjO78C3
         0Ixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V2rbehZfbjOsbvkL1TBR648VMARxa6al/csz1qm37xc=;
        b=TOBX9TtBHiDacNtBrFaS4B4XJ1uMYR/ZKglFUpsIarISO/8J3BCxxiimMt8HXZBIgb
         foRZTHLEvNghtQD5+dl+01C3wDCfD2K1EnCkjKCQF+Ctf4LktjvA73avQwljG2jyFCFn
         px2UZmAcsfB+Cyx9dljho/WDOClwuZuGNu1isy94SD5530e5KG+vSZt9oHHR8sKptnqc
         FRcPjtOImRB7eaAXPt6fkr/ozsq1SO4eZyvDx9Q8eR4dkLJ7VCun2a3156cZ1vH0Nd1j
         l45nxKlurqYH8WB+FjH5LAfSjsTiO6haQo85Vl2gGphePc0WhfFSL1owl2daSbTctHLy
         eSBw==
X-Gm-Message-State: AOAM5305B6Urse8G5+ApvmZTXdPBG74q8GC5XLiqnC9w6r+q3OIr2M7P
        VXrXlynDbI4Tc0m6U+wZXilVWpEYZ1+d0JLlDlM=
X-Google-Smtp-Source: ABdhPJzxYnjpx1pP5AK5rs5pPGzJAppE3DWukhMXjgDk4JN51ESJ9rzTMCrvMlo6YFEPFRJO1MLw+UrEEPCsZ6XjRa4=
X-Received: by 2002:a17:90a:17c1:: with SMTP id q59mr330203pja.231.1625255651825;
 Fri, 02 Jul 2021 12:54:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210702001123.728035-1-john.fastabend@gmail.com> <20210702001123.728035-2-john.fastabend@gmail.com>
In-Reply-To: <20210702001123.728035-2-john.fastabend@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 2 Jul 2021 12:54:01 -0700
Message-ID: <CAM_iQpXwTJ4kKNtcH27VVvX+bYFKTvVnM_RtP5G7zg_Nt9QBYw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 1/2] bpf, sockmap: fix potential msg memory leak
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 5:12 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> If skb_linearize is needed and fails we could leak a msg on the error
> handling. To fix ensure we kfree the msg block before returning error.
> Found during code review.
>
> Fixes: 4363023d2668e ("bpf, sockmap: Avoid failures from skb_to_sgvec when skb has frag_list")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/core/skmsg.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 9b6160a191f8..22603289c2b2 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -505,8 +505,10 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
>          * drop the skb. We need to linearize the skb so that the mapping
>          * in skb_to_sgvec can not error.
>          */
> -       if (skb_linearize(skb))
> +       if (skb_linearize(skb)) {
> +               kfree(msg);
>                 return -EAGAIN;
> +       }
>         num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
>         if (unlikely(num_sge < 0)) {
>                 kfree(msg);

I think it is better to let whoever allocates msg free it, IOW,
let sk_psock_skb_ingress_enqueue()'s callers handle its failure.

Thanks.

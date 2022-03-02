Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364F14C9E61
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 08:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238308AbiCBHa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 02:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiCBHaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 02:30:25 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D164C51E51;
        Tue,  1 Mar 2022 23:29:41 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso672027pjb.0;
        Tue, 01 Mar 2022 23:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n+PhcwQqRo/8Gtd1tkNC+jMPxT5Ks6cVlUrXMWN3ik4=;
        b=F6UPPFKKVPcVZFUnTLysi8DeM5ZnNxSinx5W+BPBY7bn2dEiwrb6hCi089Ohyc+Cff
         cvg3M53iTmASMInR4kjsGHw1gn7Dd6zJO2kE8gMLqeMvCHHM/LYyjSPj7WLRThz0L+or
         k38oIlwayvHk2meozkmSsvQaf9j9tvKF/L8mc1IN/9lKN5BoLL2aBxWBRvCH69kwwAx5
         /icdl3iEe1skXX6TNmTzhhbYQOaNUKemUTWz4hJ9OgG7s83PUqyYqS2xmQvxXA7KFXmz
         jFOlZoqeSZmjtGmHGzhM8W3K38HuU3/poHlovgvPK43HgLmql5ssgppHzD7lsZuRMiJp
         ft+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n+PhcwQqRo/8Gtd1tkNC+jMPxT5Ks6cVlUrXMWN3ik4=;
        b=X33iFavQoHySuwEesQgUE0zM7E81GWwwwpo+aevTRXRCVqB+JAPvRW6yCZ2UAfQWC8
         fKXnBqkAUimErXlAkTZFhkKWdUf0XNcJ6rOePpZoo0JFdbtGeg4Mx09Hp+RLN6DR+7Qc
         aXjrWcUo/GSXSIDhD/TKevKP5azNvzJMNVq/jr2YGtiek7rRo6aBd+7dQMx+yLimDsDl
         XOvliNr+SoaV8s2mBRIlNAfnPL1DF5E6qLzSiukY0EOXvfcEWtp+e47gPXbmmgsrJ7oz
         +YMS/fsL5MOYe8+Vz/qK7k+4dFlLinHsR7BF+6b3sp3W1cdt0F2lKCVA+Rkj2l8Hp90/
         eh8g==
X-Gm-Message-State: AOAM530MaF2GQ0hXKi5jIgetBGcspjdyx8GIiukV5+Lj0c/7ud4eNM4O
        TcEJLulVZqwHNTG6SMJC1W+sfKjGnJYYsYzTnvM=
X-Google-Smtp-Source: ABdhPJySOpWhvU0ZuNChoueITcvmjAVZyd/O+WwyWQ60m7KIRAB1X8qddJpHis7ybnBVGu3Gd8GMplPU0zKFl7lEgug=
X-Received: by 2002:a17:90a:b307:b0:1bd:37f3:f0fc with SMTP id
 d7-20020a17090ab30700b001bd37f3f0fcmr16405568pjr.132.1646206181283; Tue, 01
 Mar 2022 23:29:41 -0800 (PST)
MIME-Version: 1.0
References: <20220301132623.GA19995@vscode.7~>
In-Reply-To: <20220301132623.GA19995@vscode.7~>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 2 Mar 2022 08:29:30 +0100
Message-ID: <CAJ8uoz2y2r1wS3_sSgZ8jC2fkiyNCW_q4oQdc_JYe2bKO4NoJA@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: unmap rings when umem deleted
To:     lic121 <lic121@chinatelecom.cn>
Cc:     bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Tue, Mar 1, 2022 at 6:57 PM lic121 <lic121@chinatelecom.cn> wrote:
>
> xsk_umem__create() does mmap for fill/comp rings, but xsk_umem__delete()
> doesn't do the unmap. This works fine for regular cases, because
> xsk_socket__delete() does unmap for the rings. But for the case that
> xsk_socket__create_shared() fails, umem rings are not unmapped.
>
> fill_save/comp_save are checked to determine if rings have already be
> unmapped by xsk. If fill_save and comp_save are NULL, it means that the
> rings have already been used by xsk. Then they are supposed to be
> unmapped by xsk_socket__delete(). Otherwise, xsk_umem__delete() does the
> unmap.

Thanks for the fix. Please note that the AF_XDP support in libbpf has
been deprecated and moved to libxdp
(https://github.com/xdp-project/xdp-tools). The code will be
completely removed in the libbpf 1.0 release. Could I take your patch
and apply it to libxdp instead and fix the bug there? I have not
checked, but it is likely present there as well. And that is the code
base we will be using going forward.

> Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
> Signed-off-by: lic121 <lic121@chinatelecom.cn>
> ---
>  tools/lib/bpf/xsk.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index edafe56..32a2f57 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -1193,12 +1193,23 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>
>  int xsk_umem__delete(struct xsk_umem *umem)
>  {
> +       struct xdp_mmap_offsets off;
> +       int err;
> +
>         if (!umem)
>                 return 0;
>
>         if (umem->refcount)
>                 return -EBUSY;
>
> +       err = xsk_get_mmap_offsets(umem->fd, &off);
> +       if (!err && umem->fill_save && umem->comp_save) {
> +               munmap(umem->fill_save->ring - off.fr.desc,
> +                      off.fr.desc + umem->config.fill_size * sizeof(__u64));
> +               munmap(umem->comp_save->ring - off.cr.desc,
> +                      off.cr.desc + umem->config.comp_size * sizeof(__u64));
> +       }
> +
>         close(umem->fd);
>         free(umem);
>
> --
> 1.8.3.1
>

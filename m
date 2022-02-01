Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DE44A5539
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 03:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiBACZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 21:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiBACZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 21:25:20 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BD5C061714;
        Mon, 31 Jan 2022 18:25:20 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id z20so22039331ljo.6;
        Mon, 31 Jan 2022 18:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3NFcpSNbn5N8Qa2Q7ec108f+HMS/1rOzdxpFaqBQx3Y=;
        b=Zf7933wUxyldB+3Qj26LgRwrkn3jZN981YT1o/kND9/6oRNwee7M12QtzvDRG19HkP
         WGehHovTmgHSYvn1+vx/TwmF3aymj5Yu/3dEeok5PDSCz9cym7t0MV9oSKPKoAfcVKPU
         l51C0HGBTgkFA2I1VOcGjvz/Jx/YjtjHRd/0HnpfRfF/9MvSkgW8vuSGSL1c3m+L8Ew6
         flrPnTiUVf3KT6HvvYSkm6cFT1+tQdcT8rJB08DBHsGPkUOX4NkShccufmDN6ZOjfAm4
         uvEMlUyxDSWBJ/gQWY0L/uoQmpIi679IJw79qIIK857NxOs3r4wvnIEWsZ25IAFfiD6r
         jL5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3NFcpSNbn5N8Qa2Q7ec108f+HMS/1rOzdxpFaqBQx3Y=;
        b=8QWSt6nmWUw7ieQA8WyE6wvGqbskzmF1akD87Ecoxktq/f46iTYAm0MpTdM3PwFLeN
         QMfD/2ZCpKK1zS6ch/onmcBPxmfQrapLU+5j9edVGr442qEb27CS/B0iguPZeieXO3X9
         HP4lGW0TZkY64noMrf/CaQ/C6iDpUWvLmD8DmZW/eSWqhYo17C1FKRiTtfvBY+BPeOB6
         O2Q1HXVlR5Ix8cYrh5rkLWIwPe3rsSQHSGfXe5UFa/QBaUT1TsjtBRbKyAWI/mPXBiQg
         8kqe10u6wJF17i8teJ87gtCzWyPXmxwQhaj96DqxmWjNACGEotQOpCgqbWJcTm/x3LK/
         R1wQ==
X-Gm-Message-State: AOAM530VNsb7n8mg40zWezzcMOSeRHZXgWvLyKek5LUir8ziKzpswTrv
        PPhaR7/QAma7V8QrIsQM6KPGaNK+a2MejKYt5Og=
X-Google-Smtp-Source: ABdhPJyU2s2NAFGnCYn+is4A64/LbHpz8swj5c9UlhKMBGs6BaQqdbFMID0H3hoo6ZTnlbOhy7ypqY/ZpKcvuLQc3Zw=
X-Received: by 2002:a2e:9b8c:: with SMTP id z12mr9531343lji.476.1643682318491;
 Mon, 31 Jan 2022 18:25:18 -0800 (PST)
MIME-Version: 1.0
References: <20220131114600.21849-1-houtao1@huawei.com> <36954dbd-beab-9599-3579-105037822045@iogearbox.net>
In-Reply-To: <36954dbd-beab-9599-3579-105037822045@iogearbox.net>
From:   htbegin <hotforest@gmail.com>
Date:   Tue, 1 Feb 2022 10:25:06 +0800
Message-ID: <CANUnq3ZneUy1LZBsR59s-QwzqK0pfRrf-2DPL7nQ3rgCnANJ6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: use VM_MAP instead of VM_ALLOC for ringbuf
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Hou Tao <houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Feb 1, 2022 at 12:28 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/31/22 12:46 PM, Hou Tao wrote:
> > Now the ringbuf area in /proc/vmallocinfo is showed as vmalloc,
> > but VM_ALLOC is only used for vmalloc(), and for the ringbuf area
> > it is created by mapping allocated pages, so use VM_MAP instead.
> >
> > After the change, ringbuf info in /proc/vmallocinfo will changed from:
> >    [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmalloc user
> > to
> >    [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmap user
>
> Could you elaborate in the commit msg if this also has some other internal
> effect aside from the /proc/vmallocinfo listing? Thanks!
>
For now, the VM_MAP flag only affects the output in /proc/vmallocinfo.

Thanks,
Tao
> > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > ---
> >   kernel/bpf/ringbuf.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> > index 638d7fd7b375..710ba9de12ce 100644
> > --- a/kernel/bpf/ringbuf.c
> > +++ b/kernel/bpf/ringbuf.c
> > @@ -104,7 +104,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
> >       }
> >
> >       rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
> > -               VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
> > +               VM_MAP | VM_USERMAP, PAGE_KERNEL);
> >       if (rb) {
> >               kmemleak_not_leak(pages);
> >               rb->pages = pages;
> >
>

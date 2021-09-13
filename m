Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DE34097CD
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344302AbhIMPvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343968AbhIMPvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:51:03 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C13C028BA5;
        Mon, 13 Sep 2021 08:36:41 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id i21so22029511ejd.2;
        Mon, 13 Sep 2021 08:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XSYbOa1IizAHpslHQQmvn+2hEv67SUo9KMqNHAVVr/c=;
        b=IxOMxIVUf83SESPCmeqzWMSc4EeNXdU8BXuhAkjBidOQoIdoll6j+53llXrD43nPhY
         I2eXyZrkJGWwMhwkXz93mb3uaxsfQNQnbQsOk1JeaCPuMxligG62v6r7GZq4uaGA35Xu
         1BbR0b98NQFNbk7NZsM+GFVfKTlNdtaKh4wnvB35i8bFC30T1EZejxaQDQ2AAx+Pikmu
         KJy+munhXsVw8Jy0PBPZeVXQ2ObvAkd7FxH4JF0wBLuGtnWjj0VTZNd+Ut6HL8xmRETT
         0GpZ39BRFsKQOpc9Vmm9ZRuI6KejeiqU7xglX+7XZG2XufPXSBYoj1eNPyjlIa4ni0pi
         HPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XSYbOa1IizAHpslHQQmvn+2hEv67SUo9KMqNHAVVr/c=;
        b=CzSU5xYi2KtLOR0k0YJ/hzbUPksk5vN6mQ09bb0NZoJxrGQZBRBB3Yw9T6/rTyEJ6C
         snn7I+NrhcrCkhHCc3UKADcfKk3UcZ7LG5ByBiuXtvCd1yiazSV8wAKVS38C3p94VuFq
         ge4Sw6d0P73JuVTEJ/KD/SZOPwqwe7Ho0PNt83oxvIs65YXFge8wHBjlps2jPXNDhw6o
         Bw1JplG2qNtYD/LdffSIVLPiEQrXqszQN0a7tHoJpQ6o2zlbb4QR+tmd2N+3XuqiP2aq
         lsrmZHkeF5lMBX6C8ShzNNIqs8WCDa4w4dlVZIHIhQQHC4FEO0yl6zdYbTGyAIEFd2WY
         0yLA==
X-Gm-Message-State: AOAM531zOFFHzS6KofOKL8PfopcwI2dD8+tFfTEzw7/zRurmjmLj9M5T
        8aQvY7mQyG/n4TQgex4HUn60Zjp/KZV8F/Wl2gSqepbvlsgmBQ==
X-Google-Smtp-Source: ABdhPJwLjo74lSFVZD71/d7P98WZS5j01e79q+eKxJkyr1M9XahZtYihosk2ZYxZhu5WqY6L9VLpLIz+gNMHPXFlBxw=
X-Received: by 2002:a17:906:7250:: with SMTP id n16mr13223849ejk.147.1631547400206;
 Mon, 13 Sep 2021 08:36:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210913110246.2955737-1-mudongliangabcd@gmail.com> <4f260295-b7a2-92ad-3bb0-06074288dd23@fb.com>
In-Reply-To: <4f260295-b7a2-92ad-3bb0-06074288dd23@fb.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 13 Sep 2021 23:36:13 +0800
Message-ID: <CAD-N9QWPUtFRr4XYJG4zAi_fhB1aLsnHsHu0GsfLyC3RamabNw@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix kmalloc bug in bpf_check
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Willy Tarreau <w@1wt.eu>,
        syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 11:34 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 9/13/21 4:02 AM, Dongliang Mu wrote:
> > Since 7661809d493b ("mm: don't allow oversized kvmalloc() calls
> > ") does not allow oversized kvmalloc, it triggers a kmalloc bug warning
> > at bpf_check.
> >
> > Fix it by adding a sanity check in th check_btf_line.
> >
> > Reported-by: syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com
> > Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
>
> Thanks for the fix. A similar patch has been proposed here:
> https://lore.kernel.org/bpf/20210911005557.45518-1-cuibixuan@huawei.com/

OK, I see. Let's ignore this patch.

>
> > ---
> >   kernel/bpf/verifier.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 047ac4b4703b..3c5a79f78bc5 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -9913,6 +9913,9 @@ static int check_btf_line(struct bpf_verifier_env *env,
> >       if (!nr_linfo)
> >               return 0;
> >
> > +     if (nr_linfo > INT_MAX/sizeof(struct bpf_line_info))
> > +             return -EINVAL;
> > +
> >       rec_size = attr->line_info_rec_size;
> >       if (rec_size < MIN_BPF_LINEINFO_SIZE ||
> >           rec_size > MAX_LINEINFO_REC_SIZE ||
> >

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F35264C1C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgIJSBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIJSA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 14:00:59 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1028EC061573;
        Thu, 10 Sep 2020 11:00:59 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id c2so9329240ljj.12;
        Thu, 10 Sep 2020 11:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ixsHcN6jItwFo+b7ORNGXDNB8lkHhVKtZ2pYCkfr3s=;
        b=Xh2LBZMIDwx1qhyaaqYYiwxId4iBxGDOGSqjJ8jMJ89x5b/GHCt3/7rE4eAkCKVrkB
         /SpSiZZkL+rz+cCupn/R9zjfERCG/hSyjQaeNzBdj5D2tus6YHXqiC9QrVFA+++F37qI
         iHfAPDH22/b3Cv2qzqkWbXuF3D5ZUJZe6UaPJnAEJ2Y6FavKiUT0uVZ/yLZR7XqUuSfV
         CysERIhEK0rer61DnJTTyiBNE5xlMTGN5NwKsVXahTB9ALJ9d4H045srW90iY/apy5/V
         sxEe3Et9Mmc85c2pbpv4el6DCcF+oMyV7Rby/4vb1iAXCgTxOKRwBnYgWDfXLTOzHN0S
         /WxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ixsHcN6jItwFo+b7ORNGXDNB8lkHhVKtZ2pYCkfr3s=;
        b=iJqyJdO3zB1WZ847kZQnAkBdXr4kRgWxjmiKKjs4MqBPV3zFuYPzQN9TpR7gAF24Sw
         SL7XrYYPCejtCBBM9N1uoA+CNqZD9zPGqhChHmAYuoa7eiWTRb/OrOVxozmR4HPk/hTi
         RAKG0rTZc7oFRx4tKGUERq8fsYr0+b7iYNNqfH2r7Oedfq7/bndPqYitBaWfyflG5XQb
         OzuOq9MTc2sRjk1bGcmQMk4H1CiA6cLr/YC9kQnKMiRj9kegkBiwFvbS7v8Ma6RvQFyF
         FRSO4J34R9VlIkudhZ1UblAF6qWBlFL9LbvnRTfJsMoFowHz3TVRWI91mMTYpJx+K39+
         DOEQ==
X-Gm-Message-State: AOAM530CfDDkM+4Bj9FOOs6bZcetxKIRTxn9CJoyAIh3wZrgPZIC9ZcP
        jbYDNWI6pHFtlgcTBP+o8tX6yasb1oZQ6Jkc0hU=
X-Google-Smtp-Source: ABdhPJxn68UyTSyW7y+9kdF6cM2l0ADSl+ZshZtcE3TpS6dgc6WaALSFl9zSOzkIp7kRhIgLv9LYMZBxNWMCj2pIqig=
X-Received: by 2002:a2e:808f:: with SMTP id i15mr4780575ljg.51.1599760857300;
 Thu, 10 Sep 2020 11:00:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200909151115.1559418-1-jolsa@kernel.org>
In-Reply-To: <20200909151115.1559418-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Sep 2020 11:00:45 -0700
Message-ID: <CAADnVQ+3sBR7dTQhX+eHvzJajtnm0QctjrWFyc+LMkHJOoOabA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Fix context type resolving for
 extension programs
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eelco Chaudron <echaudro@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 8:11 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Eelco reported we can't properly access arguments if the tracing
> program is attached to extension program.
>
> Having following program:
>
>   SEC("classifier/test_pkt_md_access")
>   int test_pkt_md_access(struct __sk_buff *skb)
>
> with its extension:
>
>   SEC("freplace/test_pkt_md_access")
>   int test_pkt_md_access_new(struct __sk_buff *skb)
>
> and tracing that extension with:
>
>   SEC("fentry/test_pkt_md_access_new")
>   int BPF_PROG(fentry, struct sk_buff *skb)
>
> It's not possible to access skb argument in the fentry program,
> with following error from verifier:
>
>   ; int BPF_PROG(fentry, struct sk_buff *skb)
>   0: (79) r1 = *(u64 *)(r1 +0)
>   invalid bpf_context access off=0 size=8
>
> The problem is that btf_ctx_access gets the context type for the
> traced program, which is in this case the extension.
>
> But when we trace extension program, we want to get the context
> type of the program that the extension is attached to, so we can
> access the argument properly in the trace program.
>
> Reported-by: Eelco Chaudron <echaudro@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/btf.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index f9ac6935ab3c..37ad01c32e5a 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3859,6 +3859,14 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>         }
>
>         info->reg_type = PTR_TO_BTF_ID;
> +
> +       /* When we trace extension program, we want to get the context
> +        * type of the program that the extension is attached to, so
> +        * we can access the argument properly in the trace program.
> +        */
> +       if (tgt_prog && tgt_prog->type == BPF_PROG_TYPE_EXT)
> +               tgt_prog = tgt_prog->aux->linked_prog;
> +
>         if (tgt_prog) {
>                 ret = btf_translate_to_vmlinux(log, btf, t, tgt_prog->type, arg);

I think it would be cleaner to move resolve_prog_type() from verifier.c
and use that helper function here.

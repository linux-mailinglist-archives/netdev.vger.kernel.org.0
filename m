Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA545106F9
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 20:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351649AbiDZSeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 14:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351613AbiDZSd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 14:33:59 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89761CB0D;
        Tue, 26 Apr 2022 11:30:51 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id k4so19446512plk.7;
        Tue, 26 Apr 2022 11:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/OKcS6E5AHopfe6TSQqeBBsA+saXO4yiGsN11OQPGJ8=;
        b=fLzncqcj0dXP5hQrUX0xFv5GFAYa+Swj7LLrKFTa4snWvd/S4QrdcP5YjXMWmQ1+es
         xY85buGrIJWvIjLkVKPB9qzFbL7CqWqUjPMUhsb9512+Ri1BaScFpieW5mWW+F+jcKdm
         fQzUTjRaHAizZbQr1Dh7HZ6DdIFruqmwCaxWDtMMGc9GKDvkyDAX6i5blV7wA/OmbnWU
         fj18nAGTVQChr/G0wrGDqbL0MsAogzN+mj4xCD8IdtXoLFDWv9OZ8UIk2JXq2VX5RH0V
         oYdnODOI2PMuPoYSzuwMnbGPA8mpqwbMwnQX5h4706OVsAELAxTj+7i78zzPaZoraqEi
         tsqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/OKcS6E5AHopfe6TSQqeBBsA+saXO4yiGsN11OQPGJ8=;
        b=WNuHT29N+dW9VFzZj/UTWzSpbpceUW9H62wBott3+5oJd/fV1I1tyQfmW1AFBLhBA4
         HuLmj1pDsF21JhdcuJvavJrbgru9nNY6vMYhxlgeBEvN8sL7q1ElP3PDw4evbFOM2xo2
         n0koFXvITNkcQRuibqb6YjY7VwQoHp45l/vYifyqmgE9I4KHyHycl5wF8PHbshNbG+AB
         RTsyoVZIPi7F/7BDHIwtfwarYlvck6Y4tbs2voSyNSfB7Q9WRFVE8sioZtQ8V99GuX9x
         4f8SGSTOUm5JjbKXR6H+r+iJIURE0V5215gTaLdTMC5JwVJloWilvL1NixG9CCKtGD0S
         SS+Q==
X-Gm-Message-State: AOAM5308kvPCdK7bKZJIcHEaxd2eyh2133DFEB8dG29gwjHhKQE6Gv8w
        RoPx0eFuEzYnzy8uJDTUdHUUxH6CvJ/ngSRSko8=
X-Google-Smtp-Source: ABdhPJxXiV8tIRzp6ZwyiejNDWj+U3jWbP25qY+GotbknlOieIbkJ7bbp6ln6ZKJfl/jVHt68rnqmwR6fgC8tCq5+Do=
X-Received: by 2002:a17:90a:8591:b0:1b9:da10:2127 with SMTP id
 m17-20020a17090a859100b001b9da102127mr39272157pjn.13.1650997851279; Tue, 26
 Apr 2022 11:30:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220424092613.863290-1-imagedong@tencent.com> <20220426182621.kgut2bpateytcxaj@MacBook-Pro.local>
In-Reply-To: <20220426182621.kgut2bpateytcxaj@MacBook-Pro.local>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 26 Apr 2022 11:30:40 -0700
Message-ID: <CAADnVQL0rLLUMUcfdu=-dc2BCe8AQg5oz+gt+6j95y9V1DFEYA@mail.gmail.com>
Subject: Re: [PATCH] bpf: init map_btf_id during compiling
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, benbjiang@tencent.com,
        Hao Peng <flyingpeng@tencent.com>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 11:26 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Apr 24, 2022 at 05:26:13PM +0800, menglong8.dong@gmail.com wrote:
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 0918a39279f6..588a001cc767 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -4727,30 +4727,6 @@ static const struct bpf_map_ops * const btf_vmlinux_map_ops[] = {
> >  #undef BPF_MAP_TYPE
> >  };
> >
> > -static int btf_vmlinux_map_ids_init(const struct btf *btf,
> > -                                 struct bpf_verifier_log *log)
> > -{
> > -     const struct bpf_map_ops *ops;
> > -     int i, btf_id;
> > -
> > -     for (i = 0; i < ARRAY_SIZE(btf_vmlinux_map_ops); ++i) {
> > -             ops = btf_vmlinux_map_ops[i];
> > -             if (!ops || (!ops->map_btf_name && !ops->map_btf_id))
> > -                     continue;
> > -             if (!ops->map_btf_name || !ops->map_btf_id) {
> > -                     bpf_log(log, "map type %d is misconfigured\n", i);
> > -                     return -EINVAL;
> > -             }
> > -             btf_id = btf_find_by_name_kind(btf, ops->map_btf_name,
> > -                                            BTF_KIND_STRUCT);
> > -             if (btf_id < 0)
> > -                     return btf_id;
> > -             *ops->map_btf_id = btf_id;
> > -     }
> > -
> > -     return 0;
> > -}
> > -
> >  static int btf_translate_to_vmlinux(struct bpf_verifier_log *log,
> >                                    struct btf *btf,
> >                                    const struct btf_type *t,
> > @@ -4812,11 +4788,6 @@ struct btf *btf_parse_vmlinux(void)
> >       /* btf_parse_vmlinux() runs under bpf_verifier_lock */
> >       bpf_ctx_convert.t = btf_type_by_id(btf, bpf_ctx_convert_btf_id[0]);
> >
> > -     /* find bpf map structs for map_ptr access checking */
> > -     err = btf_vmlinux_map_ids_init(btf, log);
> > -     if (err < 0)
> > -             goto errout;
> > -
>
> Looks nice. Please address build warn and resubmit.

Just noticed v2. Ignore the above.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07103104381
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 19:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfKTSfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 13:35:05 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39541 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfKTSfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 13:35:04 -0500
Received: by mail-qt1-f196.google.com with SMTP id t8so606366qtc.6;
        Wed, 20 Nov 2019 10:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pZuTqS/YMEv/CcY1o7IiiVS2Y53ZWuBFrP+npt1ogsY=;
        b=PwiGmkAsHFIQSikwWTw2kyOfJBRSgz7MoaD/KW1sF78yU1n7DMo4gNLQibYPaquQ0F
         uZMt1QwspE5+ej5ZPt0vv2+toMlev85HVZ+nZv+Oe7KNv7Nt2PV4pg2s/MzJTbvPgzfe
         qWQWCYrrSjaQGI5vWRda+uAfWILN/cjnBnnKMaE/PZu6fuOBT8bbSQ9L4UlWyrCo2AeI
         eplNgbY/hhhPA25rFRfrjSqT0ONQCOmkPCipahWYv1JJjBFTgMXAtMVC+T3VsmmKw0Md
         +jnzDv33bKeLbo1zTw/u6C3j77nFdHMJbt1ZO49b8zPKBYQ6duelQaBX3Oy5nM0XSUDx
         LDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pZuTqS/YMEv/CcY1o7IiiVS2Y53ZWuBFrP+npt1ogsY=;
        b=KmyOLmtmtrlLH04yIA2McFTAOoTfNruYu0lo2LBaeXNoyhOMbcwpVnsaz+ZOt/ixY0
         mA+tdbprcaTNPYm1jNacWB0xCP+OEEJ4fFrx4v2XIAoTXEI4g+FOpkPuuUAv80jbLhjQ
         WwQbM6x9hNuDKUKgKWrEMmkl70p08fyQjjDmeQyG7A02Ug1sCvdOTN0Xbu+AAQoz1R2a
         Sg4BDGpmiYOpM2foQjb9m4LuT8NLQcf+MbWFmkuXjG2o6Oe4ZKc1UuJSogDSl5porZmg
         z4dmR/CiBwESvoy9kGPTQUam3srRAzI2nvQxaKpgNk5TV6QggDANFv+xXTEpiGxMQAoE
         uv4A==
X-Gm-Message-State: APjAAAXga+OE5ndidwsIQY9E4AJLHzz7G1ra7O5yTUhE3pDn6c/8e5N0
        hqz4jJiAsqjIL4EkP7Fp+1Z4fzjFKHjv+tALpvI=
X-Google-Smtp-Source: APXvYqxsNBnP+52k3EteNymAqmsOcfqcASX2OtZAIp6heNGM55bRBl2CcWa36sWE69G71V52d8Klc+nsHZ+WlWChBiU=
X-Received: by 2002:ac8:199d:: with SMTP id u29mr3940883qtj.93.1574274903227;
 Wed, 20 Nov 2019 10:35:03 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574126683.git.daniel@iogearbox.net> <a08b0f2ed58fe90eb733d5ad8409285ee126c888.1574126683.git.daniel@iogearbox.net>
In-Reply-To: <a08b0f2ed58fe90eb733d5ad8409285ee126c888.1574126683.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Nov 2019 10:34:52 -0800
Message-ID: <CAEf4BzZrRo=TGZRNO8e5q-N3CW4KLDOOBONSRAqM7yWOHBndvg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/8] bpf: add initial poke descriptor table for
 jit images
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 5:38 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add initial poke table data structures and management to the BPF
> prog that can later be used by JITs. Also add an instance of poke
> specific data for tail call maps; plan for later work is to extend
> this also for BPF static keys.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/linux/bpf.h    | 20 ++++++++++++++++++++
>  include/linux/filter.h | 10 ++++++++++
>  kernel/bpf/core.c      | 34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 64 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 836e49855bf9..cad4382c1265 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -488,6 +488,24 @@ struct bpf_func_info_aux {
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
> +               } tail_call;
> +       };
> +       u8 ip_stable;

this one is bool, any reason you used u8 instead?

> +       u8 adj_off;
> +       u16 reason;
> +};
> +

[...]

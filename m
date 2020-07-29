Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B292326C3
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgG2Vam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgG2Val (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 17:30:41 -0400
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A85C92082E;
        Wed, 29 Jul 2020 21:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596058241;
        bh=Rkb+yVU3xgcmvVOZjIk9GO+61I1wdDDEJj24FRfaGSk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=s9VYAq6zXeqI/wCu+MQANaTrL+b8ngk3UhkRyklY8l6JXQaeQlkjjSg4BdyCZhiUu
         F1hNZVJwzy0Ye0P7lOtj8gA1k/CTeC2h+GtBs5B42/CqpKmngPKF/nSpFAHg97qY5C
         NBy7dbcN4/W6Wwr3c9pEJkVHnA8NKX1VCtbCMiNI=
Received: by mail-lj1-f171.google.com with SMTP id g6so14016285ljn.11;
        Wed, 29 Jul 2020 14:30:40 -0700 (PDT)
X-Gm-Message-State: AOAM533rHS46jNudZWXR2i8Iv4Vyf3N7CdTm2t/TXFRgk6a+/DLENX5w
        rlSiArR79fNX5GFQ40Z7tMG7evaLkSxTh1Uwfek=
X-Google-Smtp-Source: ABdhPJyydIOOnGfPFsaMpDtfvP/MLe2XdJ0RL+Q94+UeIRlZcaI5EwIIXdtRxDSaLdWCb+tvULYlMU/AYOTjLVlZDhE=
X-Received: by 2002:a2e:88c6:: with SMTP id a6mr184430ljk.27.1596058239018;
 Wed, 29 Jul 2020 14:30:39 -0700 (PDT)
MIME-Version: 1.0
References: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
 <159603979365.4454.14002555655802904027.stgit@john-Precision-5820-Tower>
In-Reply-To: <159603979365.4454.14002555655802904027.stgit@john-Precision-5820-Tower>
From:   Song Liu <song@kernel.org>
Date:   Wed, 29 Jul 2020 14:30:27 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4W8MsyhvxHmh-i50PShO9Gz0HK1G6rRViO-aHwXy4Uyg@mail.gmail.com>
Message-ID: <CAPhsuW4W8MsyhvxHmh-i50PShO9Gz0HK1G6rRViO-aHwXy4Uyg@mail.gmail.com>
Subject: Re: [bpf PATCH v2 2/5] bpf: sock_ops sk access may stomp registers
 when dst_reg = src_reg
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 9:25 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Similar to patch ("bpf: sock_ops ctx access may stomp registers") if the
> src_reg = dst_reg when reading the sk field of a sock_ops struct we
> generate xlated code,
>
>   53: (61) r9 = *(u32 *)(r9 +28)
>   54: (15) if r9 == 0x0 goto pc+3
>   56: (79) r9 = *(u64 *)(r9 +0)
>
> This stomps on the r9 reg to do the sk_fullsock check and then when
> reading the skops->sk field instead of the sk pointer we get the
> sk_fullsock. To fix use similar pattern noted in the previous fix
> and use the temp field to save/restore a register used to do
> sk_fullsock check.
>
> After the fix the generated xlated code reads,
>
>   52: (7b) *(u64 *)(r9 +32) = r8
>   53: (61) r8 = *(u32 *)(r9 +28)
>   54: (15) if r9 == 0x0 goto pc+3
>   55: (79) r8 = *(u64 *)(r9 +32)
>   56: (79) r9 = *(u64 *)(r9 +0)
>   57: (05) goto pc+1
>   58: (79) r8 = *(u64 *)(r9 +32)
>
> Here r9 register was in-use so r8 is chosen as the temporary register.
> In line 52 r8 is saved in temp variable and at line 54 restored in case
> fullsock != 0. Finally we handle fullsock == 0 case by restoring at
> line 58.
>
> This adds a new macro SOCK_OPS_GET_SK it is almost possible to merge
> this with SOCK_OPS_GET_FIELD, but I found the extra branch logic a
> bit more confusing than just adding a new macro despite a bit of
> duplicating code.
>
> Fixes: 1314ef561102e ("bpf: export bpf_sock for BPF_PROG_TYPE_SOCK_OPS prog type")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>
[...]

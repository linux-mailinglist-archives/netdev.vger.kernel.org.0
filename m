Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F213DAEDB
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 00:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhG2W3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 18:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhG2W3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 18:29:16 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B0BC061765;
        Thu, 29 Jul 2021 15:29:12 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id k65so12594615yba.13;
        Thu, 29 Jul 2021 15:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=71ZZ/nQBnwbk1aMA3D066yL5yEXN+z/P3q8vX1qgDEo=;
        b=Q3n9wsH5O5MV7yd1keFEHATgLBEQRMmqXptk0RM00J0d2qI5inZZkhx6JPEDXjYiOx
         fn6qIch1BQwSW3pevhi5z4ouvccywpEs5oJJ5UZahqkIi7ni4L81XK4sMZDi/aQOVZyj
         lhlOBQHFEip0pB84VfBKbVD+eKdPl4lbzUTzLmrH03aZXcsbRO93yQE1SLdREMX7IjN7
         aNt7/l3unaDfEStYRVnII69TzaIjWsMIlDdfNoYLRcajYYJ5AigRPKueNiKucHqKGJMw
         Nb47VZ9OA/C3i39mEnMi/AvbqwKwLWuvphwKH/c1+hy0IXlmfH5JOCbY9BN0HiwZnUTQ
         a4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=71ZZ/nQBnwbk1aMA3D066yL5yEXN+z/P3q8vX1qgDEo=;
        b=ihU2OtG7n9JMkQ/0Klx/VrB0HmyDZvDCCShPmy5g23jD+x1Trb2tNuzOXAc0Ji4bmZ
         Qf7F/07KtQqeJg6EmwcvTxkU9TknChHkmzkEqYAlJ3aWBUi+3CtnLBpyQkhT2XlMvZA3
         vIkPbMTYwS2LmfSg6NmaGAiGj7T2+psLs13NDGJcqStciFqXeQ+JrzzvB4XkSxoUMsMr
         PZUb/ObUKu8hRmDJfY4+ZmXvTU8cyHb8E/ZedQLCQhJ/V6zmFwuljFPSPEEnZQAKMhQS
         SqHpZATSoOD8fpkhIIijbbWQXIciSOZSWoIfD+pAAJZIfonEldf5JEgRVi1Rn4zuij7D
         lKlA==
X-Gm-Message-State: AOAM530lb7w/gDzUhWy2H/u/yFSvNI+JWLr4R3i2JbW/8tSBYcqcaGrs
        zmiv3Zs8w7X1RcXX/WiaRMjcnX9PiQMMGkAqrao=
X-Google-Smtp-Source: ABdhPJySPg+LJ2sawuVSs9eejWwx71N6oU3MpgRC+jFAMvM0FGp9tLLsxvtP7fDdprupbgmlv88L2377wDx1eqA2Vvw=
X-Received: by 2002:a25:d691:: with SMTP id n139mr1371030ybg.27.1627597751164;
 Thu, 29 Jul 2021 15:29:11 -0700 (PDT)
MIME-Version: 1.0
References: <5afe26c6-7ab1-88ab-a3e0-eb007256a856@iogearbox.net>
 <20210728164741.350370-1-johan.almbladh@anyfinetworks.com>
 <1503e9c4-7150-3244-4710-7b6b2d59e0da@fb.com> <CAM1=_QTQeTp7LF-XdrOG_qjKpPJ-oQ24kKnG_7MDSbA7LX+uoA@mail.gmail.com>
In-Reply-To: <CAM1=_QTQeTp7LF-XdrOG_qjKpPJ-oQ24kKnG_7MDSbA7LX+uoA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Jul 2021 15:29:00 -0700
Message-ID: <CAEf4BzbYbSAqU91r8RzXWWR81mq9kwJ0=r8-1aRU1UaeDqxMeg@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix off-by-one in tail call count limiting
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 2:38 PM Johan Almbladh
<johan.almbladh@anyfinetworks.com> wrote:
>
> On Wed, Jul 28, 2021 at 9:13 PM Yonghong Song <yhs@fb.com> wrote:
> > I also checked arm/arm64 jit. I saw the following comments:
> >
> >          /* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
> >           *      goto out;
> >           * tail_call_cnt++;
> >           */
> >
> > Maybe we have this MAX_TAIL_CALL_CNT + 1 issue
> > for arm/arm64 jit?
>
> That wouldn't be unreasonable. I don't have an arm or arm64 setup
> available right now, but I can try to test it in qemu.

On a brief check, there seems to be quite a mess in terms of the code
and comments.

E.g., in arch/x86/net/bpf_jit_comp32.c:

        /*
         * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
         *     goto out;
         */

                            ^^^^ here comment is wrong

        [...]

        /* cmp edx,hi */
        EMIT3(0x83, add_1reg(0xF8, IA32_EBX), hi);
        EMIT2(IA32_JNE, 3);
        /* cmp ecx,lo */
        EMIT3(0x83, add_1reg(0xF8, IA32_ECX), lo);

        /* ja out */
        EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));

        ^^^ JAE is >=, right? But the comment says JA.


As for arch/x86/net/bpf_jit_comp.c, both comment and the code seem to
do > MAX_TAIL_CALL_CNT, but you are saying JIT is correct. What am I
missing?

Can you please check all the places where MAX_TAIL_CALL_CNT is used
throughout the code? Let's clean this up in one go.

Also, given it's so easy to do this off-by-one error, can you please
add a negative test validating that 33 tail calls are not allowed? I
assume we have a positive test that allows exactly MAX_TAIL_CALL_CNT,
but please double-check that as well.

I also wonder if it would make sense to convert these
internal-but-sort-of-advertised constants like MAX_TAIL_CALL_CNT and
BPF_COMPLEXITY_LIMIT_INSNS into enums so that they can be "discovered"
from BTF. This should be discussed/attempted outside of this fix,
though. Just bringing it up here.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1479264AA5E
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 23:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbiLLWfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 17:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbiLLWff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 17:35:35 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AE93886;
        Mon, 12 Dec 2022 14:35:35 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id s7so13616303plk.5;
        Mon, 12 Dec 2022 14:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mzGWl9NbNab0/cvXriuWvS+/VwjtyPgYG+89ik87v1k=;
        b=qlgEfpnoW8gJaCNB4KKrm5dS038kcOmt4a+SMi7A5RD91MfAizfibgXKh/Df/62W49
         Z0tAegm03FedMwxkEMBzD/W1FA5iMe+BGxxQcvUkpizGjQzGNrABVNWfuFNS2lgardw1
         zzaQdZhF2yXPiq3ELIOeDrskuRA48MyhiFrHhm2pXW73Y1l7i44QIKYUiVQ9XM4cCOCm
         SszlmtTP6ETnaymJwbROhI1Pz2KmrIXY+9vOBrlP0zWk2c14+1S5k5Hn1f5OT85z8uME
         r/2Axv3QJCr11+eFFNvSXEAXkMEas9cxUIuYKM15iblMeUKL+9SKtsTOvE49ecu5Jc1s
         XjQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mzGWl9NbNab0/cvXriuWvS+/VwjtyPgYG+89ik87v1k=;
        b=ns+eRXy6on2sBP+zlxHdEIBLyE1c8F6Un8Zd6oWSs/bhxroCFEX/COTORQNg4aKIw8
         HJ8KkEYsPHAqy67+icP+4YMmUbUpV81HbQZUPK84F579F1J/iJC74ytP0RZk9EYK3GjD
         gamKkmZoLa5xioCC4VwmNEU4SnfHIwMmSaen/uKM10dkRINsBx5S74GOubymYc0v9xYv
         5KIxasyu4BvO7FgHod/jw+UX4Y7soOe4WFzIe7Lrl6fCzt+KgTN0VK/fqx0PpYufJtOo
         6ooNfq9tCTBpBdz7PQPO5m56IXI18COx+z5YCBgB0VQxqy0OwsK5kfcowW6ogBvNuwlc
         rAIg==
X-Gm-Message-State: ANoB5pmyf5+A3aBbj0oKdIMDF8P19jQKiLrlFlfL1zVFrImNKjzCv7zx
        MH4nUSDvnAqKwlGAQMmexOaeBAit4UZWTV/4dQE=
X-Google-Smtp-Source: AA0mqf5AQvhfFF0eknZ3EkeuoiFDWyTCzTrWUL7QtzqX7Wu/L0Laykp9ma9U3vKOsByuEUeIs+p8jBIL5D/LnsePgHk=
X-Received: by 2002:a17:90b:3d89:b0:219:ef00:9ffe with SMTP id
 pq9-20020a17090b3d8900b00219ef009ffemr67918pjb.106.1670884534849; Mon, 12 Dec
 2022 14:35:34 -0800 (PST)
MIME-Version: 1.0
References: <cover.1670778651.git.david.keisarschm@mail.huji.ac.il>
 <7c16cafe96c47ff5234fbb980df9d3e3d48a0296.1670778652.git.david.keisarschm@mail.huji.ac.il>
 <01ade45b-8ca6-d584-199b-a06778038356@meta.com>
In-Reply-To: <01ade45b-8ca6-d584-199b-a06778038356@meta.com>
From:   Amit Klein <aksecurity@gmail.com>
Date:   Tue, 13 Dec 2022 00:35:24 +0200
Message-ID: <CANEQ_+KDR+kC=hYhTtNeQuSTp+-Dg0tRx-9MzJKQ2zH++fBGyQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] Replace invocation of weak PRNG in kernel/bpf/core.c
To:     Yonghong Song <yhs@meta.com>
Cc:     david.keisarschm@mail.huji.ac.il,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ilay.bahat1@gmail.com,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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

On Mon, Dec 12, 2022 at 8:03 PM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 12/11/22 2:16 PM, david.keisarschm@mail.huji.ac.il wrote:
> > From: David <david.keisarschm@mail.huji.ac.il>
> >
> > We changed the invocation of
> >   prandom_u32_state to get_random_u32.
> >   We deleted the maintained state,
> >   which was a CPU-variable,
> >   since get_random_u32 maintains its own CPU-variable.
> >   We also deleted the state initializer,
> >   since it is not needed anymore.
> >
> > Signed-off-by: David <david.keisarschm@mail.huji.ac.il>
> > ---
> >   include/linux/bpf.h   |  1 -
> >   kernel/bpf/core.c     | 13 +------------
> >   kernel/bpf/verifier.c |  2 --
> >   net/core/filter.c     |  1 -
> >   4 files changed, 1 insertion(+), 16 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
[...]
> Please see the discussion here.
> https://lore.kernel.org/bpf/87edtctz8t.fsf@toke.dk/
> There is a performance concern with the above change.
>

I see. How about using (in this instance only!) the SipHash-based
solution which was the basis for prandom_u32() starting with commit
c51f8f88d705 (v5.10-rc1) up until commit d4150779e60f (v5.19-rc1)?
Copying the relevant snippets (minus comments, for brevity) from
/lib/random32.c and /include/linux/prandom.h from that era (the 32
random bits are generated by prandom_u32() at the bottom; I didn't
bother with initialization, and I don't know if the per_cpu logic is
needed here, or perhaps some other kind of locking, if any):


#define PRND_SIPROUND(v0, v1, v2, v3) ( \
v0 += v1, v1 = rol32(v1, 5), v2 += v3, v3 = rol32(v3, 8), \
v1 ^= v0, v0 = rol32(v0, 16), v3 ^= v2, \
v0 += v3, v3 = rol32(v3, 7), v2 += v1, v1 = rol32(v1, 13), \
v3 ^= v0, v1 ^= v2, v2 = rol32(v2, 16) \

)

struct siprand_state {
    unsigned long v0;
    unsigned long v1;
    unsigned long v2;
    unsigned long v3;
};

static DEFINE_PER_CPU(struct siprand_state, net_rand_state)
__latent_entropy;   // do we actually need this? -AK

static inline u32 siprand_u32(struct siprand_state *s)
{
    unsigned long v0 = s->v0, v1 = s->v1, v2 = s->v2, v3 = s->v3;

    PRND_SIPROUND(v0, v1, v2, v3);
    PRND_SIPROUND(v0, v1, v2, v3);
    s->v0 = v0;  s->v1 = v1;  s->v2 = v2;  s->v3 = v3;
    return v1 + v3;
}


u32 prandom_u32(void)
{
    struct siprand_state *state = get_cpu_ptr(&net_rand_state);
    u32 res = siprand_u32(state);

    trace_prandom_u32(res);
    put_cpu_ptr(&net_rand_state);
    return res;
}
EXPORT_SYMBOL(prandom_u32);

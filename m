Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAC34BA878
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbiBQSh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:37:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiBQSh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:37:58 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C905642E
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:37:41 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id a42so725799ljq.13
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6yxC89IdHow+evEPU8I4jfR6TBaubPEKo1t8AkqK3k8=;
        b=C0GRmY5VXmFVstoRUZkcC9c69p9lcAe4A23o5s/lbTL4Cr8QIZ8cE0V8ZZ6CWhQl0E
         k7CXm09mJotHhntqH9R3dGJejhrforLCewyPpH0kDQkd4wq2ZQnMJOMGxUfEb9yYg7lG
         4D/dsNy82Z+rrGC7i8VoU2N0h5cMf70GH6g2BhGc+Lvc5jYLrUMAhQ4noRCOVhGfz1e0
         x/6CrdMIlwpILtWu9pF7TEjNGOYyyRXEQhc6biBlVaOaLwlC4WaR1hOdwfWN/y3ARSTx
         0jT4Q8s8kKSQSCb6l4z0qsyzfB4h0hLQiQwCigNlmQJ2R5IsWHIZojhJRd3e0khuVGcc
         IB9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6yxC89IdHow+evEPU8I4jfR6TBaubPEKo1t8AkqK3k8=;
        b=pMoPaIARW2zVD4F06y+dt3VDP5xLaf+v9w581IoDjHXZxyNMohVyUD/hufIFEb8wjf
         VywSvK82NxP27ISwFJiqdnRz7nFWb33PgRiP2owMvIqeDGTEzQs6jGRhswWS0O+tk7Bu
         6i6J1PyNRy4uE2jVlnWtdp0U0I+skTwbekv9vJdK/lfaMlatoLSgVCDG3JLalW6z3r0l
         duvzkGlDc/oJb4DrU5+c80jbw+FoYggl7ACJH16wEFp6BLBCSG7B79dkQPXBb3RcamsK
         Q3lXIhHBmsSFpbB5mi1X4Mtnpgj7BluP1Q35DbfUDuWRAKMjaXwCdpE6lQK4NNx1Qfwq
         eAYA==
X-Gm-Message-State: AOAM530kk555n0cgCnKwu4ge43GCUGkvSdKgByMjRa2/1atxJXcZon3C
        oqdAIkbTCIlCHZZHBdlRV1vI6YympaH8cnzol+41XRrgXxo=
X-Google-Smtp-Source: ABdhPJzHsEb0AHOZBFWdnAp7qFJpo52ZdgaeLdSwTSKiD20hiDXP17Iwhjb9YcPpgbh76NgkBcFkAhiwyaXJeH8/AEE=
X-Received: by 2002:a05:651c:1143:b0:230:21db:210b with SMTP id
 h3-20020a05651c114300b0023021db210bmr3189059ljo.394.1645123059542; Thu, 17
 Feb 2022 10:37:39 -0800 (PST)
MIME-Version: 1.0
References: <20220217181902.808742-1-eric.dumazet@gmail.com>
In-Reply-To: <20220217181902.808742-1-eric.dumazet@gmail.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Thu, 17 Feb 2022 10:37:23 -0800
Message-ID: <CAMzD94TTh3FOsG9sPcuDhHxZjDZjuaZjZN6O+0EhOU-bCxUKWA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: add schedule points in batch ops
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Brian Vazquez <brianvv@google.com>


On Thu, Feb 17, 2022 at 10:19 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> syzbot reported various soft lockups caused by bpf batch operations.
>
>  INFO: task kworker/1:1:27 blocked for more than 140 seconds.
>  INFO: task hung in rcu_barrier
>
> Nothing prevents batch ops to process huge amount of data,
> we need to add schedule points in them.
>
> Note that maybe_wait_bpf_programs(map) calls from
> generic_map_delete_batch() can be factorized by moving
> the call after the loop.
>
> This will be done later in -next tree once we get this fix merged,
> unless there is strong opinion doing this optimization sooner.
>
> Fixes: aa2e93b8e58e ("bpf: Add generic support for update and delete batch ops")
> Fixes: cb4d03ab499d ("bpf: Add generic support for lookup batch op")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Brian Vazquez <brianvv@google.com>
> Cc: Stanislav Fomichev <sdf@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
>  kernel/bpf/syscall.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index fa4505f9b6119bcb219ab9733847a98da65d1b21..ca70fe6fba387937dfb54f10826f19ac55a8a8e7 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1355,6 +1355,7 @@ int generic_map_delete_batch(struct bpf_map *map,
>                 maybe_wait_bpf_programs(map);
>                 if (err)
>                         break;
> +               cond_resched();
>         }
>         if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
>                 err = -EFAULT;
> @@ -1412,6 +1413,7 @@ int generic_map_update_batch(struct bpf_map *map,
>
>                 if (err)
>                         break;
> +               cond_resched();
>         }
>
>         if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
> @@ -1509,6 +1511,7 @@ int generic_map_lookup_batch(struct bpf_map *map,
>                 swap(prev_key, key);
>                 retry = MAP_LOOKUP_RETRIES;
>                 cp++;
> +               cond_resched();
>         }
>
>         if (err == -EFAULT)
> --
> 2.35.1.265.g69c8d7142f-goog
>

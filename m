Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525FA5FC6E1
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 16:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJLOAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 10:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiJLOAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 10:00:52 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B296346DA9
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:00:48 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id r22so19436127ljn.10
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7XyabsjW/wJmaeLvPtceOyUXBqFMY1IMZVxCwkvDtNY=;
        b=QxpaRF5Jpuw2TaG9LG69QOXTQvewmUXpTtxRz/6a0EnVKMQTseBFtGZRq7pjoFTnOv
         eHntbiAJLVLYttPHX2FWzrs1imKdw6Qzh5a9ANht588JG1GHYy08hv7Y+WgI7uB6nMF4
         pU2ox1xczhM9te6ozADkHHf021eeU4bQMaKygN0z3XHBEWepcybTUriwrMP6LZ1Gi5Oj
         KsREY6WDduFf71g1j6z8Wqyhms1E0IgbdnFxt3CtpyVkiuAwUnHJ/N73Bt8nFjQPaKUZ
         AIcvZmo+e/cRp+4ANVZrg1GczaT5a+HE8TDtYf0N1GEc19oruhTSGllw6oszAfJvAoQn
         gtQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7XyabsjW/wJmaeLvPtceOyUXBqFMY1IMZVxCwkvDtNY=;
        b=GzX+8oni8Ijk5FnMhMA03rgf8sfZhu2kaYMaIOA3sNtnn4lOg4M19DzIf2MH1HX7fx
         2el9hBYMS6GmbtgSVWR5qBvuW2QSL8+12XjAr3SehKWTiOxmQ3Txk8qYxQ5HMR8dPIxw
         7AsFcj9qGyy23Hg6LDGWmArS+Lu8+w0+bhtCOO5+rbdeO0DKy7GcIKHtshuzcdIHH7ra
         svxn9XgpzUu3dAnUkfwkT7BuSRGfqh6rBJfo69nUfROw4CNKZdsPHckWaXO9VcMRVwYE
         m9WnA1hZwC8Z7hEOdJvL5d7X9CUtDshlQVyNfb8fYuNgLSf9ZliRqJqlDlERKAhiaEot
         48zg==
X-Gm-Message-State: ACrzQf1SnvzsGoK4TUJP1bn+3734kHS3OCFNluPiZa9Nf6vgBRtjyOY/
        RkMEdA1mfm+inlH5KukdUHzRtHCm3/ldzhqQHG45CA==
X-Google-Smtp-Source: AMsMyM4BI0vt4DQRL1aaQ5ozrUqdHIo3ET01olSDcyJ1Uu9ZMhUNlighXyo21D/2m0yjM51H0jHA5OGNXzprX6fLDmA=
X-Received: by 2002:a05:651c:1112:b0:26c:7323:3f2c with SMTP id
 e18-20020a05651c111200b0026c73233f2cmr11405741ljo.4.1665583246694; Wed, 12
 Oct 2022 07:00:46 -0700 (PDT)
MIME-Version: 1.0
References: <20221012133412.519394-1-edumazet@google.com>
In-Reply-To: <20221012133412.519394-1-edumazet@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 12 Oct 2022 16:00:34 +0200
Message-ID: <CACT4Y+YQ39dVh0tbmjzqoNEnS76ucbVYiNrfwjiby-8z6E7UDQ@mail.gmail.com>
Subject: Re: [PATCH net] kcm: avoid potential race in kcm_tx_work
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Tom Herbert <tom@herbertland.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Oct 2022 at 15:34, 'Eric Dumazet' via syzkaller
<syzkaller@googlegroups.com> wrote:
>
> syzbot found that kcm_tx_work() could crash [1] in:
>
>         /* Primarily for SOCK_SEQPACKET sockets */
>         if (likely(sk->sk_socket) &&
>             test_bit(SOCK_NOSPACE, &sk->sk_socket->flags)) {
> <<*>>   clear_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
>                 sk->sk_write_space(sk);
>         }
>
> I think the reason is that another thread might concurrently
> run in kcm_release() and call sock_orphan(sk) while sk is not
> locked. kcm_tx_work() find sk->sk_socket being NULL.

Does it make sense to add some lockdep annotations to sock_orphan()
and maybe some other similar functions to catch such cases earlier?


> [1]
> BUG: KASAN: null-ptr-deref in instrument_atomic_write include/linux/instrumented.h:86 [inline]
> BUG: KASAN: null-ptr-deref in clear_bit include/asm-generic/bitops/instrumented-atomic.h:41 [inline]
> BUG: KASAN: null-ptr-deref in kcm_tx_work+0xff/0x160 net/kcm/kcmsock.c:742
> Write of size 8 at addr 0000000000000008 by task kworker/u4:3/53
>
> CPU: 0 PID: 53 Comm: kworker/u4:3 Not tainted 5.19.0-rc3-next-20220621-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: kkcmd kcm_tx_work
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> kasan_report+0xbe/0x1f0 mm/kasan/report.c:495
> check_region_inline mm/kasan/generic.c:183 [inline]
> kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
> instrument_atomic_write include/linux/instrumented.h:86 [inline]
> clear_bit include/asm-generic/bitops/instrumented-atomic.h:41 [inline]
> kcm_tx_work+0xff/0x160 net/kcm/kcmsock.c:742
> process_one_work+0x996/0x1610 kernel/workqueue.c:2289
> worker_thread+0x665/0x1080 kernel/workqueue.c:2436
> kthread+0x2e9/0x3a0 kernel/kthread.c:376
> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
> </TASK>
>
> Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Tom Herbert <tom@herbertland.com>
> ---
>  net/kcm/kcmsock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
> index 1215c863e1c410fa9ba5b9c3706152decfb3ebac..27725464ec08fe2b5f2e86202636cbc895568098 100644
> --- a/net/kcm/kcmsock.c
> +++ b/net/kcm/kcmsock.c
> @@ -1838,10 +1838,10 @@ static int kcm_release(struct socket *sock)
>         kcm = kcm_sk(sk);
>         mux = kcm->mux;
>
> +       lock_sock(sk);
>         sock_orphan(sk);
>         kfree_skb(kcm->seq_skb);
>
> -       lock_sock(sk);
>         /* Purge queue under lock to avoid race condition with tx_work trying
>          * to act when queue is nonempty. If tx_work runs after this point
>          * it will just return.
> --
> 2.38.0.rc1.362.ged0d419d3c-goog
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/20221012133412.519394-1-edumazet%40google.com.

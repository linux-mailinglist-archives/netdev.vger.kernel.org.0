Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C035FC793
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 16:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJLOjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 10:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiJLOjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 10:39:11 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAE061DA1
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:39:09 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 81so20243223ybf.7
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Iwty6IO2YhJUWtTmIIC3w1X+zwPEtrCB5GqbjID7kbs=;
        b=AyYQdaIpG99rx17v8MMe1/XgQ5Oi5n6hF0MbmcrL+bu3ifAw1kPCeas0u4EaTseVpd
         YxCuLKyySoK8U8uU+IPSxnzEQP4fonSCIkFPBQHgakm/iaOolC1Py6RSgWt3go2Ap4fN
         NYIPNycBmcz8VRKye8EQHtb7NWVaEWuc/qH23bFMSt5K/2dxGoHFmOHj84rf+64DJSa+
         SZOlu5SwSJyXmV6ReXo+LPxsZENawfEipURjUUBTVkQU2I/qvwdRX4gU+DMcx0Aot+Ws
         tAEWrYUw5o9cmNA7DUU1g2gbUsY6Upjru9ifyuU+ONZmzSJqD/9o6j4KgigwEMDeMrGG
         adbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Iwty6IO2YhJUWtTmIIC3w1X+zwPEtrCB5GqbjID7kbs=;
        b=X1jIWMVwA8E81yQiUihf+MPEWZUaK3fIF+LzeFvh3d/P99Ts1ecJ3dHPm9pIENtQhK
         SkcEudjPTJCPGgNXq2JxneY2wKcw4kHesUPXn4/tKoOosK7sgXF5VW++lnasBeSpmbAt
         Ej9Nmi/vy6w/16Ody48geSuYuZPumE1uWUrdQFl0XMY1OK+d/ybt35BdvYj0TGBnwMlj
         GGQptrZTPmTIm+AElU6MVSecql0pthEjpU+xfhV8wQkG3+R99s23Scec6t1kyzdMmtue
         vzG3hgRSj80mVIRJRxdI0TowQlOA7S7AodswJ8T6et0UPIjcJFEyRSTPy8dyj62wEztZ
         cIyw==
X-Gm-Message-State: ACrzQf0CAaO8+XXdm+zT1ohSXrTzV/dcwfN05uST8ONyX7X1lK+b7NK2
        zR3Zj0DJyZxVNVfVBYHe0OvgzZJDxVQHLVq6DRC3RA==
X-Google-Smtp-Source: AMsMyM4u5IATBvJBSVGl7BsAZuT/y6oB0gu+hsUV2HsJFUR9Ex7QjOgaFDdfRS4tKUHKkvrZmt9R4glMSI2lgjfQ7Qk=
X-Received: by 2002:a25:328c:0:b0:6be:2d4a:e77 with SMTP id
 y134-20020a25328c000000b006be2d4a0e77mr27453078yby.407.1665585548486; Wed, 12
 Oct 2022 07:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221012133412.519394-1-edumazet@google.com> <CACT4Y+YQ39dVh0tbmjzqoNEnS76ucbVYiNrfwjiby-8z6E7UDQ@mail.gmail.com>
In-Reply-To: <CACT4Y+YQ39dVh0tbmjzqoNEnS76ucbVYiNrfwjiby-8z6E7UDQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Oct 2022 07:38:57 -0700
Message-ID: <CANn89iJUHnzPa1EBD=eTK7J0R3XqHW=kqXcaCF0MbEzsBO+SEA@mail.gmail.com>
Subject: Re: [PATCH net] kcm: avoid potential race in kcm_tx_work
To:     Dmitry Vyukov <dvyukov@google.com>
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

On Wed, Oct 12, 2022 at 7:00 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Wed, 12 Oct 2022 at 15:34, 'Eric Dumazet' via syzkaller
> <syzkaller@googlegroups.com> wrote:
> >
> > syzbot found that kcm_tx_work() could crash [1] in:
> >
> >         /* Primarily for SOCK_SEQPACKET sockets */
> >         if (likely(sk->sk_socket) &&
> >             test_bit(SOCK_NOSPACE, &sk->sk_socket->flags)) {
> > <<*>>   clear_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
> >                 sk->sk_write_space(sk);
> >         }
> >
> > I think the reason is that another thread might concurrently
> > run in kcm_release() and call sock_orphan(sk) while sk is not
> > locked. kcm_tx_work() find sk->sk_socket being NULL.
>
> Does it make sense to add some lockdep annotations to sock_orphan()
> and maybe some other similar functions to catch such cases earlier?

I thought about that, but this seems net-next material.

>
>
> > [1]
> > BUG: KASAN: null-ptr-deref in instrument_atomic_write include/linux/instrumented.h:86 [inline]
> > BUG: KASAN: null-ptr-deref in clear_bit include/asm-generic/bitops/instrumented-atomic.h:41 [inline]
> > BUG: KASAN: null-ptr-deref in kcm_tx_work+0xff/0x160 net/kcm/kcmsock.c:742
> > Write of size 8 at addr 0000000000000008 by task kworker/u4:3/53
> >
> > CPU: 0 PID: 53 Comm: kworker/u4:3 Not tainted 5.19.0-rc3-next-20220621-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Workqueue: kkcmd kcm_tx_work
> > Call Trace:
> > <TASK>
> > __dump_stack lib/dump_stack.c:88 [inline]
> > dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> > kasan_report+0xbe/0x1f0 mm/kasan/report.c:495
> > check_region_inline mm/kasan/generic.c:183 [inline]
> > kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
> > instrument_atomic_write include/linux/instrumented.h:86 [inline]
> > clear_bit include/asm-generic/bitops/instrumented-atomic.h:41 [inline]
> > kcm_tx_work+0xff/0x160 net/kcm/kcmsock.c:742
> > process_one_work+0x996/0x1610 kernel/workqueue.c:2289
> > worker_thread+0x665/0x1080 kernel/workqueue.c:2436
> > kthread+0x2e9/0x3a0 kernel/kthread.c:376
> > ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
> > </TASK>
> >
> > Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Tom Herbert <tom@herbertland.com>
> > ---
> >  net/kcm/kcmsock.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
> > index 1215c863e1c410fa9ba5b9c3706152decfb3ebac..27725464ec08fe2b5f2e86202636cbc895568098 100644
> > --- a/net/kcm/kcmsock.c
> > +++ b/net/kcm/kcmsock.c
> > @@ -1838,10 +1838,10 @@ static int kcm_release(struct socket *sock)
> >         kcm = kcm_sk(sk);
> >         mux = kcm->mux;
> >
> > +       lock_sock(sk);
> >         sock_orphan(sk);
> >         kfree_skb(kcm->seq_skb);
> >
> > -       lock_sock(sk);
> >         /* Purge queue under lock to avoid race condition with tx_work trying
> >          * to act when queue is nonempty. If tx_work runs after this point
> >          * it will just return.
> > --
> > 2.38.0.rc1.362.ged0d419d3c-goog
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/20221012133412.519394-1-edumazet%40google.com.

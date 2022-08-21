Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8399F59B54C
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 17:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiHUP6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 11:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiHUP6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 11:58:15 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868FDD7C;
        Sun, 21 Aug 2022 08:58:14 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id 62so6601598iov.5;
        Sun, 21 Aug 2022 08:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=jl057+Trbv3ToeVWTsybg5kXr0sDHbVCziecNl2AV6Y=;
        b=gSYXLG0m3nEyXiI/Jq1RB2mepjUqkocLXXiGtLSoFgwxJXH6PuvYrv3JFLRtpkE4yZ
         vN6bnu/cPzJoMtTuKFQHGchDqvdDZjqdZ58E9y1CaVo5LT3VPiKNDzhRagQgK0WedDMK
         2XRBWjPM4VMrwuYmj3a18rCuajEHRbCQvLKPEsLdtoMW2knsGotQHF1ipXy4uxCEcmfx
         zkEoy9u0MWc1br52yfE0eyLXElhZuvhG2yXaFrwcpgAV43unHMsYaRdsJakz3KIHxguc
         p7vVa6wMNNUxzgUDi1Sfb8kSj1gScc0zmfn2LtBOR5mwFhy7DR8mgddZ3M79p7D9MhJt
         AP2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=jl057+Trbv3ToeVWTsybg5kXr0sDHbVCziecNl2AV6Y=;
        b=YQjTDKq9fdERF1rQKMDGduSW5sk5BJx8vsic3mrJtrmntCLA7R2yu5g45Ld+Fyf2+m
         mzeeizM6li7/20PmG7wRdaBRRrU2jQyZOSK6MdfGvSEYmhIiWJKdsYx7uEzlGrqRFcrO
         yW/nl8psKp5DXQ+MzB1uOGjqfV2mETqRlhI+csjJPxUSVU5LK8TWcYMoZIGk7Ik9UItx
         j/hrie7BesyFHfuLLhZhgre7ZeJgJw4oCua9gTNT8TkUUENvsrL6EV9GS0bdd2t9FdKo
         AgELNQLGiAeF78AukyzCQDMum+XDq8vNogb9tasTgnMTV3EqjH+A1hENTDWmB4OUg9Ja
         ofjw==
X-Gm-Message-State: ACgBeo1GYMkbWG8RD+YsCpZ1l1kyhikTnOypiYmnYcVoq+t2zBDoTDXj
        MjxNdoqJN5SOe1M6zIXwKpZiez5pAp6vyA7fyJk/c7imPTs=
X-Google-Smtp-Source: AA6agR6eQf/e2pEF818vApDCSFB8aXweqxuUn+lxjrAQ5KWz/mhdyriIpsoGD5KP2qmT9XOsR02iY8GYLa4BmuoYFfE=
X-Received: by 2002:a05:6602:1343:b0:689:2942:9b57 with SMTP id
 i3-20020a056602134300b0068929429b57mr6999688iov.75.1661097493907; Sun, 21 Aug
 2022 08:58:13 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000ce327f05d537ebf7@google.com> <20220821125751.4185-1-yin31149@gmail.com>
In-Reply-To: <20220821125751.4185-1-yin31149@gmail.com>
From:   Khalid Masum <khalid.masum.92@gmail.com>
Date:   Sun, 21 Aug 2022 21:58:02 +0600
Message-ID: <CAABMjtF2GeNyTf6gQ1hk0BiXKY9HWQStBAk_R3w6MCFQ3bOYzA@mail.gmail.com>
Subject: Re: [PATCH] rxrpc: fix bad unlock balance in rxrpc_do_sendmsg
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        linux-afs@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 21, 2022 at 6:58 PM Hawkins Jiawei <yin31149@gmail.com> wrote:
>
> Syzkaller reports bad unlock balance bug as follows:
> ------------[ cut here ]------------
> WARNING: bad unlock balance detected!
> syz-executor.0/4094 is trying to release lock (&call->user_mutex) at:
> [<ffffffff87c1d8d1>] rxrpc_do_sendmsg+0x851/0x1110 net/rxrpc/sendmsg.c:754
> but there are no more locks to release!
>
> other info that might help us debug this:
> no locks held by syz-executor.0/4094.
>
> stack backtrace:
> [...]
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x57/0x7d lib/dump_stack.c:106
>  print_unlock_imbalance_bug include/trace/events/lock.h:69 [inline]
>  __lock_release kernel/locking/lockdep.c:5333 [inline]
>  lock_release.cold+0x49/0x4e kernel/locking/lockdep.c:5686
>  __mutex_unlock_slowpath+0x99/0x5e0 kernel/locking/mutex.c:907
>  rxrpc_do_sendmsg+0x851/0x1110 net/rxrpc/sendmsg.c:754
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg+0xab/0xe0 net/socket.c:734
>  ____sys_sendmsg+0x5c2/0x7a0 net/socket.c:2485
>  ___sys_sendmsg+0xdb/0x160 net/socket.c:2539
>  __sys_sendmsg+0xc3/0x160 net/socket.c:2568
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  [...]
>  </TASK>
> ------------------------------------
>
> When kernel wants to send a message through an RxRPC socket in
> rxrpc_do_sendmsg(), kernel should hold the call->user_mutex lock,
> or it will triggers bug when releasing this lock before returning
> from rxrpc_do_sendmsg().
>
> Yet the problem is that during rxrpc_do_sendmsg(), kernel may call
> rxrpc_wait_for_tx_window_intr() to wait for space to appear in the
> tx queue or a signal to occur. When kernel fails the
> mutex_lock_interruptible(), kernel will returns from the
> rxrpc_wait_for_tx_window_intr() without acquiring the mutex lock, then
> triggers bug when releasing the mutex lock in rxrpc_do_sendmsg().
>
> This patch solves it by acquiring the call->user_mutex lock, when
> kernel fails the mutex_lock_interruptible() before returning from
> the rxrpc_wait_for_tx_window_intr().
>
> Reported-and-tested-by: syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com
> Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
> ---
>  net/rxrpc/sendmsg.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
> index 1d38e279e2ef..e13043d357d5 100644
> --- a/net/rxrpc/sendmsg.c
> +++ b/net/rxrpc/sendmsg.c
> @@ -53,8 +53,10 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
>                 trace_rxrpc_transmit(call, rxrpc_transmit_wait);
>                 mutex_unlock(&call->user_mutex);
>                 *timeo = schedule_timeout(*timeo);
> -               if (mutex_lock_interruptible(&call->user_mutex) < 0)
> +               if (mutex_lock_interruptible(&call->user_mutex) < 0) {
> +                       mutex_lock(&call->user_mutex);

The interruptible version fails to acquire the lock. So why is it okay to
force it to acquire the mutex_lock since we are in the interrupt context?
>                         return sock_intr_errno(*timeo);
> +               }
>         }
>  }

thanks,
  -- Khalid Masum

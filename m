Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310656329EE
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 17:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiKUQrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 11:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiKUQrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 11:47:31 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CCF2BC9
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 08:47:29 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-37063f855e5so119295457b3.3
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 08:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wpz46GpUf85XyJC706goOrpSFWBrsB/hhiJ+50gJggk=;
        b=VQfMy3CbZa/BsgICUywM22OGXmD60s1DqaY/tvMFKRjVz7C6hst6eUY6jeoRk+y8KD
         PCvkpXhzHCyskmarVQi87QMXmyA4W6KD8Uj2xNfsFMMkzdJRIgcgPafnqnmTJhhXjvhk
         exEeAynn1X+iPfRkbM1bWZT5mRqm5Y86F7+36+In2qN2i9zWCI9MEpd0ZYo8nhbIOclR
         Exovyjar6XzMmxJZlxtHsjpKOurDhrM7IlfRnEB4bIuKLg87pe5emLO5/NSb8fdP2exU
         elpt5ntVOX1C8CG+iADKZS6II6kie0Zuk12z1IAFGfzxoG9dS4tZNenjLnyY836aLD4Y
         ftXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wpz46GpUf85XyJC706goOrpSFWBrsB/hhiJ+50gJggk=;
        b=hGOFhAoVYPEsMpNriFFZfGJJHUwk9NYkwbH1qDsmC6z0XXFsAEWZqR1O/iQo8JjiR4
         zlPCGbQjotvAQMagmouNYpqhs6x/sf1TA5i/saaK0rZTQ3t2gFf64ihlXOk1GDllth9T
         kAUjGj8/6GUrgqYz0Qz0brs5+7sB6JX7UBenyIKfYIMzki26x2jBTi1irsrZSYNPgYT8
         4JiT4v12lVq597yGtrdjwZAYJT1sH20ijx61lQ0f31WtMPBGmZV90Zc65FfajnN346cr
         slg0+CFguhordUkbM2e03qwHCl/LIAmiLfxkjKoUItfJdA0qqBBOLD+nc873uXe0zYhv
         e3lw==
X-Gm-Message-State: ANoB5pnU6rQHaAqF/KxVbCceVDWzgPS94MID88tS0NrPib5Vg7LHIgFl
        uT+qIUp1/Ink3AKhUljLkQpJfpICjoB2e+WV++XihQ==
X-Google-Smtp-Source: AA0mqf5EyMIMmgnP8mk7235pVX9j8DOd32u6K6FXjYuxZrD9VEeiToW3iCdc/L1kyEi6fvlMqeUBe6Q9S8zB10vpjSE=
X-Received: by 2002:a05:690c:a92:b0:36c:aaa6:e571 with SMTP id
 ci18-20020a05690c0a9200b0036caaa6e571mr17931945ywb.467.1669049248861; Mon, 21
 Nov 2022 08:47:28 -0800 (PST)
MIME-Version: 1.0
References: <20221120090213.922567-1-syoshida@redhat.com>
In-Reply-To: <20221120090213.922567-1-syoshida@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Nov 2022 08:47:17 -0800
Message-ID: <CANn89iLy3zBDN-y0JB_FJ9Mnmr5N0OguvHRfjVhyXELEpLREMw@mail.gmail.com>
Subject: Re: [PATCH v2] net: tun: Fix use-after-free in tun_detach()
To:     Shigeru Yoshida <syoshida@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+106f9b687cd64ee70cd1@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 20, 2022 at 1:02 AM Shigeru Yoshida <syoshida@redhat.com> wrote:
>
> syzbot reported use-after-free in tun_detach() [1].  This causes call
> trace like below:
>
> ==================================================================
> BUG: KASAN: use-after-free in notifier_call_chain+0x1ee/0x200 kernel/notifier.c:75
> Read of size 8 at addr ffff88807324e2a8 by task syz-executor.0/3673
>
> CPU: 0 PID: 3673 Comm: syz-executor.0 Not tainted 6.1.0-rc5-syzkaller-00044-gcc675d22e422 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>  print_address_description mm/kasan/report.c:284 [inline]
>  print_report+0x15e/0x461 mm/kasan/report.c:395
>  kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
>  notifier_call_chain+0x1ee/0x200 kernel/notifier.c:75
>  call_netdevice_notifiers_info+0x86/0x130 net/core/dev.c:1942
>  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
>  call_netdevice_notifiers net/core/dev.c:1997 [inline]
>  netdev_wait_allrefs_any net/core/dev.c:10237 [inline]
>  netdev_run_todo+0xbc6/0x1100 net/core/dev.c:10351
>  tun_detach drivers/net/tun.c:704 [inline]
>  tun_chr_close+0xe4/0x190 drivers/net/tun.c:3467
>  __fput+0x27c/0xa90 fs/file_table.c:320
>  task_work_run+0x16f/0x270 kernel/task_work.c:179
>  exit_task_work include/linux/task_work.h:38 [inline]
>  do_exit+0xb3d/0x2a30 kernel/exit.c:820
>  do_group_exit+0xd4/0x2a0 kernel/exit.c:950
>  get_signal+0x21b1/0x2440 kernel/signal.c:2858
>  arch_do_signal_or_restart+0x86/0x2300 arch/x86/kernel/signal.c:869
>  exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
>  exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
>  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
>  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> The cause of the issue is that sock_put() from __tun_detach() drops
> last reference count for struct net, and then notifier_call_chain()
> from netdev_state_change() accesses that struct net.
>
> This patch fixes the issue by calling sock_put() from tun_detach()
> after all necessary accesses for the struct net has done.
>
> Fixes: 83c1f36f9880 ("tun: send netlink notification when the device is modified")
> Reported-by: syzbot+106f9b687cd64ee70cd1@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=96eb7f1ce75ef933697f24eeab928c4a716edefe [1]
> Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
> ---
> v2:
> - Include symbolic stack trace
> - Add Fixes and Reported-by tags
> v1: https://lore.kernel.org/all/20221119075615.723290-1-syoshida@redhat.com/
> ---
>  drivers/net/tun.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 7a3ab3427369..ce9fcf4c8ef4 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -686,7 +686,6 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>                 if (tun)
>                         xdp_rxq_info_unreg(&tfile->xdp_rxq);
>                 ptr_ring_cleanup(&tfile->tx_ring, tun_ptr_free);
> -               sock_put(&tfile->sk);
>         }
>  }
>
> @@ -702,6 +701,11 @@ static void tun_detach(struct tun_file *tfile, bool clean)
>         if (dev)
>                 netdev_state_change(dev);
>         rtnl_unlock();
> +
> +       if (clean) {

Would you mind explaining (a comment would be nice) why this barrier is needed ?

Thanks.

> +               synchronize_rcu();
> +               sock_put(&tfile->sk);
> +       }
>  }
>
>  static void tun_detach_all(struct net_device *dev)
> --
> 2.38.1
>

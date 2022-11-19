Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22031631048
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 19:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbiKSSbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 13:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiKSSbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 13:31:52 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A6510FCC
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 10:31:50 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id p81so1580594yba.4
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 10:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IWUt2aOgdPhBZTsItNj8gJnhW81NAJJXG1h3QcsUyVE=;
        b=N5WlWPU9BX7vv2x+RIeDT7v+Yo6NfOHsEcFInqqwnwM+vXNh1t48AH2NKhoIEAsHfj
         nu7eoa01HyWaZrBVpGucrPKrPT9jHfiO45IMktrrgyVIE6uUAJYM/V+xXCCYfBXFGzBU
         hpVsxZ97aIQM0rgxTG0GSHwU9ETx5krWvU4e7rcFxTNh0AGncNmTs43NMT6GfQPVuE/Z
         viZwb1loHDTQ4r96X/FoUBjQGplcFLRJKUp2nq9h1IXC6VQnM597jY2Cgsd+ZMMJadfq
         iL0yP/hSvfnAnuH7WcVhstDTbF85ueWn2dmfHkqag8s9etQsUHbP41rsHFjgZ2hcI01F
         8Imw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IWUt2aOgdPhBZTsItNj8gJnhW81NAJJXG1h3QcsUyVE=;
        b=bxxSXOwpEHiwbhqqUsH5fB5C3Mz1qwisotaNywuS+15bxHUQoGTmdPSxr1DDharQ3q
         U9RNNU1udWRaf9p1eYZrObDCZiIIvKOraTDcFB2Ul8MQ+tfP/pS0jvXtMpAEETCcyl+B
         PtYu+lsKvRXEm9Q+njOOWyWT4Dyk6ZXZu8uDu5VEGcNbs5pl+DOzVQOsZubtmcY2mr3v
         YPw/BMvkN6S7CBox2OCcGE/qQkGvHjuMBH6PSRG+OpeHZTRzFCicz+FIYEGliVXjIf0a
         kF0EZpL3ahgmUPWA1/18LEnQZDOnnhw9Uo9iqNYHO1M7ZtsLy6i+3q5BOu9mKSczFi4P
         ahhg==
X-Gm-Message-State: ANoB5pmaaSo2lkT67TBAbenlxCKbTP+FwfuHhYT9OqKLFX/O8QUM64rv
        3s3o4uZ5W5T7ih0n+huyvQvuWILENHflbmFC6etRuA==
X-Google-Smtp-Source: AA0mqf7himSJWw2WH+wJoCMfe17olO+sSx8RKZ0+K0aeWJ/y8rTVj0vpiFQTaypQ3cIKsKZahKKAd3CgnlkJxRnsI7Q=
X-Received: by 2002:a25:348c:0:b0:6cb:ec87:a425 with SMTP id
 b134-20020a25348c000000b006cbec87a425mr10439320yba.387.1668882709536; Sat, 19
 Nov 2022 10:31:49 -0800 (PST)
MIME-Version: 1.0
References: <20221119075615.723290-1-syoshida@redhat.com>
In-Reply-To: <20221119075615.723290-1-syoshida@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 19 Nov 2022 10:31:38 -0800
Message-ID: <CANn89iJaCRMb-vSrBOV_zbjxq8Gpg7K3d031AECmEqSN-XWpkA@mail.gmail.com>
Subject: Re: [PATCH] net: tun: Fix use-after-free in tun_detach()
To:     Shigeru Yoshida <syoshida@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
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

On Fri, Nov 18, 2022 at 11:56 PM Shigeru Yoshida <syoshida@redhat.com> wrote:
>
> syzbot reported use-after-free in tun_detach() [1].  This causes call
> trace like below:
>
> ==================================================================
> BUG: KASAN: use-after-free in notifier_call_chain+0x1da/0x1e0
> ...
> Call Trace:

Please include a symbolic stack trace, I think syzbot has them.

>  <TASK>
>  dump_stack_lvl+0x100/0x178
>  print_report+0x167/0x470
>  ? __virt_addr_valid+0x5e/0x2d0
>  ? __phys_addr+0xc6/0x140
>  ? notifier_call_chain+0x1da/0x1e0
>  ? notifier_call_chain+0x1da/0x1e0
>  kasan_report+0xbf/0x1e0
>  ? notifier_call_chain+0x1da/0x1e0
>  notifier_call_chain+0x1da/0x1e0
>  call_netdevice_notifiers_info+0x83/0x130
>  netdev_run_todo+0xc33/0x11b0
>  ? generic_xdp_install+0x490/0x490
>  ? __tun_detach+0x1500/0x1500
>  tun_chr_close+0xe2/0x190
>  __fput+0x26a/0xa40
>  task_work_run+0x14d/0x240
>  ? task_work_cancel+0x30/0x30
>  do_exit+0xb31/0x2a40
>  ? reacquire_held_locks+0x4a0/0x4a0
>  ? do_raw_spin_lock+0x12e/0x2b0
>  ? mm_update_next_owner+0x7c0/0x7c0
>  ? rwlock_bug.part.0+0x90/0x90
>  ? lockdep_hardirqs_on_prepare+0x17f/0x410
>  do_group_exit+0xd4/0x2a0
>  __x64_sys_exit_group+0x3e/0x50
>  do_syscall_64+0x38/0xb0
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> The cause of the issue is that sock_put() from __tun_detach() drops
> last reference count for struct net, and then notifier_call_chain()
> from netdev_state_change() accesses that struct net.
>
> This patch fixes the issue by calling sock_put() from tun_detach()
> after all necessary accesses for the struct net has done.
>
> Link: https://syzkaller.appspot.com/bug?id=96eb7f1ce75ef933697f24eeab928c4a716edefe [1]
> Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>

Please add a Fixes: tag, once you identified which commit added this bug.

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
> +               synchronize_rcu();
> +               sock_put(&tfile->sk);
> +       }
>  }
>
>  static void tun_detach_all(struct net_device *dev)
> --
> 2.38.1
>

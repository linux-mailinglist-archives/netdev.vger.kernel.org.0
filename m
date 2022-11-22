Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B1B6343EC
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbiKVSrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbiKVSrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:47:14 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5E07FC2C
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:47:13 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id b131so18346554yba.11
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dTOA9Ph35CYeJ8dbWo1cP4Zrrfu9iAGIJB5Su8F8/h8=;
        b=C5YtO03xDsrZ8sonthtSzPrBMVSXWomGZmMAtFkFeyOeWQqusJQYrHZcAcPZKJgeBl
         xnvGhCWfr30rghBTk/W/RIIMuG/0CgHPXapTYX+Ioqkbl8q7qMTLiCYBrrPN1pPviPYF
         aMJ6Cui/L9IerPuKBLHSed8o0zgztTrlQolKQC4T1LDV3CfVMkFsKz1eepmWvCxAdymK
         JXlP0X+fy5yu95kKSTI98kUUHp1D/Z/aTUM03Ho7Kq1kdjnWd9iOkra65P+JYrk1yofR
         FRtbtc0ktvqweM2H753Yucj/3yHJS80Id6RR8TvRjmT8t9Vwl6VNaa9RTMYHapN8Apof
         lOZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dTOA9Ph35CYeJ8dbWo1cP4Zrrfu9iAGIJB5Su8F8/h8=;
        b=AN8LzbdaggEazVt2Hl8sZqcZh2jUH8eVVOXgAII+rppQfkSd/bCAV7Z6vP+OSwWMzU
         6QhXerlnoAK1XlvxqSWFhKJ0Kigy7xX+NQLAQFpLkNMrusN3jUljbnxOjm5sHiM8nBaG
         FwG8ExMOcHjiA8iewo+dJD48/s4o6RLu4EQhfw/YOa7ubqs4X9sU/ubPvQtJHhbeK4NY
         WD3SYY4QPgn+Pum0bnMd9IWDDyNzMrJGVgQFf3d8AYXWbCeJ4r0DfHgP9PUnHc9WaJyS
         gy+8XvxQHAIVCrXZJYZ5lZfuM+PXomcqiarIMs8k5/LQvLm4DOMlGOrprINZU/apPlx8
         gq4w==
X-Gm-Message-State: ANoB5pk4VRoVkMk3OjItwgZogL/e6+lybogFUA9c0MhuljbpyUTTyQ5f
        aDwr3Beis9grR+af3QaMKJsU4/dmUyk0b4zH4OQ9mg==
X-Google-Smtp-Source: AA0mqf5WNe9llKT+N0TL0EfvDLU9nHv38RyeLQsGH4yX3TOpkduZi81IigeCJsQN+pc88l2NUuZvs5sQi2LUyHuC2m8=
X-Received: by 2002:a25:d914:0:b0:6e1:547c:7a43 with SMTP id
 q20-20020a25d914000000b006e1547c7a43mr22973792ybg.231.1669142832207; Tue, 22
 Nov 2022 10:47:12 -0800 (PST)
MIME-Version: 1.0
References: <20221120090213.922567-1-syoshida@redhat.com> <CANn89iLy3zBDN-y0JB_FJ9Mnmr5N0OguvHRfjVhyXELEpLREMw@mail.gmail.com>
 <20221123.031005.476714651315933198.syoshida@redhat.com>
In-Reply-To: <20221123.031005.476714651315933198.syoshida@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 22 Nov 2022 10:47:01 -0800
Message-ID: <CANn89iKQVvaHN+QXxmvk+Cm2vauHNcPRyh3ee_F=JH8coUQnnA@mail.gmail.com>
Subject: Re: [PATCH v2] net: tun: Fix use-after-free in tun_detach()
To:     Shigeru Yoshida <syoshida@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+106f9b687cd64ee70cd1@syzkaller.appspotmail.com
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

On Tue, Nov 22, 2022 at 10:10 AM Shigeru Yoshida <syoshida@redhat.com> wrote:
>
> Hi Eric,
>
> On Mon, 21 Nov 2022 08:47:17 -0800, Eric Dumazet wrote:
> > On Sun, Nov 20, 2022 at 1:02 AM Shigeru Yoshida <syoshida@redhat.com> wrote:
> >>
> >> syzbot reported use-after-free in tun_detach() [1].  This causes call
> >> trace like below:
> >>
> >> ==================================================================
> >> BUG: KASAN: use-after-free in notifier_call_chain+0x1ee/0x200 kernel/notifier.c:75
> >> Read of size 8 at addr ffff88807324e2a8 by task syz-executor.0/3673
> >>
> >> CPU: 0 PID: 3673 Comm: syz-executor.0 Not tainted 6.1.0-rc5-syzkaller-00044-gcc675d22e422 #0
> >> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> >> Call Trace:
> >>  <TASK>
> >>  __dump_stack lib/dump_stack.c:88 [inline]
> >>  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
> >>  print_address_description mm/kasan/report.c:284 [inline]
> >>  print_report+0x15e/0x461 mm/kasan/report.c:395
> >>  kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
> >>  notifier_call_chain+0x1ee/0x200 kernel/notifier.c:75
> >>  call_netdevice_notifiers_info+0x86/0x130 net/core/dev.c:1942
> >>  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
> >>  call_netdevice_notifiers net/core/dev.c:1997 [inline]
> >>  netdev_wait_allrefs_any net/core/dev.c:10237 [inline]
> >>  netdev_run_todo+0xbc6/0x1100 net/core/dev.c:10351
> >>  tun_detach drivers/net/tun.c:704 [inline]
> >>  tun_chr_close+0xe4/0x190 drivers/net/tun.c:3467
> >>  __fput+0x27c/0xa90 fs/file_table.c:320
> >>  task_work_run+0x16f/0x270 kernel/task_work.c:179
> >>  exit_task_work include/linux/task_work.h:38 [inline]
> >>  do_exit+0xb3d/0x2a30 kernel/exit.c:820
> >>  do_group_exit+0xd4/0x2a0 kernel/exit.c:950
> >>  get_signal+0x21b1/0x2440 kernel/signal.c:2858
> >>  arch_do_signal_or_restart+0x86/0x2300 arch/x86/kernel/signal.c:869
> >>  exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> >>  exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
> >>  __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
> >>  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
> >>  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
> >>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >>
> >> The cause of the issue is that sock_put() from __tun_detach() drops
> >> last reference count for struct net, and then notifier_call_chain()
> >> from netdev_state_change() accesses that struct net.
> >>
> >> This patch fixes the issue by calling sock_put() from tun_detach()
> >> after all necessary accesses for the struct net has done.
> >>
> >> Fixes: 83c1f36f9880 ("tun: send netlink notification when the device is modified")
> >> Reported-by: syzbot+106f9b687cd64ee70cd1@syzkaller.appspotmail.com
> >> Link: https://syzkaller.appspot.com/bug?id=96eb7f1ce75ef933697f24eeab928c4a716edefe [1]
> >> Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
> >> ---
> >> v2:
> >> - Include symbolic stack trace
> >> - Add Fixes and Reported-by tags
> >> v1: https://lore.kernel.org/all/20221119075615.723290-1-syoshida@redhat.com/
> >> ---
> >>  drivers/net/tun.c | 6 +++++-
> >>  1 file changed, 5 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >> index 7a3ab3427369..ce9fcf4c8ef4 100644
> >> --- a/drivers/net/tun.c
> >> +++ b/drivers/net/tun.c
> >> @@ -686,7 +686,6 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
> >>                 if (tun)
> >>                         xdp_rxq_info_unreg(&tfile->xdp_rxq);
> >>                 ptr_ring_cleanup(&tfile->tx_ring, tun_ptr_free);
> >> -               sock_put(&tfile->sk);
> >>         }
> >>  }
> >>
> >> @@ -702,6 +701,11 @@ static void tun_detach(struct tun_file *tfile, bool clean)
> >>         if (dev)
> >>                 netdev_state_change(dev);
> >>         rtnl_unlock();
> >> +
> >> +       if (clean) {
> >
> > Would you mind explaining (a comment would be nice) why this barrier is needed ?
>
> I thought that tfile is accessed with rcu_lock(), so I put
> synchronize_rcu() here.  Please let me know if I misunderstand the
> concept of rcu (I'm losing my confidence...).
>

Addin Jason for comments.

If an RCU grace period was needed before commit 83c1f36f9880 ("tun:
send netlink notification when the device is modified"),
would we need another patch ?

Also sock_flag(sk, SOCK_RCU_FREE) would probably be better than adding
a synchronize_rcu() (if again a grace period is needed)



> Thanks,
> Shigeru
>
> >
> > Thanks.
> >
> >> +               synchronize_rcu();
> >> +               sock_put(&tfile->sk);
> >> +       }
> >>  }
> >>
> >>  static void tun_detach_all(struct net_device *dev)
> >> --
> >> 2.38.1
> >>
> >
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DA963F172
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 14:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiLANVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 08:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLANVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 08:21:07 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12075A06C0;
        Thu,  1 Dec 2022 05:21:05 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id x6so1840027lji.10;
        Thu, 01 Dec 2022 05:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dQOMDIDPvYlGkw37i+opI65nUUsT7B3x6lyWidt8ATA=;
        b=mX5ZL8CPwySyLpJTgAbBPcO8d6ooThgZWvtfw6q5ZJFF6o6rHCpGfIn7RNLcWN8umX
         ZAVBUQa3N7sbukEwJsQIbDOach/jyCCfVWkyX3vMq4rgPq0UZVdAxzMo3pSE0Q1hGjfy
         wPCqGGou5TkavSwFRwI0NyuwLSASnPxEdleisVeexqISIS3MbjOlKMp8vkf8l1R2iLhX
         /BVdX3AgNTdEy9DtoMbfoBAesu/2pxYoiZFOqnLDdZi7KQm4zr8iU+AYI8PaZ79+e/P0
         Q1xAJV67ECOahzWb58lUt5Xm/YOvrz8TJggUATb6OpcOKE8Lg4nFk04FSB2/FD/6gDK7
         J6ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dQOMDIDPvYlGkw37i+opI65nUUsT7B3x6lyWidt8ATA=;
        b=BcK28Q5ZDzge7RhRbLjkm33kUh3i5g7glTvOOx5BTfhpFZOi8nbjuygm81+iucdsu6
         GICSUw6RDkotNKgbeIvYtsKjmU6nf0zeZTKetm70MerCoEOOeunp7GsOixYwuYH8FeZ2
         mI3jhByWIW84KCjcjoapE6TxVo87vjIZyq9dy4gTgatse+HKKcdYIFIIiY41+jjZcjM+
         AgSKSOJ+O5paO3FoLADbD/gSSxotpuOKsi8i9d/PsFpwis/8DhQ1CsWNFvK9ujRFtoRB
         0BKmcUJlucgDl5bzOzWv+7KLsdBC2M8ZQqxSvaCsX/AkX0tRsRaqyOCkwUpQGhcMgafQ
         P9Sw==
X-Gm-Message-State: ANoB5pnCNz9WTL02fB72222SUONJd2BTyZEHdvdffTw8h09GAP2VddUw
        GWfut1jv/I8tMIot8uKYN+cqhGm5uzMlqSFGdC4=
X-Google-Smtp-Source: AA0mqf7nRR+HCpX3tN8nqonzgSND0zPHiPXF10xpu4AW5Pr7lCYDKvn0WNRTez9NUsyh+GxoJl5/7ZZ6ed1c/RVA8dM=
X-Received: by 2002:a05:651c:198f:b0:277:6a5:109b with SMTP id
 bx15-20020a05651c198f00b0027706a5109bmr17260105ljb.42.1669900863230; Thu, 01
 Dec 2022 05:21:03 -0800 (PST)
MIME-Version: 1.0
References: <20221129025249.463833-1-yin31149@gmail.com> <a45ab50d7566913913be41336e6e37369c073925.camel@redhat.com>
In-Reply-To: <a45ab50d7566913913be41336e6e37369c073925.camel@redhat.com>
From:   Hawkins Jiawei <yin31149@gmail.com>
Date:   Thu, 1 Dec 2022 21:20:51 +0800
Message-ID: <CAKrof1O7yP0TN07w_8CKM6BWHToeoOFJq8tNhWW2MzEq3QrrYg@mail.gmail.com>
Subject: Re: [PATCH v3] net: sched: fix memory leak in tcindex_set_parms
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, 18801353760@163.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Cong Wang <cong.wang@bytedance.com>,
        Dmitry Vyukov <dvyukov@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Dec 2022 at 18:24, Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2022-11-29 at 10:52 +0800, Hawkins Jiawei wrote:
> > Syzkaller reports a memory leak as follows:
> > ====================================
> > BUG: memory leak
> > unreferenced object 0xffff88810c287f00 (size 256):
> >   comm "syz-executor105", pid 3600, jiffies 4294943292 (age 12.990s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffff814cf9f0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1046
> >     [<ffffffff839c9e07>] kmalloc include/linux/slab.h:576 [inline]
> >     [<ffffffff839c9e07>] kmalloc_array include/linux/slab.h:627 [inline]
> >     [<ffffffff839c9e07>] kcalloc include/linux/slab.h:659 [inline]
> >     [<ffffffff839c9e07>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
> >     [<ffffffff839c9e07>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
> >     [<ffffffff839caa1f>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
> >     [<ffffffff8394db62>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
> >     [<ffffffff8389e91c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
> >     [<ffffffff839eba67>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
> >     [<ffffffff839eab87>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
> >     [<ffffffff839eab87>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
> >     [<ffffffff839eb046>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
> >     [<ffffffff8383e796>] sock_sendmsg_nosec net/socket.c:714 [inline]
> >     [<ffffffff8383e796>] sock_sendmsg+0x56/0x80 net/socket.c:734
> >     [<ffffffff8383eb08>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
> >     [<ffffffff83843678>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
> >     [<ffffffff838439c5>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
> >     [<ffffffff83843c14>] __do_sys_sendmmsg net/socket.c:2651 [inline]
> >     [<ffffffff83843c14>] __se_sys_sendmmsg net/socket.c:2648 [inline]
> >     [<ffffffff83843c14>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
> >     [<ffffffff84605fd5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff84605fd5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > ====================================
> >
> > Kernel uses tcindex_change() to change an existing
> > filter properties. During the process of changing,
> > kernel uses tcindex_alloc_perfect_hash() to newly
> > allocate filter results, uses tcindex_filter_result_init()
> > to clear the old filter result.
> >
> > Yet the problem is that, kernel clears the old
> > filter result, without destroying its tcf_exts structure,
> > which triggers the above memory leak.
> >
> > Considering that there already extis a tc_filter_wq workqueue
> > to destroy the old tcindex_data by tcindex_partial_destroy_work()
> > at the end of tcindex_set_parms(), this patch solves this memory
> > leak bug by removing this old filter result clearing part,
> > and delegating it to the tc_filter_wq workqueue.
> >
> > [Thanks to the suggestion from Jakub Kicinski, Cong Wang, Paolo Abeni
> > and Dmitry Vyukov]
> >
> > Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
> > Link: https://lore.kernel.org/all/0000000000001de5c505ebc9ec59@google.com/
> > Reported-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
> > Tested-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
> > Cc: Cong Wang <cong.wang@bytedance.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Dmitry Vyukov <dvyukov@google.com>
> > Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
>
> The patch looks correct to me, but we are very late in this release
> cycle, and I fear there is a chance of introducing some regression. The
> issue addressed here is present since quite some time, I suggest to
> postpone this fix to the beginning of the next release cycle.
>
> Please, repost this patch after that 6.1 is released, thanks! (And feel
> free to add my Acked-by).

Thanks for your review.

I will retest this patch after 6.1, and repost this patch
if the patch works fine.

>
> Paolo
>

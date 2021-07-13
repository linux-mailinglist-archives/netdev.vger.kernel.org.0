Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8DF3C71CD
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 16:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbhGMOHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 10:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236721AbhGMOHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 10:07:05 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADADC0613DD;
        Tue, 13 Jul 2021 07:04:14 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id l1so11535895edr.11;
        Tue, 13 Jul 2021 07:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=arUYuAy2PN4/feE5llijqQYwxfh81atG4dBl/yi0Yrc=;
        b=Qbcg0RVjBLBhe4in65MsZo8Itjh7iHNOFBSeAIXck14Ga87IMfIcv/An5nl2Tc8Loq
         YuS3FN/XuAJnxd1S0mBfSMcHGzhJdVfBaOXP8DqGDSMWqPLgB+pYQRSmd0G2mi7O4WnW
         /8VAD114iWB3/gr9CjAFkl3GtQ38FdsrfKcfe9wmyXnz8fvGuTw6bAAin5qUDQyFq+Sw
         Zz2h9v1YanLFiVAWc/N4vhd31D+B5S5hH2ySzaaPXiA6QiEaxsoZ5nj9dIntDp/UGh/P
         ZQzlZNovrou6iVI1MudTvuwyY6c+bQ2+vypD54l504Sjd4u6ojxskWQNv1KM9ffDdkTj
         7PUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=arUYuAy2PN4/feE5llijqQYwxfh81atG4dBl/yi0Yrc=;
        b=eLBWUdxqfzZba//2wRy6E3TPql0LmW4A7taZjxZ9Ni1nZNN3b1p/wSPIJrssQAf7Jv
         JtD0p9OpICmMjHQ57+B0xpUdvkTIIAJ/QFuvccwUbrd3srzeAVq8I3E98kerApQij2Ze
         PAtlGpHZVPNm3LibG6gE87XlAxtEad5Mz+pexkOYtgAT7sCsIAQl2x7muQcBYrOEYplw
         pwucZY9OnNGhQhmhPBkjPpLHHuIL0eDy2zoZmBuVWHRkd6Sx//hvAzn7RQ4h2ngBdOVu
         6oyDq7Z0mOOXGCtLbcEAvnek9229jP9zP+P4Fmu/xq+li7wVVVvq86Hy5HwGIlMb331M
         Z/tA==
X-Gm-Message-State: AOAM531n++ZP+dF5rjz/Pnib7tuTJ0Vag8B/McmF7SVaMFLTVMykT7Jk
        JFuoSPj4EIuZ8dblRGuejpy/NGt/grl4iS8PLls=
X-Google-Smtp-Source: ABdhPJy+Xb1snyVwx0jEahtGtFKIsgzL7Mg1DFZsm5Jjzxhey/YtgT0ZllwPsn1jkBcPBqr+D2RAXpAP+lQVJyIJtxc=
X-Received: by 2002:a05:6402:270d:: with SMTP id y13mr6035528edd.66.1626185051561;
 Tue, 13 Jul 2021 07:04:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210713054019.409273-1-mudongliangabcd@gmail.com> <CAB_54W6DkBkASH5ojbChSoPB6ogQNy+7rq2kr=m9PNLmzATHtQ@mail.gmail.com>
In-Reply-To: <CAB_54W6DkBkASH5ojbChSoPB6ogQNy+7rq2kr=m9PNLmzATHtQ@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 13 Jul 2021 22:03:45 +0800
Message-ID: <CAD-N9QWcjQ8YkpunPgDU3j5CtS5coHrFwsmsJoYG9DH39T0yzA@mail.gmail.com>
Subject: Re: [PATCH] ieee802154: hwsim: fix memory leak in __pskb_copy_fclone
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <aring@mojatatu.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 9:47 PM Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Tue, 13 Jul 2021 at 01:40, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >
> > hwsim_hw_xmit fails to deallocate the newskb copied by pskb_copy. Fix
> > this by adding kfree_skb after ieee802154_rx_irqsafe.
> >
> >   [<ffffffff836433fb>] __alloc_skb+0x22b/0x250 net/core/skbuff.c:414
> >   [<ffffffff8364ad95>] __pskb_copy_fclone+0x75/0x360 net/core/skbuff.c:1609
> >   [<ffffffff82ae65e3>] __pskb_copy include/linux/skbuff.h:1176 [inline]
> >   [<ffffffff82ae65e3>] pskb_copy include/linux/skbuff.h:3207 [inline]
> >   [<ffffffff82ae65e3>] hwsim_hw_xmit+0xd3/0x140 drivers/net/ieee802154/mac802154_hwsim.c:132
> >   [<ffffffff83ff8f47>] drv_xmit_async net/mac802154/driver-ops.h:16 [inline]
> >   [<ffffffff83ff8f47>] ieee802154_tx+0xc7/0x190 net/mac802154/tx.c:83
> >   [<ffffffff83ff9138>] ieee802154_subif_start_xmit+0x58/0x70 net/mac802154/tx.c:132
> >   [<ffffffff83670b82>] __netdev_start_xmit include/linux/netdevice.h:4944 [inline]
> >   [<ffffffff83670b82>] netdev_start_xmit include/linux/netdevice.h:4958 [inline]
> >   [<ffffffff83670b82>] xmit_one net/core/dev.c:3658 [inline]
> >   [<ffffffff83670b82>] dev_hard_start_xmit+0xe2/0x330 net/core/dev.c:3674
> >   [<ffffffff83718028>] sch_direct_xmit+0xf8/0x520 net/sched/sch_generic.c:342
> >   [<ffffffff8367193b>] __dev_xmit_skb net/core/dev.c:3874 [inline]
> >   [<ffffffff8367193b>] __dev_queue_xmit+0xa3b/0x1360 net/core/dev.c:4241
> >   [<ffffffff83ff5437>] dgram_sendmsg+0x437/0x570 net/ieee802154/socket.c:682
> >   [<ffffffff836345b6>] sock_sendmsg_nosec net/socket.c:702 [inline]
> >   [<ffffffff836345b6>] sock_sendmsg+0x56/0x80 net/socket.c:722
> >
> > Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
>
> sorry, I don't get the fix. Is this a memory leak? I remember there
> was something reported by syzkaller [0] but I wasn't able yet to get
> into it. Is it what you referring to?

Yes, you're right.

I get this memory leak many times in my local syzkaller instance but
do not recognize there is already a bug report in the syzbot
dashboard.

> __pskb_copy_fclone() shows "The returned buffer has a reference count
> of 1" and ieee802154_rx_irqsafe() will queue the skb for a tasklet.
> With your patch it will be immediately freed and a use after free will
> occur.

Thanks for your feedback. I am sorry about this fix since I did not
observe UAF in my testing.

I will keep learning more materials about socket in Linux kernel. :)

> I believe there is something wrong in the error path of
> 802.15.4 frame parsing and that's why we sometimes have a leaks there.

Should be yes, it occurs many times in my local syzkaller instance.

>
> I need to test this patch, but I don't get how this patch is supposed
> to fix the issue.

This patch should be incorrect. Please directly focus on bug reports
on the syzbot dashboard. If possible, please cc me your final patch
about this bug. I can learn something from this bug.

Best regards
Dongliang Mu

>
> - Alex
>
> [0] https://groups.google.com/g/syzkaller-bugs/c/EoIvZbk3Zfo/m/AlKUiErlAwAJ

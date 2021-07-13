Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D123C7171
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 15:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbhGMNuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 09:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236222AbhGMNuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 09:50:13 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3972FC0613DD;
        Tue, 13 Jul 2021 06:47:23 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id p8so30550186wrr.1;
        Tue, 13 Jul 2021 06:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X/AEnKgR35dch3/Dd4uftg3ppYbt85cCwHqG8mB8H40=;
        b=hHPV0jO0A53LsFdk1uIC2UDPRjwsgp6Khb9VjaAoaF31e/tfTM/VZeelFGvz4A1LhQ
         VqIsT7exIXTKWb635pIeS2si1JfsMbllUg1pTpFXsgyiobOVnFTfPr6Zdqub1qB0GL2p
         Z4K9vbagjhnMaI+y9VE2nbP/7Na7sf/NnDzveuSHKPfogbo11SPevbH3ZJauTo7nso/H
         9gq4gSxmaXQ6I83ipChNMc3ow8UhHjeN1dtMvapBqI6quoHXubYjckkF0g8vlcQAa6OM
         zLrInzQEl/8ObWfTF2c4kPlyViBRTBLGzryI2xPP371Yz51cRxZIaVGkgTKH1JLbyv/w
         huFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X/AEnKgR35dch3/Dd4uftg3ppYbt85cCwHqG8mB8H40=;
        b=mEi5TdzyNO4XNJ44hfSfEnDO+B+32UYSmZ3lJkt9tJZ+yeFwevSRz4AIZ3NhbXg/8T
         FdjxHIn3Pnw1xpgVvKiWLBq2nulB7XnJHlvo9KBhxUg46UOOxCB8sgX9N2KB3jxf5lxw
         Oc75nj1SKDgzKvpvV0aXAVtZEsCcL9LhCpcqqOGWHKW2DDolIJxxA6f3+Jf+ClEt2jGr
         wkM0OvRUIUUBKKLSANv8Nh6/FXF7v8sE1G9Jj/YB6++7czQjLdb9rqfpdfa7YWjpIXyd
         mVg5BFDc7fUXdi6N7Ym7e5QXgUQoPoei/45AVh3+QVAAmdcnvIYARBam8/qGyZ6keFES
         daqA==
X-Gm-Message-State: AOAM531kOCCaa0aE61+Wt1bE8wCJ7Z14y9p82EPceqMPVTF8gE2ooz6l
        zsZEsbo5HcanCgMEgLXOW5us3LMAceheG+EUfLg=
X-Google-Smtp-Source: ABdhPJxz/AMLqAjw+OLCeNgQzB+GRtUscV/kpXH6OPXF7N3eeXF6ZvPSvKnOblE9jj+X0nhUUX+w/Dq7KnNhXY8VWHQ=
X-Received: by 2002:a5d:530b:: with SMTP id e11mr2420650wrv.65.1626184041894;
 Tue, 13 Jul 2021 06:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210713054019.409273-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210713054019.409273-1-mudongliangabcd@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 13 Jul 2021 09:47:10 -0400
Message-ID: <CAB_54W6DkBkASH5ojbChSoPB6ogQNy+7rq2kr=m9PNLmzATHtQ@mail.gmail.com>
Subject: Re: [PATCH] ieee802154: hwsim: fix memory leak in __pskb_copy_fclone
To:     Dongliang Mu <mudongliangabcd@gmail.com>
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

Hi,

On Tue, 13 Jul 2021 at 01:40, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> hwsim_hw_xmit fails to deallocate the newskb copied by pskb_copy. Fix
> this by adding kfree_skb after ieee802154_rx_irqsafe.
>
>   [<ffffffff836433fb>] __alloc_skb+0x22b/0x250 net/core/skbuff.c:414
>   [<ffffffff8364ad95>] __pskb_copy_fclone+0x75/0x360 net/core/skbuff.c:1609
>   [<ffffffff82ae65e3>] __pskb_copy include/linux/skbuff.h:1176 [inline]
>   [<ffffffff82ae65e3>] pskb_copy include/linux/skbuff.h:3207 [inline]
>   [<ffffffff82ae65e3>] hwsim_hw_xmit+0xd3/0x140 drivers/net/ieee802154/mac802154_hwsim.c:132
>   [<ffffffff83ff8f47>] drv_xmit_async net/mac802154/driver-ops.h:16 [inline]
>   [<ffffffff83ff8f47>] ieee802154_tx+0xc7/0x190 net/mac802154/tx.c:83
>   [<ffffffff83ff9138>] ieee802154_subif_start_xmit+0x58/0x70 net/mac802154/tx.c:132
>   [<ffffffff83670b82>] __netdev_start_xmit include/linux/netdevice.h:4944 [inline]
>   [<ffffffff83670b82>] netdev_start_xmit include/linux/netdevice.h:4958 [inline]
>   [<ffffffff83670b82>] xmit_one net/core/dev.c:3658 [inline]
>   [<ffffffff83670b82>] dev_hard_start_xmit+0xe2/0x330 net/core/dev.c:3674
>   [<ffffffff83718028>] sch_direct_xmit+0xf8/0x520 net/sched/sch_generic.c:342
>   [<ffffffff8367193b>] __dev_xmit_skb net/core/dev.c:3874 [inline]
>   [<ffffffff8367193b>] __dev_queue_xmit+0xa3b/0x1360 net/core/dev.c:4241
>   [<ffffffff83ff5437>] dgram_sendmsg+0x437/0x570 net/ieee802154/socket.c:682
>   [<ffffffff836345b6>] sock_sendmsg_nosec net/socket.c:702 [inline]
>   [<ffffffff836345b6>] sock_sendmsg+0x56/0x80 net/socket.c:722
>
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>

sorry, I don't get the fix. Is this a memory leak? I remember there
was something reported by syzkaller [0] but I wasn't able yet to get
into it. Is it what you referring to?
__pskb_copy_fclone() shows "The returned buffer has a reference count
of 1" and ieee802154_rx_irqsafe() will queue the skb for a tasklet.
With your patch it will be immediately freed and a use after free will
occur. I believe there is something wrong in the error path of
802.15.4 frame parsing and that's why we sometimes have a leaks there.

I need to test this patch, but I don't get how this patch is supposed
to fix the issue.

- Alex

[0] https://groups.google.com/g/syzkaller-bugs/c/EoIvZbk3Zfo/m/AlKUiErlAwAJ

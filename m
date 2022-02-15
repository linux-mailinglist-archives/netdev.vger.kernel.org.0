Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BD44B5F98
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 01:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiBOAyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 19:54:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbiBOAym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 19:54:42 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56C513C9DA
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:54:17 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id 124so23206688ybn.11
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+AX2SYoC4msJOh9OJc3IccwcSk5p5Afcs2DP3Zp2Qvg=;
        b=UM9q3k7K5CuUBXwtgck8hLLXSV6Hd6T/btHOyEF29xCMhoQb4t8kdhXmA42PrDR0bQ
         mypRKZ5hRGJDDrbtC0j//EW9/k53PcekkX9mPE/xwKJUV1ofX5YTuHAyusuDqiKo+1ne
         uvHa74MVxE/xkU+Z+BpH6G5xenS+BQt9AFHoDihQ4/PHvPLYYp0ArR1/2SFcdP9yJhtS
         ffeOzbgpEu5HsGPgaOKmLtK102AI1pvjxzf2+CSxegobs9O960xqJfg5fj41QsQcXE47
         +v2t712L9LwB+S+z1BwmFrFlFNS3FbqRYpCdABljL/uOgeQqSnhCkfVCd3Vxzy+Z7gKV
         Lc7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+AX2SYoC4msJOh9OJc3IccwcSk5p5Afcs2DP3Zp2Qvg=;
        b=gUWuyisKSnAIHhK7V8FzxGXZCsQTvmfC2jzWfZGLX2Yt/I3K7fTMQHFXllJUkRTMHl
         8xd/vuiMxBMo/zM1bO5ea34+BXfmcoSTzffF8ydjKSpWoZLRA8pdU9Hx5Dwghdj4FLPa
         4+ZWDofD3BFqUdqshRj7KjPqU/LS8O3NcjJi9TWcVlQydblDlrfcmdlJvgGiAl+PtS9E
         DLu0bOj9JDUeRBknVB1a4Tm0bo3EMLlNbYG47i/p6W1em8p3cR0JeU7Msp8VRmAPTplp
         WbRYiCvUrIdoMs0L55IfQaWXVjYLFXv2j8TNz+bIiv5fJGJSBqIwoPZBdcDcwvuvmfYT
         ESBQ==
X-Gm-Message-State: AOAM532+YaNBuHD5zMt+wy4ZGd2YlECvj74Fcqp7Chf9DWnc6kLyLSuo
        pTUsBTUdAWY8qlm1Oj21BA71/xXOrsmyC2rt/5A=
X-Google-Smtp-Source: ABdhPJyYfX2UFsj/xY+/Kqy80rxXxyKIq5Uj8vZ3Uho+pUHytHaUAefR4V+uqV6CBRO9NucJvhv8z+HgOGaSjkBuYNI=
X-Received: by 2002:a81:ee06:: with SMTP id l6mr1471760ywm.450.1644886455201;
 Mon, 14 Feb 2022 16:54:15 -0800 (PST)
MIME-Version: 1.0
References: <20220208053451.2885398-1-eric.dumazet@gmail.com>
 <YgryyOR3PaTztFn8@pop-os.localdomain> <CANn89iKNOpRSGC_1WcXQ+=R4NnZSp6w9V+HFSZ7OPO+gZdPheg@mail.gmail.com>
In-Reply-To: <CANn89iKNOpRSGC_1WcXQ+=R4NnZSp6w9V+HFSZ7OPO+gZdPheg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 14 Feb 2022 16:54:04 -0800
Message-ID: <CAM_iQpWYJQW31JOiTNUTs4jarSkd_m4Es_yK=AZSf3a2X3CTwg@mail.gmail.com>
Subject: Re: [PATCH net] ipmr,ip6mr: acquire RTNL before calling
 ip[6]mr_free_table() on failure path
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 4:36 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Feb 14, 2022 at 4:24 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Mon, Feb 07, 2022 at 09:34:51PM -0800, Eric Dumazet wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > ip[6]mr_free_table() can only be called under RTNL lock.
> > >
> > > RTNL: assertion failed at net/core/dev.c (10367)
> > > WARNING: CPU: 1 PID: 5890 at net/core/dev.c:10367 unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
> > > Modules linked in:
> > > CPU: 1 PID: 5890 Comm: syz-executor.2 Not tainted 5.16.0-syzkaller-11627-g422ee58dc0ef #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > RIP: 0010:unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
> > > Code: 0f 85 9b ee ff ff e8 69 07 4b fa ba 7f 28 00 00 48 c7 c6 00 90 ae 8a 48 c7 c7 40 90 ae 8a c6 05 6d b1 51 06 01 e8 8c 90 d8 01 <0f> 0b e9 70 ee ff ff e8 3e 07 4b fa 4c 89 e7 e8 86 2a 59 fa e9 ee
> > > RSP: 0018:ffffc900046ff6e0 EFLAGS: 00010286
> > > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > > RDX: ffff888050f51d00 RSI: ffffffff815fa008 RDI: fffff520008dfece
> > > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > > R10: ffffffff815f3d6e R11: 0000000000000000 R12: 00000000fffffff4
> > > R13: dffffc0000000000 R14: ffffc900046ff750 R15: ffff88807b7dc000
> > > FS:  00007f4ab736e700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007fee0b4f8990 CR3: 000000001e7d2000 CR4: 00000000003506e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >  <TASK>
> > >  mroute_clean_tables+0x244/0xb40 net/ipv6/ip6mr.c:1509
> > >  ip6mr_free_table net/ipv6/ip6mr.c:389 [inline]
> > >  ip6mr_rules_init net/ipv6/ip6mr.c:246 [inline]
> > >  ip6mr_net_init net/ipv6/ip6mr.c:1306 [inline]
> >
> > Isn't that new table still empty in this case? Which means
> > mroute_clean_tables() should not actually unregister any netdevice??
> >
> > Should we just move that assertion after list empty check?
> >
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 909fb3815910..ff6e7d0074dd 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -10359,11 +10359,11 @@ void unregister_netdevice_many(struct list_head *head)
> >         LIST_HEAD(close_head);
> >
> >         BUG_ON(dev_boot_phase);
> > -       ASSERT_RTNL();
> >
> >         if (list_empty(head))
>
> The rule is that we need to hold RTNL when calling unregister_netdevice_many().
>
> Adding a special case for empty list would avoid this safety check,
> and perhaps hide future bugs.

Why is that? What bugs are you talking about when it is just a nop?

>
> This ASSER_RTNL() check has been there forever (before git)

So is this bug? ;)

>
> Not sure what this brings, my patch only fixed a super-rare case ?
> Do you think the added rtrnl acquisition is an issue ?

Yes, it is just completely unnecessary, I fail to see why we want to
use RTNL to protect a nop.

Thanks.

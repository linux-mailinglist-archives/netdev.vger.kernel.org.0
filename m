Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930AB4B5F25
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 01:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbiBOAhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 19:37:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiBOAg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 19:36:59 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749ECD10A5
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:36:50 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id l125so18123832ybl.4
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OMgHF2JrMyXepJoCnVqN594bHqz8fp95QM+XInn8HwQ=;
        b=JEnCw0dMwasrEdjlxFazWYjsxOSInngdU5EtibJ2sPr2birz1B+ow0hi/8qhcZo5wq
         NPNxun1c0ignd8DTSoy7ipZ2UFbBLddf8hkAI8bXm/S7+7p1rUdv/GDGNse6aMw7ElOz
         Ugp/hYISgh7pv2Ay31XAGHPEfp7LWa4Rk9uknPIBANPEDFfKtqcP0DMsx3pfs+C/ooA/
         Jv6LxWkKHNkbq7IYA8evAurATj8OKQsES4Khpv7VR3Vm5RFHPF4Cv4MQRSE3amruF4Vn
         Rxa5/4rpt+HutDggSvCCkrh/OubxP0RbNhR2q1WC/bX0UAjjsY/VmkdSiplX3HSnIvau
         p4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OMgHF2JrMyXepJoCnVqN594bHqz8fp95QM+XInn8HwQ=;
        b=MdXgjjFvYBZsCQbFvwJp62twp1h+EJulujOkwFYhYBRAfn2FBidV2FoZgKzkxmHC0y
         PpMBBrvSaqSH2W/pgnjtafCYq9IXrgAcwXk8E+hYFPS0tcQLJ54vh7b5NEZDBzG2c3Ty
         rKRyrdy//RI5Rn1yo+z1uD7wK7AukB61VRXkY5zqYH4+Yi7grCmnbPhqgM1D/bzc7PBo
         awHbVV0mIYT3nEoJcCn9aLG5n1smrnMh1RlQcgGESHImCm6/blOTRey6ODTQNdQtEYI3
         Wp69lFZO9YbYh7+p0NPOBp2TTbNrodOCr4WXpOoUUT1Izw6FwMrH/yOiizLKRDOK4ysk
         TIwg==
X-Gm-Message-State: AOAM532KMtYwN4kiENV/vkhBejc0ovuV9lm7gXq7Srjt9ZqpJYC7k6jS
        LYwo2G+Fi8BYs2//OrxNfST7K19Z/ZMc6E3drTiYlQ==
X-Google-Smtp-Source: ABdhPJz2YSoC1E1vKsK3ThmbYLj/W0TxGiW3yMyDce87QRqTcznxrUrN9s/tH+tOWUTWYy9i05nFfRdx1GAZRHmluCQ=
X-Received: by 2002:a81:b80b:: with SMTP id v11mr1350513ywe.295.1644885409325;
 Mon, 14 Feb 2022 16:36:49 -0800 (PST)
MIME-Version: 1.0
References: <20220208053451.2885398-1-eric.dumazet@gmail.com> <YgryyOR3PaTztFn8@pop-os.localdomain>
In-Reply-To: <YgryyOR3PaTztFn8@pop-os.localdomain>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 14 Feb 2022 16:36:38 -0800
Message-ID: <CANn89iKNOpRSGC_1WcXQ+=R4NnZSp6w9V+HFSZ7OPO+gZdPheg@mail.gmail.com>
Subject: Re: [PATCH net] ipmr,ip6mr: acquire RTNL before calling
 ip[6]mr_free_table() on failure path
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 4:24 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Feb 07, 2022 at 09:34:51PM -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > ip[6]mr_free_table() can only be called under RTNL lock.
> >
> > RTNL: assertion failed at net/core/dev.c (10367)
> > WARNING: CPU: 1 PID: 5890 at net/core/dev.c:10367 unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
> > Modules linked in:
> > CPU: 1 PID: 5890 Comm: syz-executor.2 Not tainted 5.16.0-syzkaller-11627-g422ee58dc0ef #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
> > Code: 0f 85 9b ee ff ff e8 69 07 4b fa ba 7f 28 00 00 48 c7 c6 00 90 ae 8a 48 c7 c7 40 90 ae 8a c6 05 6d b1 51 06 01 e8 8c 90 d8 01 <0f> 0b e9 70 ee ff ff e8 3e 07 4b fa 4c 89 e7 e8 86 2a 59 fa e9 ee
> > RSP: 0018:ffffc900046ff6e0 EFLAGS: 00010286
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: ffff888050f51d00 RSI: ffffffff815fa008 RDI: fffff520008dfece
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > R10: ffffffff815f3d6e R11: 0000000000000000 R12: 00000000fffffff4
> > R13: dffffc0000000000 R14: ffffc900046ff750 R15: ffff88807b7dc000
> > FS:  00007f4ab736e700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007fee0b4f8990 CR3: 000000001e7d2000 CR4: 00000000003506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  mroute_clean_tables+0x244/0xb40 net/ipv6/ip6mr.c:1509
> >  ip6mr_free_table net/ipv6/ip6mr.c:389 [inline]
> >  ip6mr_rules_init net/ipv6/ip6mr.c:246 [inline]
> >  ip6mr_net_init net/ipv6/ip6mr.c:1306 [inline]
>
> Isn't that new table still empty in this case? Which means
> mroute_clean_tables() should not actually unregister any netdevice??
>
> Should we just move that assertion after list empty check?
>
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 909fb3815910..ff6e7d0074dd 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10359,11 +10359,11 @@ void unregister_netdevice_many(struct list_head *head)
>         LIST_HEAD(close_head);
>
>         BUG_ON(dev_boot_phase);
> -       ASSERT_RTNL();
>
>         if (list_empty(head))

The rule is that we need to hold RTNL when calling unregister_netdevice_many().

Adding a special case for empty list would avoid this safety check,
and perhaps hide future bugs.

This ASSER_RTNL() check has been there forever (before git)

Not sure what this brings, my patch only fixed a super-rare case ?
Do you think the added rtrnl acquisition is an issue ?

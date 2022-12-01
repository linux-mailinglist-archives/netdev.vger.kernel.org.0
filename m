Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E31463F81F
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 20:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiLATZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 14:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiLATZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 14:25:32 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9BBC7721
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 11:25:31 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id y83so3317246yby.12
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 11:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NQoeb0KaA6tBmStXDhUp2Jzj7YSOKmV4N1ezYR1ylC0=;
        b=QeERqtXOAtsPgIvidT8jMSYIXHRseZnTuXJVybh/79J7qNsQn5H/3UWmmA/1LThXQ2
         WDSmM3WuDWtb5LwOhaem6Asdnabvn8FqSLpYsJQPRQkrwY3g6/HlsmU1wWTiAhSdt3oa
         cz4sQDBt+cADd2ElYTF50MUdWkX50sWJDCYtC1nlTwJV1HKC+BmRH36VcV3rAMgq3dRC
         6GomxwZnHTlZwcFvLgt/7Ll6A37SiuRMbkzR04VACbABY2xTvvNikWX4ZuoCjMZAfm1u
         IAgkKvTyc5D+qVR18PcQIiaLB49ml0vWiSbR9ZvNimEQdB3/wq+OaoaPdozXr7q7J11g
         iXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NQoeb0KaA6tBmStXDhUp2Jzj7YSOKmV4N1ezYR1ylC0=;
        b=vjZnAow5mnnKutu/ub0hRyWVaWZx6l0zT2+ym/eBlN81WrgxSMqn6jl36I/5zGFaCL
         rJ+GdPVqUnRLOgaZxbQDtIFpwxccZirYp2Ttl+mYehKqM+f/en9z3MTpsPW4I8MJESRL
         lq40B5FSYu2pANRum9RFWRd6pPLnT17hhmAGwVab1V79UXdysEsZ/+bzjGdQxlhls8D4
         F2AFmoOkPfschEpZyRhZTUYU9ywE0GcFKFLIERkzw65cOeNb7fE+hbbz5Kgb6mJjsBR5
         J/NVneQrvk5+PLDsUXTL/BdX+few5bJU8jpyOidxDe6pAtWNwU9hC4e5VNj5NYz2I0A1
         WX5w==
X-Gm-Message-State: ANoB5pkU3ghbiP/6pn9RvETf1JNM5fGmoq5GErA2pKpeSodQhP2gcjLU
        XUUcc0xgByuZotDaOFGdY26/3KpEd5xyOaIj0nUvxQ==
X-Google-Smtp-Source: AA0mqf4FirlLNrAAQOf54JhkjC7QUPVZI8xTLsWtKiqihKjMUiFPu6xzC2dZ1JE2QmK/rhX9QzEXeIUd85Tcjw9iDR4=
X-Received: by 2002:a25:d88:0:b0:6f0:9db5:63e7 with SMTP id
 130-20020a250d88000000b006f09db563e7mr36460310ybn.387.1669922730336; Thu, 01
 Dec 2022 11:25:30 -0800 (PST)
MIME-Version: 1.0
References: <1669817512-4560-1-git-send-email-george.kennedy@oracle.com> <CALs4sv2ZfT1SAYY0oOYhrBBCjsG_th5g=QtSsbKJnPbW8faQ+w@mail.gmail.com>
In-Reply-To: <CALs4sv2ZfT1SAYY0oOYhrBBCjsG_th5g=QtSsbKJnPbW8faQ+w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Dec 2022 20:25:18 +0100
Message-ID: <CANn89iL9obgd==tdp9DgdxXk78UvzF6D4J1OeihB1kx9_U4oZw@mail.gmail.com>
Subject: Re: [PATCH] net: check for dev pointer being NULL in
 dev_hard_header() to avoid GPF
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     George Kennedy <george.kennedy@oracle.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        harshit.m.mogalapalli@oracle.com
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

On Thu, Dec 1, 2022 at 2:16 PM Pavan Chebbi <pavan.chebbi@broadcom.com> wrote:
>
> On Wed, Nov 30, 2022 at 7:43 PM George Kennedy
> <george.kennedy@oracle.com> wrote:
> >
> > The dev pointer can be NULL in dev_hard_header(). Add check for dev being
> > NULL in dev_hard_header() to avoid GPF.
> >
> > general protection fault, probably for non-canonical address
> >     0xdffffc0000000046: 0000 [#1] PREEMPT SMP KASAN NOPTI
> > KASAN: null-ptr-deref in range [0x0000000000000230-0x0000000000000237]
> > CPU: 1 PID: 45 Comm: kworker/1:1 Not tainted 6.1.0-rc7+ #2
> > Hardware name: Red Hat KVM, BIOS 1.15.0-2.module+el8.6.0+20659+3dcf7c70
> > Workqueue: mld mld_ifc_work
> > RIP: 0010:macvlan_hard_header (./include/linux/netdevice.h:3057
> >     (discriminator 4) drivers/net/macvlan.c:594 (discriminator 4))
> > RSP: 0018:ffff888103d377d0 EFLAGS: 00010212
> > RAX: dffffc0000000000 RBX: ffff88801cf1a000 RCX: 0000000000000000
> > RDX: 0000000000000046 RSI: 0000000000000000 RDI: 0000000000000230
> > RBP: ffff88801e8ef328 R08: 0000000000000000 R09: 0000000000000060
> > R10: 0000000000000000 R11: 0000000000000000 R12: ffff88801f0497c0
> > R13: 0000000000000000 R14: ffff888045187c98 R15: 0000000000000060
> > FS:  0000000000000000(0000) GS:ffff888106c80000(0000)
> >     knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007fbf3f1c1840 CR3: 0000000014e36000 CR4: 00000000000006e0
> > Call Trace:
> >  <TASK>
> > neigh_connected_output (./include/linux/netdevice.h:3060
> >     net/core/neighbour.c:1595)
> > ip6_finish_output2 (./include/net/neighbour.h:546
> >     net/ipv6/ip6_output.c:134)
> > ip6_finish_output (net/ipv6/ip6_output.c:195 net/ipv6/ip6_output.c:206)
> > ip6_output (./include/linux/netfilter.h:291 net/ipv6/ip6_output.c:227)
> > NF_HOOK.constprop.0 (./include/net/dst.h:445
> >     ./include/linux/netfilter.h:302)
> > mld_sendpack (net/ipv6/mcast.c:1824)
> > mld_send_cr (net/ipv6/mcast.c:2122)
> > mld_ifc_work (net/ipv6/mcast.c:2655)
> > process_one_work (kernel/workqueue.c:2294)
> > worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2437)
> > kthread (kernel/kthread.c:376)
> > ret_from_fork (arch/x86/entry/entry_64.S:312)
> >  </TASK>
> > Modules linked in:
> > Dumping ftrace buffer:
> >    (ftrace buffer empty)
> > ---[ end trace 0000000000000000 ]---
> >
> > Fixes: 0c4e85813d0a ("[NET]: Wrap netdevice hardware header creation.")
> > Reported-by: syzkaller <syzkaller@googlegroups.com>
> > Signed-off-by: George Kennedy <george.kennedy@oracle.com>
> > ---
> >  include/linux/netdevice.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index eddf8ee270e7..9b25a6301fa5 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3054,7 +3054,7 @@ static inline int dev_hard_header(struct sk_buff *skb, struct net_device *dev,
> >                                   const void *daddr, const void *saddr,
> >                                   unsigned int len)
> >  {
> > -       if (!dev->header_ops || !dev->header_ops->create)
> > +       if (!dev || !dev->header_ops || !dev->header_ops->create)

Do  you have a repro ?

This patch will not prevent a crash later I think.

Please fix the root cause, thanks !

> >                 return 0;
>
> net_device being NULL during eth header construction? seems like a
> more serious issue?
> If it indeed is a genuine scenario I think a better description is needed...
>
> >
> >         return dev->header_ops->create(skb, dev, type, daddr, saddr, len);
> > --
> > 2.31.1
> >

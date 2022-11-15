Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B1B6297A1
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiKOLkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiKOLkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:40:10 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9519A28E0F
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:40:08 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id br15-20020a056830390f00b0061c9d73b8bdso8356285otb.6
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iAp3GCmehVyuNhHC14mjklC9CGomnMwAaIYc4+gSGuY=;
        b=TO9lH6CdS0DyvGX513VIpESOq/0YwmoEjcHTYscF02VB64/kWhtdAHIAvl4oTdYNh5
         xGuKUF9/2Vl6th2X9YzjoSBh+xqHFCOJ4/BKfbH0CVL0BPr8qgDDfRWGh36X6eb46vo0
         UeOT8unDXO9qc2k4jfFdJXXzi6jxIw6giXpT/J+L6lRjhzI+nN5NF1iuJsBoLE9Ne0Sq
         YB6oQWYEKxOi9Cexa/B02gOY388k53NhZ0axwGnzopjB+YNtpCd32i2c5ONenpwpObE8
         ajyWvQz2GlbbEVKQ3NcM4v0QNaUIJL7E/LgmsqI3xJgnHzNYBi87LKGY1om5bbMd99Cn
         95zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iAp3GCmehVyuNhHC14mjklC9CGomnMwAaIYc4+gSGuY=;
        b=ZA0wE261KBXW72qV9q4z6+eaDqsvmjthz5S8f2bIMtntypmUYLjWpEX0xhJ3yfWPi7
         qUJOsY+25ts3M6Hl/oYjKF80LZxoUd6hse0AN96CtWsd0d6OPiDTGVS24MWLdp0eDo3F
         fxUDRiQfmKGut8fP9CRg2hjXtVW4HmI6LmOyqzCetT8rS+KpXl4hBwH8AtAf113ZIb+Z
         esjXmm8+pkETcXYlGxSsY0Qe4JKSOUZ/ijiWYr5Ei0fmPK8Uu2Ler4TkWQTcvZHDHFAG
         8oLomJlRAlZ62p5s1Beh/TBlpM7FLScXSre5ngoCbMDWKjk3V3Y07f3y35+AHbbAiPg4
         ngsw==
X-Gm-Message-State: ANoB5pk+kRAxJ2MbulF10jnZUH+QCHgcMt6qze8MUU0BB/y5+36+z7BH
        VKIeFEL/BH3Ksf1k+BPZJtAFUo9Vz328Noo7CRA8Jw==
X-Google-Smtp-Source: AA0mqf5YJcW/sDDMsqlByS1XgYj3oGiAhDxUp3BRSTBg5mIjCnRn7CtD3AL8mXFBbhRstTQwNtnZPWlBTLwefbYBBx4=
X-Received: by 2002:a05:6830:43:b0:66c:9e9a:1f82 with SMTP id
 d3-20020a056830004300b0066c9e9a1f82mr7959449otp.269.1668512407512; Tue, 15
 Nov 2022 03:40:07 -0800 (PST)
MIME-Version: 1.0
References: <20221113170507.8205-1-yin31149@gmail.com> <0f385a7bcb8ccf71e39581d4be23b59d3bccc2e7.camel@redhat.com>
In-Reply-To: <0f385a7bcb8ccf71e39581d4be23b59d3bccc2e7.camel@redhat.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 15 Nov 2022 12:39:56 +0100
Message-ID: <CACT4Y+Zg1usxpCX490fw=OMFn8ds6cybF+DiqyB0BURVqs-eKQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: sched: fix memory leak in tcindex_set_parms
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Hawkins Jiawei <yin31149@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, 18801353760@163.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, 15 Nov 2022 at 12:36, Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2022-11-14 at 01:05 +0800, Hawkins Jiawei wrote:
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
> > traffic-control-indices filter properties. During the
> > process of changing, kernel clears the old
> > traffic-control-indices filter result, and updates it
> > by RCU assigning new traffic-control-indices data.
> >
> > Yet the problem is that, kernel clears the old
> > traffic-control-indices filter result, without destroying
> > its tcf_exts structure, which triggers the above
> > memory leak.
> >
> > This patch solves it by using tcf_exts_destroy() to
> > destroy the tcf_exts structure in old
> > traffic-control-indices filter result, after the
> > RCU grace period.
> >
> > [Thanks to the suggestion from Jakub Kicinski and Cong Wang]
> >
> > Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
> > Link: https://lore.kernel.org/all/0000000000001de5c505ebc9ec59@google.com/
> > Reported-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
> > Tested-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
> > Cc: Cong Wang <cong.wang@bytedance.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
> > ---
> > v2:
> >   - remove all 'will' in commit message according to Jakub Kicinski
> >   - add Fixes tag according to Jakub Kicinski
> >   - remove all ifdefs according to Jakub Kicinski and Cong Wang
> >   - add synchronize_rcu() before destorying old_e according to
> > Cong Wang
> >
> > v1: https://lore.kernel.org/all/20221031060835.11722-1-yin31149@gmail.com/
> >  net/sched/cls_tcindex.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> > index 1c9eeb98d826..d2fac9559d3e 100644
> > --- a/net/sched/cls_tcindex.c
> > +++ b/net/sched/cls_tcindex.c
> > @@ -338,6 +338,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >       struct tcf_result cr = {};
> >       int err, balloc = 0;
> >       struct tcf_exts e;
> > +     struct tcf_exts old_e = {};
> >
> >       err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
> >       if (err < 0)
> > @@ -479,6 +480,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >       }
> >
> >       if (old_r && old_r != r) {
> > +             old_e = old_r->exts;
> >               err = tcindex_filter_result_init(old_r, cp, net);
> >               if (err < 0) {
> >                       kfree(f);
> > @@ -510,6 +512,12 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >               tcf_exts_destroy(&new_filter_result.exts);
> >       }
> >
> > +     /* Note: old_e should be destroyed after the RCU grace period,
> > +      * to avoid possible use-after-free by concurrent readers.
> > +      */
> > +     synchronize_rcu();
>
> this could make tc reconfiguration potentially very slow. I'm wondering
> if we can delegate the tcf_exts_destroy() to some workqueue?

call_rcu?

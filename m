Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28E261E2CA
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 15:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiKFOz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 09:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiKFOz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 09:55:56 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E077C2ADF;
        Sun,  6 Nov 2022 06:55:55 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id b185so8472468pfb.9;
        Sun, 06 Nov 2022 06:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bzFP6fXSVaa/k6s5JY3J/zzifpQhv/3TCU4QFuakK6Y=;
        b=d9p5ti0yWa1iS+O7oyxrnwyn6ic1QKIe23kB5B6EPFKZIaDj9Z04RiwAVFrRNVT1Nv
         LVSPFL+A8WcYmDnsdu1hk5aPXpf+l72WfhVfkv4botuBPqondTp/wBppTAIPF18Uxd1p
         HO2xy0DSxj0WLnCYmKnjP8QjBTVckusv5Cd616piFjwYAjDjrVEv3obm8xrl0TW3zBER
         ypSIUVTbiZTB5MNHEMAKLfxTay0xKQXXHJi/C/rZ74u/UkbmZOaTirP+JTpMN/pgrebk
         7dCoAWZOKcLKJBONnf9fubOo1pp4KfiixNOm/MmKEaXTTFfTFmWOq/G6HGMOtwagiakg
         CFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bzFP6fXSVaa/k6s5JY3J/zzifpQhv/3TCU4QFuakK6Y=;
        b=lRNLn+0+jJ1j/hmGdJwkM61YwJJ7xgCH1TlWkXtDo0CAbavLvSgMiu9hwCala8/32w
         djZ4YuyLI56vISHV75vvVF/M8TmrWrAmxnHqQEJ9YymQpKp6h5n92EqHnqjBmKn8vKUJ
         m43nhePqsYAR8txcA2of/on6HVNG3knZHePrAMo/UJoa6XSYCYiX97/ez7Qwf5+OMvHs
         xpb5U8/bbQREx3nje1pJE6WNYhanu8B1bRuSRNW7hs9WKwZBvCCrWNHZ9PBabKNYlxNh
         NVonsBDfN68weq8VthIW+lmP0FfNU23GHA+w7eXgcCwptSe28D98pdWt7+ivt2ZdkWo1
         e6EA==
X-Gm-Message-State: ACrzQf1X853CyLhKLe9ZT+b/xSMp+5ZtGPSnLSIruJOFJRQyof6m6YGu
        JIA21WtYpO0JKhPdz1sHsO8=
X-Google-Smtp-Source: AMsMyM5OclPprfXFsek0mCLflxWPWDkxJ8EFOQs2v+XUDq4NpE5tXIz4v36Q7tBzH7NNJl7ifddakw==
X-Received: by 2002:a63:205f:0:b0:46e:f589:6096 with SMTP id r31-20020a63205f000000b0046ef5896096mr38250431pgm.622.1667746555285;
        Sun, 06 Nov 2022 06:55:55 -0800 (PST)
Received: from localhost ([159.226.94.113])
        by smtp.gmail.com with ESMTPSA id c16-20020a056a00009000b0056299fd2ba2sm2702227pfj.162.2022.11.06.06.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 06:55:54 -0800 (PST)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     xiyou.wangcong@gmail.com
Cc:     18801353760@163.com, davem@davemloft.net, edumazet@google.com,
        jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Subject: Re: [PATCH] net: sched: fix memory leak in tcindex_set_parms
Date:   Sun,  6 Nov 2022 22:55:31 +0800
Message-Id: <20221106145530.3717-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <Y2a+eXr20BcI3JDe@pop-os.localdomain>
References: <Y2a+eXr20BcI3JDe@pop-os.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong,

On Sun, 6 Nov 2022 at 03:50, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Oct 31, 2022 at 02:08:35PM +0800, Hawkins Jiawei wrote:
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
> > Kernel will uses tcindex_change() to change an existing
> > traffic-control-indices filter properties. During the
> > process of changing, kernel will clears the old
> > traffic-control-indices filter result, and updates it
> > by RCU assigning new traffic-control-indices data.
> >
> > Yet the problem is that, kernel will clears the old
> > traffic-control-indices filter result, without destroying
> > its tcf_exts structure, which triggers the above
> > memory leak.
> >
> > This patch solves it by using tcf_exts_destroy() to
> > destroy the tcf_exts structure in old
> > traffic-control-indices filter result.
>
> So... your patch can be just the following one-liner, right?

Yes, as you and Jakub points out, all ifdefs can be removed,
and I will refactor those in v2 patch.

>
>
> diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> index 1c9eeb98d826..00a6c04a4b42 100644
> --- a/net/sched/cls_tcindex.c
> +++ b/net/sched/cls_tcindex.c
> @@ -479,6 +479,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>         }
>
>         if (old_r && old_r != r) {
> +               tcf_exts_destroy(&old_r->exts);
>                 err = tcindex_filter_result_init(old_r, cp, net);
>                 if (err < 0) {
>                         kfree(f);

As for the position of the tcf_exts_destroy(), should we
call it after the RCU updating, after
`rcu_assign_pointer(tp->root, cp)` ?

Or the concurrent RCU readers may derefer this freed memory
(Please correct me If I am wrong).

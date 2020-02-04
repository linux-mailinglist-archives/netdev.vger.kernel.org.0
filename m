Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3A9152251
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 23:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgBDW0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 17:26:43 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43103 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgBDW0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 17:26:43 -0500
Received: by mail-ot1-f68.google.com with SMTP id p8so31732oth.10;
        Tue, 04 Feb 2020 14:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2tyk/h0a5VJnd8kvdMaFB4WsulH8yL9zaxL85u/nukc=;
        b=Y5YY69YGmf1AuiAIVEdeg9efVXKtwUiLSWDTlS4u85rN66z2oPsoNfZrKOtt8NQ1pb
         ib57GeSglPL8JIi1AyRkEoSqvOVK+UGOMvhUFVac7mTV2ZuHI+V2apWsj1l3dCCR53Ul
         ULFjbyc9n9PBKdVb6CxAeyxnWIRnGyLwSRLaQ/AQX2xx2Sx4f6rfeWX+6YSEvUa4Jaww
         61ypQjYuNt7BbnpCC9pCTuotlMohUManQAb76dB6zeA/1CRUgAfqPGTdMrXCkcOysCol
         4Relm91jgvfGu4OYAxin8RzqSbk7n/SiYt9X7dsvy/ja6CNfkdIya+hGa9IUVLBYECKP
         WgrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2tyk/h0a5VJnd8kvdMaFB4WsulH8yL9zaxL85u/nukc=;
        b=MGRKhnhOHG0jp0GiA60bkoZbsORCGq0FCUJKvmZUwsCCbLRuoXG3aiDGuybbjPusNf
         SUJj0FOxEC/+/uGG7NgXtk83AcLWUXxEX9l/Az6aFQeBEwD1YKFW9I5Yv9RHgu0EPons
         DJVEdDCf4tYYqh2IzynUe3P6fb/tCjrmrVd9VXiaBSGmIxP2GP0mB+lYo6v0UxvZyYuP
         iUsqivjs9A/brLmjl5rnEfLZDGL05ccJo+dRDJp+t1JNYr/VLo1aX3ft02rWHGUKcb+8
         fq1SwLdP8NbLHUqDM1YisaEJP6lF9C5gy6KyiEWs66QvuOslLxua3iFSUIoKQKYeRa1/
         2+/Q==
X-Gm-Message-State: APjAAAVmrx+l5M1L4TOEk9t0LUr4xkE2R5NDf4rxAg/tDaHhHq55nxqj
        /jEIQcCF9a0c8IyUaT553Gnh2J8jMpSupIiTWNM=
X-Google-Smtp-Source: APXvYqwuANOUUIinBL/+HHdNFA1M9bXhsUTaNEdZlWqhfHxTpT2F9t9pxfN2u8NSAiKzShjrVrUu2K35fxS7kCYyF7s=
X-Received: by 2002:a9d:67cc:: with SMTP id c12mr17600533otn.319.1580855202068;
 Tue, 04 Feb 2020 14:26:42 -0800 (PST)
MIME-Version: 1.0
References: <0000000000009a59d2059dc3c8e9@google.com> <a1673e4f-6382-d7df-6942-6e4ffd2b81ce@gmail.com>
 <20200204.222245.1920371518669295397.davem@davemloft.net>
In-Reply-To: <20200204.222245.1920371518669295397.davem@davemloft.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 4 Feb 2020 14:26:30 -0800
Message-ID: <CAM_iQpVE=B+LDpG=DpiHh_ydUxxhTj_ge-20zgdB4J1OqAfCtQ@mail.gmail.com>
Subject: Re: memory leak in tcindex_set_parms
To:     David Miller <davem@davemloft.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 4, 2020 at 1:22 PM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Tue, 4 Feb 2020 10:03:16 -0800
>
> >
> >
> > On 2/4/20 9:58 AM, syzbot wrote:
> >> Hello,
> >>
> >> syzbot found the following crash on:
> >>
> >> HEAD commit:    322bf2d3 Merge branch 'for-5.6' of git://git.kernel.org/pu..
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=1111f8e6e00000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=8d0490614a000a37
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=f0bbb2287b8993d4fa74
> >> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17db90f6e00000
> >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a94511e00000
> >>
> >> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >> Reported-by: syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com
> >>
> >>
> >
> > Might have been fixed already ?
> >
> > commit 599be01ee567b61f4471ee8078870847d0a11e8e    net_sched: fix an OOB access in cls_tcindex
>
> My reaction was actually that this bug is caused by this commit :)

I think it is neither of the cases, I will test the following change:

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 09b7dc5fe7e0..2495b15ca78c 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -454,6 +454,7 @@ tcindex_set_parms(struct net *net, struct
tcf_proto *tp, unsigned long base,
        oldp = p;
        r->res = cr;
        tcf_exts_change(&r->exts, &e);
+       tcf_exts_destroy(&e);

        rcu_assign_pointer(tp->root, cp);

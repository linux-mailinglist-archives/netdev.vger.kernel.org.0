Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06771C4EBA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgEEHC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725320AbgEEHC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 03:02:27 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1FAC061A0F;
        Tue,  5 May 2020 00:02:27 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id i13so961794oie.9;
        Tue, 05 May 2020 00:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qfsI1Ae/gqByhDdxZCxdOk6CE5/Yy0Hxtg5XtcaRpu8=;
        b=umG6XOaKe/xvpUZeb+ZoINdQdF6RfrbdVKqruPqkdIJ3fN4ToRiF/OLriv7P70gpss
         +7l7G+K7OdLaaw7rteichaKB0E6oUI12pB1ztiSsenG/+MVo4pPUNUOsUiQPXi/Gob3C
         o0xRew0aPGmj1QwayCuMxqN95fzZk17nsUD/lExn8Wlcsheal9pzwjie9/u7PgTrGsyh
         mWnqWj3earegjwCMKdLYOAo0hNQPJLzWM9+Wk8Rk2CGTVltXrw+MmLqBFEloTEGNBeaw
         LUkn7aq2OlSq72zQMipu9yhlE9cWuqFuV7Tjnpah+So7NmMcgCCQvtODO4p9dRk5Hay8
         YhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qfsI1Ae/gqByhDdxZCxdOk6CE5/Yy0Hxtg5XtcaRpu8=;
        b=T1ZzxKnWQvye0APIhOHVVY5s8NmWKw/Oxb98q+WE1DmXsErobofUqezpwPerOOSu7V
         QP/LSRPItAOlbEHjuKHMC9fzSIGakFwG/8DRDjBNOOFvPWzwsqxZYiyBC6xLjHl8QSsz
         VYbAP/zwIgoeeNpB3UvAvNeSPjHkjXgXwLUyJBEek79Hq4JX8R1/DFl9WMs8K5G/SW+M
         BoW/6SWXZkM92jRiIVIcHCFQnNYX1uolXjwJ4lVmCBLWYPymfiyav5pA8hXYVSKvqXUr
         Ktixpm5nelw6RrWxa/STdI9UXiXlY8b+JeqFotZVwubovD1mepNC9crtEnSDGq+QjWdi
         ee4g==
X-Gm-Message-State: AGi0PubSNO4Yh4Mod1TuLaN+M2uj+93Fu1Yw+pcXIz/WHtEeWAIMR0ix
        0b6HuSZDagUprDrYBTYxvJI8z1wO2a7xhp4IAsY=
X-Google-Smtp-Source: APiQypJ2xrC1M/0qN6b4tO9XZLdzWwTN5fdKRF0qgDKiz+8gLvFQDr/+AKJ8ps3kVV5UKQj3RHOQjIA0St1A71S1ZTw=
X-Received: by 2002:a54:4e84:: with SMTP id c4mr1569779oiy.142.1588662146271;
 Tue, 05 May 2020 00:02:26 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005a8fe005a4b8a114@google.com> <20200504190348.iphzmd7micvidh46@treble>
 <CAM_iQpVu11xwKS5OEhDKmtbnP83oFNy9jBoAROS78-ECPEBWdw@mail.gmail.com>
In-Reply-To: <CAM_iQpVu11xwKS5OEhDKmtbnP83oFNy9jBoAROS78-ECPEBWdw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 5 May 2020 00:02:15 -0700
Message-ID: <CAM_iQpVsWkJQaWG01kz8C0J8oSPq23RNKfgAfgUs3dpSDRHFaQ@mail.gmail.com>
Subject: Re: BUG: stack guard page was hit in unwind_next_frame
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     syzbot <syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        shile.zhang@linux.alibaba.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86 <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 6:06 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, May 4, 2020 at 12:08 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> >
> > On Sat, May 02, 2020 at 11:36:11PM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    8999dc89 net/x25: Fix null-ptr-deref in x25_disconnect
> > > git tree:       net
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=16004440100000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=b7a70e992f2f9b68
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=e73ceacfd8560cc8a3ca
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > >
> > > Unfortunately, I don't have any reproducer for this crash yet.
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com
> >
> > Infinite loop in network code.
>
> It is not a loop, it is an unbound recursion where netdev events
> trigger between bond master and slave back and forth.
>
> Let me see how this can be fixed properly.

The following patch works for me, I think it is reasonable to stop
the netdev event propagation from upper to lower device, but I am
not sure whether this will miss the netdev event in complex
multi-layer setups.

diff --git a/net/core/dev.c b/net/core/dev.c
index 522288177bbd..ece50ae346c3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8907,7 +8907,7 @@ static void netdev_sync_lower_features(struct
net_device *upper,
                        netdev_dbg(upper, "Disabling feature %pNF on
lower dev %s.\n",
                                   &feature, lower->name);
                        lower->wanted_features &= ~feature;
-                       netdev_update_features(lower);
+                       __netdev_update_features(lower);

                        if (unlikely(lower->features & feature))
                                netdev_WARN(upper, "failed to disable
%pNF on %s!\n",

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD08A2E1002
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 23:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgLVWIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 17:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbgLVWII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 17:08:08 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D604C0613D3;
        Tue, 22 Dec 2020 14:07:28 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1krpoN-0001oG-Lf; Tue, 22 Dec 2020 23:07:19 +0100
Date:   Tue, 22 Dec 2020 23:07:19 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     syzbot <syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jakub Jelinek <jakub@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: kernel BUG at lib/string.c:LINE! (6)
Message-ID: <20201222220719.GB9639@breakpoint.cc>
References: <000000000000fcbe0705b70e9bd9@google.com>
 <CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Tue, Dec 22, 2020 at 6:44 AM syzbot
> <syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com> wrote:
> >
> > The issue was bisected to:
> >
> > commit 2f78788b55ba ("ilog2: improve ilog2 for constant arguments")
> 
> That looks unlikely, although possibly some constant folding
> improvement might make the fortify code notice something with it.
> 
> > detected buffer overflow in strlen
> > ------------[ cut here ]------------
> > kernel BUG at lib/string.c:1149!
> > Call Trace:
> >  strlen include/linux/string.h:325 [inline]
> >  strlcpy include/linux/string.h:348 [inline]
> >  xt_rateest_tg_checkentry+0x2a5/0x6b0 net/netfilter/xt_RATEEST.c:143
> 
> Honestly, this just looks like the traditional bug in "strlcpy()".

Yes, thats exactly what this is, no idea why the bisection points
at ilog2 changes.

> That BSD function is complete garbage, exactly because it doesn't
> limit the source length. People tend to _think_ it does ("what's that
> size_t argument for?") but strlcpy() only limits the *destination*
> size, and the source is always read fully.

Right, I'll send a patch shortly.

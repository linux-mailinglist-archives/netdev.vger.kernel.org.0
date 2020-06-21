Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC561202A2B
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 12:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbgFUK5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 06:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729848AbgFUK5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 06:57:02 -0400
X-Greylist: delayed 7891 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 21 Jun 2020 03:57:02 PDT
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F29DC061794;
        Sun, 21 Jun 2020 03:57:02 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 9D08BC01A; Sun, 21 Jun 2020 12:57:00 +0200 (CEST)
Date:   Sun, 21 Jun 2020 12:56:45 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Alexander Kapshuk <alexander.kapshuk@gmail.com>
Cc:     lucho@ionkov.net, ericvh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/9p: Validate current->sighand in client.c
Message-ID: <20200621105645.GA21909@nautica>
References: <20200618190807.GA20699@nautica>
 <20200620201456.14304-1-alexander.kapshuk@gmail.com>
 <20200621084512.GA720@nautica>
 <CAJ1xhMWe6qN9RcpmTkJVRkCs+5F=_JtdwsYuFfM7ZckwEkubhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJ1xhMWe6qN9RcpmTkJVRkCs+5F=_JtdwsYuFfM7ZckwEkubhA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Kapshuk wrote on Sun, Jun 21, 2020:
> Thanks for your feedback.
> Shall I simply resend the v2 patch with the commit message reworded as
> you suggested, or should I make it a v3 patch instead?

Yes please resend the same commit reworded. v2 or v3 doesn't matter
much, the [PATCH whatever] part of the mail isn't included in the commit
message; I don't receive so much patches to be fussy about that :)

> One other thing I wanted to clarify is I got a message from kernel
> test robot <lkp@intel.com>,
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/TMTLPYU6A522JH2VCN3PNZVAP6EE5MDF/,
> saying that on parisc my patch resulted in __lock_task_sighand being
> undefined during modpost'ing.
> I've noticed similar messages about other people's patches on the
> linux-kernel mailing list with the responses stating that the issue
> was at the compilation site rather than with the patch itself.
> As far as I understand, that is the case with my patch also. So no
> further action on that is required of me, is it?

Thanks, I hadn't noticed this mail -- unfortunately I don't have
anything setup to test pa risc, but __lock_task_sighand is defined in
kernel/signal.c which is unconditionally compiled so shouldn't have
anything to do with arch-specific failures, so I will run into the same
problem when I test this.

From just looking at the code, it looks like a real problem to me -
__lock_task_sighand is never passed to EXPORT_SYMBOL so when building 9p
as a module we cannot use the function. Only exported symbols can be
called from code that can be built as modules.

That looks like an oversight to me more than something on purpose, but
it does mean I cannot take the patch right now -- we need to first get
the symbol exported before we can use it in 9p.


As things stand I'd rather have this patch wait one cycle for this than
revert to manipulating rcu directly like you did first -- if you're up
for it you can send a patch to get it exported first and I'll pick this
patch up next cycle, or I can take care of that too if you don't want to
bother.

Letting you tell me which you prefer,
-- 
Dominique

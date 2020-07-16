Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7478E221DC0
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 09:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGPH6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 03:58:38 -0400
Received: from nautica.notk.org ([91.121.71.147]:45383 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgGPH6i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 03:58:38 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 637A9C01B; Thu, 16 Jul 2020 09:58:35 +0200 (CEST)
Date:   Thu, 16 Jul 2020 09:58:20 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     David Miller <davem@davemloft.net>
Cc:     hch@lst.de, nazard@nazar.ca, ericvh@gmail.com, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+e6f77e16ff68b2434a2c@syzkaller.appspotmail.com
Subject: Re: [PATCH] net/9p: validate fds in p9_fd_open
Message-ID: <20200716075820.GA3720@nautica>
References: <20200711104923.GA6584@nautica>
 <20200715073715.GA22899@lst.de>
 <20200715134756.GB22828@nautica>
 <20200715.142459.1215411672362681844.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200715.142459.1215411672362681844.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller wrote on Wed, Jul 15, 2020:
> From: Dominique Martinet <asmadeus@codewreck.org>
> Date: Wed, 15 Jul 2020 15:47:56 +0200
> > It's honestly just a warn on something that would fail anyway so I'd
> > rather let it live in -next first, I don't get why syzbot is so verbose
> > about this - it sent a mail when it found a c repro and one more once it
> > bisected the commit yesterday but it should not be sending more?
> 
> I honestly find it hard to understand the resistence to fixing the
> warning in mainline.
> 
> I merge such fixes aggressively.

Well, if it was something a user could ever see with normal (even
exotic) 9p workloads, sure; I would want that in mainline asap and do
what's required in a hurry.

But this warning only happens when passing fd that are invalid, so the
mount would fail with EIO anyway, and it's not a dos either -- I don't
see the harm really.
Someone who'd get errors anyway will just get slightly more verbose
errors (and for people like me with kernel.panic_on_warn set it'll even
crash their machines sure), and "normal" users won't ever see it -- I
see no reason to rush this.


It's not about the "extra work" of sending things to linus in a single
patch PR (it's honestly a wonder 9p gets maintainers at all, the volume
of patches doesn't really mandate it), but I need to fix tests first
anyway as said previously.
I've spent a couple of hours on it yesterday, and should be able to get
things running again soonish -- meanwhile I'm not comfortable sending
any patch anywhere anyway.

Yes given the patch content it's probably fine but syzbot doesn't test
that a 9p mount with a fd argument works, just that there's no warning /
crash, so for all I know we could just be returning -EIO early and
calling it a fix.
I don't see any reason this would fail, but the point of tests is to...
test things work the things we think they do?



Anyways, if you care about this feel free to take the patch and send it
along with your process earlier. I'm just stubborn in not wanting to
send things I could test untested and it came at a bad time / don't
think this is critical enough to manually test. Then again I probably
just spent more time arguing about it than it would have taken to
test...
(if you do please fix the goto as pointed out in a review)

Thanks,
-- 
Dominique

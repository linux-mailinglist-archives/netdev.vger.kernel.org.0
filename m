Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652CF5E80E
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfGCPpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfGCPpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 11:45:46 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A45E4218A0;
        Wed,  3 Jul 2019 15:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562168745;
        bh=nkSctcmSSLmZlOfUl/F8SiptTEAf+xXUe9V+zp4RRj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mAVdCxcjl7wPz5882RmuJ8WHrloDryJ0ZpPtZoci2yc5CaV0chm9E43gkl5v+0fqo
         HwZHZM3w44hSYssUIoHV+r5+SnTAP0Lf/UB9Kb/QQGJhxuGhx6dCpKpUgfmLzQBC1d
         WypMUPV7VkScFWInLcWD1p1yeObEOlAXZ4P8CKl0=
Date:   Wed, 3 Jul 2019 08:45:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+d88a977731a9888db7ba@syzkaller.appspotmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Dave Watson <davejwatson@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: kernel panic: corrupted stack end in dput
Message-ID: <20190703154543.GA21629@sol.localdomain>
References: <20190703064307.13740-1-hdanton@sina.com>
 <20190703144000.GH17978@ZenIV.linux.org.uk>
 <20190703152334.GI17978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703152334.GI17978@ZenIV.linux.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+bpf and tls maintainers]

On Wed, Jul 03, 2019 at 04:23:34PM +0100, Al Viro wrote:
> On Wed, Jul 03, 2019 at 03:40:00PM +0100, Al Viro wrote:
> > On Wed, Jul 03, 2019 at 02:43:07PM +0800, Hillf Danton wrote:
> > 
> > > > This is very much *NOT* fine.
> > > > 	1) trylock can fail from any number of reasons, starting
> > > > with "somebody is going through the hash chain doing a lookup on
> > > > something completely unrelated"
> > > 
> > > They are also a red light that we need to bail out of spiraling up
> > > the directory hierarchy imho.
> > 
> > Translation: "let's leak the reference to parent, shall we?"
> > 
> > > > 	2) whoever had been holding the lock and whatever they'd
> > > > been doing might be over right after we get the return value from
> > > > spin_trylock().
> > > 
> > > Or after we send a mail using git. I don't know.
> > > 
> > > > 	3) even had that been really somebody adding children in
> > > > the same parent *AND* even if they really kept doing that, rather
> > > > than unlocking and buggering off, would you care to explain why
> > > > dentry_unlist() called by __dentry_kill() and removing the victim
> > > > from the list of children would be safe to do in parallel with that?
> > > >
> > > My bad. I have to walk around that unsafety.
> > 
> > WHAT unsafety?  Can you explain what are you seeing and how to
> > reproduce it, whatever it is?
> 
> BTW, what makes you think that it's something inside dput() itself?
> All I see is that at some point in the beginning of the loop body
> in dput() we observe a buggered stack.
> 
> Is that the first iteration through the loop?  IOW, is that just
> the place where we first notice preexisting corruption, or is
> that something the code called from that loop does?  If it's
> a stack overflow, I would be very surprised to see it here -
> dput() is iterative and it's called on a very shallow stack in
> those traces.
> 
> What happens if you e.g. turn that
> 	dput(dentry);
> in __fput() into
> 	rcu_read_lock(); rcu_read_unlock(); // trigger the check
> 	dput(dentry);
> 
> and run your reporducer?
> 

Please don't waste your time on this, it looks like just another report from the
massive memory corruption in BPF and/or TLS.  Look at reproducer:

bpf$MAP_CREATE(0x0, &(0x7f0000000280)={0xf, 0x4, 0x4, 0x400, 0x0, 0x1}, 0x3c)
socket$rxrpc(0x21, 0x2, 0x800000000a)
r0 = socket$inet6_tcp(0xa, 0x1, 0x0)
setsockopt$inet6_tcp_int(r0, 0x6, 0x13, &(0x7f00000000c0)=0x100000001, 0x1d4)
connect$inet6(r0, &(0x7f0000000140), 0x1c)
bpf$MAP_CREATE(0x0, &(0x7f0000000000)={0x5}, 0xfffffffffffffdcb)
bpf$MAP_CREATE(0x2, &(0x7f0000003000)={0x3, 0x0, 0x77fffb, 0x0, 0x10020000000, 0x0}, 0x2c)
setsockopt$inet6_tcp_TCP_ULP(r0, 0x6, 0x1f, &(0x7f0000000040)='tls\x00', 0x4)

It's the same as like 20 other syzbot reports.

- Eric

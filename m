Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DCE5E7BA
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfGCPXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:23:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38800 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCPXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 11:23:40 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hih6c-00069a-6M; Wed, 03 Jul 2019 15:23:34 +0000
Date:   Wed, 3 Jul 2019 16:23:34 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+d88a977731a9888db7ba@syzkaller.appspotmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Subject: Re: kernel panic: corrupted stack end in dput
Message-ID: <20190703152334.GI17978@ZenIV.linux.org.uk>
References: <20190703064307.13740-1-hdanton@sina.com>
 <20190703144000.GH17978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703144000.GH17978@ZenIV.linux.org.uk>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 03:40:00PM +0100, Al Viro wrote:
> On Wed, Jul 03, 2019 at 02:43:07PM +0800, Hillf Danton wrote:
> 
> > > This is very much *NOT* fine.
> > > 	1) trylock can fail from any number of reasons, starting
> > > with "somebody is going through the hash chain doing a lookup on
> > > something completely unrelated"
> > 
> > They are also a red light that we need to bail out of spiraling up
> > the directory hierarchy imho.
> 
> Translation: "let's leak the reference to parent, shall we?"
> 
> > > 	2) whoever had been holding the lock and whatever they'd
> > > been doing might be over right after we get the return value from
> > > spin_trylock().
> > 
> > Or after we send a mail using git. I don't know.
> > 
> > > 	3) even had that been really somebody adding children in
> > > the same parent *AND* even if they really kept doing that, rather
> > > than unlocking and buggering off, would you care to explain why
> > > dentry_unlist() called by __dentry_kill() and removing the victim
> > > from the list of children would be safe to do in parallel with that?
> > >
> > My bad. I have to walk around that unsafety.
> 
> WHAT unsafety?  Can you explain what are you seeing and how to
> reproduce it, whatever it is?

BTW, what makes you think that it's something inside dput() itself?
All I see is that at some point in the beginning of the loop body
in dput() we observe a buggered stack.

Is that the first iteration through the loop?  IOW, is that just
the place where we first notice preexisting corruption, or is
that something the code called from that loop does?  If it's
a stack overflow, I would be very surprised to see it here -
dput() is iterative and it's called on a very shallow stack in
those traces.

What happens if you e.g. turn that
	dput(dentry);
in __fput() into
	rcu_read_lock(); rcu_read_unlock(); // trigger the check
	dput(dentry);

and run your reporducer?

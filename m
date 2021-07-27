Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1999F3D7DCE
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 20:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhG0Six (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 14:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhG0Six (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 14:38:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B61C60F9E;
        Tue, 27 Jul 2021 18:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627411132;
        bh=7P1dk2Zya5Hxz/KwAAaJC49En7ygIfIysjTZnKxCPvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h2ju/8bpR2Yw9THzOV5z3GFnwbg17C1REx2LCLzeeG5RBGFHUn/owLfUTeXNqIg/o
         Z70mgBSwI7MQ/NrLm/LoVqbaqg4zEDgatBR387cBgwKe7jz06+KvjkEceUXf733uxW
         PhLlZe3eYtuvN/ZB9UN8WvHeb1pBlwOX8T/vtI+w=
Date:   Tue, 27 Jul 2021 20:38:50 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "andriin@fb.com" <andriin@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "alobakin@pm.me" <alobakin@pm.me>,
        "weiwan@google.com" <weiwan@google.com>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        "sergey.senozhatsky.work@gmail.com" 
        <sergey.senozhatsky.work@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "mbenes@suse.com" <mbenes@suse.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/module: add documentation for try_module_get()
Message-ID: <YQBSutZfhqfTzKQa@kroah.com>
References: <20210722221905.1718213-1-mcgrof@kernel.org>
 <dbf27fa2f8864e1d91f7015249b1a5f1@AcuMS.aculab.com>
 <YQBCvKgH481C7o1c@bombadil.infradead.org>
 <YQBGemOIF4sp/ges@kroah.com>
 <YQBN2/K4Ne5orgzS@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQBN2/K4Ne5orgzS@bombadil.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 11:18:03AM -0700, Luis Chamberlain wrote:
> On Tue, Jul 27, 2021 at 07:46:34PM +0200, gregkh@linuxfoundation.org wrote:
> > On Tue, Jul 27, 2021 at 10:30:36AM -0700, Luis Chamberlain wrote:
> > > On Sat, Jul 24, 2021 at 12:15:10PM +0000, David Laight wrote:
> > > > From: Luis Chamberlain
> > > > > Sent: 22 July 2021 23:19
> > > > > 
> > > > > There is quite a bit of tribal knowledge around proper use of
> > > > > try_module_get() and that it must be used only in a context which
> > > > > can ensure the module won't be gone during the operation. Document
> > > > > this little bit of tribal knowledge.
> > > > > 
> > > > ...
> > > > 
> > > > Some typos.
> > > > 
> > > > > +/**
> > > > > + * try_module_get - yields to module removal and bumps reference count otherwise
> > > > > + * @module: the module we should check for
> > > > > + *
> > > > > + * This can be used to check if userspace has requested to remove a module,
> > > >                                                            a module be removed
> > > > > + * and if so let the caller give up. Otherwise it takes a reference count to
> > > > > + * ensure a request from userspace to remove the module cannot happen.
> > > > > + *
> > > > > + * Care must be taken to ensure the module cannot be removed during
> > > > > + * try_module_get(). This can be done by having another entity other than the
> > > > > + * module itself increment the module reference count, or through some other
> > > > > + * means which gaurantees the module could not be removed during an operation.
> > > >                   guarantees
> > > > > + * An example of this later case is using this call in a sysfs file which the
> > > > > + * module created. The sysfs store / read file operation is ensured to exist
> > > >                                                             ^^^^^^^^^^^^^^^^^^^
> > > > Not sure what that is supposed to mean.
> > > 
> > > I'll clarify further. How about:
> > > 
> > > The sysfs store / read file operations are gauranteed to exist using
> > > kernfs's active reference (see kernfs_active()).
> > 
> > But that has nothing to do with module reference counts.  kernfs knows
> > nothing about modules.
> 
> Yes but we are talking about sysfs files which the module creates. So
> but inference again, an active reference protects a module.

What active reference?  sysfs creation/removal/rename/whatever right now
has nothing to do with module reference counts as they are totally
disconnected.  kernfs has nothing to do with module reference counts
either.  So I do not know what you are inferring here.

> > > > So there is a potentially horrid race:
> > > > The module unload is going to do:
> > > > 	driver_data->module_ref = 0;
> > > > and elsewhere there'll be:
> > > > 	ref = driver_data->module_ref;
> > > > 	if (!ref || !try_module_get(ref))
> > > > 		return -error;
> > > > 
> > > > You have to have try_module_get() to allow the module unload
> > > > function to sleep.
> > > > But the above code still needs a driver lock to ensure the
> > > > unload code doesn't race with the try_module_get() and the
> > > > 'ref' be invalidated before try_module_get() looks at it.
> > > > (eg if an interrupt defers processing.)
> > > > 
> > > > So there can be no 'yielding'.
> > > 
> > > Oh but there is. Consider access to a random sysfs file 'add_new_device'
> > > which takes as input a name, for driver foo, and so foo's
> > > add_new_foobar_device(name="bar") is called. Unless sysfs file
> > > "yields" by using try_module_get() before trying to add a new
> > > foo device called "bar", it will essentially be racing with the
> > > exit routine of module foo, and depending on how locking is implemented
> > > (most drivers get it wrong), this easily leads to crashes.
> > > 
> > > In fact, this documentation patch was motivated by my own solution to a
> > > possible deadlock when sysfs is used. Using the same example above, if
> > > the same sysfs file uses *any* lock, which is *also* used on the exit
> > > routine, you can easily trigger a deadlock. This can happen for example
> > > by the lock being obtained by the removal routine, then the sysfs file
> > > gets called, waits for the lock to complete, then the module's exit
> > > routine starts cleaning up and removing sysfs files, but we won't be
> > > able to remove the sysfs file (due to kernefs active reference) until
> > > the sysfs file complets, but it cannot complete because the lock is
> > > already held.
> > > 
> > > Yes, this is a generic problem. Yes I have proof [0]. Yes, a generic
> > > solution has been proposed [1], and because Greg is not convinced and I
> > > need to move on with life, I am suggesting a temporary driver specific
> > > solution (to which Greg is still NACK'ing, without even proposing any
> > > alternatives) [2].
> > > 
> > > [0] https://lkml.kernel.org/r/20210703004632.621662-5-mcgrof@kernel.org
> > > [1] https://lkml.kernel.org/r/20210401235925.GR4332@42.do-not-panic.com 
> > > [2] https://lkml.kernel.org/r/20210723174919.ka3tzyre432uilf7@garbanzo
> > 
> > My problem with your proposed solution is that it is still racy, you can
> > not increment your own module reference count from 0 -> 1 and expect it
> > to work properly.  You need external code to do that somewhere.
> 
> You are not providing *any* proof for this.

I did provide proof of that.  Here it is again.

Consider these lines of code:

 1	int foo(int baz)
 2	{
 3		int retval
 4
 5		if (!try_module_get(THIS_MODULE))
 6			return -ERROR;
 7		retval = do_something(baz)
 8		put_module(THIS_MODULE);
 9		return retval;
10	}

Going into the call to foo(), there is no reference held on THIS_MODULE.

Right before line 5 is called (or really, right before the jump to
try_module_get(), yet still within foo() (i.e. lines 2-4 where you have
fun stack frames set up, and ftrace hooks, and other nifty things),
userspace asks for the module to be unloaded, and the module is removed
from the system and the memory for this code is overwritten with all
0x00.

Then, we try to call into try_module_get(), but yet, that call
instruction is gone and boom.

Or better yet, after put_module() is called, the module is unloaded
_before_ the return happens.  Then we try to make the return jump back,
but that instruction was overwritten with all 0x00.  Or different code
because a new module was loaded then.

Yes, your window is smaller, but it is still there, and still can be
triggered.  That is why in the 2.5 days we removed almost all instances
of this pattern.  There are still some floating around in the kernel,
but odds are they are broken because NO ONE TESTS UNLOADING MODULES
UNDER STRESS.

Except your crazy customer :)

> And even so, I believe I have clarified as best as possible how a
> kernfs active reference implicitly protects the module when we are
> talking about sysfs files.

I do not see any link anywhere between kernfs and modules, what am I
missing?  Pointers to lines of code would be appreciated.

> > Now trying to tie sysfs files to the modules that own them would be
> > nice, but as we have seen, that way lies way too many kernel changes,
> > right?
> 
> It's not a one-liner fix. Yes.
> 
> > Hm, maybe.  Did we think about this from the kobj_attribute level?  If
> > we use the "wrapper" logic there and the use of the macros we already
> > have for attributes, we might be able to get the module pointer directly
> > "for free".
> >
> > Did we try that?
> 
> That was my hope. I tried that first. Last year in November I determined
> kernfs is kobject stupid. But more importantly *neither* are struct device
> specific, so neither of them have semantics for modules or even devices.

But what about at the kobject level?

I will try to look at that this week, can't promise anything...

greg k-h

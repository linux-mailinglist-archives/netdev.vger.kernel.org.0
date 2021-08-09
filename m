Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648623E4EAC
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbhHIVlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:41:51 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:60482 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbhHIVls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:41:48 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDD1L-009NHX-Gh; Mon, 09 Aug 2021 21:41:19 +0000
Date:   Mon, 9 Aug 2021 21:41:19 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        christian.brauner@ubuntu.com, cong.wang@bytedance.com,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        jamorris@linux.microsoft.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, shuah@kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 _copy_to_iter
Message-ID: <YRGg/yTXTAL/1whP@zeniv-ca.linux.org.uk>
References: <0000000000006bd0b305c914c3dc@google.com>
 <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
 <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
 <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com>
 <CACT4Y+bFLFg9WUiGWq=8ubKFug47=XNjqQJkTX3v1Hos0r+Z_A@mail.gmail.com>
 <2901262f-1ba7-74c0-e5fc-394b65414d12@oracle.com>
 <YRGKWP7/n7+st7Ko@zeniv-ca.linux.org.uk>
 <YRGNIduUvw/kCLIU@zeniv-ca.linux.org.uk>
 <c1ec22f6-ed3b-fe70-2c7e-38a534f01d2b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1ec22f6-ed3b-fe70-2c7e-38a534f01d2b@oracle.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 01:37:08PM -0700, Shoaib Rao wrote:

> > +#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
> > +               mutex_lock(&u->iolock);
> > +               unix_state_lock(sk);
> > +
> > +               err = unix_stream_recv_urg(state);
> > +
> > +               unix_state_unlock(sk);
> > +               mutex_unlock(&u->iolock);
> > +#endif
> > 
> > is 100% broken, since you *are* attempting to copy data to userland between
> > spin_lock(&unix_sk(s)->lock) and spin_unlock(&unix_sk(s)->lock).
> 
> Yes, but why are we calling it unix_state_lock() why not
> unix_state_spinlock() ?

We'd never bothered with such naming conventions; keep in mind that
locking rules can and do change from time to time, and encoding the
nature of locking primitive into the name would result in tons of
noise.

> I have tons of experience doing kernel coding and you can never ever cover
> everything, that is why I wanted to root cause the issue instead of just
> turning off the check.
> 
> Imagine you or Eric make a mistake and break the kernel, how would you guys
> feel if I were to write a similar email?

Moderately embarrassed, at a guess, but what would that have to do with
somebody pointing the bug out?  Bonehead mistakes happen, they are embarrassing
no matter who catches them - trust me, it's no less unpleasant when you end
up being one who finds your own bug months after it went into the tree.  Been
there, done that...

Since you asked, as far as my reactions normally go:
	* I made a mistake that ended up screwing people over => can be
hideously embarrassing, no matter what.  No cause for that in your case,
AFAICS - it hadn't even gone into mainline yet.
	* I made a dumb mistake that got caught (again, doesn't matter
by whom) => unpleasant; shit happens (does it ever), but that's not
a tragedy.  Ought to look for the ways to catch the same kind of mistakes
and see if I have stepped into the same problem anywhere else - often
enough the blind spots strike more than once.  If the method of catching
the same kind of crap ends up being something like 'grep for <pattern>,
manually check the instances to weed out the false positive'... might
be worth running over the tree; often enough the blind spots are shared.
Would be partially applicable in your case ("if using an unfamiliar locking
helper, check what it does"), but not easily greppable.
	* I kept looking at bug report, missing the relevant indicators
despite the increasingly direct references to those by other people =>
mildly embarrassing (possibly more than mildly, if that persists for long).
Ought to get some coffee, wake up properly (if applicable, that is) and make
notes for myself re what to watch out for.  Partially applicable here;
I'm no telepath, but at a guess you missed the list of locks in the report
_and_ missed repeated references to some spinlock being involved.
Since the call chain had not (AFAICS) been missed, the question
"which spinlock do they keep blathering about?" wouldn't have been hard.
Might be useful to make note of, for the next time you have to deal with
such reports.
	* Somebody starts asking whether I bloody understand something
trivial => figure out what does that have to do with the situation at
hand, reply with the description of what I'd missed (again, quite possibly
the answer will be "enough coffee") and move on to figuring out how to
fix the damn bug.  Not exactly applicable here - the closest I can see
is Eric's question regarding the difference between mutex and spinlock.
In similar situation I'd go with something along the lines of "Sorry,
hadn't spotted the spinlock in question"; your reply had been a bit
more combative than that, but that's a matter of taste.  None of my
postings would fit into that class, AFAICS...
	* Somebody explains (in painful details) what's wrong with the
code => more or less the same as above, only with less temptation (for
me) to get defensive.  Reactions vary - some folks find it more offensive
than the previous one, but essentially it's the same thing.

	The above describes my reactions, in case it's not obvious -
I'm not saying that everyone should react the same way, but you've
asked how would I (or Eric) react in such-and-such case.  And I can't
speak for Eric, obviously...

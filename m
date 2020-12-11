Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F202D7AFB
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 17:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406791AbgLKQbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 11:31:46 -0500
Received: from smtp8.emailarray.com ([65.39.216.67]:11101 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395361AbgLKQbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 11:31:11 -0500
Received: (qmail 56187 invoked by uid 89); 11 Dec 2020 16:30:25 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 11 Dec 2020 16:30:25 -0000
Date:   Fri, 11 Dec 2020 08:30:17 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next] bpf: increment and use correct thread
 iterator
Message-ID: <20201211163017.3fjxnuickl2m523m@bsd-mbp.dhcp.thefacebook.com>
References: <20201204034302.2123841-1-jonathan.lemon@gmail.com>
 <2b90f131-5cb0-3c67-ea2e-f2c66ad918a7@fb.com>
 <20201204171452.bl4foim6x7nf3vvn@bsd-mbp.dhcp.thefacebook.com>
 <e6e8dd8c-f537-bea8-93ac-4badd3234c85@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6e8dd8c-f537-bea8-93ac-4badd3234c85@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 11:02:54AM -0800, Yonghong Song wrote:
> 
> 
> Maybe you can post v3 of the patch with the above information in the
> commit description so people can better understand what the problem
> you are trying to solve here?
> 
> Also, could you also send to bpf@vger.kernel.org?

Sure, I can do that.

> > > > If unable to obtain the file structure for the current task,
> > > > proceed to the next task number after the one returned from
> > > > task_seq_get_next(), instead of the next task number from the
> > > > original iterator.
> > > This seems a correct change. The current code should still work
> > > but it may do some redundant/unnecessary work in kernel.
> > > This only happens when a task does not have any file,
> > > no sure whether this is the culprit for the problem this
> > > patch tries to address.
> > > 
> > > > 
> > > > Use thread_group_leader() instead of comparing tgid vs pid, which
> > > > might may be racy.
> > > 
> > > I see
> > > 
> > > static inline bool thread_group_leader(struct task_struct *p)
> > > {
> > >          return p->exit_signal >= 0;
> > > }
> > > 
> > > I am not sure whether thread_group_leader(task) is equivalent
> > > to task->tgid == task->pid or not. Any documentation or explanation?
> > > 
> > > Could you explain why task->tgid != task->pid in the original
> > > code could be racy?
> > 
> > My understanding is that anything which uses pid_t for comparision
> > in the kernel is incorrect.  Looking at de_thread(), there is a
> > section which swaps the pid and tids around, but doesn't seem to
> > change tgid directly.
> > 
> > There's also this comment in linux/pid.h:
> >          /*
> >           * Both old and new leaders may be attached to
> >           * the same pid in the middle of de_thread().
> >           */
> > 
> > So the safest thing to do is use the explicit thread_group_leader()
> > macro rather than trying to open code things.
> 
> I did some limited experiments and did not trigger a case where
> task->tgid != task->pid not agreeing with !thread_group_leader().
> Will need more tests in the environment to reproduce the warning
> to confirm whether this is the culprit or not.

Perhaps, but on the other hand, the splats disappear with this 
patch, so it's doing something right.  If your debug code hasn't
detected any cases where thread_group_leader() isn't making a 
difference, then there shouldn't be any objections in making the 
replacement, right?  It does make the code easier to understand
and matches the rest of the kernel.
-- 
Jonathan

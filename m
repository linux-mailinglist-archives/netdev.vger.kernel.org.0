Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9360DB8604
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 00:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405305AbfISW0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 18:26:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55952 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406829AbfISWWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 18:22:25 -0400
Received: from static-dcd-cqq-121001.business.bouyguestelecom.com ([212.194.121.1] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iB4ob-0007Gc-Nt; Thu, 19 Sep 2019 22:22:17 +0000
Date:   Fri, 20 Sep 2019 00:22:16 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jann Horn <jannh@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com,
        Song Liu <songliubraving@fb.com>, yhs@fb.com,
        kernel list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: Re: [PATCH v1 1/3] seccomp: add SECCOMP_USER_NOTIF_FLAG_CONTINUE
Message-ID: <20190919222143.o3pumstojzhgfw4v@wittgenstein>
References: <20190919095903.19370-1-christian.brauner@ubuntu.com>
 <20190919095903.19370-2-christian.brauner@ubuntu.com>
 <CAG48ez1QkJAMgTpqv4EqbDmYPPpxuB8cR=XhUAr1fHZOBY_DHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG48ez1QkJAMgTpqv4EqbDmYPPpxuB8cR=XhUAr1fHZOBY_DHg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 09:37:06PM +0200, Jann Horn wrote:
> On Thu, Sep 19, 2019 at 11:59 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> > This allows the seccomp notifier to continue a syscall.
> [...]
> > Recently we landed seccomp support for SECCOMP_RET_USER_NOTIF (cf. [4])
> > which enables a process (watchee) to retrieve an fd for its seccomp
> > filter. This fd can then be handed to another (usually more privileged)
> > process (watcher). The watcher will then be able to receive seccomp
> > messages about the syscalls having been performed by the watchee.
> [...]
> > This can be solved by
> > telling seccomp to resume the syscall.
> [...]
> > @@ -780,8 +783,14 @@ static void seccomp_do_user_notification(int this_syscall,
> >                 list_del(&n.list);
> >  out:
> >         mutex_unlock(&match->notify_lock);
> > +
> > +       /* Userspace requests to continue the syscall. */
> > +       if (flags & SECCOMP_USER_NOTIF_FLAG_CONTINUE)
> > +               return 0;
> > +
> >         syscall_set_return_value(current, task_pt_regs(current),
> >                                  err, ret);
> > +       return -1;
> >  }
> 
> Seccomp currently expects the various seccomp return values to be
> fully ordered based on how much action the kernel should take against
> the requested syscall. Currently, the range of return values is
> basically divided into three regions: "block syscall in some way"
> (from SECCOMP_RET_KILL_PROCESS to SECCOMP_RET_USER_NOTIF), "let ptrace
> decide" (SECCOMP_RET_TRACE) and "allow" (SECCOMP_RET_LOG and
> SECCOMP_RET_ALLOW). If SECCOMP_RET_USER_NOTIF becomes able to allow
> syscalls, it will be able to override a negative decision from
> SECCOMP_RET_TRACE.
> 
> In practice, that's probably not a big deal, since I'm not aware of
> anyone actually using SECCOMP_RET_TRACE for security purposes, and on
> top of that, you'd have to allow ioctl(..., SECCOMP_IOCTL_NOTIF_SEND,
> ...) and seccomp() with SECCOMP_FILTER_FLAG_NEW_LISTENER in your
> seccomp policy for this to work.
> 
> More interestingly, what about the case where two
> SECCOMP_RET_USER_NOTIF filters are installed? The most recently
> installed filter takes precedence if the return values's action parts
> are the same (and this is also documented in the manpage); so if a
> container engine installs a filter that always intercepts sys_foobar()
> (and never uses SECCOMP_USER_NOTIF_FLAG_CONTINUE), and then something
> inside the container also installs a filter that always intercepts
> sys_foobar() (and always uses SECCOMP_USER_NOTIF_FLAG_CONTINUE), the
> container engine's filter will become ineffective.

Excellent point. We discussed the nested container case today.

> 
> With my tendency to overcomplicate things, I'm thinking that maybe it
> might be a good idea to:
>  - collect a list of all filters that returned SECCOMP_RET_USER_NOTIF,
> as well as the highest-precedence return value that was less strict
> than SECCOMP_RET_USER_NOTIF
>  - sequentially send notifications to all of the
> SECCOMP_RET_USER_NOTIF filters until one doesn't return
> SECCOMP_USER_NOTIF_FLAG_CONTINUE
>  - if all returned SECCOMP_USER_NOTIF_FLAG_CONTINUE, go with the
> highest-precedence return value that was less strict than
> SECCOMP_RET_USER_NOTIF, or allow if no such return value was
> encountered
> 
> But perhaps, for now, it would also be enough to just expand the big
> fat warning note and tell people that if they allow the use of
> SECCOMP_IOCTL_NOTIF_SEND and SECCOMP_FILTER_FLAG_NEW_LISTENER in their
> filter, SECCOMP_RET_USER_NOTIF is bypassable. And if someone actually
> has a usecase where SECCOMP_RET_USER_NOTIF should be secure and nested
> SECCOMP_RET_USER_NOTIF support is needed, that more complicated logic
> could be added later?

Yes, I think that is the correct approach for now.
Realistically, the most useful scenario is a host-privileged supervisor
process and a user-namespaced supervised process (or to use a concrete
example, a host-privileged container manager and an unprivileged
container). Having a user-namespaced supervisor process supervising
another nested user-namespaced process is for the most part useless
because the supervisor can't do any of the interesting syscalls (e.g.
mounting block devices that are deemed safe, faking mknod() etc.). So I
expect seccomp with USER_NOTIF to be blocked just for good measure. 
Also - maybe I'm wrong - the warning we added points out that this is
only safe if the supervised process can already rely on kernel (or
other) restrictions, i.e. even if an attacker overwrites pointer syscall
arguments with harmful ones the supervisor must be sure that they are
already blocked anyway. Which can be generalized to: if an unwanted
syscall goes through in _some_ way then the supervisor must be sure that
it is blocked.
Iiuc, for your specific attack all the nested attacker can do is to
never actually get the (outer) supervisor to fake the syscall for it.
A more interesting case might be where the host-privileged supervising
process wants to deny a syscall that would otherwise succeed. But if
that's the case then the outer supervisor is trying to implement a
security policy. But we explicitly point out that this is not possible
with the notifier in general.
But honestly, that is very advanced and it seems unlikely that someone
would want this. So I'd say let's just point this out.

Christian

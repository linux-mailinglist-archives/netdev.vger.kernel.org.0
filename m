Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391BB394565
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 17:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbhE1Ptc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 11:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbhE1Pt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 11:49:29 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF37C061574
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 08:47:53 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id h24so2091334ejy.2
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 08:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cedQ3gdQGSeryyIBkgL2iEXtO51+6C0BVmoVaS+PlM8=;
        b=cV3BLzZEFVqzScfaH+W2YK1IING9yBQLn3zs/n4gZ/1QFQkDsq4/sT+Oz99jSji5OB
         zMnYo8T2L2JzSDnjz3XCqMFWyADusnMnQUIYhGMPTz7q4lfwQiaODHEtfNCa3vdf1sUN
         qiVX84dZNOsQWGTudOMSBi3ad6uuqnawwLDXa8x2HKDGZ5kHWAcQUYPTvufJzA8W0211
         2H79PEPxxkqVJMjWi2CozKYpkBJGsoo491sHWLofkgqkGyNujdcBqMelLZi4dmYHCj8b
         pOKX1NVawxYnhgJQJAJRofEZRnqYwlQwS4zBKPV3A/knri21lHjUHOk4+i++RwAMO6gZ
         ra4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cedQ3gdQGSeryyIBkgL2iEXtO51+6C0BVmoVaS+PlM8=;
        b=Yi1msfFdoHF6sjjkwmZKlBKxDQlBC5VE0iEBZvV9h6Yp3fOam6vBERho/gGdA3jhEa
         DVH1LKMQgtW9aP2hHtjF9hV0PdoU4fZ4YWllU20JrynfBEqtz2YkJ6UlzflOXB/7QE0l
         2eqAJB6ALxRaaLcCS8UITdS5ALK8kp0YntrI66QMXFXst8kxSDEivsBwyxe6eQ5y1mAt
         lEEVsRB/Pj5qIDNSMDPRske55jng2IOir9kU2Fl5KyDibKfffk28eEJSuFr55Q4/LuT5
         9QFeRqYC/ZfQhCeQLl8rfjddAs3qSkGHPAa+VlixYsgCizQXMAkOck4eQLFfHAZ1JV96
         DFdA==
X-Gm-Message-State: AOAM533NS8uXJQVXw4hdULMk981L469N17xpBWhtYuk8rrBNL5V+EIDF
        K+HEbTgCMWOmHECh13LD+ufY7o7a6AVJckrsomHF
X-Google-Smtp-Source: ABdhPJy5zGrumOsF35e9/C8VOmP4TnS6oe5zK2otc0QgHld1PJrO+rbOMzZA/egUo9LAH2Kzd15DYfSROZYt4coiLJ8=
X-Received: by 2002:a17:906:840c:: with SMTP id n12mr9552143ejx.431.1622216871579;
 Fri, 28 May 2021 08:47:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210517092006.803332-1-omosnace@redhat.com> <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net>
In-Reply-To: <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 28 May 2021 11:47:40 -0400
Message-ID: <CAHC9VhR-kYmMA8gsqkiL5=poN9FoL-uCyx1YOLCoG2hRiUBYug@mail.gmail.com>
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>, jolsa@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 3:10 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 5/28/21 3:37 AM, Paul Moore wrote:
> > On Mon, May 17, 2021 at 5:22 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> >>
> >> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
> >> lockdown") added an implementation of the locked_down LSM hook to
> >> SELinux, with the aim to restrict which domains are allowed to perform
> >> operations that would breach lockdown.
> >>
> >> However, in several places the security_locked_down() hook is called in
> >> situations where the current task isn't doing any action that would
> >> directly breach lockdown, leading to SELinux checks that are basically
> >> bogus.
> >>
> >> Since in most of these situations converting the callers such that
> >> security_locked_down() is called in a context where the current task
> >> would be meaningful for SELinux is impossible or very non-trivial (and
> >> could lead to TOCTOU issues for the classic Lockdown LSM
> >> implementation), fix this by modifying the hook to accept a struct cred
> >> pointer as argument, where NULL will be interpreted as a request for a
> >> "global", task-independent lockdown decision only. Then modify SELinux
> >> to ignore calls with cred == NULL.
> >
> > I'm not overly excited about skipping the access check when cred is
> > NULL.  Based on the description and the little bit that I've dug into
> > thus far it looks like using SECINITSID_KERNEL as the subject would be
> > much more appropriate.  *Something* (the kernel in most of the
> > relevant cases it looks like) is requesting that a potentially
> > sensitive disclosure be made, and ignoring it seems like the wrong
> > thing to do.  Leaving the access control intact also provides a nice
> > avenue to audit these requests should users want to do that.
>
> I think the rationale/workaround for ignoring calls with cred == NULL (or the previous
> patch with the unimplemented hook) from Ondrej was two-fold, at least speaking for his
> seen tracing cases:
>
>    i) The audit events that are triggered due to calls to security_locked_down()
>       can OOM kill a machine, see below details [0].
>
>   ii) It seems to be causing a deadlock via slow_avc_audit() -> audit_log_end()
>       when presumingly trying to wake up kauditd [1].
>
> How would your suggestion above solve both i) and ii)?

First off, a bit of general commentary - I'm not sure if Ondrej was
aware of this, but info like that is good to have in the commit
description.  Perhaps it was in the linked RHBZ but I try not to look
at those when reviewing patches; the commit descriptions must be
self-sufficient since we can't rely on the accessibility or the
lifetime of external references.  It's fine if people want to include
external links in their commits, I would actually even encourage it in
some cases, but the links shouldn't replace a proper description of
the problem and why the proposed solution is The Best Solution.

With that out of the way, it sounds like your issue isn't so much the
access check, but rather the frequency of the access denials and the
resulting audit records in your particular use case.  My initial
reaction is that you might want to understand why you are getting so
many SELinux access denials, your loaded security policy clearly does
not match with your intended use :)  Beyond that, if you want to
basically leave things as-is but quiet the high frequency audit
records that result from these SELinux denials you might want to look
into the SELinux "dontaudit" policy rule, it was created for things
like this.  Some info can be found in The SELinux Notebook, relevant
link below:

* https://github.com/SELinuxProject/selinux-notebook/blob/main/src/avc_rules.md#dontaudit

The deadlock issue that was previously reported remains an open case
as far as I'm concerned; I'm presently occupied trying to sort out a
rather serious issue with respect to io_uring and LSM/audit (plus
general stuff at $DAYJOB) so I haven't had time to investigate this
any further.  Of course anyone else is welcome to dive into it (I
always want to encourage this, especially from "performance people"
who just want to shut it all off), however if the answer is basically
"disable LSM and/or audit checks" you have to know that it is going to
result in a high degree of skepticism from me, so heavy documentation
on why it is The Best Solution would be a very good thing :)  Beyond
that, I think the suggestions above of "why do you have so many policy
denials?" and "have you looked into dontaudit?" are solid places to
look for a solution in your particular case.

> >> Since most callers will just want to pass current_cred() as the cred
> >> parameter, rename the hook to security_cred_locked_down() and provide
> >> the original security_locked_down() function as a simple wrapper around
> >> the new hook.
>
> [...]
> >
> >> 3. kernel/trace/bpf_trace.c:bpf_probe_read_kernel{,_str}_common()
> >>       Called when a BPF program calls a helper that could leak kernel
> >>       memory. The task context is not relevant here, since the program
> >>       may very well be run in the context of a different task than the
> >>       consumer of the data.
> >>       See: https://bugzilla.redhat.com/show_bug.cgi?id=1955585
> >
> > The access control check isn't so much who is consuming the data, but
> > who is requesting a potential violation of a "lockdown", yes?  For
> > example, the SELinux policy rule for the current lockdown check looks
> > something like this:
> >
> >    allow <who> <who> : lockdown { <reason> };
> >
> > It seems to me that the task context is relevant here and performing
> > the access control check based on the task's domain is correct.
>
> This doesn't make much sense to me, it's /not/ the task 'requesting a potential
> violation of a "lockdown"', but rather the running tracing program which is e.g.
> inspecting kernel data structures around the triggered event. If I understood
> you correctly, having an 'allow' check on, say, httpd would be rather odd since
> things like perf/bcc/bpftrace/systemtap/etc is installing the tracing probe instead.
>
> Meaning, if we would /not/ trace such events (like in the prior mentioned syscall
> example), then there is also no call to the security_locked_down() from that same/
> unmodified application.

My turn to say that you don't make much sense to me :)

Let's reset.

What task_struct is running the BPF tracing program which is calling
into security_locked_down()?  My current feeling is that it is this
context/domain/cred that should be used for the access control check;
in the cases where it is a kernel thread, I think passing NULL is
reasonable, but I think the proper thing for SELinux is to interpret
NULL as kernel_t.

-- 
paul moore
www.paul-moore.com

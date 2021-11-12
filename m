Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6076044DF9E
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 02:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhKLBLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 20:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKLBLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 20:11:34 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF95C061766;
        Thu, 11 Nov 2021 17:08:44 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id v22so2396808qtx.8;
        Thu, 11 Nov 2021 17:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5n/yTDCK8CRJjJdsGfPnssp0jZQU00+EZOCC5bWYfFU=;
        b=eUFcPQH0+0JCmXaHUH4Vr/Q5I/Z1D9/oJh0q7uzMisY7Jtkb5gI3JH1sT/SXrOnOpM
         g8HruycYIChrcCipVEllN5Jv8xJ9gLMJbZJYA+E9KWfKOR/8BBWgxzKkF36mXpIJl8mo
         AR7yOz9wVNZCVBNfJE2jqwfJ/7PdIp7P3B5BRlZp+dIsl7df4Ul6d7n0jSVwTh+dpOjr
         WVodnD6rwOxGWD7SPgfwN9oK2dZK8zg9hzw7+Px7+Uiy7HarZuqFKe5a4OVNJmOVTpT+
         2CR/bSkH8UZfCQ6riWAIYRGWE9B9EqVtxsKAv26PNJPjaujKiyzLnRf0tb69K1PfaFd9
         Ph0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5n/yTDCK8CRJjJdsGfPnssp0jZQU00+EZOCC5bWYfFU=;
        b=u7yTapVgQVR8mJzwI72o0xRMoYMoySGn4NWOuy7tc3DZbfxvYAq8j8io/DptXca1Ws
         ir/di8hpMHIJnOV84IHUh0cQ5n2Rc/FdN0g+pJF/ftgiqHjBYV8LnI+D70/4aQU3rLiU
         YaOMIGWNvn3kHwWZYrIjzSfYUBWA1fDY1QlmACeRwF8i/R8eI1DoV3tD/EApEcKnGUzG
         VdHyKkh+6Jj/HT4NPrdMHiFmz9zy7uY2C13P+zUmVt/kRlLCsc4il2rWdUjxq9vtHZcr
         nsCrDjajBn1znyLS9frPRCbXiLBjEAYCvxEH2zpx2lZlZL/YI4pnx5fwGStYkplfMSb2
         mvmw==
X-Gm-Message-State: AOAM5302NBQmmMSGEP5fPMG7QEI/B0N9eXhCr+BSnqdHW4pWQ27YDJ8c
        UTMZpTUG/u9KnK++RvrmQOYlmPPwnQW0//UHPec=
X-Google-Smtp-Source: ABdhPJwuSkW7GcYwHPj4mRDzO3ZZvr5ZfE3/Da4Wdt9UsnAM5SMYhEoz/FAMUpgFUYTswEasTP0wQZl74+yXE4QGJ/E=
X-Received: by 2002:a05:622a:194:: with SMTP id s20mr12344990qtw.66.1636679323658;
 Thu, 11 Nov 2021 17:08:43 -0800 (PST)
MIME-Version: 1.0
References: <20211108083840.4627-1-laoar.shao@gmail.com> <20211108083840.4627-5-laoar.shao@gmail.com>
 <a13c0541-59a3-6561-6d42-b51fef9f7c8b@redhat.com> <b495d38d-5cdd-8a33-b9d3-de721095ccab@redhat.com>
 <YYz/4bSdSXR3Palz@alley> <70dd5e1c-99c9-c1ca-4e3f-1a894896cf06@redhat.com>
In-Reply-To: <70dd5e1c-99c9-c1ca-4e3f-1a894896cf06@redhat.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 12 Nov 2021 09:08:05 +0800
Message-ID: <CALOAHbBcetHc9h436L9aHv17R+noERrZ0kETSEW9MfW7OOdQkg@mail.gmail.com>
Subject: Re: [PATCH 4/7] fs/binfmt_elf: use get_task_comm instead of
 open-coded string copy
To:     David Hildenbrand <david@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 7:47 PM David Hildenbrand <david@redhat.com> wrote:
>
> On 11.11.21 12:34, Petr Mladek wrote:
> > On Thu 2021-11-11 11:06:04, David Hildenbrand wrote:
> >> On 11.11.21 11:03, David Hildenbrand wrote:
> >>> On 08.11.21 09:38, Yafang Shao wrote:
> >>>> It is better to use get_task_comm() instead of the open coded string
> >>>> copy as we do in other places.
> >>>>
> >>>> struct elf_prpsinfo is used to dump the task information in userspace
> >>>> coredump or kernel vmcore. Below is the verfication of vmcore,
> >>>>
> >>>> crash> ps
> >>>>    PID    PPID  CPU       TASK        ST  %MEM     VSZ    RSS  COMM
> >>>>       0      0   0  ffffffff9d21a940  RU   0.0       0      0  [swapper/0]
> >>>>>     0      0   1  ffffa09e40f85e80  RU   0.0       0      0  [swapper/1]
> >>>>>     0      0   2  ffffa09e40f81f80  RU   0.0       0      0  [swapper/2]
> >>>>>     0      0   3  ffffa09e40f83f00  RU   0.0       0      0  [swapper/3]
> >>>>>     0      0   4  ffffa09e40f80000  RU   0.0       0      0  [swapper/4]
> >>>>>     0      0   5  ffffa09e40f89f80  RU   0.0       0      0  [swapper/5]
> >>>>       0      0   6  ffffa09e40f8bf00  RU   0.0       0      0  [swapper/6]
> >>>>>     0      0   7  ffffa09e40f88000  RU   0.0       0      0  [swapper/7]
> >>>>>     0      0   8  ffffa09e40f8de80  RU   0.0       0      0  [swapper/8]
> >>>>>     0      0   9  ffffa09e40f95e80  RU   0.0       0      0  [swapper/9]
> >>>>>     0      0  10  ffffa09e40f91f80  RU   0.0       0      0  [swapper/10]
> >>>>>     0      0  11  ffffa09e40f93f00  RU   0.0       0      0  [swapper/11]
> >>>>>     0      0  12  ffffa09e40f90000  RU   0.0       0      0  [swapper/12]
> >>>>>     0      0  13  ffffa09e40f9bf00  RU   0.0       0      0  [swapper/13]
> >>>>>     0      0  14  ffffa09e40f98000  RU   0.0       0      0  [swapper/14]
> >>>>>     0      0  15  ffffa09e40f9de80  RU   0.0       0      0  [swapper/15]
> >>>>
> >>>> It works well as expected.
> >>>>
> >>>> Suggested-by: Kees Cook <keescook@chromium.org>
> >>>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> >>>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >>>> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> >>>> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> >>>> Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> >>>> Cc: Peter Zijlstra <peterz@infradead.org>
> >>>> Cc: Steven Rostedt <rostedt@goodmis.org>
> >>>> Cc: Matthew Wilcox <willy@infradead.org>
> >>>> Cc: David Hildenbrand <david@redhat.com>
> >>>> Cc: Al Viro <viro@zeniv.linux.org.uk>
> >>>> Cc: Kees Cook <keescook@chromium.org>
> >>>> Cc: Petr Mladek <pmladek@suse.com>
> >>>> ---
> >>>>  fs/binfmt_elf.c | 2 +-
> >>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> >>>> index a813b70f594e..138956fd4a88 100644
> >>>> --- a/fs/binfmt_elf.c
> >>>> +++ b/fs/binfmt_elf.c
> >>>> @@ -1572,7 +1572,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
> >>>>    SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
> >>>>    SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
> >>>>    rcu_read_unlock();
> >>>> -  strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
> >>>> +  get_task_comm(psinfo->pr_fname, p);
> >>>>
> >>>>    return 0;
> >>>>  }
> >>>>
> >>>
> >>> We have a hard-coded "pr_fname[16]" as well, not sure if we want to
> >>> adjust that to use TASK_COMM_LEN?
> >>
> >> But if the intention is to chance TASK_COMM_LEN later, we might want to
> >> keep that unchanged.
> >
> > It seems that len will not change in the end. Another solution is
> > going to be used for the long names, see
> > https://lore.kernel.org/r/20211108084142.4692-1-laoar.shao@gmail.com.
>
> Yes, that's what I recall as well. The I read the patch
> subjects+descriptions in this series "make it adopt to task comm size
> change" and was slightly confused.
>
> Maybe we should just remove any notion of "task comm size change" from
> this series and instead just call it a cleanup.
>
>

Agreed that it may make a little confused for the one who didn't
engage in this series at the first place.
I will improve the subjection+description.


-- 
Thanks
Yafang

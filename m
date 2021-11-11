Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A38344D5DF
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 12:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhKKLhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 06:37:53 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:54172 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbhKKLhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 06:37:52 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8CAEA21B35;
        Thu, 11 Nov 2021 11:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636630501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JF8tqJ/qYg7iprU4Smn80buBhFNtzpmt6OjhcdUzme4=;
        b=tQs9jwdvsxjCgUy1YjhWC29W8ruybAG4J6MEmsTVUl02QFHxRH/s1s/9OHEiuUPFVici7l
        a7IIKOvAHN0uhNPRfQ9w31C41z0iH87gt/kcggUdS4rbeZX90inzrYufC8X4JKmsrqAU/J
        8qSJkb29gfd827eZ2067ocolEPYIeIc=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D0F91A3B83;
        Thu, 11 Nov 2021 11:35:00 +0000 (UTC)
Date:   Thu, 11 Nov 2021 12:34:57 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 4/7] fs/binfmt_elf: use get_task_comm instead of
 open-coded string copy
Message-ID: <YYz/4bSdSXR3Palz@alley>
References: <20211108083840.4627-1-laoar.shao@gmail.com>
 <20211108083840.4627-5-laoar.shao@gmail.com>
 <a13c0541-59a3-6561-6d42-b51fef9f7c8b@redhat.com>
 <b495d38d-5cdd-8a33-b9d3-de721095ccab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b495d38d-5cdd-8a33-b9d3-de721095ccab@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 2021-11-11 11:06:04, David Hildenbrand wrote:
> On 11.11.21 11:03, David Hildenbrand wrote:
> > On 08.11.21 09:38, Yafang Shao wrote:
> >> It is better to use get_task_comm() instead of the open coded string
> >> copy as we do in other places.
> >>
> >> struct elf_prpsinfo is used to dump the task information in userspace
> >> coredump or kernel vmcore. Below is the verfication of vmcore,
> >>
> >> crash> ps
> >>    PID    PPID  CPU       TASK        ST  %MEM     VSZ    RSS  COMM
> >>       0      0   0  ffffffff9d21a940  RU   0.0       0      0  [swapper/0]
> >>>     0      0   1  ffffa09e40f85e80  RU   0.0       0      0  [swapper/1]
> >>>     0      0   2  ffffa09e40f81f80  RU   0.0       0      0  [swapper/2]
> >>>     0      0   3  ffffa09e40f83f00  RU   0.0       0      0  [swapper/3]
> >>>     0      0   4  ffffa09e40f80000  RU   0.0       0      0  [swapper/4]
> >>>     0      0   5  ffffa09e40f89f80  RU   0.0       0      0  [swapper/5]
> >>       0      0   6  ffffa09e40f8bf00  RU   0.0       0      0  [swapper/6]
> >>>     0      0   7  ffffa09e40f88000  RU   0.0       0      0  [swapper/7]
> >>>     0      0   8  ffffa09e40f8de80  RU   0.0       0      0  [swapper/8]
> >>>     0      0   9  ffffa09e40f95e80  RU   0.0       0      0  [swapper/9]
> >>>     0      0  10  ffffa09e40f91f80  RU   0.0       0      0  [swapper/10]
> >>>     0      0  11  ffffa09e40f93f00  RU   0.0       0      0  [swapper/11]
> >>>     0      0  12  ffffa09e40f90000  RU   0.0       0      0  [swapper/12]
> >>>     0      0  13  ffffa09e40f9bf00  RU   0.0       0      0  [swapper/13]
> >>>     0      0  14  ffffa09e40f98000  RU   0.0       0      0  [swapper/14]
> >>>     0      0  15  ffffa09e40f9de80  RU   0.0       0      0  [swapper/15]
> >>
> >> It works well as expected.
> >>
> >> Suggested-by: Kees Cook <keescook@chromium.org>
> >> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> >> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> >> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> >> Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> >> Cc: Peter Zijlstra <peterz@infradead.org>
> >> Cc: Steven Rostedt <rostedt@goodmis.org>
> >> Cc: Matthew Wilcox <willy@infradead.org>
> >> Cc: David Hildenbrand <david@redhat.com>
> >> Cc: Al Viro <viro@zeniv.linux.org.uk>
> >> Cc: Kees Cook <keescook@chromium.org>
> >> Cc: Petr Mladek <pmladek@suse.com>
> >> ---
> >>  fs/binfmt_elf.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> >> index a813b70f594e..138956fd4a88 100644
> >> --- a/fs/binfmt_elf.c
> >> +++ b/fs/binfmt_elf.c
> >> @@ -1572,7 +1572,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
> >>  	SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
> >>  	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
> >>  	rcu_read_unlock();
> >> -	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
> >> +	get_task_comm(psinfo->pr_fname, p);
> >>  
> >>  	return 0;
> >>  }
> >>
> > 
> > We have a hard-coded "pr_fname[16]" as well, not sure if we want to
> > adjust that to use TASK_COMM_LEN?
> 
> But if the intention is to chance TASK_COMM_LEN later, we might want to
> keep that unchanged.

It seems that len will not change in the end. Another solution is
going to be used for the long names, see
https://lore.kernel.org/r/20211108084142.4692-1-laoar.shao@gmail.com.

> (replacing the 16 by a define might still be a good idea, similar to how
> it's done for ELF_PRARGSZ, but just a thought)

If the code would need some tweaking when the size changes, you could
still use TASK_COMM_LEN and trigger a compilation error when the size
gets modified. For example, static_assert(TASK_COMM_LEN == 16);

It will make it clear that it needs attention if the size is ever modified.

Best Regards,
Petr

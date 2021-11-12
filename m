Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686D144DF86
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 02:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbhKLBIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 20:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbhKLBH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 20:07:59 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD68EC061766;
        Thu, 11 Nov 2021 17:05:08 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id f20so6734304qtb.4;
        Thu, 11 Nov 2021 17:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fXIzR4H7rC51zoCliJSnruG3gN++VRKIsy1ed6L1uZ0=;
        b=nahxv2cN/OPoduTjxYuNz1wjlJTPzrf+j7EJDi5o315fzmzSXE3lk519tlit7AgmLM
         5L+QlE/H1xO1r/kc91HECc3YRKpLyqx09c7oT9vn30n1jm02RW0i3xGEO5eWeGgHlfW9
         6VSQdjPR377+WUR0sMdg1l0I2yKNEPUpBdOBKXM5mRfUXpdGzfVLFuZ8Nv7DupTynkIe
         BF7YIEyZd9xN4RyU/T0a3pssM65Mm0RFjAE9wPHqBCGDh6n7uCw3hnU/o5XV5q3vJC1G
         vMmIqWVH0lig3JTV3iJQ1yYRpvRc5WjWSA+7kXGzvVrDnaxWW2oMoBUcVnDn4yJM/VhM
         xcNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fXIzR4H7rC51zoCliJSnruG3gN++VRKIsy1ed6L1uZ0=;
        b=6B8d6Ei8jxsqv10zFU9gU2qrAo3kkRdQvMW0bhmqMAQ3ahS6oICodG0FJPv1N0cGbs
         sVF9dysQxX6qnkmnGfZJD9Yhg1kOtCrdVyGH48XICrq6CMxQ7tvRXW/AOj/bUyFCnRBU
         RE0LCTm6h9h9Ey3q2+m7J2saxq1ByzkPXIjXH5c0ZslXaefLTeRhp94xhmrCMawy9yHm
         RIbPEeYDm5Y14+pHqmBRbTH52Aw7D3XeKteofNnqIwlblXVzNB2BT23C8qfIRK1lnuic
         oSxqzHN+6sq4/xNC2CkFHKP3CHt2R8vL0gdCaiSIpOCZ1t9lp5wRHLohDv8gYJM+9KMd
         hjRA==
X-Gm-Message-State: AOAM531IC256vqhIsoTOsN434vApuy6p7sSEbAcnbKQLZjZqZNDz69++
        mU8NL3rw4sGhdGJK1JcLMd+doIwAUb0b9J49V7M=
X-Google-Smtp-Source: ABdhPJyI15v6hfbPLVFglCWNTP1c+ur2pT58CD6zvbF3WVkubZRvuIGJW+6csH/fYOnC6Xy11GFkA/YMw9b/TRBReIw=
X-Received: by 2002:a05:622a:194:: with SMTP id s20mr12323495qtw.66.1636679107925;
 Thu, 11 Nov 2021 17:05:07 -0800 (PST)
MIME-Version: 1.0
References: <20211108083840.4627-1-laoar.shao@gmail.com> <20211108083840.4627-5-laoar.shao@gmail.com>
 <a13c0541-59a3-6561-6d42-b51fef9f7c8b@redhat.com> <b495d38d-5cdd-8a33-b9d3-de721095ccab@redhat.com>
 <YYz/4bSdSXR3Palz@alley>
In-Reply-To: <YYz/4bSdSXR3Palz@alley>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 12 Nov 2021 09:03:40 +0800
Message-ID: <CALOAHbBYguv8RbhBayGFHORKbW2TVHRyp_NtjYUmLTOwwJeR1A@mail.gmail.com>
Subject: Re: [PATCH 4/7] fs/binfmt_elf: use get_task_comm instead of
 open-coded string copy
To:     Petr Mladek <pmladek@suse.com>
Cc:     David Hildenbrand <david@redhat.com>,
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

On Thu, Nov 11, 2021 at 7:35 PM Petr Mladek <pmladek@suse.com> wrote:
>
> On Thu 2021-11-11 11:06:04, David Hildenbrand wrote:
> > On 11.11.21 11:03, David Hildenbrand wrote:
> > > On 08.11.21 09:38, Yafang Shao wrote:
> > >> It is better to use get_task_comm() instead of the open coded string
> > >> copy as we do in other places.
> > >>
> > >> struct elf_prpsinfo is used to dump the task information in userspace
> > >> coredump or kernel vmcore. Below is the verfication of vmcore,
> > >>
> > >> crash> ps
> > >>    PID    PPID  CPU       TASK        ST  %MEM     VSZ    RSS  COMM
> > >>       0      0   0  ffffffff9d21a940  RU   0.0       0      0  [swapper/0]
> > >>>     0      0   1  ffffa09e40f85e80  RU   0.0       0      0  [swapper/1]
> > >>>     0      0   2  ffffa09e40f81f80  RU   0.0       0      0  [swapper/2]
> > >>>     0      0   3  ffffa09e40f83f00  RU   0.0       0      0  [swapper/3]
> > >>>     0      0   4  ffffa09e40f80000  RU   0.0       0      0  [swapper/4]
> > >>>     0      0   5  ffffa09e40f89f80  RU   0.0       0      0  [swapper/5]
> > >>       0      0   6  ffffa09e40f8bf00  RU   0.0       0      0  [swapper/6]
> > >>>     0      0   7  ffffa09e40f88000  RU   0.0       0      0  [swapper/7]
> > >>>     0      0   8  ffffa09e40f8de80  RU   0.0       0      0  [swapper/8]
> > >>>     0      0   9  ffffa09e40f95e80  RU   0.0       0      0  [swapper/9]
> > >>>     0      0  10  ffffa09e40f91f80  RU   0.0       0      0  [swapper/10]
> > >>>     0      0  11  ffffa09e40f93f00  RU   0.0       0      0  [swapper/11]
> > >>>     0      0  12  ffffa09e40f90000  RU   0.0       0      0  [swapper/12]
> > >>>     0      0  13  ffffa09e40f9bf00  RU   0.0       0      0  [swapper/13]
> > >>>     0      0  14  ffffa09e40f98000  RU   0.0       0      0  [swapper/14]
> > >>>     0      0  15  ffffa09e40f9de80  RU   0.0       0      0  [swapper/15]
> > >>
> > >> It works well as expected.
> > >>
> > >> Suggested-by: Kees Cook <keescook@chromium.org>
> > >> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > >> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > >> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > >> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > >> Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> > >> Cc: Peter Zijlstra <peterz@infradead.org>
> > >> Cc: Steven Rostedt <rostedt@goodmis.org>
> > >> Cc: Matthew Wilcox <willy@infradead.org>
> > >> Cc: David Hildenbrand <david@redhat.com>
> > >> Cc: Al Viro <viro@zeniv.linux.org.uk>
> > >> Cc: Kees Cook <keescook@chromium.org>
> > >> Cc: Petr Mladek <pmladek@suse.com>
> > >> ---
> > >>  fs/binfmt_elf.c | 2 +-
> > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >>
> > >> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > >> index a813b70f594e..138956fd4a88 100644
> > >> --- a/fs/binfmt_elf.c
> > >> +++ b/fs/binfmt_elf.c
> > >> @@ -1572,7 +1572,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
> > >>    SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
> > >>    SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
> > >>    rcu_read_unlock();
> > >> -  strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
> > >> +  get_task_comm(psinfo->pr_fname, p);
> > >>
> > >>    return 0;
> > >>  }
> > >>
> > >
> > > We have a hard-coded "pr_fname[16]" as well, not sure if we want to
> > > adjust that to use TASK_COMM_LEN?
> >
> > But if the intention is to chance TASK_COMM_LEN later, we might want to
> > keep that unchanged.
>
> It seems that len will not change in the end. Another solution is
> going to be used for the long names, see
> https://lore.kernel.org/r/20211108084142.4692-1-laoar.shao@gmail.com.
>
> > (replacing the 16 by a define might still be a good idea, similar to how
> > it's done for ELF_PRARGSZ, but just a thought)
>
> If the code would need some tweaking when the size changes, you could
> still use TASK_COMM_LEN and trigger a compilation error when the size
> gets modified. For example, static_assert(TASK_COMM_LEN == 16);
>
> It will make it clear that it needs attention if the size is ever modified.
>

I think we can just add some comments to make it grepable, for example,

+  /* TASK_COMM_LEN */
    char pr_fname[16];

or a more detailed explanation:

+  /*
+   * The hard-coded 16 is derived from TASK_COMM_LEN, but it can be changed as
+   *  it is exposed to userspace. We'd better make it hard-coded here.
+   */
char pr_fname[16];

-- 
Thanks
Yafang

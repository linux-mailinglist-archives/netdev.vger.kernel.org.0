Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C48C21BED0
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgGJUzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgGJUzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 16:55:53 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1990C08C5DC;
        Fri, 10 Jul 2020 13:55:53 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id e11so6655850qkm.3;
        Fri, 10 Jul 2020 13:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=umxzZ9l+zQBonEiIpx0tLenM6i//HJK3uk8ryAmYO6Y=;
        b=IOKxiaGo3+r6vUQQY+pFq+PCP3gGqfYI8u28d8jT68pc7ASmi9ypo/72ZBbwbZEy7z
         j/cqyqzx2h3OpdDCnDhvNe1jmVeNN+atM/KLzvK+swqIOD0/HSQw2qE00khhWaCBX/JN
         OKQEMlACX2AcFIeIvbmgX42Y1OaiTy2RQvEGXM1WRkd6nJV3XAg+VTFPlSgKEKYzf/wD
         0carPgvw1UTFCG6vIJWrXabmSBomeu+F1jM1jDTnvEi7XW9tFZAvnktZ3bHsAFlgextV
         Li1E3HzNGLnDI78D5n3LgSHW/Z79RphQhm0hB9oIYbU7BIVdImsbae9Y93xXFUzR4yBw
         b7oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=umxzZ9l+zQBonEiIpx0tLenM6i//HJK3uk8ryAmYO6Y=;
        b=fGEr8+uLJb0QFBGcQfXZhXc/sMVEcgjhQq2eMwbc2alxi86pjt34uqg9tSIWCS47+N
         QOC062u2II1T58m7AC+pjLe42WmtSx038zDtmAgl1Sv0kE/PW+wb0RQ4+BX8bAuG1BqX
         lkbm/X910E7286pWTpoj/ztK9WieKPz9Fn9HizATgiTOG/KeFWwI4VR+7wUJA1wUKNR6
         pLe/qAJiyO3w25OyfMxt9+jMMO++g/NzCOSVWzp64wCrRGmyOAlsmBvA9m4jknV+zUQw
         jgMeWl5fMo56+/VlyPE4OO4AZa6xU0GfzMxeYRyAlkwsqdpgWPqkhRAiayGgxDK8SPA4
         Rzaw==
X-Gm-Message-State: AOAM532m0bNpOA3PaPQSRrcoLxVKuGGz6hsxruTOqJPMBonYB3PzqjJt
        2vMJmSdeLPM5b+mm0I8jkFihuVTl13omrJUPUzijfoJA
X-Google-Smtp-Source: ABdhPJzjNRIbTmxWF6b67i0FEABG0rtnFThtdCrOIHhzY52R63JviI5RQ7RYTS+b/7LuBpE6xn99Nux9ryyTRI57MWY=
X-Received: by 2002:a37:7683:: with SMTP id r125mr67674733qkc.39.1594414552906;
 Fri, 10 Jul 2020 13:55:52 -0700 (PDT)
MIME-Version: 1.0
References: <1594390953-31757-1-git-send-email-alan.maguire@oracle.com> <1594390953-31757-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1594390953-31757-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Jul 2020 13:55:41 -0700
Message-ID: <CAEf4BzbYk_kmqMEDS6BZR-jYbPNHpSCQFxaG5uSwzkKmMO8UbA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: use dedicated bpf_trace_printk event
 instead of trace_printk()
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 7:25 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> The bpf helper bpf_trace_printk() uses trace_printk() under the hood.
> This leads to an alarming warning message originating from trace
> buffer allocation which occurs the first time a program using
> bpf_trace_printk() is loaded.
>
> We can instead create a trace event for bpf_trace_printk() and enable
> it in-kernel when/if we encounter a program using the
> bpf_trace_printk() helper.  With this approach, trace_printk()
> is not used directly and no warning message appears.
>
> This work was started by Steven (see Link) and finished by Alan; added
> Steven's Signed-off-by with his permission.
>
> Link: https://lore.kernel.org/r/20200628194334.6238b933@oasis.local.home
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/trace/Makefile    |  2 ++
>  kernel/trace/bpf_trace.c | 41 ++++++++++++++++++++++++++++++++++++-----
>  kernel/trace/bpf_trace.h | 34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 72 insertions(+), 5 deletions(-)
>  create mode 100644 kernel/trace/bpf_trace.h
>

[...]

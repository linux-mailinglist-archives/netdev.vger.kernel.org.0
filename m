Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C7D463AAA
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242276AbhK3P51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237730AbhK3P5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:57:25 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B32FC061574;
        Tue, 30 Nov 2021 07:54:06 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id d2so27208110qki.12;
        Tue, 30 Nov 2021 07:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5jfG9Qw6wgd9sRjYfyHDytET8Ac/XcqwnteljgGuckk=;
        b=BntxTnwecg6BJSWIvVKExBquBtQ30s/lQ1YU/vtHIPa1Rx8ar/0r4fbnZzkVxmuMAb
         OzAbN7axchp00LTYFaxf1R9+06zsQfibPFDthdJkWHwessPgB59jSkf2hhJC9Jya5qyy
         HlASVFBQYACqEYVUo0srq3QkMFzJGpti1VVHtgcnXPBDChfHu3LanOSzPF2UPdSdM8Gk
         ouRdu2IXl6S/VnlWEksWw3jwf6CY3mhCilbCsObeM91dghSXL7b0a41ke+NdWEQkEgzh
         Won2HU6OUxb+j1fd9BYxScLJplAHx9QZ5JOlu9jWIR1hHSvIoz2zJCWmVGE6ELg+suCU
         X1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5jfG9Qw6wgd9sRjYfyHDytET8Ac/XcqwnteljgGuckk=;
        b=QYu8T1KZNItC3Ow00Hp4fcFAx9qIKgKa93R0Bdf7diNfT1y2kfSr7LZF8bTFEA9rzJ
         vQDUq+LeP5zkG0V1d+YUQFMnwqif4tsZg8GN4iLgL6CWODCtibYyc4Lcv/w6EyZB+IeJ
         1T+dI+X9sQ8vcwwlHGnSKrwIbQWs4nraED1OKHNCRTZzRrwKzfXxozYIINl4XjahE4PJ
         tPALFOyxes7JSa4jsvCLDh8u9S20GEQuH2nhQZsgvcnJH+q1JWFYrGWws/J/sUxDtgWn
         VZ5L7kAZNJjgsNbMrYJrKCVPLldMEDmX4pGt4HultIKI/VWBdqYQPDbrZM+E52wK1qtq
         p5sw==
X-Gm-Message-State: AOAM530gmFMeBNgWhlcwRZ9s7kMo0HSPkAh81OcsG7lC/JMw8kfwwWkS
        DH7lH3JN3ZWjtouwppGoSY22fH9pnZ02BFk/juY=
X-Google-Smtp-Source: ABdhPJyonKn3G8UIi6BT3phblLDnrVQm6qLkdWviQusM/bKsEz//a+DZxT6MhXu5EzeyFmfNCV15y1QUuJs0ifkzE2Y=
X-Received: by 2002:a05:620a:2e3:: with SMTP id a3mr7577qko.451.1638287645274;
 Tue, 30 Nov 2021 07:54:05 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-5-laoar.shao@gmail.com>
 <20211129110140.733475f3@gandalf.local.home> <CALOAHbB-2ESG0QgESN_b=bXzESbq+UBP-dqttirKnt1c9TZHZA@mail.gmail.com>
 <20211130092240.312f68a4@gandalf.local.home>
In-Reply-To: <20211130092240.312f68a4@gandalf.local.home>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 30 Nov 2021 23:53:30 +0800
Message-ID: <CALOAHbB6oTNpRUHvgMaH+kxJn7Fr7zE2bkvkniPFsPzH-SuHjA@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] fs/binfmt_elf: replace open-coded string copy with get_task_comm
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 10:22 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 30 Nov 2021 11:01:27 +0800
> Yafang Shao <laoar.shao@gmail.com> wrote:
>
> > There are three options,
> > - option 1
> >   comment on all the hard-coded 16 to explain why it is hard-coded
> > - option 2
> >   replace the hard-coded 16 that can be replaced and comment on the
> > others which can't be replaced.
> > - option 3
> >    replace the hard-coded 16 that can be replaced and specifically
> > define TASK_COMM_LEN_16 in other files which can't include
> > linux/sched.h.
> >
> > Which one do you prefer ?
> >
>
> Option 3. Since TASK_COMM_LEN_16 is, by it's name, already hard coded to
> 16, it doesn't really matter if you define it in more than one location.
>
> Or we could define it in another header that include/sched.h can include.
>
> The idea of having TASK_COMM_LEN_16 is to easily grep for it, and also know
> exactly what it is used for when people see it being used.
>

I will send a separate patch (or patchset) to replace all the old
hard-coded 16 with TASK_COMM_LEN_16 based on the -mm tree.

--
Thanks
Yafang

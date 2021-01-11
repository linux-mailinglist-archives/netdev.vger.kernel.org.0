Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B007D2F0FDB
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 11:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbhAKKPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 05:15:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbhAKKPg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 05:15:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E00CD22CAD
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610360095;
        bh=d3oM9Oo6bVko7We/EPWu4QxmYIbJ4zJH2EUzv0RJwUI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EIknoTTUOA5JOVqZp5FFk/YV11pg/k+grAQhZ9jHYbC7VQ38q+Y2mwEfXoSO+CDwr
         z4zF6OWN0h94MaPePDFjVC95uGuEcrvkM6BX/INH4LdeJNv7iR47la14Fwc7jhklAq
         ovujKqNyz8ZpnzBzYfqWvTMnk+AsZp7c7T49+vbN8R07R1VMRhvxThhYSAZIFuNPqy
         qUBqp91LUrw6YySXszXeWBupXhVW+9X0r3pIckKnHcZzYwmuJAeEhgeUo65nm2pVPz
         ltXHN345ZslUel2sb4CRG9xC26Y3C4JfVodZPtjfbetEmjtAlR/AbGSHSQhRCqqxn2
         gq16UzrTIVo2w==
Received: by mail-lj1-f170.google.com with SMTP id w26so2739885ljo.4
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 02:14:54 -0800 (PST)
X-Gm-Message-State: AOAM532VRrE3ZFSUaRk2jWGCs2Y0Azsjol5nnJi/FR+NqwIlpjAH591z
        q1fKs4aujpaHlwCM+ZXe/g+i70CIPC3j3xIt8VMvJQ==
X-Google-Smtp-Source: ABdhPJxrYgQcEgxWO0GY0HQ/eD89zuEf1GD1o7KXaFoAe6xlgUqy7scB0TPtomJZL4cRNzfuB49GOAnPxY86RG1sMTU=
X-Received: by 2002:a2e:5018:: with SMTP id e24mr7428302ljb.425.1610360093047;
 Mon, 11 Jan 2021 02:14:53 -0800 (PST)
MIME-Version: 1.0
References: <20210108231950.3844417-1-songliubraving@fb.com> <20210108231950.3844417-2-songliubraving@fb.com>
In-Reply-To: <20210108231950.3844417-2-songliubraving@fb.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 11 Jan 2021 11:14:42 +0100
X-Gmail-Original-Message-ID: <CACYkzJ6BT8F+75GW=7hLwjMwFccYBqPb3FXV5dVk0SkeNFpurg@mail.gmail.com>
Message-ID: <CACYkzJ6BT8F+75GW=7hLwjMwFccYBqPb3FXV5dVk0SkeNFpurg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing programs
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 9, 2021 at 12:35 AM Song Liu <songliubraving@fb.com> wrote:
>
> To access per-task data, BPF program typically creates a hash table with
> pid as the key. This is not ideal because:
>  1. The use need to estimate requires size of the hash table, with may be
>     inaccurate;
>  2. Big hash tables are slow;
>  3. To clean up the data properly during task terminations, the user need
>     to write code.
>
> Task local storage overcomes these issues and becomes a better option for
> these per-task data. Task local storage is only available to BPF_LSM. Now
> enable it for tracing programs.

Also mention here that you change the pointer from being a security blob to a
dedicated member in the task struct. I assume this is because you want to
use it without CONFIG_BPF_LSM?

>

Can you also mention the reasons for changing the
raw_spin_lock_bh to raw_spin_lock_irqsave in the commit log?


> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  include/linux/bpf.h            |  7 +++++++
>  include/linux/bpf_lsm.h        | 22 ----------------------
>  include/linux/bpf_types.h      |  2 +-
>  include/linux/sched.h          |  5 +++++
>  kernel/bpf/Makefile            |  3 +--
>  kernel/bpf/bpf_local_storage.c | 28 +++++++++++++++++-----------
>  kernel/bpf/bpf_lsm.c           |  4 ----
>  kernel/bpf/bpf_task_storage.c  | 26 ++++++--------------------
>  kernel/fork.c                  |  5 +++++
>  kernel/trace/bpf_trace.c       |  4 ++++
>  10 files changed, 46 insertions(+), 60 deletions(-)
>

[...]

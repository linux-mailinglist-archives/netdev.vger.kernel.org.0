Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E743C4620BA
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351709AbhK2Tpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240131AbhK2Tnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:43:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BB5C08EA72;
        Mon, 29 Nov 2021 08:01:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 029FB61536;
        Mon, 29 Nov 2021 16:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59321C53FAD;
        Mon, 29 Nov 2021 16:01:41 +0000 (UTC)
Date:   Mon, 29 Nov 2021 11:01:40 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
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
Subject: Re: [PATCH v2 4/7] fs/binfmt_elf: replace open-coded string copy
 with get_task_comm
Message-ID: <20211129110140.733475f3@gandalf.local.home>
In-Reply-To: <20211120112738.45980-5-laoar.shao@gmail.com>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
        <20211120112738.45980-5-laoar.shao@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Nov 2021 11:27:35 +0000
Yafang Shao <laoar.shao@gmail.com> wrote:

> diff --git a/include/linux/elfcore-compat.h b/include/linux/elfcore-compat.h
> index e272c3d452ce..54feb64e9b5d 100644
> --- a/include/linux/elfcore-compat.h
> +++ b/include/linux/elfcore-compat.h
> @@ -43,6 +43,11 @@ struct compat_elf_prpsinfo
>  	__compat_uid_t			pr_uid;
>  	__compat_gid_t			pr_gid;
>  	compat_pid_t			pr_pid, pr_ppid, pr_pgrp, pr_sid;
> +	/*
> +	 * The hard-coded 16 is derived from TASK_COMM_LEN, but it can't be
> +	 * changed as it is exposed to userspace. We'd better make it hard-coded
> +	 * here.

Didn't I once suggest having a macro called something like:

  TASK_COMM_LEN_16 ?


https://lore.kernel.org/all/20211014221409.5da58a42@oasis.local.home/

-- Steve


> +	 */
>  	char				pr_fname[16];
>  	char				pr_psargs[ELF_PRARGSZ];
>  };
> diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
> index 957ebec35aad..746e081879a5 100644
> --- a/include/linux/elfcore.h
> +++ b/include/linux/elfcore.h
> @@ -65,6 +65,11 @@ struct elf_prpsinfo
>  	__kernel_gid_t	pr_gid;
>  	pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
>  	/* Lots missing */
> +	/*
> +	 * The hard-coded 16 is derived from TASK_COMM_LEN, but it can't be
> +	 * changed as it is exposed to userspace. We'd better make it hard-coded
> +	 * here.
> +	 */
>  	char	pr_fname[16];	/* filename of executable */
>  	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
>  };

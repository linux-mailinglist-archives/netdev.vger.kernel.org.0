Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB2D2E6C8C
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgL1Xcs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Dec 2020 18:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgL1Xcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 18:32:48 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D2AC0613D6;
        Mon, 28 Dec 2020 15:32:07 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 2EAD54CE685A5;
        Mon, 28 Dec 2020 15:32:07 -0800 (PST)
Date:   Mon, 28 Dec 2020 15:32:01 -0800 (PST)
Message-Id: <20201228.153201.2263947627585407747.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     kuba@kernel.org, ast@kernel.org, bsd@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-12-28
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201228212830.32406-1-daniel@iogearbox.net>
References: <20201228212830.32406-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 28 Dec 2020 15:32:07 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Mon, 28 Dec 2020 22:28:30 +0100

> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> There is a small merge conflict between bpf tree commit 69ca310f3416
> ("bpf: Save correct stopping point in file seq iteration") and net tree
> commit 66ed594409a1 ("bpf/task_iter: In task_file_seq_get_next use
> task_lookup_next_fd_rcu"). The get_files_struct() does not exist anymore
> in net, so take the hunk in HEAD and add the `info->tid = curr_tid` to
> the error path:
> 
>   [...]
>                 curr_task = task_seq_get_next(ns, &curr_tid, true);
>                 if (!curr_task) {
>                         info->task = NULL;
>                         info->tid = curr_tid;
>                         return NULL;
>                 }
> 
>                 /* set info->task and info->tid */
>   [...]
> 
> We've added 10 non-merge commits during the last 9 day(s) which contain
> a total of 11 files changed, 75 insertions(+), 20 deletions(-).
> 
> The main changes are:
> 
> 1) Various AF_XDP fixes such as fill/completion ring leak on failed bind and
>    fixing a race in skb mode's backpressure mechanism, from Magnus Karlsson.
> 
> 2) Fix latency spikes on lockdep enabled kernels by adding a rescheduling
>    point to BPF hashtab initialization, from Eric Dumazet.
> 
> 3) Fix a splat in task iterator by saving the correct stopping point in the
>    seq file iteration, from Jonathan Lemon.
> 
> 4) Fix BPF maps selftest by adding retries in case hashtab returns EBUSY
>    errors on update/deletes, from Andrii Nakryiko.
> 
> 5) Fix BPF selftest error reporting to something more user friendly if the
>    vmlinux BTF cannot be found, from Kamal Mostafa.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
> 
> Thanks a lot!
> 
> Also thanks to reporters, reviewers and testers of commits in this pull-request:
> 
> Andrii Nakryiko, Björn Töpel, John Sperbeck, Song Liu, Xuan Zhuo
> 
> ----------------------------------------------------------------
> 
> The following changes since commit 3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9:
> 
>   Merge tag 'staging-5.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging (2020-12-15 14:18:40 -0800)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 
> 

Pulled, thanks.  Please double check my conflict resolution.


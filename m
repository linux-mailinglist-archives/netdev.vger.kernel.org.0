Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C693E0B6C
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731883AbfJVS3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:29:32 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37471 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfJVS3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:29:32 -0400
Received: by mail-lj1-f195.google.com with SMTP id l21so18272794lje.4;
        Tue, 22 Oct 2019 11:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uxMt9H3LtJ7pqzPSuyrIM24uiwA0nTK1MUHdhFbeMb8=;
        b=PiAnv00bcmsJPhL9rkYry1ebqzZoDitqWAbx65kYao8BKYY1ncoD4nLJ4o4QR4ORbU
         GQg+glL5E68Co1wl2U4gGELEcf/oModpXJjasQWm5jtjD7cx49FgEqV/Hea3nN8JGhio
         V5DLajQPcIoP7crrCNfDgqCQMDopE4UU7eQKMAACrr7bvwtarObyYFm8h+OosPiwQn2L
         7FM1eEofvJItp0GcZa6xDqDTP35h2N7nWGx+19UqjxzqsSbLtlgTidYcXN9Qvj5fA4io
         4y1o9HsGwCnWIWduXXwK076dZSCRNQGxDEQUN3wlOtWE1kDEFlWPXaph+egJr8tQomoH
         IaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uxMt9H3LtJ7pqzPSuyrIM24uiwA0nTK1MUHdhFbeMb8=;
        b=GdRcZr8GWpXuLvOgzGW3TJpZgoGyTzh8n9+GIX1Wax1cCDgCcZq6eqY6VWUw04A5x/
         tl59YQKaX41tdMsBtfEy7RbIKvEDQBNkEZ0BB1hKNUvG2E8QrMcGvNYrsWN3b0yUilmU
         gS+3yNYA029ZNIvpITSxgF/dF25et/AU+E2fJEjfa7m4Z5vD8HCWmNdhjChVPALwsipb
         g1gunzonvg89GoP9fyDpk7Qh/onJBL7un03BWWY6e1Ht7A4LYubK5+w4oC4w7FWXIe1v
         czYA2rYa+WTdhA6mMHpk87E+uENEuGtAGDXB24vSyd/2D3vEnmwx8hpaVPSXubc8hs/z
         iwNA==
X-Gm-Message-State: APjAAAVRPZOkmv0PYn7YwRWYMHOrG3zWwYqb/gCnqWdZRmTPx//Mqmvh
        wNWw8MO+8oYm3kmbdhZrjKBMF8FULpbBxthjEESsEQ==
X-Google-Smtp-Source: APXvYqxznjs4ukuAeKRHApg+x3X8+OGoWHGAtuPwqYX7BKTMv33fLwj5/VSFNB0WtYVxST94TzGzbLHHcp1sLFgNB00=
X-Received: by 2002:a2e:9b12:: with SMTP id u18mr20149416lji.142.1571768969771;
 Tue, 22 Oct 2019 11:29:29 -0700 (PDT)
MIME-Version: 1.0
References: <55f6367324c2d7e9583fa9ccf5385dcbba0d7a6e.1571752452.git.daniel@iogearbox.net>
In-Reply-To: <55f6367324c2d7e9583fa9ccf5385dcbba0d7a6e.1571752452.git.daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 22 Oct 2019 11:29:18 -0700
Message-ID: <CAADnVQLgMRfN0iawBbeoA5mFenzDiTecuCnVPtQ7oXbhKkt4qA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Fix use after free in subprog's jited symbol removal
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        syzbot+710043c5d1d5b5013bc7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 6:57 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> syzkaller managed to trigger the following crash:
>
>   [...]
>   BUG: unable to handle page fault for address: ffffc90001923030
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD aa551067 P4D aa551067 PUD aa552067 PMD a572b067 PTE 80000000a1173163
>   Oops: 0000 [#1] PREEMPT SMP KASAN
>   CPU: 0 PID: 7982 Comm: syz-executor912 Not tainted 5.4.0-rc3+ #0
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   RIP: 0010:bpf_jit_binary_hdr include/linux/filter.h:787 [inline]
>   RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:531 [inline]
>   RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
>   RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
>   RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
>   RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
>   RIP: 0010:is_bpf_text_address+0x184/0x3b0 kernel/bpf/core.c:709
> After further debugging it turns out that we walk kallsyms while in parallel
> we tear down a BPF program which contains subprograms that have been JITed
> though the program itself has not been fully exposed and is eventually bailing
> out with error.
>
> The bpf_prog_kallsyms_del_subprogs() in bpf_prog_load()'s error path removes
> the symbols, however, bpf_prog_free() tears down the JIT memory too early via
> scheduled work. Instead, it needs to properly respect RCU grace period as the
> kallsyms walk for BPF is under RCU.
>
> Fix it by refactoring __bpf_prog_put()'s tear down and reuse it in our error
> path where we defer final destruction when we have subprogs in the program.
>
> Fixes: 7d1982b4e335 ("bpf: fix panic in prog load calls cleanup")
> Fixes: 1c2a088a6626 ("bpf: x64: add JIT support for multi-function programs")
> Reported-and-tested-by: syzbot+710043c5d1d5b5013bc7@syzkaller.appspotmail.com
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Applied. Thanks!

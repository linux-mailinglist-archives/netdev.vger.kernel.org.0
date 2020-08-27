Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4CD25510B
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 00:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgH0W2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 18:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgH0W2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 18:28:34 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17905C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 15:28:34 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id c18so2253458wrm.9
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 15:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4hHcLoIlXcDvwVbwc1z/8wUhjLFiMa1va1nRfXBv6ko=;
        b=odgjvpfK2R3BY3lM7XCndIw+ml5WjTJc9kvGxDh/F52xEguQWgOkNdzeZx4RgY3DLp
         I30EEGRYc5x/frQO/QKnDRZb8orEPpKyCu5ywjtRoD12LhafwkhohV7vp2bVdFf0js2L
         77dHz2f2juIwYARPuaZyavm7h2x+98cw8kRkg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4hHcLoIlXcDvwVbwc1z/8wUhjLFiMa1va1nRfXBv6ko=;
        b=Sy6rssIsYwCkzwPGwhqzrz608b4ngLX0H3EQad6yWZ7XvzIpHi83q0Ab8BJRaczWQ+
         EIE8cagFAIdFyv82JePY7pHnAMHQhzb5+XUL+nWhdu2urh+cNl1iQzInasVeOmvuuZ1l
         a65PCmpXHgJktxAz7vpBboy5yvr0T0Z8E+Zot6v65KG6amdakGct+4nYqlXTrzMA0jsR
         OpYgKKBMAJcyVztYSwADvKnuiauBrcfxypubHsuRujyirh+Ja0Q1UHV1I0cdgE0Yz16A
         LhT30UqRm6n4CfzeAOGJv/YvHTCp3sxS8H0QFgfuhMkZ/a4vVeQZvweDjkKV+UENdEIi
         3/3A==
X-Gm-Message-State: AOAM531hjzoTPkMsjWoJXRneyll02dGPZOVVbhTIJmAlTkPxlvzY5qeb
        YaoFbnmL9ufr1mSpNYTUBicSdJFT/Y6haUHgQbveQg==
X-Google-Smtp-Source: ABdhPJyg067kOlD5lyl6KWo5e2BMZfMdnnVAB1Dt+z85r0wqhWeKFGWvw23GzIHHqcQXtKKhsk6aGgUGjR6e4lHrFlI=
X-Received: by 2002:a5d:558a:: with SMTP id i10mr20734963wrv.146.1598567311712;
 Thu, 27 Aug 2020 15:28:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com> <20200827220114.69225-3-alexei.starovoitov@gmail.com>
In-Reply-To: <20200827220114.69225-3-alexei.starovoitov@gmail.com>
From:   KP Singh <kpsingh@chromium.org>
Date:   Fri, 28 Aug 2020 00:28:21 +0200
Message-ID: <CACYkzJ6zooHd09bsCjb6SXrjXsWmo6yaFZL3ULW56rTxC8mc0g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/5] bpf: Introduce sleepable BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, josef@toxicpanda.com,
        bpoirier@suse.com, Andrew Morton <akpm@linux-foundation.org>,
        hannes@cmpxchg.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 28, 2020 at 12:01 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Introduce sleepable BPF programs that can request such property for themselves
> via BPF_F_SLEEPABLE flag at program load time. In such case they will be able
> to use helpers like bpf_copy_from_user() that might sleep. At present only
> fentry/fexit/fmod_ret and lsm programs can request to be sleepable and only
> when they are attached to kernel functions that are known to allow sleeping.
>
> The non-sleepable programs are relying on implicit rcu_read_lock() and
> migrate_disable() to protect life time of programs, maps that they use and
> per-cpu kernel structures used to pass info between bpf programs and the
> kernel. The sleepable programs cannot be enclosed into rcu_read_lock().
> migrate_disable() maps to preempt_disable() in non-RT kernels, so the progs
> should not be enclosed in migrate_disable() as well. Therefore
> rcu_read_lock_trace is used to protect the life time of sleepable progs.
>
> There are many networking and tracing program types. In many cases the
> 'struct bpf_prog *' pointer itself is rcu protected within some other kernel
> data structure and the kernel code is using rcu_dereference() to load that
> program pointer and call BPF_PROG_RUN() on it. All these cases are not touched.
> Instead sleepable bpf programs are allowed with bpf trampoline only. The
> program pointers are hard-coded into generated assembly of bpf trampoline and
> synchronize_rcu_tasks_trace() is used to protect the life time of the program.
> The same trampoline can hold both sleepable and non-sleepable progs.
>
> When rcu_read_lock_trace is held it means that some sleepable bpf program is
> running from bpf trampoline. Those programs can use bpf arrays and preallocated
> hash/lru maps. These map types are waiting on programs to complete via
> synchronize_rcu_tasks_trace();
>
> Updates to trampoline now has to do synchronize_rcu_tasks_trace() and
> synchronize_rcu_tasks() to wait for sleepable progs to finish and for
> trampoline assembly to finish.
>
> This is the first step of introducing sleepable progs. Eventually dynamically
> allocated hash maps can be allowed and networking program types can become
> sleepable too.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: KP Singh <kpsingh@google.com>

Thanks for kicking off the allow list.

I will continue my analysis looking at which hooks are sleepable
and we can, eventually, generalize the information into lsm_hook_defs.h

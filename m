Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839EB1E6E6C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436903AbgE1WMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436899AbgE1WMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:12:32 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAF5C08C5C7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:12:31 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l26so843408wme.3
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/wx6Jr8JL0gjucup2F5R2t29CbUsCxkdTrMH+In/lVg=;
        b=i2OaulLoxqzSBTeQrs7Ir5LgR9BZnR32sFnZcpEd6RGRuev/1eS1R6SICn8Cn49r0E
         Jer6QKI/BWhMjykAx1eiVFZpO0NasdAKJC62n1DneXyFOe4hj/OdYKVOGJvaCTuqwo9t
         rFini5WQwdNK43iai6s3Rneyz3mfuadirssoA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/wx6Jr8JL0gjucup2F5R2t29CbUsCxkdTrMH+In/lVg=;
        b=fTdeVFzxNEozFITcgr7qM3vcP3fC0dGkW6Z4PmEavX2s/IgSA7LPAtZKo3oO6uy0dI
         CmqmsLGCTi+dYayKB5TqTLUw7aGCR4SmrTzpKyMrDtME2y7tqblIzH279ipvR68ehvC8
         20iMops0YsI6q5pcLtIyWu8dWciYFpy6J+X0wPhSxVqdKhkJsHUTCwv8eL8L0KulvfQV
         6uTBDwy2/MKFRZOOnYKohPVibe/B/jmRjg2TmZvo9QW7oAhGvfqGsv0mkIyozexIutLP
         fb6nbZJOBy9jcWX71zITanHmzxvxSTtFM8E4UlCZ/XsgnUcJIxtScv/7nFNxETRzWLYy
         A3eA==
X-Gm-Message-State: AOAM533w1vF9JDWlprYa8iU4MxLj3VYCh9olfa7vpNHW4QQERzofiOmQ
        wUYTuB6wL15I8QkefhUtwMMw6g==
X-Google-Smtp-Source: ABdhPJy95sMf662ilUIoea35z9/O+cvgqCY8Ikc/+BSqd8vuRPM/J7etm/QEyrbvMzCunfPIStqWiw==
X-Received: by 2002:a1c:65c2:: with SMTP id z185mr5139937wmb.125.1590703949695;
        Thu, 28 May 2020 15:12:29 -0700 (PDT)
Received: from google.com ([81.6.44.51])
        by smtp.gmail.com with ESMTPSA id q13sm7342354wrn.84.2020.05.28.15.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 15:12:29 -0700 (PDT)
From:   KP Singh <kpsingh@chromium.org>
X-Google-Original-From: KP Singh <kpsingh>
Date:   Fri, 29 May 2020 00:12:27 +0200
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/3] bpf: Introduce sleepable BPF programs
Message-ID: <20200528221227.GA217782@google.com>
References: <20200528053334.89293-1-alexei.starovoitov@gmail.com>
 <20200528053334.89293-2-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528053334.89293-2-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27-May 22:33, Alexei Starovoitov wrote:
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
> should not be enclosed in migrate_disable() as well. Therefore bpf_srcu is used
> to protect the life time of sleepable progs.
> 
> There are many networking and tracing program types. In many cases the
> 'struct bpf_prog *' pointer itself is rcu protected within some other kernel
> data structure and the kernel code is using rcu_dereference() to load that
> program pointer and call BPF_PROG_RUN() on it. All these cases are not touched.
> Instead sleepable bpf programs are allowed with bpf trampoline only. The
> program pointers are hard-coded into generated assembly of bpf trampoline and
> synchronize_srcu(&bpf_srcu) is used to protect the life time of the program.
> The same trampoline can hold both sleepable and non-sleepable progs.
> 
> When bpf_srcu lock is held it means that some sleepable bpf program is running
> from bpf trampoline. Those programs can use bpf arrays and preallocated hash/lru
> maps. These map types are waiting on programs to complete via
> synchronize_srcu(&bpf_srcu);
> 
> Updates to trampoline now has to do synchronize_srcu + synchronize_rcu_tasks
> to wait for sleepable progs to finish and for trampoline assembly to finish.
> 
> In the future srcu will be replaced with upcoming rcu_trace.
> That will complete the first step of introducing sleepable progs.
> 
> After that dynamically allocated hash maps can be allowed. All map elements
> would have to be srcu protected instead of normal rcu.
> per-cpu maps will be allowed. Either via the following pattern:
> void *elem = bpf_map_lookup_elem(map, key);
> if (elem) {
>    // access elem
>    bpf_map_release_elem(map, elem);
> }
> where modified lookup() helper will do migrate_disable() and
> new bpf_map_release_elem() will do corresponding migrate_enable().
> Or explicit bpf_migrate_disable/enable() helpers will be introduced.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Thanks! This will be really helpful for LSM programs.

Acked-by: KP Singh <kpsingh@google.com>

> ---
>  arch/x86/net/bpf_jit_comp.c    | 36 +++++++++++++++-------
>  include/linux/bpf.h            |  4 +++
>  include/uapi/linux/bpf.h       |  8 +++++
>  kernel/bpf/arraymap.c          |  5 +++
>  kernel/bpf/hashtab.c           | 19 ++++++++----
>  kernel/bpf/syscall.c           | 12 ++++++--
>  kernel/bpf/trampoline.c        | 33 +++++++++++++++++++-
>  kernel/bpf/verifier.c          | 56 ++++++++++++++++++++++++++--------
>  tools/include/uapi/linux/bpf.h |  8 +++++
>  9 files changed, 147 insertions(+), 34 deletions(-)

[...]

> +			if (ret)
> +				verbose(env, "%s() is not modifiable\n",
> +					prog->aux->attach_func_name);
> +		} else if (prog->aux->sleepable && prog->type == BPF_PROG_TYPE_TRACING) {
> +			/* fentry/fexit progs can be sleepable only if they are
> +			 * attached to ALLOW_ERROR_INJECTION or security_*() funcs.
> +			 * LSM progs check that they are attached to bpf_lsm_*() funcs
> +			 * which are sleepable too.

I know of one LSM hook which is not sleepable and is executed in an
RCU callback i.e. task_free. I don't think t's a problem to run under
SRCU for that (I tried it and it does not cause any issues).

We can add a blacklisting mechanism later for the sleepable flags or
just the sleeping helpers (based on some of the work going on to
whitelist functions for helper usage).

- KP

> +			 */
> +			ret = check_attach_modify_return(prog, addr);
> +			if (ret)
> +				verbose(env, "%s is not sleepable\n",

[...]

>   * two extensions:
>   *
> -- 
> 2.23.0
> 

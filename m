Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2257BAE143
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 00:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbfIIWwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 18:52:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728989AbfIIWwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 18:52:42 -0400
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F74C222C1
        for <netdev@vger.kernel.org>; Mon,  9 Sep 2019 22:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568069560;
        bh=KQdOtep/fJtO4YL+FRc2frDHqd9PIOzbuU5ucWQl2UQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aW6ay5Q8op/HZa/5vNXr2/suTkKSE3Q58tm2lo/KOu+l5ryRSyMxiQStM2Ne3W26V
         Uw9XMcbsamtNuNlcG82q5AepsZc2U2Hq5OzHnsjnShO16kNRGn/eOUha36EfFl9ygd
         9Ezdyqj9UOqOOtfYWF6Gmq7+Vh3Y14mgYSWqy6b4=
Received: by mail-wr1-f44.google.com with SMTP id k6so4148884wrn.11
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 15:52:40 -0700 (PDT)
X-Gm-Message-State: APjAAAXIC7n7iqpiN71+OUX156DJASlYGr1BwqS8b/2R72EcLvxPziCH
        3gNEZr+AmJHoYEcHVzXPsXl2KgJtoM7M3XMqPcRC1A==
X-Google-Smtp-Source: APXvYqxjXu9tLKEeidry8TRnmvMaltITLyIhvUtZf50njewqCflxdMPyZxPcqVEhtg99777/tMeAYnKT6NblO0sboVA=
X-Received: by 2002:adf:fe0f:: with SMTP id n15mr886881wrr.343.1568069558803;
 Mon, 09 Sep 2019 15:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190906231053.1276792-1-ast@kernel.org> <20190906231053.1276792-2-ast@kernel.org>
In-Reply-To: <20190906231053.1276792-2-ast@kernel.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 9 Sep 2019 15:52:27 -0700
X-Gmail-Original-Message-ID: <CALCETrVCimrLCzdZ2Jgb-AFd-Ptjd+MmyD-XW=baSt6uOOTtEg@mail.gmail.com>
Message-ID: <CALCETrVCimrLCzdZ2Jgb-AFd-Ptjd+MmyD-XW=baSt6uOOTtEg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/4] capability: introduce CAP_BPF and CAP_TRACING
To:     Alexei Starovoitov <ast@kernel.org>,
        James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 4:10 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Split BPF and perf/tracing operations that are allowed under
> CAP_SYS_ADMIN into corresponding CAP_BPF and CAP_TRACING.
> For backward compatibility include them in CAP_SYS_ADMIN as well.
>
> The end result provides simple safety model for applications that use BPF:
> - for tracing program types
>   BPF_PROG_TYPE_{KPROBE, TRACEPOINT, PERF_EVENT, RAW_TRACEPOINT, etc}
>   use CAP_BPF and CAP_TRACING
> - for networking program types
>   BPF_PROG_TYPE_{SCHED_CLS, XDP, CGROUP_SKB, SK_SKB, etc}
>   use CAP_BPF and CAP_NET_ADMIN
>
> There are few exceptions from this simple rule:
> - bpf_trace_printk() is allowed in networking programs, but it's using
>   ftrace mechanism, hence this helper needs additional CAP_TRACING.
> - cpumap is used by XDP programs. Currently it's kept under CAP_SYS_ADMIN,
>   but could be relaxed to CAP_NET_ADMIN in the future.
> - BPF_F_ZERO_SEED flag for hash/lru map is allowed under CAP_SYS_ADMIN only
>   to discourage production use.
> - BPF HW offload is allowed under CAP_SYS_ADMIN.
> - cg_sysctl, cg_device, lirc program types are neither networking nor tracing.
>   They can be loaded under CAP_BPF, but attach is allowed under CAP_NET_ADMIN.
>   This will be cleaned up in the future.
>
> userid=nobody + (CAP_TRACING | CAP_NET_ADMIN) + CAP_BPF is safer than
> typical setup with userid=root and sudo by existing bpf applications.
> It's not secure, since these capabilities:
> - allow bpf progs access arbitrary memory
> - let tasks access any bpf map
> - let tasks attach/detach any bpf prog
>
> bpftool, bpftrace, bcc tools binaries should not be installed with
> cap_bpf+cap_tracing, since unpriv users will be able to read kernel secrets.
>
> CAP_BPF, CAP_NET_ADMIN, CAP_TRACING are roughly equal in terms of
> damage they can make to the system.
> Example:
> CAP_NET_ADMIN can stop network traffic. CAP_BPF can write into map
> and if that map is used by firewall-like bpf prog the network traffic
> may stop.
> CAP_BPF allows many bpf prog_load commands in parallel. The verifier
> may consume large amount of memory and significantly slow down the system.
> CAP_TRACING allows many kprobes that can slow down the system.

Do we want to split CAP_TRACE_KERNEL and CAP_TRACE_USER?  It's not
entirely clear to me that it's useful.

>
> In the future more fine-grained bpf permissions may be added.
>
> Existing unprivileged BPF operations are not affected.
> In particular unprivileged users are allowed to load socket_filter and cg_skb
> program types and to create array, hash, prog_array, map-in-map map types.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/capability.h          | 18 +++++++++++
>  include/uapi/linux/capability.h     | 49 ++++++++++++++++++++++++++++-
>  security/selinux/include/classmap.h |  4 +--
>  3 files changed, 68 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index ecce0f43c73a..13eb49c75797 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -247,6 +247,24 @@ static inline bool ns_capable_setid(struct user_namespace *ns, int cap)
>         return true;
>  }
>  #endif /* CONFIG_MULTIUSER */
> +
> +static inline bool capable_bpf(void)
> +{
> +       return capable(CAP_SYS_ADMIN) || capable(CAP_BPF);
> +}
> +static inline bool capable_tracing(void)
> +{
> +       return capable(CAP_SYS_ADMIN) || capable(CAP_TRACING);
> +}
> +static inline bool capable_bpf_tracing(void)
> +{
> +       return capable(CAP_SYS_ADMIN) || (capable(CAP_BPF) && capable(CAP_TRACING));
> +}
> +static inline bool capable_bpf_net_admin(void)
> +{
> +       return (capable(CAP_SYS_ADMIN) || capable(CAP_BPF)) && capable(CAP_NET_ADMIN);
> +}
> +

These helpers are all wrong, unfortunately, since they will produce
inappropriate audit events.  capable_bpf() should look more like this:

if (capable_noaudit(CAP_BPF))
  return capable(CAP_BPF);
if (capable_noaudit(CAP_SYS_ADMIN))
  return capable(CAP_SYS_ADMIN);

return capable(CAP_BPF);

James, etc: should there instead be new helpers to do this more
generically rather than going through the noaudit contortions?  My
code above is horrible.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A03C485FE0
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 05:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbiAFEbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 23:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiAFEbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 23:31:04 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952D4C061212;
        Wed,  5 Jan 2022 20:31:04 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id q5so1673396ioj.7;
        Wed, 05 Jan 2022 20:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HZTxQYalIRmgO/xfk9dIV8yzOAYZyGHheqX/9sT3on8=;
        b=CIo9La2GJvCAn5U5AAXD5QEUFfc9fMYLBvzdt+6HG+opbpIJYuutbvVlamNio0z6ZU
         kNU3nOU3okuzw/btfkSe9Yx8wEXkzun2susJFTnXXzJY00HZw+m3sWUAufhn+gvZrzDF
         uLz/Pcsu5Yt2d+zXLkZCF7+yNPv/VasN3BNnhtbIuw01PD7c5Z2c5TTnFwKTTOD6fSb9
         uYeiEgiHkaz04X4IiZX4uj14AvmYlZUC9W5i9d2A/tnrHHowVjm2c0z64cTfbooNLkOS
         CP5A16NHtcvyQ2z7UFhLhczwmE4NoHEtxVNvxp2LnQhfrefP4rqRHQWAWnPKWtlpS1dv
         DiKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HZTxQYalIRmgO/xfk9dIV8yzOAYZyGHheqX/9sT3on8=;
        b=yCw8GBHvTTtfBGwqx/8sEH9BVyZ5Fas10qikU3MnyNoMY1/uPmZ8NILKArg+dhMC50
         7ENqMnl8m+JH5a2ddWwu18V7Wnt/icaADyr04M/syQ9jcn2n1c3TZbcEXwJEY0hb9wHj
         HidSRaI0uHcRKXHV6fs63ZwxIcEJrlmEOVl/GOuhWWWQSNX+Jfh8JhoL6RPNsWbC+SCA
         kDCZa96Yjd4o3SjxPfGsayu04X3zFQMEVJ6pXDEKPS79ho8+fGFr42VsUJytsfPPCuM8
         ku71ZdVR6P/u/SQHiv21IG8JIDztDDGiJaSJe5tfFjidBFQrIiS4z/Ok6Vvw4LxnqM9E
         ul9A==
X-Gm-Message-State: AOAM5308GQHxcsO4tVIfIyz59WXqd48Wi6UtwGu8fyjlmHLvIwQpCkL3
        VgAUHb4qKV0h1INERhwPObrb/3N8Fdl7cn4iVHA=
X-Google-Smtp-Source: ABdhPJzsDsZ9VPsO5hkxmjgaBDwtSJyZAZjQ2vJF6ptLmjNP2Ze4kxWV1dhL8oGXb3xqXrZ090pJhDpBO7h/ELLIDYo=
X-Received: by 2002:a5d:9f01:: with SMTP id q1mr27186140iot.144.1641443464002;
 Wed, 05 Jan 2022 20:31:04 -0800 (PST)
MIME-Version: 1.0
References: <20220104080943.113249-1-jolsa@kernel.org> <20220104080943.113249-6-jolsa@kernel.org>
In-Reply-To: <20220104080943.113249-6-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Jan 2022 20:30:52 -0800
Message-ID: <CAEf4BzbvG00H5nbKGRLW+v0fC66DaZjHGD_AC7gwBRtbRoLmFA@mail.gmail.com>
Subject: Re: [PATCH 05/13] kprobe: Allow to get traced function address for
 multi ftrace kprobes
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 12:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> The current bpf_get_func_ip_kprobe helper does not work properly,
> when used in ebpf program triggered by the new multi kprobes.
>
> We can't use kprobe's func_addr in bpf_get_func_ip_kprobe helper,
> because there are multiple functions registered for single kprobe
> object.
>
> Adding new per cpu variable current_ftrace_multi_addr and extra
> address in kretprobe_instance object to keep current traced function
> address for each cpu for both kprobe handler and kretprobe trampoline.
>
> The address value is set/passed as follows, for kprobe:
>
>   kprobe_ftrace_multi_handler
>   {
>     old = kprobe_ftrace_multi_addr_set(ip);
>     handler..
>     kprobe_ftrace_multi_addr_set(old);
>   }
>
> For kretprobe:
>
>   kprobe_ftrace_multi_handler
>   {
>     old = kprobe_ftrace_multi_addr_set(ip);
>     ...
>       pre_handler_kretprobe
>       {
>         ri->ftrace_multi_addr = kprobe_ftrace_multi_addr
>       }
>     ...
>     kprobe_ftrace_multi_addr_set(old);
>   }
>
>   __kretprobe_trampoline_handler
>   {
>     prev_func_addr = kprobe_ftrace_multi_addr_set(ri->ftrace_multi_addr);
>     handler..
>     kprobe_ftrace_multi_addr_set(prev_func_addr);
>   }
>

Is it possible to record or calculate the multi-kprobe "instance
index" (i.e., which position in addrs array did we get triggered for)?
If yes, then storing that index would allow to fetch both IP and
cookie value with just one per-cpu variable.


> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  arch/x86/kernel/kprobes/ftrace.c |  3 +++
>  include/linux/kprobes.h          | 26 ++++++++++++++++++++++++++
>  kernel/kprobes.c                 |  6 ++++++
>  kernel/trace/bpf_trace.c         |  7 ++++++-
>  4 files changed, 41 insertions(+), 1 deletion(-)
>

[...]

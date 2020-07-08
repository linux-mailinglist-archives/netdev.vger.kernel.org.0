Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBCC217F4A
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 07:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgGHF4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 01:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729670AbgGHF43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 01:56:29 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017ADC061755;
        Tue,  7 Jul 2020 22:56:29 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g13so33623158qtv.8;
        Tue, 07 Jul 2020 22:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ede8UCLHh6UsB8NU2wRY++2AzYreMnz6NE+PpTkdL98=;
        b=hmOhTu0bZ1qSrrBabkvGxLEkZ6Tmxj4uI8hMEYNDcbakRAgvMsuDZnazGEZynvTCiJ
         bfi/OBeeX2McKvP0C4RiyguymOlK+lW3uQUOK+si6eZgNCNaicQRly1rO1fjktjBRrKQ
         9p4xz6HPzxMweLxx8DltGiyb0ThA0y4bYzk7fk849e8c07DKAVCx+NHYodc5mUo4EOQo
         wNfuwA4mW0ASVjcme8pfyC5TJI+QKg0JVwHk0WzyWule9ThvFHA+F+aacLeL3MdCY9Oc
         UDuTyDxXTvAYtrMN0DDUggvpIZhmp6umf4aY9JajNrz0gcch1Ubnf/1+ussfKEPvzn25
         ya/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ede8UCLHh6UsB8NU2wRY++2AzYreMnz6NE+PpTkdL98=;
        b=Bdi7yg0tcGAexA2QlHDYMCk77DWNrTnwQrawBCfxBDAJYWA6fsEB9+1AWW3YLeV74e
         k0DbjMgH8cumyRWPIbNOzJqUpkMOospeA4Je9SBL3lQArfFtnOgMAaDJKS6P6CG7LqG/
         vi69J/H0HUx0eeUNldYokc/b2xyzXWmktTeobyaElLHtLOruRSHnf50AnWskGx/tvBYE
         4KIp5cM4dESrRHI58/IPwWuRcaN6kErr82rQIHSC7Pjr1oI/CERwWWLk0QA2Suqx89Xj
         KCKa0OMxBDSjTsehUUNC0bCx7ajDStyKsxClLzIlzPYp9M6+l70sO/zHLA/E4MpK630W
         l3Ug==
X-Gm-Message-State: AOAM530uN1j6XF0JIsOhnEct8CLUKZsDPlZEvA4h6wg+YWuTxAdjDl1u
        uigieGtpyVKdOtdUC7LDvWyyEQVbFY57g1ZU3Ww=
X-Google-Smtp-Source: ABdhPJzyBiKleEu5SueSzbeJcoPFdUlCA5bsg0IlxIguusVGJrcnFS9fyhDINLrfrwxoiI5whB4X1OCdXROVWfJBtUc=
X-Received: by 2002:ac8:19c4:: with SMTP id s4mr54112512qtk.117.1594187788189;
 Tue, 07 Jul 2020 22:56:28 -0700 (PDT)
MIME-Version: 1.0
References: <1593787468-29931-1-git-send-email-alan.maguire@oracle.com> <1593787468-29931-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1593787468-29931-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Jul 2020 22:56:17 -0700
Message-ID: <CAEf4BzaGWZGYQf6C0GT3mwhjh8PSVLwgoFiHtpx6zaTny3B_gw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: use dedicated bpf_trace_printk event
 instead of trace_printk()
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 7:47 AM Alan Maguire <alan.maguire@oracle.com> wrote:
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
>  kernel/trace/Makefile    |  2 ++
>  kernel/trace/bpf_trace.c | 41 +++++++++++++++++++++++++++++++++++++----
>  kernel/trace/bpf_trace.h | 34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 73 insertions(+), 4 deletions(-)
>  create mode 100644 kernel/trace/bpf_trace.h
>

[...]

> +static DEFINE_SPINLOCK(trace_printk_lock);
> +
> +#define BPF_TRACE_PRINTK_SIZE   1024
> +
> +static inline int bpf_do_trace_printk(const char *fmt, ...)
> +{
> +       static char buf[BPF_TRACE_PRINTK_SIZE];
> +       unsigned long flags;
> +       va_list ap;
> +       int ret;
> +
> +       spin_lock_irqsave(&trace_printk_lock, flags);
> +       va_start(ap, fmt);
> +       ret = vsnprintf(buf, BPF_TRACE_PRINTK_SIZE, fmt, ap);
> +       va_end(ap);
> +       if (ret > 0)
> +               trace_bpf_trace_printk(buf);

Is there any reason to artificially limit the case of printing empty
string? It's kind of an awkward use case, for sure, but having
guarantee that every bpf_trace_printk() invocation triggers tracepoint
is a nice property, no?

> +       spin_unlock_irqrestore(&trace_printk_lock, flags);
> +
> +       return ret;
> +}
> +
>  /*
>   * Only limited trace_printk() conversion specifiers allowed:
>   * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pB %pks %pus %s
> @@ -483,8 +510,7 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
>   */
>  #define __BPF_TP_EMIT()        __BPF_ARG3_TP()
>  #define __BPF_TP(...)                                                  \
> -       __trace_printk(0 /* Fake ip */,                                 \
> -                      fmt, ##__VA_ARGS__)
> +       bpf_do_trace_printk(fmt, ##__VA_ARGS__)
>
>  #define __BPF_ARG1_TP(...)                                             \
>         ((mod[0] == 2 || (mod[0] == 1 && __BITS_PER_LONG == 64))        \
> @@ -518,13 +544,20 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
>         .arg2_type      = ARG_CONST_SIZE,
>  };
>
> +int bpf_trace_printk_enabled;

static?

> +
>  const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
>  {
>         /*
>          * this program might be calling bpf_trace_printk,
> -        * so allocate per-cpu printk buffers
> +        * so enable the associated bpf_trace/bpf_trace_printk event.
>          */
> -       trace_printk_init_buffers();
> +       if (!bpf_trace_printk_enabled) {
> +               if (trace_set_clr_event("bpf_trace", "bpf_trace_printk", 1))

just to double check, it's ok to simultaneously enable same event in
parallel, right?

> +                       pr_warn_ratelimited("could not enable bpf_trace_printk events");
> +               else
> +                       bpf_trace_printk_enabled = 1;
> +       }
>
>         return &bpf_trace_printk_proto;
>  }

[...]

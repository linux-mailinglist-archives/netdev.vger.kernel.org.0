Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1279110039
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 21:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfD3TTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 15:19:47 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40196 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfD3TTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 15:19:47 -0400
Received: by mail-oi1-f196.google.com with SMTP id y64so6675436oia.7
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 12:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g3qC6EpvLSeHFr2sRZhVsgJD/RMgh/dYJRkIiVXTq9w=;
        b=Nnxc1mQbpIdlfxZJ7b65LkwEBcnT2G3SZCW1ewlTv0HCLQ4SeZltNWI5DB2nRlxokd
         RbaAGI3WnQpjuhLJY9ogavnDOrcrgDcvHLoP1iCDhPh5D+pmfThLuStn7g+aL5vdM5ar
         sr/4+METBLx3UHpY+uyqkruCyquSMHVBY6rqFpT8B7wIk5ADufaYUkL6d/EkL+nrEEJL
         A52w4k7dbRxEjbEjnCVFV55IGN5uMzHbR/DBtTPsL+cdGWrwxwSHUVqQrT8gQ7y1NYdl
         R9H10F3TJ2anAK5lqoJyjCsDV1U8YOZ066fwedQIWhxvucztM9lbs98EpH9FMtFY+vbv
         PdHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g3qC6EpvLSeHFr2sRZhVsgJD/RMgh/dYJRkIiVXTq9w=;
        b=TANzALeLALExvrG6xfsy36yD6Nmeg7YEtd9x/2eWvjT16jYQw8TRgaHm6sWOqZNSo0
         if5WGaJLfLD9vfHnmThE3n/o8Sgn6DkgJXV+M/DDPhuutQApgr0ixtsfzmZd1nq428hj
         hgj/vNEKkNBTGRO7aefbmwbugLhFip582X9OtOY1lkCKsQXRxXC7Tknw9uOobFSFsaw7
         TRIXJHfU8/dnMkHvQljHOmJUTQP/8WyiKZgpcvLtMpmgIewp4EI/9lqFsYAsNmUAlXK9
         O7EneImU485qgzRwcRRGK/PkNxG5yIWgVZO1sQc9vllDQGDVP9WIPT4tLO5F7OY3Ao3t
         LD6Q==
X-Gm-Message-State: APjAAAWtCOHdTxur2uDhebRGp+GK8PmxAIiBNgeB2UjkTSiRQNOVtbE/
        /WAnJaP6xd9KyHgi4v82cIEzePjDCS4D9nxjGlujWQ==
X-Google-Smtp-Source: APXvYqxkhEi0s8vy1kV0tccLSHaysowwTaDcwz5lI7gFIXwU1OEMUPDBxvGY5LUoFgErWFKKyHF8OmhxBFF+gGMYJP8=
X-Received: by 2002:aca:dcd7:: with SMTP id t206mr4274264oig.68.1556651985980;
 Tue, 30 Apr 2019 12:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190404003249.14356-1-matthewgarrett@google.com> <20190404003249.14356-23-matthewgarrett@google.com>
In-Reply-To: <20190404003249.14356-23-matthewgarrett@google.com>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 30 Apr 2019 15:19:20 -0400
Message-ID: <CAG48ez0uVYJHycXv8jTvYrSGomhsQrQkR+Jpf-vXYJYn58eEjw@mail.gmail.com>
Subject: Re: [PATCH V32 22/27] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
To:     Matthew Garrett <matthewgarrett@google.com>, bpf@vger.kernel.org
Cc:     James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Linux API <linux-api@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Matthew Garrett <mjg59@google.com>,
        Network Development <netdev@vger.kernel.org>,
        Chun-Yi Lee <jlee@suse.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+bpf list

On Wed, Apr 3, 2019 at 8:34 PM Matthew Garrett
<matthewgarrett@google.com> wrote:
> There are some bpf functions can be used to read kernel memory:
> bpf_probe_read, bpf_probe_write_user and bpf_trace_printk.  These allow
> private keys in kernel memory (e.g. the hibernation image signing key) to
> be read by an eBPF program and kernel memory to be altered without
> restriction. Disable them if the kernel has been locked down in
> confidentiality mode.
>
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> cc: netdev@vger.kernel.org
> cc: Chun-Yi Lee <jlee@suse.com>
> cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  kernel/trace/bpf_trace.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 8b068adb9da1..9e8eda605b5e 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -137,6 +137,9 @@ BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
>  {
>         int ret;
>
> +       if (kernel_is_locked_down("BPF", LOCKDOWN_CONFIDENTIALITY))
> +               return -EINVAL;
> +
>         ret = probe_kernel_read(dst, unsafe_ptr, size);
>         if (unlikely(ret < 0))
>                 memset(dst, 0, size);

This looks wrong. bpf_probe_read_proto is declared with an
ARG_PTR_TO_UNINIT_MEM argument, so if you don't do a "memset(dst, 0,
size);" like in the probe_kernel_read() error path, the BPF program
can read uninitialized memory.

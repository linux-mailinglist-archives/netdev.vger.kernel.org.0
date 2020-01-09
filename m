Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 068B8135FE0
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388367AbgAIRxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:53:07 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36626 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730326AbgAIRxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 12:53:07 -0500
Received: by mail-lf1-f67.google.com with SMTP id n12so5851541lfe.3;
        Thu, 09 Jan 2020 09:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gE9Y5ECnaA5y/G3Oq/1mhBQAFOudM6qoOofRQi0t/RQ=;
        b=RA7VLeHUl85U4Z7omEUtRZFBQsf2W28qXz5EtPeM8XKVrm7xf8Ooya7DM4lOk9qu5A
         8fftAaZuuvDWKoJwUTZNdfXz4XAtLN2DT0dkum7GAp/Yef4m+ITodJxjKN19TOH4cE45
         zaDVuwvNbtXG4U2xJ9FauK2eOZ4N2tioTX2fr94gVarYr2/OsvmzGecq+bglwa7hmxdj
         IjcpzGrstitmjbrEnWsRlQQmtszDlaYIULYd7JqaXrDLSlamvbp7CTQzcxugQutw56om
         U8veGx0ZHAm/r33Fx8Hbt65UTJ9t2KsgguL5O9PYIgPoOtrb50LqRt4uyFv3FH7JHQtv
         azHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gE9Y5ECnaA5y/G3Oq/1mhBQAFOudM6qoOofRQi0t/RQ=;
        b=n7qYo33N2OppaUo7vIX9JvlEVjKg66HuBonE+Vy31LFVoIwziXdgvzLMUFE22CIpjG
         biefbq0DP0BmzWYfd/7L+63XNHIV2ESOxsmqzSGfLjTsyNKOsfzGaZ0k0JF5N03a4g9r
         IvIas5iac/UVDz9XA/aFVY++ehoPoy75B5iwPcbbrmx82dRwV+ZtF/ack3iptljYXJR3
         /hVcY4kNa3uQDRr1eYqLkIoIvjQIjDPLC9zSZQKqDu4xH3uHXZ+l66x87IqUK3ynClxC
         5wI6HdHEUCRVPqYRmcR3ct+JOQ1b1DJLQCya8AQwOiIl1af2EBkNDRVSKSESq+jR9Awy
         VsJA==
X-Gm-Message-State: APjAAAXEnjpPZsUjXNc77kwVzDlJU+9tCUI1FIs5289C/ZXjzcKIS3La
        8vuEiWn5M1EwWL6iSVTTSBYZznXg8QSVErIYCKo=
X-Google-Smtp-Source: APXvYqyU96xY1YnjNk04+rd/JS/JxMyZCKVccvYZUo/Jlzs2MKno2O9may8YKGt3uNjXiTcg4lig9F4we2hY36PiKkY=
X-Received: by 2002:a19:be93:: with SMTP id o141mr7373284lff.181.1578592385497;
 Thu, 09 Jan 2020 09:53:05 -0800 (PST)
MIME-Version: 1.0
References: <20200109003453.3854769-1-kafai@fb.com>
In-Reply-To: <20200109003453.3854769-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 9 Jan 2020 09:52:54 -0800
Message-ID: <CAADnVQ+nkr5+KJ8GAH7=TwA72ttB7xxrU8T5+RxkDKvn4FbWHg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 00/11] Introduce BPF STRUCT_OPS
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 4:35 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This series introduces BPF STRUCT_OPS.  It is an infra to allow
> implementing some specific kernel's function pointers in BPF.
> The first use case included in this series is to implement
> TCP congestion control algorithm in BPF  (i.e. implement
> struct tcp_congestion_ops in BPF).
>
> There has been attempt to move the TCP CC to the user space
> (e.g. CCP in TCP).   The common arguments are faster turn around,
> get away from long-tail kernel versions in production...etc,
> which are legit points.
>
> BPF has been the continuous effort to join both kernel and
> userspace upsides together (e.g. XDP to gain the performance
> advantage without bypassing the kernel).  The recent BPF
> advancements (in particular BTF-aware verifier, BPF trampoline,
> BPF CO-RE...) made implementing kernel struct ops (e.g. tcp cc)
> possible in BPF.
>
> The idea is to allow implementing tcp_congestion_ops in bpf.
> It allows a faster turnaround for testing algorithm in the
> production while leveraging the existing (and continue growing) BPF
> feature/framework instead of building one specifically for
> userspace TCP CC.
>
> Please see individual patch for details.
>
> The bpftool support will be posted in follow-up patches.
>
> v4:
> - Expose tcp_ca_find() to tcp.h in patch 7.
>   It is used to check the same bpf-tcp-cc
>   does not exist to guarantee the register()
>   will succeed.
> - set_memory_ro() and then set_memory_x() only after all
>   trampolines are written to the image in patch 6. (Daniel)
>   spinlock is replaced by mutex because set_memory_*
>   requires sleepable context.

Applied. Thanks

Please address any future follow up
and please remember to provide 'why' details in commit log
no matter how obvious the patch looks as Arnaldo pointed out.

Re: 'bpftool module' command.
I think it's too early to call anything 'a module',
since in this context people will immediately assume 'a kernel module'
It's a loaded phrase with a lot of consequences.
bpf-tcp-cc cubic and dctcp do look like kernel modules, but they are
not kernel modules at all. imo making them look like kernel modules
has plenty of downsides.
So as an immediate followup for bpftool I'd recommend to stick
with 'bpftool struct_ops' command or whatever other name.
Just not 'bpftool module'.

I think there is a makefile issue with selftests.
make clean;make -j50
kept failing for me three times in a row with:
progs/bpf_dctcp.c:138:4: warning: implicit declaration of function
'bpf_tcp_send_ack' is invalid in C99 [-Wimplicit-function-declaration]
                        bpf_tcp_send_ack(sk, *prior_rcv_nxt);
but single threaded 'make clean;make' succeeded.
Andrii, you have a chance to take a look and reproduce would be great.

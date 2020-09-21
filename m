Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15E427362E
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgIUXGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgIUXGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 19:06:04 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1843C061755;
        Mon, 21 Sep 2020 16:06:04 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id k18so2727798ybh.1;
        Mon, 21 Sep 2020 16:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JAJeSLPEctV1I2i+iBTFcnidXbsQyJBZGBpU38HncEY=;
        b=a//5dOYDtFY5KPITlAtIGEUNjU1dZEstlpA3JBbZwF7SJPNvNOTvl6LYh4GsGES5io
         Gb+NqPFCsUMQm2ZxIZLetS1qi7FwOre90Q/sdH0Fjobvm39Pj3tiuADup+L1bS5A37Te
         JH6udenG9Oaawg7YEuvCBK3xDPZUUXZQNoSUDEHosIkFBJpKjMZpZwwCVep4KR+EWV2Y
         JG4JXqWe+lKn36vpciaShXubPaWi4AnDxamXrbgzZMFH7etcwapfWXbpnSsut4KAeA1h
         3dFF41t6QKJF1ht+RfEkEyMMuQaJYe3au8SshJ9kMkPntBgQCnU/epUIBwDAZRdMqtiC
         fMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JAJeSLPEctV1I2i+iBTFcnidXbsQyJBZGBpU38HncEY=;
        b=ETebywtQPJu91JL5WgJPMX5V09qU0jJO8C5YbK1Ilu3Qbjbr/PljPSmqzmOsKMurSQ
         Yoe9PegfcNOgtNC68n6JF56N/uK0mDddQgxm0z8O42UhFuk7/YiGAi+tDY1dh+gRmMIt
         hsn5GkaOGwTV/Z6zJrTzDkWNlzuq6ZLWpe/jQqtL7s2Ym4A78dXP28RULALQHxiHsC73
         Xle8ClSXf4DQt036osBwtFOqq3tyWHHoxhLYd011PYS6UWLWWaS7DY+/nzcaPGf4gsQf
         I8QtwKp8V2aNH2zr3CZfeb1S60blv/M4twGr2nhZnE7rZXQ+v5Z1U7XqZID3A/8ZQOcJ
         reDw==
X-Gm-Message-State: AOAM533Asu/UsBTot/FLQINODhshTABVtb8aS2oslQ7jzKvjnV/jSS9A
        Xka1w3Ep6ghmQDysmosp4UQWSymkaIeWJ4epTsw=
X-Google-Smtp-Source: ABdhPJwvTBXl7ZW3tVVF+D6wlfBWQP6k25xZ0YZIM7A6J3hCsTlfZWMK38GCjfk5Ajscv0yR0HL8cE8Lu0QC5U6WPnQ=
X-Received: by 2002:a25:6644:: with SMTP id z4mr3166667ybm.347.1600729564130;
 Mon, 21 Sep 2020 16:06:04 -0700 (PDT)
MIME-Version: 1.0
References: <160051618267.58048.2336966160671014012.stgit@toke.dk> <160051618622.58048.13304507277053169557.stgit@toke.dk>
In-Reply-To: <160051618622.58048.13304507277053169557.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 16:05:53 -0700
Message-ID: <CAEf4BzY4UR+KjZ3bY6ykyW5CPNwAzwgKVhYHGdgDuMT2nntmTg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 03/10] bpf: verifier: refactor check_attach_btf_id()
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> The check_attach_btf_id() function really does three things:
>
> 1. It performs a bunch of checks on the program to ensure that the
>    attachment is valid.
>
> 2. It stores a bunch of state about the attachment being requested in
>    the verifier environment and struct bpf_prog objects.
>
> 3. It allocates a trampoline for the attachment.
>
> This patch splits out (1.) and (3.) into separate functions in preparatio=
n
> for reusing them when the actual attachment is happening (in the
> raw_tracepoint_open syscall operation), which will allow tracing programs
> to have multiple (compatible) attachments.
>
> No functional change is intended with this patch.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Ok, so bad news: you broke another selftest (test_overhead). Please,
do run test_progs and make sure everything succeeds, every time before
you post a new version.

Good news, though, is that this refactoring actually fixed a pretty
nasty bug in check_attach_btf_id logic: whenever bpf_trampoline
already existed (e.g., due to successful fentry to function X), all
subsequent fentry/fexit/fmod_ret and all their sleepable variants
would skip a bunch of check. So please attach the following Fixes
tags:

Fixes: 6ba43b761c41 ("bpf: Attachment verification for BPF_MODIFY_RETURN")
Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")

As for selftests, feel free to just drop the fmod_ret program, it was
never supposed to be possible, I just never realized that.

>  include/linux/bpf.h          |    7 +
>  include/linux/bpf_verifier.h |    9 ++
>  kernel/bpf/trampoline.c      |   20 ++++
>  kernel/bpf/verifier.c        |  197 ++++++++++++++++++++++++------------=
------
>  4 files changed, 149 insertions(+), 84 deletions(-)
>

[...]

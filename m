Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B996E18E40E
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 20:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgCUTnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 15:43:53 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46402 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbgCUTnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 15:43:53 -0400
Received: by mail-qk1-f196.google.com with SMTP id f28so10920437qkk.13;
        Sat, 21 Mar 2020 12:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8X1nssZkX3zE36HSGSKw4pjFMAwkKO3h6A7s6TzL6sg=;
        b=QM3sQ4nzW+ZZ2vvk6bH+H5qKOjZqOguoJrsIbMowx6oOUKbcGwlxx/0zNo+WPc22EW
         SkE6HPfpYMB4N5SXVWn7BsreBFc59jYneewMVbAeN0zmpmKld4wsINeJES853hx48jhs
         Hi1tJm5KcFQKEKvkR/CxdATFen4dQEYDJt2X3UPQk9TjaEcxVy/7zr6MEAwgrZysiOV4
         GNiU1M805ZRBfUhS3wRouqie7vDrl2LDyLTaAylHxxw8bafnCDh0zgbYFGRPfOwYexIB
         FLoa9uHwqVPQnAD5/AbqqpQoA9KvNMrnVg8Hx/jrNPk37TLu/GdQ+TRdVAeUu11jIMr1
         8GWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8X1nssZkX3zE36HSGSKw4pjFMAwkKO3h6A7s6TzL6sg=;
        b=kdjeA2Yafc4bai8LK8nG7ej2yxoO3HPneKKCtw6slJNn5/ziVXRVf9in7SJ84kKhvg
         +cHJ8CZJUAYC10XIPJvCjlcEtBO30jty8SE6cUiEvQLkxc5odAXyKn44+uV70zUeYWth
         zleyKA4CCcRQ7t8nJnn4pdErWEfgX/xi9bp97GvizWcelGp7bM5le75VRh+ARjuJXYqW
         uaknJ65LKo9ATSkQhI75yja7eczP1f10B68VNOGzsFhXsnjWzaFOLdzZCOdxBfMjbWSk
         Q9vi66MlOkrbjyvO5I20K4I7gigahbNiNqjn223ErsI7s4NT/WPQwGKIQ2w09aLjTvUE
         7qVg==
X-Gm-Message-State: ANhLgQ3zkCeO0lVw4IK/ndPfNCzGlXC3UhDrwHYL+v5gi2d47ecm1nyJ
        VhsZz0YOwpc8c7C9tKq5bL6htVC+fuZcpkvjAZA=
X-Google-Smtp-Source: ADFU+vviphwOi87GrpQ2PO4bA4AsZGiWxAw1kQpNFJW4HSm1xb2bYdrJQvdp/a3WfbWi0CZ7H+SAnI+1+aRaHMcIecQ=
X-Received: by 2002:a37:454c:: with SMTP id s73mr2758212qka.92.1584819832189;
 Sat, 21 Mar 2020 12:43:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200321100424.1593964-1-danieltimlee@gmail.com> <20200321100424.1593964-3-danieltimlee@gmail.com>
In-Reply-To: <20200321100424.1593964-3-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 21 Mar 2020 12:43:41 -0700
Message-ID: <CAEf4BzbTYyBG4=Muj5EOqtNxkivtT9Bn5+ibmp3e-BLBybQO1A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 2/2] samples: bpf: refactor perf_event user
 program with libbpf bpf_link
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 3:04 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> The bpf_program__attach of libbpf(using bpf_link) is much more intuitive
> than the previous method using ioctl.
>
> bpf_program__attach_perf_event manages the enable of perf_event and
> attach of BPF programs to it, so there's no neeed to do this
> directly with ioctl.
>
> In addition, bpf_link provides consistency in the use of API because it
> allows disable (detach, destroy) for multiple events to be treated as
> one bpf_link__destroy. Also, bpf_link__destroy manages the close() of
> perf_event fd.
>
> This commit refactors samples that attach the bpf program to perf_event
> by using libbbpf instead of ioctl. Also the bpf_load in the samples were
> removed and migrated to use libbbpf API.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

> Changes in v2:
>  - check memory allocation is successful
>  - clean up allocated memory on error
>
> Changes in v3:
>  - Improve pointer error check (IS_ERR())
>  - change to calloc for easier destroy of bpf_link
>  - remove perf_event fd list since bpf_link handles fd
>  - use newer bpf_object__{open/load} API instead of bpf_prog_load
>  - perf_event for _SC_NPROCESSORS_ONLN instead of _SC_NPROCESSORS_CONF
>  - find program with name explicitly instead of bpf_program__next
>  - unconditional bpf_link__destroy() on cleanup
>
> Changes in v4:
>  - bpf_link *, bpf_object * set NULL on init & err for easier destroy
>  - close bpf object with bpf_object__close()
>
> Changes in v5:
>  - on error, return error code with exit
>
>  samples/bpf/Makefile           |   4 +-
>  samples/bpf/sampleip_user.c    |  98 +++++++++++++++--------
>  samples/bpf/trace_event_user.c | 139 ++++++++++++++++++++++-----------
>  3 files changed, 159 insertions(+), 82 deletions(-)
>

[...]

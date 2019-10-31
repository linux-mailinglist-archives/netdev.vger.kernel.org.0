Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13874EB83F
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbfJaUHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:07:35 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39961 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfJaUHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:07:35 -0400
Received: by mail-qk1-f195.google.com with SMTP id y81so8351958qkb.7;
        Thu, 31 Oct 2019 13:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E7hwyp8h5jDhBVawX15T64TVVDKIMmEzthJ/OWzt9Yk=;
        b=NwSdFnFH5HNZE1MG/G47pg6a4XO6ZBPDxXI/vpTzKDWJmrHRjU6+tKeMUzq75amGv6
         lQoZRT1cbz+8R4Ms40xWyPhYk2KJIf13zd166Grdvpkbt0pJSFcZY8WzefHCNzGWlxwA
         QvCh9rgrUq0pM/3oMCvBUk+f+I2XaSz4tUsh40ibtowVOL67jU9eAbJz3/vubDMP1UpK
         IXYtHpHtIdQmCqr4mZNW2v+On7DZ6QOVx8ZZHNz2X4C402aMlHkva4NkeN0HnZUWTIIm
         JKu3tZ1qWCnmYnZFmUU4NfiDNWdXMv0LcVBLVowhhXjvzblAtT5Cj0OKDL7eRLnZThRC
         s9fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E7hwyp8h5jDhBVawX15T64TVVDKIMmEzthJ/OWzt9Yk=;
        b=r4tIPZNg7jAfq00gHsYsELHpb2iTtraGruE5YMvuftUzVJDVlmW3ZWVd8Eb8omCNTz
         WUUu7CHy+ek5/1voVCaAbLDm8ZCQtqNyPrB/aKOVTXuZes/jf3cj32EHUlRODPegJR0X
         mD6872sxFajHK5b1JgDdCKkeuhd9kLLKOd8840dA6c31Y5Om/gGCK9cxmXFcXyckxuj+
         thrNR7l+lby9Lfby0I0mT7eCX8rkNA+rkUwgLmC4oXW6HVugxPZ/xttNxXk/p039Pf/Z
         yzLJKPF/crxaHsEHrSq8sd78KVyHFewPOmeFBAxJXcftZC0FTl5UVjuzJARaTCkyr8IX
         iduQ==
X-Gm-Message-State: APjAAAXsG162ea1YwpADvo6BnqjZ9mnBndb1K40rJhpeMKAbKXNR7IWD
        lr1S3AoaFqW8U1IY0YxUhZ/IfYBIYLimNx/NB3s7dQ==
X-Google-Smtp-Source: APXvYqyTAM/zy5H6uhLeOWJVUL7irhem0G2EcdbNZEMsnlcyXTg/t4I77ssl+pJ4zITpuPmB67F1MitKJbwTr5uiE1U=
X-Received: by 2002:a37:a7c4:: with SMTP id q187mr646515qke.437.1572552453870;
 Thu, 31 Oct 2019 13:07:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1572483054.git.daniel@iogearbox.net> <637eba87807516061f1fee93536053507ea20b0a.1572483054.git.daniel@iogearbox.net>
In-Reply-To: <637eba87807516061f1fee93536053507ea20b0a.1572483054.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 31 Oct 2019 13:07:22 -0700
Message-ID: <CAEf4BzYLjj0ExmO3hOV-JN+KJFs4vEW9PL7yDrK1+HTan+LVPQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/8] bpf: Add probe_read_{user,kernel} and
 probe_read_{user,kernel}_str helpers
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 6:00 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> The current bpf_probe_read() and bpf_probe_read_str() helpers are broken
> in that they assume they can be used for probing memory access for kernel
> space addresses /as well as/ user space addresses.
>
> However, plain use of probe_kernel_read() for both cases will attempt to
> always access kernel space address space given access is performed under
> KERNEL_DS and some archs in-fact have overlapping address spaces where a
> kernel pointer and user pointer would have the /same/ address value and
> therefore accessing application memory via bpf_probe_read{,_str}() would
> read garbage values.
>
> Lets fix BPF side by making use of recently added 3d7081822f7f ("uaccess:
> Add non-pagefault user-space read functions"). Unfortunately, the only way
> to fix this status quo is to add dedicated bpf_probe_read_{user,kernel}()
> and bpf_probe_read_{user,kernel}_str() helpers. The bpf_probe_read{,_str}()
> helpers are kept as-is to retain their current behavior.
>
> The two *_user() variants attempt the access always under USER_DS set, the
> two *_kernel() variants will -EFAULT when accessing user memory if the
> underlying architecture has non-overlapping address ranges, also avoiding
> throwing the kernel warning via 00c42373d397 ("x86-64: add warning for
> non-canonical user access address dereferences").
>
> Fixes: a5e8c07059d0 ("bpf: add bpf_probe_read_str helper")
> Fixes: 2541517c32be ("tracing, perf: Implement BPF programs attached to kprobes")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

LGTM!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/uapi/linux/bpf.h       | 120 +++++++++++++++-------
>  kernel/trace/bpf_trace.c       | 181 ++++++++++++++++++++++++---------
>  tools/include/uapi/linux/bpf.h | 120 +++++++++++++++-------
>  3 files changed, 297 insertions(+), 124 deletions(-)
>

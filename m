Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F7D596B1
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 11:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfF1JBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 05:01:38 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46193 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfF1JBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 05:01:38 -0400
Received: by mail-ot1-f66.google.com with SMTP id z23so5221652ote.13
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 02:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qUV4kfBHQVUIKfARtG5Yav4Y3FA4sBjhtv6NQ9Qeu8I=;
        b=ivpGvcNMhyqcB3ec1oT53roHxf8bewZ3Phb32ULIMDyniG6NclUbjzZ+a+5XrNDs1b
         SLblk5TVBOPR3Rjk/W0F5n+geCFzDrMLzbT1e9slOxgOjriNHnSCMTmE+dl4TjZUKuh0
         XLHZASHT2NvQWoy5b66tH0j9TEahbD/9GO+J8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qUV4kfBHQVUIKfARtG5Yav4Y3FA4sBjhtv6NQ9Qeu8I=;
        b=CE+ou3SQdDN8Gn1fAqJx6jrpSjW6gFXl77xO35N0C3qRSDJIJn5dKvGL+VrK5rPmax
         MVMdHnUSGywNOgxhf7zEak3NK01vaSqtOpH+xAviOd7ffBqNoEpxeGMm2JcwU6V5t+1f
         pWtftI6RHNMN4zPSdoj0Z5xZeRYauXVHDRZzpyW1i1NGzRUTPRiDKQprePSkJPxgilh4
         gRyyyBD2BX+TgxHkPy+elEB3MG8nJVSRIC9kRdCWBzIeu4ybf7lRMQsiZjR7PCIFW2Cm
         BYofzpDrr5efcV30QzjtxL0ZIAhf0QeXvJHHb0IDuZ5xafUO4wzg7OHOlAGW4yYubmYP
         /P7g==
X-Gm-Message-State: APjAAAXxBXi2LoAF9EcZNWWAKbEeXyxN6f/UP3GZPq1cSwHJv50AHQMm
        bcu9jr1BXi44uSDNVBBmTjEQg5p1iUPJCsZaLWVkWw==
X-Google-Smtp-Source: APXvYqyzaKbGnEbZX82tZjeqdRHpKJO2uNGCf/NKctMgnNoP971VgVKcSpcqhzdqJ6FJf2DUKEU5RNJ8x0u4O2p9aIU=
X-Received: by 2002:a05:6830:1485:: with SMTP id s5mr214548otq.132.1561712497511;
 Fri, 28 Jun 2019 02:01:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190627201923.2589391-1-songliubraving@fb.com> <20190627201923.2589391-2-songliubraving@fb.com>
In-Reply-To: <20190627201923.2589391-2-songliubraving@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 28 Jun 2019 10:01:26 +0100
Message-ID: <CACAyw98RvDc+i3gpgnAtnM0ojAfQ-mHvzRXFRUcgkEPr3K4G-g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Jann Horn <jannh@google.com>,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 at 21:19, Song Liu <songliubraving@fb.com> wrote:
>
> This patch introduce unprivileged BPF access. The access control is
> achieved via device /dev/bpf. Users with write access to /dev/bpf are able
> to call sys_bpf().
>
> Two ioctl command are added to /dev/bpf:
>
> The two commands enable/disable permission to call sys_bpf() for current
> task. This permission is noted by bpf_permitted in task_struct. This
> permission is inherited during clone(CLONE_THREAD).

If I understand it correctly, a process would have to open /dev/bpf before
spawning other threads for this to work?

That still wouldn't work for Go I'm afraid. The runtime creates and destroys
threads on an ad-hoc basis, and there is no way to "initialize" in the
first thread.
With the API as is, any Go wrapper wishing to use this would have to do the
following _for every BPF syscall_:

1. Use runtime.LockOSThread() to prevent the scheduler from moving the
    goroutine.
2. Open /dev/bpf to set the bit in current_task
3. Execute the syscall
4. Call runtime.UnlockOSThread()

Note that calling into C code via CGo doesn't change this. Is it not possible to
set the bit on all processes in the current thread group?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com

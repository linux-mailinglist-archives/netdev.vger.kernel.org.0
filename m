Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9EA485C78
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 00:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245605AbiAEXvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 18:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245548AbiAEXuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 18:50:54 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF65C061212;
        Wed,  5 Jan 2022 15:50:54 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id y18so1071847iob.8;
        Wed, 05 Jan 2022 15:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0zfMb+1SdFOxuYnMn3F/Qlgo0+UXJSZ15PtBx86grNE=;
        b=UYEgJNfQHdd53UEz7fncIMq08vBYdy0UVG4YBafKvJU4GQpYk3Ju9SRcg+VBIOJS+V
         KKZtC+f+F1NsQz6Gzj44Kncb6Z3+pZqPs0+z87FRLT1rkoi49u/eeBzn0M7F3g7y0Y8P
         9zFfeIoLWK7pBMBHyNi7OE7ccLzWqaK2W1mJyJE2c9z/T9S7yGgoPtlRG18pl+X4k7Ts
         sUhcJ7kTDarSdyYg8m9vBlb43EdFVbrjqFeOD2qoT3Nlpz5NdGwuHIsz31Um4eaxIHS+
         nukAA68neT49dpPXPy19MMikuOQ7mDvEdIVCC4yGriFwoBP+uX9ODicTP6Wbf6UJkSeV
         vTDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0zfMb+1SdFOxuYnMn3F/Qlgo0+UXJSZ15PtBx86grNE=;
        b=VHAx69jPqfL9eUrII9l0Ru4ceo7KA/X9BdSxAvvoxAj4xXK3kGfXdLXGPShsmZoQmq
         xtw+yhTY1QRVSfTtl1cuvuU4M17mDaJuTMoXUhRoXNK98T3hcEBUOztQDxmAffOrssJ1
         d1AX0I+r5mfhSyWG0JAlG0tF/FX+ajGml7dG8HRmVnrBe8UiE4jo7jzfzDdBnD4G1KQA
         N6XIl36MsnXzhUBaIWDedFDAvuZpXlJO0X/q7c8Pmel1jiPMVtTcf3oTCuMWQ5dfg+PR
         zL1LpaM5QrIBPKdj9ITRTk3fh1ya/FC1dt385rgybLHW0eIAgO864vedXN4REvIM71G/
         YO5w==
X-Gm-Message-State: AOAM5308MRCIteXxMMGto8mr9ojTEkq5C3mPZJ/h5ZcijMGSxzWJPXwq
        mvNpnrgnbX0bIKiYjTVAXz003ya/3q2xKqLK1zM=
X-Google-Smtp-Source: ABdhPJzthy66Bvze+d8GBjLkHw9iUTICuUoRVrkwlb3ekN/uhPc4ULOw5BPUdUHOLrVp6ASNv6owmXGYwLklufnGisY=
X-Received: by 2002:a02:ce8f:: with SMTP id y15mr21725717jaq.234.1641426653541;
 Wed, 05 Jan 2022 15:50:53 -0800 (PST)
MIME-Version: 1.0
References: <BCA4C02F-0238-4818-BDF1-2F0411CD95A6@gmail.com>
In-Reply-To: <BCA4C02F-0238-4818-BDF1-2F0411CD95A6@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Jan 2022 15:50:42 -0800
Message-ID: <CAEf4Bzbxgj-1Eboi7wri+E7P_2xkZ48K2VnqbHz-Kow2zdLojw@mail.gmail.com>
Subject: Re: [Resource Leak] Missing closing files in samples/bpf/hbm.c
To:     Ryan Cai <ycaibb@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 7:26 PM Ryan Cai <ycaibb@gmail.com> wrote:
>
> Dear Kernel maintainers,
>
>           1. In run_bpf_prog, the file opened at Line 308 may not closed when going to Line 310.
>           Location: https://github.com/torvalds/linux/blob/5bfc75d92efd494db37f5c4c173d3639d4772966/samples/bpf/hbm.c#L302-L310
>
>          2. In read_trace_pipe2, the file opened at Line 91 may not closed in the function.
>          Location: https://github.com/torvalds/linux/blob/5bfc75d92efd494db37f5c4c173d3639d4772966/samples/bpf/hbm.c#L91-L109
>
>            Should it be a bug? I can send a patch for these.
>

seems so, please send patches

> Best,
> Ryan
>
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FF31B357E
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 05:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgDVDWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 23:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726228AbgDVDWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 23:22:51 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA08EC0610D6;
        Tue, 21 Apr 2020 20:22:49 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id i16so460165ils.12;
        Tue, 21 Apr 2020 20:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ngwWNryn53mv5pf3kxdo+3CTU9h4WSyb9ORxIz0mDo=;
        b=ffHScq1RcJmx3bP5Ru5ifCLjCgE4UUmpBUUaHrF0ci728gEjOLaSzxbbUZsIkImI+d
         1389lfc19T2o62fNbQwdfXzNcIL6c9HxDudSbtJmsy36/5VXNMHNbp5vNxc8oBc4Aemr
         jrgyS7FnmRVztOR+5/v7UZjd7stM2dRL+2yWul50ScFOEbXgULqM7xutrIqo6XLN+Swq
         ZIcu15X0Svf6wcNkn+3m3WrV2m/9sgFFJ8Bpod9AnCftroQz2tvkF8iErYQun9Qb6EBO
         /mfpD3VHT5W47hagPHTjxhjfhJc7R+9V99x5bvhLpliBD1d0n6wZxPrh6pUdVOWmDUxP
         ukkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ngwWNryn53mv5pf3kxdo+3CTU9h4WSyb9ORxIz0mDo=;
        b=euwdsPmkxhPjamWqDvS2YeESCmh2Ua+6AFblAPY8YkmboVRZhyRlQCehLh9V5s0Qqb
         elVudvR69OGT95/qnylo0w6cM9VxwWZvjyyNfiS1s8XbfQ6dBciw62mX85aEe5b1lr2I
         ZTrHS1X9eHfQMeiV17j7tBhC0bdIKCkUjMGWEVcVif/clTmsoIhEi8EeqAIpqUE2lO0i
         igMbUKjdc6ya6IyLPCcfWqEd5b4bgYMmzzXPu+4FUMpn70YTHC+Jc7c134L9ov8lRw1o
         aBEx0dmJduQs7OyyvlR1sutK1mh5QC8PAjn5oS4yaphucl6p+eb6FOMBcU/sYekE6+4b
         B7og==
X-Gm-Message-State: AGi0PubqsjC74IzLiuiTi7dN1TBSjj7bFQIWgB88C/CNh//Flnx6Gs9M
        O+EStw6U5cfIsxJtUydmImcc6pWzbCL9H8q/NA==
X-Google-Smtp-Source: APiQypKWVc/5KxHWRXc9pXM1nr31xgg5a0uM08KcpBvS2/zCInPHw70vQv4k1EfyXLA3/6mHs8xWM6RZMaBmXcWSw74=
X-Received: by 2002:a92:41c7:: with SMTP id o190mr23768272ila.11.1587525767232;
 Tue, 21 Apr 2020 20:22:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200421171552.28393-1-luke.r.nels@gmail.com> <6f1130b3-eaea-cc5e-716f-5d6be77101b9@zytor.com>
 <CAKU6vyb38-XcFeAiP7OW0j++0jS-J4gZP6S2E21dpQwvcEFpKQ@mail.gmail.com>
In-Reply-To: <CAKU6vyb38-XcFeAiP7OW0j++0jS-J4gZP6S2E21dpQwvcEFpKQ@mail.gmail.com>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Tue, 21 Apr 2020 23:22:36 -0400
Message-ID: <CAMzpN2hpwK00duVmrzuhDeZY+H7doJ+C-O6=SWrzy+KvAsupqw@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf, x32: Fix invalid instruction in BPF_LDX zero-extension
To:     Xi Wang <xi.wang@gmail.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org,
        Luke Nelson <luke.r.nels@gmail.com>,
        Wang YanQing <udknight@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 3:32 PM Xi Wang <xi.wang@gmail.com> wrote:
>
> On Tue, Apr 21, 2020 at 10:39 AM H. Peter Anvin <hpa@zytor.com> wrote:
> > x32 is not x86-32.  In Linux we generally call the latter "i386".
>
> Agreed.  Most of the previous patches to this file use "x32" and this
> one just wanted to be consistent.
>
> > C7 /0 imm32 is a valid instruction on i386. However, it is also
> > inefficient when the destination is a register, because B8+r imm32 is
> > equivalent, and when the value is zero, XOR is indeed more efficient.
> >
> > The real error is using EMIT3() instead of EMIT2_off32(), but XOR is
> > more efficient. However, let's make the bug statement *correct*, or it
> > is going to confuse the Hades out of people in the future.
>
> I don't see how the bug statement is incorrect, which merely points
> out that "C7 C0 0" is an invalid instruction, regardless of whether
> the JIT intended to emit C7 /0 imm32, B8+r imm32, 31 /r, 33 /r, or any
> other equivalent form.

You should explain the reason it is invalid, ie. the instruction
encoding needs a 32-bit immediate but the current code only emits an
8-bit immediate.

--
Brian Gerst

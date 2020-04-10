Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA151A4CA2
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 01:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgDJXZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 19:25:58 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37607 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgDJXZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 19:25:57 -0400
Received: by mail-qk1-f193.google.com with SMTP id 130so3801275qke.4;
        Fri, 10 Apr 2020 16:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XJSJ+w4/Plnso05TYxnfYidDNdaDe5kK5saMa7/s/0g=;
        b=b3iPHprRcQ63yr4BeZbaL4CRW9UxfHw+SQ2Kyzah7jcOfDeUO2vSbgxxPcBfH9lFqC
         3URZ2F2q0/0Gv3M86cy6XID7GoApfmh0/paEyoCGqnqyWhlpbZ6QePF0O1TSxi3JiwqA
         pVakZ8dW9RoAj5C7FCwlIjNY3RgHt6+vROxiCWedfEpFHHDIiXVwBF3UI45xjNS3+jKr
         usCrVeC5W127bvbqPbeocXcx8/Esf8EkFtibj52SckgWqk7oxe0P+paH/SZgTBSUAn6l
         DKMCp0Lfjs+hDBkbjrzYcL/BKSM1juuqS21EpR2/3rxTerdSyMliIrhm1RaBfoROaJNW
         TQ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XJSJ+w4/Plnso05TYxnfYidDNdaDe5kK5saMa7/s/0g=;
        b=tCFCWHtyS1/O0R8CeYafByLXnD6f+az2dWzHSg01eCVENEBLq3E40+Q0gKO7PvbIKt
         Ch0jxoM11oCXKxydAAfoaV47X5hmOm4XGZCSrEn6jcky4X5w3cQZziyD/oqWB27dWdb0
         YcsLsDSiF0s86NiXAjYU7Nj1irwb6dcgHrjmOxY1/xI/duIVun2GAQ6XIBI/utNFx2Cb
         BW9+e7hKZeWZiKxwdyVF5Vx++xmLPv7p4M801CgQUvg82eJP+/D8p4cLCAKb6xvYxelU
         8h7pmEp7TuxPbdUCnvZrlqEZwB1gZ4h5Gyf52TGnc+SZU+5Z/CW4HfWDWIWqV+ayogkG
         iH5g==
X-Gm-Message-State: AGi0PuZYcIyHlcLBuYWVUg5XSvkrWg+FlC9d4aEfjc+9ajZxyjop5Vof
        cgP/6wSTN7UNDig+UpjR9/VK0Tj+3urkr+7yBSM=
X-Google-Smtp-Source: APiQypJghPXUilUtO5cpcq205V0cfE0qaVInB51VIad+RA7TTvnlQz8ZPP65Z4ThHXZ56oaXiiDsOwAi0NmMsclPuqM=
X-Received: by 2002:a05:620a:88e:: with SMTP id b14mr6681145qka.449.1586561155804;
 Fri, 10 Apr 2020 16:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232526.2675664-1-yhs@fb.com>
In-Reply-To: <20200408232526.2675664-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Apr 2020 16:25:45 -0700
Message-ID: <CAEf4Bza8w9ypepeu6eoJkiXqKqEXtWAOONDpZ9LShivKUCOJbg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> Given a loaded dumper bpf program, which already
> knows which target it should bind to, there
> two ways to create a dumper:
>   - a file based dumper under hierarchy of
>     /sys/kernel/bpfdump/ which uses can
>     "cat" to print out the output.
>   - an anonymous dumper which user application
>     can "read" the dumping output.
>
> For file based dumper, BPF_OBJ_PIN syscall interface
> is used. For anonymous dumper, BPF_PROG_ATTACH
> syscall interface is used.
>
> To facilitate target seq_ops->show() to get the
> bpf program easily, dumper creation increased
> the target-provided seq_file private data size
> so bpf program pointer is also stored in seq_file
> private data.
>
> Further, a seq_num which represents how many
> bpf_dump_get_prog() has been called is also
> available to the target seq_ops->show().
> Such information can be used to e.g., print
> banner before printing out actual data.

So I looked up seq_operations struct and did a very cursory read of
fs/seq_file.c and seq_file documentation, so I might be completely off
here.

start() is called before iteration begins, stop() is called after
iteration ends. Would it be a bit better and user-friendly interface
to have to extra calls to BPF program, say with NULL input element,
but with extra enum/flag that specifies that this is a START or END of
iteration, in addition to seq_num?

Also, right now it's impossible to write stateful dumpers that do any
kind of stats calculation, because it's impossible to determine when
iteration restarted (it starts from the very beginning, not from the
last element). It's impossible to just rememebr last processed
seq_num, because BPF program might be called for a new "session" in
parallel with the old one.

So it seems like few things would be useful:

1. end flag for post-aggregation and/or footer printing (seq_num == 0
is providing similar means for start flag).
2. Some sort of "session id", so that bpfdumper can maintain
per-session intermediate state. Plus with this it would be possible to
detect restarts (if there is some state for the same session and
seq_num == 0, this is restart).

It seems like it might be a bit more flexible to, instead of providing
seq_file * pointer directly, actually provide a bpfdumper_context
struct, which would have seq_file * as one of fields, other being
session_id and start/stop flags.

A bit unstructured thoughts, but what do you think?

>
> Note the seq_num does not represent the num
> of unique kernel objects the bpf program has
> seen. But it should be a good approximate.
>
> A target feature BPF_DUMP_SEQ_NET_PRIVATE
> is implemented specifically useful for
> net based dumpers. It sets net namespace
> as the current process net namespace.
> This avoids changing existing net seq_ops
> in order to retrieve net namespace from
> the seq_file pointer.
>
> For open dumper files, anonymous or not, the
> fdinfo will show the target and prog_id associated
> with that file descriptor. For dumper file itself,
> a kernel interface will be provided to retrieve the
> prog_id in one of the later patches.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h            |   5 +
>  include/uapi/linux/bpf.h       |   6 +-
>  kernel/bpf/dump.c              | 338 ++++++++++++++++++++++++++++++++-
>  kernel/bpf/syscall.c           |  11 +-
>  tools/include/uapi/linux/bpf.h |   6 +-
>  5 files changed, 362 insertions(+), 4 deletions(-)
>

[...]

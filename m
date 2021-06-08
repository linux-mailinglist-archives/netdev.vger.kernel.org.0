Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFAC39FE2A
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 19:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhFHRvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 13:51:40 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:33738 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbhFHRvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 13:51:38 -0400
Received: by mail-wr1-f47.google.com with SMTP id a20so22575191wrc.0
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 10:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8VUcUNHL3JuSqy+zkLCk7TZMD9OSteZxhISOtRNVDjQ=;
        b=Rkv4RbY/1E+9cYKHD1E0VCGCJJ8FeA4zTISQEe7eaDnASxEiHmqhKpYX5ore5xvmKd
         qBsqhYwcgBZuOaSUmcYb6o+iTCOoctKY3yLPFLrhzgdmC677GwT+2xpcuZ2AX5O8CbID
         Y5P7LPwa9L91pKhqsZkACt7cyWinpUyu1bGFL9FzzXC614RQEmuKnXIVookASJs7cULS
         S+jMjIljXL4R0vm/AFwuAplXCJfVclcAyqnWssZ/JNSZhqqDwqcTXOKMWM9t5UvsyUxG
         nbqy7PGOt0CvMIsE3F0Gr2CHVRxXqW4NtHwW4Zf4fzby0tyM27MqfcYBtFFjU3Tj9l+P
         NBHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8VUcUNHL3JuSqy+zkLCk7TZMD9OSteZxhISOtRNVDjQ=;
        b=q1rQC/ElyCZRsKfbI9ZfemGIsCT+jsaS7UCb52WTBhWsZLWOplfzfwfT2/eM/pB9C1
         m+hH8qzY6oIlbYXgl4D0l0rI/JPuvlchrXylbSIGqNIJBLGN0J+mPgJCmPt7RZKPapW2
         w2oRXm2/KAiHcxmFEL3YEBauzZcfbMWE44nOuM6BLVV02qJiWq4CIOdsppTGQBKjOqnJ
         ZLz2/pDrgVRoUwlOmoJmcPd9xojgtVKr6hsC8MtTJSk0G7yERYNCbAo/nsYr7yXZ2MTu
         CA8zNNfth9UZqmoW7udHb0wr21y/qqxI5jBL6sdvnvL37UZBqoVREYMy5pazSz98iJbI
         Iqlg==
X-Gm-Message-State: AOAM530Ay4WekcM7u9RZLmqep3zKwAD5rW9ixcDGfeqcuS8ck0g9fDsM
        +Ar58k5z2smnzTr62FYUKCXGfNGI36h5l30qyf6NRQ==
X-Google-Smtp-Source: ABdhPJw3AXWRQHvemXMm9mHm72Hk/moNbFy9rPAbavS5t8/FbQE/HUYxi+rspRDnbpqKEpaBgYhgnMBG3s6lyQMDBxY=
X-Received: by 2002:a5d:694b:: with SMTP id r11mr17324336wrw.168.1623174524512;
 Tue, 08 Jun 2021 10:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210521182104.18273-1-kuniyu@amazon.co.jp> <c423bd7b-03ab-91f2-60af-25c6dfa28b71@iogearbox.net>
In-Reply-To: <c423bd7b-03ab-91f2-60af-25c6dfa28b71@iogearbox.net>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Tue, 8 Jun 2021 10:48:06 -0700
Message-ID: <CAK6E8=dtFmPYpK71XJc=HFDUL9mYO1i36Q8BemwSGcCq+3BEmw@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 11:42 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> > The SO_REUSEPORT option allows sockets to listen on the same port and to
> > accept connections evenly. However, there is a defect in the current
> > implementation [1]. When a SYN packet is received, the connection is tied
> > to a listening socket. Accordingly, when the listener is closed, in-flight
> > requests during the three-way handshake and child sockets in the accept
> > queue are dropped even if other listeners on the same port could accept
> > such connections.
> >
> > This situation can happen when various server management tools restart
> > server (such as nginx) processes. For instance, when we change nginx
> > configurations and restart it, it spins up new workers that respect the new
> > configuration and closes all listeners on the old workers, resulting in the
> > in-flight ACK of 3WHS is responded by RST.
> >
> > To avoid such a situation, users have to know deeply how the kernel handles
> > SYN packets and implement connection draining by eBPF [2]:
> >
> >    1. Stop routing SYN packets to the listener by eBPF.
> >    2. Wait for all timers to expire to complete requests
> >    3. Accept connections until EAGAIN, then close the listener.
> >
> >    or
> >
> >    1. Start counting SYN packets and accept syscalls using the eBPF map.
> >    2. Stop routing SYN packets.
> >    3. Accept connections up to the count, then close the listener.
> >
> > In either way, we cannot close a listener immediately. However, ideally,
> > the application need not drain the not yet accepted sockets because 3WHS
> > and tying a connection to a listener are just the kernel behaviour. The
> > root cause is within the kernel, so the issue should be addressed in kernel
> > space and should not be visible to user space. This patchset fixes it so
> > that users need not take care of kernel implementation and connection
> > draining. With this patchset, the kernel redistributes requests and
> > connections from a listener to the others in the same reuseport group
> > at/after close or shutdown syscalls.
> >
> > Although some software does connection draining, there are still merits in
> > migration. For some security reasons, such as replacing TLS certificates,
> > we may want to apply new settings as soon as possible and/or we may not be
> > able to wait for connection draining. The sockets in the accept queue have
> > not started application sessions yet. So, if we do not drain such sockets,
> > they can be handled by the newer listeners and could have a longer
> > lifetime. It is difficult to drain all connections in every case, but we
> > can decrease such aborted connections by migration. In that sense,
> > migration is always better than draining.
> >
> > Moreover, auto-migration simplifies user space logic and also works well in
> > a case where we cannot modify and build a server program to implement the
> > workaround.
> >
> > Note that the source and destination listeners MUST have the same settings
> > at the socket API level; otherwise, applications may face inconsistency and
> > cause errors. In such a case, we have to use the eBPF program to select a
> > specific listener or to cancel migration.
This looks to be a useful feature. What happens to migrating a
passively fast-opened socket in the old listener but it has not yet
been accepted (TFO is both a mini-socket and a full-socket)?
It gets tricky when the old and new listener have different TFO key


> >
> > Special thanks to Martin KaFai Lau for bouncing ideas and exchanging code
> > snippets along the way.
> >
> >
> > Link:
> >   [1] The SO_REUSEPORT socket option
> >   https://lwn.net/Articles/542629/
> >
> >   [2] Re: [PATCH 1/1] net: Add SO_REUSEPORT_LISTEN_OFF socket option as drain mode
> >   https://lore.kernel.org/netdev/1458828813.10868.65.camel@edumazet-glaptop3.roam.corp.google.com/
>
> This series needs review/ACKs from TCP maintainers. Eric/Neal/Yuchung please take
> a look again.
>
> Thanks,
> Daniel

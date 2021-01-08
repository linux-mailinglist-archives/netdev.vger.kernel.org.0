Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139EE2EF751
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbhAHS1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728357AbhAHS1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:27:32 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B63C061380
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:26:52 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id d14so9238095qkc.13
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RhodXJ2Tzggqg1iwXnQ8qWubkJW7CK1VhA1r788tzrY=;
        b=W3m3xiliKeceK1q6ziHe/t0vuB0ezE1CtD9M5jKhPpTjmagOcjl6tLDHTMDBcmMSJk
         2RCf/1dC0IkUIPp5bFvJlAKOOaaBS3FCKYvkX2i5X0/HG8nNssILdJxXxBnDbVA73JxE
         Bd3+gcV6BXQzVG1K45oJ8iemDm4iRiOFwlN0smMY2nNbswNDDliT0bseRiuox/Fp4Rx9
         H5aSJeyoFsof9DUw0qIlR56FBs06F3yhyIGUWzFKcC8Xl/m8XxV0yosQI1rXFHVrvkhD
         jQvcnC3yA04+MZsmEPHAhl9AQY79A2ueiWer1+Pw/Felyd8G1V7VmoUYzK5LXeAId5ug
         3G4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RhodXJ2Tzggqg1iwXnQ8qWubkJW7CK1VhA1r788tzrY=;
        b=SwbquwJQRFRZxQm9fzu/z+fjrsX8OBsPYlzWVRTUMK0y9WouiMYScfsCf01ClR+AxX
         b360RpxlTU5oG25p1ulhZ6UPoTWrfac5ITYukmyjJoQMjB/W9E3KdpG+n6n/OIzvsJZH
         zX8tiyQ/DtDd/Dr0zExT1fn56wvKcF6JpW1/HxYyQZtWlolXOMUWqpPTFEWXnaZsUx9R
         6cjVpxnkMLMGOhZ01b3u+ifeUNJE16+bEtDSp5vegtj2ZDGgEUaQWkGebTrMlwCsSYuU
         T4GGmjc8s1Kx5fqNCcLiHwE2xmTLIDd31g5ykVjGNtXwlJCE4QGmB1/XKu6rS0BuTY8d
         ogTw==
X-Gm-Message-State: AOAM532uPO5DtosLsGzhx2UgrkIfLlDl79fCB3V4HbyAr+w+lPDJzOyX
        w3w746nt5fNH2koJfY/GWW9HO9EhpKQMJjh/A7pSBQ==
X-Google-Smtp-Source: ABdhPJxLs8Lwrszh07st7GVzpvmLxoDPn1PQcrYPWBACQitdJ6MtWwRbmvrphhgyK40cyTkywz8baS9ox14P3NzNV3w=
X-Received: by 2002:a37:a80a:: with SMTP id r10mr5306897qke.448.1610130411431;
 Fri, 08 Jan 2021 10:26:51 -0800 (PST)
MIME-Version: 1.0
References: <20210108180333.180906-1-sdf@google.com> <20210108180333.180906-2-sdf@google.com>
 <CANn89i+GvEUmoapF+C0Mf1qw+AuWhU5_MMPz-jy8fND0HmUJ=Q@mail.gmail.com>
In-Reply-To: <CANn89i+GvEUmoapF+C0Mf1qw+AuWhU5_MMPz-jy8fND0HmUJ=Q@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 8 Jan 2021 10:26:40 -0800
Message-ID: <CAKH8qBsWsKVxAyvhEYqXytTFMGEN=C3ZMKBPLs2RKcEpM4hXXQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 10:10 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Jan 8, 2021 at 7:03 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> > We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> > call in do_tcp_getsockopt using the on-stack data. This removes
> > 3% overhead for locking/unlocking the socket.
> >
> > Without this patch:
> >      3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
> >             |
> >              --3.30%--__cgroup_bpf_run_filter_getsockopt
> >                        |
> >                         --0.81%--__kmalloc
> >
> > With the patch applied:
> >      0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
> >
>
>
> OK but we are adding yet another indirect call.
>
> Can you add a patch on top of it adding INDIRECT_CALL_INET() avoidance ?
Sure, but do you think it will bring any benefit?
We don't have any indirect avoidance in __sys_getsockopt for the
sock->ops->getsockopt() call.
If we add it for this new bpf_bypass_getsockopt, we might as well add
it for sock->ops->getsockopt?
And we need some new INDIRECT_CALL_INET2 such that f2 doesn't get
disabled when ipv6 is disabled :-/

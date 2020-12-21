Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3D72E027E
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 23:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgLUW0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 17:26:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgLUW0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 17:26:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B555A22B51;
        Mon, 21 Dec 2020 22:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608589564;
        bh=j7oP1p+v4onbs15YBpeQ6Z26fIi6i3Bkj7pl6ROeWAs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ppH74T2NWi/PJjn6kotU8Gx5PscTPQsPlHlPBy3DkY7xXGF21Qbz9V0zESOoloxWy
         JmNboHmllCbZ1K1PJxaRAJ5MMVHV8N5IeQhqxl3X1DgzLvAt8o62hlzcDEeu1rNR/g
         pGRegGjgPE8fvQnA7BYUSZjcS82MQpPtTcfToQSCE8ZK75fCMCvIxoyyUefpdip0eM
         31FY2kvVx1I7cZNj/osNrrDwDC4NHqHKQ16id5yy4GwipjBSwZn5LRR+ulLHs/o6s9
         yFIOe4frBaDoqTAwE5549/vhR6UvcR4j6vwHWur9hn2UZQv5/71syk1f39XcQMhB3E
         GaQhAfF8xX5NA==
Received: by mail-lf1-f48.google.com with SMTP id h205so27403428lfd.5;
        Mon, 21 Dec 2020 14:26:03 -0800 (PST)
X-Gm-Message-State: AOAM5337vLB1zG5pFTXAHBn9ruF5EbuUST/ibdsK+aS8snGcWl+Rg9A8
        1gvQz3N5nQjn2gFKvurwJrbb+xn5mdizoEynP3E=
X-Google-Smtp-Source: ABdhPJytQqW0AG+oIF241EtENmmd2ta/kg9Co5TKnuQso5tgQtFGH5GzTcTuwKLAT0LbtAAl5sBmVa+TWHsRDDS+gD0=
X-Received: by 2002:a19:650:: with SMTP id 77mr7818787lfg.160.1608589561972;
 Mon, 21 Dec 2020 14:26:01 -0800 (PST)
MIME-Version: 1.0
References: <20201217172324.2121488-1-sdf@google.com> <20201217172324.2121488-2-sdf@google.com>
In-Reply-To: <20201217172324.2121488-2-sdf@google.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 21 Dec 2020 14:25:50 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6KPF6J9Q6P-g6LQGBjwP_cGdM+VPGgYfOZ8pTkwShqaQ@mail.gmail.com>
Message-ID: <CAPhsuW6KPF6J9Q6P-g6LQGBjwP_cGdM+VPGgYfOZ8pTkwShqaQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 9:24 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> When we attach a bpf program to cgroup/getsockopt any other getsockopt()
> syscall starts incurring kzalloc/kfree cost. While, in general, it's
> not an issue, sometimes it is, like in the case of TCP_ZEROCOPY_RECEIVE.
> TCP_ZEROCOPY_RECEIVE (ab)uses getsockopt system call to implement
> fastpath for incoming TCP, we don't want to have extra allocations in
> there.
>
> Let add a small buffer on the stack and use it for small (majority)
> {s,g}etsockopt values. I've started with 128 bytes to cover
> the options we care about (TCP_ZEROCOPY_RECEIVE which is 32 bytes
> currently, with some planned extension to 64 + some headroom
> for the future).
>
> It seems natural to do the same for setsockopt, but it's a bit more
> involved when the BPF program modifies the data (where we have to
> kmalloc). The assumption is that for the majority of setsockopt
> calls (which are doing pure BPF options or apply policy) this
> will bring some benefit as well.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Could you please share some performance numbers for this optimization?

Thanks,
Song

[...]

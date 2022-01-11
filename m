Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64B248B9DD
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245489AbiAKVsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:48:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36310 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244246AbiAKVsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:48:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C743B81D53;
        Tue, 11 Jan 2022 21:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3BFC36AE3;
        Tue, 11 Jan 2022 21:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641937681;
        bh=XrspnSNs6JMcU506ytCNURqiXm67siFy7Nm7GjS5lco=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hWrD0dG+l8QEpUvGU34nHGNsv4n8buFfcY3Q8bidfE7Q0xLQWB4REvLosdckHJrOJ
         XuoZhJFMr/imlnCzi8ikhF01f+peUaELYjU0yXytR1p0qQbqdaNbBToQ3DrsdisfvY
         1X2+4VMuHhaZ9/YlJEymezhfemEpaygaTnPGVYvlauT0rkQbISfWYdOqWaygowtmSz
         LGn50ql+Dr4JWRkH9LzPnC9azw07I048ES12y4zS7VzgTcc4u/nFfJw3C0pEpZzYmp
         mOY2ieaXdWn0fwUMdrYu9YM8MWt1E9eV2LPmPhSfYUXoCRtp/dYd1BZiO9Jdv0aae3
         /6ImMn3ncAj3w==
Received: by mail-yb1-f181.google.com with SMTP id h14so802931ybe.12;
        Tue, 11 Jan 2022 13:48:00 -0800 (PST)
X-Gm-Message-State: AOAM53330I9CIQ+gN0unx8WlQqPHxYzWqtNiH6kzMnpWl4xf+jwujLHm
        KHyzWIS/EJ6jk/HyT7KnlcRP+I8/K5qfmof7Q28=
X-Google-Smtp-Source: ABdhPJzL1cm6751qAuD8ankKZgSL6Brsge2gkX/u/jiwdYH43yPfjJsCzldUqYgjc/qL7CPIDrXWfsmfF3WjNcQvfvc=
X-Received: by 2002:a25:c097:: with SMTP id c145mr9050186ybf.282.1641937680223;
 Tue, 11 Jan 2022 13:48:00 -0800 (PST)
MIME-Version: 1.0
References: <20220111192952.49040-1-ivan@cloudflare.com>
In-Reply-To: <20220111192952.49040-1-ivan@cloudflare.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 11 Jan 2022 13:47:49 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5ynK+XZkUm2jDE2LcpMbqPcQJDJHmFyU_WbBQyBKN38g@mail.gmail.com>
Message-ID: <CAPhsuW5ynK+XZkUm2jDE2LcpMbqPcQJDJHmFyU_WbBQyBKN38g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tcp: bpf: Add TCP_BPF_RCV_SSTHRESH for bpf_setsockopt
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 11:29 AM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> This patch adds bpf_setsockopt(TCP_BPF_RCV_SSTHRESH) to allow setting
> rcv_ssthresh value for TCP connections. Combined with increased
> window_clamp via tcp_rmem[1], it allows to advertise initial scaled
> TCP window larger than 64k. This is useful for high BDP connections,
> where it allows to push data with fewer roundtrips, reducing latency.
>
> For active connections the larger window is advertised in the first
> non-SYN ACK packet as the part of the 3 way handshake.
>
> For passive connections the larger window is advertised whenever
> there's any packet to send after the 3 way handshake.
>
> See: https://lkml.org/lkml/2021/12/22/652

I guess this is [1] mentioned above. Please use lore link instead, e.g.

[1] https://lore.kernel.org/all/CABWYdi0qBQ57OHt4ZbRxMtdSzhubzkPaPKkYzdNfu4+cgPyXCA@mail.gmail.com/

Can we add a selftests for this? Something similar to

tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c

Thanks,
Song

[...]

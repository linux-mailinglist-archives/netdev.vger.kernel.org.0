Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD75487CD7
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 20:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiAGTMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 14:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiAGTMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 14:12:41 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EEFC061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 11:12:41 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id p5so12177772ybd.13
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 11:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Wo2DwHjmANoYVJG9zhDU4pM7xd1beKmSBIi/XVzdAQ=;
        b=BnWN1dBHBykRczyfCAifeyGj+wkKvBlsG+u3uJ96TD/MGhL44cGhoV9WVOVMQSk1Bi
         SLOb9kDCzof1pt+6IWKoB8/AcPTZB4OYaEYCYQSQyqUZnhGKyzbT4jM8vQyb54IJc6j1
         cYVRH3yCr/YXwTWbYMF96on+He2/g2kGqr1fdiOaof96hfDxwjn8EvjShvZVM7H/Dede
         GoaK/gPdy78A327D/HxyC3/ixSHVmm6EOw+bfyrrd/jVaiD97baC1ioGW3ZKKGEYdKbo
         is61Pw5CdjBQEOKk/tbASzRuHOVBa8BFy9z8YQcSI505vRNhUh5MIipj1prlsihsyiC8
         EIQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Wo2DwHjmANoYVJG9zhDU4pM7xd1beKmSBIi/XVzdAQ=;
        b=VIGFqr/ZvGyBoad0OXmpIhMimqBSV1vqp1BY50ts70bg2zA9s/Cw2H7awvYGm4uqYk
         SEqAlyCBELP3d5QAOTD/8/DA7jc6YPI1n8hjcY4YODxrjxKhltbLsu/O7rVwmYYgPRSt
         pAjh2DAVT+qsNAp0eveOF79DQGPdesWTp3a9mrcUPB9y0lSc50765H8jwU37xMBex57Q
         LgsVihozr0L/lLCf6IiNo+YWIg8RgBEXQ8hAABTn6TZzWaXIh1rfI8ZqpOTmK9Dot66j
         dGjT9f1/4bXy3S40N78un26yj28yq+n+IDFYNxqgmXnBKTct/I8EXhnyNTLGSkhYWyPo
         ERlA==
X-Gm-Message-State: AOAM531NLET9F+Yyns7MWaQobYJPCRptjbjqXqqMWzWCKWWMKfGMIPHR
        M3eVzSAbSTUMZA9H8SwQIgQgvkLOCg/nQlj5yDrsOPhXuBkuUA==
X-Google-Smtp-Source: ABdhPJypI+/wnUnLt/TeTTSG+fCBtc6NHJF/j1ex8aFdcmL4b9HvJ3ZmelZFqRKbH+ZGQSi7akeR7bnrXMJZuLo0gc0=
X-Received: by 2002:a25:d195:: with SMTP id i143mr71067900ybg.711.1641582760106;
 Fri, 07 Jan 2022 11:12:40 -0800 (PST)
MIME-Version: 1.0
References: <20220102081253.9123-1-gal@nvidia.com> <20220107105106.680cd28f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220107105106.680cd28f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 7 Jan 2022 11:12:28 -0800
Message-ID: <CANn89iJqgJjpFEaYPLuVAAzwwC_y3O6se2pChj40=zTAyWN=6w@mail.gmail.com>
Subject: Re: [RFC PATCH] net/tls: Fix skb memory leak when running kTLS traffic
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 10:51 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 2 Jan 2022 10:12:53 +0200 Gal Pressman wrote:
> > The cited Fixes commit introduced a memory leak when running kTLS
> > traffic (with/without hardware offloads).
> > I'm running nginx on the server side and wrk on the client side and get
> > the following:
> >
> >   unreferenced object 0xffff8881935e9b80 (size 224):
> >   comm "softirq", pid 0, jiffies 4294903611 (age 43.204s)
> >   hex dump (first 32 bytes):
> >     80 9b d0 36 81 88 ff ff 00 00 00 00 00 00 00 00  ...6............
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<00000000efe2a999>] build_skb+0x1f/0x170
> >     [<00000000ef521785>] mlx5e_skb_from_cqe_mpwrq_linear+0x2bc/0x610 [mlx5_core]
> >     [<00000000945d0ffe>] mlx5e_handle_rx_cqe_mpwrq+0x264/0x9e0 [mlx5_core]
> >     [<00000000cb675b06>] mlx5e_poll_rx_cq+0x3ad/0x17a0 [mlx5_core]
> >     [<0000000018aac6a9>] mlx5e_napi_poll+0x28c/0x1b60 [mlx5_core]
> >     [<000000001f3369d1>] __napi_poll+0x9f/0x560
> >     [<00000000cfa11f72>] net_rx_action+0x357/0xa60
> >     [<000000008653b8d7>] __do_softirq+0x282/0x94e
> >     [<00000000644923c6>] __irq_exit_rcu+0x11f/0x170
> >     [<00000000d4085f8f>] irq_exit_rcu+0xa/0x20
> >     [<00000000d412fef4>] common_interrupt+0x7d/0xa0
> >     [<00000000bfb0cebc>] asm_common_interrupt+0x1e/0x40
> >     [<00000000d80d0890>] default_idle+0x53/0x70
> >     [<00000000f2b9780e>] default_idle_call+0x8c/0xd0
> >     [<00000000c7659e15>] do_idle+0x394/0x450
> >
> > I'm not familiar with these areas of the code, but I've added this
> > sk_defer_free_flush() to tls_sw_recvmsg() based on a hunch and it
> > resolved the issue.
> >
> > Eric, do you think this is the correct fix? Maybe we're missing a call
> > to sk_defer_free_flush() in other places as well?
>
> Any thoughts, Eric? Since the merge window is coming soon should
> we purge the defer free queue when socket is destroyed at least?
> All the .read_sock callers will otherwise risk the leaks, it seems.

It seems I missed this patch.

We might merge it, and eventually add another

WARN_ON_ONCE(!llist_empty(sk->defer_list))
sk_defer_free_flush(sk);

at socket destroy as you suggested ?

Reviewed-by: Eric Dumazet <edumazet@google.com>

>
> > Fixes: f35f821935d8 ("tcp: defer skb freeing after socket lock is released")
> > Signed-off-by: Gal Pressman <gal@nvidia.com>
> > ---
> >  net/tls/tls_sw.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> > index 3f271e29812f..95e774f1b91f 100644
> > --- a/net/tls/tls_sw.c
> > +++ b/net/tls/tls_sw.c
> > @@ -1990,6 +1990,7 @@ int tls_sw_recvmsg(struct sock *sk,
> >
> >  end:
> >       release_sock(sk);
> > +     sk_defer_free_flush(sk);
> >       if (psock)
> >               sk_psock_put(sk, psock);
> >       return copied ? : err;
>

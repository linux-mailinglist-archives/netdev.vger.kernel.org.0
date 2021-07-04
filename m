Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981F73BAEA2
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhGDT4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhGDT4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 15:56:30 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE80C061574;
        Sun,  4 Jul 2021 12:53:53 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h1-20020a17090a3d01b0290172d33bb8bcso921129pjc.0;
        Sun, 04 Jul 2021 12:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sKEQiSSfLXdLhV4kE48qS2B58wxDqK9svhuMqm9hVhg=;
        b=LLDFTd57J2KFVVhaJUWqowH+lbs+Cll4BU0REzKX7kp9azxgnHZJMaNugdeN94hYne
         EdDt0WyS0ond/ZNmxCAmNNkSJnc77RNf5kFoZRe+h9X8mpEKtYpv1FEiajNjclGfCeS/
         kVvzTc4en+ayuUKFvB0FyPnPVFop0bkFwfwisnMIl9gAqVx1kPpKlLyb+tMxapadh9o3
         83NurNqpytJNJDXWYSzRMlcjho7fGZXH84vSwUGwXM7/xnfin0DgwAG8AkGSEOccuSUq
         9plpXFu/CzZGFxv1/5quByFtXasPY1bJgkATIL4u6LewBWN/LhtD7B7MnSNcJsJST2/S
         nPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sKEQiSSfLXdLhV4kE48qS2B58wxDqK9svhuMqm9hVhg=;
        b=KMbxAUUjWwcg2IWsoZGvODICo0vsorTQqkcnzPRSlg7qumwfsCwcTWePvw8YN6uJ+G
         DYkKgb9U2EwA6kFzljVDbNR02uDVQe4oy7wBWyWaKH+e0cDoM7HddRBvdBvGNm921/ZZ
         6KxRsIrN9upZxZTCRlTgqg4hU9mOqYYVPLLT3eL02JiDjk2sUU8wWBVCWICGJEG2t5pR
         w4AfyoalhB/bzqcFb7F0Gqr9Jq14pb9/l2sK3SzEWAzRqcZIaiNGxuJqB3qNM29r7Ek+
         0sSmg5qAqKuMoN2kkDWowxZw1jPzejsdejAw2xoJ5GpXHaodfm3BmqJV7DaaXtz+qMXS
         zwEg==
X-Gm-Message-State: AOAM533icQ89SHNJL6R1I6wvC29h3fUppQc/DVY5Dc4QLsAjbg9AV/4l
        DCrz2W976Y39dZ9wdmPEPL9uacOWG0Oi9EuXyjc=
X-Google-Smtp-Source: ABdhPJwTjwXCS26Z3l4kjK7U9nSI04aG0PYcUYWrVYewkDkaNtPE/LAhnzzKlmXBSg00AfgENIQ7m1jco8X6cFRSM10=
X-Received: by 2002:a17:902:a615:b029:126:351c:e6bf with SMTP id
 u21-20020a170902a615b0290126351ce6bfmr9329718plq.70.1625428432916; Sun, 04
 Jul 2021 12:53:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210701061656.34150-1-xiyou.wangcong@gmail.com>
 <60ddec01c651b_3fe24208dc@john-XPS-13-9370.notmuch> <875yxrs2sc.fsf@cloudflare.com>
In-Reply-To: <875yxrs2sc.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 4 Jul 2021 12:53:41 -0700
Message-ID: <CAM_iQpW69PGfp_Y8mZoqznwCk2axask5qJLB7ntZjFgGO+Eizg@mail.gmail.com>
Subject: Re: [Patch bpf v2] skmsg: check sk_rcvbuf limit before queuing to ingress_skb
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 3, 2021 at 10:52 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> When running with just the verdict prog attached, the -EIO error from
> sk_psock_verdict_apply is propagated up to tcp_read_sock. That is, it
> maps to 0 bytes used by recv_actor. sk_psock_verdict_recv in this case.
>
> tcp_read_sock, if 0 bytes were used = copied, won't sk_eat_skb. It stays
> on sk_receive_queue.

Are you sure?

When recv_actor() returns 0, the while loop breaks:

1661                         used = recv_actor(desc, skb, offset, len);
1662                         if (used <= 0) {
1663                                 if (!copied)
1664                                         copied = used;
1665                                 break;

then it calls sk_eat_skb() a few lines after the loop:
...
1690                 sk_eat_skb(sk, skb);

>
>   sk->sk_data_ready
>     sk_psock_verdict_data_ready
>       ->read_sock(..., sk_psock_verdict_recv)
>         tcp_read_sock (used = copied = 0)
>           sk_psock_verdict_recv -> ret = 0
>             sk_psock_verdict_apply -> -EIO
>               sk_psock_skb_redirect -> -EIO
>
> However, I think this gets us stuck. What if no more data gets queued,
> and sk_data_ready doesn't get called again?

I think it is dropped by sk_eat_skb() in TCP case and of course the
sender will retransmit it after detecting this loss. So from this point of
view, there is no difference between drops due to overlimit and drops
due to eBPF program policy.

Thanks.

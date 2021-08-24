Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BAB3F6176
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 17:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbhHXPXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 11:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238130AbhHXPXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 11:23:08 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A726BC061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 08:22:23 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id z18so41766689ybg.8
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 08:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fwrh7Ma93YqHeODSroVO5xFqEdFE+DoKS8enYFO4wgY=;
        b=ZRdVwHBOwg6wZSSKlvs22KmEcuWScMAwPAoS5LMwClAjyr4iO3gGTdZLw6l0uIFj03
         lFX1xo3zeQypiJZFHkrtaKfNMmFfOjhKNYq+l03uUaaFzbbp20woXQslQHD5Ol0C0COj
         J9hFt4pYV+jvX8AWMHiyvTLcXYX55FyG8+8Aa/ObtDDb1rhPz4eIOfQ0hvB0K9kafkLC
         eNMqnXUKWeeMlzBNc6lxyJV8bk+Sn6Q2vnksFn5UfK+GAejcZWciOUXsVFytYOhF0zIU
         5nWdPM4zTSlGnoOcBV/RUP2M6x+bNx8D2rpZj8xjTxVbvWLmYDNEO/QhBvBx9S1h/VQh
         FF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fwrh7Ma93YqHeODSroVO5xFqEdFE+DoKS8enYFO4wgY=;
        b=dToCSUWVXy3oeNHM7Jkb4npsiYw8jhFBcxxmPjf3+h8ipf4WPRrT90qBPw17yA+NAy
         WwwC+TPuQJQ4FvDXJjL/pX7h8CG+9298dFoU4y4ofZnggwNUYrCzCbXzvRqsXIIPzgbK
         xUVtxf5/XgZTIdjoACOqzxvB+GZ1SbX+JlK0M1kJSUQ6m6cVLNpgIKEIHlKEXL39ZWZO
         ItJsq0F+d6EaxPNzbGQbgEm9defZbTLqEloGIOSQY9Inv2pVXWm2fiEJlU2oiTftOE6b
         eUJK/vzIM+ELw7xUMS4Mta5QKS7bQ+0tpvINV9a5gHbDpbctot0flEkIrEaIptGJ3fkQ
         /hPQ==
X-Gm-Message-State: AOAM533pE5TKf1JizAsGHdfwgxxMwTLotbClRTRDR2Hv1DE721R5kVWa
        auiehMYCIfuG64vKoGhTDsHVO3Vr+WU5CWeMga+oQw==
X-Google-Smtp-Source: ABdhPJwEbBpvie3B4unGZj+uzJP7Web1EazlNgqQrk0+cD8irKHliF49e5a6ZnaalofzvcmxwMqwm13ud7ZaBo3/Gbk=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr49822032ybj.504.1629818542211;
 Tue, 24 Aug 2021 08:22:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210824125140.190253-1-yan2228598786@gmail.com>
In-Reply-To: <20210824125140.190253-1-yan2228598786@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 24 Aug 2021 08:22:11 -0700
Message-ID: <CANn89i+-EnK-zZ_kXsVAW_Or+8w3V3F4orbt40GFP2zQrr6gvw@mail.gmail.com>
Subject: Re: [PATCH] net: tcp_drop adds `reason` parameter for tracing
To:     Zhongya Yan <yan2228598786@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 5:52 AM Zhongya Yan <yan2228598786@gmail.com> wrote:
>
> When using `tcp_drop(struct sock *sk, struct sk_buff *skb)` we can
> not tell why we need to delete `skb`. To solve this problem I updated the
> method `tcp_drop(struct sock *sk, struct sk_buff *skb, enum tcp_drop_reason reason)`
> to include the source of the deletion when it is done, so you can
> get an idea of the reason for the deletion based on the source.
>
> The current purpose is mainly derived from the suggestions
> of `Yonghong Song` and `brendangregg`:
>
> https://github.com/iovisor/bcc/issues/3533.
>
> "It is worthwhile to mention the context/why we want to this
> tracepoint with bcc issue https://github.com/iovisor/bcc/issues/3533.
> Mainly two reasons: (1). tcp_drop is a tiny function which
> may easily get inlined, a tracepoint is more stable, and (2).
> tcp_drop does not provide enough information on why it is dropped.
> " by Yonghong Song
>
> Signed-off-by: Zhongya Yan <yan2228598786@gmail.com>
> ---

That is a good start, but really if people want to use this
tracepoint, they will hit a wall soon.


>         return true;
>
>  discard:

There are many " goto discards;" in this function, so using a common
value ("TCP_VALIDATE_INCOMING" ) is not helpful.


> -       tcp_drop(sk, skb);
> +       tcp_drop(sk, skb, TCP_VALIDATE_INCOMING);
>         return false;
>  }
>
> @@ -5905,7 +5915,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
>         TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
>
>  discard:
> -       tcp_drop(sk, skb);

Same here.

> +       tcp_drop(sk, skb, TCP_RCV_ESTABLISHED);
>  }
>  EXPORT_SYMBOL(tcp_rcv_established);
>
> @@ -6196,7 +6206,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
>                                                   TCP_DELACK_MAX, TCP_RTO_MAX);
>
>  discard:
> -                       tcp_drop(sk, skb);
> +                       tcp_drop(sk, skb, TCP_RCV_SYNSENT_STATE_PROCESS);
>                         return 0;
>                 } else {
>                         tcp_send_ack(sk);
> @@ -6568,7 +6578,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
>
>         if (!queued) {
>  discard:

same here.

> -               tcp_drop(sk, skb);
> +               tcp_drop(sk, skb, TCP_RCV_STATE_PROCESS);
>         }
>         return 0;
>  }
> --
> 2.25.1
>

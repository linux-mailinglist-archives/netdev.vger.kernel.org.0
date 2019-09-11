Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D72CAF3D0
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 03:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfIKA4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 20:56:05 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39608 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfIKA4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 20:56:05 -0400
Received: by mail-oi1-f194.google.com with SMTP id w144so12765179oia.6
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 17:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ORq86QBYuiUUHS/gEPslReQwFhDRKj2SeKBLnZpq064=;
        b=CddlLMlL82rz/z6D2TILPM+fzch72BKiAeUp075lFtkXeI/ExfwsinQzsukrL5fCk7
         G4hfUPI5OaowDWlZ+b0A/Wc9ClpMocRhl6pN5wTF3Bh/40YnNHam9BmQQKh9MUtrmFXn
         1Xy/xpf0/3bN6++ZpDoLIscaMItGG5SIo9CmFnKccr/mdODJb9gUtPBmDhCnQRc/BZzm
         oKW7gCB1gK83E09v3sUMVuxFaROBCgZH7Kzu1has7dJdysZXc4aqGPfhYpxPkMUpOe4q
         2vOHvllSnxYWX8RheB5uGSJtkcRHfD9JH/tQzTo+/4MzOG86iX55ck6voFiyLgNPWx11
         At3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ORq86QBYuiUUHS/gEPslReQwFhDRKj2SeKBLnZpq064=;
        b=toAzjbXVSonTLGpuQsccUXa2dNrE3aYSh3AIki6rwkB3VHeupW+t8JUKtONifCDSv/
         4yVdG/uS68leERqsGMmoeS+Iy8LlolaEsNzo/hjyJSTTT1SQo+T681n4anUm10eUDJga
         IFjFVxN5hHCAxlslZTpuOpkGyODRI0VXfZYkA2bGmC8ul738EWBvo4bIPPuNPd/X8Pkl
         4uKXd9GE43HNuX+ZqBYWt+6dNiqga9pn2iUoSYfJMUEZWa4M1JEqhg6mQf8h01NCQGPb
         vY36HDpNl4tjWUlSQPq1Ksd446322t5SZEa2zWQe3yiLCGuPmPYf6PhblbqLqZYRGAQb
         osmg==
X-Gm-Message-State: APjAAAW75uTZ64vUuIOT2iZw7djNvDmgYkrOR4DDNqqVVZqsUlAt5/IK
        PshtOMevJdeesQzAKI2bsOUz6EjpaVFblo5NckXkC/zDXdKRQg==
X-Google-Smtp-Source: APXvYqx2g25Vvv8Wf5OfozUDbbFAZrkYyZJ+TiM1HIhIZv284g80Q+bV8xjnOWUrStcRi5iqtnIyTcnR9u8NSQAgApc=
X-Received: by 2002:aca:782:: with SMTP id 124mr2042704oih.95.1568163363708;
 Tue, 10 Sep 2019 17:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190910214928.220727-1-edumazet@google.com>
In-Reply-To: <20190910214928.220727-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Tue, 10 Sep 2019 20:55:47 -0400
Message-ID: <CADVnQy=umLQzLWo3=ErOsDUHnoOzkg2Wf3SQnGNSfYE_f+rJFQ@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: force a PSH flag on TSO packets
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tariq Toukan <tariqt@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 5:49 PM Eric Dumazet <edumazet@google.com> wrote:
>
> When tcp sends a TSO packet, adding a PSH flag on it
> reduces the sojourn time of GRO packet in GRO receivers.
>
> This is particularly the case under pressure, since RX queues
> receive packets for many concurrent flows.
>
> A sender can give a hint to GRO engines when it is
> appropriate to flush a super-packet, especially when pacing
> is in the picture, since next packet is probably delayed by
> one ms.
>
> Having less packets in GRO engine reduces chance
> of LRU eviction or inflated RTT, and reduces GRO cost.
>
> We found recently that we must not set the PSH flag on
> individual full-size MSS segments [1] :
>
>  Under pressure (CWR state), we better let the packet sit
>  for a small delay (depending on NAPI logic) so that the
>  ACK packet is delayed, and thus next packet we send is
>  also delayed a bit. Eventually the bottleneck queue can
>  be drained. DCTCP flows with CWND=1 have demonstrated
>  the issue.
>
> This patch allows to slowdown the aggregate traffic without
> involving high resolution timers on senders and/or
> receivers.
>
> It has been used at Google for about four years,
> and has been discussed at various networking conferences.
>
> [1] segments smaller than MSS already have PSH flag set
>     by tcp_sendmsg() / tcp_mark_push(), unless MSG_MORE
>     has been requested by the user.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Tariq Toukan <tariqt@mellanox.com>
> ---
>  net/ipv4/tcp_output.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 42abc9bd687a5fea627cbc7cfa750d022f393d84..fec6d67bfd146dc78f0f25173fd71b8b8cc752fe 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1050,11 +1050,22 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
>         tcb = TCP_SKB_CB(skb);
>         memset(&opts, 0, sizeof(opts));
>
> -       if (unlikely(tcb->tcp_flags & TCPHDR_SYN))
> +       if (unlikely(tcb->tcp_flags & TCPHDR_SYN)) {
>                 tcp_options_size = tcp_syn_options(sk, skb, &opts, &md5);
> -       else
> +       } else {
>                 tcp_options_size = tcp_established_options(sk, skb, &opts,
>                                                            &md5);
> +               /* Force a PSH flag on all (GSO) packets to expedite GRO flush
> +                * at receiver : This slightly improve GRO performance.
> +                * Note that we do not force the PSH flag for non GSO packets,
> +                * because they might be sent under high congestion events,
> +                * and in this case it is better to delay the delivery of 1-MSS
> +                * packets and thus the corresponding ACK packet that would
> +                * release the following packet.
> +                */
> +               if (tcp_skb_pcount(skb) > 1)
> +                       tcb->tcp_flags |= TCPHDR_PSH;
> +       }
>         tcp_header_size = tcp_options_size + sizeof(struct tcphdr);
>
>         /* if no packet is in qdisc/device queue, then allow XPS to select

Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks, Eric!

neal

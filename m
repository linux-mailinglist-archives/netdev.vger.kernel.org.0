Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922C5AF2B7
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 23:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfIJVxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 17:53:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56205 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfIJVxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 17:53:08 -0400
Received: by mail-wm1-f68.google.com with SMTP id g207so1141997wmg.5
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 14:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hJQAVTDTNlbFlLbQ29lfLmQ0QjIh5ldKKkqrYjoO1B8=;
        b=CoHTDlluv7zFJzCHaJ1tWxUlSd00DqIvTjC/n9FM4XalhBbsDuDfI0AgVjY++XKOmG
         EWhy2kCTukByXil5CY4g8vrt22+o7QHG97Uk0kFfVRjCdLDch7iS4pZrSfLvh41r7hbw
         5irniWV1H264XA0HiKp8DoVjfUPQ2LhRhHyf7CVDPEQ5LAIOa6hfcKebPB5SieuFA2sa
         j1HVAzbU7e4YA7ol6PycR/1cDjxJJ+8AhOulK7AxPa52ykcquJZOzQ3rUsDrUMaHNoXt
         dSjmkbjIdgw8Q4MpKORhAf/B8Op6J9ctVQ5OCVSrvOiRHrXnIDN6h3wvz6g5+DSfZ7BP
         /MtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hJQAVTDTNlbFlLbQ29lfLmQ0QjIh5ldKKkqrYjoO1B8=;
        b=JCM/J6ay/HM0+dcincuce6dKskewspPrjU2mMQTYs3Klg0Ik4RsDmU1a4Y0WfrJrXc
         mm/uq9RdT2f2VsiDV5P/EDVYQ7XDB1ew+HKnNhvgoz1bPZCf66+8GxnnS9uiw1udVY0K
         QYAc3I7BspsUts2OFUF6YVCAhHzTfULABuRhWtw0Cz3bcSTKA6oH1rpNz850t2HF889Y
         JlyBXR9k4c/j82tjtmWYpeKIFroAjaaR2Wa+OhCOe8fUr63dM1lKZYeuV4Y3BBZwnwJz
         Zwi2px82Kj9y3yw/91laG5MF5iZl9FCjODgC+W20OJb2aLt1NkvAxgRjjO5PE8YBJlSQ
         eXhA==
X-Gm-Message-State: APjAAAXZkq5ZRaoChOYuK5zYpG8IzqGxeNgP1O3CJ5YV5nc14eZ4zIPy
        S37QDEduoZtph5BDvZf1ZHOxdgUrcbVM/voOU/V4mN6NAnuoXw==
X-Google-Smtp-Source: APXvYqxf+Xeqix6SrZjysy/N1wuTaXLPzYTBYhX1dvIMaihGV3cWi8Giii2uJ/8zg8PkIIijViyiVqxJON0ikD9hUYI=
X-Received: by 2002:a1c:c90e:: with SMTP id f14mr1152467wmb.54.1568152386934;
 Tue, 10 Sep 2019 14:53:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190910214928.220727-1-edumazet@google.com>
In-Reply-To: <20190910214928.220727-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Tue, 10 Sep 2019 17:52:29 -0400
Message-ID: <CACSApvaSCtgTSPFv5W0nxURejprB4LFpTUMvjRkm=_SgLWpAxA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: force a PSH flag on TSO packets
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
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


Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Eric, thank you for the patch and the very nice commit message!

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
> --
> 2.23.0.162.g0b9fbb3734-goog
>

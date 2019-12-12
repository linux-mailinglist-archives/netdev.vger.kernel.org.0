Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2466E11D9B0
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 23:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbfLLWxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 17:53:33 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:47042 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731143AbfLLWxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 17:53:33 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so4501565wrl.13
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 14:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2qhLqPzVpI+musHWwGUe6bREqKpz0y5ZUiDt3qFvkR8=;
        b=Qx6poLrsAmcKqxcYgI8RgXDppc/iE7zYJiKav6IHiNwiHZZ7Qn/t7SGUNTAW/k6FiS
         wMs5woPJGJ658HM7moCMZMiXlLAq8YV29vmeMin5UhQnEtrHiqbjs0QSPjX7V5EKOnjv
         5NrR3CoABEU6wqJzKUumneewIhUeCVU9FBCZxBFgwpV7R4POR1W9bcKlfgzd2yHutrkN
         9Bsq6A5/Be+YyvDwnMrIsXmo3xNwQdktGZaI5TiNjLWHSwhiYcPKxMHaG0AeeBxT7FpC
         6XOojMJsQGwCDpXqkHw0AxccpcT+JJWa3d8peaYJyTQzkdhCZ0b2R0+Ga2Qy5//lNaCx
         7kLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2qhLqPzVpI+musHWwGUe6bREqKpz0y5ZUiDt3qFvkR8=;
        b=lDLVuKmv695kWpIF07nPNZO9MMYApwPHTYrww96joA58xTPWJYU7Z/cDNhM/16mLhe
         f5BfdbjOpMmWxMdbpv6V/pMpVYYqHmnhFnr/f6+Dk6cZwoZhVH+QxHxQHLQI0+PPfJjN
         ixFpfIRCoZ78yA7w8Akd2m+xm1Lo+2Jypy1grsdZtm8dyvDGVykS/kStsz022RcZ4gY9
         +6CCPOvXAIIddCZQRAWjaYPNnUbJUzUhERIu7cDAYkJx2Msdv/ZPyvClbTTWr8FKWqv4
         PH+xb48PSczV1A7T/eDhK87PV356YYBZHk3epK1eQ6aFUMQeDu5vekZI/7mCg9eds1uK
         5G6A==
X-Gm-Message-State: APjAAAXmqzCKTzmq9tDNmJ+ByE45RYeWiDlSR4SX5FQaGbLG3u/KfV3U
        sFv7D3IXqv5laZ9vAFsHCdo2WXShTeN3ToIaDnQMow==
X-Google-Smtp-Source: APXvYqwvF7B2aVS6xdLH+UfZvVrzCR+WEg9zHEFRAxl86dSAA4lbYOUg23YI238gg+aAth/kE1IEJzx2hVwikUolXXE=
X-Received: by 2002:adf:f1d0:: with SMTP id z16mr8598489wro.209.1576191209511;
 Thu, 12 Dec 2019 14:53:29 -0800 (PST)
MIME-Version: 1.0
References: <20191212205531.213908-1-edumazet@google.com> <20191212205531.213908-2-edumazet@google.com>
In-Reply-To: <20191212205531.213908-2-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 12 Dec 2019 17:52:51 -0500
Message-ID: <CACSApvYK9T-ghgq+WvyQAdMjeqeRr0Pz_wz0X2e4o+BvJX28_Q@mail.gmail.com>
Subject: Re: [PATCH net 1/3] tcp: do not send empty skb from tcp_write_xmit()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <cpaasch@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 3:55 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Backport of commit fdfc5c8594c2 ("tcp: remove empty skb from
> write queue in error cases") in linux-4.14 stable triggered
> various bugs. One of them has been fixed in commit ba2ddb43f270
> ("tcp: Don't dequeue SYN/FIN-segments from write-queue"), but
> we still have crashes in some occasions.
>
> Root-cause is that when tcp_sendmsg() has allocated a fresh
> skb and could not append a fragment before being blocked
> in sk_stream_wait_memory(), tcp_write_xmit() might be called
> and decide to send this fresh and empty skb.
>
> Sending an empty packet is not only silly, it might have caused
> many issues we had in the past with tp->packets_out being
> out of sync.
>
> Fixes: c65f7f00c587 ("[TCP]: Simplify SKB data portion allocation with NETIF_F_SG.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Christoph Paasch <cpaasch@apple.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Cc: Jason Baron <jbaron@akamai.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  net/ipv4/tcp_output.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index b184f03d743715ef4b2d166ceae651529be77953..57f434a8e41ffd6bc584cb4d9e87703491a378c1 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2438,6 +2438,14 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
>                 if (tcp_small_queue_check(sk, skb, 0))
>                         break;
>
> +               /* Argh, we hit an empty skb(), presumably a thread
> +                * is sleeping in sendmsg()/sk_stream_wait_memory().
> +                * We do not want to send a pure-ack packet and have
> +                * a strange looking rtx queue with empty packet(s).
> +                */
> +               if (TCP_SKB_CB(skb)->end_seq == TCP_SKB_CB(skb)->seq)
> +                       break;
> +
>                 if (unlikely(tcp_transmit_skb(sk, skb, 1, gfp)))
>                         break;
>
> --
> 2.24.1.735.g03f4e72817-goog
>

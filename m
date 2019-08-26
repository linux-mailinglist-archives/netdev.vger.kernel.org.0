Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D00B49D47C
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732805AbfHZQux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:50:53 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41360 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728560AbfHZQux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 12:50:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id j16so15987853wrr.8
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 09:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u5vDlaUZ1fFToL5B5bS/CLxeDnGanGIga5VNM+/b/s8=;
        b=IpzzEhxugffuVcs+o87xIEyU4XGHpCAg8mWBDkx31IPfKBR5kILcf/nFJZM3GfVXfA
         MVkkntrwUjGCtgMJmI+nsjhwYT6oztfNqkyS67+Fkjtu1ysHF787MJpQUzQMTlj794tV
         YVZct/D+av5oU6F6WzJzZt4dLWn2Foydn5cpu2Uvr4+EGgWJi++afGX9FlZM3oCEZVxB
         nPawFBbKDpqbkrPtTRICWzr9/j546ckb4GIJACKRIU+ZGBwoj7I7mEXMR8psVGJ+wCYs
         oCpuvgl1xMQZ+cU4clJntHfhiXYc6YP3FLKOq6jHjno5SZswWJ6ZHX8LCYqHSHtdRTYz
         63Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u5vDlaUZ1fFToL5B5bS/CLxeDnGanGIga5VNM+/b/s8=;
        b=MnTZdGDuwuntQe6NpRjF9Dx6+dO9c8N3op/qdWZublmrtp1e7wTf4S5TPlakGXiBmn
         AVFPXU4m2YJINRGOyA6gXkLyG3zZfZFI2Ibk/yyOsyVDty8Q9iLEhEYF7IvIybzaoQM0
         sN7hGqtdVciNJCKKA7f8iv71coNhECq9g8xmps5vFXLDhq/J0p9QYPugm51h/A6Ngz26
         Oe8N7MIRHylZRwsbkrxu3TO3p1SOeS7hau1qaRtNZI3iWYfWhRv7CqT0AXqF00UQ8ov1
         ksn3Yhqit0B5aCtsOmni3EsWLzZg7EVXdF5sWhp9v/bw2znPqDh7LKN10py5d5kqF1K2
         xl5A==
X-Gm-Message-State: APjAAAXCB4M8bnoAHX1RPOh13t32ySOl7E0iSrfbrtaimLXUiAltPvOH
        huHBhuiFE6sg61XIXypM87nhasHj7bcrK44mNMCOiw==
X-Google-Smtp-Source: APXvYqxFAWcwPERVteb29MzlGPsU91GBFWk6F6n1xLicSCm/LstNM3xEnBoLXsupZ6dllNPUBNMc6HWgWJ4+VH4N6g4=
X-Received: by 2002:a5d:5041:: with SMTP id h1mr25069233wrt.30.1566838250565;
 Mon, 26 Aug 2019 09:50:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190826161915.81676-1-edumazet@google.com>
In-Reply-To: <20190826161915.81676-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 26 Aug 2019 12:50:13 -0400
Message-ID: <CACSApvb=MmO-9GXu3Ke9tMWpC=-uGABg+U0_6i1kBQL3+_dYMQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: remove empty skb from write queue in error cases
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jason Baron <jbaron@akamai.com>,
        Vladimir Rutsky <rutsky@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 12:19 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Vladimir Rutsky reported stuck TCP sessions after memory pressure
> events. Edge Trigger epoll() user would never receive an EPOLLOUT
> notification allowing them to retry a sendmsg().
>
> Jason tested the case of sk_stream_alloc_skb() returning NULL,
> but there are other paths that could lead both sendmsg() and sendpage()
> to return -1 (EAGAIN), with an empty skb queued on the write queue.
>
> This patch makes sure we remove this empty skb so that
> Jason code can detect that the queue is empty, and
> call sk->sk_write_space(sk) accordingly.
>
> Fixes: ce5ec440994b ("tcp: ensure epoll edge trigger wakeup when write queue is empty")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jason Baron <jbaron@akamai.com>
> Reported-by: Vladimir Rutsky <rutsky@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Nice find!

> ---
>  net/ipv4/tcp.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 77b485d60b9d0e00edc4e2f0d6c5bb3a9460b23b..61082065b26a068975c411b74eb46739ab0632ca 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -935,6 +935,22 @@ static int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
>         return mss_now;
>  }
>
> +/* In some cases, both sendpage() and sendmsg() could have added
> + * an skb to the write queue, but failed adding payload on it.
> + * We need to remove it to consume less memory, but more
> + * importantly be able to generate EPOLLOUT for Edge Trigger epoll()
> + * users.
> + */
> +static void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
> +{
> +       if (skb && !skb->len) {
> +               tcp_unlink_write_queue(skb, sk);
> +               if (tcp_write_queue_empty(sk))
> +                       tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
> +               sk_wmem_free_skb(sk, skb);
> +       }
> +}
> +
>  ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
>                          size_t size, int flags)
>  {
> @@ -1064,6 +1080,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
>         return copied;
>
>  do_error:
> +       tcp_remove_empty_skb(sk, tcp_write_queue_tail(sk));
>         if (copied)
>                 goto out;
>  out_err:
> @@ -1388,18 +1405,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>         sock_zerocopy_put(uarg);
>         return copied + copied_syn;
>
> +do_error:
> +       skb = tcp_write_queue_tail(sk);
>  do_fault:
> -       if (!skb->len) {
> -               tcp_unlink_write_queue(skb, sk);
> -               /* It is the one place in all of TCP, except connection
> -                * reset, where we can be unlinking the send_head.
> -                */
> -               if (tcp_write_queue_empty(sk))
> -                       tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
> -               sk_wmem_free_skb(sk, skb);
> -       }
> +       tcp_remove_empty_skb(sk, skb);
>
> -do_error:
>         if (copied + copied_syn)
>                 goto out;
>  out_err:
> --
> 2.23.0.187.g17f5b7556c-goog
>

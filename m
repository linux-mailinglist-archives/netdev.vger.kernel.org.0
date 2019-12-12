Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6368E11D9B7
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 23:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731086AbfLLW4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 17:56:54 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46351 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730859AbfLLW4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 17:56:54 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so4507762wrl.13
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 14:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pZOM2NQh5bKfgA5emh5o/IE5CvHY5kv7nA6uesnAFq8=;
        b=S3c0Agdo13eydPHRAYTv8bSl0zwficDRzWCeJ74C1RAdSUfMb29OfVE0yhUfeiUWJG
         D+DPIztLVNYK1Zqvj4z855oAWE0aS6PkCrxGWpYo7cCxJ1elrXF203+ahByzGm3NvUWo
         knWWngaMu4Lj9kjY1WdYssO7HMXFOAPYOBjGonXTjgj9rE2PfEVpU4K482aYl1EbhxVN
         p8Sbgf5y/5LynLyNLwU4XqW+fYECxfIHvuqD3YbJG1IlsjXi6kxJl6EqlzRlTFJ6LRCN
         KBs0JGJwRC1pWL1tPWzNBtfPNAipCtuh0lMM1GJM5MtABcbRDLZlwC8Yv8NxpRDLbTyP
         2ufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pZOM2NQh5bKfgA5emh5o/IE5CvHY5kv7nA6uesnAFq8=;
        b=aywpsdrFXr9zv/3pswlCKUXYvojWEGv2NIRmKorFhclVGt5zdjxxIJBOfuRFjhKyDx
         JkfUYqHywb3psW7q8cvegtHZv3L5l2yDEAN1hJ3emaT/Ut2WfzFQdfyaLL26UvJOmf2d
         tUjfTO82rPylOUhAAr7LEReM15Dou/U6GzDZbvX4+fG2ADzNogM1rip4c9+BQ3Zmi5R3
         xKFcbXf53oNb09Bj6fzxDe16sQ64bzWyYu5/fBHKMpAygBk/07Sjrs5Y9Jpvt+Puisjg
         vMLMg3HFWwjOtrO/sRLhBK/4VTpNNgl615K2y+kqykkNu54YVP46wE4iebeRhR7+F23z
         ss3g==
X-Gm-Message-State: APjAAAXNLlJoZb81FYeTGrLjTI4UJusxfUSqEzbEyUVOPxFmf3otTVBt
        0OObrS7joQgxwcfUxsxTTRRDoReHGpqKh2fG+ATQbg==
X-Google-Smtp-Source: APXvYqz8jrizXsiv2r1SKB18iaJ8SEvl65OtWi0u4WeYiQwO3+wGTOI0H53Zq4bHlYyyq4omN5A+KxI7cvBY/KUEFb0=
X-Received: by 2002:a5d:4805:: with SMTP id l5mr8696967wrq.3.1576191411668;
 Thu, 12 Dec 2019 14:56:51 -0800 (PST)
MIME-Version: 1.0
References: <20191212205531.213908-1-edumazet@google.com> <20191212205531.213908-4-edumazet@google.com>
In-Reply-To: <20191212205531.213908-4-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 12 Dec 2019 17:56:13 -0500
Message-ID: <CACSApvYAL9WCzsoYOW1PoP0HQ_ZVgbsJBUj_Kn3mHU+RfHPayw@mail.gmail.com>
Subject: Re: [PATCH net 3/3] tcp: refine rule to allow EPOLLOUT generation
 under mem pressure
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 3:55 PM Eric Dumazet <edumazet@google.com> wrote:
>
> At the time commit ce5ec440994b ("tcp: ensure epoll edge trigger
> wakeup when write queue is empty") was added to the kernel,
> we still had a single write queue, combining rtx and write queues.
>
> Once we moved the rtx queue into a separate rb-tree, testing
> if sk_write_queue is empty has been suboptimal.
>
> Indeed, if we have packets in the rtx queue, we probably want
> to delay the EPOLLOUT generation at the time incoming packets
> will free them, making room, but more importantly avoiding
> flooding application with EPOLLOUT events.
>
> Solution is to use tcp_rtx_and_write_queues_empty() helper.
>
> Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jason Baron <jbaron@akamai.com>
> Cc: Neal Cardwell <ncardwell@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  net/ipv4/tcp.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 8a39ee79489192c02385aaadc8d1ae969fb55d23..716938313a32534f312c6b90f66ff7870177b4a5 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1087,8 +1087,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
>                 goto out;
>  out_err:
>         /* make sure we wake any epoll edge trigger waiter */
> -       if (unlikely(skb_queue_len(&sk->sk_write_queue) == 0 &&
> -                    err == -EAGAIN)) {
> +       if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
>                 sk->sk_write_space(sk);
>                 tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
>         }
> @@ -1419,8 +1418,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>         sock_zerocopy_put_abort(uarg, true);
>         err = sk_stream_error(sk, flags, err);
>         /* make sure we wake any epoll edge trigger waiter */
> -       if (unlikely(skb_queue_len(&sk->sk_write_queue) == 0 &&
> -                    err == -EAGAIN)) {
> +       if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
>                 sk->sk_write_space(sk);
>                 tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
>         }
> --
> 2.24.1.735.g03f4e72817-goog
>

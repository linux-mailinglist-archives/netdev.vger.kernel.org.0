Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A0BC09A9
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 18:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfI0Qfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 12:35:45 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36322 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbfI0Qfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 12:35:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id y19so3897224wrd.3
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 09:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2UiXLHYPkk0mxphBGJ/ErKZt1IG6MWXMGBsXbn9pocI=;
        b=j5ipLY9hf5QphBT5IkgrVfynGWRHK3OnF7CqStpHqvPehp5P7+/aQRBcwrNv5xQdTZ
         S2hFCmyPW6LgLVSFPjTTeIVWp0UEqph/QVfu+VnUB1CyArIguFPd4qbOpWlcaYDTRoHr
         rshEVG4LNv5XBvkhF0VLljRqrrRgK778ZmELr/+NAE/+08zpOqU+Y3mJLQbuFRNAUbDk
         GDpZdbVmdh/9LjHSH2LL1WlzBWlJFCVE2VXdMJUaabNGStLadxS3coVXPQZsAjwZVhho
         08YTxOJkETSrIsQMCys6F8wS+ByiSeC5MLcSoJGKhhqHIRj9pmaUjFf9exCID7TJiWsT
         IYSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2UiXLHYPkk0mxphBGJ/ErKZt1IG6MWXMGBsXbn9pocI=;
        b=QnHDthnN02ncIZgYEazHqS3cUN6Ey8zfExFD7dgqfCaOkU6ECNpcUJBjLs19enpttj
         1jWdaX8kSFdDPipeGav52kKSvMlrBUNxTaGvqcTqKdJwFLkKF2RpHa0G0hB4ijAPxXTm
         f23SwH+EprjL/1C06DXGhkSOfMjuJ2i0WoqgSe3r/ShnkaO0uJYGUx8ch3OznZxa5hdy
         L5hMW8zbtQdKnwXCFE5ePXlfLEaszBbFIjaEUM5Hj6FH+cuWMfE9lPqL6sB/S2LqVNaf
         JOUZ2MXYopXO2ZGo0qtJy9GNKrY7xJS6PjWYOlhYs4aQ42WisGTTcCw1mYjS7/NLNZkQ
         hwrw==
X-Gm-Message-State: APjAAAVRTkxEzbxDFU5U9Pl1F1Buxz6Md0xbdHG71VWDX6GsYY7IlMFH
        KLWqGHtk8E75WpDlZO5wG57sIcF2jm++coz9I6XVwQ==
X-Google-Smtp-Source: APXvYqyeE8p30RfGOpqi//LCUXxbWVrYObaHKXK+P3Qpd35nBZSItGvH6uGVxGQm8m7jAJoL6ZS9TWk7V5M4XkSinyU=
X-Received: by 2002:a7b:c84f:: with SMTP id c15mr8257525wml.52.1569602143230;
 Fri, 27 Sep 2019 09:35:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190926224251.249797-1-edumazet@google.com>
In-Reply-To: <20190926224251.249797-1-edumazet@google.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Fri, 27 Sep 2019 09:35:06 -0700
Message-ID: <CAK6E8=f9v9eYFw7oZ7orsTru0Rr=eUMwSk5VcZP-kEgPkag1+g@mail.gmail.com>
Subject: Re: [PATCH net] tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Jon Maxwell <jmaxwell37@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 3:42 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Yuchung Cheng and Marek Majkowski independently reported a weird
> behavior of TCP_USER_TIMEOUT option when used at connect() time.
>
> When the TCP_USER_TIMEOUT is reached, tcp_write_timeout()
> believes the flow should live, and the following condition
> in tcp_clamp_rto_to_user_timeout() programs one jiffie timers :
>
>     remaining = icsk->icsk_user_timeout - elapsed;
>     if (remaining <= 0)
>         return 1; /* user timeout has passed; fire ASAP */
>
> This silly situation ends when the max syn rtx count is reached.
>
> This patch makes sure we honor both TCP_SYNCNT and TCP_USER_TIMEOUT,
> avoiding these spurious SYN packets.
>
> Fixes: b701a99e431d ("tcp: Add tcp_clamp_rto_to_user_timeout() helper to improve accuracy")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Yuchung Cheng <ycheng@google.com>
> Reported-by: Marek Majkowski <marek@cloudflare.com>
> Cc: Jon Maxwell <jmaxwell37@gmail.com>
> Link: https://marc.info/?l=linux-netdev&m=156940118307949&w=2
> ---
Acked-by: Yuchung Cheng <ycheng@google.com>
thanks for fixing it!
>  net/ipv4/tcp_timer.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index dbd9d2d0ee63aa46ad2dda417da6ec9409442b77..40de2d2364a1eca14c259d77ebed361d17829eb9 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -210,7 +210,7 @@ static int tcp_write_timeout(struct sock *sk)
>         struct inet_connection_sock *icsk = inet_csk(sk);
>         struct tcp_sock *tp = tcp_sk(sk);
>         struct net *net = sock_net(sk);
> -       bool expired, do_reset;
> +       bool expired = false, do_reset;
>         int retry_until;
>
>         if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
> @@ -242,9 +242,10 @@ static int tcp_write_timeout(struct sock *sk)
>                         if (tcp_out_of_resources(sk, do_reset))
>                                 return 1;
>                 }
> +       }
> +       if (!expired)
>                 expired = retransmits_timed_out(sk, retry_until,
>                                                 icsk->icsk_user_timeout);
> -       }
>         tcp_fastopen_active_detect_blackhole(sk, expired);
>
>         if (BPF_SOCK_OPS_TEST_FLAG(tp, BPF_SOCK_OPS_RTO_CB_FLAG))
> --
> 2.23.0.444.g18eeb5a265-goog
>

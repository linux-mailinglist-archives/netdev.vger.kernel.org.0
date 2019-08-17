Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B014C9106C
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 14:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfHQMkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 08:40:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34153 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfHQMkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 08:40:24 -0400
Received: by mail-wr1-f68.google.com with SMTP id s18so4116504wrn.1
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 05:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LaZ1tX4gz22oa4p+lxpFJQab8WKTRtUULcHikEKr6/s=;
        b=egOXgFY1ADWmSBm1+8P+Cg4CoaSAv5VCSPxaKpGufYOof8VoDyWBj1VJuLV3Z71V8l
         zuabZexjqplU1kyD1VmkaW6nmUPq7RNT7jZRe9ZFNLIQjetarJ5Ig9OYiUqYapeHvrNC
         NQHYbujqCC6HdmkvtjmAsM/LUBQbXw9sAav7on6SnA300sFnhJf/9RHTmI4fKIQAPmNH
         AaQU1I+6UDVP3NjaOPbDEfNYZ5/9qJ9Ld8hb2NWqTOKAGcTyXg3Wbotr5FjHY721w/ZJ
         5zLQ1yZIyRSnENdCIGqm0erxp4XWN9O91qxHapkGvalhVvrbheob1FtA0aeE8XZQMWo9
         O2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LaZ1tX4gz22oa4p+lxpFJQab8WKTRtUULcHikEKr6/s=;
        b=n4D4YxLeMlt5RjGBvCKTcMPSBmghFBclfXFGlQYpaiXBPN0vaqJkLJo1eggRDd3Ffc
         teZ99HgHd7XFo9QSzsh98fIFHUt01PrY38dcsL57YvUXzngmUMp6juiUqzMEOeYD5Ge+
         cKgqE1USriQehdqPdgwEZZlmqETDXraTe1i0CMXHVjXJGbHj+uzx7VJaqJr9ZtnT2tXJ
         gGeCQPVMRusINwFSlUjo9NxMHfD1kFKvlEwgTnccv89VvCPs1oAjtgXrAybEM1VHWRCh
         qcoNE+wtF8apTTPnFy6AD++6AJTqaWW4H5gPtSzmgdICL8MSlDXYLzrA7taZ+kJ4mgKl
         M03g==
X-Gm-Message-State: APjAAAW2Lk590pgt2sNTOEl0oqFGd+qKiIP99ZQovSpx+coqc/PXzeih
        b7iOJXWHjsaBeg2S6VMoruF+TyKnDmX8STkRQPlZuw==
X-Google-Smtp-Source: APXvYqwdVHhj8rOztytmi4oVVH8IQ2HEdKGNKur5FH3NPi9D3EafsYhx2xjLHKj24eDEOkNBIKW2WLYkZuzcKIzxhUA=
X-Received: by 2002:a05:6000:10cf:: with SMTP id b15mr16119269wrx.180.1566045621662;
 Sat, 17 Aug 2019 05:40:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190817042622.91497-1-edumazet@google.com>
In-Reply-To: <20190817042622.91497-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Sat, 17 Aug 2019 08:39:44 -0400
Message-ID: <CACSApvaExue4uW198Xw1Uipo8BY12PnvbpqceBs8EOHGQMn1YQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: make sure EPOLLOUT wont be missed
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

On Sat, Aug 17, 2019 at 12:26 AM Eric Dumazet <edumazet@google.com> wrote:
>
> As Jason Baron explained in commit 790ba4566c1a ("tcp: set SOCK_NOSPACE
> under memory pressure"), it is crucial we properly set SOCK_NOSPACE
> when needed.
>
> However, Jason patch had a bug, because the 'nonblocking' status
> as far as sk_stream_wait_memory() is concerned is governed
> by MSG_DONTWAIT flag passed at sendmsg() time :
>
>     long timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
>
> So it is very possible that tcp sendmsg() calls sk_stream_wait_memory(),
> and that sk_stream_wait_memory() returns -EAGAIN with SOCK_NOSPACE
> cleared, if sk->sk_sndtimeo has been set to a small (but not zero)
> value.
>
> This patch removes the 'noblock' variable since we must always
> set SOCK_NOSPACE if -EAGAIN is returned.
>
> It also renames the do_nonblock label since we might reach this
> code path even if we were in blocking mode.
>
> Fixes: 790ba4566c1a ("tcp: set SOCK_NOSPACE under memory pressure")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jason Baron <jbaron@akamai.com>
> Reported-by: Vladimir Rutsky  <rutsky@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you for the fix!

> ---
>  net/core/stream.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/net/core/stream.c b/net/core/stream.c
> index e94bb02a56295ec2db34ab423a8c7c890df0a696..4f1d4aa5fb38d989a9c81f32dfce3f31bbc1fa47 100644
> --- a/net/core/stream.c
> +++ b/net/core/stream.c
> @@ -120,7 +120,6 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
>         int err = 0;
>         long vm_wait = 0;
>         long current_timeo = *timeo_p;
> -       bool noblock = (*timeo_p ? false : true);
>         DEFINE_WAIT_FUNC(wait, woken_wake_function);
>
>         if (sk_stream_memory_free(sk))
> @@ -133,11 +132,8 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
>
>                 if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))
>                         goto do_error;
> -               if (!*timeo_p) {
> -                       if (noblock)
> -                               set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
> -                       goto do_nonblock;
> -               }
> +               if (!*timeo_p)
> +                       goto do_eagain;
>                 if (signal_pending(current))
>                         goto do_interrupted;
>                 sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
> @@ -169,7 +165,13 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
>  do_error:
>         err = -EPIPE;
>         goto out;
> -do_nonblock:
> +do_eagain:
> +       /* Make sure that whenever EAGAIN is returned, EPOLLOUT event can
> +        * be generated later.
> +        * When TCP receives ACK packets that make room, tcp_check_space()
> +        * only calls tcp_new_space() if SOCK_NOSPACE is set.
> +        */
> +       set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
>         err = -EAGAIN;
>         goto out;
>  do_interrupted:
> --
> 2.23.0.rc1.153.gdeed80330f-goog
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1487111BCC0
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfLKTRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:17:30 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45072 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLKTR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 14:17:29 -0500
Received: by mail-ot1-f67.google.com with SMTP id 59so852969otp.12
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 11:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V4cP0f+jTCOEwzsB+qIKa00ifWd+VJ6cO9ddtzoRP5E=;
        b=mdrCySH++7rIpH4z48OGg8gZpWjNGOpwAR4I414eYiZlWsFda1SIErZwmc5LReAMg9
         36vAS+FD9EVh/DsXFynMepY0Zj5bwgOrilJ2qkI9CsflLxeioI3WJTgGyluMkM/xgu1v
         rio8fi+ZOQ0s9wEqSCyRO4bwzMcAh+xnl9YdlELrFx1Ulfo236qMle6mo/hWMQzv22ia
         fRpulxtt7vPW8oJ+2cs01pruyeT1YZz1xr4ZWZtlIyaS5Rap0ZoF2sJ0aKwRyPR0hdR6
         FU3muwA7P6C7o+7cqMIjayhIHIF8I30XVudUTPZiptaz178hMQoohtf70LeXe9yIUlXe
         bltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V4cP0f+jTCOEwzsB+qIKa00ifWd+VJ6cO9ddtzoRP5E=;
        b=nsBK73y+0AP48wTdsgmOqHkbIDOLrYSa3YI5jXBXH+ZDkrhO6OrDhpLBn7yfUmhPTe
         YUbMM/uAxOFHUMU2GRXRsePZuqefYgRtdva/8Z3C5jmbMnpY5PzOkZkHjADLHqZ4k94E
         DrpjBk28345Gul0obFCla/ntJZB/Kw4H61DFsmyyZ7Q7i+PgU9KSk7Tw2QrpYD1r/k4K
         h7mydfstSNHHV7fZmme2wEriwGbe5rhVCnEoe8mCsCX+EM/rY8QgKBRCDLBn9RQCLov2
         TLZ5B7H0nKs3Z2KLkUASq74xWm7DhmKv6rlujkUWCfFRmvmYxtVefNoBPptIv+LnPK+a
         4osw==
X-Gm-Message-State: APjAAAWUICDHTbOx2HIgFzRkR6eTwYT/DDOG3tajGEghmSrBZnfosn/5
        b8IPPLj+zf0oB3mOLS7AjXQRhTIeLaDHlJGdm2e90w==
X-Google-Smtp-Source: APXvYqyAemVaEfn9qaK1IxtKdnDsCeKKKFV7H6WPLb4HwS2HysPTksmQDYALSnnf0r6hJSM7zsA9THyUks/sFlKZYe4=
X-Received: by 2002:a9d:7c8f:: with SMTP id q15mr3626607otn.341.1576091848212;
 Wed, 11 Dec 2019 11:17:28 -0800 (PST)
MIME-Version: 1.0
References: <20191211073419.258820-1-edumazet@google.com>
In-Reply-To: <20191211073419.258820-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 11 Dec 2019 14:17:12 -0500
Message-ID: <CADVnQynJoDaNhY=NODF7CJ5KdqVzwgTZU5zoysAEbGJ3TXJnvQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: do not send empty skb from tcp_write_xmit()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Jason Baron <jbaron@akamai.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 2:34 AM Eric Dumazet <edumazet@google.com> wrote:
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
> Cc: Neal Cardwell <ncardwell@google.com>
> Cc: Jason Baron <jbaron@akamai.com>
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

Thanks for the fix, Eric!

Is there any risk that any current or future bugs that create
persistently empty skbs could cause the connection to "freeze", unable
to reach the tcp_transmit_skb() call in tcp_write_xmit()?

To avoid this risk, would it make sense to delete the empty skb and
continue the tcp_write_xmit() transmit loop, rather than breaking out
of the loop?

Just curious to learn. :-)

thanks,
neal

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6336E56F9AB
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 11:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiGKJHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 05:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiGKJHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 05:07:14 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4113822BCC
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 02:07:06 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id e69so7715406ybh.2
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 02:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r3r9shr/bSnpdVbJCshaTpav4kwHF4Hogm4v6ZuXBPM=;
        b=XHgonOycZCkATK7QjpK7xNhOOrMMMUV9CCSZSo/kCdBu4+dnmaUvhfUTTpenrKen5j
         UBasG5auSqA8pCL1IT9D8Uq9Sa2goVodx7Mdr9auerdXR51S1y4IMhRLBJb4jIyKRo2l
         9sIcNyAIxL2vGfi1uJ7wi6XLVpac7PCG13I7FLcqKc0UL+/dR9jNaBCeQQSdk2JaGVGz
         dGZjgEwpbFpi49GpfV1LWXuJpdZ/OJKKc9OWE2LqYSNvsA3TjeF/VwXlqoNhYR28YFjc
         iBJMwQ5xYNeQjfRvYMeJQUUcW8sP3ho1056Girrww3f3jMccFV/uLg3JcvFrUQiuvAtz
         26zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r3r9shr/bSnpdVbJCshaTpav4kwHF4Hogm4v6ZuXBPM=;
        b=PZiRCtlYYCjKqNDSyb9XlByfACVGf95o6NRaHO9JYJP9UGVcm/xjoM6aXJLUCaV0sY
         g/w3+rNlV5tYFLHwPXO9T8BGHYAtvmHbfsXyhjgXpFd8ppKhUlUmL9bcLcn4mxnNKhEe
         x0NhKUNtZuIbZiBrtcqu6U+ezps3HZC6txF5cf7QNMIw05Q1NNtp4wyF7TsctJXS/WXF
         uw3AIhlCXp7cFjZd9JtyD/oA203jFHiADbEJ7LpFTomnGklE3zwnGApqJL+z4qBhrdi0
         88a1BIbz7FE73dziX8QdPoEfjm8KunVsLkAhtoRDhJsKpsETldItfb2SuaFltSV/1A2G
         F+vQ==
X-Gm-Message-State: AJIora9AkN2oGwg1eKfXuDgaMP51bBr/Mf/COrK0X72RdKrwLkqZ0j/G
        zdjwNGCcHavPf1JlgBpgd48jz4kbCUth/bo63Jlnlr2sQpY=
X-Google-Smtp-Source: AGRyM1vIH7goxBS9KzuDJ+Sn3+JJXHOZi8hPaZFkOgCy0uO4UqnbM8GgzsyvRkb/dGHjK1Qk01csw8POAZFNSS1TDFo=
X-Received: by 2002:a25:e211:0:b0:669:9cf9:bac7 with SMTP id
 h17-20020a25e211000000b006699cf9bac7mr15673809ybe.407.1657530425039; Mon, 11
 Jul 2022 02:07:05 -0700 (PDT)
MIME-Version: 1.0
References: <1657525740-7585-1-git-send-email-liyonglong@chinatelecom.cn>
In-Reply-To: <1657525740-7585-1-git-send-email-liyonglong@chinatelecom.cn>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 11 Jul 2022 11:06:53 +0200
Message-ID: <CANn89iJ-ca3u1JRKm=H4+rR3MFrdXxXTDUftNUzF20YTUM3=rg@mail.gmail.com>
Subject: Re: [PATCH v3] tcp: make retransmitted SKB fit into the send window
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 9:56 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>
> current code of __tcp_retransmit_skb only check TCP_SKB_CB(skb)->seq
> in send window, and TCP_SKB_CB(skb)->seq_end maybe out of send window.
> If receiver has shrunk his window, and skb is out of new window,  it
> should retransmit a smaller portion of the payload.
>
> test packetdrill script:
>     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 fcntl(3, F_GETFL) = 0x2 (flags O_RDWR)
>    +0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
>
>    +0 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
>    +0 > S 0:0(0)  win 65535 <mss 1460,sackOK,TS val 100 ecr 0,nop,wscale 8>
>  +.05 < S. 0:0(0) ack 1 win 6000 <mss 1000,nop,nop,sackOK>
>    +0 > . 1:1(0) ack 1
>
>    +0 write(3, ..., 10000) = 10000
>
>    +0 > . 1:2001(2000) ack 1 win 65535
>    +0 > . 2001:4001(2000) ack 1 win 65535
>    +0 > . 4001:6001(2000) ack 1 win 65535
>
>  +.05 < . 1:1(0) ack 4001 win 1001
>
> and tcpdump show:
> 192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 1:2001, ack 1, win 65535, length 2000
> 192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 2001:4001, ack 1, win 65535, length 2000
> 192.168.226.67.55 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000
> 192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000
> 192.0.2.1.8080 > 192.168.226.67.55: Flags [.], ack 4001, win 1001, length 0
> 192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000
> 192.168.226.67.55 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000
>
> when cient retract window to 1001, send window is [4001,5002],
> but TLP send 5001-6001 packet which is out of send window.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
> ---
>  net/ipv4/tcp_output.c | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 18c913a..efd0f05 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3100,7 +3100,6 @@ static bool tcp_can_collapse(const struct sock *sk, const struct sk_buff *skb)
>  static void tcp_retrans_try_collapse(struct sock *sk, struct sk_buff *to,
>                                      int space)
>  {
> -       struct tcp_sock *tp = tcp_sk(sk);
>         struct sk_buff *skb = to, *tmp;
>         bool first = true;
>
> @@ -3123,14 +3122,18 @@ static void tcp_retrans_try_collapse(struct sock *sk, struct sk_buff *to,
>                         continue;
>                 }
>
> -               if (space < 0)
> -                       break;
> -
> -               if (after(TCP_SKB_CB(skb)->end_seq, tcp_wnd_end(tp)))
> +               if (space < 0) {
> +                       if (unlikely(tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE,
> +                                                 skb, space + skb->len,
> +                                                 tcp_current_mss(sk), GFP_ATOMIC)))

What are you doing here ?

This seems wrong.

Can we please stick to the patch I sent earlier.

If you want to amend it later, you can do this in a separate patch,
with a clear explanation.

> +                               break;
> +                       tcp_collapse_retrans(sk, to);
>                         break;
> +               }
>
>                 if (!tcp_collapse_retrans(sk, to))
>                         break;
> +
>         }
>  }
>
> @@ -3144,7 +3147,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
>         struct tcp_sock *tp = tcp_sk(sk);
>         unsigned int cur_mss;
>         int diff, len, err;
> -
> +       int avail_wnd;
>
>         /* Inconclusive MTU probe */
>         if (icsk->icsk_mtup.probe_size)
> @@ -3166,17 +3169,25 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
>                 return -EHOSTUNREACH; /* Routing failure or similar. */
>
>         cur_mss = tcp_current_mss(sk);
> +       avail_wnd = tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq;
>
>         /* If receiver has shrunk his window, and skb is out of
>          * new window, do not retransmit it. The exception is the
>          * case, when window is shrunk to zero. In this case
> -        * our retransmit serves as a zero window probe.
> +        * our retransmit of one segment serves as a zero window probe.
>          */
> -       if (!before(TCP_SKB_CB(skb)->seq, tcp_wnd_end(tp)) &&
> -           TCP_SKB_CB(skb)->seq != tp->snd_una)
> -               return -EAGAIN;
> +       if (avail_wnd <= 0) {
> +               if (TCP_SKB_CB(skb)->seq != tp->snd_una)
> +                       return -EAGAIN;
> +               avail_wnd = cur_mss;
> +       }
>
>         len = cur_mss * segs;
> +       if (len > avail_wnd) {
> +               len = rounddown(avail_wnd, cur_mss);
> +               if (!len)
> +                       len = avail_wnd;
> +       }
>         if (skb->len > len) {
>                 if (tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb, len,
>                                  cur_mss, GFP_ATOMIC))
> @@ -3190,8 +3201,9 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
>                 diff -= tcp_skb_pcount(skb);
>                 if (diff)
>                         tcp_adjust_pcount(sk, skb, diff);
> -               if (skb->len < cur_mss)
> -                       tcp_retrans_try_collapse(sk, skb, cur_mss);
> +               avail_wnd = min_t(int, avail_wnd, cur_mss);
> +               if (skb->len < avail_wnd)
> +                       tcp_retrans_try_collapse(sk, skb, avail_wnd);
>         }
>
>         /* RFC3168, section 6.1.1.1. ECN fallback */
> --
> 1.8.3.1
>

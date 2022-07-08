Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A181E56B8C9
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 13:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbiGHLps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 07:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237947AbiGHLpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 07:45:47 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C387D1F7
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 04:45:46 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-31d27fd3d94so6906277b3.7
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 04:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0tmhfB2qZ1rJuCSaoNGejboEaSJLUIJ6TqE77fRvlzs=;
        b=smu96S04D3ZJjp1/T5E5NsAigl7ygO73rGEXME8dzP0jRfNX52v+qEnOIdQBfnvx6Q
         oapYtdbdrxK9agL5YiV+jBrVAr7IBX9/9AkFKvEqmZ0Fv9AKRiKD1Q2/+MPWka2J6cv9
         Jbd1AZ79jvjFPYSAKjEfruG1YwA2HYWV5JNnjt9tA0EIEHX7Dm1saXL71GKirJDjY9oh
         WfCAeiVItJVqcKtf6AOf1+PWQ/xnPJcE0LiS+PwVBg58qTHZFIUDrnNM/lEajrf44wA2
         AqfuIEzAbR5EWzgbmbfj4Wp962Hr3LLbowzleYizv0lq5dl/WHP0k+lLu64CB+JQKygN
         ZWvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0tmhfB2qZ1rJuCSaoNGejboEaSJLUIJ6TqE77fRvlzs=;
        b=GIXLRvuO+SB463jcNzPEUfaWQF/nWU3NlBExCFNsIx93szHtEY3cHXp42O5YRfHmeN
         ptUDq7uZ/MxPZmK703Hm5Fguax7NMB9V35zT3aT5NACB8JTqgVgGjlSIFCUU2kuO8MsE
         kdd7I9ibTAVubKl3W+3Vpi/WVPl8T6rc/stsF7CPQHf0Y58OHtNqCaCNg9JYGvEpywuL
         m8yoOZB6b/af75+XC/3JQtF9PZsOyTnrd1Sm8S29sIja6wSMvyPVNVY9kICOufUrY//Y
         u64eD4P757/nc4SSwU1AavgEf3+I9LzHLIM1RFdmzUkGCwXd3CdrViplJKZznAYck2MB
         Jl1Q==
X-Gm-Message-State: AJIora/e+vwK5sAgYSGbSTmCymbNCFRGZzafqcbDriN/YphlbYtrxQtd
        Pj7LTSe/v56l2JYoaoA3R9adqdeZLsTRcNA5RT2XlA==
X-Google-Smtp-Source: AGRyM1vpVvMPzK6xVpPVGewdD6usjx4eXhTf7KN5m9tOkzmwecfCGO77wpfaagl423Pp8jVNOfGyOhEQZL8eZf3grFU=
X-Received: by 2002:a81:4994:0:b0:31c:d036:d0b1 with SMTP id
 w142-20020a814994000000b0031cd036d0b1mr3550343ywa.255.1657280745233; Fri, 08
 Jul 2022 04:45:45 -0700 (PDT)
MIME-Version: 1.0
References: <1657270774-39372-1-git-send-email-liyonglong@chinatelecom.cn>
In-Reply-To: <1657270774-39372-1-git-send-email-liyonglong@chinatelecom.cn>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jul 2022 13:45:33 +0200
Message-ID: <CANn89i+VULAsSwaT=n8DGxazijiJfu+BLfFhuknKn9MJ8LXtUQ@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: make retransmitted SKB fit into the send window
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

On Fri, Jul 8, 2022 at 10:59 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>
> From: lyl <liyonglong@chinatelecom.cn>
>
> current code of __tcp_retransmit_skb only check TCP_SKB_CB(skb)->seq
> in send window, and TCP_SKB_CB(skb)->seq_end maybe out of send window.
> If receiver has shrunk his window, and skb is out of new window,  it
> should not retransmit it.

More exactly, it should retransmit a smaller portion of the payload.

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
> Signed-off-by: liyonglong <liyonglong@chinatelecom.cn>
> ---
>  net/ipv4/tcp_output.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 1c05443..7e1569e 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3176,7 +3176,12 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
>             TCP_SKB_CB(skb)->seq != tp->snd_una)
>                 return -EAGAIN;
>
> -       len = cur_mss * segs;
> +       len = min_t(int, tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq, cur_mss * segs);
> +
> +       /* retransmit serves as a zero window probe. */
> +       if (len == 0 && TCP_SKB_CB(skb)->seq == tp->snd_una)
> +               len = cur_mss;
> +

I asked in my prior feeback to align len to a multiple of cur_mss.
Trying to send full MSS is likely helping receivers to not waste
memory and thus send us bigger RWIN.

Also I think the logic about zero window probe could be consolidated
in one place.

Also you forgot to change the part about tcp_retrans_try_collapse()
which I also mentioned in my feedback.

If we want to fix this problem for good, we need to take care of all cases...

Something like this:

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 18c913a2347a984ae8cf2793bb8991e59e5e94ab..2aa67cbfa1428a11b723263083ce48284762e306
100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3144,7 +3144,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct
sk_buff *skb, int segs)
        struct tcp_sock *tp = tcp_sk(sk);
        unsigned int cur_mss;
        int diff, len, err;
-
+       int avail_wnd;

        /* Inconclusive MTU probe */
        if (icsk->icsk_mtup.probe_size)
@@ -3167,16 +3167,24 @@ int __tcp_retransmit_skb(struct sock *sk,
struct sk_buff *skb, int segs)

        cur_mss = tcp_current_mss(sk);

+       avail_wnd = tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq;
        /* If receiver has shrunk his window, and skb is out of
         * new window, do not retransmit it. The exception is the
         * case, when window is shrunk to zero. In this case
-        * our retransmit serves as a zero window probe.
+        * our retransmit of one segment serves as a zero window probe.
         */
-       if (!before(TCP_SKB_CB(skb)->seq, tcp_wnd_end(tp)) &&
-           TCP_SKB_CB(skb)->seq != tp->snd_una)
-               return -EAGAIN;
+       if (avail_wnd <= 0) {
+               if (TCP_SKB_CB(skb)->seq != tp->snd_una)
+                       return -EAGAIN;
+               avail_wnd = cur_mss;
+       }

        len = cur_mss * segs;
+       if (len > avail_wnd) {
+               len = rounddown(avail_wnd, cur_mss);
+               if (!len)
+                       len = avail_wnd;
+       }
        if (skb->len > len) {
                if (tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb, len,
                                 cur_mss, GFP_ATOMIC))
@@ -3190,8 +3198,9 @@ int __tcp_retransmit_skb(struct sock *sk, struct
sk_buff *skb, int segs)
                diff -= tcp_skb_pcount(skb);
                if (diff)
                        tcp_adjust_pcount(sk, skb, diff);
-               if (skb->len < cur_mss)
-                       tcp_retrans_try_collapse(sk, skb, cur_mss);
+               avail_wnd = min_t(int, avail_wnd, cur_mss);
+               if (skb->len < avail_wnd)
+                       tcp_retrans_try_collapse(sk, skb, avail_wnd);
        }

        /* RFC3168, section 6.1.1.1. ECN fallback */

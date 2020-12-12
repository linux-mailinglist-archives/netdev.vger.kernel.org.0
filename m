Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B002D894F
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 19:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407719AbgLLSfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 13:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgLLSfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 13:35:33 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D845C0613D3
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 10:34:53 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id y17so12316156wrr.10
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 10:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qGFtyYlVmI62XiTpOKeYXRAQe6g42lFPimyQ1u1WOMA=;
        b=iNMUmWuBoFJGDpNE9UAlebZ02dvNng1fcXaL1Wvi+k0jhUhxO2dc7cgGDXmNTFqck3
         cd8Owu1ezY7Zd7N1+UENX0nTMV+lcojO5X/CNWNkNLKsuEn260UJeH4vjxSC9gaglAKr
         s9Zo86YeoaSWsbCb7TUadOz4hDDIDfzf7I/+zYXR0bZEMIhS2PP0clOKY8ixQ4WgixRB
         CQBeB+Sb2MeLcjDEqrYRRj4HOWvXHaCwuNH2MLpSpkazBYuJMKs9fltgSuVYSWFOqWId
         5UV3hUowVAm6z9ZEj2oDoM2EL7tcKmJkVmxQyTC8dIUEDzMxqhfPejh6RvbG1PV/+067
         G/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qGFtyYlVmI62XiTpOKeYXRAQe6g42lFPimyQ1u1WOMA=;
        b=gaCDbWhRqC/h9cWOTDyDBNUd5nWf/riUaBcL8rw1s0uKgGG6RwGGlYzvSELpDCYKir
         NHYMP7SiLSBJ57o5I77lj2I+06hBeJWMPA3+J9HGUtD0pr3Ze2qH9/qU8P3oHA/U++Kr
         mUDjNb4FaY1ozTay82zE5Txi3LadEzuW8x6Tl8TfXksE55EH3O4amXO9chc9U/urTu76
         tpCAGS7euRujlBsXsnSF+SLKF85QiJ3a9rUhibbmq3UuNkhXQ58ZJm9lUFJpxblAHAtq
         L9RLrcGJEiecZWVsnSDUZEMvb9nK9K0qyFqV323j3xhL2tjbxAhStXkpY51jJpF6j6r3
         lM5A==
X-Gm-Message-State: AOAM531mzHtPJusFE2DsoGQRMEeVwEFPcYK8OQ9fYOec9C3h/o4wEWx0
        tUDqXqPB50zct0R/BpMEYy99uGZfUrkrviNPWu1Tqg==
X-Google-Smtp-Source: ABdhPJy0j+os78uUf1J01y2/+lUvgi4iWhE4SqyG8tlnGfdmELTyhTXeKNz9Xka/cqI0TfKL+rIBzLf0nbBRhkJSn8U=
X-Received: by 2002:adf:dc8b:: with SMTP id r11mr20694608wrj.131.1607798091560;
 Sat, 12 Dec 2020 10:34:51 -0800 (PST)
MIME-Version: 1.0
References: <160773649920.2387.14668844101686155199.stgit@localhost.localdomain>
In-Reply-To: <160773649920.2387.14668844101686155199.stgit@localhost.localdomain>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Sat, 12 Dec 2020 10:34:14 -0800
Message-ID: <CAK6E8=c4LpxcaF3Mr1T9BtkD5SPK1eoK_hGOMNa6C9a4fpFQNg@mail.gmail.com>
Subject: Re: [net-next PATCH] tcp: Add logic to check for SYN w/ data in tcp_simple_retransmit
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Martin Lau <kafai@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 5:28 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> From: Alexander Duyck <alexanderduyck@fb.com>
>
> There are cases where a fastopen SYN may trigger either a ICMP_TOOBIG
> message in the case of IPv6 or a fragmentation request in the case of
> IPv4. This results in the socket stalling for a second or more as it does
> not respond to the message by retransmitting the SYN frame.
>
> Normally a SYN frame should not be able to trigger a ICMP_TOOBIG or
> ICMP_FRAG_NEEDED however in the case of fastopen we can have a frame that
> makes use of the entire MSS. In the case of fastopen it does, and an
> additional complication is that the retransmit queue doesn't contain the
> original frames. As a result when tcp_simple_retransmit is called and
> walks the list of frames in the queue it may not mark the frames as lost
> because both the SYN and the data packet each individually are smaller than
> the MSS size after the adjustment. This results in the socket being stalled
> until the retransmit timer kicks in and forces the SYN frame out again
> without the data attached.
>
> In order to resolve this we can generate our best estimate for the original
> packet size by detecting the fastopen SYN frame and then adding the
> overhead for MAX_TCP_OPTION_SPACE and verifying if the SYN w/ data would
> have exceeded the MSS. If so we can mark the frame as lost and retransmit
> it.
>
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
>  net/ipv4/tcp_input.c |   30 +++++++++++++++++++++++++++---
>  1 file changed, 27 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 9e8a6c1aa019..79375b58de84 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -2686,11 +2686,35 @@ static void tcp_mtup_probe_success(struct sock *sk)
>  void tcp_simple_retransmit(struct sock *sk)
>  {
>         const struct inet_connection_sock *icsk = inet_csk(sk);
> +       struct sk_buff *skb = tcp_rtx_queue_head(sk);
>         struct tcp_sock *tp = tcp_sk(sk);
> -       struct sk_buff *skb;
> -       unsigned int mss = tcp_current_mss(sk);
> +       unsigned int mss;
> +
> +       /* A fastopen SYN request is stored as two separate packets within
> +        * the retransmit queue, this is done by tcp_send_syn_data().
> +        * As a result simply checking the MSS of the frames in the queue
> +        * will not work for the SYN packet. So instead we must make a best
> +        * effort attempt by validating the data frame with the mss size
> +        * that would be computed now by tcp_send_syn_data and comparing
> +        * that against the data frame that would have been included with
> +        * the SYN.
> +        */
> +       if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN && tp->syn_data) {
> +               struct sk_buff *syn_data = skb_rb_next(skb);
> +
> +               mss = tcp_mtu_to_mss(sk, icsk->icsk_pmtu_cookie) +
> +                     tp->tcp_header_len - sizeof(struct tcphdr) -
> +                     MAX_TCP_OPTION_SPACE;
nice comment! The original syn_data mss needs to be inferred which is
a hassle to get right. my sense is path-mtu issue is enough to warrant
they are lost.
I suggest simply mark syn & its data lost if tcp_simple_retransmit is
called during TFO handshake, i.e.

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 62f7aabc7920..7f0c4f2947eb 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2864,7 +2864,8 @@ void tcp_simple_retransmit(struct sock *sk)
        unsigned int mss = tcp_current_mss(sk);

        skb_rbtree_walk(skb, &sk->tcp_rtx_queue) {
-               if (tcp_skb_seglen(skb) > mss)
+               if (tcp_skb_seglen(skb) > mss ||
+                   (tp->syn_data && sk->sk_state == TCP_SYN_SENT))
                        tcp_mark_skb_lost(sk, skb);
        }

We have a TFO packetdrill test that verifies my suggested fix should
trigger an immediate retransmit vs 1s wait.




>
> -       skb_rbtree_walk(skb, &sk->tcp_rtx_queue) {
> +               if (syn_data && syn_data->len > mss)
> +                       tcp_mark_skb_lost(sk, skb);
> +
> +               skb = syn_data;
> +       } else {
> +               mss = tcp_current_mss(sk);
> +       }
> +
> +       skb_rbtree_walk_from(skb) {
>                 if (tcp_skb_seglen(skb) > mss)
>                         tcp_mark_skb_lost(sk, skb);
>         }
>
>

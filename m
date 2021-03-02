Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5607732A3E2
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577711AbhCBJwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 04:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382679AbhCBJk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 04:40:59 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EC3C061756
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 01:38:59 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id l8so19997737ybe.12
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 01:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d6j4NC0xWisYBbDQLfYR2TP2URgucSEl3kDiBda4KeM=;
        b=Kl6ajxITJStY7aqyzKvgaXV/wWJuOiyCeRA0DKZMEfS1NIanQz3D8QpnhyexUmUnc7
         8BzV7SCQHTycBCUCbcaORl4QvXHBwqj46MdZImXL0ps/+4uYOuEW6n6VP0Hw4IC6dQhB
         53NEdoKADVkPcGrva7gFBL1DOsd4xp590TpaHmN1uszvsWyMXmLkoLAqSxqs3zveFV1w
         Yz1fm1qgqTVLNwxRp92iplkbgr+8Mx54zdM/vX0Z8musNSbO3CKEAwzUj5zj3VG7Ek+x
         KKQkS8G8/4Iv8Y//L+bZxMnCtKpxcwRgu9CGGa9pL5bAembQO9A5uJ9vmqoWt9zzCnDH
         x1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d6j4NC0xWisYBbDQLfYR2TP2URgucSEl3kDiBda4KeM=;
        b=jCEJZ9BT18knXDdkuzClgJea3qhYJRDfH4pU3dXfH/VmCQDPQvNzHyehX8JmVYV162
         6LPOXqCBReJDkOyQWPk0cSyV2NxN33tPdfSRe4W6oYhz1KQefWPag2BuNLe0bc+tqfwy
         7spb4NgoAC8XrICelWzGIqD3D7SH2LXqr0IVZt5Oa7yvMOmq335r0Ed7qgYKFrRQXSOx
         anEegX2CyHtXoX07Ble09W2++A9Q+hYj/Ow4VNXZQgkXZu6oOASuK3rf8NCNu3mdsshF
         kmNqnowK8Gdm/2NDIsdb9wa7s5W5Gf+6eDH+eQOJC/CI27PdRUdUVSvfVGoGL1XmEbpD
         hY/g==
X-Gm-Message-State: AOAM532OCgRQgPD7d5GPBXOM+hnrX1ZUb3vkfRWAfWOyXL6bv4OhPFW1
        lpe/A8h3tKB07pTwDhOuAPRFZlZNi/P3yXEIawM4+A==
X-Google-Smtp-Source: ABdhPJyCgc6a11s/WQeQX9gOi/JOm5u8CCx9hrpQsaEM+4J5oyn86/D4NnLAhehSc+fTOvmz2/kEhgqlqgZYnqkA/NQ=
X-Received: by 2002:a25:b906:: with SMTP id x6mr29048098ybj.504.1614677938497;
 Tue, 02 Mar 2021 01:38:58 -0800 (PST)
MIME-Version: 1.0
References: <20210302060753.953931-1-kuba@kernel.org>
In-Reply-To: <20210302060753.953931-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 2 Mar 2021 10:38:46 +0100
Message-ID: <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen SYN
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 7:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> When receiver does not accept TCP Fast Open it will only ack
> the SYN, and not the data. We detect this and immediately queue
> the data for (re)transmission in tcp_rcv_fastopen_synack().
>
> In DC networks with very low RTT and without RFS the SYN-ACK
> may arrive before NIC driver reported Tx completion on
> the original SYN. In which case skb_still_in_host_queue()
> returns true and sender will need to wait for the retransmission
> timer to fire milliseconds later.
>
> Revert back to non-fast clone skbs, this way
> skb_still_in_host_queue() won't prevent the recovery flow
> from completing.
>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Fixes: 355a901e6cf1 ("tcp: make connect() mem charging friendly")

Hmmm, not sure if this Fixes: tag makes sense.

Really, if we delay TX completions by say 10 ms, other parts of the
stack will misbehave anyway.

Also, backporting this patch up to linux-3.19 is going to be tricky.

The real issue here is that skb_still_in_host_queue() can give a false positive.

I have mixed feelings here, as you can read my answer :/

Maybe skb_still_in_host_queue() signal should not be used when a part
of the SKB has been received/acknowledged by the remote peer
(in this case the SYN part).

Alternative is that drivers unable to TX complete their skbs in a
reasonable time should call skb_orphan()
 to avoid skb_unclone() penalties (and this skb_still_in_host_queue() issue)

If you really want to play and delay TX completions, maybe provide a
way to disable skb_still_in_host_queue() globally,
using a static key ?

My personal WIP/hack was something like :


diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 69a545db80d2ead47ffcf2f3819a6d066e95f35d..666f6f0a6a06fece204199e07a79e21d1faf8f92
100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5995,7 +5995,8 @@ static bool tcp_rcv_fastopen_synack(struct sock
*sk, struct sk_buff *synack,
                else
                        tp->fastopen_client_fail = TFO_DATA_NOT_ACKED;
                skb_rbtree_walk_from(data) {
-                       if (__tcp_retransmit_skb(sk, data, 1))
+                       /* segs = -1 to bypass
skb_still_in_host_queue() check */
+                       if (__tcp_retransmit_skb(sk, data, -1))
                                break;
                }
                tcp_rearm_rto(sk);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fbf140a770d8e21b936369b79abbe9857537acd8..1d1489e596976e352fe7d5ccee7a6eae55fdbcce
100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3155,8 +3155,12 @@ int __tcp_retransmit_skb(struct sock *sk,
struct sk_buff *skb, int segs)
                  sk->sk_sndbuf))
                return -EAGAIN;

-       if (skb_still_in_host_queue(sk, skb))
-               return -EBUSY;
+       if (segs > 0) {
+               if (skb_still_in_host_queue(sk, skb))
+                       return -EBUSY;
+       } else {
+               segs = -segs;
+       }

        if (before(TCP_SKB_CB(skb)->seq, tp->snd_una)) {
                if (unlikely(before(TCP_SKB_CB(skb)->end_seq, tp->snd_una))) {


> Signed-off-by: Neil Spring <ntspring@fb.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ipv4/tcp_output.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index fbf140a770d8..cd9461588539 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3759,9 +3759,16 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
>         /* limit to order-0 allocations */
>         space = min_t(size_t, space, SKB_MAX_HEAD(MAX_TCP_HEADER));
>
> -       syn_data = sk_stream_alloc_skb(sk, space, sk->sk_allocation, false);
> +       syn_data = alloc_skb(MAX_TCP_HEADER + space, sk->sk_allocation);
>         if (!syn_data)
>                 goto fallback;
> +       if (!sk_wmem_schedule(sk, syn_data->truesize)) {
> +               __kfree_skb(syn_data);
> +               goto fallback;
> +       }
> +       skb_reserve(syn_data, MAX_TCP_HEADER);
> +       INIT_LIST_HEAD(&syn_data->tcp_tsorted_anchor);
> +
>         syn_data->ip_summed = CHECKSUM_PARTIAL;
>         memcpy(syn_data->cb, syn->cb, sizeof(syn->cb));
>         if (space) {
> --
> 2.26.2
>

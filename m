Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6394D0E7B
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 04:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244810AbiCHDvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 22:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiCHDvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 22:51:18 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0BB31236
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 19:50:22 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id h126so35243281ybc.1
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 19:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=irhgFJ9Pa6Ggc710v+EjC8Buze4o6B3rcgYWV5ySn7U=;
        b=UHLOpznpxA8r21+zJ3T3kRvVN3Mh4+PNZuEO7SCOls1egcMfT3N/N5vEYEfTQ7jK5K
         iWe27tkBOJzebzfXTVrmmKWD9R7ohnOYz24D54CqB/8Gb1BK3UWnsdyEyt+DZWGI3R5I
         pmUr8Eo6XTUmizvabzvQq6RhjJlYgAdTvLUYimUOiy2XeFj8IyxmzfGObihTGfkUwoXc
         HKowN+7iTzUYnk+LyjrL1qcMkJurqF7STnRQKj/t5QP7QECrRf3enQxEsh/GrJy1PAW9
         BilzMjwURf9HS5CL7Z7uIDvYitTs8ddBZb/BvpBDN1E85pSZPg+JpDZ2VYwIqqxzL7eu
         Ru+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=irhgFJ9Pa6Ggc710v+EjC8Buze4o6B3rcgYWV5ySn7U=;
        b=V1pBePN7RJ8XgdID/yDqLjnhGR9b0yW3cuovLmrmtmIa5SLcGmceuVZLkZA3b3z02Q
         jyutbWNneajOIfAQ9uIcn74AyR8UjylaulNeCBUuF/+YqnSCsudDoKjk1BIxMzXTduvA
         D8xMPaeQZ9S/+HguYceLzGPrQfUFKgcgxjkHQKUrRKFfws4rM+dcvkxuuzE5Lj5Suryq
         TCZviboYtcZDp8OOTIvhMCutrE2MnoUeusl0pngSygpxq24yUEMU5xpHjgsyT2Uxu4mz
         I4cYTI+3iA26D8dfXSfWnVn/hSHYgZ0wr/ktn8i3zDABqkae8tYkZjEgszA+XLHgrgQR
         AHRw==
X-Gm-Message-State: AOAM532D2gML/cm56fuLg7J8BFOmmA8MKiSAjl2UjYIxwzqfcP7povcx
        zbXOvCEUKEZICJIDKDy+Hiz444GZLqw8jBtaW1pmkQ==
X-Google-Smtp-Source: ABdhPJwoG4Rd4MM7c6CaJdUlITVZCcU9XnM4aJaSqUlzfJmMX1OETOFSRNdy+46Sb3JSlerKjDDv1Lm6dH8acBITmnE=
X-Received: by 2002:a25:f45:0:b0:628:b4c9:7a9f with SMTP id
 66-20020a250f45000000b00628b4c97a9fmr10617203ybp.55.1646711421305; Mon, 07
 Mar 2022 19:50:21 -0800 (PST)
MIME-Version: 1.0
References: <20220308030348.258934-1-kuba@kernel.org>
In-Reply-To: <20220308030348.258934-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 7 Mar 2022 19:50:10 -0800
Message-ID: <CANn89iLoWOdLQWB0PeTtbOtzkAT=cWgzy5_RXqqLchZu1GziZw@mail.gmail.com>
Subject: Re: [RFC net-next] tcp: allow larger TSO to be built under overload
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
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

On Mon, Mar 7, 2022 at 7:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> We observed Tx-heavy workloads causing softirq overload because
> with increased load and therefore latency the pacing rates fall,
> pushing TCP to generate smaller and smaller TSO packets.

Yes, we saw this behavior but came up with something more generic,
also helping the common case. Cooking larger TSO is really a function
of the radius (distance between peers)

> It seems reasonable to allow larger packets to be built when
> system is under stress. TCP already uses the
>
>   this_cpu_ksoftirqd() == current
>
> condition as an indication of overload for TSQ scheduling.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Sending as an RFC because it seems reasonable, but really
> I haven't run any large scale testing, yet. Bumping
> tcp_min_tso_segs to prevent overloads is okay but it
> seems like we can do better since we only need coarser
> pacing once disaster strikes?
>
> The downsides are that users may have already increased
> the value to what's needed during overload, or applied
> the same logic in out-of-tree CA algo implementations
> (only BBR implements ca_ops->min_tso_segs() upstream).
>

Unfortunately this would make packetdrill flaky, thus break our tests.

Also, I would guess the pacing decreases because CWND is small anyway,
or RTT increases ?
What CC are you using ?
The issue I see here is that bi modal behavior will cause all kinds of
artifacts.

BBR2 has something to give an extra allowance based on min_rtt.

I think we should adopt this for all CC, because it is not bi-modal,
and even allow full size TSO packets
for hosts in the same rack.

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 2319531267c6830b633768dea7f0b40a46633ee1..02ec5866a05ffc2920ead95e9a65cc1ba77459c7
100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1956,20 +1956,34 @@ static bool tcp_nagle_check(bool partial,
const struct tcp_sock *tp,
 static u32 tcp_tso_autosize(const struct sock *sk, unsigned int mss_now,
                            int min_tso_segs)
 {
-       u32 bytes, segs;
+/* Use min_rtt to help adapt TSO burst size, with smaller min_rtt resulting
+ * in bigger TSO bursts. By default we cut the RTT-based allowance in half
+ * for every 2^9 usec (aka 512 us) of RTT, so that the RTT-based allowance
+ * is below 1500 bytes after 6 * ~500 usec = 3ms.
+ * Default: halve allowance per 2^9 usecs, 512us.
+ */
+       const u32 rtt_shift = 9;
+       unsigned long bytes;
+       u32 r;
+
+       bytes = sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift);
+       /* Budget a TSO/GSO burst size allowance based on min_rtt. For every
+        * K = 2^tso_rtt_shift microseconds of min_rtt, halve the burst.
+        * The min_rtt-based burst allowance is: 64 KBytes / 2^(min_rtt/K)
+        */
+       r = tcp_min_rtt(tcp_sk(sk)) >> rtt_shift;
+       if (r < BITS_PER_TYPE(u32))
+               bytes += GSO_MAX_SIZE >> r;
+
+       bytes = min_t(unsigned long, bytes, sk->sk_gso_max_size);

-       bytes = min_t(unsigned long,
-                     sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift),
-                     sk->sk_gso_max_size);

        /* Goal is to send at least one packet per ms,
         * not one big TSO packet every 100 ms.
         * This preserves ACK clocking and is consistent
         * with tcp_tso_should_defer() heuristic.
         */
-       segs = max_t(u32, bytes / mss_now, min_tso_segs);
-
-       return segs;
+       return max_t(u32, bytes / mss_now, min_tso_segs);
 }

 /* Return the number of segments we want in the skb we are transmitting.

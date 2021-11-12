Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59F544E050
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 03:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbhKLCf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 21:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbhKLCfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 21:35:25 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DB8C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 18:32:35 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y7so7399808plp.0
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 18:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KOTw1ZcaUFj5U5Kc9KmboBfIHi2Pmw2F9Zs6YOM05l0=;
        b=QKl5Y9+KYSo2dql645p9VxkUr7m7MeMf31+zpDqwkPAstyFr9v8m0lANjB2JHgajCC
         Kk0DnRXESrpqfus4foQb6L6Fo8dasAvFejoic3C2N/NpDUfPjPafDhGKi4JUD8Wi9Psq
         dYCqAgdGR7TFRTFfavviSYoZTEScUE2SbY21abdE2RmLUAt61ZEUtj7mmTXfOH2xdVZi
         DafxDq0N/LPWZHH8ElafJOLHOpb6D+maSOBkMHVKkLAD0fJMYIgvBZkKNcwGOCFo97JU
         LVb+DoyTduD4WK8Nfgh2iWEk6sJw8+X6G1K5k9r3mf+f+p4Af1jVCxqImPssP1f1d6zr
         BeUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KOTw1ZcaUFj5U5Kc9KmboBfIHi2Pmw2F9Zs6YOM05l0=;
        b=h5vp/Zt9LVZ71435cJ8aZwiGb/B9CnzvS760eYuj+twQZbFoKnTf6KlLEIWtGzBRaP
         E0SAWpCRdsrBqVOhlwdJLz+kxR67L1nuHxUN7y2bnu98mE7OdEO6pwHwQdVEy3XWeMGG
         pQrA/p2d8rvYc3SUsAnq4ew7X1pPKh2pmUvqFaEa87M8DraJBpht+88icSPCVXF3Mozp
         2bnpht0llfUbDbCr/Tjjv5a2TO8agDoeNMgz7deBuwCSGh/x3KaXvsnCuUHA8RoT/S8W
         ujfffLmlDkDKoPbbTaZeWR9nlrn/WwWwlgOl9oYbbCKnZ+VWm99XkIrwL5VP1uG2JRPU
         bUCQ==
X-Gm-Message-State: AOAM532z2+GFW+sB0lwJ6Iy+oUdTrTTepRx0FiVmQpXEiymwrn0avDCC
        9EFKRXYE7QMDvmFJLyMkS/3D6pCxhqJ6cJ7xJGllosDHvUIFPA==
X-Google-Smtp-Source: ABdhPJxkZ+AfZC5Kla6moKGkBk+gCfSOSwht5hTm0gNzVW1VkjW0ez9H83IayQRIz+g4pJLpFuNcVxl6DMLLWBFgbEQ=
X-Received: by 2002:a17:90b:38c7:: with SMTP id nn7mr13887158pjb.105.1636684354848;
 Thu, 11 Nov 2021 18:32:34 -0800 (PST)
MIME-Version: 1.0
References: <20211111235215.2605384-1-arjunroy.kdev@gmail.com>
In-Reply-To: <20211111235215.2605384-1-arjunroy.kdev@gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Thu, 11 Nov 2021 18:32:23 -0800
Message-ID: <CAOFY-A0zLEQ_cbVFS_Rd16EiOP7R-gEkHTsZ6gNEmUCbeLK1OQ@mail.gmail.com>
Subject: Re: [net v2] tcp: Fix uninitialized access in skb frags array for Rx 0cp.
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        soheil@google.com, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 3:52 PM Arjun Roy <arjunroy.kdev@gmail.com> wrote:
>
> From: Arjun Roy <arjunroy@google.com>
>
> TCP Receive zerocopy iterates through the SKB queue via
> tcp_recv_skb(), acquiring a pointer to an SKB and an offset within
> that SKB to read from. From there, it iterates the SKB frags array to
> determine which offset to start remapping pages from.
>
> However, this is built on the assumption that the offset read so far
> within the SKB is smaller than the SKB length. If this assumption is
> violated, we can attempt to read an invalid frags array element, which
> would cause a fault.
>
> tcp_recv_skb() can cause such an SKB to be returned when the TCP FIN
> flag is set. Therefore, we must guard against this occurrence inside
> skb_advance_frag().
>
> One way that we can reproduce this error follows:
> 1) In a receiver program, call getsockopt(TCP_ZEROCOPY_RECEIVE) with:
> char some_array[32 * 1024];
> struct tcp_zerocopy_receive zc = {
>   .copybuf_address  = (__u64) &some_array[0],
>   .copybuf_len = 32 * 1024,
> };
>
> 2) In a sender program, after a TCP handshake, send the following
> sequence of packets:
>   i) Seq = [X, X+4000]
>   ii) Seq = [X+4000, X+5000]
>   iii) Seq = [X+4000, X+5000], Flags = FIN | URG, urgptr=1000
>
> (This can happen without URG, if we have a signal pending, but URG is
> a convenient way to reproduce the behaviour).
>
> In this case, the following event sequence will occur on the receiver:
>
> tcp_zerocopy_receive():
> -> receive_fallback_to_copy() // copybuf_len >= inq
> -> tcp_recvmsg_locked() // reads 5000 bytes, then breaks due to URG
> -> tcp_recv_skb() // yields skb with skb->len == offset
> -> tcp_zerocopy_set_hint_for_skb()
> -> skb_advance_to_frag() // will returns a frags ptr. >= nr_frags
> -> find_next_mappable_frag() // will dereference this bad frags ptr.
>
> With this patch, skb_advance_to_frag() will no longer return an
> invalid frags pointer, and will return NULL instead, fixing the issue.
>
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Fixes: 05255b823a61 ("tcp: add TCP_ZEROCOPY_RECEIVE support for zerocopy receive")
>
> ---
>  net/ipv4/tcp.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index bc7f419184aa..ef896847f190 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1741,6 +1741,9 @@ static skb_frag_t *skb_advance_to_frag(struct sk_buff *skb, u32 offset_skb,
>  {
>         skb_frag_t *frag;
>
> +       if (unlikely(offset_skb >= skb->len))
> +               return NULL;
> +
>         offset_skb -= skb_headlen(skb);
>         if ((int)offset_skb < 0 || skb_has_frag_list(skb))
>                 return NULL;
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>

Interestingly, netdevbpf list claims a netdev/build_32bit failure here:
https://patchwork.kernel.org/project/netdevbpf/patch/20211111235215.2605384-1-arjunroy.kdev@gmail.com/

But the v1 patch seemed to be fine (that one had a wrong "Fixes" tag,
it's the only thing that changed in v2). Also, "make ARCH=i386" is
working fine for me, and the significant amount of error output
(https://patchwork.hopto.org/static/nipa/578999/12615889/build_32bit/)
does not actually have any errors inside net/ipv4/tcp.c . I assume,
then, this must be a tooling false positive, and I do not have to send
a v3 (which would have no changes)?

Thanks,
-Arjun

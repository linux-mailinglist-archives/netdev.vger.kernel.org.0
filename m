Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACE82D7025
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 07:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395483AbgLKGZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 01:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391223AbgLKGZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 01:25:19 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BBCC0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 22:24:39 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id q1so7763147ilt.6
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 22:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R2nu+evV2RiqlMwq+jAP2JmdldTYUhryc5/wfbY/nC4=;
        b=OSuxAgWyRLfNHDFi4Mn2mD2SzQBYRjIA/jPZa+b+zQh0bBZxvj1NaXT1kBXv71Huju
         +DZFt1vawTYZBoy7XTuJDfUrqDSOWiimjxGIOtBmDb0/SGE35+8CzVzYP9zdS2fsyfy1
         pMg311bA9HuotVrE4hYkWw8hbEuF7Ls6YHzMCAEqz8Y7+gg+DAS8KapSieJBgivwYnQx
         2bhFRgEJ91rfmlaQymGlTKaKkiPpMV5JO+HuvAwIrYXjzmlsPE5vbqpz9nyVFzGykH+8
         2EeXoAyRGup17oUlzVR/uubntugUC7SCLOfi9kZFUM4swri7Wff0rtQrctncbCQbQF4S
         JsOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R2nu+evV2RiqlMwq+jAP2JmdldTYUhryc5/wfbY/nC4=;
        b=LY62QbriUZDds3N0/KNrLV96d5GFOO4fHUKY4PZUk/5rLxfMEFTOsB7C+L1nl+RTmu
         ZW7jokgrubz2dHTl2X704JYuNzN4iy4xEqe1rOIT8qFws4daEI3JKG8c1ynYAS7RAUAE
         78jkr42kyc+DJTdpLTp97ikzhiqRmnBLf7If6u98mcxPnnLuY4140tNdhYoUcNCWthLW
         uzuNF+LjOYYABWakPdPAYZ2jo+xlJnnl0W3jDsz/OSFZj1ByUqVKJIbjz1zXEiXk0Y0d
         xdgS7b/HeV0yuUAdu0AFh7SD2qVNN2Rl+qghYh9Mx8xPV2AJkSe0biftwu3Fng874KJv
         yOTQ==
X-Gm-Message-State: AOAM530RVMiGikRIF+Br9oVTkeWdXvKcB42zQVT2NhJsrWpEFHxVG88Q
        SKEm3Ypl2ouCzlnGnCWrdCRJt6Kv7M6weFsewgAmKQ==
X-Google-Smtp-Source: ABdhPJw750jTsaFhagrZFnuvTxKa/l62yhXEhpVEN2/d1mxUqNtSlZ3KCEKEJ6kVvn7MOpbF7YZQYIJHXwYvVajfNDA=
X-Received: by 2002:a92:358e:: with SMTP id c14mr13382285ilf.69.1607667878507;
 Thu, 10 Dec 2020 22:24:38 -0800 (PST)
MIME-Version: 1.0
References: <160765171921.6905.7897898635812579754.stgit@localhost.localdomain>
In-Reply-To: <160765171921.6905.7897898635812579754.stgit@localhost.localdomain>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Dec 2020 07:24:27 +0100
Message-ID: <CANn89iJ5HnJYv6eWb1jm6rK173DFkp2GRnfvi9vnYwXZPzE4LQ@mail.gmail.com>
Subject: Re: [net PATCH] tcp: Mark fastopen SYN packet as lost when receiving ICMP_TOOBIG/ICMP_FRAG_NEEDED
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Yuchung Cheng <ycheng@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 2:55 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> From: Alexander Duyck <alexanderduyck@fb.com>
>
> In the case of a fastopen SYN there are cases where it may trigger either a
> ICMP_TOOBIG message in the case of IPv6 or a fragmentation request in the
> case of IPv4. This results in the socket stalling for a second or more as
> it does not respond to the message by retransmitting the SYN frame.
>
> Normally a SYN frame should not be able to trigger a ICMP_TOOBIG or
> ICMP_FRAG_NEEDED however in the case of fastopen we can have a frame that
> makes use of the entire MTU. In the case of fastopen it does, and an
> additional complication is that the retransmit queue doesn't contain the
> original frames. As a result when tcp_simple_retransmit is called and
> walks the list of frames in the queue it may not mark the frames as lost
> because both the SYN and the data packet each individually are smaller than
> the MSS size after the adjustment. This results in the socket being stalled
> until the retransmit timer kicks in and forces the SYN frame out again
> without the data attached.
>
> In order to resolve this we need to mark the SYN frame as lost if it is the
> first packet in the queue. Doing this allows the socket to recover much
> more quickly without the retransmit timeout stall.
>
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>


I do not think it is net candidate, but net-next

Yuchung might correct me, but I think TCP Fastopen standard was very
conservative about payload len in the SYN packet

So receiving an ICMP was never considered.

> ---
>  include/net/tcp.h    |    1 +
>  net/ipv4/tcp_input.c |    8 ++++++++
>  net/ipv4/tcp_ipv4.c  |    6 ++++++
>  net/ipv6/tcp_ipv6.c  |    4 ++++
>  4 files changed, 19 insertions(+)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index d4ef5bf94168..6181ad98727a 100644
> --- a/include/net/tcp.h


> +++ b/net/ipv4/tcp_ipv4.c
> @@ -546,6 +546,12 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
>                         if (sk->sk_state == TCP_LISTEN)
>                                 goto out;
>
> +                       /* fastopen SYN may have triggered the fragmentation
> +                        * request. Mark the SYN or SYN/ACK as lost.
> +                        */
> +                       if (sk->sk_state == TCP_SYN_SENT)
> +                               tcp_mark_syn_lost(sk);

This is going to crash in some cases, you do not know if you own the socket.
(Look a few lines below)

> +
>                         tp->mtu_info = info;
>                         if (!sock_owned_by_user(sk)) {
>                                 tcp_v4_mtu_reduced(sk);
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 992cbf3eb9e3..d7b1346863e3 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -443,6 +443,10 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
>                 if (!ip6_sk_accept_pmtu(sk))
>                         goto out;
>
> +               /* fastopen SYN may have triggered TOOBIG, mark it lost. */
> +               if (sk->sk_state == TCP_SYN_SENT)
> +                       tcp_mark_syn_lost(sk);


Same issue here.

> +
>                 tp->mtu_info = ntohl(info);
>                 if (!sock_owned_by_user(sk))
>                         tcp_v6_mtu_reduced(sk);
>
>

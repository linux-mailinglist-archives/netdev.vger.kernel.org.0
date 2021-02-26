Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1F2326637
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 18:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhBZRSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 12:18:22 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:17974 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhBZRSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 12:18:18 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1614359710; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=JIG40WouO/XHbdneV+wOQlmyiqQDHIYualaVqafJxXOsuiFIMdO9pt1k97NRK1ux7f
    ija1AN+beO0llFx0k5S7mecwM4P0SC3kVuV2ocXF5Tt+wnaSP9ABmR6zf7EImGBmv4yE
    GPS1WQigsrZy7zMFTAbHazUHgGaB0k2S9/wvvITMq8iHBNHF7z0zuZPriq9iQSxSEHNi
    LQD+iviWHf5meztcU5H7Bm1Yq4JRZrsTb85PS8R+S9ph//N7j4arERksgD+D8Z1pVXby
    ezm4Ds2K+G0bw2NJZ0fmBZOOv/oEWYA/twNwnfJCg2/Yihl/DFoaGqNY1W2gmp63TMFd
    S5vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1614359710;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=FCCWz2y199L4CnM1fW+BV96WabUqKD8PmzCV5AMWD/Q=;
    b=ZHKRrbYrZ8CeW+LpE8ICv4iKgy/SuPpNC9qN5DISXfoxM40E/4Sanmd6UxHhpr1QNl
    zwLeBdWEh4yNTbCKqeuD5nX0ZXSgYs1koa4lUc5DtCFBJlh4e+Hymy+m/iTsiOMIO2x+
    /REM+E4OE3LiOJvhKlR7hakF5cd80rUdikMzt55KL27QsNHalrQN34GQ4c7Gy5grmlwN
    g6GJ/XgXvwmL9yLFlnUpO9kxPYrV6xsTaRzcLPeJjTu/PdNBLgdqLy7n1TE4Lh4CbCgr
    hyv0t/z+7lpMa3hwuFZ0Zq+qNfjqU03Z3+CdCuGc7EtYj8K7UKlzIHKW9RklPzqy3R1j
    gG4w==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1614359710;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=FCCWz2y199L4CnM1fW+BV96WabUqKD8PmzCV5AMWD/Q=;
    b=L1+erj4mu8ygrsacdv/F94ArTomtKTb5aABtl0U+KlizOf+c6Sx5nBwXUotz6KuO2y
    yO/kPlXeioBUnfPgPkmKaeFLkLF+8POcRMqwVBoQFBdf6HVS827iTkfQk32hUXwm14E0
    /L02iG8/cThMG9QOvYBUQySQDkjTX91BezgP3nHjbsRlebccShDdfr44IGx+kTJ8a5vP
    Hlai9qNZbCt6Lqk1cCaCN9nGQj4fDzmjkOUzEf/XM/VgazqLP55iwrg+VSuemogQxGQj
    d+JvWsX7l9UyJiyocqkT5D6ZTDqOYZstMn6Pt0iCvEaHsPFqmRsY6+U5GvAtDYmXqOcI
    pUYQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMGUMh6mCA="
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
    by smtp.strato.de (RZmta 47.19.0 DYNA|AUTH)
    with ESMTPSA id V003bex1QHF9JpZ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 26 Feb 2021 18:15:09 +0100 (CET)
Subject: Re: [PATCH net v4 1/1] can: can_skb_set_owner(): fix ref counting if
 socket was closed before setting skb ownership
To:     Oleksij Rempel <o.rempel@pengutronix.de>, mkl@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Robin van der Gracht <robin@protonic.nl>
Cc:     Andre Naujoks <nautsch2@gmail.com>,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210226092456.27126-1-o.rempel@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <2e9e82d1-7e52-0f5b-c1bf-848c2f162019@hartkopp.net>
Date:   Fri, 26 Feb 2021 18:15:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210226092456.27126-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26.02.21 10:24, Oleksij Rempel wrote:
> There are two ref count variables controlling the free()ing of a socket:
> - struct sock::sk_refcnt - which is changed by sock_hold()/sock_put()
> - struct sock::sk_wmem_alloc - which accounts the memory allocated by
>    the skbs in the send path.
> 
> In case there are still TX skbs on the fly and the socket() is closed,
> the struct sock::sk_refcnt reaches 0. In the TX-path the CAN stack
> clones an "echo" skb, calls sock_hold() on the original socket and
> references it. This produces the following back trace:
> 
> | WARNING: CPU: 0 PID: 280 at lib/refcount.c:25 refcount_warn_saturate+0x114/0x134
> | refcount_t: addition on 0; use-after-free.
> | Modules linked in: coda_vpu(E) v4l2_jpeg(E) videobuf2_vmalloc(E) imx_vdoa(E)
> | CPU: 0 PID: 280 Comm: test_can.sh Tainted: G            E     5.11.0-04577-gf8ff6603c617 #203
> | Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> | Backtrace:
> | [<80bafea4>] (dump_backtrace) from [<80bb0280>] (show_stack+0x20/0x24) r7:00000000 r6:600f0113 r5:00000000 r4:81441220
> | [<80bb0260>] (show_stack) from [<80bb593c>] (dump_stack+0xa0/0xc8)
> | [<80bb589c>] (dump_stack) from [<8012b268>] (__warn+0xd4/0x114) r9:00000019 r8:80f4a8c2 r7:83e4150c r6:00000000 r5:00000009 r4:80528f90
> | [<8012b194>] (__warn) from [<80bb09c4>] (warn_slowpath_fmt+0x88/0xc8) r9:83f26400 r8:80f4a8d1 r7:00000009 r6:80528f90 r5:00000019 r4:80f4a8c2
> | [<80bb0940>] (warn_slowpath_fmt) from [<80528f90>] (refcount_warn_saturate+0x114/0x134) r8:00000000 r7:00000000 r6:82b44000 r5:834e5600 r4:83f4d540
> | [<80528e7c>] (refcount_warn_saturate) from [<8079a4c8>] (__refcount_add.constprop.0+0x4c/0x50)
> | [<8079a47c>] (__refcount_add.constprop.0) from [<8079a57c>] (can_put_echo_skb+0xb0/0x13c)
> | [<8079a4cc>] (can_put_echo_skb) from [<8079ba98>] (flexcan_start_xmit+0x1c4/0x230) r9:00000010 r8:83f48610 r7:0fdc0000 r6:0c080000 r5:82b44000 r4:834e5600
> | [<8079b8d4>] (flexcan_start_xmit) from [<80969078>] (netdev_start_xmit+0x44/0x70) r9:814c0ba0 r8:80c8790c r7:00000000 r6:834e5600 r5:82b44000 r4:82ab1f00
> | [<80969034>] (netdev_start_xmit) from [<809725a4>] (dev_hard_start_xmit+0x19c/0x318) r9:814c0ba0 r8:00000000 r7:82ab1f00 r6:82b44000 r5:00000000 r4:834e5600
> | [<80972408>] (dev_hard_start_xmit) from [<809c6584>] (sch_direct_xmit+0xcc/0x264) r10:834e5600 r9:00000000 r8:00000000 r7:82b44000 r6:82ab1f00 r5:834e5600 r4:83f27400
> | [<809c64b8>] (sch_direct_xmit) from [<809c6c0c>] (__qdisc_run+0x4f0/0x534)
> 
> To fix this problem, only set skb ownership to sockets which have still
> a ref count > 0.
> 
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Andre Naujoks <nautsch2@gmail.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Fixes: 0ae89beb283a ("can: add destructor for self generated skbs")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>   include/linux/can/skb.h | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
> index 685f34cfba20..d82018cc0d0b 100644
> --- a/include/linux/can/skb.h
> +++ b/include/linux/can/skb.h
> @@ -65,8 +65,12 @@ static inline void can_skb_reserve(struct sk_buff *skb)
>   
>   static inline void can_skb_set_owner(struct sk_buff *skb, struct sock *sk)
>   {
> -	if (sk) {
> -		sock_hold(sk);
> +	/*
> +	 * If the socket has already been closed by user space, the refcount may
> +	 * already be 0 (and the socket will be freed after the last TX skb has
> +	 * been freed). So only increase socket refcount if the refcount is > 0.
> +	 */
> +	if (sk && refcount_inc_not_zero(&sk->sk_refcnt)) {
>   		skb->destructor = sock_efree;
>   		skb->sk = sk;
>   	}

Ah, now I got the problem. You are replacing sock_hold(). Maybe I was a 
bit slow-witted here - but with the comment it is ok.

Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>

Many thanks!

Oliver

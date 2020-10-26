Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124262989D7
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 10:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768652AbgJZJx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 05:53:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1768669AbgJZJwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 05:52:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603705926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EzJl/A45Yba7R3oWiXbf0VIqJAG69+6BHxAA1BrHBdc=;
        b=YqbzsfihbYm20b4Hkfsgax9M1FYpC7wbxumWvr53y0xklOWGBKwbm15t0d9UPnPkt/cI+R
        gku2BLX/j5/Cl/mgT/JTmV2xcrv3FtPMVByqeonnSep0efUGRF8ypAvH/ZdvYROQUOp80K
        VhcOpfipR1oqnD6pyrUwK7K8TUM8SYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-I8qAw6eHMWeHc-dB1dn3GQ-1; Mon, 26 Oct 2020 05:52:02 -0400
X-MC-Unique: I8qAw6eHMWeHc-dB1dn3GQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 839F51006C93;
        Mon, 26 Oct 2020 09:52:00 +0000 (UTC)
Received: from ovpn-114-234.ams2.redhat.com (ovpn-114-234.ams2.redhat.com [10.36.114.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA60E5C1C2;
        Mon, 26 Oct 2020 09:51:57 +0000 (UTC)
Message-ID: <acbb8a3a7bd83ee1121dfa91c207e4681a01d2d8.camel@redhat.com>
Subject: Re: [PATCH] net: udp: increase UDP_MIB_RCVBUFERRORS when ENOBUFS
From:   Paolo Abeni <pabeni@redhat.com>
To:     Menglong Dong <menglong8.dong@gmail.com>, davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 26 Oct 2020 10:51:56 +0100
In-Reply-To: <20201026093907.13799-1-menglong8.dong@gmail.com>
References: <20201026093907.13799-1-menglong8.dong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2020-10-26 at 17:39 +0800, Menglong Dong wrote:
> The error returned from __udp_enqueue_schedule_skb is ENOMEM or ENOBUFS.
> For now, only ENOMEM is counted into UDP_MIB_RCVBUFERRORS in
> __udp_queue_rcv_skb. UDP_MIB_RCVBUFERRORS should count all of the
> failed skb because of memory errors during udp receiving, not just because of the limit of sock receive queue. We can see this
> in __udp4_lib_mcast_deliver:
> 
> 		nskb = skb_clone(skb, GFP_ATOMIC);
> 
> 		if (unlikely(!nskb)) {
> 			atomic_inc(&sk->sk_drops);
> 			__UDP_INC_STATS(net, UDP_MIB_RCVBUFERRORS,
> 					IS_UDPLITE(sk));
> 			__UDP_INC_STATS(net, UDP_MIB_INERRORS,
> 					IS_UDPLITE(sk));
> 			continue;
> 		}
> 
> See, UDP_MIB_RCVBUFERRORS is increased when skb clone failed. From this
> point, ENOBUFS from __udp_enqueue_schedule_skb should be counted, too.
> It means that the buffer used by all of the UDP sock is to the limit, and
> it ought to be counted.
> 
> Signed-off-by: Menglong Dong <menglong8.dong@gmail.com>
> ---
>  net/ipv4/udp.c | 4 +---
>  net/ipv6/udp.c | 4 +---
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 09f0a23d1a01..49a69d8d55b3 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2035,9 +2035,7 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
>  		int is_udplite = IS_UDPLITE(sk);
>  
>  		/* Note that an ENOMEM error is charged twice */
> -		if (rc == -ENOMEM)
> -			UDP_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS,
> -					is_udplite);
> +		UDP_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS, is_udplite);
>  		UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
>  		kfree_skb(skb);
>  		trace_udp_fail_queue_rcv_skb(rc, sk);
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 29d9691359b9..d5e23b150fd9 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -634,9 +634,7 @@ static int __udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
>  		int is_udplite = IS_UDPLITE(sk);
>  
>  		/* Note that an ENOMEM error is charged twice */
> -		if (rc == -ENOMEM)
> -			UDP6_INC_STATS(sock_net(sk),
> -					 UDP_MIB_RCVBUFERRORS, is_udplite);
> +		UDP6_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS, is_udplite);
>  		UDP6_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
>  		kfree_skb(skb);
>  		return -1;

The diffstat is nice, but I'm unsure we can do this kind of change
(well, I really think we should not do it): it will fool any kind of
existing users (application, scripts, admin) currently reading the
above counters and expecting UDP_MIB_RCVBUFERRORS being increased with
the existing schema.

Cheers,

Paolo


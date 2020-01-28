Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2A414B37B
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 12:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgA1L1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 06:27:20 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50956 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725901AbgA1L1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 06:27:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580210839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WoK20dj2WtqaSEOQp40+FfgOB/2S785cb3dvVwYAbWw=;
        b=dQACrC8DPoXWIS5I0qPuDoGSTcFZHUWtBszW2BpMUNwWTci89G5DTrPjc9aBwGf4Sv/Ifq
        SOWEP94L71KEpsfCF0fvZ/UHWc8krtQVHdXk7DPxPQ8gSoFuRC45LUXOPhwD+h2RWTjChU
        UTTtpv2A6h4zZCbRtu1IKoq09ILxVR0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-4vS0gXQ5PtmCzKoc4H25-Q-1; Tue, 28 Jan 2020 06:27:15 -0500
X-MC-Unique: 4vS0gXQ5PtmCzKoc4H25-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0096213E5;
        Tue, 28 Jan 2020 11:27:14 +0000 (UTC)
Received: from ovpn-118-5.ams2.redhat.com (unknown [10.36.118.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 929C2863C9;
        Tue, 28 Jan 2020 11:27:12 +0000 (UTC)
Message-ID: <2c22b5de7b99cd6b32117f907ea031beb5b59d1e.camel@redhat.com>
Subject: Re: [PATCH net] udp: segment looped gso packets correctly
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Date:   Tue, 28 Jan 2020 12:27:14 +0100
In-Reply-To: <20200127204031.244254-1-willemdebruijn.kernel@gmail.com>
References: <20200127204031.244254-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-01-27 at 15:40 -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Multicast and broadcast packets can be looped from egress to ingress
> pre segmentation with dev_loopback_xmit. That function unconditionally
> sets ip_summed to CHECKSUM_UNNECESSARY.
> 
> udp_rcv_segment segments gso packets in the udp rx path. Segmentation
> usually executes on egress, and does not expect packets of this type.
> __udp_gso_segment interprets !CHECKSUM_PARTIAL as CHECKSUM_NONE. But
> the offsets are not correct for gso_make_checksum.
> 
> UDP GSO packets are of type CHECKSUM_PARTIAL, with their uh->check set
> to the correct pseudo header checksum. Reset ip_summed to this type.
> (CHECKSUM_PARTIAL is allowed on ingress, see comments in skbuff.h)
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  include/net/udp.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/net/udp.h b/include/net/udp.h
> index bad74f7808311..8f163d674f072 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -476,6 +476,9 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
>  	if (!inet_get_convert_csum(sk))
>  		features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
>  
> +	if (skb->pkt_type == PACKET_LOOPBACK)
> +		skb->ip_summed = CHECKSUM_PARTIAL;
> +
>  	/* the GSO CB lays after the UDP one, no need to save and restore any
>  	 * CB fragment
>  	 */

LGTM, Thanks!

Acked-by: Paolo Abeni <pabeni@redhat.com>

Out of sheer curiosity, do you know what was the kernel behaviour
before the 'fixes' commit ? GSO packet delivered to user-space stillaggregated ?!? 

Thanks,

Paolo


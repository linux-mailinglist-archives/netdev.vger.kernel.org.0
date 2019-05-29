Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86962DECF
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 15:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfE2Nqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 09:46:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbfE2Nqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 09:46:52 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D591A30C1208;
        Wed, 29 May 2019 13:46:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBAEC60FAF;
        Wed, 29 May 2019 13:46:43 +0000 (UTC)
Message-ID: <1b48684a933e6d782dca9114929fe1b23d7a4a46.camel@redhat.com>
Subject: Re: [PATCH net-next v2] udp: Avoid post-GRO UDP checksum
 recalculation
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sean Tranchetti <stranche@codeaurora.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date:   Wed, 29 May 2019 15:46:43 +0200
In-Reply-To: <1559067774-613-1-git-send-email-stranche@codeaurora.org>
References: <1559067774-613-1-git-send-email-stranche@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 29 May 2019 13:46:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-05-28 at 12:22 -0600, Sean Tranchetti wrote:
> Currently, when resegmenting an unexpected UDP GRO packet, the full UDP
> checksum will be calculated for every new SKB created by skb_segment()
> because the netdev features passed in by udp_rcv_segment() lack any
> information about checksum offload capabilities.
> 
> Usually, we have no need to perform this calculation again, as
>   1) The GRO implementation guarantees that any packets making it to the
>      udp_rcv_segment() function had correct checksums, and, more
>      importantly,
>   2) Upon the successful return of udp_rcv_segment(), we immediately pull
>      the UDP header off and either queue the segment to the socket or
>      hand it off to a new protocol handler.
> 
> Unless userspace has set the IP_CHECKSUM sockopt to indicate that they
> want the final checksum values, we can pass the needed netdev feature
> flags to __skb_gso_segment() to avoid checksumming each segment in
> skb_segment().
> 
> Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
> ---
>  include/net/udp.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/udp.h b/include/net/udp.h
> index d8ce937..dbe030d 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -471,12 +471,19 @@ struct udp_iter_state {
>  static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
>  					      struct sk_buff *skb, bool ipv4)
>  {
> +	netdev_features_t features = NETIF_F_SG;
>  	struct sk_buff *segs;
>  
> +	/* Avoid csum recalculation by skb_segment unless userspace explicitly
> +	 * asks for the final checksum values
> +	 */
> +	if (!inet_get_convert_csum(sk))
> +		features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
> +
>  	/* the GSO CB lays after the UDP one, no need to save and restore any
>  	 * CB fragment
>  	 */
> -	segs = __skb_gso_segment(skb, NETIF_F_SG, false);
> +	segs = __skb_gso_segment(skb, features, false);
>  	if (unlikely(IS_ERR_OR_NULL(segs))) {
>  		int segs_nr = skb_shinfo(skb)->gso_segs;

The patch itself LGTM, thanks.

Acked-by: Paolo Abeni <pabeni@redhat.com>

Possibly this can target the 'net' tree as the relevant commit is
already there and the patch itself is not very invasive.

Paolo



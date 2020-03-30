Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA9E1197672
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 10:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgC3I3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 04:29:32 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36524 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729576AbgC3I3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 04:29:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2AD0720482;
        Mon, 30 Mar 2020 10:29:30 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3aqecYZNCBrY; Mon, 30 Mar 2020 10:29:29 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id AF076200A0;
        Mon, 30 Mar 2020 10:29:29 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 30 Mar
 2020 10:29:29 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 25B0B3180136; Mon, 30 Mar 2020 10:29:29 +0200 (CEST)
Date:   Mon, 30 Mar 2020 10:29:29 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     network dev <netdev@vger.kernel.org>, <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net] udp: fix a skb extensions leak
Message-ID: <20200330082929.GG13121@gauss3.secunet.de>
References: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 cas-essen-02.secunet.de (10.53.40.202)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 05:06:25PM +0800, Xin Long wrote:
> On udp rx path udp_rcv_segment() may do segment where the frag skbs
> will get the header copied from the head skb in skb_segment_list()
> by calling __copy_skb_header(), which could overwrite the frag skbs'
> extensions by __skb_ext_copy() and cause a leak.
> 
> This issue was found after loading esp_offload where a sec path ext
> is set in the skb.
> 
> On udp tx gso path, it works well as the frag skbs' extensions are
> not set. So this issue should be fixed on udp's rx path only and
> release the frag skbs' extensions before going to do segment.

Are you sure that this affects only the RX path? What if such
a packet is forwarded? Also, I think TCP has the same problem.

> 
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/udp.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/net/udp.h b/include/net/udp.h
> index e55d5f7..7bf0ca5 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -486,6 +486,10 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
>  	if (skb->pkt_type == PACKET_LOOPBACK)
>  		skb->ip_summed = CHECKSUM_PARTIAL;
>  
> +	if (skb_has_frag_list(skb) && skb_has_extensions(skb))
> +		skb_walk_frags(skb, segs)
> +			skb_ext_put(segs);

If a skb in the fraglist has a secpath, it is still valid.
So maybe instead of dropping it here and assign the one
from the head skb, we could just keep the secpath. But
I don't know about other extensions. I've CCed Florian,
he might know a bit more about other extensions. Also,
it might be good to check if the extensions of the GRO
packets are all the same before merging.


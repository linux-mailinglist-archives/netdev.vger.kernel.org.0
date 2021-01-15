Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725D22F741C
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 09:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732460AbhAOIN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 03:13:29 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:42896 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbhAOIN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 03:13:28 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 775D120322;
        Fri, 15 Jan 2021 09:12:45 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qODBdNW82-s6; Fri, 15 Jan 2021 09:12:44 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8FA68201AA;
        Fri, 15 Jan 2021 09:12:44 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 09:12:44 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 15 Jan
 2021 09:12:44 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C35143180345; Fri, 15 Jan 2021 09:12:43 +0100 (CET)
Date:   Fri, 15 Jan 2021 09:12:43 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Dongseok Yi <dseok.yi@samsung.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        <namkyu78.kim@samsung.com>, Alexander Lobakin <alobakin@pm.me>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] udp: ipv4: manipulate network header of NATed UDP
 GRO fraglist
Message-ID: <20210115081243.GM9390@gauss3.secunet.de>
References: <CGME20210115061039epcas2p479bc5f3dd3dad5a250c4e0fc42896704@epcas2p4.samsung.com>
 <1610690304-167832-1-git-send-email-dseok.yi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1610690304-167832-1-git-send-email-dseok.yi@samsung.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 02:58:24PM +0900, Dongseok Yi wrote:
> UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> forwarding. Only the header of head_skb from ip_finish_output_gso ->
> skb_gso_segment is updated but following frag_skbs are not updated.
> 
> A call path skb_mac_gso_segment -> inet_gso_segment ->
> udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> does not try to update UDP/IP header of the segment list.

We still need to find out why it works for Alexander, but not for you.
Different usecases?

We copy only the MAC header in skb_segment_list(), so I think
this is a valid bug when NAT changed the UDP header.

> 
> Update dport, daddr and checksums of each skb of the segment list
> after __udp_gso_segment.
> 
> Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> ---
> Steffen Klassert said, there could be 2 options.
> https://lore.kernel.org/patchwork/patch/1362257/
> 
> I was trying to write a quick fix, but it was not easy to forward
> segmented list. Currently, assuming DNAT only. Should we consider
> SNAT too?

If it is broken, then it is broken for both, so yes.

> 
>  net/ipv4/udp_offload.c | 45 +++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 41 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index ff39e94..7e24928 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -309,10 +309,12 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
>  					 netdev_features_t features)
>  {
>  	struct sk_buff *segs = ERR_PTR(-EINVAL);
> +	struct sk_buff *seg;
>  	unsigned int mss;
>  	__wsum csum;
> -	struct udphdr *uh;
> -	struct iphdr *iph;
> +	struct udphdr *uh, *uh2;
> +	struct iphdr *iph, *iph2;
> +	bool is_fraglist = false;
>  
>  	if (skb->encapsulation &&
>  	    (skb_shinfo(skb)->gso_type &
> @@ -327,8 +329,43 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
>  	if (!pskb_may_pull(skb, sizeof(struct udphdr)))
>  		goto out;
>  
> -	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
> -		return __udp_gso_segment(skb, features);
> +	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
> +		if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST)
> +			is_fraglist = true;
> +
> +		segs = __udp_gso_segment(skb, features);
> +		if (IS_ERR_OR_NULL(segs) || !is_fraglist)
> +			return segs;
> +
> +		seg = segs;
> +		uh = udp_hdr(seg);
> +		iph = ip_hdr(seg);
> +
> +		while ((seg = seg->next)) {
> +			uh2 = udp_hdr(seg);
> +			iph2 = ip_hdr(seg);
> +
> +			if (uh->dest == uh2->dest && iph->daddr == iph2->daddr)
> +				continue;
> +
> +			if (uh2->check) {
> +				inet_proto_csum_replace4(&uh2->check, seg,
> +							 iph2->daddr,
> +							 iph->daddr, true);
> +				inet_proto_csum_replace2(&uh2->check, seg,
> +							 uh2->dest, uh->dest,
> +							 false);
> +				if (!uh2->check)
> +					uh2->check = CSUM_MANGLED_0;
> +			}
> +			uh2->dest = uh->dest;
> +
> +			csum_replace4(&iph2->check, iph2->daddr, iph->daddr);
> +			iph2->daddr = iph->daddr;
> +		}
> +
> +		return segs;
> +	}

I would not like to add this to a generic codepath. I think we can
relatively easy copy the full headers in skb_segment_list().

I think about something like the (completely untested) patch below:

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f62cae3f75d8..63ae7f79fad7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3651,13 +3651,14 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 				 unsigned int offset)
 {
 	struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
+	unsigned int doffset = skb->data - skb_mac_header(skb);
 	unsigned int tnl_hlen = skb_tnl_header_len(skb);
 	unsigned int delta_truesize = 0;
 	unsigned int delta_len = 0;
 	struct sk_buff *tail = NULL;
 	struct sk_buff *nskb;
 
-	skb_push(skb, -skb_network_offset(skb) + offset);
+	skb_push(skb, doffset);
 
 	skb_shinfo(skb)->frag_list = NULL;
 
@@ -3675,7 +3676,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		delta_len += nskb->len;
 		delta_truesize += nskb->truesize;
 
-		skb_push(nskb, -skb_network_offset(nskb) + offset);
+		skb_push(nskb, doffset);
 
 		skb_release_head_state(nskb);
 		 __copy_skb_header(nskb, skb);
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index ff39e94781bf..1181398378b8 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -190,9 +190,22 @@ EXPORT_SYMBOL(skb_udp_tunnel_segment);
 static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
 					      netdev_features_t features)
 {
+	struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
 	unsigned int mss = skb_shinfo(skb)->gso_size;
+	unsigned int offset;
 
-	skb = skb_segment_list(skb, features, skb_mac_header_len(skb));
+	skb_headers_offset_update(list_skb, skb_headroom(list_skb) - skb_headroom(skb));
+
+	/* Check for header changes and copy the full header in that case. */
+	if ((udp_hdr(skb)->dest == udp_hdr(list_skb)->dest) &&
+	    (udp_hdr(skb)->source == udp_hdr(list_skb)->source) &&
+	    (ip_hdr(skb)->daddr == ip_hdr(list_skb)->daddr) &&
+	    (ip_hdr(skb)->saddr == ip_hdr(list_skb)->saddr))
+		offset = skb_mac_header_len(skb);
+	else
+		offset = skb->data - skb_mac_header(skb);
+
+	skb = skb_segment_list(skb, features, offset);
 	if (IS_ERR(skb))
 		return skb;
 

After that you can apply the CSUM magic in __udp_gso_segment_list().


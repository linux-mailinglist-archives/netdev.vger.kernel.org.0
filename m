Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00591495EE4
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 13:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350391AbiAUMH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 07:07:59 -0500
Received: from mg.ssi.bg ([193.238.174.37]:58142 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237622AbiAUMH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 07:07:59 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jan 2022 07:07:58 EST
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 14FE712CFD
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 14:02:31 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id CA53312B69
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 14:02:29 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 037B13C09C4;
        Fri, 21 Jan 2022 14:02:24 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 20LC2NxZ061189;
        Fri, 21 Jan 2022 14:02:23 +0200
Date:   Fri, 21 Jan 2022 14:02:23 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Martin KaFai Lau <kafai@fb.com>
cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [RFC PATCH v3 net-next 3/4] net: Set skb->mono_delivery_time
 and clear it when delivering locally
In-Reply-To: <20220121073045.4179438-1-kafai@fb.com>
Message-ID: <ca728d81-80e8-3767-d5e-d44f6ad96e43@ssi.bg>
References: <20220121073026.4173996-1-kafai@fb.com> <20220121073045.4179438-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Thu, 20 Jan 2022, Martin KaFai Lau wrote:

> This patch sets the skb->mono_delivery_time to flag the skb->tstamp
> is used as the mono delivery_time (EDT) instead of the (rcv) timestamp.
> 
> skb_clear_delivery_time() is added to clear the delivery_time and set
> back to the (rcv) timestamp if needed when the skb is being delivered
> locally (to a sk).  skb_clear_delivery_time() is called in
> ip_local_deliver() and ip6_input().  In most of the regular ingress
> cases, the skb->tstamp should already have the (rcv) timestamp.
> For the egress loop back to ingress cases, the marking of the (rcv)
> timestamp is postponed from dev.c to ip_local_deliver() and
> ip6_input().
> 
> Another case needs to clear the delivery_time is the network
> tapping (e.g. af_packet by tcpdump).  Regardless of tapping at the ingress
> or egress,  the tapped skb is received by the af_packet socket, so
> it is ingress to the af_packet socket and it expects
> the (rcv) timestamp.
> 
> When tapping at egress, dev_queue_xmit_nit() is used.  It has already
> expected skb->tstamp may have delivery_time,  so it does
> skb_clone()+net_timestamp_set() to ensure the cloned skb has
> the (rcv) timestamp before passing to the af_packet sk.
> This patch only adds to clear the skb->mono_delivery_time
> bit in net_timestamp_set().
> 
> When tapping at ingress, it currently expects the skb->tstamp is either 0
> or has the (rcv) timestamp.  Meaning, the tapping at ingress path
> has already expected the skb->tstamp could be 0 and it will get
> the (rcv) timestamp by ktime_get_real() when needed.
> 
> There are two cases for tapping at ingress:
> 
> One case is af_packet queues the skb to its sk_receive_queue.  The skb
> is either not shared or new clone created.  The skb_clear_delivery_time()
> is called to clear the delivery_time (if any) before it is queued to the
> sk_receive_queue.
> 
> Another case, the ingress skb is directly copied to the rx_ring
> and tpacket_get_timestamp() is used to get the (rcv) timestamp.
> skb_tstamp() is used in tpacket_get_timestamp() to check
> the skb->mono_delivery_time bit before returning skb->tstamp.
> As mentioned earlier, the tapping@ingress has already expected
> the skb may not have the (rcv) timestamp (because no sk has asked
> for it) and has handled this case by directly calling ktime_get_real().
> 
> In __skb_tstamp_tx, it clones the egress skb and queues the clone to the
> sk_error_queue.  The outgoing skb may have the mono delivery_time while
> the (rcv) timestamp is expected for the clone, so the
> skb->mono_delivery_time bit is also cleared from the clone.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/skbuff.h | 27 +++++++++++++++++++++++++--
>  net/core/dev.c         |  4 +++-
>  net/core/skbuff.c      |  6 ++++--
>  net/ipv4/ip_input.c    |  1 +
>  net/ipv6/ip6_input.c   |  1 +
>  net/packet/af_packet.c |  4 +++-
>  6 files changed, 37 insertions(+), 6 deletions(-)
> 

> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index 3a025c011971..35311ca75496 100644
> --- a/net/ipv4/ip_input.c
> +++ b/net/ipv4/ip_input.c
> @@ -244,6 +244,7 @@ int ip_local_deliver(struct sk_buff *skb)
>  	 */
>  	struct net *net = dev_net(skb->dev);
>  
> +	skb_clear_delivery_time(skb);

	Is it safe to move this line into ip_local_deliver_finish ?

>  	if (ip_is_fragment(ip_hdr(skb))) {
>  		if (ip_defrag(net, skb, IP_DEFRAG_LOCAL_DELIVER))
>  			return 0;
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index 80256717868e..84f93864b774 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -469,6 +469,7 @@ static int ip6_input_finish(struct net *net, struct sock *sk, struct sk_buff *sk
>  
>  int ip6_input(struct sk_buff *skb)
>  {
> +	skb_clear_delivery_time(skb);

	Is it safe to move this line into ip6_input_finish?
The problem for both cases is that IPVS hooks at LOCAL_IN and
can decide to forward the packet by returning NF_STOLEN and
avoiding the _finish code. In short, before reaching the
_finish code it is still not decided that packet reaches the
sockets.

>  	return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_IN,
>  		       dev_net(skb->dev), NULL, skb, skb->dev, NULL,
>  		       ip6_input_finish);

Regards

--
Julian Anastasov <ja@ssi.bg>


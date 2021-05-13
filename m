Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4977337FFB1
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 23:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhEMVQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 17:16:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54573 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233363AbhEMVQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 17:16:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620940532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5SdWwEV+zCJbxKelabW7d6utwsZpaXtUQB9xq50xT0E=;
        b=LbC4ux+29Jibj91SDEobzO+kOVdafz9KZXCplaPz3t7RzAq07iXlbyKnNYAmhduXZ0g59b
        MozVNi+Ad9MBQsR689t8VCqmVcNQHmChNZhy+uYPIzD3yKxnYXEq/YlQ45F0zbuKSi3TNW
        dUxA/wi+cfgDpQscW9ScbTHAHwGwbPk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-xF5u0pplO5KVpu1Ur19ZHA-1; Thu, 13 May 2021 17:15:31 -0400
X-MC-Unique: xF5u0pplO5KVpu1Ur19ZHA-1
Received: by mail-qk1-f197.google.com with SMTP id s10-20020a05620a030ab02902e061a1661fso20419625qkm.12
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 14:15:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5SdWwEV+zCJbxKelabW7d6utwsZpaXtUQB9xq50xT0E=;
        b=lDsHD744YGya1+iYe0MVRRUVseeKaZQ/0N46OHw385n8le8VbjJdu1aB+VD1taJIH0
         +HuEIzJZbYBTfJAU4wpo6nJLnn5OA4eJ4sw/WRTNZzeOtIIsqCXt/gw3pc+7akZJpBzE
         uOgWUDKQsPkKBOEA1mT/DeX8ajI12p/W8nOMY2Gev6HbzKmOixUVS/4qwt+moVwpPDVd
         EGvj6VgQZdplpHTTbkK/aZx/XTsXGIqTnGdBYnMao16iV99Ru4m3/DXrz5iCuX0RagfO
         CiplmgKZliO2w3SbEmdcX73k3PCDqqhqip9t9jZcg5/BUQ6ZTs4aSG39DxAUAYJszPwC
         hu1w==
X-Gm-Message-State: AOAM530EAtNYFA1ofrteJ9nLPlXrMZvRgUmDxDyYt/CQB5KWrEUBoo44
        CFLaoIRtqMqw5ZHQdGI7p+prsUrxWhkYKWaXjmIUYohsUREo3XubsZGMewo7Ch6N1Ec6q2TY0Jd
        koLtQ5K8RJjwLaDF4
X-Received: by 2002:ad4:4f82:: with SMTP id em2mr42994375qvb.55.1620940530565;
        Thu, 13 May 2021 14:15:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzq6e2qJ2N6ZaFPSLp+HaYVI5zp7erPP/7GjPYOwJjKYRtBtokfcDULNigOX+USK/Hvshsoyg==
X-Received: by 2002:ad4:4f82:: with SMTP id em2mr42994360qvb.55.1620940530363;
        Thu, 13 May 2021 14:15:30 -0700 (PDT)
Received: from [192.168.0.106] ([24.225.235.43])
        by smtp.gmail.com with ESMTPSA id q13sm3249089qkn.10.2021.05.13.14.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 14:15:29 -0700 (PDT)
Subject: Re: [PATCH net] tipc: fix a race in tipc_sk_mcast_rcv
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Ying Xue <ying.xue@windriver.com>, lyl2019@mail.ustc.edu.cn
References: <25c57c05b6f5cc81fd49b8f060ebf0961ea8af68.1619638230.git.lucien.xin@gmail.com>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <3dd765e7-3509-1813-e1fe-894d26843c2e@redhat.com>
Date:   Thu, 13 May 2021 17:15:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <25c57c05b6f5cc81fd49b8f060ebf0961ea8af68.1619638230.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/21 3:30 PM, Xin Long wrote:
> After commit cb1b728096f5 ("tipc: eliminate race condition at multicast
> reception"), when processing the multicast reception, the packets are
> firstly moved from be->inputq1 to be->arrvq in tipc_node_broadcast(),
> then process be->arrvq in tipc_sk_mcast_rcv().
>
> In tipc_sk_mcast_rcv(), it gets the 1st skb by skb_peek(), then process
> this skb without any lock. It means meanwhile another thread could also
> call tipc_sk_mcast_rcv() and process be->arrvq and pick up the same skb,
> then free it. A double free issue will be caused as Li Shuang reported:
>
>    [] kernel BUG at mm/slub.c:305!
>    []  kfree+0x3a7/0x3d0
>    []  kfree_skb+0x32/0xa0
>    []  skb_release_data+0xb4/0x170
>    []  kfree_skb+0x32/0xa0
>    []  skb_release_data+0xb4/0x170
>    []  kfree_skb+0x32/0xa0
>    []  tipc_sk_mcast_rcv+0x1fa/0x380 [tipc]
>    []  tipc_rcv+0x411/0x1120 [tipc]
>    []  tipc_udp_recv+0xc6/0x1e0 [tipc]
>    []  udp_queue_rcv_one_skb+0x1a9/0x500
>    []  udp_unicast_rcv_skb.isra.66+0x75/0x90
>    []  __udp4_lib_rcv+0x537/0xc40
>    []  ip_protocol_deliver_rcu+0xdf/0x1d0
>    []  ip_local_deliver_finish+0x4a/0x50
>    []  ip_local_deliver+0x6b/0xe0
>    []  ip_rcv+0x27b/0x36a
>    []  __netif_receive_skb_core+0xb47/0xc40
>    []  process_backlog+0xae/0x160
>
> Commit 6bf24dc0cc0c ("net:tipc: Fix a double free in tipc_sk_mcast_rcv")
> tried to fix this double free by not releasing the skbs in be->arrvq,
> which would definitely cause the skbs' leak.
>
> The problem is we shouldn't process the skbs in be->arrvq without any
> lock to protect the code from peeking to dequeuing them. The fix here
> is to use a temp skb list instead of be->arrvq to make it "per thread
> safe". While at it, remove the no-longer-used be->arrvq.
>
> Fixes: cb1b728096f5 ("tipc: eliminate race condition at multicast reception")
> Fixes: 6bf24dc0cc0c ("net:tipc: Fix a double free in tipc_sk_mcast_rcv")
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>   net/tipc/node.c   |  9 ++++-----
>   net/tipc/socket.c | 16 +++-------------
>   2 files changed, 7 insertions(+), 18 deletions(-)
>
> diff --git a/net/tipc/node.c b/net/tipc/node.c
> index e0ee832..0c636fb 100644
> --- a/net/tipc/node.c
> +++ b/net/tipc/node.c
> @@ -72,7 +72,6 @@ struct tipc_link_entry {
>   struct tipc_bclink_entry {
>   	struct tipc_link *link;
>   	struct sk_buff_head inputq1;
> -	struct sk_buff_head arrvq;
>   	struct sk_buff_head inputq2;
>   	struct sk_buff_head namedq;
>   	u16 named_rcv_nxt;
> @@ -552,7 +551,6 @@ struct tipc_node *tipc_node_create(struct net *net, u32 addr, u8 *peer_id,
>   	INIT_LIST_HEAD(&n->conn_sks);
>   	skb_queue_head_init(&n->bc_entry.namedq);
>   	skb_queue_head_init(&n->bc_entry.inputq1);
> -	__skb_queue_head_init(&n->bc_entry.arrvq);
>   	skb_queue_head_init(&n->bc_entry.inputq2);
>   	for (i = 0; i < MAX_BEARERS; i++)
>   		spin_lock_init(&n->links[i].lock);
> @@ -1803,14 +1801,15 @@ void tipc_node_broadcast(struct net *net, struct sk_buff *skb, int rc_dests)
>   static void tipc_node_mcast_rcv(struct tipc_node *n)
>   {
>   	struct tipc_bclink_entry *be = &n->bc_entry;
> +	struct sk_buff_head tmpq;
>   
> -	/* 'arrvq' is under inputq2's lock protection */
> +	__skb_queue_head_init(&tmpq);
>   	spin_lock_bh(&be->inputq2.lock);
>   	spin_lock_bh(&be->inputq1.lock);
> -	skb_queue_splice_tail_init(&be->inputq1, &be->arrvq);
> +	skb_queue_splice_tail_init(&be->inputq1, &tmpq);
>   	spin_unlock_bh(&be->inputq1.lock);
>   	spin_unlock_bh(&be->inputq2.lock);
> -	tipc_sk_mcast_rcv(n->net, &be->arrvq, &be->inputq2);
> +	tipc_sk_mcast_rcv(n->net, &tmpq, &be->inputq2);
>   }
>   
>   static void tipc_node_bc_sync_rcv(struct tipc_node *n, struct tipc_msg *hdr,
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index 022999e..2870798 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -1210,8 +1210,7 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
>   	__skb_queue_head_init(&tmpq);
>   	INIT_LIST_HEAD(&dports);
>   
> -	skb = tipc_skb_peek(arrvq, &inputq->lock);
> -	for (; skb; skb = tipc_skb_peek(arrvq, &inputq->lock)) {
> +	while ((skb = __skb_dequeue(arrvq)) != NULL) {
>   		hdr = buf_msg(skb);
>   		user = msg_user(hdr);
>   		mtyp = msg_type(hdr);
> @@ -1220,13 +1219,7 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
>   		type = msg_nametype(hdr);
>   
>   		if (mtyp == TIPC_GRP_UCAST_MSG || user == GROUP_PROTOCOL) {
> -			spin_lock_bh(&inputq->lock);
> -			if (skb_peek(arrvq) == skb) {
> -				__skb_dequeue(arrvq);
> -				__skb_queue_tail(inputq, skb);
> -			}
> -			kfree_skb(skb);
> -			spin_unlock_bh(&inputq->lock);
> +			skb_queue_tail(inputq, skb);
>   			continue;
>   		}
>   
> @@ -1263,10 +1256,7 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
>   		}
>   		/* Append to inputq if not already done by other thread */
>   		spin_lock_bh(&inputq->lock);
> -		if (skb_peek(arrvq) == skb) {
> -			skb_queue_splice_tail_init(&tmpq, inputq);
> -			__skb_dequeue(arrvq);
> -		}
> +		skb_queue_splice_tail_init(&tmpq, inputq);
>   		spin_unlock_bh(&inputq->lock);
>   		__skb_queue_purge(&tmpq);
>   		kfree_skb(skb);
Nack.

This would invalidate the sequence guarantee of messages between two 
specific sockets.
The whole point of having a lock protected arrival queue is to preserve 
the order when messages are moved from inputq1 to inputq2.
Let's take a discussion on our mailing list.

///jon


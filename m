Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C12B5AA5F
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 13:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfF2LUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 07:20:04 -0400
Received: from mail5.windriver.com ([192.103.53.11]:56388 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbfF2LUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 07:20:03 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x5TBIIi8030102
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Sat, 29 Jun 2019 04:18:34 -0700
Received: from [128.224.155.90] (128.224.155.90) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.439.0; Sat, 29 Jun
 2019 04:18:14 -0700
Subject: Re: [net-next 1/1] tipc: embed jiffies in macro TIPC_BC_RETR_LIM
To:     Jon Maloy <jon.maloy@ericsson.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <gordan.mihaljevic@dektech.com.au>, <tung.q.nguyen@dektech.com.au>,
        <hoang.h.le@dektech.com.au>, <canh.d.luu@dektech.com.au>,
        <tipc-discussion@lists.sourceforge.net>
References: <1561734380-26868-1-git-send-email-jon.maloy@ericsson.com>
From:   Ying Xue <ying.xue@windriver.com>
Message-ID: <40abd327-3d1c-3b51-dfb7-427ae70cc0cb@windriver.com>
Date:   Sat, 29 Jun 2019 19:07:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <1561734380-26868-1-git-send-email-jon.maloy@ericsson.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.155.90]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/19 11:06 PM, Jon Maloy wrote:
> The macro TIPC_BC_RETR_LIM is always used in combination with 'jiffies',
> so we can just as well perform the addition in the macro itself. This
> way, we get a few shorter code lines and one less line break.
> 
> Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>

Acked-by: Ying Xue <ying.xue@windriver.com>

> ---
>  net/tipc/link.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/net/tipc/link.c b/net/tipc/link.c
> index f8bf63b..66d3a07 100644
> --- a/net/tipc/link.c
> +++ b/net/tipc/link.c
> @@ -207,7 +207,7 @@ enum {
>  	BC_NACK_SND_SUPPRESS,
>  };
>  
> -#define TIPC_BC_RETR_LIM msecs_to_jiffies(10)   /* [ms] */
> +#define TIPC_BC_RETR_LIM  (jiffies + msecs_to_jiffies(10))
>  #define TIPC_UC_RETR_TIME (jiffies + msecs_to_jiffies(1))
>  
>  /*
> @@ -976,8 +976,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
>  			__skb_queue_tail(transmq, skb);
>  			/* next retransmit attempt */
>  			if (link_is_bc_sndlink(l))
> -				TIPC_SKB_CB(skb)->nxt_retr =
> -					jiffies + TIPC_BC_RETR_LIM;
> +				TIPC_SKB_CB(skb)->nxt_retr = TIPC_BC_RETR_LIM;
>  			__skb_queue_tail(xmitq, _skb);
>  			TIPC_SKB_CB(skb)->ackers = l->ackers;
>  			l->rcv_unacked = 0;
> @@ -1027,7 +1026,7 @@ static void tipc_link_advance_backlog(struct tipc_link *l,
>  		__skb_queue_tail(&l->transmq, skb);
>  		/* next retransmit attempt */
>  		if (link_is_bc_sndlink(l))
> -			TIPC_SKB_CB(skb)->nxt_retr = jiffies + TIPC_BC_RETR_LIM;
> +			TIPC_SKB_CB(skb)->nxt_retr = TIPC_BC_RETR_LIM;
>  
>  		__skb_queue_tail(xmitq, _skb);
>  		TIPC_SKB_CB(skb)->ackers = l->ackers;
> @@ -1123,7 +1122,7 @@ static int tipc_link_bc_retrans(struct tipc_link *l, struct tipc_link *r,
>  		if (link_is_bc_sndlink(l)) {
>  			if (time_before(jiffies, TIPC_SKB_CB(skb)->nxt_retr))
>  				continue;
> -			TIPC_SKB_CB(skb)->nxt_retr = jiffies + TIPC_BC_RETR_LIM;
> +			TIPC_SKB_CB(skb)->nxt_retr = TIPC_BC_RETR_LIM;
>  		}
>  		_skb = __pskb_copy(skb, LL_MAX_HEADER + MIN_H_SIZE, GFP_ATOMIC);
>  		if (!_skb)
> 

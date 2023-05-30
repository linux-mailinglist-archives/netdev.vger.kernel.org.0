Return-Path: <netdev+bounces-6474-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA897166EA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:25:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F19541C20C48
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3906524E89;
	Tue, 30 May 2023 15:25:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDB217AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE1CC433D2;
	Tue, 30 May 2023 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685460331;
	bh=XSvGB8nUY1B3/Ku5Og67q3HT++wQ3wNQBgl34wHEj/A=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Lk8NHkEKcIHoRV/sI5OSOU97NpLdeHaxGg78p8pZcT2H7k60f/LnAHJ3LSPe00E2g
	 bPEMM/IOMCZe0F59LvottmxDVAuJl7UPoBZufVZ/GF78hH6FE8wqP45Eab/QaGg9BL
	 5/yzzS5fabovm0rQzPoxosHoaxkx02mYwAuyVfrhYBqhW8AM81qfQ8OFhElbgxBVzg
	 gIahUkRvdeDjipt0q5Ck4ekXxBZgY8E5M8WTdB3rafS0Yw+V8WBcE2Hb4ji8q1XkIE
	 //jTVGUbTNza0tAqxow+rcRqUFD+Y7f0CLGJtkOjjTuj+mPgbs/yJTXZ+gU0SkR/Lv
	 4S0g7H5yyUSUg==
Message-ID: <b4940bfa-aab6-644a-77d3-20bf9a876a6a@kernel.org>
Date: Tue, 30 May 2023 09:25:30 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next] net: Make gro complete function to return void
Content-Language: en-US
To: Parav Pandit <parav@nvidia.com>, edumazet@google.com,
 davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org
References: <20230529134430.492879-1-parav@nvidia.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230529134430.492879-1-parav@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/23 7:44 AM, Parav Pandit wrote:
> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> index 45dda7889387..88f9b0081ee7 100644
> --- a/net/ipv4/tcp_offload.c
> +++ b/net/ipv4/tcp_offload.c
> @@ -296,7 +296,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
>  	return pp;
>  }
>  
> -int tcp_gro_complete(struct sk_buff *skb)
> +void tcp_gro_complete(struct sk_buff *skb)
>  {
>  	struct tcphdr *th = tcp_hdr(skb);
>  
> @@ -311,8 +311,6 @@ int tcp_gro_complete(struct sk_buff *skb)
>  
>  	if (skb->encapsulation)
>  		skb->inner_transport_header = skb->transport_header;
> -
> -	return 0;
>  }
>  EXPORT_SYMBOL(tcp_gro_complete);

tcp_gro_complete seems fairly trivial. Any reason not to make it an
inline and avoid another function call in the datapath?

>  
> @@ -342,7 +340,8 @@ INDIRECT_CALLABLE_SCOPE int tcp4_gro_complete(struct sk_buff *skb, int thoff)
>  	if (NAPI_GRO_CB(skb)->is_atomic)
>  		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_FIXEDID;
>  
> -	return tcp_gro_complete(skb);
> +	tcp_gro_complete(skb);
> +	return 0;
>  }
>  




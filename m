Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D875C145265
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 11:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgAVKRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 05:17:14 -0500
Received: from www62.your-server.de ([213.133.104.62]:50544 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAVKRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 05:17:14 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuD4J-00074X-Mm; Wed, 22 Jan 2020 11:17:03 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuD4J-000GIS-BX; Wed, 22 Jan 2020 11:17:03 +0100
Subject: Re: [PATCH v3] [net]: Fix skb->csum update in
 inet_proto_csum_replace16().
To:     Praveen Chaudhary <praveen5582@gmail.com>, fw@strlen.de,
        pablo@netfilter.org, davem@davemloft.net, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
References: <1573080729-3102-1-git-send-email-pchaudhary@linkedin.com>
 <1573080729-3102-2-git-send-email-pchaudhary@linkedin.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <16d56ee6-53bc-1124-3700-bc0a78f927d6@iogearbox.net>
Date:   Wed, 22 Jan 2020 11:17:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1573080729-3102-2-git-send-email-pchaudhary@linkedin.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25702/Tue Jan 21 12:39:19 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/6/19 11:52 PM, Praveen Chaudhary wrote:
> skb->csum is updated incorrectly, when manipulation for NF_NAT_MANIP_SRC\DST
> is done on IPV6 packet.
> 
> Fix:
> No need to update skb->csum in function inet_proto_csum_replace16(), even if
> skb->ip_summed == CHECKSUM_COMPLETE, because change in L4 header checksum field
> and change in IPV6 header cancels each other for skb->csum calculation.
> 
> Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
> Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
> Signed-off-by: Andy Stracner <astracner@linkedin.com>
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>
> ---
> Changes in V2.
> 1.) Updating diff as per email discussion with Florian Westphal.
>      Since inet_proto_csum_replace16() does incorrect calculation
>      for skb->csum in all cases.
> 2.) Change in Commmit logs.
> ---
> 
> ---
> Changes in V3.
> Addressing Pablo`s Suggesion.
> 1.) Updated Subject and description
> 2.) Added full documentation of function.
> ---
> ---
>   net/core/utils.c | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/utils.c b/net/core/utils.c
> index 6b6e51d..af3b5cb 100644
> --- a/net/core/utils.c
> +++ b/net/core/utils.c
> @@ -438,6 +438,21 @@ void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
>   }
>   EXPORT_SYMBOL(inet_proto_csum_replace4);
>   
> +/**
> + * inet_proto_csum_replace16 - update L4 header checksum field as per the
> + * update in IPv6 Header. Note, there is no need to update skb->csum in this
> + * function, even if skb->ip_summed == CHECKSUM_COMPLETE, because change in L4
> + * header checksum field and change in IPV6 header cancels each other for
> + * skb->csum calculation.
> + *
> + * @sum: L4 header checksum field
> + * @skb: sk_buff for the packet
> + * @from: old IPv6 address
> + * @to: new IPv6 address
> + * @pseudohdr: True if L4 header checksum includes pseudoheader
> + *
> + * Return void
> + */
>   void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
>   			       const __be32 *from, const __be32 *to,
>   			       bool pseudohdr)
> @@ -449,9 +464,6 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
>   	if (skb->ip_summed != CHECKSUM_PARTIAL) {
>   		*sum = csum_fold(csum_partial(diff, sizeof(diff),
>   				 ~csum_unfold(*sum)));
> -		if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
> -			skb->csum = ~csum_partial(diff, sizeof(diff),
> -						  ~skb->csum);

What is the technical rationale in removing this here but not in any of the
other inet_proto_csum_replace*() functions? You changelog has zero analysis
on why here but not elsewhere this change would be needed?

>   	} else if (pseudohdr)
>   		*sum = ~csum_fold(csum_partial(diff, sizeof(diff),
>   				  csum_unfold(*sum)));
> 


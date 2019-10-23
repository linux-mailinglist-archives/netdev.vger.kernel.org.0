Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3149FE2355
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390961AbfJWTdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:33:43 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:58948 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389916AbfJWTdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 15:33:43 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iNMO1-0005gG-Bj; Wed, 23 Oct 2019 21:33:37 +0200
Date:   Wed, 23 Oct 2019 21:33:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Praveen Chaudhary <praveen5582@gmail.com>
Cc:     davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        pablo@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
Subject: Re: [PATCH] [netfilter]: Fix skb->csum calculation when netfilter
 manipulation for NF_NAT_MANIP_SRC\DST is done on IPV6 packet.
Message-ID: <20191023193337.GP25052@breakpoint.cc>
References: <1571857342-8407-1-git-send-email-pchaudhary@linkedin.com>
 <1571857342-8407-2-git-send-email-pchaudhary@linkedin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571857342-8407-2-git-send-email-pchaudhary@linkedin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Praveen Chaudhary <praveen5582@gmail.com> wrote:
> Update skb->csum, when netfilter code updates IPV6 SRC\DST address in IPV6 HEADER due to iptable rule.
> 
> Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
> Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
> Signed-off-by: Andy Stracner <astracner@linkedin.com>
> ---
>  include/net/checksum.h       |  2 ++
>  net/core/utils.c             | 13 +++++++++++++
>  net/netfilter/nf_nat_proto.c |  2 ++
>  3 files changed, 17 insertions(+)
> 
> diff --git a/include/net/checksum.h b/include/net/checksum.h
> index 97bf488..d7d28b7 100644
> --- a/include/net/checksum.h
> +++ b/include/net/checksum.h
> @@ -145,6 +145,8 @@ void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
>  void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
>  			       const __be32 *from, const __be32 *to,
>  			       bool pseudohdr);
> +void inet_proto_skb_csum_replace16(struct sk_buff *skb,
> +			       const __be32 *from, const __be32 *to);
>  void inet_proto_csum_replace_by_diff(__sum16 *sum, struct sk_buff *skb,
>  				     __wsum diff, bool pseudohdr);
>  
> diff --git a/net/core/utils.c b/net/core/utils.c
> index 6b6e51d..ab3284b 100644
> --- a/net/core/utils.c
> +++ b/net/core/utils.c
> @@ -458,6 +458,19 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL(inet_proto_csum_replace16);
>  
> +void inet_proto_skb_csum_replace16(struct sk_buff *skb,
> +			       const __be32 *from, const __be32 *to)
> +{
> +	__be32 diff[] = {
> +		~from[0], ~from[1], ~from[2], ~from[3],
> +		to[0], to[1], to[2], to[3],
> +	};
> +	if (skb->ip_summed == CHECKSUM_COMPLETE)
> +		skb->csum = csum_partial(diff, sizeof(diff),
> +				  skb->csum);
> +}
> +EXPORT_SYMBOL(inet_proto_skb_csum_replace16);
> +
>  void inet_proto_csum_replace_by_diff(__sum16 *sum, struct sk_buff *skb,
>  				     __wsum diff, bool pseudohdr)
>  {
> diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
> index 0a59c14..de94590 100644
> --- a/net/netfilter/nf_nat_proto.c
> +++ b/net/netfilter/nf_nat_proto.c
> @@ -467,6 +467,8 @@ static void nf_nat_ipv6_csum_update(struct sk_buff *skb,
>  	}
>  	inet_proto_csum_replace16(check, skb, oldip->s6_addr32,
>  				  newip->s6_addr32, true);
> +	inet_proto_skb_csum_replace16(skb, oldip->s6_addr32,
> +				  newip->s6_addr32);

This is confusing.

You're saying that inet_proto_csum_replace16() is producing a wrong
skb->csum.  So why are you adding a new function to do the
csum calculation instead of fixing inet_proto_csum_replace16() to do
the right thing?

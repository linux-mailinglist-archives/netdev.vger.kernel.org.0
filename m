Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1ECD2E815
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfE2WXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:23:17 -0400
Received: from ja.ssi.bg ([178.16.129.10]:56316 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726018AbfE2WXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 18:23:17 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x4TMM6Qe021583;
        Thu, 30 May 2019 01:22:06 +0300
Date:   Thu, 30 May 2019 01:22:06 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Jacky Hu <hengqing.hu@gmail.com>
cc:     jacky.hu@walmart.com, jason.niesz@walmart.com,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v3] ipvs: add checksum support for gue encapsulation
In-Reply-To: <20190528231107.14197-1-hengqing.hu@gmail.com>
Message-ID: <alpine.LFD.2.21.1905300115590.2934@ja.home.ssi.bg>
References: <20190528231107.14197-1-hengqing.hu@gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Wed, 29 May 2019, Jacky Hu wrote:

>  	gueh = (struct guehdr *)skb->data;
>  
>  	gueh->control = 0;
>  	gueh->version = 0;
> -	gueh->hlen = 0;
> +	gueh->hlen = optlen >> 2;
>  	gueh->flags = 0;
>  	gueh->proto_ctype = *next_protocol;
>  
> +	data = &gueh[1];
> +
> +	if (need_priv) {
> +		__be32 *flags = data;
> +		u16 csum_start = skb_checksum_start_offset(skb);
> +		__be16 *pd = data;

	Packet tests show another problem. Fix is to defer
pd assignment after data += GUE_LEN_PRIV:

		__be16 *pd;

> +
> +		gueh->flags |= GUE_FLAG_PRIV;
> +		*flags = 0;
> +		data += GUE_LEN_PRIV;
> +
> +		if (csum_start < hdrlen)
> +			return -EINVAL;
> +
> +		csum_start -= hdrlen;

		pd = data;

> +		pd[0] = htons(csum_start);
> +		pd[1] = htons(csum_start + skb->csum_offset);
> +
> +		if (!skb_is_gso(skb)) {
> +			skb->ip_summed = CHECKSUM_NONE;
> +			skb->encapsulation = 0;
> +		}
> +
> +		*flags |= GUE_PFLAG_REMCSUM;
> +		data += GUE_PLEN_REMCSUM;
> +	}
> +

Regards

--
Julian Anastasov <ja@ssi.bg>

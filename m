Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD293C51D
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404442AbfFKHaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:30:02 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42361 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404400AbfFKHaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 03:30:01 -0400
Received: by mail-wr1-f68.google.com with SMTP id x17so11708054wrl.9
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 00:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JzyBNpw2ZNnfemR3jZKVgS7dkzwPKtIKYWzQ2f3x8qs=;
        b=fK0Lcu6fLgzZPP/HRbTKB2m8t/gBuY+CQ4WdGp487n9QQR856m83u1EKC9psQL4TWH
         8YpCRYYPvd2N5PWN/WBM4TkoDz8Gew5qoztX8JUEeqcCI0r59LbsWbkhHIKZ2dmTrWIb
         2V9/TFuRI238rr6JoDNx3XOmZjycrfBmbivh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JzyBNpw2ZNnfemR3jZKVgS7dkzwPKtIKYWzQ2f3x8qs=;
        b=NYBLYMYO0LJfdoTWwifgHmHqUbNwdAoAUshLSmnl3+fRNTgHJ8hV3HwZKPnEhWMNWs
         R+3wRYbB4vnQY5Ecsbs22RpCVXgeJnVxIhgyk5vPCL7ywffA1h8Ha6yNSaryrlkZLATc
         VPZXo89wIJwHpGibqBlpuDIe25Ufr9jrv+UkPNkuchgcaOG14Wxv9wiWYNg1WKIsLAAK
         Iru9xhFLWkgnzOYQTV3bGU6uCuah94KPPCaVjQDqBGdi1MaXpVvMIXOT2+NuYnH1fNj3
         Bpk+RuNOBLMHTorfDBA5eIMMozhtJT9bLzoKaMqtNxz67/3gY62TZaGxH0yu1fPTKB9h
         6eGw==
X-Gm-Message-State: APjAAAW8b5fzfOeYDvMZc+Ss7TrNO9TN+D7vHKBm28FOga1Eo/pK29B3
        pedllxsTYkF1yt1A8sUXIOxZ4g3vmtE=
X-Google-Smtp-Source: APXvYqzJ4rMJZuu59eQ4uINzt6d5n1sQoJK7M1zAnfFxdh+18vEveuXbdB0QdDWbQFfbr2KYySrMEw==
X-Received: by 2002:a5d:5510:: with SMTP id b16mr13769053wrv.267.1560238199127;
        Tue, 11 Jun 2019 00:29:59 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 6sm13525388wrd.51.2019.06.11.00.29.57
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 00:29:57 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv4: Support multipath hashing on inner IP pkts
 for GRE tunnel
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20190611003142.11626-1-ssuryaextr@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <076bc564-7c97-f591-6b4c-2e540db4cb87@cumulusnetworks.com>
Date:   Tue, 11 Jun 2019 10:29:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190611003142.11626-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/06/2019 03:31, Stephen Suryaputra wrote:
> Multipath hash policy value of 0 isn't distributing since the outer IP
> dest and src aren't varied eventhough the inner ones are. Since the flow
> is on the inner ones in the case of tunneled traffic, hashing on them is
> desired.
> 
> This currently only supports IP over GRE and CONFIG_NET_GRE_DEMUX must
> be compiled as built-in in the kernel.
> 
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.txt |  4 ++
>  net/ipv4/route.c                       | 75 ++++++++++++++++++++++----
>  net/ipv4/sysctl_net_ipv4.c             |  2 +-
>  3 files changed, 70 insertions(+), 11 deletions(-)
> 
[snip]
> @@ -1820,6 +1827,47 @@ static void ip_multipath_l3_keys(const struct sk_buff *skb,
>  	hash_keys->addrs.v4addrs.dst = key_iph->daddr;
>  }
>  
> +static void ip_multipath_inner_l3_keys(const struct sk_buff *skb,
> +				       struct flow_keys *hash_keys)
> +{
> +	const struct iphdr *outer_iph = ip_hdr(skb);
> +	const struct iphdr *inner_iph;
> +	struct iphdr _inner_iph;
> +	int hdr_len;
> +
> +	switch (outer_iph->protocol) {
> +#ifdef CONFIG_NET_GRE_DEMUX
> +	case IPPROTO_GRE:
> +		{
> +			struct tnl_ptk_info tpi;
> +			bool csum_err = false;
> +
> +			hdr_len = gre_parse_header(skb, &tpi, &csum_err,
> +						   htons(ETH_P_IP),
> +						   outer_iph->ihl * 4);
> +			if (hdr_len > 0 && tpi.proto == htons(ETH_P_IP))
> +				break;

Have you considered using the flow dissector and doing something similar to the bonding ?
It does a full flow dissect via skb_flow_dissect_flow_keys() and uses whatever headers
it needs, but that will support any tunneling protocol which the flow dissector
recognizes and will be improved upon automatically by people adding to it.
Also would avoid doing dissection by yourself.

The bond commit which added that was:
 32819dc18348 ("bonding: modify the old and add new xmit hash policies")

> +		}
> +		/* fallthrough */
> +#endif
> +	default:
> +		/* Hash on outer for unknown tunnels, non IP tunneled, or non-
> +		 * tunneled pkts
> +		 */
> +		ip_multipath_l3_keys(skb, hash_keys, outer_iph, 0);
> +		return;
> +	}
> +	inner_iph = skb_header_pointer(skb,
> +				       outer_iph->ihl * 4 + hdr_len,
> +				       sizeof(struct iphdr), &_inner_iph);
> +	if (inner_iph) {
> +		ip_multipath_l3_keys(skb, hash_keys, inner_iph, hdr_len);
> +	} else {
> +		/* Use outer */
> +		ip_multipath_l3_keys(skb, hash_keys, outer_iph, 0);
> +	}
> +}
> +
>  /* if skb is set it will be used and fl4 can be NULL */
>  int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
>  		       const struct sk_buff *skb, struct flow_keys *flkeys)
> @@ -1828,12 +1876,13 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
>  	struct flow_keys hash_keys;
>  	u32 mhash;
>  
> +	memset(&hash_keys, 0, sizeof(hash_keys));
> +

This was an optimization, it was done on purpose to avoid doing anything when we
have L3+4 configured (1) and the skb has its hash already calculated.

>  	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
>  	case 0:
> -		memset(&hash_keys, 0, sizeof(hash_keys));
>  		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
>  		if (skb) {
> -			ip_multipath_l3_keys(skb, &hash_keys);
> +			ip_multipath_l3_keys(skb, &hash_keys, NULL, 0);
>  		} else {
>  			hash_keys.addrs.v4addrs.src = fl4->saddr;
>  			hash_keys.addrs.v4addrs.dst = fl4->daddr;
> @@ -1849,8 +1898,6 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
>  			if (skb->l4_hash)
>  				return skb_get_hash_raw(skb) >> 1;
>  
> -			memset(&hash_keys, 0, sizeof(hash_keys));
> -
>  			if (!flkeys) {
>  				skb_flow_dissect_flow_keys(skb, &keys, flag);
>  				flkeys = &keys;
> @@ -1863,7 +1910,6 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
>  			hash_keys.ports.dst = flkeys->ports.dst;
>  			hash_keys.basic.ip_proto = flkeys->basic.ip_proto;
>  		} else {
> -			memset(&hash_keys, 0, sizeof(hash_keys));
>  			hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
>  			hash_keys.addrs.v4addrs.src = fl4->saddr;
>  			hash_keys.addrs.v4addrs.dst = fl4->daddr;
> @@ -1872,6 +1918,15 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
>  			hash_keys.basic.ip_proto = fl4->flowi4_proto;
>  		}
>  		break;
> +	case 2:
> +		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
> +		if (skb) {
> +			ip_multipath_inner_l3_keys(skb, &hash_keys);
> +		} else {
> +			hash_keys.addrs.v4addrs.src = fl4->saddr;
> +			hash_keys.addrs.v4addrs.dst = fl4->daddr;
> +		}
> +		break;
>  	}
>  	mhash = flow_hash_from_keys(&hash_keys);
>  
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 2316c08e9591..e1efc2e62d21 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -960,7 +960,7 @@ static struct ctl_table ipv4_net_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_fib_multipath_hash_policy,
>  		.extra1		= &zero,
> -		.extra2		= &one,
> +		.extra2		= &two,
>  	},
>  #endif
>  	{
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C42448A3
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393266AbfFMRKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:10:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39860 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbfFMRKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 13:10:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so10903632wma.4
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 10:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hvCARmY3koL00K51Yl35jh30n/0xzcHqZ+8s3BMtB3c=;
        b=NW4Un36HdNFEpKmOwg9F7Ie4ZZrA+D8Y35Iz5xcUQuqVsmRwJ/V10pbuZNkt3clx0O
         A9fCQBwoCdCfm263WrSGPIsda07buvQCOuslqHP8b/2jdtBepCgEbhw1UqpVMW4/GOpj
         /flNOw84QhSlyJlMNdu8q/2Xe2WcLEOocmvIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hvCARmY3koL00K51Yl35jh30n/0xzcHqZ+8s3BMtB3c=;
        b=i27AePVK8SQwGFyX3z2Q4RT4qKC0Rp0jtpGQ369i7b4LenIb3RikrYi3iB1kPJH1nP
         t/2vvK3p/KwUwh4STxMi99GuER0RA+NsgLECffnycFwTPU1mbcNRyM+RzVrbz8zXNGBS
         MOsWucpKOF2gypYYyOCFhsDG3mMEpRLiGQEZpJ3XxHtfBAqvA502qYBp2CNW1Z7IVOjr
         l9ih9vrx5c7LZWiMyHUBHlwkg1Qea0HtzlMt3KBJeFUykZ1r6ItY6gMq0lcNpPAHw7R1
         fPmG1VT3cfYUU4q4LKt3eaCbVS3EB7af+UReSHvjxSEwADIbX/7+tx4d2OIShvOJuZgw
         u6lQ==
X-Gm-Message-State: APjAAAU1OCvP97gEWh2RY4L1H71N1bXzMDDvtPF2wgX3kvZIdR74TvMn
        y9VXEazc/l2STyzOdFsAtjdnBVzIhqI=
X-Google-Smtp-Source: APXvYqz3i4ih2NP5h7TwP8+Nqvf9xUe36gGStLtnnd4OysDf9tR8DclpcWXC7QuAT0evOuFEeI4JuA==
X-Received: by 2002:a1c:6c08:: with SMTP id h8mr4809663wmc.62.1560445805190;
        Thu, 13 Jun 2019 10:10:05 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id h84sm614237wmf.43.2019.06.13.10.10.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:10:04 -0700 (PDT)
Subject: Re: [PATCH net-next v2] ipv4: Support multipath hashing on inner IP
 pkts for GRE tunnel
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20190613170330.8783-1-ssuryaextr@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <3fc341e0-68f5-8a77-3f44-f050a83ce295@cumulusnetworks.com>
Date:   Thu, 13 Jun 2019 20:10:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190613170330.8783-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/06/2019 20:03, Stephen Suryaputra wrote:
> Multipath hash policy value of 0 isn't distributing since the outer IP
> dest and src aren't varied eventhough the inner ones are. Since the flow
> is on the inner ones in the case of tunneled traffic, hashing on them is
> desired.
> 
> This is done mainly for IP over GRE, hence only tested for that. But
> anything else supported by flow dissection should work.
> 
> v2: Use skb_flow_dissect_flow_keys() directly so that other tunneling
>     can be supported through flow dissection (per Nikolay Aleksandrov).
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.txt |  1 +
>  net/ipv4/route.c                       | 20 ++++++++++++++++++++
>  net/ipv4/sysctl_net_ipv4.c             |  2 +-
>  3 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index 5eedc6941ce5..2f3bc910895a 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -80,6 +80,7 @@ fib_multipath_hash_policy - INTEGER
>  	Possible values:
>  	0 - Layer 3
>  	1 - Layer 4
> +	2 - Inner Layer 3 for tunneled IP packets.

Hmm, but you're using the ports below, so it's not L3 ?

>  
>  fib_sync_mem - UNSIGNED INTEGER
>  	Amount of dirty memory from fib entries that can be backlogged before
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 14c7fdacaa72..c3e03bce0a3a 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1872,6 +1872,26 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
>  			hash_keys.basic.ip_proto = fl4->flowi4_proto;
>  		}
>  		break;
> +	case 2:
> +		memset(&hash_keys, 0, sizeof(hash_keys));
> +		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
> +		/* skb is currently provided only when forwarding */
> +		if (skb) {
> +			struct flow_keys keys;
> +
> +			skb_flow_dissect_flow_keys(skb, &keys, 0);
> +
> +			hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
> +			hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
> +			hash_keys.ports.src = keys.ports.src;
> +			hash_keys.ports.dst = keys.ports.dst;
> +			hash_keys.basic.ip_proto = keys.basic.ip_proto;

This is inconsistent with the code below, you're using ports when we have skb and
using only addresses when we don't (host traffic). So either make it L3-only and
use addresses or make sure you're using the correct ports as well.

> +		} else {
> +			/* Same as case 0 */
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


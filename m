Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C70C244195
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 01:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgHMW76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 18:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgHMW76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 18:59:58 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130B4C061757;
        Thu, 13 Aug 2020 15:59:58 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id r19so3455205qvw.11;
        Thu, 13 Aug 2020 15:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d4y6RKmJp64y+vBgl80qCMwx5Kvv2+JF1QEkaEd/Q/Y=;
        b=Mar5kH4b1luz+Eg0+FRCRdeG3PMCNh9r0ZcwNQfrIICZN3sGLom6wSFcSYxHWFGXx3
         GcQG+hF7+A1FWcDIFmYXRsvXD3jjMdX/cofcMP3dmvGcGsnLANVfawW8V2MnCx85cpqg
         rHmYiMmPLbYQPHGp8/DMSpcYwWRW9uusJyvdnZAV37t8PKq9DKTVLc4W/JZhwYLSib7O
         URlCsA9+RWGAjyqNqs0dlzi0HqZRWWQVlk2T8jSi2LPBwVS/smjuV6UQVcYrndmcSw7v
         k7Gdzf16IEpxuIi6EVJzNcJrwqmfsJfH5mJgF2jRgqJ0sUScZQzQQp0U9PW15p+TUjaN
         yqrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d4y6RKmJp64y+vBgl80qCMwx5Kvv2+JF1QEkaEd/Q/Y=;
        b=sIpI+33DGcReBEPCTK3tiv3zoLRdfFZ9UYgpM+y/9GLPJaGP59I3Kw6rFPiUTZAgMh
         Y0gJgV0ES1LqZITiHW4u25tf71igMMYfM05EKYYCLCC0Icd+C6lZ7Eg/EC3FT+Xp2sU8
         s6WH1jbD1u2myPR1khPtGZALv3t0nH5QlT3W/yrxkxj0lDUPoXDCsSVerIx1XVmb8QQ4
         1rEU0sDFdka9ZU7uapqjgt4XDIyD3H4zdRRHRmdIqNN6YVGYIZoqdMtpyadm9LkYILEO
         Fgoh0cBWEXVi6dxCF5jfgkXz1dIv723ae4oNBilfUPv3IoQFXPx2cInUuOVUUPefU+dp
         wgqw==
X-Gm-Message-State: AOAM5319dMsfPxYq31ToHWbBv2FLow3sF6wEx7eBLRkLdF3RIpv0T3HA
        vOnle2WvVeRnGYfvykGSYYWPcKGyJDQ=
X-Google-Smtp-Source: ABdhPJwZrLegS3Rzau/i8wqVIuJofDyPm23QT+dQhzDPpYvIi6pmHV7EZ2ZMog2JpgyWTkD2Yg4TCA==
X-Received: by 2002:a05:6214:2f0:: with SMTP id h16mr109906qvu.201.1597359597139;
        Thu, 13 Aug 2020 15:59:57 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:1557:417:a433:9b3f? ([2601:282:803:7700:1557:417:a433:9b3f])
        by smtp.googlemail.com with ESMTPSA id t187sm6819566qka.26.2020.08.13.15.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 15:59:56 -0700 (PDT)
Subject: Re: [PATCH 2/3] ipv4/icmp: l3mdev: Perform icmp error route lookup on
 source device routing table
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Ahern <dsahern@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200811195003.1812-1-mathieu.desnoyers@efficios.com>
 <20200811195003.1812-3-mathieu.desnoyers@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <adb0c227-9189-5f8e-cc36-0e24b789befe@gmail.com>
Date:   Thu, 13 Aug 2020 16:59:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200811195003.1812-3-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/20 1:50 PM, Mathieu Desnoyers wrote:
> As per RFC792, ICMP errors should be sent to the source host.
> 
> However, in configurations with Virtual Routing and Forwarding tables,
> looking up which routing table to use is currently done by using the
> destination net_device.
> 
> commit 9d1a6c4ea43e ("net: icmp_route_lookup should use rt dev to
> determine L3 domain") changes the interface passed to
> l3mdev_master_ifindex() and inet_addr_type_dev_table() from skb_in->dev
> to skb_dst(skb_in)->dev. This effectively uses the destination device
> rather than the source device for choosing which routing table should be
> used to lookup where to send the ICMP error.
> 
> Therefore, if the source and destination interfaces are within separate
> VRFs, or one in the global routing table and the other in a VRF, looking
> up the source host in the destination interface's routing table will
> fail if the destination interface's routing table contains no route to
> the source host.
> 
> One observable effect of this issue is that traceroute does not work in
> the following cases:
> 
> - Route leaking between global routing table and VRF
> - Route leaking between VRFs
> 
> Preferably use the source device routing table when sending ICMP error
> messages. If no source device is set, fall-back on the destination
> device routing table.
> 
> Fixes: 9d1a6c4ea43e ("net: icmp_route_lookup should use rt dev to determine L3 domain")
> Link: https://tools.ietf.org/html/rfc792
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> ---
>  net/ipv4/icmp.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index cf36f955bfe6..1eb83d82ec68 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -465,6 +465,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
>  					int type, int code,
>  					struct icmp_bxm *param)
>  {
> +	struct net_device *route_lookup_dev = NULL;
>  	struct rtable *rt, *rt2;
>  	struct flowi4 fl4_dec;
>  	int err;
> @@ -479,7 +480,17 @@ static struct rtable *icmp_route_lookup(struct net *net,
>  	fl4->flowi4_proto = IPPROTO_ICMP;
>  	fl4->fl4_icmp_type = type;
>  	fl4->fl4_icmp_code = code;
> -	fl4->flowi4_oif = l3mdev_master_ifindex(skb_dst(skb_in)->dev);
> +	/*
> +	 * The device used for looking up which routing table to use is
> +	 * preferably the source whenever it is set, which should ensure
> +	 * the icmp error can be sent to the source host, else fallback
> +	 * on the destination device.
> +	 */
> +	if (skb_in->dev)
> +		route_lookup_dev = skb_in->dev;
> +	else if (skb_dst(skb_in))
> +		route_lookup_dev = skb_dst(skb_in)->dev;
> +	fl4->flowi4_oif = l3mdev_master_ifindex(route_lookup_dev);
>  
>  	security_skb_classify_flow(skb_in, flowi4_to_flowi(fl4));
>  	rt = ip_route_output_key_hash(net, fl4, skb_in);
> @@ -503,7 +514,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
>  	if (err)
>  		goto relookup_failed;
>  
> -	if (inet_addr_type_dev_table(net, skb_dst(skb_in)->dev,
> +	if (inet_addr_type_dev_table(net, route_lookup_dev,
>  				     fl4_dec.saddr) == RTN_LOCAL) {
>  		rt2 = __ip_route_output_key(net, &fl4_dec);
>  		if (IS_ERR(rt2))
> 

ICMP's can be generated in many locations:
1. forward path - I think the skb_in dev is always set,

2. ingress and upper layer protocols -  dev is dropped prior to
transport layers, so, for example, UDP sending port unreachable calls
icmp_send with skb_in->dev set to NULL.

3. local packets and egress - e.g., link failures and here I believe skb
dev is set.

If in and out are in the same L3 domain, either device works where for
VRF route leaking with the forward path in and out are in separate
domains so yes you want the ingress device.

This change seems fine to me and I have not seen any issues with
existing selftests.

Reviewed-by: David Ahern <dsahern@kernel.org>


But I did notice that unreachable / fragmentation needed messages are
NOT working with this change. You can see that by changing the MTU of
eth1 in r1 to 1400 and running:
   ip netns exec h1 ping -s 1450 -Mdo -c1 172.16.2.2

You really should get that working as well with VRF route leaking.



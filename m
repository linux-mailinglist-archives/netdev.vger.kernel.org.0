Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52C35C1AC
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbfGARDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:03:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40662 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbfGARDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:03:18 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so264341wmj.5
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 10:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SG3c1bytHc4Lg6OlNggpaL51TFc+3K1rkGSSWjHw9kU=;
        b=Pu0M+D5IWXH6Dbwks64En+Od19SEYzWFFcxnPG0+fyxU8gjOKGfEtPzVj4NZWpVRIp
         ckOQzyiO3OExYIxCh5LUN96SfemaexrshOBavF9kdNW1eH3drgYKvhWLjEqptcBbPvVs
         iKh9HP1o6ixL1aCkBixRGgXiJx9Go9IoTtf4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SG3c1bytHc4Lg6OlNggpaL51TFc+3K1rkGSSWjHw9kU=;
        b=tIwyiOwvvtpSqNzJWOG8z1eSw1uyYT9fzw8rsk25NPDFPJ98+wGH2d6aKXMw3IdWSP
         AFbKsnY+locp36eTVO64sv/oaIIAFqNHWm7r4ZGplY1eottv8XtyuMx9GLrzpJlACehH
         DR8waIiBw0IzcVtznKLOikDs+qDxA+iQDHHaLr6sO/bq5Yv8LX/y3k53U+rICV8Piz+L
         0etw0PJPfDat7L88X0cELNSSm/hfg9Abdx34JYGlfIdzltYNGz1vL+q6dBTZUjg0vRow
         u6tEAnnRwHC0TLDI/swoBQOy2ci9T7IQsF6G47zck72qQyvR6SZfwgIPHtZao8wTUH0q
         3TAg==
X-Gm-Message-State: APjAAAWvcJuC0k/psppVOg4MXprYVUWbVuDQ9kKhUH9DX5Oyqq57XRKU
        k1ouKkU3SYXBx78lnM6KOe7pWtEpC/U=
X-Google-Smtp-Source: APXvYqwQWppoJhJWlHXTbnp7Km8CRzdAdEO19J9WGTowCqoH7908fSAoX11S/h15bAGbEhklRAH9mQ==
X-Received: by 2002:a1c:770d:: with SMTP id t13mr163768wmi.79.1562000595571;
        Mon, 01 Jul 2019 10:03:15 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id n3sm11268603wro.59.2019.07.01.10.03.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 10:03:15 -0700 (PDT)
Subject: Re: Use-after-free in br_multicast_rcv
To:     Martin Weinelt <martin@linuxlounge.net>,
        bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org
References: <41ac3aa3-cbf7-1b7b-d847-1fb308334931@linuxlounge.net>
 <E0170D52-C181-4F0F-B5F8-F1801C2A8F5A@cumulusnetworks.com>
 <21ab085f-0f7f-88bc-b661-af74dd9eeea2@linuxlounge.net>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <cc232ed3-9e02-ebb4-4901-9d617013abb8@cumulusnetworks.com>
Date:   Mon, 1 Jul 2019 20:03:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <21ab085f-0f7f-88bc-b661-af74dd9eeea2@linuxlounge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On 01/07/2019 19:53, Martin Weinelt wrote:
> Hi Nik,
> 
> more info below.
> 
> On 6/29/19 3:11 PM, nikolay@cumulusnetworks.com wrote:
>> On 29 June 2019 14:54:44 EEST, Martin Weinelt <martin@linuxlounge.net> wrote:
>>> Hello,
>>>
>>> we've recently been experiencing memory leaks on our Linux-based
>>> routers,
>>> at least as far back as v4.19.16.
>>>
>>> After rebuilding with KASAN it found a use-after-free in 
>>> br_multicast_rcv which I could reproduce on v5.2.0-rc6. 
>>>
>>> Please find the KASAN report below, I'm anot sure what else to provide
>>> so
>>> feel free to ask.
>>>
>>> Best,
>>>  Martin
>>>
>>>
>>
>> Hi Martin, 
>> I'll look into this, are there any specific steps to reproduce it? 
>>
>> Thanks, 
>>    Nik
>>>  
> Each server is a KVM Guest and has 18 bridges with the same master/slave
> relationships:
> 
>   bridge -> batman-adv -> {l2 tunnel, virtio device}
> 
> Linus Lüssing from the batman-adv asked me to apply this patch to help
> debugging.
> 
> v5.2-rc6-170-g728254541ebc with this patch yielded the following KASAN 
> report, not sure if the additional information at the end is a result of
> the added patch though.
> 
> Best,
>   Martin
> 

I see a couple of issues that can cause out-of-bounds accesses in br_multicast.c
more specifically there're pskb_may_pull calls and accesses to stale skb pointers.
I've had these on my "to fix" list for some time now, will prepare, test the fixes and
send them for review. In a few minutes I'll send a test patch for you.
That being said, I thought you said you've been experiencing memory leaks, but below
reports are for out-of-bounds accesses, could you please clarify if you were
speaking about these or is there another issue as well ?
If you're experiencing memory leaks, are you sure they're related to the bridge ?
You could try kmemleak for those.

Thank you,
 Nik

> From 47a04e977311a0c45f26905588f563b55239da7f Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
> Date: Sat, 29 Jun 2019 20:24:23 +0200
> Subject: [PATCH] bridge: DEBUG: ipv6_addr_is_ll_all_nodes() wrappers for impr.
>  call traces
> 
> ---
>  net/bridge/br_multicast.c | 70 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 63 insertions(+), 7 deletions(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index de22c8fbbb15..224a43318955 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -57,6 +57,42 @@ static void br_ip6_multicast_leave_group(struct net_bridge *br,
>  					 struct net_bridge_port *port,
>  					 const struct in6_addr *group,
>  					 __u16 vid, const unsigned char *src);
> +
> +static noinline void br_ip6_multicast_leave_group_mld2report(
> +					 struct net_bridge *br,
> +					 struct net_bridge_port *port,
> +					 const struct in6_addr *group,
> +					 __u16 vid,
> +					 const unsigned char *src)
> +{
> +	br_ip6_multicast_leave_group(br, port, group, vid, src);
> +}
> +
> +static noinline void br_ip6_multicast_leave_group_ipv6rcv(
> +					 struct net_bridge *br,
> +					 struct net_bridge_port *port,
> +					 const struct in6_addr *group,
> +					 __u16 vid,
> +					 const unsigned char *src)
> +{
> +	br_ip6_multicast_leave_group(br, port, group, vid, src);
> +}
> +
> +
> +static noinline bool ipv6_addr_is_ll_all_nodes_addgroup(const struct in6_addr *addr)
> +{
> +	return ipv6_addr_is_ll_all_nodes(addr);
> +}
> +
> +static noinline bool ipv6_addr_is_ll_all_nodes_leavegroup(const struct in6_addr *addr)
> +{
> +	return ipv6_addr_is_ll_all_nodes(addr);
> +}
> +
> +static noinline bool ipv6_addr_is_ll_all_nodes_mcastrcv(const struct in6_addr *addr)
> +{
> +	return ipv6_addr_is_ll_all_nodes(addr);
> +}
>  #endif
>  
>  static struct net_bridge_mdb_entry *br_mdb_ip_get_rcu(struct net_bridge *br,
> @@ -595,7 +631,7 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
>  {
>  	struct br_ip br_group;
>  
> -	if (ipv6_addr_is_ll_all_nodes(group))
> +	if (ipv6_addr_is_ll_all_nodes_addgroup(group))
>  		return 0;
>  
>  	memset(&br_group, 0, sizeof(br_group));
> @@ -605,6 +641,26 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
>  
>  	return br_multicast_add_group(br, port, &br_group, src);
>  }
> +
> +static noinline int br_ip6_multicast_add_group_mld2report(
> +				      struct net_bridge *br,
> +				      struct net_bridge_port *port,
> +				      const struct in6_addr *group,
> +				      __u16 vid,
> +				      const unsigned char *src)
> +{
> +	return br_ip6_multicast_add_group(br, port, group, vid, src);
> +}
> +
> +static noinline int br_ip6_multicast_add_group_ipv6rcv(
> +				      struct net_bridge *br,
> +				      struct net_bridge_port *port,
> +				      const struct in6_addr *group,
> +				      __u16 vid,
> +				      const unsigned char *src)
> +{
> +	return br_ip6_multicast_add_group(br, port, group, vid, src);
> +}
>  #endif
>  
>  static void br_multicast_router_expired(struct timer_list *t)
> @@ -1022,10 +1078,10 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
>  		if ((grec->grec_type == MLD2_CHANGE_TO_INCLUDE ||
>  		     grec->grec_type == MLD2_MODE_IS_INCLUDE) &&
>  		    ntohs(*nsrcs) == 0) {
> -			br_ip6_multicast_leave_group(br, port, &grec->grec_mca,
> +			br_ip6_multicast_leave_group_mld2report(br, port, &grec->grec_mca,
>  						     vid, src);
>  		} else {
> -			err = br_ip6_multicast_add_group(br, port,
> +			err = br_ip6_multicast_add_group_mld2report(br, port,
>  							 &grec->grec_mca, vid,
>  							 src);
>  			if (err)
> @@ -1494,7 +1550,7 @@ static void br_ip6_multicast_leave_group(struct net_bridge *br,
>  	struct br_ip br_group;
>  	struct bridge_mcast_own_query *own_query;
>  
> -	if (ipv6_addr_is_ll_all_nodes(group))
> +	if (ipv6_addr_is_ll_all_nodes_leavegroup(group))
>  		return;
>  
>  	own_query = port ? &port->ip6_own_query : &br->ip6_own_query;
> @@ -1658,7 +1714,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
>  	err = ipv6_mc_check_mld(skb);
>  
>  	if (err == -ENOMSG) {
> -		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
> +		if (!ipv6_addr_is_ll_all_nodes_mcastrcv(&ipv6_hdr(skb)->daddr))
>  			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
>  
>  		if (ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr)) {
> @@ -1683,7 +1739,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
>  	case ICMPV6_MGM_REPORT:
>  		src = eth_hdr(skb)->h_source;
>  		BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
> -		err = br_ip6_multicast_add_group(br, port, &mld->mld_mca, vid,
> +		err = br_ip6_multicast_add_group_ipv6rcv(br, port, &mld->mld_mca, vid,
>  						 src);
>  		break;
>  	case ICMPV6_MLD2_REPORT:
> @@ -1694,7 +1750,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
>  		break;
>  	case ICMPV6_MGM_REDUCTION:
>  		src = eth_hdr(skb)->h_source;
> -		br_ip6_multicast_leave_group(br, port, &mld->mld_mca, vid, src);
> +		br_ip6_multicast_leave_group_ipv6rcv(br, port, &mld->mld_mca, vid, src);
>  		break;
>  	}
>  
> 


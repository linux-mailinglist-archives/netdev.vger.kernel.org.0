Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9ED29883A
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 09:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771566AbgJZIXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 04:23:38 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:30032 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1769486AbgJZIXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 04:23:38 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 8B3575C1C0A;
        Mon, 26 Oct 2020 16:23:30 +0800 (CST)
Subject: Re: [PATCH net] ip_tunnel: fix over-mtu packet send fail without
 TUNNEL_DONT_FRAGMENT flags
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <1603272115-25351-1-git-send-email-wenxu@ucloud.cn>
 <20201023141254.7102795d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <c4dae63c-6a99-922e-5bd0-03ac355779ae@ucloud.cn>
Date:   Mon, 26 Oct 2020 16:23:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201023141254.7102795d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZQ0pPSE0aHRlCTB8eVkpNS0hMS0tNSktMSUJVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NxQ6ESo4Sz5NP0gRTzYDATwC
        QzgwFBlVSlVKTUtITEtLTUpLQktNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFISUlONwY+
X-HM-Tid: 0a75640156562087kuqy8b3575c1c0a
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/24/2020 5:12 AM, Jakub Kicinski wrote:
> On Wed, 21 Oct 2020 17:21:55 +0800 wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> The TUNNEL_DONT_FRAGMENT flags specific the tunnel outer ip can do
>> fragment or not in the md mode. Without the TUNNEL_DONT_FRAGMENT
>> should always do fragment. So it should not care the frag_off in
>> inner ip.
> Can you describe the use case better? My understanding is that we
> should propagate DF in normally functioning networks, and let PMTU 
> do its job.

Sorry for relying so late.  ip_md_tunnel_xmit send packet in the collect_md mode.

For OpenVswitch example, ovs set the gre port with flags df_default=false which will not

set TUNNEL_DONT_FRAGMENT for tun_flags.

And the mtu of virtual machine is 1500 with default. And the tunnel underlay device mtu

is 1500 default too. So if the size of packet send from vm +  underlay length > underlay device mtu.

The packet always be dropped if the ip header of  packet set flags with DF.

In the collect_md the outer packet can fragment or not should depends on the tun_flags but not inner

ip header like vxlan device did.

>> Fixes: cfc7381b3002 ("ip_tunnel: add collect_md mode to IPIP tunnel")
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  net/ipv4/ip_tunnel.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
>> index 8b04d1d..ee65c92 100644
>> --- a/net/ipv4/ip_tunnel.c
>> +++ b/net/ipv4/ip_tunnel.c
>> @@ -608,9 +608,6 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
>>  			ttl = ip4_dst_hoplimit(&rt->dst);
>>  	}
>>  
>> -	if (!df && skb->protocol == htons(ETH_P_IP))
>> -		df = inner_iph->frag_off & htons(IP_DF);
>> -
>>  	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
>>  	if (headroom > dev->needed_headroom)
>>  		dev->needed_headroom = headroom;
>

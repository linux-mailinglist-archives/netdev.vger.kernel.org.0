Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCE06371B
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfGINjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:39:14 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:61529 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfGINjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 09:39:13 -0400
Received: from [192.168.1.5] (unknown [180.157.105.169])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 42BE241B81;
        Tue,  9 Jul 2019 21:38:59 +0800 (CST)
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_nat_proto: add
 nf_nat_bridge_ops support
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1562574567-8293-1-git-send-email-wenxu@ucloud.cn>
 <20190708141730.ozycgmtrub7ok2qs@breakpoint.cc>
 <0a4cf910-6c87-34b6-3018-3e25f6fecdce@ucloud.cn>
 <20190709104206.gy6l52rx2dat3743@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <d70cb6ae-1e90-16b2-083c-8da8112e1f28@ucloud.cn>
Date:   Tue, 9 Jul 2019 21:38:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190709104206.gy6l52rx2dat3743@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkNMS0tLSk5OT09DQkpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OBw6Mjo4KTgzTQ0qFy4pFDoq
        FQ8KCkhVSlVKTk1JTUxCTkhCT0xOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSktOVUpNQllXWQgBWUFPSkxPNwY+
X-HM-Tid: 0a6bd6f576d22086kuqy42be241b81
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/7/9 18:42, Florian Westphal 写道:
> wenxu <wenxu@ucloud.cn> wrote:
>>> For NAT on bridge, it should be possible already to push such packets
>>> up the stack by
>>>
>>> bridge input meta iif eth0 ip saddr 192.168.0.0/16 \
>>>        meta pkttype set unicast ether daddr set 00:11:22:33:44:55
>> yes, packet can be push up to IP stack to handle the nat through bridge device. 
>>
>> In my case dnat 2.2.1.7 to 10.0.0.7, It assume the mac address of the two address
>> is the same known by outer.
> I think that in general they will have different MAC addresses, so plain
> replacement of ip addresses won't work.
>
>> But in This case modify the packet dmac to bridge device, the packet push up through bridge device
>> Then do nat and route send back to bridge device.
> Are you saying that you can use the send-to-ip-layer approach?
>
> We might need/want a more convenient way to do this.
> There are two ways that I can see:
>
> 1. a redirect support for nftables bridge family.
>    The redirect expression would be same as "ether daddr set
>    <bridge_mac>", but there is no need to know the bridge mac address.
>
> 2. Support ebtables -t broute in nftables.
>    The route rework for ebtables has been completed already, so
>    this needs a new expression.  Packet that is brouted behaves
>    as if the bridge port was not part of the bridge.

This is my senario:

For a virtual machine example with address  10.0.0.7 and internet address 2.2.1.7  default router

10.0.0.1. There are both the east-west and south-north traffic. So the outer vnet0 connect to bridge

br0 which with address 10.0.0.1.   The bridge also add an flow-based/metadata_dst vxlan device vxlan0.


So there are three kinds traffic to handle:

1. 10.0.0.7 <-----> 10.0.0.8: both ingress and egress packet gothrough the bridge with vlanid to vni feature.

2. 10.0.0.7 <-----> 10.0.1.8: The egress packet push up to stack through br0 to do route. And the route send packet through

vxlan0 to peer with static mac(Maybe the route can send through br0); The ingress packet always gothrough the bridge to VM.

3. 10.0.0.7  <----> 1.1.1.7: The egress The egress packet push up to stack through br0 to do route and nat. And the route send

packet through vxlan0 to router. With this patche, The router assume is the same mac address for 10.0.0.7 and 2.2.1.7. so it can do

nat under bridge and send to VM.


I think the most big problem is that the only vxlan0 device is alyways attach on br0. For L3( do route) traffic the egress packet will push

up to stack do route through br0.  The ingress I hope only gothrough the bridge to VM for all the three kinds traffic above.


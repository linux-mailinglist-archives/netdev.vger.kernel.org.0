Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63E559208
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 05:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfF1Dhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 23:37:52 -0400
Received: from m97188.mail.qiye.163.com ([220.181.97.188]:60052 "EHLO
        m97188.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfF1Dhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 23:37:52 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m97188.mail.qiye.163.com (Hmail) with ESMTPA id E9E0E964028;
        Fri, 28 Jun 2019 11:37:47 +0800 (CST)
Subject: Re: [PATCH 2/3 nf-next] netfilter:nf_flow_table: Support bridge type
 flow offload
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1561545148-11978-1-git-send-email-wenxu@ucloud.cn>
 <1561545148-11978-2-git-send-email-wenxu@ucloud.cn>
 <20190626183816.3ux3iifxaal4ffil@breakpoint.cc>
 <20190626191945.2mktaqrcrfcrfc66@breakpoint.cc>
 <dce5cba2-766c-063e-745f-23b3dd83494b@ucloud.cn>
 <20190627125839.t56fnptdeqixt7wd@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <b2a48653-9f30-18a9-d0e1-eaa940a361a9@ucloud.cn>
Date:   Fri, 28 Jun 2019 11:37:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190627125839.t56fnptdeqixt7wd@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUhXWQgYFAkeWUFZVkpVS0lNS0tLSk9JS0JMT0xZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MlE6KTo6ITg5EAsvTxU9CAtR
        QjoaFBFVSlVKTk1KTUJIS01DSU5LVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBQ0NOQzcG
X-HM-Tid: 0a6b9c291b4320bckuqye9e0e964028
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/27/2019 8:58 PM, Pablo Neira Ayuso wrote:
> On Thu, Jun 27, 2019 at 02:22:36PM +0800, wenxu wrote:
>> On 6/27/2019 3:19 AM, Florian Westphal wrote:
>>> Florian Westphal <fw@strlen.de> wrote:
> [...]
>>>> Whats the idea with this patch?
>>>>
>>>> Do you see a performance improvement when bypassing bridge layer? If so,
>>>> how much?
>>>>
>>>> I just wonder if its really cheaper than not using bridge conntrack in
>>>> the first place :-)
>> This patch is based on the conntrack function in bridge.  It will
>> bypass the fdb lookup and conntrack lookup to get the performance 
>> improvement. The more important things for hardware offload in the
>> future with nf_tables add hardware offload support
> Florian would like to see numbers / benchmark.


I just did a simple performace test with following test.

p netns add ns21
ip netns add ns22
ip l add dev veth21 type veth peer name eth0 netns ns21
ip l add dev veth22 type veth peer name eth0 netns ns22
ifconfig veth21 up
ifconfig veth22 up
ip netns exec ns21 ip a a dev eth0 10.0.0.7/24
ip netns exec ns22 ip a a dev eth0 10.0.0.8/24
ip netns exec ns21 ifconfig eth0 up
ip netns exec ns22 ifconfig eth0 up

ip l add dev br0 type bridge vlan_filtering 1
brctl addif br0 veth21
brctl addif br0 veth22

ifconfig br0 up

bridge vlan add dev veth21 vid 200 pvid untagged
bridge vlan add dev veth22 vid 200 pvid untagged

nft add table bridge firewall
nft add chain bridge firewall zones { type filter hook prerouting priority - 300 \; }
nft add rule bridge firewall zones counter ct zone set iif map { "veth21" : 2, "veth22" : 2 }

nft add chain bridge firewall rule-200-ingress
nft add rule bridge firewall rule-200-ingress ct zone 2 ct state established,related counter accept
nft add rule bridge firewall rule-200-ingress ct zone 2 ct state invalid counter drop
nft add rule bridge firewall rule-200-ingress ct zone 2 tcp dport 23 ct state new counter accept
nft add rule bridge firewall rule-200-ingress counter drop

nft add chain bridge firewall rule-200-egress
nft add rule bridge firewall rule-200-egress ct zone 2 ct state established,related counter accept
nft add rule bridge firewall rule-200-egress ct zone 2 ct state invalid counter drop
nft add rule bridge firewall rule-200-egress ct zone 2 tcp dport 23 ct state new counter drop
nft add rule bridge firewall rule-200-egress counter accept

nft add chain bridge firewall rules-all { type filter hook prerouting priority - 150 \; }
nft add rule bridge firewall rules-all counter meta protocol ip iif vmap { "veth22" : jump rule-200-ingress, "veth21" : jump rule-200-egress }



netns21 communication with ns22


ns21 iperf to 10.0.0.8 with dport 22 in ns22


first time with OFFLOAD enable

nft add flowtable bridge firewall fb2 { hook ingress priority 0 \; devices = { veth21, veth22 } \; }
nft add chain bridge firewall ftb-all {type filter hook forward priority 0 \; policy accept \; }
nft add rule bridge firewall ftb-all counter ct zone 2 ip protocol tcp flow offload @fb2

# iperf -c 10.0.0.8 -p 22 -t 60 -i2
------------------------------------------------------------
Client connecting to 10.0.0.8, TCP port 22
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 10.0.0.7 port 60014 connected with 10.0.0.8 port 22
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 2.0 sec  10.8 GBytes  46.5 Gbits/sec
[  3]  2.0- 4.0 sec  10.9 GBytes  46.7 Gbits/sec
[  3]  4.0- 6.0 sec  10.9 GBytes  46.8 Gbits/sec
[  3]  6.0- 8.0 sec  11.0 GBytes  47.2 Gbits/sec
[  3]  8.0-10.0 sec  11.0 GBytes  47.1 Gbits/sec
[  3] 10.0-12.0 sec  11.0 GBytes  47.1 Gbits/sec
[  3] 12.0-14.0 sec  11.7 GBytes  50.4 Gbits/sec
[  3] 14.0-16.0 sec  12.0 GBytes  51.6 Gbits/sec
[  3] 16.0-18.0 sec  12.0 GBytes  51.6 Gbits/sec
[  3] 18.0-20.0 sec  12.0 GBytes  51.6 Gbits/sec
[  3] 20.0-22.0 sec  12.0 GBytes  51.5 Gbits/sec
[  3] 22.0-24.0 sec  12.0 GBytes  51.4 Gbits/sec
[  3] 24.0-26.0 sec  12.0 GBytes  51.3 Gbits/sec
[  3] 26.0-28.0 sec  12.0 GBytes  51.7 Gbits/sec
[  3] 28.0-30.0 sec  12.0 GBytes  51.6 Gbits/sec
[  3] 30.0-32.0 sec  12.0 GBytes  51.6 Gbits/sec
[  3] 32.0-34.0 sec  12.0 GBytes  51.6 Gbits/sec
[  3] 34.0-36.0 sec  12.0 GBytes  51.5 Gbits/sec
[  3] 36.0-38.0 sec  12.0 GBytes  51.5 Gbits/sec
[  3] 38.0-40.0 sec  12.0 GBytes  51.6 Gbits/sec
[  3] 40.0-42.0 sec  12.0 GBytes  51.6 Gbits/sec
[  3] 42.0-44.0 sec  12.0 GBytes  51.5 Gbits/sec
[  3] 44.0-46.0 sec  12.0 GBytes  51.4 Gbits/sec
[  3] 46.0-48.0 sec  12.0 GBytes  51.4 Gbits/sec
[  3] 48.0-50.0 sec  12.0 GBytes  51.5 Gbits/sec
[  3] 50.0-52.0 sec  12.0 GBytes  51.6 Gbits/sec
[  3] 52.0-54.0 sec  12.0 GBytes  51.6 Gbits/sec
[  3] 54.0-56.0 sec  12.0 GBytes  51.5 Gbits/sec
[  3] 56.0-58.0 sec  11.9 GBytes  51.2 Gbits/sec
[  3] 58.0-60.0 sec  11.8 GBytes  50.7 Gbits/sec
[  3]  0.0-60.0 sec   353 GBytes  50.5 Gbits/sec


The second time on any offload:
# iperf -c 10.0.0.8 -p 22 -t 60 -i2
------------------------------------------------------------
Client connecting to 10.0.0.8, TCP port 22
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 10.0.0.7 port 60536 connected with 10.0.0.8 port 22
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 2.0 sec  8.88 GBytes  38.1 Gbits/sec
[  3]  2.0- 4.0 sec  9.02 GBytes  38.7 Gbits/sec
[  3]  4.0- 6.0 sec  9.02 GBytes  38.8 Gbits/sec
[  3]  6.0- 8.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3]  8.0-10.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3] 10.0-12.0 sec  9.04 GBytes  38.8 Gbits/sec
[  3] 12.0-14.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3] 14.0-16.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3] 16.0-18.0 sec  9.06 GBytes  38.9 Gbits/sec
[  3] 18.0-20.0 sec  9.07 GBytes  39.0 Gbits/sec
[  3] 20.0-22.0 sec  9.07 GBytes  38.9 Gbits/sec
[  3] 22.0-24.0 sec  9.06 GBytes  38.9 Gbits/sec
[  3] 24.0-26.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3] 26.0-28.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3] 28.0-30.0 sec  9.06 GBytes  38.9 Gbits/sec
[  3] 30.0-32.0 sec  9.06 GBytes  38.9 Gbits/sec
[  3] 32.0-34.0 sec  9.07 GBytes  38.9 Gbits/sec
[  3] 34.0-36.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3] 36.0-38.0 sec  9.03 GBytes  38.8 Gbits/sec
[  3] 38.0-40.0 sec  9.03 GBytes  38.8 Gbits/sec
[  3] 40.0-42.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3] 42.0-44.0 sec  9.03 GBytes  38.8 Gbits/sec
[  3] 44.0-46.0 sec  9.04 GBytes  38.8 Gbits/sec
[  3] 46.0-48.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3] 48.0-50.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3] 50.0-52.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3] 52.0-54.0 sec  9.06 GBytes  38.9 Gbits/sec
[  3] 54.0-56.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3] 56.0-58.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3] 58.0-60.0 sec  9.05 GBytes  38.9 Gbits/sec
[  3]  0.0-60.0 sec   271 GBytes  38.8 Gbits/sec




>

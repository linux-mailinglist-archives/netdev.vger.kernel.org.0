Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32356112D7B
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 15:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfLDOdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 09:33:07 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:43777 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbfLDOdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 09:33:07 -0500
Received: from [192.168.1.7] (unknown [180.157.173.7])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 1033141DA2;
        Wed,  4 Dec 2019 22:32:54 +0800 (CST)
Subject: Re: Bad performance for VF outgoing in offloaded mode
To:     Roi Dayan <roid@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
References: <1574147331-31096-1-git-send-email-wenxu@ucloud.cn>
 <20191119.163923.660983355933809356.davem@davemloft.net>
 <2a08a1aa-6aa8-c361-f825-458d234d975f@ucloud.cn>
 <AM4PR05MB3411591D31D7B22EE96BC6C3CF4E0@AM4PR05MB3411.eurprd05.prod.outlook.com>
 <f0552f13-ae5d-7082-9f68-0358d560c073@ucloud.cn>
 <VI1PR05MB34224DF57470AE3CC46F2CACCF4E0@VI1PR05MB3422.eurprd05.prod.outlook.com>
 <746ba973-3c58-31f8-42ce-db880fd1d8f4@ucloud.cn>
 <VI1PR05MB3422BEDAB38E12C26DF7C6C6CF4E0@VI1PR05MB3422.eurprd05.prod.outlook.com>
 <64285654-bc9a-c76e-5875-dc6e434dc4d4@ucloud.cn>
 <AM4PR05MB3411EE998E04B7AA9E0081F0CF4B0@AM4PR05MB3411.eurprd05.prod.outlook.com>
 <1b13e159-1030-2ea3-f69e-578041504ee6@ucloud.cn>
 <84874b42-c525-2149-539d-e7510d15f6a6@mellanox.com>
 <fc909cd7-3e82-89a6-9fe8-8eba546686d8@ucloud.cn>
 <ee1a369f-58c7-1fd4-f0fe-09b2a9900931@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <08de868c-31df-6688-9235-dea0ebd4d676@ucloud.cn>
Date:   Wed, 4 Dec 2019 22:32:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <ee1a369f-58c7-1fd4-f0fe-09b2a9900931@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUtPS0tLSkpOSEJPTkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NAg6MRw*STg0NVYNCgIxCz4r
        HQEaCRxVSlVKTkxOT01CQkxPSU1CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSkxIVUxZV1kIAVlBQk5OSDcG
X-HM-Tid: 0a6ed15402932086kuqy1033141da2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/12/4 21:50, Roi Dayan 写道:
>
> On 2019-11-28 7:03 AM, wenxu wrote:
>> Hi mellanox team,
>>
>>
>> I did a performance test for tc offload with upstream kernel:
>>
>> I setup a vm with a VF as eth0
>>
>> In the vm:
>>
>> ifconfig eth0 10.0.0.75/24 up
>>
>>
>> On the host the mlx_p0 is the pf representor and mlx_pf0vf0 is the vf representor
>>
>> The device in the switchdev mode
>>
>> # grep -ri "" /sys/class/net/*/phys_* 2>/dev/null
>> /sys/class/net/mlx_p0/phys_port_name:p0
>> /sys/class/net/mlx_p0/phys_switch_id:34ebc100034b6b50
>> /sys/class/net/mlx_pf0vf0/phys_port_name:pf0vf0
>> /sys/class/net/mlx_pf0vf0/phys_switch_id:34ebc100034b6b50
>> /sys/class/net/mlx_pf0vf1/phys_port_name:pf0vf1
>> /sys/class/net/mlx_pf0vf1/phys_switch_id:34ebc100034b6b50
>>
>>
>> The tc filter as following: just forward ip/arp packets  in mlx_p0 and mlx_pf0vf0 each other
>>
>> tc qdisc add dev mlx_p0 ingress
>> tc qdisc add dev mlx_pf0vf0 ingress
>>
>> tc filter add dev mlx_pf0vf0 pref 2 ingress  protocol ip flower skip_sw action mirred egress redirect dev mlx_p0
>> tc filter add dev mlx_p0 pref 2 ingress  protocol ip flower skip_sw action mirred egress redirect dev mlx_pf0vf0
>>
>> tc filter add dev mlx_pf0vf0 pref 1 ingress  protocol arp flower skip_sw action mirred egress redirect dev mlx_p0
>> tc filter add dev mlx_p0 pref 1 ingress  protocol arp flower skip_sw action mirred egress redirect dev mlx_pf0vf0
>>
>>
>> The remote server device eth0:
>>
>> ifconfig eth0 10.0.0.241/24
>>
>>
>> test case 1:   tcp recieve from VF to PF
>>
>> In the vm: iperf -s
>>
>> On the remote server:
>>
>> iperf -c 10.0.0.75 -t 10 -i 2
>> ------------------------------------------------------------
>> Client connecting to 10.0.0.75, TCP port 5001
>> TCP window size: 85.0 KByte (default)
>> ------------------------------------------------------------
>> [  3] local 10.0.0.241 port 59708 connected with 10.0.0.75 port 5001
>> [ ID] Interval       Transfer     Bandwidth
>> [  3]  0.0- 2.0 sec  5.40 GBytes  23.2 Gbits/sec
>> [  3]  2.0- 4.0 sec  5.35 GBytes  23.0 Gbits/sec
>> [  3]  4.0- 6.0 sec  5.46 GBytes  23.5 Gbits/sec
>> [  3]  6.0- 8.0 sec  5.10 GBytes  21.9 Gbits/sec
>> [  3]  8.0-10.0 sec  5.36 GBytes  23.0 Gbits/sec
>> [  3]  0.0-10.0 sec  26.7 GBytes  22.9 Gbits/sec
>>
>>
>> Good performance with offload.
>>
>> # tc -s filter ls dev mlx_p0 ingress
>> filter protocol arp pref 1 flower chain 0
>> filter protocol arp pref 1 flower chain 0 handle 0x1
>>   eth_type arp
>>   skip_sw
>>   in_hw in_hw_count 1
>>     action order 1: mirred (Egress Redirect to device mlx_pf0vf0) stolen
>>      index 4 ref 1 bind 1 installed 971 sec used 82 sec
>>      Action statistics:
>>     Sent 420 bytes 7 pkt (dropped 0, overlimits 0 requeues 0)
>>     Sent software 0 bytes 0 pkt
>>     Sent hardware 420 bytes 7 pkt
>>     backlog 0b 0p requeues 0
>>
>> filter protocol ip pref 2 flower chain 0
>> filter protocol ip pref 2 flower chain 0 handle 0x1
>>   eth_type ipv4
>>   skip_sw
>>   in_hw in_hw_count 1
>>     action order 1: mirred (Egress Redirect to device mlx_pf0vf0) stolen
>>      index 2 ref 1 bind 1 installed 972 sec used 67 sec
>>      Action statistics:
>>     Sent 79272204362 bytes 91511261 pkt (dropped 0, overlimits 0 requeues 0)
>>     Sent software 0 bytes 0 pkt
>>     Sent hardware 79272204362 bytes 91511261 pkt
>>     backlog 0b 0p requeues 0
>>
>> #  tc -s filter ls dev mlx_pf0vf0 ingress
>> filter protocol arp pref 1 flower chain 0
>> filter protocol arp pref 1 flower chain 0 handle 0x1
>>   eth_type arp
>>   skip_sw
>>   in_hw in_hw_count 1
>>     action order 1: mirred (Egress Redirect to device mlx_p0) stolen
>>      index 3 ref 1 bind 1 installed 978 sec used 88 sec
>>      Action statistics:
>>     Sent 600 bytes 10 pkt (dropped 0, overlimits 0 requeues 0)
>>     Sent software 0 bytes 0 pkt
>>     Sent hardware 600 bytes 10 pkt
>>     backlog 0b 0p requeues 0
>>
>> filter protocol ip pref 2 flower chain 0
>> filter protocol ip pref 2 flower chain 0 handle 0x1
>>   eth_type ipv4
>>   skip_sw
>>   in_hw in_hw_count 1
>>     action order 1: mirred (Egress Redirect to device mlx_p0) stolen
>>      index 1 ref 1 bind 1 installed 978 sec used 73 sec
>>      Action statistics:
>>     Sent 71556027574 bytes 47805525 pkt (dropped 0, overlimits 0 requeues 0)
>>     Sent software 0 bytes 0 pkt
>>     Sent hardware 71556027574 bytes 47805525 pkt
>>     backlog 0b 0p requeues 0
>>
>>
>>
>> test case 2:  tcp send from VF to PF
>>
>> On the reomte server: iperf -s
>>
>> in the vm:
>>
>> # iperf -c 10.0.0.241 -t 10 -i 2
>>
>> ------------------------------------------------------------
>> Client connecting to 10.0.0.241, TCP port 5001
>> TCP window size:  230 KByte (default)
>> ------------------------------------------------------------
>> [  3] local 10.0.0.75 port 53166 connected with 10.0.0.241 port 5001
>> [ ID] Interval       Transfer     Bandwidth
>> [  3]  0.0- 2.0 sec   939 MBytes  3.94 Gbits/sec
>> [  3]  2.0- 4.0 sec   944 MBytes  3.96 Gbits/sec
>> [  3]  4.0- 6.0 sec  1.01 GBytes  4.34 Gbits/sec
>> [  3]  6.0- 8.0 sec  1.03 GBytes  4.44 Gbits/sec
>> [  3]  8.0-10.0 sec  1.02 GBytes  4.39 Gbits/sec
>> [  3]  0.0-10.0 sec  4.90 GBytes  4.21 Gbits/sec
>>
>>
>> Bad performance with offload.  All the packet are offloaded. 
>>
>> It is the offload problem in the hardware?
>>
>>
>> BR
>>
>> wenxu
>>
>>
> Hi Wenxu,
>
> We didn't notice this behavior.
> Could it be your VM doesn't have enough resources to generate the traffic?
> As a listener it's only sending the acks.

I  don't think so. If delete the ingress qdisc on mlx_pf0vf0 and set ifconfig mlx_pf0vf0 10.0.0.241/24"

iperf -s on the host.

In the vm.

# iperf -c 10.0.0.241 -t 10 -i 2
------------------------------------------------------------
Client connecting to 10.0.0.241, TCP port 5001
TCP window size: 4.00 MByte (default)
------------------------------------------------------------
[  3] local 10.0.0.75 port 50960 connected with 10.0.0.241 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 2.0 sec  6.34 GBytes  27.3 Gbits/sec
[  3]  2.0- 4.0 sec  6.45 GBytes  27.7 Gbits/sec
[  3]  4.0- 6.0 sec  6.65 GBytes  28.6 Gbits/sec
[  3]  6.0- 8.0 sec  6.60 GBytes  28.3 Gbits/sec
[  3]  8.0-10.0 sec  6.29 GBytes  27.0 Gbits/sec
[  3]  0.0-10.0 sec  32.3 GBytes  27.8 Gbits/sec


The VM can generic enough traffic. Maybe you can test my case with upstream kernel

> Thanks,
> Roi

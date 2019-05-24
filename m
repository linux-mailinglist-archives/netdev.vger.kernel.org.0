Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B24628E7E
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 03:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388824AbfEXBDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 21:03:01 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:2538 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388803AbfEXBDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 21:03:01 -0400
Received: from [192.168.1.3] (unknown [116.234.5.34])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 30C7F5C1192;
        Fri, 24 May 2019 09:02:57 +0800 (CST)
Subject: Re: Bug or mis configuration for mlx5e lag and multipath
To:     Roi Dayan <roid@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <678285cb-0821-405a-57ae-0d72e96f9ef7@ucloud.cn>
 <8bbeec48-6bbc-260c-91e3-4b58290055b2@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <c670c82c-877e-199a-da17-891dd2de571d@ucloud.cn>
Date:   Fri, 24 May 2019 09:02:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8bbeec48-6bbc-260c-91e3-4b58290055b2@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kIGBQJHllBWVZJVUtKTktLS0pLT0JLT0pMWVdZKFlBSUI3V1ktWUFJV1
        kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NjI6Dxw6KjgwNiwpLRlPTQMX
        NQwwFD9VSlVKTk5DTU5CTExMTUJNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VTlVIT1lXWQgBWUFOT05CNwY+
X-HM-Tid: 0a6ae75cc3a62087kuqy30c7f5c1192
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I can get the right log from demsg

 mlx5_core 0000:81:00.0: modify lag map port 1:1 port 2:2


I debug with the driver, I find the rule be add on mlx_pf0vf0 and the peer one pf1,

So I think the esw0 and esw1 both have the rule.

The test case is based on the master branch of the net git tree.

在 2019/5/23 23:15, Roi Dayan 写道:
>
> On 20/05/2019 04:53, wenxu wrote:
>> Hi Roi & Saeed,
>>
>> I just test the mlx5e lag and mutipath feature. There are some suituation the outgoing can't be offloaded.
>>
>> ovs configureation as following.
>>
>> # ovs-vsctl show
>> dfd71dfb-6e22-423e-b088-d2022103af6b
>>     Bridge "br0"
>>         Port "mlx_pf0vf0"
>>             Interface "mlx_pf0vf0"
>>         Port gre
>>             Interface gre
>>                 type: gre
>>                 options: {key="1000", local_ip="172.168.152.75", remote_ip="172.168.152.241"}
>>         Port "br0"
>>             Interface "br0"
>>                 type: internal
>>
>> set the mlx5e driver:
>>
>>
>> modprobe mlx5_core
>> echo 0 > /sys/class/net/eth2/device/sriov_numvfs
>> echo 0 > /sys/class/net/eth3/device/sriov_numvfs
>> echo 2 > /sys/class/net/eth2/device/sriov_numvfs
>> echo 2 > /sys/class/net/eth3/device/sriov_numvfs
>> lspci -nn | grep Mellanox
>> echo 0000:81:00.2 > /sys/bus/pci/drivers/mlx5_core/unbind
>> echo 0000:81:00.3 > /sys/bus/pci/drivers/mlx5_core/unbind
>> echo 0000:81:03.6 > /sys/bus/pci/drivers/mlx5_core/unbind
>> echo 0000:81:03.7 > /sys/bus/pci/drivers/mlx5_core/unbind
>>
>> devlink dev eswitch set pci/0000:81:00.0  mode switchdev encap enable
>> devlink dev eswitch set pci/0000:81:00.1  mode switchdev encap enable
>>
>> modprobe bonding mode=802.3ad miimon=100 lacp_rate=1
>> ip l del dev bond0
>> ifconfig mlx_p0 down
>> ifconfig mlx_p1 down
>> ip l add dev bond0 type bond mode 802.3ad
>> ifconfig bond0 172.168.152.75/24 up
>> echo 1 > /sys/class/net/bond0/bonding/xmit_hash_policy
>> ip l set dev mlx_p0 master bond0
>> ip l set dev mlx_p1 master bond0
>> ifconfig mlx_p0 up
>> ifconfig mlx_p1 up
>>
>> systemctl start openvswitch
>> ovs-vsctl set Open_vSwitch . other_config:hw-offload=true
>> systemctl restart openvswitch
>>
>>
>> mlx_pf0vf0 is assigned to vm. The tc rule show in_hw
>>
>> # tc filter ls dev mlx_pf0vf0 ingress
>> filter protocol ip pref 2 flower
>> filter protocol ip pref 2 flower handle 0x1
>>   dst_mac 8e:c0:bd:bf:72:c3
>>   src_mac 52:54:00:00:12:75
>>   eth_type ipv4
>>   ip_tos 0/3
>>   ip_flags nofrag
>>   in_hw
>>     action order 1: tunnel_key set
>>     src_ip 172.168.152.75
>>     dst_ip 172.168.152.241
>>     key_id 1000 pipe
>>     index 2 ref 1 bind 1
>>  
>>     action order 2: mirred (Egress Redirect to device gre_sys) stolen
>>      index 2 ref 1 bind 1
>>
>> In the vm:  the mlx5e driver enable xps default (by the way I think it is better not enable xps in default kernel can select queue by each flow),  in the lag mode different vf queue associate with hw PF.
>>
>> with command taskset -c 2 ping 10.0.0.241
>>
>> the packet can be offloaded , the outgoing pf is mlx_p0
>>
>> but with command taskset -c 1 ping 10.0.0.241
>>
>> the packet can't be offloaded, I can capture the packet on the mlx_pf0vf0, the outgoing pf is mlx_p1. Althrough the tc flower rule show in_hw
>>
>>
>> I check with the driver  both mlx_pf0vf0 and peer(mlx_p1) install the tc rule success
>>
>> I think it's a problem of lag mode. Or I miss some configureation?
>>
>>
>> BR
>>
>> wenxu
>>
>>
>>
>>
>>
> Hi,
>
> we need to verify the driver detected to be in lag mode and
> duplicated the offload rule to both eswitches.
> do you see lag map messages in dmesg?
> something like "lag map port 1:1 port 2:2"
> this is to make sure the driver actually in lag mode.
> in this mode a rule added to mlx_pf0vf0 will be added to esw of pf0 and esw of pf1.
> then when u send a packet it could be handled in esw0 or esw1
> if the rule is not in esw1 then it wont be offloaded when using pf1.
>
> thanks,
> Roi

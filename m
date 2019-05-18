Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 344B32215A
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 05:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfERDRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 23:17:23 -0400
Received: from m97188.mail.qiye.163.com ([220.181.97.188]:15437 "EHLO
        smtp.qiye.163.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727183AbfERDRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 23:17:23 -0400
Received: from [192.168.1.5] (unknown [58.38.1.117])
        by smtp.qiye.163.com (Hmail) with ESMTPA id 8CC3696399C;
        Sat, 18 May 2019 11:17:21 +0800 (CST)
Subject: Re: [PATCH v2] net/mlx5e: Add bonding device for indr block to
 offload the packet received from bonding device
To:     Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1558084668-21203-1-git-send-email-wenxu@ucloud.cn>
 <1129938e-2dff-9aed-5a76-f438e3e7ea15@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <2b7bb0a4-d697-2a7e-fa02-399f1368d809@ucloud.cn>
Date:   Sat, 18 May 2019 11:17:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1129938e-2dff-9aed-5a76-f438e3e7ea15@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kIGBQJHllBWVZKVUJDSUtLS0hOS0JOSUpOWVdZKFlBSUI3V1ktWUFJV1
        kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PRg6MTo*FDg*GC46LkJJIS88
        GRYwCglVSlVKTk5DSk9CT09KQ0tJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWU5DVUhD
        VUpVSkpMWVdZCAFZQUhIT0k3Bg++
X-HM-Tid: 0a6ac8f1a8cb20bckuqy8cc3696399c
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/5/18 6:11, Mark Bloch 写道:
>
> On 5/17/19 2:17 AM, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> The mlx5e support the lag mode. When add mlx_p0 and mlx_p1 to bond0.
>> packet received from mlx_p0 or mlx_p1 and in the ingress tc flower
>> forward to vf0. The tc rule can't be offloaded because there is
>> no indr_register_block for the bonding device.
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> index 91e24f1..134fa0b 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> @@ -796,6 +796,7 @@ static int mlx5e_nic_rep_netdevice_event(struct notifier_block *nb,
>>  	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
>>  
>>  	if (!mlx5e_tc_tun_device_to_offload(priv, netdev) &&
>> +	    !netif_is_bond_master(netdev) &&
> I'm not that familiar with this code path, but shouldn't you check the mlx5e
> netdevices are slaves of the bond device (what if you have multiple
> bond devices in the system?)

The bonding device is not simlilar with vlan device,  when vlan device is register, the real device is defintived.  But the when the bonding device is register, there maybe not slave device.

As the following codes. Any NETDEV_REGISTER EVENT will do indr register block.

    if (!mlx5e_tc_tun_device_to_offload(priv, netdev) &&
        !netif_is_bond_master(netdev) &&
        !is_vlan_dev(netdev))
        return NOTIFY_OK;

    switch (event) {
    case NETDEV_REGISTER:
        mlx5e_rep_indr_register_block(rpriv, netdev);

>>  	    !is_vlan_dev(netdev))
>>  		return NOTIFY_OK;
>>  
>>
> Mark

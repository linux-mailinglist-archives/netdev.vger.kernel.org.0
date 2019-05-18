Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E947722156
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 05:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfERDKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 23:10:38 -0400
Received: from m97188.mail.qiye.163.com ([220.181.97.188]:12264 "EHLO
        smtp.qiye.163.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727073AbfERDKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 23:10:37 -0400
Received: from [192.168.1.5] (unknown [58.38.1.117])
        by smtp.qiye.163.com (Hmail) with ESMTPA id 8C827962962;
        Sat, 18 May 2019 11:10:32 +0800 (CST)
Subject: Re: [PATCH] net/mlx5e: restrict the real_dev of vlan device is the
 same as uplink device
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Gavi Teitz <gavi@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1557912345-14649-1-git-send-email-wenxu@ucloud.cn>
 <32affe9e97f26ff1c7b5993255a6783533fe6bff.camel@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <e22c5097-028e-2e23-b1e9-0d7098802d1f@ucloud.cn>
Date:   Sat, 18 May 2019 11:10:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <32affe9e97f26ff1c7b5993255a6783533fe6bff.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kIGBQJHllBWVZKVUJDTEtLS0hPTUpDSExDWVdZKFlBSUI3V1ktWUFJV1
        kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ohw6Nzo*Tzg6Ki4aEEIdODAc
        IyhPCgtVSlVKTk5DSk9CS0hJQ0xNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWU5DVUhD
        VUpVSkpMWVdZCAFZQUlCQkk3Bg++
X-HM-Tid: 0a6ac8eb6b6d20bckuqy8c827962962
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There will be multiple vlan device which maybe not belong to the uplink rep device, so wen can limit it

在 2019/5/18 4:30, Saeed Mahameed 写道:
> On Wed, 2019-05-15 at 17:25 +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> When register indr block for vlan device, it should check the
>> real_dev
>> of vlan device is same as uplink device. Or it will set offload rule
>> to mlx5e which will never hit.
>>
> I would improve the commit message, it is not really clear to me what
> is going on here.
>
> Anyway Roi and team, can you please provide feedback ..
>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> index 91e24f1..a39fdac 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> @@ -796,7 +796,7 @@ static int mlx5e_nic_rep_netdevice_event(struct
>> notifier_block *nb,
>>  	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
>>  
>>  	if (!mlx5e_tc_tun_device_to_offload(priv, netdev) &&
>> -	    !is_vlan_dev(netdev))
>> +	    !(is_vlan_dev(netdev) && vlan_dev_real_dev(netdev) ==
>> rpriv->netdev))
>>  		return NOTIFY_OK;
>>  
>>  	switch (event) {

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAA243F7A5
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhJ2HHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:07:10 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13988 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhJ2HHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 03:07:09 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HgYKB33ShzZcVs;
        Fri, 29 Oct 2021 15:02:38 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Fri, 29 Oct 2021 15:04:36 +0800
Subject: Re: [PATCH net] net: vlan: fix a UAF in vlan_dev_real_dev()
To:     Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <20211027121606.3300860-1-william.xuanziyang@huawei.com>
 <20211027184640.7955767e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211028114503.GM2744544@nvidia.com>
 <20211028070050.6ca7893b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <b573b01c-2cc9-4722-6289-f7b9e0a43e19@huawei.com>
Date:   Fri, 29 Oct 2021 15:04:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211028070050.6ca7893b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, 28 Oct 2021 08:45:03 -0300 Jason Gunthorpe wrote:
>>> But will make all the callers of vlan_dev_real_dev() feel like they
>>> should NULL-check the result, which is not necessary.  
>>
>> Isn't it better to reliably return NULL instead of a silent UAF in
>> this edge case? 
> 
> I don't know what the best practice is for maintaining sanity of
> unregistered objects.
> 
> If there really is a requirement for the real_dev pointer to be sane we
> may want to move the put_device(real_dev) to vlan_dev_free(). There
> should not be any risk of circular dependency but I'm not 100% sure.
> 
>>> RDMA must be calling this helper on a vlan which was already
>>> unregistered, can we fix RDMA instead?  
>>
>> RDMA holds a get on the netdev which prevents unregistration, however
>> unregister_vlan_dev() does:
>>
>>         unregister_netdevice_queue(dev, head);
>>         dev_put(real_dev);
>>
>> Which corrupts the still registered vlan device while it is sitting in
>> the queue waiting to unregister. So, it is not true that a registered
>> vlan device always has working vlan_dev_real_dev().
> 
> That's not my reading, unless we have a different definition of
> "registered". The RDMA code in question runs from a workqueue, at the
> time the UNREGISTER notification is generated all objects are still
> alive and no UAF can happen. Past UNREGISTER extra care is needed when
> accessing the object.
> 
> Note that unregister_vlan_dev() may queue the unregistration, without
> running it. If it clears real_dev the UNREGISTER notification will no
> longer be able to access real_dev, which used to be completely legal.
> .
> 

I am sorry. I have made a misunderstanding and given a wrong conclusion
that unregister_vlan_dev() just move the vlan_ndev to a list to unregister
later and it is possible the real_dev has been freed when we access in
netdevice_queue_work().

real_ndev UNREGISTE trigger NETDEV_UNREGISTER notification in
vlan_device_event(), unregister_vlan_dev() and unregister_netdevice_many()
are within real_ndev UNREGISTE process. real_dev and vlan_ndev are all
alive before real_ndev UNREGISTE finished.

Above is the correction for my previous misunderstanding. But the real
scenario of the problem is as following:

__rtnl_newlink
vlan_newlink
register_vlan_dev(vlan_ndev, ...)
register_netdevice(vlan_ndev)
netdevice_queue_work(..., vlan_ndev) [dev_hold(vlan_ndev)]
queue_work(gid_cache_wq, ...)
...
rtnl_configure_link(vlan_ndev, ...) [failed]
ops->dellink(vlan_ndev, &list_kill) [unregister_vlan_dev]
unregister_netdevice_many(&list_kill)
...
ppp_release
unregister_netdevice(real_dev)
ppp_destroy_interface
free_netdev(real_dev)
netdev_freemem(real_dev) [real_dev freed]
...
netdevice_event_work_handler [vlan_ndev NETDEV_REGISTER notifier work]
is_eth_port_of_netdev_filter
vlan_dev_real_dev [real_dev UAF]

So my first solution as following for the problem is correct.
https://lore.kernel.org/linux-rdma/20211025163941.GA393143@nvidia.com/T/#m44abbf1ea5e4b5237610c1b389c3340d92a03b8d

Thank you!


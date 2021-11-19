Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A27345689E
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 04:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbhKSDcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 22:32:04 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:28154 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbhKSDcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 22:32:03 -0500
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HwMXz71LJz8vTY;
        Fri, 19 Nov 2021 11:27:15 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 19 Nov 2021 11:29:00 +0800
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, <davem@davemloft.net>,
        <jgg@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
 <87k0h9bb9x.fsf@nvidia.com>
 <20211115094940.138d86dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87a6i3t2zg.fsf@nvidia.com> <7f7cbbec-8c4e-a2dc-787b-570d1049a6b4@huawei.com>
 <20211118061735.5357f739@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <c240e0e0-256c-698b-4a98-47490869faa3@huawei.com>
Date:   Fri, 19 Nov 2021 11:29:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211118061735.5357f739@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, 18 Nov 2021 09:46:24 +0800 Ziyang Xuan (William) wrote:
>>>> I think we should move the dev_hold() to ndo_init(), otherwise 
>>>> it's hard to reason if destructor was invoked or not if
>>>> register_netdevice() errors out.  
>>>
>>> Ziyang Xuan, do you intend to take care of this?
>>> .  
>>
>> I am reading the related processes according to the problem scenario.
>> And I will give a more clear sequence and root cause as soon as possible
>> by some necessary tests.
> 
> Okay, I still don't see the fix. 
> 
> Petr would you mind submitting since you have a repro handy?
> .
The sequence for the problem maybe as following:

=============================================================
# create vlan device
vlan_newlink [assume real_dev refcnt == 2 just referenced by itself]
	register_vlan_dev
		register_netdevice(vlan_dev) [success]
		netdev_upper_dev_link [failed]
		unregister_netdevice(vlan_dev) [failure process]
		...
		netdev_run_todo [vlan_dev]
			vlan_dev_free(vlan_dev) [priv_destructor cb]
				dev_put(real_dev) [real_dev refcnt == 1]

# delete real device
unregister_netdevice(real_dev) [real_dev refcnt == 1]
	unregister_netdevice_many
		dev_put(real_dev) [real_dev refcnt == 0]
		net_set_todo(real_dev)
...
netdev_run_todo [real_dev]
	netdev_wait_allrefs(real_dev) [real_dev refcnt == 0]
		pr_emerg("unregister_netdevice: ...", ...)

I am thinking about how to fix the problem. priv_destructor() of the
net_device referenced not only by net_set_todo() but also failure process
in register_netdevice().

I need some time to test my some ideas. And anyone has good ideas, please
do not be stingy.

Thank you!



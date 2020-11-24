Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6952C1EC7
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgKXHT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:19:56 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8576 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730003AbgKXHT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 02:19:56 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CgFl253frzLnfF;
        Tue, 24 Nov 2020 15:19:26 +0800 (CST)
Received: from [10.174.179.81] (10.174.179.81) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 15:19:47 +0800
Subject: Re: [PATCH net] ipv6: addrlabel: fix possible memory leak in
 ip6addrlbl_net_init
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20201122023456.71100-1-wanghai38@huawei.com>
 <20201123172207.213d7134@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <029b9280-3c3f-afe0-1991-be54678afd51@huawei.com>
Date:   Tue, 24 Nov 2020 15:19:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20201123172207.213d7134@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/11/24 9:22, Jakub Kicinski Ð´µÀ:
> On Sun, 22 Nov 2020 10:34:56 +0800 Wang Hai wrote:
>> kmemleak report a memory leak as follows:
>>
>> unreferenced object 0xffff8880059c6a00 (size 64):
>>    comm "ip", pid 23696, jiffies 4296590183 (age 1755.384s)
>>    hex dump (first 32 bytes):
>>      20 01 00 10 00 00 00 00 00 00 00 00 00 00 00 00   ...............
>>      1c 00 00 00 00 00 00 00 00 00 00 00 07 00 00 00  ................
>>    backtrace:
>>      [<00000000aa4e7a87>] ip6addrlbl_add+0x90/0xbb0
>>      [<0000000070b8d7f1>] ip6addrlbl_net_init+0x109/0x170
>>      [<000000006a9ca9d4>] ops_init+0xa8/0x3c0
>>      [<000000002da57bf2>] setup_net+0x2de/0x7e0
>>      [<000000004e52d573>] copy_net_ns+0x27d/0x530
>>      [<00000000b07ae2b4>] create_new_namespaces+0x382/0xa30
>>      [<000000003b76d36f>] unshare_nsproxy_namespaces+0xa1/0x1d0
>>      [<0000000030653721>] ksys_unshare+0x3a4/0x780
>>      [<0000000007e82e40>] __x64_sys_unshare+0x2d/0x40
>>      [<0000000031a10c08>] do_syscall_64+0x33/0x40
>>      [<0000000099df30e7>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> We should free all rules when we catch an error in ip6addrlbl_net_init().
>> otherwise a memory leak will occur.
>>
>> Fixes: 2a8cc6c89039 ("[IPV6] ADDRCONF: Support RFC3484 configurable address selection policy table.")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> We can simplify this function.
>
>> diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
>> index 642fc6ac13d2..637e323a0224 100644
>> --- a/net/ipv6/addrlabel.c
>> +++ b/net/ipv6/addrlabel.c
>> @@ -306,6 +306,8 @@ static int ip6addrlbl_del(struct net *net,
>>   /* add default label */
>>   static int __net_init ip6addrlbl_net_init(struct net *net)
>>   {
>> +	struct ip6addrlbl_entry *p = NULL;
>> +	struct hlist_node *n;
>>   	int err = 0;
> err does not need init
>
>>   	int i;
>>   
>> @@ -320,9 +322,17 @@ static int __net_init ip6addrlbl_net_init(struct net *net)
> instead of the temporary ret variable we can assign directly to err
>
>>   					 ip6addrlbl_init_table[i].prefixlen,
>>   					 0,
>>   					 ip6addrlbl_init_table[i].label, 0);
>> -		/* XXX: should we free all rules when we catch an error? */
>> -		if (ret && (!err || err != -ENOMEM))
>> +		if (ret && (!err || err != -ENOMEM)) {
> this will become if (err)
>
>>   			err = ret;
>> +			goto err_ip6addrlbl_add;
>> +		}
>> +	}
>> +	return err;
> return 0;
>
>> +err_ip6addrlbl_add:
>> +	hlist_for_each_entry_safe(p, n, &net->ipv6.ip6addrlbl_table.head, list) {
>> +		hlist_del_rcu(&p->list);
>> +		kfree_rcu(p, rcu);
>>   	}
>>   	return err;
>>   }

Thanks for advice. I just sent a v2

¡°[PATCH net v2] ipv6: addrlabel: fix possible memory leak in 
ip6addrlbl_net_init¡±

> .
>

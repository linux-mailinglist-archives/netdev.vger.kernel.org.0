Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5AA2BA4A7
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 09:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgKTI37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 03:29:59 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7709 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgKTI37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 03:29:59 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CcqTq21P7zkc9s;
        Fri, 20 Nov 2020 16:29:35 +0800 (CST)
Received: from [10.174.179.81] (10.174.179.81) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Fri, 20 Nov 2020 16:29:53 +0800
Subject: Re: [PATCH net] ipvs: fix possible memory leak in
 ip_vs_control_net_init
To:     Julian Anastasov <ja@ssi.bg>
CC:     <horms@verge.net.au>, <pablo@netfilter.org>,
        <kadlec@netfilter.org>, <fw@strlen.de>, <davem@davemloft.net>,
        <kuba@kernel.org>, <christian@brauner.io>,
        <hans.schillstrom@ericsson.com>, <lvs-devel@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20201119104102.67427-1-wanghai38@huawei.com>
 <f111e78-b9c1-453-c6e5-a063e62cd83b@ssi.bg>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <0574c34c-60a8-8d8d-38b1-962898e55801@huawei.com>
Date:   Fri, 20 Nov 2020 16:29:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f111e78-b9c1-453-c6e5-a063e62cd83b@ssi.bg>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/11/20 2:22, Julian Anastasov Ð´µÀ:
> 	Hello,
>
> On Thu, 19 Nov 2020, Wang Hai wrote:
>
>> kmemleak report a memory leak as follows:
>>
>> BUG: memory leak
>> unreferenced object 0xffff8880759ea000 (size 256):
>> comm "syz-executor.3", pid 6484, jiffies 4297476946 (age 48.546s)
>> hex dump (first 32 bytes):
>> 00 00 00 00 01 00 00 00 08 a0 9e 75 80 88 ff ff ...........u....
[...]
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>> ---
>>   net/netfilter/ipvs/ip_vs_ctl.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
>> index e279ded4e306..d99bb89e7c25 100644
>> --- a/net/netfilter/ipvs/ip_vs_ctl.c
>> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
>> @@ -4180,6 +4180,9 @@ int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
>>   	return 0;
> 	May be we should add some #ifdef CONFIG_PROC_FS because
> proc_create_net* return NULL when PROC is not used. For example:
>
> #ifdef CONFIG_PROC_FS
> 	if (!proc_create_net...
> 		goto err_vs;
> 	if (!proc_create_net...
> 		goto err_stats;
> 	...
> #endif
> 	...
>
>>   err:
> #ifdef CONFIG_PROC_FS
>> +	remove_proc_entry("ip_vs_stats_percpu", ipvs->net->proc_net);
> err_percpu:
>> +	remove_proc_entry("ip_vs_stats", ipvs->net->proc_net);
> err_stats:
>> +	remove_proc_entry("ip_vs", ipvs->net->proc_net);
> err_vs:
> #endif
>
>>   	free_percpu(ipvs->tot_stats.cpustats);
>>   	return -ENOMEM;
>>   }
>> -- 
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
>
> .

Thanks for your advice, I just sent v2

¡°[PATCH net v2] ipvs: fix possible memory leak in ip_vs_control_net_init¡±

>

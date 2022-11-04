Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BFC618DAE
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 02:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiKDBgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 21:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiKDBgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 21:36:36 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D74D1EC79;
        Thu,  3 Nov 2022 18:36:35 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N3NRZ6myFzpW95;
        Fri,  4 Nov 2022 09:32:58 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 09:36:33 +0800
Received: from [10.67.108.67] (10.67.108.67) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 4 Nov
 2022 09:36:33 +0800
Message-ID: <5b05c7d9-a7e3-8b32-4aa6-cd94df2858e5@huawei.com>
Date:   Fri, 4 Nov 2022 09:36:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH net] net: ping6: Fix possible leaked pernet namespace in
 pingv6_init()
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <lorenzo@google.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <yoshfuji@linux-ipv6.org>
References: <20221103090345.187989-1-chenzhongjin@huawei.com>
 <20221103165827.19428-1-kuniyu@amazon.com>
Content-Language: en-US
From:   Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <20221103165827.19428-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/11/4 0:58, Kuniyuki Iwashima wrote:
> From:   Chen Zhongjin <chenzhongjin@huawei.com>
> Date:   Thu, 3 Nov 2022 17:03:45 +0800
>> When IPv6 module initializing in pingv6_init(), inet6_register_protosw()
>> is possible to fail but returns without any error cleanup.
> The change itself looks sane, but how does it fail ?
> It seems inet6_register_protosw() never fails for pingv6_protosw.
> Am I missing something ?

Thanks for reminding! I only injected error return value for functions 
but didn't notice the inner logic.

Rechecked and find you are right that inet6_register_protosw() is safe 
for this case.

Sorry for bothering, please reject this. Will check carefully next time.


Best,

Chen

> ---8<---
> static struct inet_protosw pingv6_protosw = {
> 	.type =      SOCK_DGRAM,         <-- .type < SOCK_MAX
> 	.protocol =  IPPROTO_ICMPV6,
> 	.prot =      &pingv6_prot,
> 	.ops =       &inet6_sockraw_ops,
> 	.flags =     INET_PROTOSW_REUSE,  <-- always makes `answer` NULL
> };
>
> int inet6_register_protosw(struct inet_protosw *p)
> {
> 	struct list_head *lh;
> 	struct inet_protosw *answer;
> 	struct list_head *last_perm;
> 	int protocol = p->protocol;
> 	int ret;
>
> 	spin_lock_bh(&inetsw6_lock);
>
> 	ret = -EINVAL;
> 	if (p->type >= SOCK_MAX)
> 		goto out_illegal;
>
> 	/* If we are trying to override a permanent protocol, bail. */
> 	answer = NULL;
> 	ret = -EPERM;
> 	last_perm = &inetsw6[p->type];
> 	list_for_each(lh, &inetsw6[p->type]) {
> 		answer = list_entry(lh, struct inet_protosw, list);
>
> 		/* Check only the non-wild match. */
> 		if (INET_PROTOSW_PERMANENT & answer->flags) {
> 			if (protocol == answer->protocol)
> 				break;
> 			last_perm = lh;
> 		}
>
> 		answer = NULL;
> 	}
> 	if (answer)
> 		goto out_permanent;
> ...
> 	list_add_rcu(&p->list, last_perm);
> 	ret = 0;
> out:
> 	spin_unlock_bh(&inetsw6_lock);
> 	return ret;
>
> out_permanent:
> 	pr_err("Attempt to override permanent protocol %d\n", protocol);
> 	goto out;
>
> out_illegal:
> 	pr_err("Ignoring attempt to register invalid socket type %d\n",
> 	       p->type);
> 	goto out;
> }
> ---8<---
>
>> This leaves wild ops in namespace list and when another module tries to
>> add or delete pernet namespace it triggers page fault.
>> Although IPv6 cannot be unloaded now, this error should still be handled
>> to avoid kernel panic during IPv6 initialization.
>>
>> BUG: unable to handle page fault for address: fffffbfff80bab69
>> CPU: 0 PID: 434 Comm: modprobe
>> RIP: 0010:unregister_pernet_operations+0xc9/0x450
>> Call Trace:
>>   <TASK>
>>   unregister_pernet_subsys+0x31/0x3e
>>   nf_tables_module_exit+0x44/0x6a [nf_tables]
>>   __do_sys_delete_module.constprop.0+0x34f/0x5b0
>>   ...
>>
>> Fix it by adding error handling in pingv6_init(), and add a helper
> I'm wondering this could be another place.
>
>
>> function pingv6_ops_unset to avoid duplicate code.
>>
>> Fixes: d862e5461423 ("net: ipv6: Implement /proc/net/icmp6.")
>> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
>> ---
>>   net/ipv6/ping.c | 30 ++++++++++++++++++++++--------
>>   1 file changed, 22 insertions(+), 8 deletions(-)
>>
>> diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
>> index 86c26e48d065..5df688dd5208 100644
>> --- a/net/ipv6/ping.c
>> +++ b/net/ipv6/ping.c
>> @@ -277,10 +277,21 @@ static struct pernet_operations ping_v6_net_ops = {
>>   };
>>   #endif
>>   
>> +static void pingv6_ops_unset(void)
>> +{
>> +	pingv6_ops.ipv6_recv_error = dummy_ipv6_recv_error;
>> +	pingv6_ops.ip6_datagram_recv_common_ctl = dummy_ip6_datagram_recv_ctl;
>> +	pingv6_ops.ip6_datagram_recv_specific_ctl = dummy_ip6_datagram_recv_ctl;
>> +	pingv6_ops.icmpv6_err_convert = dummy_icmpv6_err_convert;
>> +	pingv6_ops.ipv6_icmp_error = dummy_ipv6_icmp_error;
>> +	pingv6_ops.ipv6_chk_addr = dummy_ipv6_chk_addr;
>> +}
>> +
>>   int __init pingv6_init(void)
>>   {
>> +	int ret;
>>   #ifdef CONFIG_PROC_FS
>> -	int ret = register_pernet_subsys(&ping_v6_net_ops);
>> +	ret = register_pernet_subsys(&ping_v6_net_ops);
>>   	if (ret)
>>   		return ret;
>>   #endif
>> @@ -291,7 +302,15 @@ int __init pingv6_init(void)
>>   	pingv6_ops.icmpv6_err_convert = icmpv6_err_convert;
>>   	pingv6_ops.ipv6_icmp_error = ipv6_icmp_error;
>>   	pingv6_ops.ipv6_chk_addr = ipv6_chk_addr;
>> -	return inet6_register_protosw(&pingv6_protosw);
>> +
>> +	ret = inet6_register_protosw(&pingv6_protosw);
>> +	if (ret) {
>> +		pingv6_ops_unset();
>> +#ifdef CONFIG_PROC_FS
>> +		unregister_pernet_subsys(&ping_v6_net_ops);
>> +#endif
>> +	}
>> +	return ret;
>>   }
>>   
>>   /* This never gets called because it's not possible to unload the ipv6 module,
>> @@ -299,12 +318,7 @@ int __init pingv6_init(void)
>>    */
>>   void pingv6_exit(void)
>>   {
>> -	pingv6_ops.ipv6_recv_error = dummy_ipv6_recv_error;
>> -	pingv6_ops.ip6_datagram_recv_common_ctl = dummy_ip6_datagram_recv_ctl;
>> -	pingv6_ops.ip6_datagram_recv_specific_ctl = dummy_ip6_datagram_recv_ctl;
>> -	pingv6_ops.icmpv6_err_convert = dummy_icmpv6_err_convert;
>> -	pingv6_ops.ipv6_icmp_error = dummy_ipv6_icmp_error;
>> -	pingv6_ops.ipv6_chk_addr = dummy_ipv6_chk_addr;
>> +	pingv6_ops_unset();
>>   #ifdef CONFIG_PROC_FS
>>   	unregister_pernet_subsys(&ping_v6_net_ops);
>>   #endif
>> -- 
>> 2.17.1

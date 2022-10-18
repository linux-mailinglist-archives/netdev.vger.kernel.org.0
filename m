Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96202602094
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 03:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiJRBsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 21:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiJRBsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 21:48:21 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E95754BD
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 18:48:18 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MrxTg2G7Lz1P7F4;
        Tue, 18 Oct 2022 09:43:35 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 09:48:16 +0800
Message-ID: <c482c66b-a455-ff6e-7a6a-a8c5d717c457@huawei.com>
Date:   Tue, 18 Oct 2022 09:48:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] ip6mr: fix UAF issue in ip6mr_sk_done() when
 addrconf_init_net() failed
To:     Eric Dumazet <edumazet@google.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20221017080331.16878-1-shaozhengchao@huawei.com>
 <CANn89iJdZx=e2QN_AXPiZQDh4u4EY5dOrzgdsqgWTCpvLhJVcQ@mail.gmail.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <CANn89iJdZx=e2QN_AXPiZQDh4u4EY5dOrzgdsqgWTCpvLhJVcQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/17 23:58, Eric Dumazet wrote:
> On Mon, Oct 17, 2022 at 12:55 AM Zhengchao Shao
> <shaozhengchao@huawei.com> wrote:
>>
>> If the initialization fails in calling addrconf_init_net(), devconf_all is
>> the pointer that has been released. Then ip6mr_sk_done() is called to
>> release the net, accessing devconf->mc_forwarding directly causes invalid
>> pointer access.
>>
>> The process is as follows:
>> setup_net()
>>          ops_init()
>>                  addrconf_init_net()
>>                  all = kmemdup(...)           ---> alloc "all"
>>                  ...
>>                  net->ipv6.devconf_all = all;
>>                  __addrconf_sysctl_register() ---> failed
>>                  ...
>>                  kfree(all);                  ---> ipv6.devconf_all invalid
>>                  ...
>>          ops_exit_list()
>>                  ...
>>                  ip6mr_sk_done()
>>                          devconf = net->ipv6.devconf_all;
>>                          //devconf is invalid pointer
>>                          if (!devconf || !atomic_read(&devconf->mc_forwarding))
>>
>>
>> Fixes: 7d9b1b578d67 ("ip6mr: fix use-after-free in ip6mr_sk_done()")
> 
> Hmmm. I wonder if you are not masking a more serious bug.
> 
> When I wrote this patch ( 7d9b1b578d67) I was following the standard
> rule of ops->exit() being called
> only if the corresponding ops->init() function had not failed.
> 
> net/core/net_namespace.c:setup_net() even has some comments about this rule:
> 
> out_undo:
>          /* Walk through the list backwards calling the exit functions
>           * for the pernet modules whose init functions did not fail.
>           */
>          list_add(&net->exit_list, &net_exit_list);
>          saved_ops = ops;
>          list_for_each_entry_continue_reverse(ops, &pernet_list, list)
>                  ops_pre_exit_list(ops, &net_exit_list);
> 
>          synchronize_rcu();
> 
>          ops = saved_ops;
>          list_for_each_entry_continue_reverse(ops, &pernet_list, list)
>                  ops_exit_list(ops, &net_exit_list);
> 
>          ops = saved_ops;
>          list_for_each_entry_continue_reverse(ops, &pernet_list, list)
>                  ops_free_list(ops, &net_exit_list);
> 
>          rcu_barrier();
>          goto out;
> 
> 
Hi Eric:
	Thank you for your reply. I wonder if fixing commit
e0da5a480caf ("[NETNS]: Create ipv6 devconf-s for namespaces")
would be more appropriate?

Zhengchao Shao

> 
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   net/ipv6/addrconf.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>> index 417834b7169d..9c3f5202a97b 100644
>> --- a/net/ipv6/addrconf.c
>> +++ b/net/ipv6/addrconf.c
>> @@ -7214,9 +7214,11 @@ static int __net_init addrconf_init_net(struct net *net)
>>          __addrconf_sysctl_unregister(net, all, NETCONFA_IFINDEX_ALL);
>>   err_reg_all:
>>          kfree(dflt);
>> +       net->ipv6.devconf_dflt = NULL;
>>   #endif
>>   err_alloc_dflt:
>>          kfree(all);
>> +       net->ipv6.devconf_all = NULL;
>>   err_alloc_all:
>>          kfree(net->ipv6.inet6_addr_lst);
>>   err_alloc_addr:
>> --
>> 2.17.1
>>

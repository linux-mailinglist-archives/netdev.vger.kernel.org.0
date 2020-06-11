Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D221F6C46
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 18:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgFKQiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 12:38:22 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:27410 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgFKQiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 12:38:22 -0400
Received: from [192.168.1.4] (unknown [101.93.38.162])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 45F6F416EF;
        Fri, 12 Jun 2020 00:37:53 +0800 (CST)
Subject: Re: [PATCH net v2] flow_offload: fix incorrect cleanup for indirect
 flow_blocks
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <1591869797-7264-1-git-send-email-wenxu@ucloud.cn>
 <20200611110537.GA6047@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <c45c1e4c-f9d9-f619-9f8e-d9f957c475c5@ucloud.cn>
Date:   Fri, 12 Jun 2020 00:36:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200611110537.GA6047@salvia>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkxJS0tLS05LTk9PTE9ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdIjULOBw6SBweSBwjHjEeHDAPCjocVlZVSkJLTShJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PTo6IQw5ATg5GTAPMxQpMk0v
        EkwKCk9VSlVKTkJKQ0JIT0xIT0hPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVC
        SFVIQ1VKTUlZV1kIAVlBSU5PSTcG
X-HM-Tid: 0a72a43eb8642086kuqy45f6f416ef
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/6/11 19:05, Pablo Neira Ayuso Ð´µÀ:
> On Thu, Jun 11, 2020 at 06:03:17PM +0800, wenxu@ucloud.cn wrote:
> [...]
>> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
>> index 0cfc35e..40eaf64 100644
>> --- a/net/core/flow_offload.c
>> +++ b/net/core/flow_offload.c
>> @@ -372,14 +372,13 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
>>   }
>>   EXPORT_SYMBOL(flow_indr_dev_register);
>>   
>> -static void __flow_block_indr_cleanup(flow_setup_cb_t *setup_cb, void *cb_priv,
>> +static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
>>   				      struct list_head *cleanup_list)
>>   {
>>   	struct flow_block_cb *this, *next;
>>   
>>   	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
>> -		if (this->cb == setup_cb &&
>> -		    this->cb_priv == cb_priv) {
>> +		if (this->release == release) {
> Are you sure this is correct?
>
> This will remove _all_ existing representors in this driver.
>
> This will not work if only one representor is gone?
>
> Please, describe what scenario you are trying to fix.
>
> Thank you.

Yes you are right. But there still an another problem.

The match statements this->cb_priv == cb_priv always return false

the flow_block_cb->cb_priv is totally differnent data from 
flow_indr_dev->cb_priv

in the dirvers.

>

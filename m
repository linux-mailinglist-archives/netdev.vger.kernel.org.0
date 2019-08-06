Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD62083DDB
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 01:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfHFXhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 19:37:15 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:7357 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfHFXhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 19:37:14 -0400
Received: from [192.168.1.3] (unknown [101.93.38.113])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 0DE344160C;
        Wed,  7 Aug 2019 07:37:10 +0800 (CST)
Subject: Re: [PATCH net-next v6 5/6] flow_offload: support get multi-subsystem
 block
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     jakub.kicinski@netronome.com, jiri@resnulli.us,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
 <1564925041-23530-6-git-send-email-wenxu@ucloud.cn>
 <20190806161000.3csoy3jlpq6cletq@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <7654c76a-bc47-e0f7-7b94-90e36b337ee0@ucloud.cn>
Date:   Wed, 7 Aug 2019 07:36:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190806161000.3csoy3jlpq6cletq@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSUhJS0tLSE5LQk5JSk5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6P006Vgw*DDgxMk1LLE0pSjM6
        KhQwFCxVSlVKTk1OSkhPTUhLSEpKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVC
        SFVIQ1VKSkhZV1kIAVlBTklJTDcG
X-HM-Tid: 0a6c694b2d492086kuqy0de344160c
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/8/7 0:10, Pablo Neira Ayuso 写道:
> On Sun, Aug 04, 2019 at 09:24:00PM +0800, wenxu@ucloud.cn wrote:
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index 8f1a7b8..6022dd0 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
> [...]
>> @@ -282,6 +282,8 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
>>  }
>>  EXPORT_SYMBOL(flow_block_cb_setup_simple);
>>  
>> +static LIST_HEAD(block_ing_cb_list);
>> +
>>  static struct rhashtable indr_setup_block_ht;
>>  
>>  struct flow_indr_block_cb {
>> @@ -295,7 +297,6 @@ struct flow_indr_block_dev {
>>  	struct rhash_head ht_node;
>>  	struct net_device *dev;
>>  	unsigned int refcnt;
>> -	flow_indr_block_ing_cmd_t  *block_ing_cmd_cb;
>>  	struct list_head cb_list;
>>  };
>>  
>> @@ -389,6 +390,22 @@ static void flow_indr_block_cb_del(struct flow_indr_block_cb *indr_block_cb)
>>  	kfree(indr_block_cb);
>>  }
>>  
>> +static void flow_block_ing_cmd(struct net_device *dev,
>> +			       flow_indr_block_bind_cb_t *cb,
>> +			       void *cb_priv,
>> +			       enum flow_block_command command)
>> +{
>> +	struct flow_indr_block_ing_entry *entry;
>> +
>> +	rcu_read_lock();
>> +
> unnecessary empty line.
>
>> +	list_for_each_entry_rcu(entry, &block_ing_cb_list, list) {
>> +		entry->cb(dev, cb, cb_priv, command);
>> +	}
>> +
>> +	rcu_read_unlock();
> OK, there's rcu_read_lock here...
>
>> +}
>> +
>>  int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
>>  				  flow_indr_block_bind_cb_t *cb,
>>  				  void *cb_ident)
>> @@ -406,10 +423,8 @@ int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
>>  	if (err)
>>  		goto err_dev_put;
>>  
>> -	if (indr_dev->block_ing_cmd_cb)
>> -		indr_dev->block_ing_cmd_cb(dev, indr_block_cb->cb,
>> -					   indr_block_cb->cb_priv,
>> -					   FLOW_BLOCK_BIND);
>> +	flow_block_ing_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
>> +			   FLOW_BLOCK_BIND);
>>  
>>  	return 0;
>>  
>> @@ -448,10 +463,8 @@ void __flow_indr_block_cb_unregister(struct net_device *dev,
>>  	if (!indr_block_cb)
>>  		return;
>>  
>> -	if (indr_dev->block_ing_cmd_cb)
>> -		indr_dev->block_ing_cmd_cb(dev, indr_block_cb->cb,
>> -					   indr_block_cb->cb_priv,
>> -					   FLOW_BLOCK_UNBIND);
>> +	flow_block_ing_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
>> +			   FLOW_BLOCK_UNBIND);
>>  
>>  	flow_indr_block_cb_del(indr_block_cb);
>>  	flow_indr_block_dev_put(indr_dev);
>> @@ -469,7 +482,6 @@ void flow_indr_block_cb_unregister(struct net_device *dev,
>>  EXPORT_SYMBOL_GPL(flow_indr_block_cb_unregister);
>>  
>>  void flow_indr_block_call(struct net_device *dev,
>> -			  flow_indr_block_ing_cmd_t cb,
>>  			  struct flow_block_offload *bo,
>>  			  enum flow_block_command command)
>>  {
>> @@ -480,15 +492,24 @@ void flow_indr_block_call(struct net_device *dev,
>>  	if (!indr_dev)
>>  		return;
>>  
>> -	indr_dev->block_ing_cmd_cb = command == FLOW_BLOCK_BIND
>> -				     ? cb : NULL;
>> -
>>  	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
>>  		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
>>  				  bo);
>>  }
>>  EXPORT_SYMBOL_GPL(flow_indr_block_call);
>>  
>> +void flow_indr_add_block_ing_cb(struct flow_indr_block_ing_entry *entry)
>> +{
> ... but registration does not protect the list with a mutex.
>
>> +	list_add_tail_rcu(&entry->list, &block_ing_cb_list);
>> +}
>> +EXPORT_SYMBOL_GPL(flow_indr_add_block_ing_cb);

flow_indr_add_block_ing_cb called from tc and nft in different order.
 subsys_initcall(tc_filter_init) and nf_tables_module_init 
It will be called at the same time? 

And any nft need flow_indr_del_block_ing_cb. It also does nedd the lock?


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E207F7DC
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 15:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391809AbfHBNJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 09:09:23 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:53729 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389781AbfHBNJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 09:09:23 -0400
Received: from [192.168.1.3] (unknown [180.157.106.98])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id B10A64116C;
        Fri,  2 Aug 2019 21:09:18 +0800 (CST)
Subject: Re: [PATCH net-next v5 5/6] flow_offload: support get flow_block
 immediately
From:   wenxu <wenxu@ucloud.cn>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        John Hurley <john.hurley@netronome.com>
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
 <1564628627-10021-6-git-send-email-wenxu@ucloud.cn>
 <20190801161129.25fee619@cakuba.netronome.com>
 <bac5c6a5-8a1b-ee74-988b-6c2a71885761@ucloud.cn>
Message-ID: <55850b13-991f-97bd-b452-efacd0f39aa4@ucloud.cn>
Date:   Fri, 2 Aug 2019 21:09:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <bac5c6a5-8a1b-ee74-988b-6c2a71885761@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSkhJS0tLSUtMQktKWVdZKFlBSU
        I3V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nyo6CTo5LDg#Ik84DUJNIVEZ
        LDkaCxxVSlVKTk1PTE5KSE5CS01KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSktNVUJDWVdZCAFZQU5PSko3Bg++
X-HM-Tid: 0a6c5272ebe92086kuqyb10a64116c
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/8/2 18:45, wenxu 写道:
> On 8/2/2019 7:11 AM, Jakub Kicinski wrote:
>> On Thu,  1 Aug 2019 11:03:46 +0800, wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> The new flow-indr-block can't get the tcf_block
>>> directly. It provide a callback list to find the flow_block immediately
>>> when the device register and contain a ingress block.
>>>
>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> First of all thanks for splitting the series up into more patches, 
>> it is easier to follow the logic now!
>>
>>> @@ -328,6 +348,7 @@ struct flow_indr_block_dev {
>>>  
>>>  	INIT_LIST_HEAD(&indr_dev->cb_list);
>>>  	indr_dev->dev = dev;
>>> +	flow_get_default_block(indr_dev);
>>>  	if (rhashtable_insert_fast(&indr_setup_block_ht, &indr_dev->ht_node,
>>>  				   flow_indr_setup_block_ht_params)) {
>>>  		kfree(indr_dev);
>> I wonder if it's still practical to keep the block information in the
>> indr_dev structure at all. The way this used to work was:
>>
>>
>> [hash table of devices]     --------------
>>                  |         |    netdev    |
>>                  |         |    refcnt    |
>>   indir_dev[tun0]|  ------ | cached block | ---- [ TC block ]
>>                  |         |   callbacks  | .
>>                  |          --------------   \__ [cb, cb_priv, cb_ident]
>>                  |                               [cb, cb_priv, cb_ident]
>>                  |          --------------
>>                  |         |    netdev    |
>>                  |         |    refcnt    |
>>   indir_dev[tun1]|  ------ | cached block | ---- [ TC block ]
>>                  |         |   callbacks  |.
>> -----------------           --------------   \__ [cb, cb_priv, cb_ident]
>>                                                  [cb, cb_priv, cb_ident]
>>
>>
>> In the example above we have two tunnels tun0 and tun1, each one has a
>> indr_dev structure allocated, and for each one of them two drivers
>> registered for callbacks (hence the callbacks list has two entries).
>>
>> We used to cache the TC block in the indr_dev structure, but now that
>> there are multiple subsytems using the indr_dev we either have to have
>> a list of cached blocks (with entries for each subsystem) or just always
>> iterate over the subsystems :(
>>
>> After all the same device may have both a TC block and a NFT block.
>>
>> I think always iterating would be easier:
>>
>> The indr_dev struct would no longer have the block pointer, instead
>> when new driver registers for the callback instead of:
>>
>> 	if (indr_dev->ing_cmd_cb)
>> 		indr_dev->ing_cmd_cb(indr_dev->dev, indr_dev->flow_block,
>> 				     indr_block_cb->cb, indr_block_cb->cb_priv,
>> 				     FLOW_BLOCK_BIND);
>>
>> We'd have something like the loop in flow_get_default_block():
>>
>> 	for each (subsystem)
>> 		subsystem->handle_new_indir_cb(indr_dev, cb);
>>
>> And then per-subsystem logic would actually call the cb. Or:
>>
>> 	for each (subsystem)
>> 		block = get_default_block(indir_dev)
>> 		indr_dev->ing_cmd_cb(...)
>             nft dev chian is also based on register_netdevice_notifier, So for unregister case,
>
> the basechian(block) of nft maybe delete before the __tc_indr_block_cb_unregister. is right?
>
> So maybe we can cache the block as a list of all the subsystem in  indr_dev ?


when the device is unregister the nft netdev chain related to this device will also be delete through netdevice_notifier

. So for unregister case,the basechian(block) of nft maybe delete before the __tc_indr_block_cb_unregister.

cache for the block is not work because the chain already be delete and free. Maybe it improve the prio of

rep_netdev_event can help this?

>
>

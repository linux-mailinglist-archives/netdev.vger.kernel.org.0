Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8492F7778D
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 10:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbfG0IFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 04:05:53 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:12832 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfG0IFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 04:05:53 -0400
Received: from [192.168.1.5] (unknown [58.37.151.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 0612A411AE;
        Sat, 27 Jul 2019 16:05:47 +0800 (CST)
Subject: Re: [PATCH net-next v3 1/3] flow_offload: move tc indirect block to
 flow offload
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1564148047-6428-1-git-send-email-wenxu@ucloud.cn>
 <1564148047-6428-2-git-send-email-wenxu@ucloud.cn>
 <20190726175627.7c146f94@cakuba.netronome.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <587a1c0a-12dc-4e65-855f-e5552a195d52@ucloud.cn>
Date:   Sat, 27 Jul 2019 16:05:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190726175627.7c146f94@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk1CS0tLTUlOTUpLSE5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MU06Ixw6NTgrKko#EiwxPj0*
        PiEwCglVSlVKTk1PSUpPTE9DSU9PVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWU5DVUhM
        VUpOSlVKSUJZV1kIAVlBSEhJSzcG
X-HM-Tid: 0a6c3276e4152086kuqy0612a411ae
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/7/27 8:56, Jakub Kicinski 写道:
> On Fri, 26 Jul 2019 21:34:05 +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> move tc indirect block to flow_offload and rename
>> it to flow indirect block.The nf_tables can use the
>> indr block architecture.
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index 00b9aab..66f89bc 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -4,6 +4,7 @@
>>  #include <linux/kernel.h>
>>  #include <linux/list.h>
>>  #include <net/flow_dissector.h>
>> +#include <linux/rhashtable.h>
>>  
>>  struct flow_match {
>>  	struct flow_dissector	*dissector;
>> @@ -366,4 +367,42 @@ static inline void flow_block_init(struct flow_block *flow_block)
>>  	INIT_LIST_HEAD(&flow_block->cb_list);
>>  }
>>  
>> +typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
>> +				      enum tc_setup_type type, void *type_data);
>> +
>> +struct flow_indr_block_cb {
>> +	struct list_head list;
>> +	void *cb_priv;
>> +	flow_indr_block_bind_cb_t *cb;
>> +	void *cb_ident;
>> +};
>> +
>> +typedef void flow_indr_block_ing_cmd_t(struct net_device *dev,
>> +				       struct flow_block *flow_block,
>> +				       struct flow_indr_block_cb *indr_block_cb,
>> +				       enum flow_block_command command);
>> +
>> +struct flow_indr_block_dev {
>> +	struct rhash_head ht_node;
>> +	struct net_device *dev;
>> +	unsigned int refcnt;
>> +	struct list_head cb_list;
>> +	flow_indr_block_ing_cmd_t *ing_cmd_cb;
>> +	struct flow_block *flow_block;
> TC can only have one block per device. Now with nftables offload we can
> have multiple blocks. Could you elaborate how this is solved?
>
>> +};

the nftable offload only work on netdev base chain. Each device can limit to one netdev base chain.


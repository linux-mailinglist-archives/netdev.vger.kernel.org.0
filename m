Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE29778BFB
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 14:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfG2MrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 08:47:25 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:56035 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfG2MrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 08:47:25 -0400
Received: from [192.168.1.5] (unknown [116.234.0.221])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id BFE3841CF9;
        Mon, 29 Jul 2019 20:47:20 +0800 (CST)
Subject: Re: [PATCH net-next v4 1/3] flow_offload: move tc indirect block to
 flow offload
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     pablo@netfilter.org, fw@strlen.de, jakub.kicinski@netronome.com,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
 <1564296769-32294-2-git-send-email-wenxu@ucloud.cn>
 <20190729111350.GE2211@nanopsycho>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <c218d9bb-1da7-2ed6-d5b0-afddbe3d0bd7@ucloud.cn>
Date:   Mon, 29 Jul 2019 20:47:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190729111350.GE2211@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0pIS0tLSU9CQ01JTUxZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MEk6Hyo6IzgwLkkNE1ZOI0NR
        SElPCxNVSlVKTk1PT0tPT09KSUxPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VS1VJSUpZV1kIAVlBSENMTzcG
X-HM-Tid: 0a6c3dc5607e2086kuqybfe3841cf9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/7/29 19:13, Jiri Pirko 写道:
> Sun, Jul 28, 2019 at 08:52:47AM CEST, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> move tc indirect block to flow_offload and rename
>> it to flow indirect block.The nf_tables can use the
>> indr block architecture.
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>> v3: subsys_initcall for init_flow_indr_rhashtable
>> v4: no change
>>
> [...]
>
>
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index 00b9aab..66f89bc 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -4,6 +4,7 @@
>> #include <linux/kernel.h>
>> #include <linux/list.h>
>> #include <net/flow_dissector.h>
>> +#include <linux/rhashtable.h>
>>
>> struct flow_match {
>> 	struct flow_dissector	*dissector;
>> @@ -366,4 +367,42 @@ static inline void flow_block_init(struct flow_block *flow_block)
>> 	INIT_LIST_HEAD(&flow_block->cb_list);
>> }
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
> I don't understand why are you pushing this struct out of the c file to
> the header. Please don't.
>
>
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
> I don't understand why are you pushing this struct out of the c file to
> the header. Please don't.

the flow_indr_block_dev and indr_block_cb in the h file used for the function

tc_indr_block_ing_cmd in cls_api.c

>> -static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
>> -				  struct tc_indr_block_cb *indr_block_cb,
>> +static void tc_indr_block_ing_cmd(struct net_device *dev,
> I don't understand why you change struct tc_indr_block_dev * to
> struct net_device * here. If you want to do that, please do that in a
> separate patch, not it this one where only "the move" should happen.
>

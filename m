Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06781FC43B
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 04:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgFQCrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 22:47:42 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:18339 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgFQCrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 22:47:42 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 3E31841C52;
        Wed, 17 Jun 2020 10:47:33 +0800 (CST)
Subject: Re: [PATCH net v3 2/4] flow_offload: fix incorrect cb_priv check for
 flow_block_cb
To:     Simon Horman <simon.horman@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org,
        vladbu@mellanox.com
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
 <1592277580-5524-3-git-send-email-wenxu@ucloud.cn>
 <20200616105123.GA21396@netronome.com>
 <aee3192c-7664-580b-1f37-9003c91f185b@ucloud.cn>
 <20200616143427.GA8084@netronome.com>
 <565dd609-1e20-16f4-f38d-8a0b15816f50@ucloud.cn>
 <20200616154716.GA16382@netronome.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <c24444d5-8229-c835-ddf9-20d4ab322c54@ucloud.cn>
Date:   Wed, 17 Jun 2020 10:47:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200616154716.GA16382@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSU5JQkJCTENJTk1JSU1ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdMjULOBw*MxkTCz0TNBceTi0DUDocVlZVSE5OSEsoSVlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MQg6TSo4KDg9QjYJDgFDSUs9
        IjMwFEtVSlVKTkJJSE1JS05ITk1IVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFOSktONwY+
X-HM-Tid: 0a72c02caf202086kuqy3e31841c52
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/16/2020 11:47 PM, Simon Horman wrote:
> On Tue, Jun 16, 2020 at 11:18:16PM +0800, wenxu wrote:
>> 在 2020/6/16 22:34, Simon Horman 写道:
>>> On Tue, Jun 16, 2020 at 10:20:46PM +0800, wenxu wrote:
>>>> 在 2020/6/16 18:51, Simon Horman 写道:
>>>>> On Tue, Jun 16, 2020 at 11:19:38AM +0800, wenxu@ucloud.cn wrote:
>>>>>> From: wenxu <wenxu@ucloud.cn>
>>>>>>
>>>>>> In the function __flow_block_indr_cleanup, The match stataments
>>>>>> this->cb_priv == cb_priv is always false, the flow_block_cb->cb_priv
>>>>>> is totally different data with the flow_indr_dev->cb_priv.
>>>>>>
>>>>>> Store the representor cb_priv to the flow_block_cb->indr.cb_priv in
>>>>>> the driver.
>>>>>>
>>>>>> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
>>>>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>>>> Hi Wenxu,
>>>>>
>>>>> I wonder if this can be resolved by using the cb_ident field of struct
>>>>> flow_block_cb.
>>>>>
>>>>> I observe that mlx5e_rep_indr_setup_block() seems to be the only call-site
>>>>> where the value of the cb_ident parameter of flow_block_cb_alloc() is
>>>>> per-block rather than per-device. So part of my proposal is to change
>>>>> that.
>>>> I check all the xxdriver_indr_setup_block. It seems all the cb_ident parameter of
>>>>
>>>> flow_block_cb_alloc is per-block. Both in the nfp_flower_setup_indr_tc_block
>>>>
>>>> and bnxt_tc_setup_indr_block.
>>>>
>>>>
>>>> nfp_flower_setup_indr_tc_block:
>>>>
>>>> struct nfp_flower_indr_block_cb_priv *cb_priv;
>>>>
>>>> block_cb = flow_block_cb_alloc(nfp_flower_setup_indr_block_cb,
>>>>                                                cb_priv, cb_priv,
>>>>                                                nfp_flower_setup_indr_tc_release);
>>>>
>>>>
>>>> bnxt_tc_setup_indr_block:
>>>>
>>>> struct bnxt_flower_indr_block_cb_priv *cb_priv;
>>>>
>>>> block_cb = flow_block_cb_alloc(bnxt_tc_setup_indr_block_cb,
>>>>                                                cb_priv, cb_priv,
>>>>                                                bnxt_tc_setup_indr_rel);
>>>>
>>>>
>>>> And the function flow_block_cb_is_busy called in most place. Pass the
>>>>
>>>> parameter as cb_priv but not cb_indent .
>>> Thanks, I see that now. But I still think it would be useful to understand
>>> the purpose of cb_ident. It feels like it would lead to a clean solution
>>> to the problem you have highlighted.
>> I think The cb_ident means identify.  It is used to identify the each flow block cb.
>>
>> In the both flow_block_cb_is_busy and flow_block_cb_lookup function check
>>
>> the block_cb->cb_ident == cb_ident.
> Thanks, I think that I now see what you mean about the different scope of
> cb_ident and your proposal to allow cleanup by flow_indr_dev_unregister().
>
> I do, however, still wonder if there is a nicer way than reaching into
> the structure and manually setting block_cb->indr.cb_priv
> at each call-site.
>
> Perhaps a variant of flow_block_cb_alloc() for indirect blocks
> would be nicer?
Yes, It seems a variant of flow_block_cb_alloc() for indirect blocks is better, Thanks.
>

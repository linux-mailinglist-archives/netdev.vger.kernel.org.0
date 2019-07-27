Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF777778A
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 10:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbfG0IDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 04:03:25 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:8646 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfG0IDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 04:03:25 -0400
Received: from [192.168.1.5] (unknown [58.37.151.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id C18F3418C7;
        Sat, 27 Jul 2019 16:03:12 +0800 (CST)
Subject: Re: [PATCH net-next v3 2/3] flow_offload: support get tcf block
 immediately
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1564148047-6428-1-git-send-email-wenxu@ucloud.cn>
 <1564148047-6428-3-git-send-email-wenxu@ucloud.cn>
 <20190726175245.4467d94b@cakuba.netronome.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <aa9e0c4b-5678-cec8-48e2-352b3bd3ba9a@ucloud.cn>
Date:   Sat, 27 Jul 2019 16:02:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190726175245.4467d94b@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSElCS0tLSkpOSEJPTkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PC46Iio4Kzg5EEowEioZDAML
        Kk4wCg9VSlVKTk1PSUpPTkJIS01MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWU5DVUhM
        VUpOSlVKSUJZV1kIAVlBSEtITjcG
X-HM-Tid: 0a6c327485c22086kuqyc18f3418c7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/7/27 8:52, Jakub Kicinski 写道:
> On Fri, 26 Jul 2019 21:34:06 +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> Because the new flow-indr-block can't get the tcf_block
>> directly.
>> It provide a callback to find the tcf block immediately
>> when the device register and contain a ingress block.
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
> Please CC people who gave you feedback on your subsequent submissions.
>
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index 66f89bc..3b2e848 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -391,6 +391,10 @@ struct flow_indr_block_dev {
>>  	struct flow_block *flow_block;
>>  };
>>  
>> +typedef void flow_indr_get_default_block_t(struct flow_indr_block_dev *indr_dev);
>> +
>> +void flow_indr_set_default_block_cb(flow_indr_get_default_block_t *cb);
>> +
>>  struct flow_indr_block_dev *flow_indr_block_dev_lookup(struct net_device *dev);
>>  
>>  int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
>> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
>> index 9f1ae67..db8469d 100644
>> --- a/net/core/flow_offload.c
>> +++ b/net/core/flow_offload.c
>> @@ -298,6 +298,14 @@ struct flow_indr_block_dev *
>>  }
>>  EXPORT_SYMBOL(flow_indr_block_dev_lookup);
>>  
>> +static flow_indr_get_default_block_t *flow_indr_get_default_block;
> This static variable which can only be set to the TC's callback really
> is not a great API design :/
So any advise? just call the function in tc system with #ifdef NET_CLSXXX?
>

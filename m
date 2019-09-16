Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14414B3B4C
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733054AbfIPN3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:29:08 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:37151 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfIPN3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:29:08 -0400
Received: from [192.168.1.6] (unknown [116.234.5.20])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 04D1C419F4;
        Mon, 16 Sep 2019 21:29:03 +0800 (CST)
Subject: Re: [PATCH net] net/sched: cls_api: Fix nooffloaddevcnt counter in
 indr block call success
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <1568628934-32085-1-git-send-email-wenxu@ucloud.cn>
 <20190916102810.GN2286@nanopsycho.orion>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <8a6bdafb-206d-b443-1cdf-e0b6be9fb1b8@ucloud.cn>
Date:   Mon, 16 Sep 2019 21:28:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190916102810.GN2286@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQ01NS0tLSUJPTUNOSE1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MRw6NCo*TTgwFysDTCoWHwsy
        AjMKCiFVSlVKTk1DTU9LTk9PSkNIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VTlVJS1lXWQgBWUFIQktMNwY+
X-HM-Tid: 0a6d3a432d792086kuqy04d1c419f4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/9/16 18:28, Jiri Pirko 写道:
> Please use get_maintainers script to get list of ccs.
>
> Mon, Sep 16, 2019 at 12:15:34PM CEST, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> When a block bind with a dev which support indr block call(vxlan/gretap
>> device). It can bind success but with nooffloaddevcnt++. It will fail
>> when replace the hw filter in tc_setup_cb_call with skip_sw mode for
>> checkout the nooffloaddevcnt and skip_sw.
> I read this paragraph 5 times, I still don't understand :( Could you
> please re-phrase?
will do.
>> if (block->nooffloaddevcnt && err_stop)
>> 	return -EOPNOTSUPP;
>>
>> So with this patch, if the indr block call success, it will not modify
>> the nooffloaddevcnt counter.
>>
>> Fixes: 7f76fa36754b ("net: sched: register callbacks for indirect tc block binds")
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>> net/sched/cls_api.c | 27 +++++++++++++++------------
>> 1 file changed, 15 insertions(+), 12 deletions(-)
>>
>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> index efd3cfb..8a1e3a5 100644
>> --- a/net/sched/cls_api.c
>> +++ b/net/sched/cls_api.c
>> @@ -766,10 +766,10 @@ void tc_indr_block_cb_unregister(struct net_device *dev,
>> }
>> EXPORT_SYMBOL_GPL(tc_indr_block_cb_unregister);
>>
>> -static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
>> -			       struct tcf_block_ext_info *ei,
>> -			       enum flow_block_command command,
>> -			       struct netlink_ext_ack *extack)
>> +static int tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
>> +			      struct tcf_block_ext_info *ei,
>> +			      enum flow_block_command command,
>> +			      struct netlink_ext_ack *extack)
>> {
>> 	struct tc_indr_block_cb *indr_block_cb;
>> 	struct tc_indr_block_dev *indr_dev;
>> @@ -785,7 +785,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
>>
>> 	indr_dev = tc_indr_block_dev_lookup(dev);
>> 	if (!indr_dev)
>> -		return;
>> +		return -ENOENT;
>>
>> 	indr_dev->block = command == FLOW_BLOCK_BIND ? block : NULL;
>>
>> @@ -793,7 +793,10 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
>> 		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
>> 				  &bo);
>>
>> -	tcf_block_setup(block, &bo);
>> +	if (list_empty(&bo.cb_list))
>> +		return -EOPNOTSUPP;
> How is this part related to the rest of the patch?

This check the list is to make sure there is real hw-offload for the indr device( There maybe

get some wrong with indr_block_cb->cb in the driver).  It should a return err to indicate the

caller add the nooffloaddevcnt counter.

.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5FDB7550
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388370AbfISIkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:40:13 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:7608 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387617AbfISIkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 04:40:12 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A7CCA41ACA;
        Thu, 19 Sep 2019 16:40:10 +0800 (CST)
Subject: Re: [PATCH net v3] net/sched: cls_api: Fix nooffloaddevcnt counter
 when indr block call success
From:   wenxu <wenxu@ucloud.cn>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org
References: <1568882232-12847-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <43a07f33-96ec-a169-4316-1b97a4927492@ucloud.cn>
Date:   Thu, 19 Sep 2019 16:40:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1568882232-12847-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSU5PS0tLSkNNQklLSkxZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mkk6TBw6PDg1KSkJSgorQzhR
        EU0KFDNVSlVKTk1DQ0NJT0pLQ0NCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT0NPSDcG
X-HM-Tid: 0a6d48adc5062086kuqya7cca41aca
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sorry forget cc to jiri.

On 9/19/2019 4:37 PM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> A vxlan or gretap device offload through indr block methord. If the device
> successfully bind with a real hw through indr block call, It also add
> nooffloadcnt counter. This counter will lead the rule add failed in
> fl_hw_replace_filter-->tc_setup_cb_call with skip_sw flags.
>
> In the tc_setup_cb_call will check the nooffloaddevcnt and skip_sw flags
> as following:
> if (block->nooffloaddevcnt && err_stop)
>         return -EOPNOTSUPP;
>
> So with this patch, if the indr block call success, it will not modify
> the nooffloaddevcnt counter.
>
> Fixes: 7f76fa36754b ("net: sched: register callbacks for indirect tc block binds")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v3: rebase to the net
>
>  net/sched/cls_api.c | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)
>
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 32577c2..c980127 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -607,11 +607,11 @@ static void tc_indr_block_get_and_ing_cmd(struct net_device *dev,
>  	tc_indr_block_ing_cmd(dev, block, cb, cb_priv, command);
>  }
>  
> -static void tc_indr_block_call(struct tcf_block *block,
> -			       struct net_device *dev,
> -			       struct tcf_block_ext_info *ei,
> -			       enum flow_block_command command,
> -			       struct netlink_ext_ack *extack)
> +static int tc_indr_block_call(struct tcf_block *block,
> +			      struct net_device *dev,
> +			      struct tcf_block_ext_info *ei,
> +			      enum flow_block_command command,
> +			      struct netlink_ext_ack *extack)
>  {
>  	struct flow_block_offload bo = {
>  		.command	= command,
> @@ -621,10 +621,15 @@ static void tc_indr_block_call(struct tcf_block *block,
>  		.block_shared	= tcf_block_shared(block),
>  		.extack		= extack,
>  	};
> +
>  	INIT_LIST_HEAD(&bo.cb_list);
>  
>  	flow_indr_block_call(dev, &bo, command);
> -	tcf_block_setup(block, &bo);
> +
> +	if (list_empty(&bo.cb_list))
> +		return -EOPNOTSUPP;
> +
> +	return tcf_block_setup(block, &bo);
>  }
>  
>  static bool tcf_block_offload_in_use(struct tcf_block *block)
> @@ -681,8 +686,6 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
>  		goto no_offload_dev_inc;
>  	if (err)
>  		goto err_unlock;
> -
> -	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
>  	up_write(&block->cb_lock);
>  	return 0;
>  
> @@ -691,9 +694,10 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
>  		err = -EOPNOTSUPP;
>  		goto err_unlock;
>  	}
> +	err = tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
> +	if (err)
> +		block->nooffloaddevcnt++;
>  	err = 0;
> -	block->nooffloaddevcnt++;
> -	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
>  err_unlock:
>  	up_write(&block->cb_lock);
>  	return err;
> @@ -706,8 +710,6 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
>  	int err;
>  
>  	down_write(&block->cb_lock);
> -	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
> -
>  	if (!dev->netdev_ops->ndo_setup_tc)
>  		goto no_offload_dev_dec;
>  	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
> @@ -717,7 +719,9 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
>  	return;
>  
>  no_offload_dev_dec:
> -	WARN_ON(block->nooffloaddevcnt-- == 0);
> +	err = tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
> +	if (err)
> +		WARN_ON(block->nooffloaddevcnt-- == 0);
>  	up_write(&block->cb_lock);
>  }
>  

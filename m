Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 329288D821
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfHNQcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:32:41 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:41284 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726166AbfHNQcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:32:41 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2B38240005A;
        Wed, 14 Aug 2019 16:32:39 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 14 Aug
 2019 09:32:36 -0700
Subject: Re: [PATCH net-next,v4 07/12] net: sched: use flow block API
To:     Pablo Neira Ayuso <pablo@netfilter.org>
References: <20190709205550.3160-1-pablo@netfilter.org>
 <20190709205550.3160-8-pablo@netfilter.org>
CC:     netdev <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <b45709c7-38b5-2dcb-3db1-0c2fca1840be@solarflare.com>
Date:   Wed, 14 Aug 2019 17:32:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190709205550.3160-8-pablo@netfilter.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24846.005
X-TM-AS-Result: No-8.652700-4.000000-10
X-TMASE-MatchedRID: vbSD0OnL8/IbF9xF7zzuNfZvT2zYoYOwC/ExpXrHizz5+tteD5RzhUa8
        yKZOJ6C10ydY4VdAUiKE/4V4ELwD7ldXhVJKmheRiFAxVB+a60Z5GpkA2em4X1VkJxysad/IZ0K
        4y8cwk+TQ28Xu0AD31q/rqubmgBuQMLxnrIEe9UEmEURBmKrZlN0Gx5Pa47KxJLfQYoCQHFZBTO
        ceQiaS50+dy+d/3+snO9j5Iv9OVbEgmbNmX9WJ5MGNvKPnBgOa3V4UShoTXaccNByoSo036VV2z
        fPCCri0C8Mvm8Nyba5BWXUe0d/YHd5xKQ1PuX/ZEhGH3CRdKUXj+qfvZhFpQjE5FmPR2MmRezKB
        ji0+3F75tFRf3eUM1cUR3WaFcu9ziUvyAFIM+O1vVGJXymdLJMnlJe2gk8vII0YrtQLsSUz8z4k
        rOhCPi+fOVcxjDhcwAYt5KiTiutkLbigRnpKlKZx+7GyJjhAU+XAG8WadtZkRklN03KneMWuNSY
        9U7MALSGrkWcCpOZbePVC4a2WVYi6D86u7S96RsJv4+BFJlvRVRXSWvXPfUEDe7/Z84AiJh8xkx
        6AsMh4ZTSkqdqz5FucIl+0VmRmLNglg0VTTR7tgO21BQaodlQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.652700-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24846.005
X-MDID: 1565800360-6DOxZqhgQkJF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/07/2019 21:55, Pablo Neira Ayuso wrote:
> This patch adds tcf_block_setup() which uses the flow block API.
>
> This infrastructure takes the flow block callbacks coming from the
> driver and register/unregister to/from the cls_api core.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> <snip>
> @@ -796,13 +804,20 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
>  				 struct netlink_ext_ack *extack)
>  {
>  	struct tc_block_offload bo = {};
> +	int err;
>  
>  	bo.net = dev_net(dev);
>  	bo.command = command;
>  	bo.binder_type = ei->binder_type;
>  	bo.block = block;
>  	bo.extack = extack;
> -	return dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
> +	INIT_LIST_HEAD(&bo.cb_list);
> +
> +	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
> +	if (err < 0)
> +		return err;
> +
> +	return tcf_block_setup(block, &bo);
>  }
>  
>  static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
> @@ -1636,6 +1651,77 @@ void tcf_block_cb_unregister(struct tcf_block *block,
>  }
>  EXPORT_SYMBOL(tcf_block_cb_unregister);
>  
> +static int tcf_block_bind(struct tcf_block *block,
> +			  struct flow_block_offload *bo)
> +{
> +	struct flow_block_cb *block_cb, *next;
> +	int err, i = 0;
> +
> +	list_for_each_entry(block_cb, &bo->cb_list, list) {
> +		err = tcf_block_playback_offloads(block, block_cb->cb,
> +						  block_cb->cb_priv, true,
> +						  tcf_block_offload_in_use(block),
> +						  bo->extack);
> +		if (err)
> +			goto err_unroll;
> +
> +		i++;
> +	}
> +	list_splice(&bo->cb_list, &block->cb_list);
> +
> +	return 0;
> +
> +err_unroll:
> +	list_for_each_entry_safe(block_cb, next, &bo->cb_list, list) {
> +		if (i-- > 0) {
> +			list_del(&block_cb->list);
> +			tcf_block_playback_offloads(block, block_cb->cb,
> +						    block_cb->cb_priv, false,
> +						    tcf_block_offload_in_use(block),
> +						    NULL);
> +		}
> +		flow_block_cb_free(block_cb);
> +	}
> +
> +	return err;
> +}
Why has the replay been moved from the function called by the driver
 (__tcf_block_cb_register()) to work done by the driver's caller based on
 what the driver has left on this flow_block_offload.cb_list?  This makes
 it impossible for the driver to (say) unregister a block outside of an
 explicit request from ndo_setup_tc().
In my under-development driver, I have a teardown path called on PCI
 remove, which calls tcf_block_cb_unregister() on all my block bindings
 (of which the driver keeps track), to ensure that no flow rules are still
 in place when unregister_netdev() is called; this is needed because some
 of the driver's state for certain rules involves taking a reference on
 the netdevice (dev_hold()).  Your structural changes here make that
 impossible; is there any reason why they're necessary?

-Ed

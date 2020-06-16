Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E31D1FB418
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgFPOUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:20:47 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:59438 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgFPOUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:20:46 -0400
Received: from [192.168.1.7] (unknown [114.92.199.241])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 59F305C122F;
        Tue, 16 Jun 2020 22:20:43 +0800 (CST)
Subject: Re: [PATCH net v3 2/4] flow_offload: fix incorrect cb_priv check for
 flow_block_cb
To:     Simon Horman <simon.horman@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org,
        vladbu@mellanox.com
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
 <1592277580-5524-3-git-send-email-wenxu@ucloud.cn>
 <20200616105123.GA21396@netronome.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <aee3192c-7664-580b-1f37-9003c91f185b@ucloud.cn>
Date:   Tue, 16 Jun 2020 22:20:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200616105123.GA21396@netronome.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQ0NIS0tLSU5PTUhKS09ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdIjULOBw5Mz1QDExKHhMeCEwDQzocVlZVSkxMSShJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Oj46LAw5DTgrGTY4SU0xFyJC
        TzNPCTlVSlVKTkJJSEpMSU9ITkJCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKT1VC
        SVVKQkJVSU9KWVdZCAFZQU5JQ0w3Bg++
X-HM-Tid: 0a72bd80f08c2087kuqy59f305c122f
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/6/16 18:51, Simon Horman 写道:
> On Tue, Jun 16, 2020 at 11:19:38AM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> In the function __flow_block_indr_cleanup, The match stataments
>> this->cb_priv == cb_priv is always false, the flow_block_cb->cb_priv
>> is totally different data with the flow_indr_dev->cb_priv.
>>
>> Store the representor cb_priv to the flow_block_cb->indr.cb_priv in
>> the driver.
>>
>> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
> Hi Wenxu,
>
> I wonder if this can be resolved by using the cb_ident field of struct
> flow_block_cb.
>
> I observe that mlx5e_rep_indr_setup_block() seems to be the only call-site
> where the value of the cb_ident parameter of flow_block_cb_alloc() is
> per-block rather than per-device. So part of my proposal is to change
> that.

I check all the xxdriver_indr_setup_block. It seems all the cb_ident parameter of

flow_block_cb_alloc is per-block. Both in the nfp_flower_setup_indr_tc_block

and bnxt_tc_setup_indr_block.


nfp_flower_setup_indr_tc_block:

struct nfp_flower_indr_block_cb_priv *cb_priv;

block_cb = flow_block_cb_alloc(nfp_flower_setup_indr_block_cb,
                                               cb_priv, cb_priv,
                                               nfp_flower_setup_indr_tc_release);


bnxt_tc_setup_indr_block:

struct bnxt_flower_indr_block_cb_priv *cb_priv;

block_cb = flow_block_cb_alloc(bnxt_tc_setup_indr_block_cb,
                                               cb_priv, cb_priv,
                                               bnxt_tc_setup_indr_rel);


And the function flow_block_cb_is_busy called in most place. Pass the

parameter as cb_priv but not cb_indent .







>
> The other part of my proposal is to make use of cb_ident in
> __flow_block_indr_cleanup(). Which does seem to match the intended
> purpose of cb_ident. Perhaps it would also be good to document what
> the intended purpose of cb_ident (and the other fields of struct
> flow_block_cb) is.
>
> Compile tested only.
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> index a62bcf0cf512..4de6fcae5252 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> @@ -438,7 +438,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
>  		list_add(&indr_priv->list,
>  			 &rpriv->uplink_priv.tc_indr_block_priv_list);
>  
> -		block_cb = flow_block_cb_alloc(setup_cb, indr_priv, indr_priv,
> +		block_cb = flow_block_cb_alloc(setup_cb, rpriv, indr_priv,
>  					       mlx5e_rep_indr_block_unbind);
>  		if (IS_ERR(block_cb)) {
>  			list_del(&indr_priv->list);
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index b288d2f03789..d281fb182894 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -373,14 +373,13 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
>  EXPORT_SYMBOL(flow_indr_dev_register);
>  
>  static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
> -				      void *cb_priv,
> +				      void *cb_ident,
>  				      struct list_head *cleanup_list)
>  {
>  	struct flow_block_cb *this, *next;
>  
>  	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
> -		if (this->release == release &&
> -		    this->cb_priv == cb_priv) {
> +		if (this->release == release && this->cb_ident == cb_ident) {
>  			list_move(&this->indr.list, cleanup_list);
>  			return;
>  		}
>

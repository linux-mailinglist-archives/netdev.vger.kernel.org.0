Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E4AA010F
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 13:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfH1Lxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 07:53:32 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60796 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726300AbfH1Lxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 07:53:32 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 51B7765291F07743461C;
        Wed, 28 Aug 2019 19:53:29 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Wed, 28 Aug 2019
 19:53:25 +0800
Subject: Re: [PATCH net-next v3 05/10] net: sched: add API for registering
 unlocked offload block callbacks
To:     Vlad Buslov <vladbu@mellanox.com>, <netdev@vger.kernel.org>
CC:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <jakub.kicinski@netronome.com>,
        <pablo@netfilter.org>, Jiri Pirko <jiri@mellanox.com>
References: <20190826134506.9705-1-vladbu@mellanox.com>
 <20190826134506.9705-6-vladbu@mellanox.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <e44141c7-2029-3bee-57b5-ce910a100b72@huawei.com>
Date:   Wed, 28 Aug 2019 19:53:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20190826134506.9705-6-vladbu@mellanox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/8/26 21:45, Vlad Buslov wrote:
> Extend struct flow_block_offload with "unlocked_driver_cb" flag to allow
> registering and unregistering block hardware offload callbacks that do not
> require caller to hold rtnl lock. Extend tcf_block with additional
> lockeddevcnt counter that is incremented for each non-unlocked driver
> callback attached to device. This counter is necessary to conditionally
> obtain rtnl lock before calling hardware callbacks in following patches.
> 
> Register mlx5 tc block offload callbacks as "unlocked".
> 
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 ++
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 3 +++
>   include/net/flow_offload.h                        | 1 +
>   include/net/sch_generic.h                         | 1 +
>   net/sched/cls_api.c                               | 6 ++++++
>   5 files changed, 13 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index fa4bf2d4bcd4..8592b98d0e70 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -3470,10 +3470,12 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
>   			  void *type_data)
>   {
>   	struct mlx5e_priv *priv = netdev_priv(dev);
> +	struct flow_block_offload *f = type_data;
>   
>   	switch (type) {
>   #ifdef CONFIG_MLX5_ESWITCH
>   	case TC_SETUP_BLOCK:
> +		f->unlocked_driver_cb = true;
>   		return flow_block_cb_setup_simple(type_data,
>   						  &mlx5e_block_cb_list,
>   						  mlx5e_setup_tc_block_cb,
Hi,

I have got below warning when compiling the latest net-next:
drivers/net/ethernet/mellanox//mlx5/core/en_main.c:3473:29: warning: 
unused variable ‘f’ [-Wunused-variable]
   struct flow_block_offload *f = type_data;

Could this variable be defined within "#ifdef CONFIG_MLX5_ESWITCH"?
BTW, it seems varible f has not been used in any place in addition to 
assigning true to its member unlocked_driver_cb in "case 
TC_SETUP_BLOCK:". Maybe I have miss something about it:).

Huazhong.
Thanks.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index 3c0d36b2b91c..e7ac6233037d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -763,6 +763,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
>   	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
>   		return -EOPNOTSUPP;
>   
> +	f->unlocked_driver_cb = true;
>   	f->driver_block_list = &mlx5e_block_cb_list;
>   
>   	switch (f->command) {
> @@ -1245,9 +1246,11 @@ static int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
>   			      void *type_data)
>   {
>   	struct mlx5e_priv *priv = netdev_priv(dev);
> +	struct flow_block_offload *f = type_data;
>   
>   	switch (type) {
>   	case TC_SETUP_BLOCK:
> +		f->unlocked_driver_cb = true;
>   		return flow_block_cb_setup_simple(type_data,
>   						  &mlx5e_rep_block_cb_list,
>   						  mlx5e_rep_setup_tc_cb,
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 757fa84de654..fc881875f856 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -284,6 +284,7 @@ struct flow_block_offload {
>   	enum flow_block_command command;
>   	enum flow_block_binder_type binder_type;
>   	bool block_shared;
> +	bool unlocked_driver_cb;
>   	struct net *net;
>   	struct flow_block *block;
>   	struct list_head cb_list;
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index c4fbbaff30a2..43f5b7ed02bd 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -408,6 +408,7 @@ struct tcf_block {
>   	bool keep_dst;
>   	atomic_t offloadcnt; /* Number of oddloaded filters */
>   	unsigned int nooffloaddevcnt; /* Number of devs unable to do offload */
> +	unsigned int lockeddevcnt; /* Number of devs that require rtnl lock. */
>   	struct {
>   		struct tcf_chain *chain;
>   		struct list_head filter_chain_list;
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 8b807e75fae2..1a39779bdbad 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -1418,6 +1418,8 @@ static int tcf_block_bind(struct tcf_block *block,
>   						  bo->extack);
>   		if (err)
>   			goto err_unroll;
> +		if (!bo->unlocked_driver_cb)
> +			block->lockeddevcnt++;
>   
>   		i++;
>   	}
> @@ -1433,6 +1435,8 @@ static int tcf_block_bind(struct tcf_block *block,
>   						    block_cb->cb_priv, false,
>   						    tcf_block_offload_in_use(block),
>   						    NULL);
> +			if (!bo->unlocked_driver_cb)
> +				block->lockeddevcnt--;
>   		}
>   		flow_block_cb_free(block_cb);
>   	}
> @@ -1454,6 +1458,8 @@ static void tcf_block_unbind(struct tcf_block *block,
>   					    NULL);
>   		list_del(&block_cb->list);
>   		flow_block_cb_free(block_cb);
> +		if (!bo->unlocked_driver_cb)
> +			block->lockeddevcnt--;
>   	}
>   }
>   
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB5D190E16
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgCXMvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:51:05 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:57397 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgCXMvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 08:51:04 -0400
Received: from [192.168.1.3] (unknown [101.81.70.14])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 0393341180;
        Tue, 24 Mar 2020 20:50:51 +0800 (CST)
Subject: Re: [PATCH net-next v5 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     saeedm@mellanox.com, paulb@mellanox.com, netdev@vger.kernel.org
References: <1585007097-28475-1-git-send-email-wenxu@ucloud.cn>
 <1585007097-28475-3-git-send-email-wenxu@ucloud.cn>
 <vbfimiudklj.fsf@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <d6e75961-1098-1dc4-b1ea-fa733aeb37c0@ucloud.cn>
Date:   Tue, 24 Mar 2020 20:49:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <vbfimiudklj.fsf@mellanox.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEhLS0tLS09JQkpOSE9ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MDo6IRw*NjgzGhIfOQgoLxYX
        AS0KC0xVSlVKTkNOS05PSU5JSU1JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVD
        SlVMS1VKT1lXWQgBWUFPTE9LNwY+
X-HM-Tid: 0a710c987c7a2086kuqy0393341180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/3/24 20:05, Vlad Buslov Ð´µÀ:
> On Tue 24 Mar 2020 at 01:44, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> Add mlx5e_rep_indr_setup_ft_cb to support indr block setup
>> in FT mode.
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>> v5: no change
>>
>>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 52 ++++++++++++++++++++++++
>>   1 file changed, 52 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> index 057f5f9..30c81c3 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> @@ -732,6 +732,55 @@ static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
>>   	}
>>   }
>>
>> +static int mlx5e_rep_indr_setup_ft_cb(enum tc_setup_type type,
>> +				      void *type_data, void *indr_priv)
>> +{
>> +	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
>> +	struct flow_cls_offload *f = type_data;
>> +	struct flow_cls_offload tmp;
>> +	struct mlx5e_priv *mpriv;
>> +	struct mlx5_eswitch *esw;
>> +	unsigned long flags;
>> +	int err;
>> +
>> +	mpriv = netdev_priv(priv->rpriv->netdev);
>> +	esw = mpriv->mdev->priv.eswitch;
>> +
>> +	flags = MLX5_TC_FLAG(EGRESS) |
>> +		MLX5_TC_FLAG(ESW_OFFLOAD) |
>> +		MLX5_TC_FLAG(FT_OFFLOAD);
>> +
>> +	switch (type) {
>> +	case TC_SETUP_CLSFLOWER:
>> +		memcpy(&tmp, f, sizeof(*f));
>> +
>> +		if (!mlx5_esw_chains_prios_supported(esw))
>> +			return -EOPNOTSUPP;
>> +
>> +		/* Re-use tc offload path by moving the ft flow to the
>> +		 * reserved ft chain.
>> +		 *
>> +		 * FT offload can use prio range [0, INT_MAX], so we normalize
>> +		 * it to range [1, mlx5_esw_chains_get_prio_range(esw)]
>> +		 * as with tc, where prio 0 isn't supported.
>> +		 *
>> +		 * We only support chain 0 of FT offload.
>> +		 */
>> +		if (tmp.common.prio >= mlx5_esw_chains_get_prio_range(esw))
>> +			return -EOPNOTSUPP;
>> +		if (tmp.common.chain_index != 0)
>> +			return -EOPNOTSUPP;
>> +
>> +		tmp.common.chain_index = mlx5_esw_chains_get_ft_chain(esw);
>> +		tmp.common.prio++;
>> +		err = mlx5e_rep_indr_offload(priv->netdev, &tmp, priv, flags);
>> +		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
> Why do you need to create temporary copy of flow_cls_offload struct and
> then copy parts of tmp back to the original? Again, this info should
> probably be in the commit message.

This FT mode using the specficed chain_index which changed by driver adnd

using only in driver. It will move the flow table rules to their 
steering domain.

This scenario just follow the mlx5e_rep_setup_ft_cb which did offload in 
FT mode.

So it's an old scenario, Is it necessary to add to the commit message?

>
>> +		return err;
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
>> +}
>> +
>>   static void mlx5e_rep_indr_block_unbind(void *cb_priv)
>>   {
>>   	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
>> @@ -809,6 +858,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
>>   	case TC_SETUP_BLOCK:
>>   		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
>>   						  mlx5e_rep_indr_setup_tc_cb);
>> +	case TC_SETUP_FT:
>> +		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
>> +						  mlx5e_rep_indr_setup_ft_cb);
>>   	default:
>>   		return -EOPNOTSUPP;
>>   	}

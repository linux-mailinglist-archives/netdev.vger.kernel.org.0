Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 532FB18DDD3
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 05:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgCUD6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 23:58:49 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:18707 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgCUD6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 23:58:49 -0400
Received: from [192.168.1.6] (unknown [101.81.70.14])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A960141C8A;
        Sat, 21 Mar 2020 11:58:38 +0800 (CST)
Subject: Re: [PATCH net-next v2 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1584523959-6587-1-git-send-email-wenxu@ucloud.cn>
 <1584523959-6587-3-git-send-email-wenxu@ucloud.cn>
 <0a74354f83b864501d708200f7d78085cca19fff.camel@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <9c118bb4-9971-1a2d-7dd5-2b2a41d4db55@ucloud.cn>
Date:   Sat, 21 Mar 2020 11:57:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <0a74354f83b864501d708200f7d78085cca19fff.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQkJKS0tLSUJPTUNOSE1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pyo6Aww5ATg3GhMvDAguMAtK
        ITIKCzBVSlVKTkNPTE1ISkpDQk9NVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVD
        SlVMS1VKT1lXWQgBWUFPTUlONwY+
X-HM-Tid: 0a70fb3e24e02086kuqya960141c8a
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/3/21 10:45, Saeed Mahameed 写道:
> On Wed, 2020-03-18 at 17:32 +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> Add mlx5e_rep_indr_setup_ft_cb to support indr block setup
>> in FT mode.
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>> v2: rebase to master
>>
>>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 49
>> ++++++++++++++++++++++++
>>   1 file changed, 49 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> index 057f5f9..a88c70b 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> @@ -732,6 +732,52 @@ static int mlx5e_rep_indr_setup_tc_cb(enum
>> tc_setup_type type,
>>   	}
>>   }
>>   
>> +static int mlx5e_rep_indr_setup_ft_cb(enum tc_setup_type type,
>> +				      void *type_data, void *indr_priv)
>> +{
>> +	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
>> +	struct mlx5e_priv *mpriv = netdev_priv(priv->rpriv->netdev);
> Hi Wenxu,
>
> let's fix reverse xmas tree style here, while vlad is looking at this.

But the second line depends on the first line.  the mpriv ptr get from 
the priv ptr.


>
>> +	struct mlx5_eswitch *esw = mpriv->mdev->priv.eswitch;
>> +	struct flow_cls_offload *f = type_data;
>> +	struct flow_cls_offload tmp;
>> +	unsigned long flags;
>> +	int err;
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
>> +		 * FT offload can use prio range [0, INT_MAX], so we
>> normalize
>> +		 * it to range [1, mlx5_esw_chains_get_prio_range(esw)]
>> +		 * as with tc, where prio 0 isn't supported.
>> +		 *
>> +		 * We only support chain 0 of FT offload.
>> +		 */
>> +		if (tmp.common.prio >=
>> mlx5_esw_chains_get_prio_range(esw))
>> +			return -EOPNOTSUPP;
>> +		if (tmp.common.chain_index != 0)
>> +			return -EOPNOTSUPP;
>> +
>> +		tmp.common.chain_index =
>> mlx5_esw_chains_get_ft_chain(esw);
>> +		tmp.common.prio++;
>> +		err = mlx5e_rep_indr_offload(priv->netdev, &tmp, priv,
>> flags);
>> +		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
>> +		return err;
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
>> +}
>> +
>>   static void mlx5e_rep_indr_block_unbind(void *cb_priv)
>>   {
>>   	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
>> @@ -809,6 +855,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device
>> *netdev, void *cb_priv,
>>   	case TC_SETUP_BLOCK:
>>   		return mlx5e_rep_indr_setup_block(netdev, cb_priv,
>> type_data,
>>   						  mlx5e_rep_indr_setup_
>> tc_cb);
>> +	case TC_SETUP_FT:
>> +		return mlx5e_rep_indr_setup_block(netdev, cb_priv,
>> type_data,
>> +						  mlx5e_rep_indr_setup_
>> ft_cb);
>>   	default:
>>   		return -EOPNOTSUPP;
>>   	}

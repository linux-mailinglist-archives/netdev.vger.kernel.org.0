Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB0711A188
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 03:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfLKClk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 21:41:40 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:32132 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfLKClk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 21:41:40 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 0672840F58;
        Wed, 11 Dec 2019 10:41:32 +0800 (CST)
Subject: Re: [PATCH net-next 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
To:     Paul Blakey <paulb@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
References: <1575972525-20046-1-git-send-email-wenxu@ucloud.cn>
 <1575972525-20046-2-git-send-email-wenxu@ucloud.cn>
 <140d29e0-712a-31b0-e7b0-e4f8af29d4a8@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <a96ffa33-e680-d92c-3c5c-f86b7b9e12bb@ucloud.cn>
Date:   Wed, 11 Dec 2019 10:41:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <140d29e0-712a-31b0-e7b0-e4f8af29d4a8@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEtMS0tLS09KS0tDWVdZKFlBSU
        I3V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mj46Fzo*MTg0TEkeDRILDRc6
        LE0wCRlVSlVKTkxNS0hJS0JPS09MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT05PQzcG
X-HM-Tid: 0a6ef2d543e62086kuqy0672840f58
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/10/2019 7:44 PM, Paul Blakey wrote:
> On 12/10/2019 12:08 PM, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> Add mlx5e_rep_indr_setup_ft_cb to support indr block setup
>> in FT mode.
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 37 ++++++++++++++++++++++++
>>   1 file changed, 37 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> index 6f304f6..e0da17c 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>> @@ -748,6 +748,40 @@ static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
>>   	}
>>   }
>>   
>> +static int mlx5e_rep_indr_setup_ft_cb(enum tc_setup_type type,
>> +				      void *type_data, void *indr_priv)
>> +{
>> +	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
>> +	struct mlx5e_priv *mpriv = netdev_priv(priv->rpriv->netdev);
>> +	struct mlx5_eswitch *esw = mpriv->mdev->priv.eswitch;
>> +	struct flow_cls_offload *f = type_data;
>> +	struct flow_cls_offload cls_flower;
>> +	unsigned long flags;
>> +	int err;
>> +
>> +	flags = MLX5_TC_FLAG(EGRESS) |
>> +		MLX5_TC_FLAG(ESW_OFFLOAD) |
>> +		MLX5_TC_FLAG(FT_OFFLOAD);
>> +
>> +	switch (type) {
>> +	case TC_SETUP_CLSFLOWER:
>> +		if (!mlx5_eswitch_prios_supported(esw) || f->common.chain_index)
>> +			return -EOPNOTSUPP;
>> +
>> +		/* Re-use tc offload path by moving the ft flow to the
>> +		 * reserved ft chain.
>> +		 */
>> +		memcpy(&cls_flower, f, sizeof(*f));
>> +		cls_flower.common.chain_index = FDB_FT_CHAIN;
>> +		err = mlx5e_rep_indr_offload(priv->netdev, &cls_flower, priv,
>> +					     flags);
>> +		memcpy(&f->stats, &cls_flower.stats, sizeof(f->stats));
>> +		return err;
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
>> +}
>> +
>>   static void mlx5e_rep_indr_block_unbind(void *cb_priv)
>>   {
>>   	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
>> @@ -825,6 +859,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
>>   	case TC_SETUP_BLOCK:
>>   		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
>>   						  mlx5e_rep_indr_setup_tc_cb);
>> +	case TC_SETUP_FT:
>> +		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
>> +						  mlx5e_rep_indr_setup_ft_cb);
>>   	default:
>>   		return -EOPNOTSUPP;
>>   	}
>
> +cc Saeed
>
>
> This looks good to me, but it should be on top of a patch that will 
> actual allows the indirect BIND if the nft
>
> table device is a tunnel device. Is that upstream? If so which patch?
>
>
> Currently (5.5.0-rc1+), nft_register_flowtable_net_hooks calls 
> nf_flow_table_offload_setup which will see
>
> that the tunnel device doesn't have ndo_setup_tc and return 
> -EOPNOTSUPPORTED.

The related patch  http://patchwork.ozlabs.org/patch/1206935/

is waiting for upstream


>
> Thanks,
>
> Paul.
>
>
>

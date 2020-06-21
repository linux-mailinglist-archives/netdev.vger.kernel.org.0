Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FC4202AD2
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 15:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgFUNkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 09:40:18 -0400
Received: from mail-vi1eur05on2085.outbound.protection.outlook.com ([40.107.21.85]:6248
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729649AbgFUNkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 09:40:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPq6dje81MiQwITlfOrbhuLntSPZOvdofpGdsexerVTGgO1f12K1RQLqeupjWZNg0MlIPAoc+AR5Tl/uWOCKJlDn0aYBQddOj6FVpAXr2BnI4cM6/gNKSY8tBI4EEb74iqwj56WjwvM0fNxODPVziLYLnUjTalO3mtoRhfc8up1uD79pUDABHVjPeTBTgOGtUDQCBdvAZgPH641mkcrLzqwVK77kpMnnjaI2fVtQwvHYzxnFFtJjExLkFhgkR+nYI/E+c0YW/ArTQL81AnADtDPLfiY+5B+NsVHFnGHxd2MqLfdzsvRDrmdRYBdTaCylyL8lqZ+FKFZ+L75zxu7q8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9qR6pGjGxgmkbkM01BPnLcEi+MYOCiplUkpoip4JNQ=;
 b=lS2TQg0HCYfO/HDbXII/kCkUKseEobu1A7eNdqwLZ2cO1Gt12hf8N9kZQRV/OeA831giSmIP8brPel/JlNrwnRZexeIMrayR05PfhsdnqgrvJhIwPcKQn1zR9qMsUK/rzSp32rfDYtzQT0X/LmxoONmPEqZuLzKypLpiARKWJu1IMQgBUvQde2ySotKxdo7kU8GeRpJ09A09AXJxeWcpWX3iO9Pwy+PyxZ2pvrvT+8Eji4BgLX+OXR0TdO+1vysbaDK8nSeJeu6CaEqtQAW0jwlcTHKuhdhNDi4U8xgV6rh+7dj8qBSTHit7+XH1SZlb0oO3AbLHUNPB8iwhEVKfXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9qR6pGjGxgmkbkM01BPnLcEi+MYOCiplUkpoip4JNQ=;
 b=PUkzB2AvjS+4P4TJ3oqjDlkMJWC6Sr+7f/mNjcrggWb8CrzsGH4jUFLq8gntt/A3jSxWrRapPa0U6LF+o643Eqz1gUZwdL5XRQlEZUReWX44D4T0wDCF2bR3WcXaIdRcPCQoo6NYK3tEnc4HrmSdcKhxcwIAQH678Ya7nFVWOrU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com (2603:10a6:5:18::21) by
 DB7PR05MB4443.eurprd05.prod.outlook.com (2603:10a6:5:25::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.23; Sun, 21 Jun 2020 13:40:13 +0000
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::39ab:622c:b05b:c86]) by DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::39ab:622c:b05b:c86%3]) with mapi id 15.20.3109.025; Sun, 21 Jun 2020
 13:40:12 +0000
Subject: Re: [PATCH net-next v3 1/3] net/mlx5e: Implicitly decap the tunnel
 packet when necessary
To:     xiangxia.m.yue@gmail.com, paulb@mellanox.com, saeedm@mellanox.com,
        gerlitz.or@gmail.com
Cc:     netdev@vger.kernel.org
References: <20200618083646.59507-1-xiangxia.m.yue@gmail.com>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <c5fbdc63-96e9-8d02-0cd9-03cf036afe91@mellanox.com>
Date:   Sun, 21 Jun 2020 16:40:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <20200618083646.59507-1-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0202CA0020.eurprd02.prod.outlook.com
 (2603:10a6:200:89::30) To DB7PR05MB4156.eurprd05.prod.outlook.com
 (2603:10a6:5:18::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.170] (176.231.115.41) by AM4PR0202CA0020.eurprd02.prod.outlook.com (2603:10a6:200:89::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Sun, 21 Jun 2020 13:40:11 +0000
X-Originating-IP: [176.231.115.41]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a879c09d-e3d7-4aa7-1453-08d815e89f82
X-MS-TrafficTypeDiagnostic: DB7PR05MB4443:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB444363A0E24867FED2972DCFB5960@DB7PR05MB4443.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:313;
X-Forefront-PRVS: 04410E544A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eg4m0Yog1YW9Nln995uVhnX0T8ZjS71+KNNskofiPJe+QKV8SXwkG5T9YCsOj1WKNlbtNdWHVbE5DY5OQiNB5yCy51w3EBLSeUbMNtxdvx9mZOGypFKyUf4Un6DKJtme/YsYJpJQvTvWbppU3tREw9vxaM7dRhu2u+++tg5BRPfyZNsVcpS6Ja7A3S/CFFcVUtsl1rAjdb6GmFtB0IqcWTOTN8jgPcyQCsH5Ziodd5Z5kYZejcMtToFa9+FL7P9g+w7cL6+njx0+kbTCcBEYyMVAhUQPRMdGntO4fKDAaXw4TSfeUKK4nO9ocBcElLUaE4pMCQ2CVqoPRyyhX7d4drF7cBBL7uXfmJvU4TX4BIT2BrZpOrVuC491sLZ0csKjPyQs5fRwCpeALdGUGpxtJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4156.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(31686004)(316002)(478600001)(2616005)(66556008)(66476007)(956004)(8676002)(36756003)(66946007)(86362001)(31696002)(16526019)(83380400001)(26005)(186003)(5660300002)(52116002)(4326008)(2906002)(6486002)(16576012)(8936002)(30864003)(53546011)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oDCy7zXgNLhZxhDCPClswAStUUFT4RpkwuV8p05FZD420VH8xZi7r78yQEubuKB0kwJvVgsoU7QRh2HCcJ4/VYNUvUGY7yPAKdzWPqyRkTBEno0Xer+Umv07537VKWZLac3oYs2OGzwl2tRY7xwi13jVcyhyG7PD+1xoS1zfGe8hp7Y2K1Kp/l1W14L4eUG6YON21YEedhuTeclrqmaq9mjKAIdwBMEsKHQGznn7rqtyDkjYbzunIUx7l9tSfRP0avJP6fr7zqO0YeXjJx+7TuXe86aXsIkAfEltiwr960xmAw73jMxwgP+7kUcLKDQwl7N5cRQSVq/7AmPktLRvTPLf+qu2HodpO+kRPTcwQe8opeYOtPEF2eCaJ8UxcGvW3sODWM7g4hEx1Rj/HvMOXCeqAdXF3VJGqjW8Kr5O1pRW9p/D5WdKvI5MG4pE667kYHnfmYWk9oFT1Y6oRt35VKZlJ62uhmy7uWJ5jTg/pR8gVENCc0vbFHqs6h3ql95l
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a879c09d-e3d7-4aa7-1453-08d815e89f82
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2020 13:40:12.7432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7td7R9vvHnrPMrzEye3N5MzxK1WSt6kUDvFG3hTXJwwJJR5Kd++3pP6sheBXllHiQRY/HrfYvE+z2TPIEGKBjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4443
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-06-18 11:36 AM, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> The commit 0a7fcb78cc21 ("net/mlx5e: Support inner header rewrite with
> goto action"), will decapsulate the tunnel packets if there is a goto
> action in chain 0. But in some case, we don't want do that, for example:
> 
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0      \
>         flower enc_dst_ip 2.2.2.100 enc_dst_port 4789                   \
>         action goto chain 2
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2      \
>         flower dst_mac 00:11:22:33:44:55 enc_src_ip 2.2.2.200           \
>         enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100           \
>         action tunnel_key unset action mirred egress redirect dev enp130s0f0_0
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2      \
>         flower dst_mac 00:11:22:33:44:66 enc_src_ip 2.2.2.200           \
>         enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 200           \
>         action tunnel_key unset action mirred egress redirect dev enp130s0f0_1
> 
> If there are pedit and goto actions, do the decapsulate and id mapping action.
> 

Hi Tonghao,

I think you might missed Paul's comments on V2?

Thanks,
Roi

> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  .../ethernet/mellanox/mlx5/core/en/mapping.c  |  24 ++++
>  .../ethernet/mellanox/mlx5/core/en/mapping.h  |   1 +
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 109 ++++++++++++------
>  3 files changed, 99 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
> index ea321e528749..90306dde6b60 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
> @@ -74,6 +74,30 @@ int mapping_add(struct mapping_ctx *ctx, void *data, u32 *id)
>  	return err;
>  }
>  
> +int mapping_find_by_data(struct mapping_ctx *ctx, void *data, u32 *id)
> +{
> +	struct mapping_item *mi;
> +	u32 hash_key;
> +
> +	mutex_lock(&ctx->lock);
> +
> +	hash_key = jhash(data, ctx->data_size, 0);
> +	hash_for_each_possible(ctx->ht, mi, node, hash_key) {
> +		if (!memcmp(data, mi->data, ctx->data_size))
> +			goto found;
> +	}
> +
> +	mutex_unlock(&ctx->lock);
> +	return -ENOENT;
> +
> +found:
> +	if (id)
> +		*id = mi->id;
> +
> +	mutex_unlock(&ctx->lock);
> +	return 0;
> +}
> +
>  static void mapping_remove_and_free(struct mapping_ctx *ctx,
>  				    struct mapping_item *mi)
>  {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
> index 285525cc5470..af501c9796b7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
> @@ -9,6 +9,7 @@ struct mapping_ctx;
>  int mapping_add(struct mapping_ctx *ctx, void *data, u32 *id);
>  int mapping_remove(struct mapping_ctx *ctx, u32 id);
>  int mapping_find(struct mapping_ctx *ctx, u32 id, void *data);
> +int mapping_find_by_data(struct mapping_ctx *ctx, void *data, u32 *id);
>  
>  /* mapping uses an xarray to map data to ids in add(), and for find().
>   * For locking, it uses a internal xarray spin lock for add()/remove(),
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 7fc84f58e28a..05f8df8b53af 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -1836,7 +1836,8 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
>  	}
>  }
>  
> -static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
> +static int flow_has_tc_action(struct flow_cls_offload *f,
> +			      enum flow_action_id action)
>  {
>  	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
>  	struct flow_action *flow_action = &rule->action;
> @@ -1844,12 +1845,8 @@ static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
>  	int i;
>  
>  	flow_action_for_each(i, act, flow_action) {
> -		switch (act->id) {
> -		case FLOW_ACTION_GOTO:
> +		if (act->id == action)
>  			return true;
> -		default:
> -			continue;
> -		}
>  	}
>  
>  	return false;
> @@ -1901,10 +1898,37 @@ enc_opts_is_dont_care_or_full_match(struct mlx5e_priv *priv,
>  	       sizeof(*__dst));\
>  })
>  
> +static void mlx5e_make_tunnel_match_key(struct flow_cls_offload *f,
> +					struct net_device *filter_dev,
> +					struct tunnel_match_key *tunnel_key)
> +{
> +	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
> +
> +	memset(tunnel_key, 0, sizeof(*tunnel_key));
> +	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL,
> +		       &tunnel_key->enc_control);
> +	if (tunnel_key->enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS)
> +		COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
> +			       &tunnel_key->enc_ipv4);
> +	else
> +		COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS,
> +			       &tunnel_key->enc_ipv6);
> +
> +	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IP, &tunnel_key->enc_ip);
> +	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_PORTS,
> +		       &tunnel_key->enc_tp);
> +	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_KEYID,
> +		       &tunnel_key->enc_key_id);
> +
> +	tunnel_key->filter_ifindex = filter_dev->ifindex;
> +}
> +
>  static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
>  				    struct mlx5e_tc_flow *flow,
>  				    struct flow_cls_offload *f,
> -				    struct net_device *filter_dev)
> +				    struct net_device *filter_dev,
> +				    bool sets_mapping,
> +				    bool needs_mapping)
>  {
>  	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
>  	struct netlink_ext_ack *extack = f->common.extack;
> @@ -1925,22 +1949,7 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
>  	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
>  	uplink_priv = &uplink_rpriv->uplink_priv;
>  
> -	memset(&tunnel_key, 0, sizeof(tunnel_key));
> -	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL,
> -		       &tunnel_key.enc_control);
> -	if (tunnel_key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS)
> -		COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
> -			       &tunnel_key.enc_ipv4);
> -	else
> -		COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS,
> -			       &tunnel_key.enc_ipv6);
> -	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_IP, &tunnel_key.enc_ip);
> -	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_PORTS,
> -		       &tunnel_key.enc_tp);
> -	COPY_DISSECTOR(rule, FLOW_DISSECTOR_KEY_ENC_KEYID,
> -		       &tunnel_key.enc_key_id);
> -	tunnel_key.filter_ifindex = filter_dev->ifindex;
> -
> +	mlx5e_make_tunnel_match_key(f, filter_dev, &tunnel_key);
>  	err = mapping_add(uplink_priv->tunnel_mapping, &tunnel_key, &tun_id);
>  	if (err)
>  		return err;
> @@ -1970,10 +1979,10 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
>  	mask = enc_opts_id ? TUNNEL_ID_MASK :
>  			     (TUNNEL_ID_MASK & ~ENC_OPTS_BITS_MASK);
>  
> -	if (attr->chain) {
> +	if (needs_mapping) {
>  		mlx5e_tc_match_to_reg_match(&attr->parse_attr->spec,
>  					    TUNNEL_TO_REG, value, mask);
> -	} else {
> +	} else if (sets_mapping) {
>  		mod_hdr_acts = &attr->parse_attr->mod_hdr_acts;
>  		err = mlx5e_tc_match_to_reg_set(priv->mdev,
>  						mod_hdr_acts,
> @@ -1996,6 +2005,25 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
>  	return err;
>  }
>  
> +static int mlx5e_lookup_flow_tunnel_id(struct mlx5e_priv *priv,
> +				       struct mlx5e_tc_flow *flow,
> +				       struct flow_cls_offload *f,
> +				       struct net_device *filter_dev,
> +				       u32 *tun_id)
> +{
> +	struct mlx5_rep_uplink_priv *uplink_priv;
> +	struct mlx5e_rep_priv *uplink_rpriv;
> +	struct tunnel_match_key tunnel_key;
> +	struct mlx5_eswitch *esw;
> +
> +	esw = priv->mdev->priv.eswitch;
> +	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> +	uplink_priv = &uplink_rpriv->uplink_priv;
> +
> +	mlx5e_make_tunnel_match_key(f, filter_dev, &tunnel_key);
> +	return mapping_find_by_data(uplink_priv->tunnel_mapping, &tunnel_key, tun_id);
> +}
> +
>  static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow)
>  {
>  	u32 enc_opts_id = flow->tunnel_id & ENC_OPTS_BITS_MASK;
> @@ -2057,13 +2085,19 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
>  	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
>  	struct netlink_ext_ack *extack = f->common.extack;
>  	bool needs_mapping, sets_mapping;
> +	bool pedit_action;
>  	int err;
>  
>  	if (!mlx5e_is_eswitch_flow(flow))
>  		return -EOPNOTSUPP;
>  
> -	needs_mapping = !!flow->esw_attr->chain;
> -	sets_mapping = !flow->esw_attr->chain && flow_has_tc_fwd_action(f);
> +	pedit_action = flow_has_tc_action(f, FLOW_ACTION_MANGLE) ||
> +		       flow_has_tc_action(f, FLOW_ACTION_ADD);
> +	sets_mapping = pedit_action &&
> +		       flow_has_tc_action(f, FLOW_ACTION_GOTO);
> +	needs_mapping = !!flow->esw_attr->chain &&
> +			!mlx5e_lookup_flow_tunnel_id(priv, flow, f,
> +						     filter_dev, NULL);
>  	*match_inner = !needs_mapping;
>  
>  	if ((needs_mapping || sets_mapping) &&
> @@ -2075,7 +2109,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
>  		return -EOPNOTSUPP;
>  	}
>  
> -	if (!flow->esw_attr->chain) {
> +	if (*match_inner) {
>  		err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f,
>  					 match_level);
>  		if (err) {
> @@ -2085,18 +2119,20 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
>  				    "Failed to parse tunnel attributes");
>  			return err;
>  		}
> -
> -		/* With mpls over udp we decapsulate using packet reformat
> -		 * object
> -		 */
> -		if (!netif_is_bareudp(filter_dev))
> -			flow->esw_attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
>  	}
>  
> +	/* With mpls over udp we decapsulate using packet reformat
> +	 * object
> +	 */
> +	if (!netif_is_bareudp(filter_dev) &&
> +	    sets_mapping && !needs_mapping)
> +		flow->esw_attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
> +
>  	if (!needs_mapping && !sets_mapping)
>  		return 0;
>  
> -	return mlx5e_get_flow_tunnel_id(priv, flow, f, filter_dev);
> +	return mlx5e_get_flow_tunnel_id(priv, flow, f, filter_dev,
> +					sets_mapping, needs_mapping);
>  }
>  
>  static void *get_match_inner_headers_criteria(struct mlx5_flow_spec *spec)
> @@ -4309,6 +4345,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>  		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>  	}
>  
> +	if (decap)
> +		attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
> +
>  	if (!(attr->action &
>  	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
>  		NL_SET_ERR_MSG_MOD(extack,
> 

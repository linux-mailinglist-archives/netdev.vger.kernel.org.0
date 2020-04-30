Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE421C0033
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgD3P03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:26:29 -0400
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:59748
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726830AbgD3P02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 11:26:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PP0EAPf6A46adgzTTiw9OUaThjOVBGW1+O+vk4DRbz0LjfShH7hZ+/rvouxHEk8DeKz/O4k9DtgWpmRbodoV2fEPLQwR1avPTJKxhmpzC3L1psPiOLz3MtgWNvig66fcyj9nHWQMnCslqzM3/8sUXVA1HByRL4eOf/GzXgh0VZrVnjgR0i3DNMv7mebIN33Eh6oAtMVe8hmfqXZPKVp2q2SRBXru3vRTaZdz55/gZ0zasON0M3vqZ1YSTooVsxefqYJdlq635th4gjJ7FcKUwkhRmv+u9HynO8nJLjVtaExP7cdSfENYavXg+PMstv1fHpSJstUOZ33ZkNe/XJJQPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mnNwuNvaAq/kKoqj+j4aPbhgB1QTY72lTn7+qNutJU=;
 b=VhcjJ4eRdZj3LvkFCm6XV06EDHWd1Tzv3FaEVZI5/xnweHfjxtRMMK69TQKv31muOH7fwbTXxZZeLSqw1xa5b6sFlXWfezeLFdVT9EMK0210hjxkCf3vEHm5RNKv4roI/nb6ZlgWegNMsjGWnMjpJ6VaccaSmDRKcsRV+01+PFqgL1x39vjH6TGH0x4vcYisah4Bc3a09jbO34+EDnLF4Wjrg9UHmWVVzGuNqIu9tbnR5xJTV+51N+h18ymVyvRVAypXVZBcdXWnYpzZf9J5gUNIN3Yny2pH0qJ/9kcgZf+9hwGp8Sg1D/viDfrf/qQl0uRQU8FGSRxqWidLUjMB6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mnNwuNvaAq/kKoqj+j4aPbhgB1QTY72lTn7+qNutJU=;
 b=pc44QlR+DVliZ6eyPMgixoyXjQxgH8WTbRbuPQWfgrJssgPcP12AWCMBaj+SSFCX/wxZYy3b+HNTOmqElv8R+ZURnHCE1kJW83c5Zr8Lz3IBY/3OR30GPcY7h4xj3ZCLBpzp9sWm+wG4IdkGJNoyIg+KBjW9U0OaayvGHB6RiR4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from VI1PR05MB4157.eurprd05.prod.outlook.com (2603:10a6:803:4d::20)
 by VI1PR05MB4542.eurprd05.prod.outlook.com (2603:10a6:802:61::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 15:26:22 +0000
Received: from VI1PR05MB4157.eurprd05.prod.outlook.com
 ([fe80::90af:a464:b72d:e314]) by VI1PR05MB4157.eurprd05.prod.outlook.com
 ([fe80::90af:a464:b72d:e314%5]) with mapi id 15.20.2937.023; Thu, 30 Apr 2020
 15:26:22 +0000
Subject: Re: [PATCH net-next 1/3] net/mlx5e: Implicitly decap the tunnel
 packet when necessary
To:     xiangxia.m.yue@gmail.com, paulb@mellanox.com, saeedm@mellanox.com,
        gerlitz.or@gmail.com
Cc:     netdev@vger.kernel.org
References: <1588051455-42828-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <0de430f3-a3a8-24d0-caf7-b6ee657c83bd@mellanox.com>
Date:   Thu, 30 Apr 2020 18:26:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <1588051455-42828-1-git-send-email-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR05CA0149.eurprd05.prod.outlook.com
 (2603:10a6:207:3::27) To VI1PR05MB4157.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.170] (176.231.113.172) by AM3PR05CA0149.eurprd05.prod.outlook.com (2603:10a6:207:3::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 15:26:21 +0000
X-Originating-IP: [176.231.113.172]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 97bdf07e-ca8d-46e6-0bbb-08d7ed1ad6ad
X-MS-TrafficTypeDiagnostic: VI1PR05MB4542:|VI1PR05MB4542:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB45427BC7D423742E55FF8FD7B5AA0@VI1PR05MB4542.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4157.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(2906002)(26005)(186003)(66476007)(4326008)(66946007)(66556008)(6486002)(2616005)(956004)(53546011)(478600001)(36756003)(8936002)(16576012)(31696002)(8676002)(316002)(31686004)(16526019)(6666004)(52116002)(5660300002)(30864003)(86362001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dKGWwgT10G9r7V7xEHgu7BYA8LUYPiL7dtakiKePOectjqzzjAnTfOCX2XsYSBJySBZj3x7IGRWmO2LwDBxA4JvTUFG4KsqriCePu7ER8gqJ6QfFle1BgqpwDvFTgMD1+vBFKiRCPX6Dyfp0cWsNEHOmf2wODO/INg6r6bzDro3b7yxRzexeKrjIZOa2S1jL47rR7FOkdWsePWxd846uuphV95lA8Woyf23v6pFiF0WvAC5i4D91onFQEO4C1oh7He4neiTmQWH34f5gWS5OdjeyEdIEUrnYGm951bJQcQmkn+qLaxjnQ1mrznYNvrET61Hf3yxTBg889liZyQYyyKvTZ85PxPmKEeP5y7Q2cOLj2fcsW2Ng9ZiThPZ3YXEOXtweq/2hkVqhbBG9pqi9btidyopo9PxdZhxDvMXb/h8VpLE6JfYQC7qZE5o5cAPPKxLDD3rHfJ4Y1SITrdMCIOO5kz+TRqA303YKB7P7Er0=
X-MS-Exchange-AntiSpam-MessageData: COgs99JSTmyVx+2hGVgubpMxiIGc0RswYZ93qkXdmu4xEe1K2B+Vi7QQBEQRQGRoyfWny1L40bhBbq7AdmVByEIpzhY+AAWLLRlk3SqmB1TCjoH6YIpZmssiKsIqlzr1a4UBB9fUYwQ7SulXkVsGpfIX5h36aZdtLa+RTPAdevVBsVXICha6eAdyr4OEiLg9U1Bp+ydQRkARCTz/knaHWO25uADR5HGAAmt0nnIZIXM3HnH0OV9Uw8E/GvKANpr0CvKiRrVFQUrb7J+QaJOUI6MJDC6Kj5eqJfowVGyEk4KGX+0HuklBUNtIzdHeUaZWGrec5wXnD4Xru2s7WVhIUyPp5RQOn05I/djiHA8o72d6Fl3+A0CgNPBHR6ERI4dBl1AUL2ysGJUJGI7rW+1Fmn7bgCCBTP6tsXeSfIYH4XhQXq4Ue7uDktsNLyAGFJHnAG6BKt0rRumPBfqTVkrzy7/eUcWxikTT1uj0mKy+Wzr2x5f68sbL9YZFonHctAgPm8kJQ3bweJQgkRkfolS2gdb+tXJj4r+ErCtGrf7F8jlM1AcqPTFDhWjpZK+2iR0EJ3CcgvHpmpdRL4h80ujNF3ZtdEVoBDV3mQejH0yx/M7W6VBBO0jTrmHgmVQ4PGAaka2PwYYD1fXRu9+RfTv/j1DBdMlMPMDaoKKHwjTKzlM6P79+7evQSYUglHURlrSxJ0p1zN6thVaz6aaMl/8QO0iuyOY0fB1tC0Rl9fXa6wWyCsds53VkkD+fw9Z3ObgcsDfiI8vyOCj/AMUEsVVla2zbhgDLJvzqOtPVJJ039os17+EgIejHZP3e2/Y7rDMa
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97bdf07e-ca8d-46e6-0bbb-08d7ed1ad6ad
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 15:26:22.4890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QDFkUki1dtrHvyL16yqhNDj61W6ZQaN5rXQmptFAfTgjAR5zyukqnwG/161RD9R3pznsNIpUn30Hl8PxSEL3bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4542
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-04-28 8:24 AM, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> The commit 0a7fcb78cc21 ("net/mlx5e: Support inner header rewrite with
> goto action"), will decapitate the tunnel packets if there is a goto
> action in chain 0. But in some case, we don't want do that, for example:

Hi Zhang,

Thanks for your commit. i'll run more tests so i might have some comments later.
Can you use decapsulate instead of decapitate please.

> 
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
> 	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789			\
> 	action goto chain 2
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower dst_mac 00:11:22:33:44:55 enc_src_ip 2.2.2.200		\
> 	enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100		\
> 	action tunnel_key unset action mirred egress redirect dev enp130s0f0_0
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower dst_mac 00:11:22:33:44:66 enc_src_ip 2.2.2.200		\
> 	enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 200		\
> 	action tunnel_key unset action mirred egress redirect dev enp130s0f0_1
> 
> In this patch, if there is a pedit action in chain, do the decapitation action.

decapsulation

> if there are pedit and goto actions, do the decapitation and id mapping action.
> 
> 8 test units:
> [1]:
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
> 	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789			\
> 	action goto chain 2
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55	\
> 	action tunnel_key unset \
> 	action mirred egress redirect dev enp130s0f0_0
> [2]:
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
> 	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100	\
> 	action goto chain 2
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55	\
> 	action pedit ex munge eth src set 00:11:22:33:44:f0		\
> 	action mirred egress redirect dev enp130s0f0_0
> [3]:
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
> 	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789 enc_key_id 100	\
> 	action goto chain 2
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55	\
> 	action tunnel_key unset \
> 	action pedit ex munge eth src set 00:11:22:33:44:f0		\
> 	action mirred egress redirect dev enp130s0f0_0
> [4]:
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
> 	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789			\
> 	enc_key_id 100 dst_mac 00:11:22:33:44:55			\
> 	action pedit ex munge eth src set 00:11:22:33:44:ff pipe	\
> 	action mirred egress redirect dev enp130s0f0_0

what about the case of only chain 0 without pedit?
I think now we skip matching tun? see comment below in parse_tunnel_attr().

> [5]:
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
> 	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55	\
> 	action pedit ex munge eth src set 00:11:22:33:44:ff		\
> 	action goto chain 2
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 src_mac 00:11:22:33:44:ff	\
> 	action tunnel_key unset	\
> 	action mirred egress redirect dev enp130s0f0_0
> [6]:
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
> 	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55	\
> 	action pedit ex munge eth src set 00:11:22:33:44:ff		\
> 	action goto chain 2
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 src_mac 00:11:22:33:44:ff	\
> 	action tunnel_key unset \
> 	action pedit ex munge eth src set 00:11:22:33:44:f0		\
> 	action mirred egress redirect dev enp130s0f0_0
> [7]:
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
> 	flower  enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55	\
> 	action pedit ex munge eth src set 00:11:22:33:44:ff		\
> 	action goto chain 2
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 src_mac 00:11:22:33:44:ff	\
> 	action pedit ex munge eth src set 00:11:22:33:44:f0		\
> 	action goto chain 3
> $ tc filter add dev vxlan0 protocol ip parent ffff: prio 1 chain 3	\
> 	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 src_mac 00:11:22:33:44:f0	\
> 	action tunnel_key unset \
> 	action pedit ex munge eth src set 00:11:22:33:44:f1		\
> 	action mirred egress redirect dev enp130s0f0_0
> [8]:
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 0	\
> 	flower enc_dst_ip 2.2.2.100 enc_dst_port 4789			\
> 	action goto chain 2
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 2	\
> 	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55	\
> 	action pedit ex munge eth src set 00:11:22:33:44:f0		\
> 	action goto chain 3
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 3	\
> 	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55	\
> 	action pedit ex munge eth src set 00:11:22:33:44:f1		\
> 	action goto chain 4
> $ tc filter add dev $VXLAN protocol ip parent ffff: prio 1 chain 4	\
> 	flower enc_src_ip 2.2.2.200 enc_dst_ip 2.2.2.100		\
> 	enc_dst_port 4789 enc_key_id 100 dst_mac 00:11:22:33:44:55	\
> 	action pedit ex munge eth src set 00:11:22:33:44:f2		\
> 	action mirred egress redirect dev enp130s0f0_0
> 
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/mapping.c   | 24 ++++++
>  .../net/ethernet/mellanox/mlx5/core/en/mapping.h   |  1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 97 +++++++++++++++-------
>  3 files changed, 92 insertions(+), 30 deletions(-)
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
> @@ -9,6 +9,7 @@
>  int mapping_add(struct mapping_ctx *ctx, void *data, u32 *id);
>  int mapping_remove(struct mapping_ctx *ctx, u32 id);
>  int mapping_find(struct mapping_ctx *ctx, u32 id, void *data);
> +int mapping_find_by_data(struct mapping_ctx *ctx, void *data, u32 *id);
>  
>  /* mapping uses an xarray to map data to ids in add(), and for find().
>   * For locking, it uses a internal xarray spin lock for add()/remove(),
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index a574c588269a..64f5c3f3dbb3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -1786,7 +1786,8 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
>  	}
>  }
>  
> -static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
> +static int flow_has_tc_action(struct flow_cls_offload *f,
> +			      enum flow_action_id action)
>  {
>  	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
>  	struct flow_action *flow_action = &rule->action;
> @@ -1794,12 +1795,8 @@ static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
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
> @@ -1853,10 +1850,37 @@ static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
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
> @@ -1876,22 +1900,7 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
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
> @@ -1915,10 +1924,10 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
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
> @@ -1941,6 +1950,25 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
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
> @@ -1976,14 +2004,22 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
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
> -	*match_inner = !needs_mapping;
> +	pedit_action = flow_has_tc_action(f, FLOW_ACTION_MANGLE) ||
> +		       flow_has_tc_action(f, FLOW_ACTION_ADD);
> +
> +	*match_inner = pedit_action;
> +	sets_mapping = pedit_action &&
> +		       flow_has_tc_action(f, FLOW_ACTION_GOTO);
> +
> +	needs_mapping = !!flow->esw_attr->chain &&
> +			!mlx5e_lookup_flow_tunnel_id(priv, flow, f,
> +						     filter_dev, NULL);
>  
>  	if ((needs_mapping || sets_mapping) &&
>  	    !mlx5_eswitch_reg_c1_loopback_enabled(esw)) {
> @@ -1994,7 +2030,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
>  		return -EOPNOTSUPP;
>  	}
>  
> -	if (!flow->esw_attr->chain) {
> +	if (*match_inner && !needs_mapping) {

why you only get inside for match_inner?
what about the case of matching tunnel on chain 0 without pedit action?
we need to call mlx5e_tc_tun_parse()

>  		err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f,
>  					 match_level);
>  		if (err) {
> @@ -2011,7 +2047,8 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
>  	if (!needs_mapping && !sets_mapping)
>  		return 0;
>  
> -	return mlx5e_get_flow_tunnel_id(priv, flow, f, filter_dev);
> +	return mlx5e_get_flow_tunnel_id(priv, flow, f, filter_dev,
> +					sets_mapping, needs_mapping);
>  }
>  
>  static void *get_match_inner_headers_criteria(struct mlx5_flow_spec *spec)
> 

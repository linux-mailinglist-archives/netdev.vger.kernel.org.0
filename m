Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159782305FA
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgG1I7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 04:59:20 -0400
Received: from mail-db8eur05on2050.outbound.protection.outlook.com ([40.107.20.50]:8245
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728195AbgG1I7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 04:59:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9aNuFsf3Fo3+Wa8ly7l0Xur2ZAtPudpisfeQbluhKndiq8BmA8eCBryunsbnpJREeaiTxaGUOqalKfWWkuYv8JTY+Q46DgEQiyB7td1J/9sTYe2AFQXodSbqKKl4mzWW0aRn8PExdn4rxgwLueUrS0ZLScRZQp0suQj7/WIg7FqmQO65NoZLtn0X2KogQl5edQxa5KETeeoeAKpMoB4S9GfBwgWZRfNz6VGSSjRzotU0Jjycbn7vhlVfhgzqXXb/jE0CWW1tsZs0XUPXNS2OI917m00RSbMvQWqYAd4Lg9hwI1WBHJE8ajVtGHYUdCkh9VqVut36445V+vscj/6Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0H9ghvCnS9dn5JNtVuvM3+A03tOJQel7+3IBseLp7PI=;
 b=OH3S5AJf1lzj5sEt/c6llBaYVEfxI9bbwPVqSLa1QLHx6VAqE/y538Y7Z9MszalfDbYnISDgE+Fd6bfqtAaCRh+fgUQ8+RS6xkbfXmsQNHI1nPPAXcFe3jMmROrJEzH/EibFZrxuEg5ET1VVikrZ3nst+kocqS+Vlfy6v3hun8lURDystyJBdK2AMB/0p7ocM0asLhJGwWur98mKKQJVHkH9VoJtp0cwjSpZ7z9rhDryWglnV/EP66BaRcejvi0++fbsb3b7C9OmEFdzc0s8jdUvojNkzqYikzjifehXG/pSxk6QaTkK0lTxjAg4UZD8vhanr/y0aiH+czD9u0vq9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0H9ghvCnS9dn5JNtVuvM3+A03tOJQel7+3IBseLp7PI=;
 b=LvD/e1xkJBTYqmTcAYIES8SPMHwFYa7F1jrKJ+7VQLcNlf9wVbRs9/odm0M7P9KYIGpRs/xqY6NbkaE6xLi2LeNeQJmUxs8mlbkAvLiD4nXFJn2xGh/D0jdDa52JhPtIPkMZJTU6sP+CgmYE7ebXfjPJYOTW4eeCEHAHULN6smo=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM7PR05MB6867.eurprd05.prod.outlook.com (2603:10a6:20b:1aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 08:59:13 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3239.016; Tue, 28 Jul 2020
 08:59:13 +0000
Subject: Re: [PATCH bpf-next v4 08/14] xsk: enable sharing of dma mappings
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
References: <1595307848-20719-1-git-send-email-magnus.karlsson@intel.com>
 <1595307848-20719-9-git-send-email-magnus.karlsson@intel.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <11a4e8cb-1c88-ada8-7534-8f32d16e729d@mellanox.com>
Date:   Tue, 28 Jul 2020 11:59:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1595307848-20719-9-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0034.eurprd03.prod.outlook.com
 (2603:10a6:208:14::47) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.57.1.235] (159.224.90.213) by AM0PR03CA0034.eurprd03.prod.outlook.com (2603:10a6:208:14::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 08:59:11 +0000
X-Originating-IP: [159.224.90.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 570a2697-76a8-4389-3fcc-08d832d47f9f
X-MS-TrafficTypeDiagnostic: AM7PR05MB6867:
X-Microsoft-Antispam-PRVS: <AM7PR05MB68674D8CEDEE4F211D139690D1730@AM7PR05MB6867.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p9rM+eGn/iQrxy8Jkf4TxLaeXkYL2j+d5NIgMx+AJPLe1UCNP4/GKXUiCw33wpV0ggKNYVz9tF92DuO+SCA/kdl05HpFG51i76pYNnthVMvgP/CnTtY93X3xtiolWf3kndlhzIOgP+VBRwsIT3HHvdWUZK/S3w1wBxbnsNVUHPbh2BO2q6JCgo9pIUwT2jf8ZL9Ayf24olIpROElqLIEZX1Eg+aNTC5RGesVuvycD8mKv8GIjHO6GEVnLV5G4FmcGQNZrgzvnDVAiNDEyV8DyrcIBNKcEux3eD1sIqqxfje31cUOrZiH+JtE8+VcDgHlLUtngx9i7Bua2RIVGleazvYRikXh9DIFRrKFLv77wfNOoy4t8JndU1jnI7kkCigx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(2906002)(66946007)(4326008)(36756003)(66476007)(8676002)(5660300002)(31686004)(6666004)(66556008)(8936002)(956004)(2616005)(53546011)(31696002)(7416002)(26005)(6916009)(83380400001)(16526019)(55236004)(186003)(478600001)(6486002)(316002)(86362001)(16576012)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kQvbwW+Qs/FOGtDm/ExjLHxj1EJyoFlnmSmoYzUn2siFk/a/ZGdjdnl3Y4kxSsaPbtYShlAAfsUe955Oj6sp6HA/q1PNrBWj7z2ULBwgHBKwMxdMRQCQRtouWR5EfmPd3Nok1lgHoe++R/cowDw7iDcl0kvjH8zfwHJ0cPNVMPdZm4mePauuua40p5UPTkXEkuSi29jb7MZrN3g6VxHwyR8dJCl67JvmEmzxBIaxhNu61+Ph4JdSKhXJKejftzbabhYrfC1HAQebqIWXmJQFntBMBstlwc2cT+zqznAMw9Ujv5FNcKFENuOr5oiktVTZg1jleWN9nZA0vkfKi1RKgN+ZGNCOXlfecQIWqiFMBR8okdNOPOHwJSiPlK3FJmtFiiQNuVwYUtdPfuTioNojIxdiHLSweUffIzIvACaONEWwOIanJXA4Mv7B5gU7GJpSCirMD5ZZyTOEHOwRdy8raIihDWhGo04giajZdKwBPoPFFdKgYoXp3KxoSnhZ/XuL
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 570a2697-76a8-4389-3fcc-08d832d47f9f
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 08:59:13.2331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GmaxJKHTohzjq4QlMjayOVGlKh2+w59H4+hAqdvKKLgFUWMWVEFEslfQ1QLAfBazKcJeVxHXktZ3qvbj41FEkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6867
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-21 08:04, Magnus Karlsson wrote:
> Enable the sharing of dma mappings by moving them out from the buffer
> pool. Instead we put each dma mapped umem region in a list in the umem
> structure. If dma has already been mapped for this umem and device, it
> is not mapped again and the existing dma mappings are reused.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   include/net/xdp_sock.h      |   1 +
>   include/net/xsk_buff_pool.h |   7 +++
>   net/xdp/xdp_umem.c          |   1 +
>   net/xdp/xsk_buff_pool.c     | 112 ++++++++++++++++++++++++++++++++++++--------
>   4 files changed, 102 insertions(+), 19 deletions(-)
> 
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index 126d243..282aeba 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -30,6 +30,7 @@ struct xdp_umem {
>   	u8 flags;
>   	int id;
>   	bool zc;
> +	struct list_head xsk_dma_list;
>   };
>   
>   struct xsk_map {
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 83f100c..8f1dc4c 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -28,6 +28,13 @@ struct xdp_buff_xsk {
>   	struct list_head free_list_node;
>   };
>   
> +struct xsk_dma_map {
> +	dma_addr_t *dma_pages;
> +	struct net_device *dev;
> +	refcount_t users;
> +	struct list_head list; /* Protected by the RTNL_LOCK */
> +};
> +
>   struct xsk_buff_pool {
>   	struct xsk_queue *fq;
>   	struct xsk_queue *cq;
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 372998d..cf27249 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -199,6 +199,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>   	umem->user = NULL;
>   	umem->flags = mr->flags;
>   
> +	INIT_LIST_HEAD(&umem->xsk_dma_list);
>   	refcount_set(&umem->users, 1);
>   
>   	err = xdp_umem_account_pages(umem);
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index c563874..ca74a3e 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -104,6 +104,25 @@ void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
>   }
>   EXPORT_SYMBOL(xp_set_rxq_info);
>   
> +static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
> +{
> +	struct netdev_bpf bpf;
> +	int err;
> +
> +	ASSERT_RTNL();
> +
> +	if (pool->umem->zc) {
> +		bpf.command = XDP_SETUP_XSK_POOL;
> +		bpf.xsk.pool = NULL;
> +		bpf.xsk.queue_id = pool->queue_id;
> +
> +		err = pool->netdev->netdev_ops->ndo_bpf(pool->netdev, &bpf);
> +
> +		if (err)
> +			WARN(1, "Failed to disable zero-copy!\n");
> +	}
> +}
> +
>   int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
>   		  u16 queue_id, u16 flags)
>   {
> @@ -122,6 +141,8 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
>   	if (xsk_get_pool_from_qid(netdev, queue_id))
>   		return -EBUSY;
>   
> +	pool->netdev = netdev;
> +	pool->queue_id = queue_id;
>   	err = xsk_reg_pool_at_qid(netdev, pool, queue_id);
>   	if (err)
>   		return err;
> @@ -155,11 +176,15 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
>   	if (err)
>   		goto err_unreg_pool;
>   
> -	pool->netdev = netdev;
> -	pool->queue_id = queue_id;
> +	if (!pool->dma_pages) {
> +		WARN(1, "Driver did not DMA map zero-copy buffers");
> +		goto err_unreg_xsk;
> +	}
>   	pool->umem->zc = true;
>   	return 0;
>   
> +err_unreg_xsk:
> +	xp_disable_drv_zc(pool);
>   err_unreg_pool:
>   	if (!force_zc)
>   		err = 0; /* fallback to copy mode */
> @@ -170,25 +195,10 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
>   
>   void xp_clear_dev(struct xsk_buff_pool *pool)
>   {
> -	struct netdev_bpf bpf;
> -	int err;
> -
> -	ASSERT_RTNL();
> -
>   	if (!pool->netdev)
>   		return;
>   
> -	if (pool->umem->zc) {
> -		bpf.command = XDP_SETUP_XSK_POOL;
> -		bpf.xsk.pool = NULL;
> -		bpf.xsk.queue_id = pool->queue_id;
> -
> -		err = pool->netdev->netdev_ops->ndo_bpf(pool->netdev, &bpf);
> -
> -		if (err)
> -			WARN(1, "Failed to disable zero-copy!\n");
> -	}
> -
> +	xp_disable_drv_zc(pool);
>   	xsk_clear_pool_at_qid(pool->netdev, pool->queue_id);
>   	dev_put(pool->netdev);
>   	pool->netdev = NULL;
> @@ -233,14 +243,61 @@ void xp_put_pool(struct xsk_buff_pool *pool)
>   	}
>   }
>   
> +static struct xsk_dma_map *xp_find_dma_map(struct xsk_buff_pool *pool)
> +{
> +	struct xsk_dma_map *dma_map;
> +
> +	list_for_each_entry(dma_map, &pool->umem->xsk_dma_list, list) {
> +		if (dma_map->dev == pool->netdev)
> +			return dma_map;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void xp_destroy_dma_map(struct xsk_dma_map *dma_map)
> +{
> +	list_del(&dma_map->list);
> +	kfree(dma_map);
> +}
> +
> +static void xp_put_dma_map(struct xsk_dma_map *dma_map)
> +{
> +	if (!refcount_dec_and_test(&dma_map->users))
> +		return;
> +
> +	xp_destroy_dma_map(dma_map);
> +}
> +
> +static struct xsk_dma_map *xp_create_dma_map(struct xsk_buff_pool *pool)
> +{
> +	struct xsk_dma_map *dma_map;
> +
> +	dma_map = kzalloc(sizeof(*dma_map), GFP_KERNEL);
> +	if (!dma_map)
> +		return NULL;
> +
> +	dma_map->dev = pool->netdev;
> +	refcount_set(&dma_map->users, 1);
> +	list_add(&dma_map->list, &pool->umem->xsk_dma_list);
> +	return dma_map;
> +}
> +
>   void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
>   {
> +	struct xsk_dma_map *dma_map;
>   	dma_addr_t *dma;
>   	u32 i;
>   
>   	if (pool->dma_pages_cnt == 0)
>   		return;
>   
> +	dma_map = xp_find_dma_map(pool);
> +	if (!dma_map) {
> +		WARN(1, "Could not find dma_map for device");
> +		return;
> +	}
> +
>   	for (i = 0; i < pool->dma_pages_cnt; i++) {
>   		dma = &pool->dma_pages[i];
>   		if (*dma) {
> @@ -250,6 +307,7 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
>   		}
>   	}
>   
> +	xp_put_dma_map(dma_map);

I believe that the logic in this function is not correct. Basically, the 
driver calls xp_dma_[un]map when a socket is enabled/disabled on a given 
queue of a given netdev. On xp_dma_map, if the UMEM is already mapped 
for that netdev, we skip all the logic, but on xp_dma_unmap you unmap 
the pages unconditionally, only after that you check the refcount. This 
is not symmetric, and the pages will be unmapped when the first socket 
is closed, rendering the rest of sockets unusable.

>   	kvfree(pool->dma_pages);
>   	pool->dma_pages_cnt = 0;
>   	pool->dev = NULL;
> @@ -271,14 +329,29 @@ static void xp_check_dma_contiguity(struct xsk_buff_pool *pool)
>   int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
>   	       unsigned long attrs, struct page **pages, u32 nr_pages)
>   {
> +	struct xsk_dma_map *dma_map;
>   	dma_addr_t dma;
>   	u32 i;
>   
> +	dma_map = xp_find_dma_map(pool);
> +	if (dma_map) {
> +		pool->dma_pages = dma_map->dma_pages;
> +		refcount_inc(&dma_map->users);
> +		return 0;
> +	}
> +
> +	dma_map = xp_create_dma_map(pool);
> +	if (!dma_map)
> +		return -ENOMEM;
> +
>   	pool->dma_pages = kvcalloc(nr_pages, sizeof(*pool->dma_pages),
>   				   GFP_KERNEL);
> -	if (!pool->dma_pages)
> +	if (!pool->dma_pages) {
> +		xp_destroy_dma_map(dma_map);
>   		return -ENOMEM;
> +	}
>   
> +	dma_map->dma_pages = pool->dma_pages;
>   	pool->dev = dev;
>   	pool->dma_pages_cnt = nr_pages;
>   	pool->dma_need_sync = false;
> @@ -288,6 +361,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
>   					 DMA_BIDIRECTIONAL, attrs);
>   		if (dma_mapping_error(dev, dma)) {
>   			xp_dma_unmap(pool, attrs);
> +			xp_destroy_dma_map(dma_map);
>   			return -ENOMEM;
>   		}
>   		if (dma_need_sync(dev, dma))
> 


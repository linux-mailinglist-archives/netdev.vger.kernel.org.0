Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52892218AA0
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbgGHPAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:00:53 -0400
Received: from mail-eopbgr20061.outbound.protection.outlook.com ([40.107.2.61]:16438
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729880AbgGHPAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 11:00:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d5wkSOdOUCwIi5GwpFnXr7zhx6GaZiu+mlATFsmMLLsz9O6m4azE0hHC6FzRRxCp/T+LBqckHk6Nxd3HeSkilk5la2ebunolfNRWhBxP18ddsZ/QzFAmRKuEhXGenACgUOwtlNeCkaXiOkaeppnEMmUanmBcIh9HfqG4hH4a5dcV/RHiZvL13k1BZARuIi8yAcLWa9YyDOayv4D+20mjW9bfqoyPQK4e1/bNs+sn7x/ONTkld0qYZ8z7MHU2KoBtz6ovizYAMOXzXjWCSW47bRS2PmJEJakXhZxYaD7MzBlZXpWXVGyQOUnVcE/KfjSySZ0knnsq332oiBkE79RpUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5d3RT7UJ0eBz/DKEDUjjNzKRP36Bp1c8Zzdd+fvXRxw=;
 b=KuF8qETfkoIUQz1u0wj2YG+eKL7fCqye6lRAUvekiGzEGU2jcfPZOFUHGca3gR6xTANrYmw11KBM2A5Wph6LVXUYvLGnDcoWHw0MfO1V/NetLr76l76JP8lVRu1GWNa5zEcmKCnaEOjNmRg6k0Jnp9BXcQcOmPyPRNf2eE/xrfQRxgokxVGt6NJo51zECVbsqbBx4eCoUSl1sag4d8UWQgMGKXgDrlG23vu7kVqAKFY/88S7ij8y1Gx+dEYIPtoSy2Vt3kAPw9tjuMM+8LzoQtggsACBt9hatlEtj6+Bf9jlS1jIpJpJVpLLi9eVk0Wnn/3zXRXoVFh8fxv6CB/kSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5d3RT7UJ0eBz/DKEDUjjNzKRP36Bp1c8Zzdd+fvXRxw=;
 b=FAl8VcQUm7weLKStNIKGyrQPWiIbrdfc5SceTAwhsspFCD9nvj7YLtTDHgepOjf+xzeUaxzTladZ0rOEiYtONf+ijSFXHPSoJpsWXfS1Cm9of4JKXI/SE5mmZALd0roCZTVhWE/4OA6UDkq9I4s8Q60gNOwNvTqlW+edH/T+N0E=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB4471.eurprd05.prod.outlook.com (2603:10a6:209:44::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Wed, 8 Jul
 2020 15:00:42 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2%7]) with mapi id 15.20.3153.029; Wed, 8 Jul 2020
 15:00:42 +0000
Subject: Re: [PATCH bpf-next 03/14] xsk: create and free context independently
 from umem
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
 <1593692353-15102-4-git-send-email-magnus.karlsson@intel.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <2aa643d2-5cef-bab5-d399-4d5330eb7a21@mellanox.com>
Date:   Wed, 8 Jul 2020 18:00:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1593692353-15102-4-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR08CA0027.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::40) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.44.1.235] (37.57.128.233) by AM0PR08CA0027.eurprd08.prod.outlook.com (2603:10a6:208:d2::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Wed, 8 Jul 2020 15:00:41 +0000
X-Originating-IP: [37.57.128.233]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f9964d9c-6e80-427f-47f9-08d8234faf22
X-MS-TrafficTypeDiagnostic: AM6PR05MB4471:
X-Microsoft-Antispam-PRVS: <AM6PR05MB447156F73EF948FD8D71FE4DD1670@AM6PR05MB4471.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RAv9jpsWQ40ljp9uC/NNbW3rfTnQdlzl0a2Qg69/41+EDd3neELZyfJeXxwFdOJNomSeMuESItB5TSYElhqS7hk75GB+5KA4SdTr69zQDd3jEGNIIdl6e5m9Uts6+7eOEZro2E9e1/Dj9tFx66+TKYVSDcUtHQDI22cIi/p9I2irwAitbDvqPTspI123mgcm1xdewfeQtyAAVp8TmG0sye/wxYaFmhfPJql1Q7Z+XLNLYCQovihP3yTC+zrmko/2/3BQzJ/LdQheIjyj0mDGwX2woduMRriU9NCt/oXcrY4hKRFzh5eSQ2jtFsj+HxgEHkRHpCZZZP/iCZ6dOvd00ECv+lCWQo2FqGeJSzW9LvZB/+hV11g3c6NCM0s1pdau
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(66476007)(2906002)(86362001)(66946007)(31696002)(6486002)(31686004)(16576012)(316002)(83380400001)(2616005)(36756003)(8936002)(8676002)(956004)(4326008)(66556008)(6666004)(478600001)(5660300002)(55236004)(53546011)(6916009)(52116002)(186003)(16526019)(30864003)(26005)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: x/Fj+3TgB0YRXAF8OoeeEFof6/VhpI0NXNWke8XFwblgPEfp/cQ5pmJ1GSHWALYvsX+eYvC97mZdVdBS0cuQSF1st8HRn9ggtqIpb/8/QG9m79yu7U/S8p/GEloncQ7pWvehOygFyypgpBLNt9kBKueXuBUxUvN0XVM/LCPWnyVcFH1p5mtuVEmyMo9HvEY842JXbMraNEN/Q2SNI++PqwGvd2ubFZR4FSjAPt/GmICcKiE4fC6bah6B10b2GyoibpCGgfnrXWtPLwEy+Uc8u8NHoDFoJmwhxNirnMdBLOf6ZgsDDKBDTzNs4RW6qpTLEsjz2emUGo9bRpueBsBo8bCvncrpfU8aDIq9X8z8vr/ZrPrGG2xhv9EmRzfhpNQI1KRpXX6KgrB3StVCz3l1NQJ7AhtiZ/DaQTMEVTZH63WfA37FdQYOnh1EHYocHcH2VToMrCWtvpCMHTiegEVDrAu58XhqqVVfWJiQfHapwL4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9964d9c-6e80-427f-47f9-08d8234faf22
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 15:00:42.2701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hk8/7ufhuOrKDtcLHgkWUG9c4NR6bofS1ZUNKMbItgW6LEOoSqu4aG2xJZhJwLwQlQUhSOz/ydwuJJpZEMKIaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4471
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-02 15:19, Magnus Karlsson wrote:
> Create and free the buffer pool independently from the umem. Move
> these operations that are performed on the buffer pool from the
> umem create and destroy functions to new create and destroy
> functions just for the buffer pool. This so that in later commits
> we can instantiate multiple buffer pools per umem when sharing a
> umem between HW queues and/or devices. We also erradicate the
> back pointer from the umem to the buffer pool as this will not
> work when we introduce the possibility to have multiple buffer
> pools per umem.
> 
> It might seem a bit odd that we create an empty buffer pool first
> and then recreate it with its right size when we bind to a device
> and umem. But the page pool will in later commits be used to
> carry information before it has been assigned to a umem and its
> size decided.

What kind of information? I'm looking at the final code: on socket 
creation you just fill the pool with zeros, then we may have setsockopt 
for FQ and CQ, then xsk_bind replaces the pool with the real one. So the 
only information carried from the old pool to the new one is FQ and CQ, 
or did I miss anything?

I don't quite like this design, it's kind of a hack to support the 
initialization order that we have, but it complicates things: when you 
copy the old pool into the new one, it's not clear which fields we care 
about, and which are ignored/overwritten.

Regarding FQ and CQ, for shared UMEM, they won't be filled, so there is 
no point in the temporary pool in this case (unless it also stores 
something that I missed).

I suggest to add a pointer to some kind of a configuration struct to xs. 
All things configured with setsockopt go to that struct. xsk_bind will 
call a function to validate the config struct, and if it's OK, it will 
create the pool (once), fill the fields and free the config struct. 
Config struct can be a union with the pool to save space in xs. Probably 
we will also be able to drop a few fields from xs (such as umem?). How 
do you feel about this idea?

> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   include/net/xdp_sock.h      |   3 +-
>   include/net/xsk_buff_pool.h |  14 +++-
>   net/xdp/xdp_umem.c          | 164 ++++----------------------------------------
>   net/xdp/xdp_umem.h          |   4 +-
>   net/xdp/xsk.c               |  83 +++++++++++++++++++---
>   net/xdp/xsk.h               |   3 +
>   net/xdp/xsk_buff_pool.c     | 154 +++++++++++++++++++++++++++++++++++++----
>   net/xdp/xsk_queue.h         |  12 ++--
>   8 files changed, 250 insertions(+), 187 deletions(-)
> 
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index 6eb9628..b9bb118 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -20,13 +20,12 @@ struct xdp_buff;
>   struct xdp_umem {
>   	struct xsk_queue *fq;
>   	struct xsk_queue *cq;
> -	struct xsk_buff_pool *pool;
>   	u64 size;
>   	u32 headroom;
>   	u32 chunk_size;
> +	u32 chunks;
>   	struct user_struct *user;
>   	refcount_t users;
> -	struct work_struct work;
>   	struct page **pgs;
>   	u32 npgs;
>   	u16 queue_id;
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index a6dec9c..cda8ced 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -14,6 +14,7 @@ struct xdp_rxq_info;
>   struct xsk_queue;
>   struct xdp_desc;
>   struct xdp_umem;
> +struct xdp_sock;
>   struct device;
>   struct page;
>   
> @@ -46,16 +47,23 @@ struct xsk_buff_pool {
>   	struct xdp_umem *umem;
>   	void *addrs;
>   	struct device *dev;
> +	refcount_t users;
> +	struct work_struct work;
>   	struct xdp_buff_xsk *free_heads[];
>   };
>   
>   /* AF_XDP core. */
> -struct xsk_buff_pool *xp_create(struct xdp_umem *umem, u32 chunks,
> -				u32 chunk_size, u32 headroom, u64 size,
> -				bool unaligned);
> +struct xsk_buff_pool *xp_create(void);
> +struct xsk_buff_pool *xp_assign_umem(struct xsk_buff_pool *pool,
> +				     struct xdp_umem *umem);
> +int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
> +		  struct net_device *dev, u16 queue_id, u16 flags);
>   void xp_set_fq(struct xsk_buff_pool *pool, struct xsk_queue *fq);
>   void xp_destroy(struct xsk_buff_pool *pool);
>   void xp_release(struct xdp_buff_xsk *xskb);
> +void xp_get_pool(struct xsk_buff_pool *pool);
> +void xp_put_pool(struct xsk_buff_pool *pool);
> +void xp_clear_dev(struct xsk_buff_pool *pool);
>   
>   /* AF_XDP, and XDP core. */
>   void xp_free(struct xdp_buff_xsk *xskb);
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index adde4d5..f290345 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -47,160 +47,41 @@ void xdp_del_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
>   	spin_unlock_irqrestore(&umem->xsk_tx_list_lock, flags);
>   }
>   
> -/* The umem is stored both in the _rx struct and the _tx struct as we do
> - * not know if the device has more tx queues than rx, or the opposite.
> - * This might also change during run time.
> - */
> -static int xsk_reg_pool_at_qid(struct net_device *dev,
> -			       struct xsk_buff_pool *pool,
> -			       u16 queue_id)
> -{
> -	if (queue_id >= max_t(unsigned int,
> -			      dev->real_num_rx_queues,
> -			      dev->real_num_tx_queues))
> -		return -EINVAL;
> -
> -	if (queue_id < dev->real_num_rx_queues)
> -		dev->_rx[queue_id].pool = pool;
> -	if (queue_id < dev->real_num_tx_queues)
> -		dev->_tx[queue_id].pool = pool;
> -
> -	return 0;
> -}
> -
> -struct xsk_buff_pool *xsk_get_pool_from_qid(struct net_device *dev,
> -					    u16 queue_id)
> +static void xdp_umem_unpin_pages(struct xdp_umem *umem)
>   {
> -	if (queue_id < dev->real_num_rx_queues)
> -		return dev->_rx[queue_id].pool;
> -	if (queue_id < dev->real_num_tx_queues)
> -		return dev->_tx[queue_id].pool;
> +	unpin_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
>   
> -	return NULL;
> +	kfree(umem->pgs);
> +	umem->pgs = NULL;
>   }
> -EXPORT_SYMBOL(xsk_get_pool_from_qid);
>   
> -static void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id)
> +static void xdp_umem_unaccount_pages(struct xdp_umem *umem)
>   {
> -	if (queue_id < dev->real_num_rx_queues)
> -		dev->_rx[queue_id].pool = NULL;
> -	if (queue_id < dev->real_num_tx_queues)
> -		dev->_tx[queue_id].pool = NULL;
> +	if (umem->user) {
> +		atomic_long_sub(umem->npgs, &umem->user->locked_vm);
> +		free_uid(umem->user);
> +	}
>   }
>   
> -int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
> -			u16 queue_id, u16 flags)
> +void xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
> +			 u16 queue_id)
>   {
> -	bool force_zc, force_copy;
> -	struct netdev_bpf bpf;
> -	int err = 0;
> -
> -	ASSERT_RTNL();
> -
> -	force_zc = flags & XDP_ZEROCOPY;
> -	force_copy = flags & XDP_COPY;
> -
> -	if (force_zc && force_copy)
> -		return -EINVAL;
> -
> -	if (xsk_get_pool_from_qid(dev, queue_id))
> -		return -EBUSY;
> -
> -	err = xsk_reg_pool_at_qid(dev, umem->pool, queue_id);
> -	if (err)
> -		return err;
> -
>   	umem->dev = dev;
>   	umem->queue_id = queue_id;
>   
> -	if (flags & XDP_USE_NEED_WAKEUP) {
> -		umem->flags |= XDP_UMEM_USES_NEED_WAKEUP;
> -		/* Tx needs to be explicitly woken up the first time.
> -		 * Also for supporting drivers that do not implement this
> -		 * feature. They will always have to call sendto().
> -		 */
> -		xsk_set_tx_need_wakeup(umem->pool);
> -	}
> -
>   	dev_hold(dev);
> -
> -	if (force_copy)
> -		/* For copy-mode, we are done. */
> -		return 0;
> -
> -	if (!dev->netdev_ops->ndo_bpf || !dev->netdev_ops->ndo_xsk_wakeup) {
> -		err = -EOPNOTSUPP;
> -		goto err_unreg_umem;
> -	}
> -
> -	bpf.command = XDP_SETUP_XSK_POOL;
> -	bpf.xsk.pool = umem->pool;
> -	bpf.xsk.queue_id = queue_id;
> -
> -	err = dev->netdev_ops->ndo_bpf(dev, &bpf);
> -	if (err)
> -		goto err_unreg_umem;
> -
> -	umem->zc = true;
> -	return 0;
> -
> -err_unreg_umem:
> -	if (!force_zc)
> -		err = 0; /* fallback to copy mode */
> -	if (err)
> -		xsk_clear_pool_at_qid(dev, queue_id);
> -	return err;
>   }
>   
>   void xdp_umem_clear_dev(struct xdp_umem *umem)
>   {
> -	struct netdev_bpf bpf;
> -	int err;
> -
> -	ASSERT_RTNL();
> -
> -	if (!umem->dev)
> -		return;
> -
> -	if (umem->zc) {
> -		bpf.command = XDP_SETUP_XSK_POOL;
> -		bpf.xsk.pool = NULL;
> -		bpf.xsk.queue_id = umem->queue_id;
> -
> -		err = umem->dev->netdev_ops->ndo_bpf(umem->dev, &bpf);
> -
> -		if (err)
> -			WARN(1, "failed to disable umem!\n");
> -	}
> -
> -	xsk_clear_pool_at_qid(umem->dev, umem->queue_id);
> -
>   	dev_put(umem->dev);
>   	umem->dev = NULL;
>   	umem->zc = false;
>   }
>   
> -static void xdp_umem_unpin_pages(struct xdp_umem *umem)
> -{
> -	unpin_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
> -
> -	kfree(umem->pgs);
> -	umem->pgs = NULL;
> -}
> -
> -static void xdp_umem_unaccount_pages(struct xdp_umem *umem)
> -{
> -	if (umem->user) {
> -		atomic_long_sub(umem->npgs, &umem->user->locked_vm);
> -		free_uid(umem->user);
> -	}
> -}
> -
>   static void xdp_umem_release(struct xdp_umem *umem)
>   {
> -	rtnl_lock();
>   	xdp_umem_clear_dev(umem);
> -	rtnl_unlock();
>   
>   	ida_simple_remove(&umem_ida, umem->id);
>   
> @@ -214,20 +95,12 @@ static void xdp_umem_release(struct xdp_umem *umem)
>   		umem->cq = NULL;
>   	}
>   
> -	xp_destroy(umem->pool);
>   	xdp_umem_unpin_pages(umem);
>   
>   	xdp_umem_unaccount_pages(umem);
>   	kfree(umem);
>   }
>   
> -static void xdp_umem_release_deferred(struct work_struct *work)
> -{
> -	struct xdp_umem *umem = container_of(work, struct xdp_umem, work);
> -
> -	xdp_umem_release(umem);
> -}
> -
>   void xdp_get_umem(struct xdp_umem *umem)
>   {
>   	refcount_inc(&umem->users);
> @@ -238,10 +111,8 @@ void xdp_put_umem(struct xdp_umem *umem)
>   	if (!umem)
>   		return;
>   
> -	if (refcount_dec_and_test(&umem->users)) {
> -		INIT_WORK(&umem->work, xdp_umem_release_deferred);
> -		schedule_work(&umem->work);
> -	}
> +	if (refcount_dec_and_test(&umem->users))
> +		xdp_umem_release(umem);
>   }
>   
>   static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
> @@ -357,6 +228,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>   	umem->size = size;
>   	umem->headroom = headroom;
>   	umem->chunk_size = chunk_size;
> +	umem->chunks = chunks;
>   	umem->npgs = (u32)npgs;
>   	umem->pgs = NULL;
>   	umem->user = NULL;
> @@ -374,16 +246,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>   	if (err)
>   		goto out_account;
>   
> -	umem->pool = xp_create(umem, chunks, chunk_size, headroom, size,
> -			       unaligned_chunks);
> -	if (!umem->pool) {
> -		err = -ENOMEM;
> -		goto out_pin;
> -	}
>   	return 0;
>   
> -out_pin:
> -	xdp_umem_unpin_pages(umem);
>   out_account:
>   	xdp_umem_unaccount_pages(umem);
>   	return err;
> diff --git a/net/xdp/xdp_umem.h b/net/xdp/xdp_umem.h
> index 32067fe..93e96be 100644
> --- a/net/xdp/xdp_umem.h
> +++ b/net/xdp/xdp_umem.h
> @@ -8,8 +8,8 @@
>   
>   #include <net/xdp_sock_drv.h>
>   
> -int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
> -			u16 queue_id, u16 flags);
> +void xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
> +			 u16 queue_id);
>   void xdp_umem_clear_dev(struct xdp_umem *umem);
>   bool xdp_umem_validate_queues(struct xdp_umem *umem);
>   void xdp_get_umem(struct xdp_umem *umem);
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 7551f5b..b12a832 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -105,6 +105,46 @@ bool xsk_uses_need_wakeup(struct xsk_buff_pool *pool)
>   }
>   EXPORT_SYMBOL(xsk_uses_need_wakeup);
>   
> +struct xsk_buff_pool *xsk_get_pool_from_qid(struct net_device *dev,
> +					    u16 queue_id)
> +{
> +	if (queue_id < dev->real_num_rx_queues)
> +		return dev->_rx[queue_id].pool;
> +	if (queue_id < dev->real_num_tx_queues)
> +		return dev->_tx[queue_id].pool;
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL(xsk_get_pool_from_qid);
> +
> +void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id)
> +{
> +	if (queue_id < dev->real_num_rx_queues)
> +		dev->_rx[queue_id].pool = NULL;
> +	if (queue_id < dev->real_num_tx_queues)
> +		dev->_tx[queue_id].pool = NULL;
> +}
> +
> +/* The buffer pool is stored both in the _rx struct and the _tx struct as we do
> + * not know if the device has more tx queues than rx, or the opposite.
> + * This might also change during run time.
> + */
> +int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
> +			u16 queue_id)
> +{
> +	if (queue_id >= max_t(unsigned int,
> +			      dev->real_num_rx_queues,
> +			      dev->real_num_tx_queues))
> +		return -EINVAL;
> +
> +	if (queue_id < dev->real_num_rx_queues)
> +		dev->_rx[queue_id].pool = pool;
> +	if (queue_id < dev->real_num_tx_queues)
> +		dev->_tx[queue_id].pool = pool;
> +
> +	return 0;
> +}
> +
>   void xp_release(struct xdp_buff_xsk *xskb)
>   {
>   	xskb->pool->free_heads[xskb->pool->free_heads_cnt++] = xskb;
> @@ -281,7 +321,7 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
>   
>   	rcu_read_lock();
>   	list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
> -		if (!xskq_cons_peek_desc(xs->tx, desc, umem))
> +		if (!xskq_cons_peek_desc(xs->tx, desc, pool))
>   			continue;
>   
>   		/* This is the backpressure mechanism for the Tx path.
> @@ -347,7 +387,7 @@ static int xsk_generic_xmit(struct sock *sk)
>   	if (xs->queue_id >= xs->dev->real_num_tx_queues)
>   		goto out;
>   
> -	while (xskq_cons_peek_desc(xs->tx, &desc, xs->umem)) {
> +	while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
>   		char *buffer;
>   		u64 addr;
>   		u32 len;
> @@ -629,6 +669,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   	qid = sxdp->sxdp_queue_id;
>   
>   	if (flags & XDP_SHARED_UMEM) {
> +		struct xsk_buff_pool *curr_pool;
>   		struct xdp_sock *umem_xs;
>   		struct socket *sock;
>   
> @@ -663,6 +704,11 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   			goto out_unlock;
>   		}
>   
> +		/* Share the buffer pool with the other socket. */
> +		xp_get_pool(umem_xs->pool);
> +		curr_pool = xs->pool;
> +		xs->pool = umem_xs->pool;
> +		xp_destroy(curr_pool);
>   		xdp_get_umem(umem_xs->umem);
>   		WRITE_ONCE(xs->umem, umem_xs->umem);
>   		sockfd_put(sock);
> @@ -670,10 +716,24 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   		err = -EINVAL;
>   		goto out_unlock;
>   	} else {
> +		struct xsk_buff_pool *new_pool;
> +
>   		/* This xsk has its own umem. */
> -		err = xdp_umem_assign_dev(xs->umem, dev, qid, flags);
> -		if (err)
> +		xdp_umem_assign_dev(xs->umem, dev, qid);
> +		new_pool = xp_assign_umem(xs->pool, xs->umem);

It looks like the old pool (xs->pool) is never freed.

> +		if (!new_pool) {
> +			err = -ENOMEM;
> +			xdp_umem_clear_dev(xs->umem);
> +			goto out_unlock;
> +		}
> +
> +		err = xp_assign_dev(new_pool, xs, dev, qid, flags);
> +		if (err) {
> +			xp_destroy(new_pool);
> +			xdp_umem_clear_dev(xs->umem);
>   			goto out_unlock;
> +		}
> +		xs->pool = new_pool;
>   	}
>   
>   	xs->dev = dev;
> @@ -765,8 +825,6 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
>   			return PTR_ERR(umem);
>   		}
>   
> -		xs->pool = umem->pool;
> -
>   		/* Make sure umem is ready before it can be seen by others */
>   		smp_wmb();
>   		WRITE_ONCE(xs->umem, umem);
> @@ -796,7 +854,7 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
>   			&xs->umem->cq;
>   		err = xsk_init_queue(entries, q, true);
>   		if (optname == XDP_UMEM_FILL_RING)
> -			xp_set_fq(xs->umem->pool, *q);
> +			xp_set_fq(xs->pool, *q);
>   		mutex_unlock(&xs->mutex);
>   		return err;
>   	}
> @@ -1002,7 +1060,8 @@ static int xsk_notifier(struct notifier_block *this,
>   
>   				xsk_unbind_dev(xs);
>   
> -				/* Clear device references in umem. */
> +				/* Clear device references. */
> +				xp_clear_dev(xs->pool);
>   				xdp_umem_clear_dev(xs->umem);
>   			}
>   			mutex_unlock(&xs->mutex);
> @@ -1047,7 +1106,7 @@ static void xsk_destruct(struct sock *sk)
>   	if (!sock_flag(sk, SOCK_DEAD))
>   		return;
>   
> -	xdp_put_umem(xs->umem);
> +	xp_put_pool(xs->pool);
>   
>   	sk_refcnt_debug_dec(sk);
>   }
> @@ -1055,8 +1114,8 @@ static void xsk_destruct(struct sock *sk)
>   static int xsk_create(struct net *net, struct socket *sock, int protocol,
>   		      int kern)
>   {
> -	struct sock *sk;
>   	struct xdp_sock *xs;
> +	struct sock *sk;
>   
>   	if (!ns_capable(net->user_ns, CAP_NET_RAW))
>   		return -EPERM;
> @@ -1092,6 +1151,10 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
>   	INIT_LIST_HEAD(&xs->map_list);
>   	spin_lock_init(&xs->map_list_lock);
>   
> +	xs->pool = xp_create();
> +	if (!xs->pool)
> +		return -ENOMEM;
> +
>   	mutex_lock(&net->xdp.lock);
>   	sk_add_node_rcu(sk, &net->xdp.list);
>   	mutex_unlock(&net->xdp.lock);
> diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
> index 455ddd4..a00e3e2 100644
> --- a/net/xdp/xsk.h
> +++ b/net/xdp/xsk.h
> @@ -51,5 +51,8 @@ void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
>   			     struct xdp_sock **map_entry);
>   int xsk_map_inc(struct xsk_map *map);
>   void xsk_map_put(struct xsk_map *map);
> +void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
> +int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
> +			u16 queue_id);
>   
>   #endif /* XSK_H_ */
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index c57f0bb..da93b36 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -2,11 +2,14 @@
>   
>   #include <net/xsk_buff_pool.h>
>   #include <net/xdp_sock.h>
> +#include <net/xdp_sock_drv.h>
>   #include <linux/dma-direct.h>
>   #include <linux/dma-noncoherent.h>
>   #include <linux/swiotlb.h>
>   
>   #include "xsk_queue.h"
> +#include "xdp_umem.h"
> +#include "xsk.h"
>   
>   static void xp_addr_unmap(struct xsk_buff_pool *pool)
>   {
> @@ -32,39 +35,48 @@ void xp_destroy(struct xsk_buff_pool *pool)
>   	kvfree(pool);
>   }
>   
> -struct xsk_buff_pool *xp_create(struct xdp_umem *umem, u32 chunks,
> -				u32 chunk_size, u32 headroom, u64 size,
> -				bool unaligned)
> +struct xsk_buff_pool *xp_create(void)
> +{
> +	return kvzalloc(sizeof(struct xsk_buff_pool), GFP_KERNEL);
> +}
> +
> +struct xsk_buff_pool *xp_assign_umem(struct xsk_buff_pool *pool_old,
> +				     struct xdp_umem *umem)
>   {
>   	struct xsk_buff_pool *pool;
>   	struct xdp_buff_xsk *xskb;
>   	int err;
>   	u32 i;
>   
> -	pool = kvzalloc(struct_size(pool, free_heads, chunks), GFP_KERNEL);
> +	pool = kvzalloc(struct_size(pool, free_heads, umem->chunks),
> +			GFP_KERNEL);
>   	if (!pool)
>   		goto out;
>   
> -	pool->heads = kvcalloc(chunks, sizeof(*pool->heads), GFP_KERNEL);
> +	memcpy(pool, pool_old, sizeof(*pool_old));
> +
> +	pool->heads = kvcalloc(umem->chunks, sizeof(*pool->heads), GFP_KERNEL);
>   	if (!pool->heads)
>   		goto out;
>   
> -	pool->chunk_mask = ~((u64)chunk_size - 1);
> -	pool->addrs_cnt = size;
> -	pool->heads_cnt = chunks;
> -	pool->free_heads_cnt = chunks;
> -	pool->headroom = headroom;
> -	pool->chunk_size = chunk_size;
> +	pool->chunk_mask = ~((u64)umem->chunk_size - 1);
> +	pool->addrs_cnt = umem->size;
> +	pool->heads_cnt = umem->chunks;
> +	pool->free_heads_cnt = umem->chunks;
> +	pool->headroom = umem->headroom;
> +	pool->chunk_size = umem->chunk_size;
>   	pool->cheap_dma = true;
> -	pool->unaligned = unaligned;
> -	pool->frame_len = chunk_size - headroom - XDP_PACKET_HEADROOM;
> +	pool->unaligned = umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
> +	pool->frame_len = umem->chunk_size - umem->headroom -
> +		XDP_PACKET_HEADROOM;
>   	pool->umem = umem;
>   	INIT_LIST_HEAD(&pool->free_list);
> +	refcount_set(&pool->users, 1);
>   
>   	for (i = 0; i < pool->free_heads_cnt; i++) {
>   		xskb = &pool->heads[i];
>   		xskb->pool = pool;
> -		xskb->xdp.frame_sz = chunk_size - headroom;
> +		xskb->xdp.frame_sz = umem->chunk_size - umem->headroom;
>   		pool->free_heads[i] = xskb;
>   	}
>   
> @@ -91,6 +103,120 @@ void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
>   }
>   EXPORT_SYMBOL(xp_set_rxq_info);
>   
> +int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
> +		  struct net_device *dev, u16 queue_id, u16 flags)
> +{
> +	struct xdp_umem *umem = pool->umem;
> +	bool force_zc, force_copy;
> +	struct netdev_bpf bpf;
> +	int err = 0;
> +
> +	ASSERT_RTNL();
> +
> +	force_zc = flags & XDP_ZEROCOPY;
> +	force_copy = flags & XDP_COPY;
> +
> +	if (force_zc && force_copy)
> +		return -EINVAL;
> +
> +	if (xsk_get_pool_from_qid(dev, queue_id))
> +		return -EBUSY;
> +
> +	err = xsk_reg_pool_at_qid(dev, pool, queue_id);
> +	if (err)
> +		return err;
> +
> +	if ((flags & XDP_USE_NEED_WAKEUP) && xs->tx) {
> +		umem->flags |= XDP_UMEM_USES_NEED_WAKEUP;
> +		/* Tx needs to be explicitly woken up the first time.
> +		 * Also for supporting drivers that do not implement this
> +		 * feature. They will always have to call sendto().
> +		 */
> +		xs->tx->ring->flags |= XDP_RING_NEED_WAKEUP;
> +	}
> +
> +	if (force_copy)
> +		/* For copy-mode, we are done. */
> +		return 0;
> +
> +	if (!dev->netdev_ops->ndo_bpf || !dev->netdev_ops->ndo_xsk_wakeup) {
> +		err = -EOPNOTSUPP;
> +		goto err_unreg_pool;
> +	}
> +
> +	bpf.command = XDP_SETUP_XSK_POOL;
> +	bpf.xsk.pool = pool;
> +	bpf.xsk.queue_id = queue_id;
> +
> +	err = dev->netdev_ops->ndo_bpf(dev, &bpf);
> +	if (err)
> +		goto err_unreg_pool;
> +
> +	umem->zc = true;
> +	return 0;
> +
> +err_unreg_pool:
> +	if (!force_zc)
> +		err = 0; /* fallback to copy mode */
> +	if (err)
> +		xsk_clear_pool_at_qid(dev, queue_id);
> +	return err;
> +}
> +
> +void xp_clear_dev(struct xsk_buff_pool *pool)
> +{
> +	struct xdp_umem *umem = pool->umem;
> +	struct netdev_bpf bpf;
> +	int err;
> +
> +	ASSERT_RTNL();
> +
> +	if (!umem->dev)
> +		return;
> +
> +	if (umem->zc) {
> +		bpf.command = XDP_SETUP_XSK_POOL;
> +		bpf.xsk.pool = NULL;
> +		bpf.xsk.queue_id = umem->queue_id;
> +
> +		err = umem->dev->netdev_ops->ndo_bpf(umem->dev, &bpf);
> +
> +		if (err)
> +			WARN(1, "failed to disable umem!\n");
> +	}
> +
> +	xsk_clear_pool_at_qid(umem->dev, umem->queue_id);
> +}
> +
> +static void xp_release_deferred(struct work_struct *work)
> +{
> +	struct xsk_buff_pool *pool = container_of(work, struct xsk_buff_pool,
> +						  work);
> +
> +	rtnl_lock();
> +	xp_clear_dev(pool);
> +	rtnl_unlock();
> +
> +	xdp_put_umem(pool->umem);
> +	xp_destroy(pool);
> +}
> +
> +void xp_get_pool(struct xsk_buff_pool *pool)
> +{
> +	refcount_inc(&pool->users);
> +}
> +
> +void xp_put_pool(struct xsk_buff_pool *pool)
> +{
> +	if (!pool)
> +		return;
> +
> +	if (refcount_dec_and_test(&pool->users)) {
> +		INIT_WORK(&pool->work, xp_release_deferred);
> +		schedule_work(&pool->work);
> +	}
> +}
> +
>   void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
>   {
>   	dma_addr_t *dma;
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index 5b5d24d..75f1853 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -165,9 +165,9 @@ static inline bool xp_validate_desc(struct xsk_buff_pool *pool,
>   
>   static inline bool xskq_cons_is_valid_desc(struct xsk_queue *q,
>   					   struct xdp_desc *d,
> -					   struct xdp_umem *umem)
> +					   struct xsk_buff_pool *pool)
>   {
> -	if (!xp_validate_desc(umem->pool, d)) {
> +	if (!xp_validate_desc(pool, d)) {
>   		q->invalid_descs++;
>   		return false;
>   	}
> @@ -176,14 +176,14 @@ static inline bool xskq_cons_is_valid_desc(struct xsk_queue *q,
>   
>   static inline bool xskq_cons_read_desc(struct xsk_queue *q,
>   				       struct xdp_desc *desc,
> -				       struct xdp_umem *umem)
> +				       struct xsk_buff_pool *pool)
>   {
>   	while (q->cached_cons != q->cached_prod) {
>   		struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
>   		u32 idx = q->cached_cons & q->ring_mask;
>   
>   		*desc = ring->desc[idx];
> -		if (xskq_cons_is_valid_desc(q, desc, umem))
> +		if (xskq_cons_is_valid_desc(q, desc, pool))
>   			return true;
>   
>   		q->cached_cons++;
> @@ -235,11 +235,11 @@ static inline bool xskq_cons_peek_addr_unchecked(struct xsk_queue *q, u64 *addr)
>   
>   static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
>   				       struct xdp_desc *desc,
> -				       struct xdp_umem *umem)
> +				       struct xsk_buff_pool *pool)
>   {
>   	if (q->cached_prod == q->cached_cons)
>   		xskq_cons_get_entries(q);
> -	return xskq_cons_read_desc(q, desc, umem);
> +	return xskq_cons_read_desc(q, desc, pool);
>   }
>   
>   static inline void xskq_cons_release(struct xsk_queue *q)
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0767122083B
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 11:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgGOJJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 05:09:36 -0400
Received: from mail-eopbgr60073.outbound.protection.outlook.com ([40.107.6.73]:61089
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725922AbgGOJJf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 05:09:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtWp1bmopEkn4rUCOO4wSYl/ixRZ2XjyozW2o0B/e4+ErYdhlVDGrNWW01EJjjFLIgQsYxpxNC8UDx8LNsFaPEWQYv2nWyl697cxyqB9XvohWKEnNQj3lBYx0TZKJ2DESLE/MBnSXA8XrQc/adhM828Wlenw61emPQv9H0i6l3oPRO3YX6HuGMi0/ub5/m4s4Be/76doYYXrqHpeFTRnno5ivq8Jee/0U2iWIrbN7yA+rLWpOuFrWTTFhekrUdwnsCNUuwZnDwRpHms7BRZy7n+kxf2nsx3Nyhy8kxv58RM3zF6ErTR/vo6f0glONF/RcQBN5ghT8wZ85+7zyGaA1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sefK0izBrlXBba7nm9x0YC44rizNTTh1V7IKukh2Xig=;
 b=JhSEkn8ps6GJ9iW5JssRG5fgif39UCSJNgpAg0Ezkj76IgSTh2V8ul5h0gc41iSNv0ILG6zxhZN8JkRLtwpOZ7V/yj8l/dLoSM40/srB/sjd+5q7955eDxmC/CnrMeGCiU7fCvxipxkFd8jYLbnLcAeOXsiE+JOm2EcBI2BBGLlPs2dc4miFGYMfz0sApdKhnoRFW0SaJdoiS30t5I+3Lcb8g3tBCoZup1UTnJH9Kcd3ekO1oW5qvX4JJe5NS2qr8jRRXM8DHVqKlQNoYSX3y+x22lMmgbTc6e56d473TWyXTXXng2RMJRKLjmw7fvG2cRXpRkwvROCXegq7BOtX0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sefK0izBrlXBba7nm9x0YC44rizNTTh1V7IKukh2Xig=;
 b=thf3i9C8GU8ZoX/Zz+xaTvgCSFQmoMR5uy+KMYyIOpTC+l95v5IEF/3YV5EcDKubNrOGwO6EydtKas4r1oQYgHn6OhMt2x/c6vPyUfKPkfr/ig2DSoHQEnVp2+PvHTXQ6ml6nzL0E0AHrne4/I8jA1kcfEQSlLWzHUYnD+wSTEk=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB6056.eurprd05.prod.outlook.com (2603:10a6:20b:a9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 15 Jul
 2020 09:09:30 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 09:09:30 +0000
Subject: Re: [PATCH bpf-next v2 04/14] xsk: move fill and completion rings to
 buffer pool
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
References: <1594390602-7635-1-git-send-email-magnus.karlsson@intel.com>
 <1594390602-7635-5-git-send-email-magnus.karlsson@intel.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <0f2ff47a-d1ce-78d3-bb96-6e5bc60dc04f@mellanox.com>
Date:   Wed, 15 Jul 2020 12:09:27 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1594390602-7635-5-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0302CA0001.eurprd03.prod.outlook.com
 (2603:10a6:205:2::14) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.57.1.235] (159.224.90.213) by AM4PR0302CA0001.eurprd03.prod.outlook.com (2603:10a6:205:2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Wed, 15 Jul 2020 09:09:29 +0000
X-Originating-IP: [159.224.90.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 68846278-b595-4f8c-ae1b-08d8289ec84a
X-MS-TrafficTypeDiagnostic: AM6PR05MB6056:
X-Microsoft-Antispam-PRVS: <AM6PR05MB60563F50DF344D171769C3C5D17E0@AM6PR05MB6056.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:480;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6fm1VPpHFaiODEAXh6APeuGnwlEAduc9HP4DYKeZPqawXoylaipAamGW6dgVqto7qyl9Qhd7kzVetIK6/lUzVwGp1zJB0V6lyMumCWk7pcCQmQsXV1DOsFDb+kndbck/gzAo0EesjtE8kIMNVxMcc4nU4KgOrzV9skD9V16SprZWBTjonF457F87JRsbven9KnyOfq5AvT383RqCNjswXafvDctK+uoHa6hqSkSls0ZYzqm5zbeS7UPymCyH8b7cABTprlJ2OATdiustyzQtSY5/Qv1lVPSdz7P8evCHBBi788IgEawHIl1wus/fPCrILaPXQ1DXPsbpU9Gp2G9Nz6dE2aJR+su0kwtKhNGMnnHGtFBv/7l/CgKKeKvzh9l7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(7416002)(16576012)(30864003)(6486002)(316002)(83380400001)(36756003)(8936002)(26005)(478600001)(86362001)(2906002)(5660300002)(8676002)(31696002)(66476007)(6916009)(52116002)(31686004)(956004)(53546011)(4326008)(55236004)(66556008)(66946007)(2616005)(16526019)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1i4QVuAeTr+/qf+5j4nElOM5bpF58hBxMHSXH+xaGP4eM9Zh0MrILZaZzG6srBnfh14mmXkIbZuynM4bmRdjN/1DfsbyZO0y8YrAQonjygtMyYuCWZIhJo8Ir9owhUnw8GjbCS+SP07ZCDMj3vqdnhv67H7n9z98tfnJww2vsytTnpd4WTqfeYM/OFqC5dZK8P8EoO0bruupArmmrPssdtSc4wz3wQYtclmFAJa7R1hYHJhJ9e0yvt5ZEv+PNXgQERz67sNJn3c3tcyjElFo9FAG67qANYSMe3vH3MtiOX7HzbfOOODeEi0w3eVRi0YS5sDtIMqCBDswHvDc8nrsZI0msbSlxbI2/1FhZRYnF8YUCYIIflStcY3ai31U6iL1ks89/b6M88sw/oXx/cCuwnTtITfwKvYMa/rNktB0baz2AbFR7A17peZdrC6SodnmHHN2ROK4TUAySA/ByEd1LTKY4Wa54EsJxzCqchH+dX7iVHoV+GxoqevV0rQEHJhc
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68846278-b595-4f8c-ae1b-08d8289ec84a
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 09:09:30.4885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGq4Mib64mCguSWaRy7PDrYQcz7Zes1Wd968Xzk/w+DM0Fp1OH4hqOAIT3444RSJhO3ePFufiNwmAP3fQfKIVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6056
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-10 17:16, Magnus Karlsson wrote:
> Move the fill and completion rings from the umem to the buffer
> pool. This so that we in a later commit can share the umem
> between multiple HW queue ids. In this case, we need one fill and
> completion ring per queue id. As the buffer pool is per queue id
> and napi id this is a natural place for it and one umem
> struture can be shared between these buffer pools.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   include/net/xdp_sock.h      |  4 ++--
>   include/net/xsk_buff_pool.h |  2 +-
>   net/xdp/xdp_umem.c          | 15 ---------------
>   net/xdp/xsk.c               | 44 ++++++++++++++++++++++++--------------------
>   net/xdp/xsk_buff_pool.c     | 20 +++++++++++++++-----
>   net/xdp/xsk_diag.c          | 10 ++++++----
>   6 files changed, 48 insertions(+), 47 deletions(-)
> 
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index b9bb118..5eb59b7 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -18,8 +18,6 @@ struct xsk_queue;
>   struct xdp_buff;
>   
>   struct xdp_umem {
> -	struct xsk_queue *fq;
> -	struct xsk_queue *cq;
>   	u64 size;
>   	u32 headroom;
>   	u32 chunk_size;
> @@ -73,6 +71,8 @@ struct xdp_sock {
>   	struct list_head map_list;
>   	/* Protects map_list */
>   	spinlock_t map_list_lock;
> +	struct xsk_queue *fq_tmp; /* Only as tmp storage before bind */
> +	struct xsk_queue *cq_tmp; /* Only as tmp storage before bind */
>   };
>   
>   #ifdef CONFIG_XDP_SOCKETS
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index ff8592d5..0423303 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -30,6 +30,7 @@ struct xdp_buff_xsk {
>   
>   struct xsk_buff_pool {
>   	struct xsk_queue *fq;
> +	struct xsk_queue *cq;
>   	struct list_head free_list;
>   	dma_addr_t *dma_pages;
>   	struct xdp_buff_xsk *heads;
> @@ -57,7 +58,6 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
>   						struct xdp_umem *umem);
>   int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
>   		  u16 queue_id, u16 flags);
> -void xp_set_fq(struct xsk_buff_pool *pool, struct xsk_queue *fq);
>   void xp_destroy(struct xsk_buff_pool *pool);
>   void xp_release(struct xdp_buff_xsk *xskb);
>   void xp_get_pool(struct xsk_buff_pool *pool);
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index f290345..7d86a63 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -85,16 +85,6 @@ static void xdp_umem_release(struct xdp_umem *umem)
>   
>   	ida_simple_remove(&umem_ida, umem->id);
>   
> -	if (umem->fq) {
> -		xskq_destroy(umem->fq);
> -		umem->fq = NULL;
> -	}
> -
> -	if (umem->cq) {
> -		xskq_destroy(umem->cq);
> -		umem->cq = NULL;
> -	}
> -
>   	xdp_umem_unpin_pages(umem);
>   
>   	xdp_umem_unaccount_pages(umem);
> @@ -278,8 +268,3 @@ struct xdp_umem *xdp_umem_create(struct xdp_umem_reg *mr)
>   
>   	return umem;
>   }
> -
> -bool xdp_umem_validate_queues(struct xdp_umem *umem)
> -{
> -	return umem->fq && umem->cq;
> -}
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index caaf298..b44b150 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -36,7 +36,7 @@ static DEFINE_PER_CPU(struct list_head, xskmap_flush_list);
>   bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
>   {
>   	return READ_ONCE(xs->rx) &&  READ_ONCE(xs->umem) &&
> -		READ_ONCE(xs->umem->fq);
> +		(xs->pool->fq || READ_ONCE(xs->fq_tmp));
>   }
>   
>   void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
> @@ -46,7 +46,7 @@ void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
>   	if (umem->need_wakeup & XDP_WAKEUP_RX)
>   		return;
>   
> -	umem->fq->ring->flags |= XDP_RING_NEED_WAKEUP;
> +	pool->fq->ring->flags |= XDP_RING_NEED_WAKEUP;
>   	umem->need_wakeup |= XDP_WAKEUP_RX;
>   }
>   EXPORT_SYMBOL(xsk_set_rx_need_wakeup);
> @@ -76,7 +76,7 @@ void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *pool)
>   	if (!(umem->need_wakeup & XDP_WAKEUP_RX))
>   		return;
>   
> -	umem->fq->ring->flags &= ~XDP_RING_NEED_WAKEUP;
> +	pool->fq->ring->flags &= ~XDP_RING_NEED_WAKEUP;
>   	umem->need_wakeup &= ~XDP_WAKEUP_RX;
>   }
>   EXPORT_SYMBOL(xsk_clear_rx_need_wakeup);
> @@ -254,7 +254,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp,
>   static void xsk_flush(struct xdp_sock *xs)
>   {
>   	xskq_prod_submit(xs->rx);
> -	__xskq_cons_release(xs->umem->fq);
> +	__xskq_cons_release(xs->pool->fq);
>   	sock_def_readable(&xs->sk);
>   }
>   
> @@ -297,7 +297,7 @@ void __xsk_map_flush(void)
>   
>   void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries)
>   {
> -	xskq_prod_submit_n(pool->umem->cq, nb_entries);
> +	xskq_prod_submit_n(pool->cq, nb_entries);
>   }
>   EXPORT_SYMBOL(xsk_tx_completed);
>   
> @@ -329,7 +329,7 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
>   		 * if there is space in it. This avoids having to implement
>   		 * any buffering in the Tx path.
>   		 */
> -		if (xskq_prod_reserve_addr(umem->cq, desc->addr))
> +		if (xskq_prod_reserve_addr(pool->cq, desc->addr))
>   			goto out;
>   
>   		xskq_cons_release(xs->tx);
> @@ -367,7 +367,7 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>   	unsigned long flags;
>   
>   	spin_lock_irqsave(&xs->tx_completion_lock, flags);
> -	xskq_prod_submit_addr(xs->umem->cq, addr);
> +	xskq_prod_submit_addr(xs->pool->cq, addr);
>   	spin_unlock_irqrestore(&xs->tx_completion_lock, flags);
>   
>   	sock_wfree(skb);
> @@ -411,7 +411,7 @@ static int xsk_generic_xmit(struct sock *sk)
>   		 * if there is space in it. This avoids having to implement
>   		 * any buffering in the Tx path.
>   		 */
> -		if (unlikely(err) || xskq_prod_reserve(xs->umem->cq)) {
> +		if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
>   			kfree_skb(skb);
>   			goto out;
>   		}
> @@ -629,6 +629,11 @@ static struct socket *xsk_lookup_xsk_from_fd(int fd)
>   	return sock;
>   }
>   
> +static bool xsk_validate_queues(struct xdp_sock *xs)
> +{
> +	return xs->fq_tmp && xs->cq_tmp;
> +}
> +
>   static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   {
>   	struct sockaddr_xdp *sxdp = (struct sockaddr_xdp *)addr;
> @@ -685,6 +690,12 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   			goto out_unlock;
>   		}
>   
> +		if (xs->fq_tmp || xs->cq_tmp) {
> +			/* Do not allow setting your own fq or cq. */
> +			err = -EINVAL;
> +			goto out_unlock;
> +		}
> +
>   		sock = xsk_lookup_xsk_from_fd(sxdp->sxdp_shared_umem_fd);
>   		if (IS_ERR(sock)) {
>   			err = PTR_ERR(sock);
> @@ -709,7 +720,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   		xdp_get_umem(umem_xs->umem);
>   		WRITE_ONCE(xs->umem, umem_xs->umem);
>   		sockfd_put(sock);
> -	} else if (!xs->umem || !xdp_umem_validate_queues(xs->umem)) {
> +	} else if (!xs->umem || !xsk_validate_queues(xs)) {
>   		err = -EINVAL;
>   		goto out_unlock;
>   	} else {
> @@ -844,11 +855,9 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
>   			return -EINVAL;
>   		}
>   
> -		q = (optname == XDP_UMEM_FILL_RING) ? &xs->umem->fq :
> -			&xs->umem->cq;
> +		q = (optname == XDP_UMEM_FILL_RING) ? &xs->fq_tmp :
> +			&xs->cq_tmp;
>   		err = xsk_init_queue(entries, q, true);
> -		if (optname == XDP_UMEM_FILL_RING)
> -			xp_set_fq(xs->pool, *q);
>   		mutex_unlock(&xs->mutex);
>   		return err;
>   	}
> @@ -995,7 +1004,6 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>   	unsigned long size = vma->vm_end - vma->vm_start;
>   	struct xdp_sock *xs = xdp_sk(sock->sk);
>   	struct xsk_queue *q = NULL;
> -	struct xdp_umem *umem;
>   	unsigned long pfn;
>   	struct page *qpg;
>   
> @@ -1007,16 +1015,12 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>   	} else if (offset == XDP_PGOFF_TX_RING) {
>   		q = READ_ONCE(xs->tx);
>   	} else {
> -		umem = READ_ONCE(xs->umem);
> -		if (!umem)
> -			return -EINVAL;
> -
>   		/* Matches the smp_wmb() in XDP_UMEM_REG */
>   		smp_rmb();
>   		if (offset == XDP_UMEM_PGOFF_FILL_RING)
> -			q = READ_ONCE(umem->fq);
> +			q = READ_ONCE(xs->fq_tmp);
>   		else if (offset == XDP_UMEM_PGOFF_COMPLETION_RING)
> -			q = READ_ONCE(umem->cq);
> +			q = READ_ONCE(xs->cq_tmp);
>   	}
>   
>   	if (!q)
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index d450fb7..32720f2 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -66,6 +66,11 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
>   	INIT_LIST_HEAD(&pool->free_list);
>   	refcount_set(&pool->users, 1);
>   
> +	pool->fq = xs->fq_tmp;
> +	pool->cq = xs->cq_tmp;
> +	xs->fq_tmp = NULL;
> +	xs->cq_tmp = NULL;
> +
>   	for (i = 0; i < pool->free_heads_cnt; i++) {
>   		xskb = &pool->heads[i];
>   		xskb->pool = pool;
> @@ -82,11 +87,6 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
>   	return NULL;
>   }
>   
> -void xp_set_fq(struct xsk_buff_pool *pool, struct xsk_queue *fq)
> -{
> -	pool->fq = fq;
> -}
> -
>   void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
>   {
>   	u32 i;
> @@ -190,6 +190,16 @@ static void xp_release_deferred(struct work_struct *work)
>   	xp_clear_dev(pool);
>   	rtnl_unlock();
>   
> +	if (pool->fq) {
> +		xskq_destroy(pool->fq);
> +		pool->fq = NULL;
> +	}
> +
> +	if (pool->cq) {
> +		xskq_destroy(pool->cq);
> +		pool->cq = NULL;
> +	}
> +

It looks like xskq_destroy is missing for fq_tmp and cq_tmp, which is 
needed in some cases, e.g., if bind() wasn't called at all, or if 
xsk_bind failed with EINVAL.

>   	xdp_put_umem(pool->umem);
>   	xp_destroy(pool);
>   }
> diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
> index 0163b26..1936423 100644
> --- a/net/xdp/xsk_diag.c
> +++ b/net/xdp/xsk_diag.c
> @@ -46,6 +46,7 @@ static int xsk_diag_put_rings_cfg(const struct xdp_sock *xs,
>   
>   static int xsk_diag_put_umem(const struct xdp_sock *xs, struct sk_buff *nlskb)
>   {
> +	struct xsk_buff_pool *pool = xs->pool;
>   	struct xdp_umem *umem = xs->umem;
>   	struct xdp_diag_umem du = {};
>   	int err;
> @@ -67,10 +68,11 @@ static int xsk_diag_put_umem(const struct xdp_sock *xs, struct sk_buff *nlskb)
>   
>   	err = nla_put(nlskb, XDP_DIAG_UMEM, sizeof(du), &du);
>   
> -	if (!err && umem->fq)
> -		err = xsk_diag_put_ring(umem->fq, XDP_DIAG_UMEM_FILL_RING, nlskb);
> -	if (!err && umem->cq) {
> -		err = xsk_diag_put_ring(umem->cq, XDP_DIAG_UMEM_COMPLETION_RING,
> +	if (!err && pool->fq)
> +		err = xsk_diag_put_ring(pool->fq,
> +					XDP_DIAG_UMEM_FILL_RING, nlskb);
> +	if (!err && pool->cq) {
> +		err = xsk_diag_put_ring(pool->cq, XDP_DIAG_UMEM_COMPLETION_RING,
>   					nlskb);
>   	}
>   	return err;
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250962303A8
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgG1HPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 03:15:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:62662 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbgG1HPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 03:15:32 -0400
IronPort-SDR: 3+z1k8xFCK6tBoA0v5IyHvI/Q765YZRAhh00tn3hjGp3e0oBDr35Yrz2dUlohHlS9AHPNN7jeD
 Ilb5znMWfFnw==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="130725373"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="130725373"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 00:15:31 -0700
IronPort-SDR: sDooa2q1NaWqB/rsOFIkZNVY8QoaYjwbLDcuy8t+61wygoMiNLJuq62gYwJvhsCkK+LhwG4XFp
 lswFcA4LP3Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="322092414"
Received: from nheyde-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.57.223])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jul 2020 00:15:28 -0700
Subject: Re: [PATCH bpf-next v4 10/14] xsk: add shared umem support between
 queue ids
To:     Magnus Karlsson <magnus.karlsson@intel.com>, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
References: <1595307848-20719-1-git-send-email-magnus.karlsson@intel.com>
 <1595307848-20719-11-git-send-email-magnus.karlsson@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <f6b54e3c-a4e6-afc1-86cc-48a19a1c7372@intel.com>
Date:   Tue, 28 Jul 2020 09:15:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595307848-20719-11-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-07-21 07:04, Magnus Karlsson wrote:
> Add support to share a umem between queue ids on the same
> device. This mode can be invoked with the XDP_SHARED_UMEM bind
> flag. Previously, sharing was only supported within the same
> queue id and device, and you shared one set of fill and
> completion rings. However, note that when sharing a umem between
> queue ids, you need to create a fill ring and a completion ring
> and tie them to the socket before you do the bind with the
> XDP_SHARED_UMEM flag. This so that the single-producer
> single-consumer semantics can be upheld.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Björn Töpel <bjorn.topel@intel.com>


> ---
>   include/net/xsk_buff_pool.h |  2 ++
>   net/xdp/xsk.c               | 44 ++++++++++++++++++++++++++++++--------------
>   net/xdp/xsk_buff_pool.c     | 26 ++++++++++++++++++++++++--
>   3 files changed, 56 insertions(+), 16 deletions(-)
> 
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index b4d6307..4d699dd 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -75,6 +75,8 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
>   						struct xdp_umem *umem);
>   int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
>   		  u16 queue_id, u16 flags);
> +int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
> +			 struct net_device *dev, u16 queue_id);
>   void xp_destroy(struct xsk_buff_pool *pool);
>   void xp_release(struct xdp_buff_xsk *xskb);
>   void xp_get_pool(struct xsk_buff_pool *pool);
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index d0ff5e8..e897755 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -689,12 +689,6 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   			goto out_unlock;
>   		}
>   
> -		if (xs->fq_tmp || xs->cq_tmp) {
> -			/* Do not allow setting your own fq or cq. */
> -			err = -EINVAL;
> -			goto out_unlock;
> -		}
> -
>   		sock = xsk_lookup_xsk_from_fd(sxdp->sxdp_shared_umem_fd);
>   		if (IS_ERR(sock)) {
>   			err = PTR_ERR(sock);
> @@ -707,15 +701,41 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>   			sockfd_put(sock);
>   			goto out_unlock;
>   		}
> -		if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
> +		if (umem_xs->dev != dev) {
>   			err = -EINVAL;
>   			sockfd_put(sock);
>   			goto out_unlock;
>   		}
>   
> -		/* Share the buffer pool with the other socket. */
> -		xp_get_pool(umem_xs->pool);
> -		xs->pool = umem_xs->pool;
> +		if (umem_xs->queue_id != qid) {
> +			/* Share the umem with another socket on another qid */
> +			xs->pool = xp_create_and_assign_umem(xs,
> +							     umem_xs->umem);
> +			if (!xs->pool) {
> +				sockfd_put(sock);
> +				goto out_unlock;
> +			}
> +
> +			err = xp_assign_dev_shared(xs->pool, umem_xs->umem,
> +						   dev, qid);
> +			if (err) {
> +				xp_destroy(xs->pool);
> +				sockfd_put(sock);
> +				goto out_unlock;
> +			}
> +		} else {
> +			/* Share the buffer pool with the other socket. */
> +			if (xs->fq_tmp || xs->cq_tmp) {
> +				/* Do not allow setting your own fq or cq. */
> +				err = -EINVAL;
> +				sockfd_put(sock);
> +				goto out_unlock;
> +			}
> +
> +			xp_get_pool(umem_xs->pool);
> +			xs->pool = umem_xs->pool;
> +		}
> +
>   		xdp_get_umem(umem_xs->umem);
>   		WRITE_ONCE(xs->umem, umem_xs->umem);
>   		sockfd_put(sock);
> @@ -847,10 +867,6 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
>   			mutex_unlock(&xs->mutex);
>   			return -EBUSY;
>   		}
> -		if (!xs->umem) {
> -			mutex_unlock(&xs->mutex);
> -			return -EINVAL;
> -		}
>   
>   		q = (optname == XDP_UMEM_FILL_RING) ? &xs->fq_tmp :
>   			&xs->cq_tmp;
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index ca74a3e..688dc36 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -123,8 +123,8 @@ static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
>   	}
>   }
>   
> -int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
> -		  u16 queue_id, u16 flags)
> +static int __xp_assign_dev(struct xsk_buff_pool *pool,
> +			   struct net_device *netdev, u16 queue_id, u16 flags)
>   {
>   	bool force_zc, force_copy;
>   	struct netdev_bpf bpf;
> @@ -193,6 +193,28 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
>   	return err;
>   }
>   
> +int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
> +		  u16 queue_id, u16 flags)
> +{
> +	return __xp_assign_dev(pool, dev, queue_id, flags);
> +}
> +
> +int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
> +			 struct net_device *dev, u16 queue_id)
> +{
> +	u16 flags;
> +
> +	/* One fill and completion ring required for each queue id. */
> +	if (!pool->fq || !pool->cq)
> +		return -EINVAL;
> +
> +	flags = umem->zc ? XDP_ZEROCOPY : XDP_COPY;
> +	if (pool->uses_need_wakeup)
> +		flags |= XDP_USE_NEED_WAKEUP;
> +
> +	return __xp_assign_dev(pool, dev, queue_id, flags);
> +}
> +
>   void xp_clear_dev(struct xsk_buff_pool *pool)
>   {
>   	if (!pool->netdev)
> 

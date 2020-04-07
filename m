Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095811A153B
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 20:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgDGSsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 14:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbgDGSsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Apr 2020 14:48:15 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62A3220730;
        Tue,  7 Apr 2020 18:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586285294;
        bh=rTmBHDoBAy4CL3L6aYQVMHrBcqCicMbxXJIdvUl3zDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lUfPRcUbiJY9srJK0tCnGDSXurAhsM21eETj1n45sAnsw2/asfY8dN8IdczmirjYS
         ++rLuKtBhj36PmGVxA5pIleTSTVpPNJP8+OPb7YvYQPbKxYxUTzSp0ONsL7Gkx1Zyi
         hsxOAvETTnZqyuE62/+Njo6ARiP5kX+34+XkFG2E=
Date:   Tue, 7 Apr 2020 21:48:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        davem@davemloft.net, rds-devel@oss.oracle.com,
        sironhide0null@gmail.com
Subject: Re: [PATCH net 1/2] net/rds: Replace direct refcount_inc() by inline
 function
Message-ID: <20200407184809.GP80989@unreal>
References: <4b96ea99c3f0ccd5cc0683a5c944a1c4da41cc38.1586275373.git.ka-cheong.poon@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b96ea99c3f0ccd5cc0683a5c944a1c4da41cc38.1586275373.git.ka-cheong.poon@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 07, 2020 at 09:08:01AM -0700, Ka-Cheong Poon wrote:
> Added rds_ib_dev_get() and rds_mr_get() to improve code readability.

It is very hard to agree with this sentence.
Hiding basic kernel primitives is very rare will improve code readability.
It is definitely not the case here.

Thanks

>
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> ---
>  net/rds/ib.c      | 8 ++++----
>  net/rds/ib.h      | 5 +++++
>  net/rds/ib_rdma.c | 6 +++---
>  net/rds/rdma.c    | 8 ++++----
>  net/rds/rds.h     | 5 +++++
>  5 files changed, 21 insertions(+), 11 deletions(-)
>
> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index a792d8a..c16cb1a 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2006, 2019 Oracle and/or its affiliates. All rights reserved.
> + * Copyright (c) 2006, 2020 Oracle and/or its affiliates. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -224,10 +224,10 @@ static void rds_ib_add_one(struct ib_device *device)
>  	down_write(&rds_ib_devices_lock);
>  	list_add_tail_rcu(&rds_ibdev->list, &rds_ib_devices);
>  	up_write(&rds_ib_devices_lock);
> -	refcount_inc(&rds_ibdev->refcount);
> +	rds_ib_dev_get(rds_ibdev);
>
>  	ib_set_client_data(device, &rds_ib_client, rds_ibdev);
> -	refcount_inc(&rds_ibdev->refcount);
> +	rds_ib_dev_get(rds_ibdev);
>
>  	rds_ib_nodev_connect();
>
> @@ -258,7 +258,7 @@ struct rds_ib_device *rds_ib_get_client_data(struct ib_device *device)
>  	rcu_read_lock();
>  	rds_ibdev = ib_get_client_data(device, &rds_ib_client);
>  	if (rds_ibdev)
> -		refcount_inc(&rds_ibdev->refcount);
> +		rds_ib_dev_get(rds_ibdev);
>  	rcu_read_unlock();
>  	return rds_ibdev;
>  }
> diff --git a/net/rds/ib.h b/net/rds/ib.h
> index 0296f1f..fe7ea4e 100644
> --- a/net/rds/ib.h
> +++ b/net/rds/ib.h
> @@ -361,6 +361,11 @@ static inline void rds_ib_dma_sync_sg_for_device(struct ib_device *dev,
>  extern struct rds_transport rds_ib_transport;
>  struct rds_ib_device *rds_ib_get_client_data(struct ib_device *device);
>  void rds_ib_dev_put(struct rds_ib_device *rds_ibdev);
> +static inline void rds_ib_dev_get(struct rds_ib_device *rds_ibdev)
> +{
> +	refcount_inc(&rds_ibdev->refcount);
> +}
> +
>  extern struct ib_client rds_ib_client;
>
>  extern unsigned int rds_ib_retry_count;
> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index b34b24e..1b942d80 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2006, 2018 Oracle and/or its affiliates. All rights reserved.
> + * Copyright (c) 2006, 2020 Oracle and/or its affiliates. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -56,7 +56,7 @@ static struct rds_ib_device *rds_ib_get_device(__be32 ipaddr)
>  	list_for_each_entry_rcu(rds_ibdev, &rds_ib_devices, list) {
>  		list_for_each_entry_rcu(i_ipaddr, &rds_ibdev->ipaddr_list, list) {
>  			if (i_ipaddr->ipaddr == ipaddr) {
> -				refcount_inc(&rds_ibdev->refcount);
> +				rds_ib_dev_get(rds_ibdev);
>  				rcu_read_unlock();
>  				return rds_ibdev;
>  			}
> @@ -139,7 +139,7 @@ void rds_ib_add_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *con
>  	spin_unlock_irq(&ib_nodev_conns_lock);
>
>  	ic->rds_ibdev = rds_ibdev;
> -	refcount_inc(&rds_ibdev->refcount);
> +	rds_ib_dev_get(rds_ibdev);
>  }
>
>  void rds_ib_remove_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *conn)
> diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> index 585e6b3..d5abe0e 100644
> --- a/net/rds/rdma.c
> +++ b/net/rds/rdma.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (c) 2007, 2017 Oracle and/or its affiliates. All rights reserved.
> + * Copyright (c) 2007, 2020 Oracle and/or its affiliates. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -84,7 +84,7 @@ static struct rds_mr *rds_mr_tree_walk(struct rb_root *root, u64 key,
>  	if (insert) {
>  		rb_link_node(&insert->r_rb_node, parent, p);
>  		rb_insert_color(&insert->r_rb_node, root);
> -		refcount_inc(&insert->r_refcount);
> +		rds_mr_get(insert);
>  	}
>  	return NULL;
>  }
> @@ -343,7 +343,7 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
>
>  	rdsdebug("RDS: get_mr key is %x\n", mr->r_key);
>  	if (mr_ret) {
> -		refcount_inc(&mr->r_refcount);
> +		rds_mr_get(mr);
>  		*mr_ret = mr;
>  	}
>
> @@ -827,7 +827,7 @@ int rds_cmsg_rdma_dest(struct rds_sock *rs, struct rds_message *rm,
>  	if (!mr)
>  		err = -EINVAL;	/* invalid r_key */
>  	else
> -		refcount_inc(&mr->r_refcount);
> +		rds_mr_get(mr);
>  	spin_unlock_irqrestore(&rs->rs_rdma_lock, flags);
>
>  	if (mr) {
> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index e4a6035..6a665fa 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h
> @@ -953,6 +953,11 @@ static inline void rds_mr_put(struct rds_mr *mr)
>  		__rds_put_mr_final(mr);
>  }
>
> +static inline void rds_mr_get(struct rds_mr *mr)
> +{
> +	refcount_inc(&mr->r_refcount);
> +}
> +
>  static inline bool rds_destroy_pending(struct rds_connection *conn)
>  {
>  	return !check_net(rds_conn_net(conn)) ||
> --
> 1.8.3.1
>

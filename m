Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7377C29A277
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 03:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504323AbgJ0CBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 22:01:06 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2420 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439618AbgJ0CBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 22:01:05 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CKw0f58lqz4yYd;
        Tue, 27 Oct 2020 10:01:06 +0800 (CST)
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 27 Oct 2020 10:01:02 +0800
Received: from [10.169.42.93] (10.169.42.93) by dggema772-chm.china.huawei.com
 (10.1.198.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1913.5; Tue, 27
 Oct 2020 10:01:01 +0800
Subject: Re: [PATCH] RDMA: Add rdma_connect_locked()
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        Doug Ledford <dledford@redhat.com>,
        "Christoph Hellwig" <hch@lst.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Keith Busch <kbusch@kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
CC:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>
References: <0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com>
From:   Chao Leng <lengchao@huawei.com>
Message-ID: <e13ec119-3cc6-87ab-bc76-d2d3de7631e4@huawei.com>
Date:   Tue, 27 Oct 2020 10:01:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.169.42.93]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggema772-chm.china.huawei.com (10.1.198.214)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/10/26 22:25, Jason Gunthorpe wrote:
> There are two flows for handling RDMA_CM_EVENT_ROUTE_RESOLVED, either the
> handler triggers a completion and another thread does rdma_connect() or
> the handler directly calls rdma_connect().
> 
> In all cases rdma_connect() needs to hold the handler_mutex, but when
> handler's are invoked this is already held by the core code. This causes
> ULPs using the 2nd method to deadlock.
> 
> Provide a rdma_connect_locked() and have all ULPs call it from their
> handlers.
> 
> Reported-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> Fixes: 2a7cec538169 ("RDMA/cma: Fix locking for the RDMA_CM_CONNECT state"
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/infiniband/core/cma.c            | 39 +++++++++++++++++++++---
>   drivers/infiniband/ulp/iser/iser_verbs.c |  2 +-
>   drivers/infiniband/ulp/rtrs/rtrs-clt.c   |  4 +--
>   drivers/nvme/host/rdma.c                 | 10 +++---
>   include/rdma/rdma_cm.h                   | 13 +-------
>   net/rds/ib_cm.c                          |  5 +--
>   6 files changed, 47 insertions(+), 26 deletions(-)
> 
> Seems people are not testing these four ULPs against rdma-next.. Here is a
> quick fix for the issue:
> 
> https://lore.kernel.org/r/3b1f7767-98e2-93e0-b718-16d1c5346140@cloud.ionos.com
> 
> Jason
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 7c2ab1f2fbea37..2eaaa1292fb847 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -405,10 +405,10 @@ static int cma_comp_exch(struct rdma_id_private *id_priv,
>   	/*
>   	 * The FSM uses a funny double locking where state is protected by both
>   	 * the handler_mutex and the spinlock. State is not allowed to change
> -	 * away from a handler_mutex protected value without also holding
> +	 * to/from a handler_mutex protected value without also holding
>   	 * handler_mutex.
>   	 */
> -	if (comp == RDMA_CM_CONNECT)
> +	if (comp == RDMA_CM_CONNECT || exch == RDMA_CM_CONNECT)
>   		lockdep_assert_held(&id_priv->handler_mutex);
>   
>   	spin_lock_irqsave(&id_priv->lock, flags);
> @@ -4038,13 +4038,20 @@ static int cma_connect_iw(struct rdma_id_private *id_priv,
>   	return ret;
>   }
>   
> -int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
> +/**
> + * rdma_connect_locked - Initiate an active connection request.
> + * @id: Connection identifier to connect.
> + * @conn_param: Connection information used for connected QPs.
> + *
> + * Same as rdma_connect() but can only be called from the
> + * RDMA_CM_EVENT_ROUTE_RESOLVED handler callback.
> + */
> +int rdma_connect_locked(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
>   {
>   	struct rdma_id_private *id_priv =
>   		container_of(id, struct rdma_id_private, id);
>   	int ret;
>   
> -	mutex_lock(&id_priv->handler_mutex);
>   	if (!cma_comp_exch(id_priv, RDMA_CM_ROUTE_RESOLVED, RDMA_CM_CONNECT)) {
>   		ret = -EINVAL;
>   		goto err_unlock;
> @@ -4071,6 +4078,30 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
>   err_state:
>   	cma_comp_exch(id_priv, RDMA_CM_CONNECT, RDMA_CM_ROUTE_RESOLVED);
>   err_unlock:
> +	return ret;
> +}
> +EXPORT_SYMBOL(rdma_connect_locked);
> +
> +/**
> + * rdma_connect - Initiate an active connection request.
> + * @id: Connection identifier to connect.
> + * @conn_param: Connection information used for connected QPs.
> + *
> + * Users must have resolved a route for the rdma_cm_id to connect with by having
> + * called rdma_resolve_route before calling this routine.
> + *
> + * This call will either connect to a remote QP or obtain remote QP information
> + * for unconnected rdma_cm_id's.  The actual operation is based on the
> + * rdma_cm_id's port space.
> + */
> +int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
> +{
> +	struct rdma_id_private *id_priv =
> +		container_of(id, struct rdma_id_private, id);
> +	int ret;
> +
> +	mutex_lock(&id_priv->handler_mutex);
> +	ret = rdma_connect_locked(id, conn_param);
>   	mutex_unlock(&id_priv->handler_mutex);
>   	return ret;
>   }
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
> index 2f3ebc0a75d924..2bd18b00689341 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -620,7 +620,7 @@ static void iser_route_handler(struct rdma_cm_id *cma_id)
>   	conn_param.private_data	= (void *)&req_hdr;
>   	conn_param.private_data_len = sizeof(struct iser_cm_hdr);
>   
> -	ret = rdma_connect(cma_id, &conn_param);
> +	ret = rdma_connect_locked(cma_id, &conn_param);
>   	if (ret) {
>   		iser_err("failure connecting: %d\n", ret);
>   		goto failure;
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> index 776e89231c52f7..f298adc02acba2 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -1674,9 +1674,9 @@ static int rtrs_rdma_route_resolved(struct rtrs_clt_con *con)
>   	uuid_copy(&msg.sess_uuid, &sess->s.uuid);
>   	uuid_copy(&msg.paths_uuid, &clt->paths_uuid);
>   
> -	err = rdma_connect(con->c.cm_id, &param);
> +	err = rdma_connect_locked(con->c.cm_id, &param);
>   	if (err)
> -		rtrs_err(clt, "rdma_connect(): %d\n", err);
> +		rtrs_err(clt, "rdma_connect_locked(): %d\n", err);
>   
>   	return err;
>   }
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index aad829a2b50d0f..f488dc5f4c2c61 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -1730,11 +1730,10 @@ static void nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
>   	req->result = cqe->result;
>   
>   	if (wc->wc_flags & IB_WC_WITH_INVALIDATE) {
> -		if (unlikely(!req->mr ||
> -			     wc->ex.invalidate_rkey != req->mr->rkey)) {
> +		if (unlikely(wc->ex.invalidate_rkey != req->mr->rkey)) {
>   			dev_err(queue->ctrl->ctrl.device,
>   				"Bogus remote invalidation for rkey %#x\n",
> -				req->mr ? req->mr->rkey : 0);
> +				req->mr->rkey);
Maybe the code version is incorrect, cause falsely code rollback.
>   			nvme_rdma_error_recovery(queue->ctrl);
>   		}
>   	} else if (req->mr) {
> @@ -1890,10 +1889,10 @@ static int nvme_rdma_route_resolved(struct nvme_rdma_queue *queue)
>   		priv.hsqsize = cpu_to_le16(queue->ctrl->ctrl.sqsize);
>   	}
>   
> -	ret = rdma_connect(queue->cm_id, &param);
> +	ret = rdma_connect_locked(queue->cm_id, &param);
>   	if (ret) {
>   		dev_err(ctrl->ctrl.device,
> -			"rdma_connect failed (%d).\n", ret);
> +			"rdma_connect_locked failed (%d).\n", ret);
>   		goto out_destroy_queue_ib;
>   	}
>   
> @@ -1927,6 +1926,7 @@ static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
>   		complete(&queue->cm_done);
>   		return 0;
>   	case RDMA_CM_EVENT_REJECTED:
> +		nvme_rdma_destroy_queue_ib(queue);
Maybe the code version is incorrect, cause falsely code rollback.
>   		cm_error = nvme_rdma_conn_rejected(queue, ev);
>   		break;
>   	case RDMA_CM_EVENT_ROUTE_ERROR:
> diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
> index c672ae1da26bb5..937d55611cd073 100644
> --- a/include/rdma/rdma_cm.h
> +++ b/include/rdma/rdma_cm.h
> @@ -227,19 +227,8 @@ void rdma_destroy_qp(struct rdma_cm_id *id);
>   int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
>   		       int *qp_attr_mask);
>   
> -/**
> - * rdma_connect - Initiate an active connection request.
> - * @id: Connection identifier to connect.
> - * @conn_param: Connection information used for connected QPs.
> - *
> - * Users must have resolved a route for the rdma_cm_id to connect with
> - * by having called rdma_resolve_route before calling this routine.
> - *
> - * This call will either connect to a remote QP or obtain remote QP
> - * information for unconnected rdma_cm_id's.  The actual operation is
> - * based on the rdma_cm_id's port space.
> - */
>   int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param);
> +int rdma_connect_locked(struct rdma_cm_id *id, struct rdma_conn_param *conn_param);
>   
>   int rdma_connect_ece(struct rdma_cm_id *id, struct rdma_conn_param *conn_param,
>   		     struct rdma_ucm_ece *ece);
> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 06603dd1c8aa38..b36b60668b1da9 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -956,9 +956,10 @@ int rds_ib_cm_initiate_connect(struct rdma_cm_id *cm_id, bool isv6)
>   	rds_ib_cm_fill_conn_param(conn, &conn_param, &dp,
>   				  conn->c_proposed_version,
>   				  UINT_MAX, UINT_MAX, isv6);
> -	ret = rdma_connect(cm_id, &conn_param);
> +	ret = rdma_connect_locked(cm_id, &conn_param);
>   	if (ret)
> -		rds_ib_conn_error(conn, "rdma_connect failed (%d)\n", ret);
> +		rds_ib_conn_error(conn, "rdma_connect_locked failed (%d)\n",
> +				  ret);
>   
>   out:
>   	/* Beware - returning non-zero tells the rdma_cm to destroy
> 

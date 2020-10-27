Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CE429AD15
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 14:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751929AbgJ0NTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 09:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2442416AbgJ0NTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 09:19:41 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0357020829;
        Tue, 27 Oct 2020 13:19:39 +0000 (UTC)
Date:   Tue, 27 Oct 2020 15:19:36 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-rdma@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Christoph Hellwig <hch@lst.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Chao Leng <lengchao@huawei.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH rdma v2] RDMA: Add rdma_connect_locked()
Message-ID: <20201027131936.GD1763578@unreal>
References: <0-v2-53c22d5c1405+33-rdma_connect_locking_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v2-53c22d5c1405+33-rdma_connect_locking_jgg@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 09:20:36AM -0300, Jason Gunthorpe wrote:
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
> Link: https://lore.kernel.org/r/0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com
> Reported-and-tested-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> Fixes: 2a7cec538169 ("RDMA/cma: Fix locking for the RDMA_CM_CONNECT state")
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/infiniband/core/cma.c            | 40 +++++++++++++++++++++---
>  drivers/infiniband/ulp/iser/iser_verbs.c |  2 +-
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c   |  4 +--
>  drivers/nvme/host/rdma.c                 |  4 +--
>  include/rdma/rdma_cm.h                   | 14 ++-------
>  net/rds/ib_cm.c                          |  5 +--
>  6 files changed, 46 insertions(+), 23 deletions(-)
>
> v2:
>  - Remove extra code from nvme (Chao)
>  - Fix long lines (CH)
>
> I've applied this version to rdma-rc - expecting to get these ULPs unbroken for rc2
> release
>
> Thanks,
> Jason
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 7c2ab1f2fbea37..193c8902b9db26 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -405,10 +405,10 @@ static int cma_comp_exch(struct rdma_id_private *id_priv,
>  	/*
>  	 * The FSM uses a funny double locking where state is protected by both
>  	 * the handler_mutex and the spinlock. State is not allowed to change
> -	 * away from a handler_mutex protected value without also holding
> +	 * to/from a handler_mutex protected value without also holding
>  	 * handler_mutex.
>  	 */
> -	if (comp == RDMA_CM_CONNECT)
> +	if (comp == RDMA_CM_CONNECT || exch == RDMA_CM_CONNECT)
>  		lockdep_assert_held(&id_priv->handler_mutex);
>
>  	spin_lock_irqsave(&id_priv->lock, flags);
> @@ -4038,13 +4038,21 @@ static int cma_connect_iw(struct rdma_id_private *id_priv,
>  	return ret;
>  }
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
> +int rdma_connect_locked(struct rdma_cm_id *id,
> +			struct rdma_conn_param *conn_param)
>  {
>  	struct rdma_id_private *id_priv =
>  		container_of(id, struct rdma_id_private, id);
>  	int ret;
>
> -	mutex_lock(&id_priv->handler_mutex);
>  	if (!cma_comp_exch(id_priv, RDMA_CM_ROUTE_RESOLVED, RDMA_CM_CONNECT)) {
>  		ret = -EINVAL;
>  		goto err_unlock;

Not a big deal, but his label is not correct anymore.

Thanks

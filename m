Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4C03513F9
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 12:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhDAKz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 06:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234089AbhDAKy4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 06:54:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47C8D60FE8;
        Thu,  1 Apr 2021 10:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617274460;
        bh=LA75qGjL7UJw7E44jyn84WVVIzJMfOiXhPebs8eNjHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yrt3ghRSgrfMP5zoFkZWkHThnDJsyuv8M8M+ts37a+z2kbHroNiO46EExzl5+BAUV
         Epx+I5nyMf1iBTSqBjBZvGcf75GQm/Ixawn1yBuEi+17gs76xYPAZXq2yHogJNcIBm
         Rtj0SRlV/JUvfdugX+77+9z7kVoiijjljn6v2PulNaBH4ZA6bedwkrKLv2MS+nyNm5
         FHd1PTTwluwFE1ikC9r+cwNW8Ijrny7bbBp+CiN/0Vp7VQM01A47aDcpI5uC3MDnCB
         Zy088J+v91XU4t4JCQF6xIoD7keHV491APyQOKhmczc+2aNcKruXZwXP7ZR944+GXR
         gLclVDMEFS72w==
Date:   Thu, 1 Apr 2021 13:54:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next v3 1/2] IB/cma: Introduce
 rdma_set_min_rnr_timer()
Message-ID: <YGWmWPx71CqNRSKZ@unreal>
References: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
 <1617216194-12890-2-git-send-email-haakon.bugge@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1617216194-12890-2-git-send-email-haakon.bugge@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 08:43:13PM +0200, Håkon Bugge wrote:
> Introduce the ability for kernel ULPs to adjust the minimum RNR Retry
> timer. The INIT -> RTR transition executed by RDMA CM will be used for
> this adjustment. This avoids an additional ib_modify_qp() call.
> 
> rdma_set_min_rnr_timer() must be called before the call to
> rdma_connect() on the active side and before the call to rdma_accept()
> on the passive side.
> 
> The default value of RNR Retry timer is zero, which translates to 655
> ms. When the receiver is not ready to accept a send messages, it
> encodes the RNR Retry timer value in the NAK. The requestor will then
> wait at least the specified time value before retrying the send.
> 
> The 5-bit value to be supplied to the rdma_set_min_rnr_timer() is
> documented in IBTA Table 45: "Encoding for RNR NAK Timer Field".
> 
> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
> Acked-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/infiniband/core/cma.c      | 41 ++++++++++++++++++++++++++++++++++++++
>  drivers/infiniband/core/cma_priv.h |  2 ++
>  include/rdma/rdma_cm.h             |  2 ++
>  3 files changed, 45 insertions(+)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 9409651..5ce097d 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -852,6 +852,7 @@ static void cma_id_put(struct rdma_id_private *id_priv)
>  	id_priv->id.qp_type = qp_type;
>  	id_priv->tos_set = false;
>  	id_priv->timeout_set = false;
> +	id_priv->min_rnr_timer_set = false;
>  	id_priv->gid_type = IB_GID_TYPE_IB;
>  	spin_lock_init(&id_priv->lock);
>  	mutex_init(&id_priv->qp_mutex);
> @@ -1141,6 +1142,9 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
>  	if ((*qp_attr_mask & IB_QP_TIMEOUT) && id_priv->timeout_set)
>  		qp_attr->timeout = id_priv->timeout;
>  
> +	if ((*qp_attr_mask & IB_QP_MIN_RNR_TIMER) && id_priv->min_rnr_timer_set)
> +		qp_attr->min_rnr_timer = id_priv->min_rnr_timer;
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(rdma_init_qp_attr);
> @@ -2615,6 +2619,43 @@ int rdma_set_ack_timeout(struct rdma_cm_id *id, u8 timeout)
>  }
>  EXPORT_SYMBOL(rdma_set_ack_timeout);
>  
> +/**
> + * rdma_set_min_rnr_timer() - Set the minimum RNR Retry timer of the
> + *			      QP associated with a connection identifier.
> + * @id: Communication identifier to associated with service type.
> + * @min_rnr_timer: 5-bit value encoded as Table 45: "Encoding for RNR NAK
> + *		   Timer Field" in the IBTA specification.
> + *
> + * This function should be called before rdma_connect() on active
> + * side, and on passive side before rdma_accept(). The timer value
> + * will be associated with the local QP. When it receives a send it is
> + * not read to handle, typically if the receive queue is empty, an RNR
> + * Retry NAK is returned to the requester with the min_rnr_timer
> + * encoded. The requester will then wait at least the time specified
> + * in the NAK before retrying. The default is zero, which translates
> + * to a minimum RNR Timer value of 655 ms.
> + *
> + * Return: 0 for success
> + */
> +int rdma_set_min_rnr_timer(struct rdma_cm_id *id, u8 min_rnr_timer)
> +{
> +	struct rdma_id_private *id_priv;
> +
> +	/* It is a five-bit value */
> +	if (min_rnr_timer & 0xe0)
> +		return -EINVAL;
> +
> +	if (id->qp_type != IB_QPT_RC && id->qp_type != IB_QPT_XRC_TGT)
> +		return -EINVAL;

This is in-kernel API and safe to use WARN_ON() instead of returning
error which RDS is not checking anyway.

Thanks

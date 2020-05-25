Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3850D1E1402
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389200AbgEYSWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387644AbgEYSWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 14:22:47 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2570020776;
        Mon, 25 May 2020 18:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590430966;
        bh=Gy7JN0egwXN2SgYVpE2AsuZLSDXEWOyY8sqXQWbsPBA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MxaIn1llvFygsrrxXTuxW9cCaD+zV2lXlWmezhft4hiO6nXFpiT81GpUwi6JxOL0I
         wY0R1IFnzxEseNfaSkqYiUxtGQdcvbKLyvJASlKjO7J5u0YRd5DmwrRQ5trSykZT2V
         tDceJBtfBkBkm/0r3heLEBQjedD8bjS/cqLXN4gY=
Date:   Mon, 25 May 2020 21:22:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        target-devel@vger.kernel.org
Subject: Re: [PATCH rdma-next v2 7/7] RDMA/cma: Provide ECE reject reason
Message-ID: <20200525182242.GK10591@unreal>
References: <20200413141538.935574-1-leon@kernel.org>
 <20200413141538.935574-8-leon@kernel.org>
 <20200525181417.GC24366@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525181417.GC24366@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 03:14:17PM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 13, 2020 at 05:15:38PM +0300, Leon Romanovsky wrote:
> > @@ -4223,7 +4223,7 @@ int rdma_notify(struct rdma_cm_id *id, enum ib_event_type event)
> >  EXPORT_SYMBOL(rdma_notify);
> >
> >  int rdma_reject(struct rdma_cm_id *id, const void *private_data,
> > -		u8 private_data_len)
> > +		u8 private_data_len, enum rdma_ucm_reject_reason reason)
> >  {
> >  	struct rdma_id_private *id_priv;
> >  	int ret;
> > @@ -4237,10 +4237,12 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
> >  			ret = cma_send_sidr_rep(id_priv, IB_SIDR_REJECT, 0,
> >  						private_data, private_data_len);
> >  		} else {
> > +			enum ib_cm_rej_reason r =
> > +				(reason) ?: IB_CM_REJ_CONSUMER_DEFINED;
> > +
> >  			trace_cm_send_rej(id_priv);
> > -			ret = ib_send_cm_rej(id_priv->cm_id.ib,
> > -					     IB_CM_REJ_CONSUMER_DEFINED, NULL,
> > -					     0, private_data, private_data_len);
> > +			ret = ib_send_cm_rej(id_priv->cm_id.ib, r, NULL, 0,
> > +					     private_data, private_data_len);
> >  		}
> >  	} else if (rdma_cap_iw_cm(id->device, id->port_num)) {
> >  		ret = iw_cm_reject(id_priv->cm_id.iw,
> > diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> > index d41598954cc4..99482dc5934b 100644
> > +++ b/drivers/infiniband/core/ucma.c
> > @@ -1178,12 +1178,17 @@ static ssize_t ucma_reject(struct ucma_file *file, const char __user *inbuf,
> >  	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
> >  		return -EFAULT;
> >
> > +	if (cmd.reason &&
> > +	    cmd.reason != RDMA_USER_CM_REJ_VENDOR_OPTION_NOT_SUPPORTED)
> > +		return -EINVAL;
>
> It would be clearer to set cmd.reason to IB_CM_REJ_CONSUMER_DEFINED at
> this point..
>
> if (!cmd.reason)
>    cmd.reason = IB_CM_REJ_CONSUMER_DEFINED
>
> if (cmd.reason != IB_CM_REJ_CONSUMER_DEFINED && cmd.reason !=
>     RDMA_USER_CM_REJ_VENDOR_OPTION_NOT_SUPPORTED)
>    return -EINVAL
>
> Esaier to follow and no reason userspace shouldn't be able to
> explicitly specifiy the reason's that it is allowed to use.
>
>
> > index 8d961d8b7cdb..f8781b132f62 100644
> > +++ b/include/rdma/rdma_cm.h
> > @@ -324,11 +324,12 @@ int __rdma_accept_ece(struct rdma_cm_id *id, struct rdma_conn_param *conn_param,
> >   */
> >  int rdma_notify(struct rdma_cm_id *id, enum ib_event_type event);
> >
> > +
> >  /**
>
> Extra hunk?
>
> >   * rdma_reject - Called to reject a connection request or response.
> >   */
> >  int rdma_reject(struct rdma_cm_id *id, const void *private_data,
> > -		u8 private_data_len);
> > +		u8 private_data_len, enum rdma_ucm_reject_reason reason);
> >
> >  /**
> >   * rdma_disconnect - This function disconnects the associated QP and
> > diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
> > index c4ca1412bcf9..e545f2de1e13 100644
> > +++ b/include/uapi/rdma/rdma_user_cm.h
> > @@ -78,6 +78,10 @@ enum rdma_ucm_port_space {
> >  	RDMA_PS_UDP   = 0x0111,
> >  };
> >
> > +enum rdma_ucm_reject_reason {
> > +	RDMA_USER_CM_REJ_VENDOR_OPTION_NOT_SUPPORTED = 35
> > +};
>
> not sure we need ABI defines for IBTA constants?

Do you want to give an option to write any number?
Right now, I'm enforcing only allowed by IBTA reason
and which is used in user space.

Thanks

>
> Jason

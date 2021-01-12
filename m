Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2D42F3B51
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436546AbhALT5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:57:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406911AbhALT5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 14:57:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFC6F2311D;
        Tue, 12 Jan 2021 19:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610481390;
        bh=QE5TlA0Zxl753B5gdVcNGFk+7dY12Wdf4JiOwh97kMg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g7rCUMsrCQ2X7H1U08IwYi4wWoL7T0Y0P2bVTUayy+as8t43JqpteevAgBcUtGUrT
         Yl5xUX4tn1+dPYe9n6N8iLYDvcc8be4gL/pN8n52e2qIkSzAfrLQRbVsWcanB6sznc
         LpHZdOEXKD1PhbJjC74tI65kfcH828g38r5VClYtBJh0Sc6pFMvBPFe95ZDgB4M0KE
         FLTxnaaO3Q6+zfSP4WZcaCmW2Pcok3o21/+gLc5+LcDIfFDRwgaYg0PMdBnRTbQWGz
         VaMsU9+ZYgkJco6XYjMWvhEnFdG2FJHwXVOXdM85v+R2pf6QjCb4qr+lZd7irUVPuV
         NbY1tw+9emgeA==
Message-ID: <47e7f34d0c8a14eefba6aac00b08fc39cab61679.camel@kernel.org>
Subject: Re: [PATCH net-next v2 5/7] ibmvnic: serialize access to work queue
From:   Saeed Mahameed <saeed@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>, netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Date:   Tue, 12 Jan 2021 11:56:28 -0800
In-Reply-To: <20210112181441.206545-6-sukadev@linux.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
         <20210112181441.206545-6-sukadev@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-12 at 10:14 -0800, Sukadev Bhattiprolu wrote:
> The work queue is used to queue reset requests like CHANGE-PARAM or
> FAILOVER resets for the worker thread. When the adapter is being
> removed
> the adapter state is set to VNIC_REMOVING and the work queue is
> flushed
> so no new work is added. However the check for adapter being removed
> is
> racy in that the adapter can go into REMOVING state just after we
> check
> and we might end up adding work just as it is being flushed (or
> after).
> 
> Use a new spin lock, ->remove_lock to ensure that after (while) the
> work
> queue is (being) flushed, no new work is queued.
> 
> A follow-on patch will convert the existing ->state_lock from a spin
> lock
> to to a mutex to allow us to hold it for longer periods of time.
> Since
> work can be scheduled from a tasklet, we cannot block on the mutex,
> so
> use a new spin lock.
> 
> Fixes: 6954a9e4192b ("ibmvnic: Flush existing work items before
> device removal")
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 15 ++++++++++++++-
>  drivers/net/ethernet/ibm/ibmvnic.h |  2 ++
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index ad551418ac63..7645df37e886 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2435,6 +2435,7 @@ static int ibmvnic_reset(struct ibmvnic_adapter
> *adapter,
>  			 enum ibmvnic_reset_reason reason)
>  {
>  	struct net_device *netdev = adapter->netdev;
> +	unsigned long flags;
>  	int ret;
>  
>  	if (adapter->state == VNIC_PROBING) {
> @@ -2443,6 +2444,8 @@ static int ibmvnic_reset(struct ibmvnic_adapter
> *adapter,
>  		goto err;
>  	}
>  
> +	spin_lock_irqsave(&adapter->remove_lock, flags);
> +
>  	/*
>  	 * If failover is pending don't schedule any other reset.
>  	 * Instead let the failover complete. If there is already a
> @@ -2465,8 +2468,9 @@ static int ibmvnic_reset(struct ibmvnic_adapter
> *adapter,
>  	netdev_dbg(adapter->netdev, "Scheduling reset (reason %d)\n",
> reason);
>  	schedule_work(&adapter->ibmvnic_reset);
>  
> -	return 0;
> +	ret = 0;
>  err:
> +	spin_unlock_irqrestore(&adapter->remove_lock, flags);
>  	return -ret;
>  }
>  
> @@ -5387,6 +5391,7 @@ static int ibmvnic_probe(struct vio_dev *dev,
> const struct vio_device_id *id)
>  	memset(&adapter->pending_resets, 0, sizeof(adapter-
> >pending_resets));
>  	spin_lock_init(&adapter->rwi_lock);
>  	spin_lock_init(&adapter->state_lock);
> +	spin_lock_init(&adapter->remove_lock);
>  	mutex_init(&adapter->fw_lock);
>  	init_completion(&adapter->init_done);
>  	init_completion(&adapter->fw_done);
> @@ -5467,7 +5472,15 @@ static int ibmvnic_remove(struct vio_dev *dev)
>  		return -EBUSY;
>  	}
>  
> +	/* If ibmvnic_reset() is scheduling a reset, wait for it to
> +	 * finish. Then prevent it from scheduling any more resets
> +	 * and have the reset functions ignore any resets that have
> +	 * already been scheduled.
> +	 */
> +	spin_lock_irqsave(&adapter->remove_lock, flags);
>  	adapter->state = VNIC_REMOVING;
> +	spin_unlock_irqrestore(&adapter->remove_lock, flags);
> +

Why irqsave/restore variants ? are you expecting this spinlock to be
held in interruptcontext ?

>  	spin_unlock_irqrestore(&adapter->state_lock, flags);
>  
>  	flush_work(&adapter->ibmvnic_reset);
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.h
> b/drivers/net/ethernet/ibm/ibmvnic.h
> index 1179a95a3f92..2779696ade09 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.h
> +++ b/drivers/net/ethernet/ibm/ibmvnic.h
> @@ -1081,6 +1081,8 @@ struct ibmvnic_adapter {
>  	spinlock_t rwi_lock;
>  	enum ibmvnic_reset_reason pending_resets[VNIC_RESET_MAX-1];
>  	short next_reset;
> +	/* serialize ibmvnic_reset() and ibmvnic_remove() */
> +	spinlock_t remove_lock;
>  	struct work_struct ibmvnic_reset;
>  	struct delayed_work ibmvnic_delayed_reset;
>  	unsigned long resetting;


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651DE3707E3
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhEAQat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:30:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:38772 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230195AbhEAQat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 May 2021 12:30:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B8F45B15B;
        Sat,  1 May 2021 16:29:57 +0000 (UTC)
Subject: Re: [RFC PATCH v4 12/27] nvme-tcp-offload: Add controller level error
 recovery implementation
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com,
        Arie Gershberg <agershberg@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-13-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <92371529-22a2-cb2e-9a6f-4ecb606adaf5@suse.de>
Date:   Sat, 1 May 2021 18:29:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-13-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
> From: Arie Gershberg <agershberg@marvell.com>
> 
> In this patch, we implement controller level error handling and recovery.
> Upon an error discovered by the ULP or reset controller initiated by the
> nvme-core (using reset_ctrl workqueue), the ULP will initiate a controller
> recovery which includes teardown and re-connect of all queues.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Arie Gershberg <agershberg@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/host/tcp-offload.c | 138 +++++++++++++++++++++++++++++++-
>   drivers/nvme/host/tcp-offload.h |   1 +
>   2 files changed, 137 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> index 59e1955e02ec..9082b11c133f 100644
> --- a/drivers/nvme/host/tcp-offload.c
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -74,6 +74,23 @@ void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev)
>   }
>   EXPORT_SYMBOL_GPL(nvme_tcp_ofld_unregister_dev);
>   
> +/**
> + * nvme_tcp_ofld_error_recovery() - NVMeTCP Offload Library error recovery.
> + * function.
> + * @nctrl:	NVMe controller instance to change to resetting.
> + *
> + * API function that change the controller state to resseting.
> + * Part of the overall controller reset sequence.
> + */
> +void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl)
> +{
> +	if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_RESETTING))
> +		return;
> +
> +	queue_work(nvme_reset_wq, &to_tcp_ofld_ctrl(nctrl)->err_work);
> +}
> +EXPORT_SYMBOL_GPL(nvme_tcp_ofld_error_recovery);
> +
>   /**
>    * nvme_tcp_ofld_report_queue_err() - NVMeTCP Offload report error event
>    * callback function. Pointed to by nvme_tcp_ofld_queue->report_err.
> @@ -84,7 +101,8 @@ EXPORT_SYMBOL_GPL(nvme_tcp_ofld_unregister_dev);
>    */
>   int nvme_tcp_ofld_report_queue_err(struct nvme_tcp_ofld_queue *queue)
>   {
> -	/* Placeholder - invoke error recovery flow */
> +	pr_err("nvme-tcp-offload queue error\n");
> +	nvme_tcp_ofld_error_recovery(&queue->ctrl->nctrl);
>   
>   	return 0;
>   }
> @@ -296,6 +314,28 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
>   	return rc;
>   }
>   
> +static void nvme_tcp_ofld_reconnect_or_remove(struct nvme_ctrl *nctrl)
> +{
> +	/* If we are resetting/deleting then do nothing */
> +	if (nctrl->state != NVME_CTRL_CONNECTING) {
> +		WARN_ON_ONCE(nctrl->state == NVME_CTRL_NEW ||
> +			     nctrl->state == NVME_CTRL_LIVE);
> +
> +		return;
> +	}
> +
> +	if (nvmf_should_reconnect(nctrl)) {
> +		dev_info(nctrl->device, "Reconnecting in %d seconds...\n",
> +			 nctrl->opts->reconnect_delay);
> +		queue_delayed_work(nvme_wq,
> +				   &to_tcp_ofld_ctrl(nctrl)->connect_work,
> +				   nctrl->opts->reconnect_delay * HZ);
> +	} else {
> +		dev_info(nctrl->device, "Removing controller...\n");
> +		nvme_delete_ctrl(nctrl);
> +	}
> +}
> +
>   static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
>   {
>   	struct nvmf_ctrl_options *opts = nctrl->opts;
> @@ -407,10 +447,68 @@ nvme_tcp_ofld_teardown_io_queues(struct nvme_ctrl *nctrl, bool remove)
>   	/* Placeholder - teardown_io_queues */
>   }
>   
> +static void nvme_tcp_ofld_reconnect_ctrl_work(struct work_struct *work)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl =
> +				container_of(to_delayed_work(work),
> +					     struct nvme_tcp_ofld_ctrl,
> +					     connect_work);
> +	struct nvme_ctrl *nctrl = &ctrl->nctrl;
> +
> +	++nctrl->nr_reconnects;
> +
> +	if (ctrl->dev->ops->setup_ctrl(ctrl, false))
> +		goto requeue;
> +
> +	if (nvme_tcp_ofld_setup_ctrl(nctrl, false))
> +		goto release_and_requeue;
> +
> +	dev_info(nctrl->device, "Successfully reconnected (%d attempt)\n",
> +		 nctrl->nr_reconnects);
> +
> +	nctrl->nr_reconnects = 0;
> +
> +	return;
> +
> +release_and_requeue:
> +	ctrl->dev->ops->release_ctrl(ctrl);
> +requeue:
> +	dev_info(nctrl->device, "Failed reconnect attempt %d\n",
> +		 nctrl->nr_reconnects);
> +	nvme_tcp_ofld_reconnect_or_remove(nctrl);
> +}
> +
> +static void nvme_tcp_ofld_error_recovery_work(struct work_struct *work)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl =
> +		container_of(work, struct nvme_tcp_ofld_ctrl, err_work);
> +	struct nvme_ctrl *nctrl = &ctrl->nctrl;
> +
> +	nvme_stop_keep_alive(nctrl);
> +	nvme_tcp_ofld_teardown_io_queues(nctrl, false);
> +	/* unquiesce to fail fast pending requests */
> +	nvme_start_queues(nctrl);
> +	nvme_tcp_ofld_teardown_admin_queue(nctrl, false);
> +	blk_mq_unquiesce_queue(nctrl->admin_q);
> +
> +	if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_CONNECTING)) {
> +		/* state change failure is ok if we started nctrl delete */
> +		WARN_ON_ONCE(nctrl->state != NVME_CTRL_DELETING &&
> +			     nctrl->state != NVME_CTRL_DELETING_NOIO);
> +
> +		return;
> +	}
> +
> +	nvme_tcp_ofld_reconnect_or_remove(nctrl);
> +}
> +
>   static void
>   nvme_tcp_ofld_teardown_ctrl(struct nvme_ctrl *nctrl, bool shutdown)
>   {
> -	/* Placeholder - err_work and connect_work */
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +
> +	cancel_work_sync(&ctrl->err_work);
> +	cancel_delayed_work_sync(&ctrl->connect_work);
>   	nvme_tcp_ofld_teardown_io_queues(nctrl, shutdown);
>   	blk_mq_quiesce_queue(nctrl->admin_q);
>   	if (shutdown)
> @@ -425,6 +523,38 @@ static void nvme_tcp_ofld_delete_ctrl(struct nvme_ctrl *nctrl)
>   	nvme_tcp_ofld_teardown_ctrl(nctrl, true);
>   }
>   
> +static void nvme_tcp_ofld_reset_ctrl_work(struct work_struct *work)
> +{
> +	struct nvme_ctrl *nctrl =
> +		container_of(work, struct nvme_ctrl, reset_work);
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +
> +	nvme_stop_ctrl(nctrl);
> +	nvme_tcp_ofld_teardown_ctrl(nctrl, false);
> +
> +	if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_CONNECTING)) {
> +		/* state change failure is ok if we started ctrl delete */
> +		WARN_ON_ONCE(nctrl->state != NVME_CTRL_DELETING &&
> +			     nctrl->state != NVME_CTRL_DELETING_NOIO);
> +
> +		return;
> +	}
> +
> +	if (ctrl->dev->ops->setup_ctrl(ctrl, false))
> +		goto out_fail;
> +
> +	if (nvme_tcp_ofld_setup_ctrl(nctrl, false))
> +		goto release_ctrl;
> +
> +	return;
> +
> +release_ctrl:
> +	ctrl->dev->ops->release_ctrl(ctrl);
> +out_fail:
> +	++nctrl->nr_reconnects;
> +	nvme_tcp_ofld_reconnect_or_remove(nctrl);
> +}
> +
>   static int
>   nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
>   			   struct request *rq,
> @@ -521,6 +651,10 @@ nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
>   			     opts->nr_poll_queues + 1;
>   	nctrl->sqsize = opts->queue_size - 1;
>   	nctrl->kato = opts->kato;
> +	INIT_DELAYED_WORK(&ctrl->connect_work,
> +			  nvme_tcp_ofld_reconnect_ctrl_work);
> +	INIT_WORK(&ctrl->err_work, nvme_tcp_ofld_error_recovery_work);
> +	INIT_WORK(&nctrl->reset_work, nvme_tcp_ofld_reset_ctrl_work);
>   	if (!(opts->mask & NVMF_OPT_TRSVCID)) {
>   		opts->trsvcid =
>   			kstrdup(__stringify(NVME_TCP_DISC_PORT), GFP_KERNEL);
> diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-offload.h
> index 9fd270240eaa..b23b1d7ea6fa 100644
> --- a/drivers/nvme/host/tcp-offload.h
> +++ b/drivers/nvme/host/tcp-offload.h
> @@ -204,3 +204,4 @@ struct nvme_tcp_ofld_ops {
>   /* Exported functions for lower vendor specific offload drivers */
>   int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
>   void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
> +void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

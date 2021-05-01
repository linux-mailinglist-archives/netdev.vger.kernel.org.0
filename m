Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2153707E7
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhEAQg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:36:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:39632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230195AbhEAQg5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 May 2021 12:36:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4D50BAF4E;
        Sat,  1 May 2021 16:36:06 +0000 (UTC)
Subject: Re: [RFC PATCH v4 13/27] nvme-tcp-offload: Add queue level
 implementation
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-14-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c390a5d8-30b4-cc01-e8c9-98f09dacf0d0@suse.de>
Date:   Sat, 1 May 2021 18:36:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-14-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
> From: Dean Balandin <dbalandin@marvell.com>
> 
> In this patch we implement queue level functionality.
> The implementation is similar to the nvme-tcp module, the main
> difference being that we call the vendor specific create_queue op which
> creates the TCP connection, and NVMeTPC connection including
> icreq+icresp negotiation.
> Once create_queue returns successfully, we can move on to the fabrics
> connect.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/host/tcp-offload.c | 415 ++++++++++++++++++++++++++++++--
>   drivers/nvme/host/tcp-offload.h |   2 +-
>   2 files changed, 390 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> index 9082b11c133f..8ddce2257100 100644
> --- a/drivers/nvme/host/tcp-offload.c
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -22,6 +22,11 @@ static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld_ctrl(struct nvme_ctrl *nctr
>   	return container_of(nctrl, struct nvme_tcp_ofld_ctrl, nctrl);
>   }
>   
> +static inline int nvme_tcp_ofld_qid(struct nvme_tcp_ofld_queue *queue)
> +{
> +	return queue - queue->ctrl->queues;
> +}
> +
>   /**
>    * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
>    * function.
> @@ -191,12 +196,94 @@ nvme_tcp_ofld_alloc_tagset(struct nvme_ctrl *nctrl, bool admin)
>   	return set;
>   }
>   
> +static void __nvme_tcp_ofld_stop_queue(struct nvme_tcp_ofld_queue *queue)
> +{
> +	queue->dev->ops->drain_queue(queue);
> +	queue->dev->ops->destroy_queue(queue);
> +}
> +
> +static void nvme_tcp_ofld_stop_queue(struct nvme_ctrl *nctrl, int qid)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[qid];
> +
> +	if (!test_and_clear_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags))
> +		return;
> +
> +	__nvme_tcp_ofld_stop_queue(queue);
> +}
> +
> +static void nvme_tcp_ofld_stop_io_queues(struct nvme_ctrl *ctrl)
> +{
> +	int i;
> +
> +	for (i = 1; i < ctrl->queue_count; i++)
> +		nvme_tcp_ofld_stop_queue(ctrl, i);
> +}
> +
> +static void nvme_tcp_ofld_free_queue(struct nvme_ctrl *nctrl, int qid)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[qid];
> +
> +	if (!test_and_clear_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags))
> +		return;
> +
> +	queue = &ctrl->queues[qid];
> +	queue->ctrl = NULL;
> +	queue->dev = NULL;
> +	queue->report_err = NULL;
> +}
> +
> +static void nvme_tcp_ofld_destroy_admin_queue(struct nvme_ctrl *nctrl, bool remove)
> +{
> +	nvme_tcp_ofld_stop_queue(nctrl, 0);
> +	if (remove) {
> +		blk_cleanup_queue(nctrl->admin_q);
> +		blk_cleanup_queue(nctrl->fabrics_q);
> +		blk_mq_free_tag_set(nctrl->admin_tagset);
> +	}
> +}
> +
> +static int nvme_tcp_ofld_start_queue(struct nvme_ctrl *nctrl, int qid)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[qid];
> +	int rc;
> +
> +	queue = &ctrl->queues[qid];
> +	if (qid) {
> +		queue->cmnd_capsule_len = nctrl->ioccsz * 16;
> +		rc = nvmf_connect_io_queue(nctrl, qid, false);
> +	} else {
> +		queue->cmnd_capsule_len = sizeof(struct nvme_command) + NVME_TCP_ADMIN_CCSZ;
> +		rc = nvmf_connect_admin_queue(nctrl);
> +	}
> +
> +	if (!rc) {
> +		set_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags);
> +	} else {
> +		if (test_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags))
> +			__nvme_tcp_ofld_stop_queue(queue);
> +		dev_err(nctrl->device,
> +			"failed to connect queue: %d ret=%d\n", qid, rc);
> +	}
> +
> +	return rc;
> +}
> +
>   static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
>   					       bool new)
>   {
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[0];
>   	int rc;
>   
> -	/* Placeholder - alloc_admin_queue */
> +	rc = ctrl->dev->ops->create_queue(queue, 0, NVME_AQ_DEPTH);
> +	if (rc)
> +		return rc;
> +
> +	set_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags);
>   	if (new) {
>   		nctrl->admin_tagset =
>   				nvme_tcp_ofld_alloc_tagset(nctrl, true);
> @@ -221,7 +308,9 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
>   		}
>   	}
>   
> -	/* Placeholder - nvme_tcp_ofld_start_queue */
> +	rc = nvme_tcp_ofld_start_queue(nctrl, 0);
> +	if (rc)
> +		goto out_cleanup_queue;
>   
>   	rc = nvme_enable_ctrl(nctrl);
>   	if (rc)
> @@ -238,11 +327,12 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
>   out_quiesce_queue:
>   	blk_mq_quiesce_queue(nctrl->admin_q);
>   	blk_sync_queue(nctrl->admin_q);
> -
>   out_stop_queue:
> -	/* Placeholder - stop offload queue */
> +	nvme_tcp_ofld_stop_queue(nctrl, 0);
>   	nvme_cancel_admin_tagset(nctrl);
> -
> +out_cleanup_queue:
> +	if (new)
> +		blk_cleanup_queue(nctrl->admin_q);
>   out_cleanup_fabrics_q:
>   	if (new)
>   		blk_cleanup_queue(nctrl->fabrics_q);
> @@ -250,7 +340,127 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
>   	if (new)
>   		blk_mq_free_tag_set(nctrl->admin_tagset);
>   out_free_queue:
> -	/* Placeholder - free admin queue */
> +	nvme_tcp_ofld_free_queue(nctrl, 0);
> +
> +	return rc;
> +}
> +
> +static unsigned int nvme_tcp_ofld_nr_io_queues(struct nvme_ctrl *nctrl)
> +{
> +	unsigned int nr_io_queues;
> +
> +	nr_io_queues = min(nctrl->opts->nr_io_queues, num_online_cpus());
> +	nr_io_queues += min(nctrl->opts->nr_write_queues, num_online_cpus());
> +	nr_io_queues += min(nctrl->opts->nr_poll_queues, num_online_cpus());
> +
> +	return nr_io_queues;
> +}
> +

Really? Isn't this hardware-dependent?
I would have expected the hardware to impose some limitations here (# of 
MSIx interrupts or something). Hmm?

> +static void
> +nvme_tcp_ofld_set_io_queues(struct nvme_ctrl *nctrl, unsigned int nr_io_queues)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	struct nvmf_ctrl_options *opts = nctrl->opts;
> +
> +	if (opts->nr_write_queues && opts->nr_io_queues < nr_io_queues) {
> +		/*
> +		 * separate read/write queues
> +		 * hand out dedicated default queues only after we have
> +		 * sufficient read queues.
> +		 */
> +		ctrl->io_queues[HCTX_TYPE_READ] = opts->nr_io_queues;
> +		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_READ];
> +		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
> +			min(opts->nr_write_queues, nr_io_queues);
> +		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
> +	} else {
> +		/*
> +		 * shared read/write queues
> +		 * either no write queues were requested, or we don't have
> +		 * sufficient queue count to have dedicated default queues.
> +		 */
> +		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
> +			min(opts->nr_io_queues, nr_io_queues);
> +		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
> +	}
> +
> +	if (opts->nr_poll_queues && nr_io_queues) {
> +		/* map dedicated poll queues only if we have queues left */
> +		ctrl->io_queues[HCTX_TYPE_POLL] =
> +			min(opts->nr_poll_queues, nr_io_queues);
> +	}
> +}
> +

Same here.
Poll queues only ever make sense of the hardware can serve specific 
queue pairs without interrupts. Which again relates to the number of 
interrupts, and the affinity of those.
Or isn't this a concern with your card?

> +static void
> +nvme_tcp_ofld_terminate_io_queues(struct nvme_ctrl *nctrl, int start_from)
> +{
> +	int i;
> +
> +	/* admin-q will be ignored because of the loop condition */
> +	for (i = start_from; i >= 1; i--)
> +		nvme_tcp_ofld_stop_queue(nctrl, i);
> +}
> +

Loop condition? Care to elaborate?

> +static int nvme_tcp_ofld_create_io_queues(struct nvme_ctrl *nctrl)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	int i, rc;
> +
> +	for (i = 1; i < nctrl->queue_count; i++) {
> +		rc = ctrl->dev->ops->create_queue(&ctrl->queues[i],
> +						  i, nctrl->sqsize + 1);
> +		if (rc)
> +			goto out_free_queues;
> +
> +		set_bit(NVME_TCP_OFLD_Q_ALLOCATED, &ctrl->queues[i].flags);
> +	}
> +
> +	return 0;
> +
> +out_free_queues:
> +	nvme_tcp_ofld_terminate_io_queues(nctrl, --i);
> +
> +	return rc;
> +}
> +
> +static int nvme_tcp_ofld_alloc_io_queues(struct nvme_ctrl *nctrl)
> +{
> +	unsigned int nr_io_queues;
> +	int rc;
> +
> +	nr_io_queues = nvme_tcp_ofld_nr_io_queues(nctrl);
> +	rc = nvme_set_queue_count(nctrl, &nr_io_queues);
> +	if (rc)
> +		return rc;
> +
> +	nctrl->queue_count = nr_io_queues + 1;
> +	if (nctrl->queue_count < 2) {
> +		dev_err(nctrl->device,
> +			"unable to set any I/O queues\n");
> +
> +		return -ENOMEM;
> +	}
> +
> +	dev_info(nctrl->device, "creating %d I/O queues.\n", nr_io_queues);
> +	nvme_tcp_ofld_set_io_queues(nctrl, nr_io_queues);
> +
> +	return nvme_tcp_ofld_create_io_queues(nctrl);
> +}
> +
> +static int nvme_tcp_ofld_start_io_queues(struct nvme_ctrl *nctrl)
> +{
> +	int i, rc = 0;
> +
> +	for (i = 1; i < nctrl->queue_count; i++) {
> +		rc = nvme_tcp_ofld_start_queue(nctrl, i);
> +		if (rc)
> +			goto terminate_queues;
> +	}
> +
> +	return 0;
> +
> +terminate_queues:
> +	nvme_tcp_ofld_terminate_io_queues(nctrl, --i);
>   
>   	return rc;
>   }
> @@ -258,9 +468,10 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
>   static int
>   nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
>   {
> -	int rc;
> +	int rc = nvme_tcp_ofld_alloc_io_queues(nctrl);
>   
> -	/* Placeholder - alloc_io_queues */
> +	if (rc)
> +		return rc;
>   
>   	if (new) {
>   		nctrl->tagset = nvme_tcp_ofld_alloc_tagset(nctrl, false);
> @@ -278,7 +489,9 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
>   		}
>   	}
>   
> -	/* Placeholder - start_io_queues */
> +	rc = nvme_tcp_ofld_start_io_queues(nctrl);
> +	if (rc)
> +		goto out_cleanup_connect_q;
>   
>   	if (!new) {
>   		nvme_start_queues(nctrl);
> @@ -300,16 +513,16 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
>   out_wait_freeze_timed_out:
>   	nvme_stop_queues(nctrl);
>   	nvme_sync_io_queues(nctrl);
> -
> -	/* Placeholder - Stop IO queues */
> -
> +	nvme_tcp_ofld_stop_io_queues(nctrl);
> +out_cleanup_connect_q:
> +	nvme_cancel_tagset(nctrl);
>   	if (new)
>   		blk_cleanup_queue(nctrl->connect_q);
>   out_free_tag_set:
>   	if (new)
>   		blk_mq_free_tag_set(nctrl->tagset);
>   out_free_io_queues:
> -	/* Placeholder - free_io_queues */
> +	nvme_tcp_ofld_terminate_io_queues(nctrl, nctrl->queue_count);
>   
>   	return rc;
>   }
> @@ -336,6 +549,26 @@ static void nvme_tcp_ofld_reconnect_or_remove(struct nvme_ctrl *nctrl)
>   	}
>   }
>   
> +static int
> +nvme_tcp_ofld_init_admin_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> +			      unsigned int hctx_idx)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = data;
> +
> +	hctx->driver_data = &ctrl->queues[0];
> +
> +	return 0;
> +}
> +
> +static void nvme_tcp_ofld_destroy_io_queues(struct nvme_ctrl *nctrl, bool remove)
> +{
> +	nvme_tcp_ofld_stop_io_queues(nctrl);
> +	if (remove) {
> +		blk_cleanup_queue(nctrl->connect_q);
> +		blk_mq_free_tag_set(nctrl->tagset);
> +	}
> +}
> +
>   static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
>   {
>   	struct nvmf_ctrl_options *opts = nctrl->opts;
> @@ -387,9 +620,19 @@ static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
>   	return 0;
>   
>   destroy_io:
> -	/* Placeholder - stop and destroy io queues*/
> +	if (nctrl->queue_count > 1) {
> +		nvme_stop_queues(nctrl);
> +		nvme_sync_io_queues(nctrl);
> +		nvme_tcp_ofld_stop_io_queues(nctrl);
> +		nvme_cancel_tagset(nctrl);
> +		nvme_tcp_ofld_destroy_io_queues(nctrl, new);
> +	}
>   destroy_admin:
> -	/* Placeholder - stop and destroy admin queue*/
> +	blk_mq_quiesce_queue(nctrl->admin_q);
> +	blk_sync_queue(nctrl->admin_q);
> +	nvme_tcp_ofld_stop_queue(nctrl, 0);
> +	nvme_cancel_admin_tagset(nctrl);
> +	nvme_tcp_ofld_destroy_admin_queue(nctrl, new);
>   
>   	return rc;
>   }
> @@ -410,6 +653,18 @@ nvme_tcp_ofld_check_dev_opts(struct nvmf_ctrl_options *opts,
>   	return 0;
>   }
>   
> +static void nvme_tcp_ofld_free_ctrl_queues(struct nvme_ctrl *nctrl)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> +	int i;
> +
> +	for (i = 0; i < nctrl->queue_count; ++i)
> +		nvme_tcp_ofld_free_queue(nctrl, i);
> +
> +	kfree(ctrl->queues);
> +	ctrl->queues = NULL;
> +}
> +
>   static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
>   {
>   	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
> @@ -419,6 +674,7 @@ static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
>   		goto free_ctrl;
>   
>   	down_write(&nvme_tcp_ofld_ctrl_rwsem);
> +	nvme_tcp_ofld_free_ctrl_queues(nctrl);
>   	ctrl->dev->ops->release_ctrl(ctrl);
>   	list_del(&ctrl->list);
>   	up_write(&nvme_tcp_ofld_ctrl_rwsem);
> @@ -436,15 +692,37 @@ static void nvme_tcp_ofld_submit_async_event(struct nvme_ctrl *arg)
>   }
>   
>   static void
> -nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *ctrl, bool remove)
> +nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *nctrl, bool remove)
>   {
> -	/* Placeholder - teardown_admin_queue */
> +	blk_mq_quiesce_queue(nctrl->admin_q);
> +	blk_sync_queue(nctrl->admin_q);
> +
> +	nvme_tcp_ofld_stop_queue(nctrl, 0);
> +	nvme_cancel_admin_tagset(nctrl);
> +
> +	if (remove)
> +		blk_mq_unquiesce_queue(nctrl->admin_q);
> +
> +	nvme_tcp_ofld_destroy_admin_queue(nctrl, remove);
>   }
>   
>   static void
>   nvme_tcp_ofld_teardown_io_queues(struct nvme_ctrl *nctrl, bool remove)
>   {
> -	/* Placeholder - teardown_io_queues */
> +	if (nctrl->queue_count <= 1)
> +		return;
> +
> +	blk_mq_quiesce_queue(nctrl->admin_q);
> +	nvme_start_freeze(nctrl);
> +	nvme_stop_queues(nctrl);
> +	nvme_sync_io_queues(nctrl);
> +	nvme_tcp_ofld_stop_io_queues(nctrl);
> +	nvme_cancel_tagset(nctrl);
> +
> +	if (remove)
> +		nvme_start_queues(nctrl);
> +
> +	nvme_tcp_ofld_destroy_io_queues(nctrl, remove);
>   }
>   
>   static void nvme_tcp_ofld_reconnect_ctrl_work(struct work_struct *work)
> @@ -572,6 +850,17 @@ nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
>   	return 0;
>   }
>   
> +inline size_t nvme_tcp_ofld_inline_data_size(struct nvme_tcp_ofld_queue *queue)
> +{
> +	return queue->cmnd_capsule_len - sizeof(struct nvme_command);
> +}
> +EXPORT_SYMBOL_GPL(nvme_tcp_ofld_inline_data_size);
> +
> +static void nvme_tcp_ofld_commit_rqs(struct blk_mq_hw_ctx *hctx)
> +{
> +	/* Call ops->commit_rqs */
> +}
> +
>   static blk_status_t
>   nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
>   		       const struct blk_mq_queue_data *bd)
> @@ -583,22 +872,96 @@ nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
>   	return BLK_STS_OK;
>   }
>   
> +static void
> +nvme_tcp_ofld_exit_request(struct blk_mq_tag_set *set,
> +			   struct request *rq, unsigned int hctx_idx)
> +{
> +	/*
> +	 * Nothing is allocated in nvme_tcp_ofld_init_request,
> +	 * hence empty.
> +	 */
> +}
> +
> +static int
> +nvme_tcp_ofld_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> +			unsigned int hctx_idx)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = data;
> +
> +	hctx->driver_data = &ctrl->queues[hctx_idx + 1];
> +
> +	return 0;
> +}
> +
> +static int nvme_tcp_ofld_map_queues(struct blk_mq_tag_set *set)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl = set->driver_data;
> +	struct nvmf_ctrl_options *opts = ctrl->nctrl.opts;
> +
> +	if (opts->nr_write_queues && ctrl->io_queues[HCTX_TYPE_READ]) {
> +		/* separate read/write queues */
> +		set->map[HCTX_TYPE_DEFAULT].nr_queues =
> +			ctrl->io_queues[HCTX_TYPE_DEFAULT];
> +		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
> +		set->map[HCTX_TYPE_READ].nr_queues =
> +			ctrl->io_queues[HCTX_TYPE_READ];
> +		set->map[HCTX_TYPE_READ].queue_offset =
> +			ctrl->io_queues[HCTX_TYPE_DEFAULT];
> +	} else {
> +		/* shared read/write queues */
> +		set->map[HCTX_TYPE_DEFAULT].nr_queues =
> +			ctrl->io_queues[HCTX_TYPE_DEFAULT];
> +		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
> +		set->map[HCTX_TYPE_READ].nr_queues =
> +			ctrl->io_queues[HCTX_TYPE_DEFAULT];
> +		set->map[HCTX_TYPE_READ].queue_offset = 0;
> +	}
> +	blk_mq_map_queues(&set->map[HCTX_TYPE_DEFAULT]);
> +	blk_mq_map_queues(&set->map[HCTX_TYPE_READ]);
> +
> +	if (opts->nr_poll_queues && ctrl->io_queues[HCTX_TYPE_POLL]) {
> +		/* map dedicated poll queues only if we have queues left */
> +		set->map[HCTX_TYPE_POLL].nr_queues =
> +				ctrl->io_queues[HCTX_TYPE_POLL];
> +		set->map[HCTX_TYPE_POLL].queue_offset =
> +			ctrl->io_queues[HCTX_TYPE_DEFAULT] +
> +			ctrl->io_queues[HCTX_TYPE_READ];
> +		blk_mq_map_queues(&set->map[HCTX_TYPE_POLL]);
> +	}
> +
> +	dev_info(ctrl->nctrl.device,
> +		 "mapped %d/%d/%d default/read/poll queues.\n",
> +		 ctrl->io_queues[HCTX_TYPE_DEFAULT],
> +		 ctrl->io_queues[HCTX_TYPE_READ],
> +		 ctrl->io_queues[HCTX_TYPE_POLL]);
> +
> +	return 0;
> +}
> +
> +static int nvme_tcp_ofld_poll(struct blk_mq_hw_ctx *hctx)
> +{
> +	/* Placeholder - Implement polling mechanism */
> +
> +	return 0;
> +}
> +
>   static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
>   	.queue_rq	= nvme_tcp_ofld_queue_rq,
> +	.commit_rqs     = nvme_tcp_ofld_commit_rqs,
> +	.complete	= nvme_complete_rq,
>   	.init_request	= nvme_tcp_ofld_init_request,
> -	/*
> -	 * All additional ops will be also implemented and registered similar to
> -	 * tcp.c
> -	 */
> +	.exit_request	= nvme_tcp_ofld_exit_request,
> +	.init_hctx	= nvme_tcp_ofld_init_hctx,
> +	.map_queues	= nvme_tcp_ofld_map_queues,
> +	.poll		= nvme_tcp_ofld_poll,
>   };
>   
>   static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops = {
>   	.queue_rq	= nvme_tcp_ofld_queue_rq,
> +	.complete	= nvme_complete_rq,
>   	.init_request	= nvme_tcp_ofld_init_request,
> -	/*
> -	 * All additional ops will be also implemented and registered similar to
> -	 * tcp.c
> -	 */
> +	.exit_request	= nvme_tcp_ofld_exit_request,
> +	.init_hctx	= nvme_tcp_ofld_init_admin_hctx,
>   };
>   
>   static const struct nvme_ctrl_ops nvme_tcp_ofld_ctrl_ops = {
> diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-offload.h
> index b23b1d7ea6fa..d82645fcf9da 100644
> --- a/drivers/nvme/host/tcp-offload.h
> +++ b/drivers/nvme/host/tcp-offload.h
> @@ -105,7 +105,6 @@ struct nvme_tcp_ofld_ctrl {
>   	 * Each entry in the array indicates the number of queues of
>   	 * corresponding type.
>   	 */
> -	u32 queue_type_mapping[HCTX_MAX_TYPES];
>   	u32 io_queues[HCTX_MAX_TYPES];
>   
>   	/* Connectivity params */
> @@ -205,3 +204,4 @@ struct nvme_tcp_ofld_ops {
>   int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
>   void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
>   void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl);
> +inline size_t nvme_tcp_ofld_inline_data_size(struct nvme_tcp_ofld_queue *queue);
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF4A3707F1
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhEAQqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:46:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:41618 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231517AbhEAQqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 May 2021 12:46:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 218F2AF4E;
        Sat,  1 May 2021 16:45:15 +0000 (UTC)
Subject: Re: [RFC PATCH v4 15/27] nvme-tcp-offload: Add Timeout and ASYNC
 Support
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-16-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d762b4f0-c048-f9bd-a58b-fdbf3804e6a7@suse.de>
Date:   Sat, 1 May 2021 18:45:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-16-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
> In this patch, we present the nvme-tcp-offload timeout support
> nvme_tcp_ofld_timeout() and ASYNC support
> nvme_tcp_ofld_submit_async_event().
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/host/tcp-offload.c | 85 ++++++++++++++++++++++++++++++++-
>   drivers/nvme/host/tcp-offload.h |  2 +
>   2 files changed, 86 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> index 0cdf5a432208..1d62f921f109 100644
> --- a/drivers/nvme/host/tcp-offload.c
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -133,6 +133,26 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
>   		nvme_complete_rq(rq);
>   }
>   
> +/**
> + * nvme_tcp_ofld_async_req_done() - NVMeTCP Offload request done callback
> + * function for async request. Pointed to by nvme_tcp_ofld_req->done.
> + * Handles both NVME_TCP_F_DATA_SUCCESS flag and NVMe CQ.
> + * @req:	NVMeTCP offload request to complete.
> + * @result:     The nvme_result.
> + * @status:     The completion status.
> + *
> + * API function that allows the vendor specific offload driver to report request
> + * completions to the common offload layer.
> + */
> +void nvme_tcp_ofld_async_req_done(struct nvme_tcp_ofld_req *req,
> +				  union nvme_result *result, __le16 status)
> +{
> +	struct nvme_tcp_ofld_queue *queue = req->queue;
> +	struct nvme_tcp_ofld_ctrl *ctrl = queue->ctrl;
> +
> +	nvme_complete_async_event(&ctrl->nctrl, status, result);
> +}
> +
>   struct nvme_tcp_ofld_dev *
>   nvme_tcp_ofld_lookup_dev(struct nvme_tcp_ofld_ctrl *ctrl)
>   {
> @@ -719,7 +739,23 @@ void nvme_tcp_ofld_map_data(struct nvme_command *c, u32 data_len)
>   
>   static void nvme_tcp_ofld_submit_async_event(struct nvme_ctrl *arg)
>   {
> -	/* Placeholder - submit_async_event */
> +	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(arg);
> +	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[0];
> +	struct nvme_tcp_ofld_dev *dev = queue->dev;
> +	struct nvme_tcp_ofld_ops *ops = dev->ops;
> +
> +	ctrl->async_req.nvme_cmd.common.opcode = nvme_admin_async_event;
> +	ctrl->async_req.nvme_cmd.common.command_id = NVME_AQ_BLK_MQ_DEPTH;
> +	ctrl->async_req.nvme_cmd.common.flags |= NVME_CMD_SGL_METABUF;
> +
> +	nvme_tcp_ofld_set_sg_null(&ctrl->async_req.nvme_cmd);
> +
> +	ctrl->async_req.async = true;
> +	ctrl->async_req.queue = queue;
> +	ctrl->async_req.last = true;
> +	ctrl->async_req.done = nvme_tcp_ofld_async_req_done;
> +
> +	ops->send_req(&ctrl->async_req);
>   }
>   
>   static void
> @@ -1024,6 +1060,51 @@ static int nvme_tcp_ofld_poll(struct blk_mq_hw_ctx *hctx)
>   	return ops->poll_queue(queue);
>   }
>   
> +static void nvme_tcp_ofld_complete_timed_out(struct request *rq)
> +{
> +	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(rq);
> +	struct nvme_ctrl *nctrl = &req->queue->ctrl->nctrl;
> +
> +	nvme_tcp_ofld_stop_queue(nctrl, nvme_tcp_ofld_qid(req->queue));
> +	if (blk_mq_request_started(rq) && !blk_mq_request_completed(rq)) {
> +		nvme_req(rq)->status = NVME_SC_HOST_ABORTED_CMD;
> +		blk_mq_complete_request(rq);
> +	}
> +}
> +
> +static enum blk_eh_timer_return nvme_tcp_ofld_timeout(struct request *rq, bool reserved)
> +{
> +	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(rq);
> +	struct nvme_tcp_ofld_ctrl *ctrl = req->queue->ctrl;
> +
> +	dev_warn(ctrl->nctrl.device,
> +		 "queue %d: timeout request %#x type %d\n",
> +		 nvme_tcp_ofld_qid(req->queue), rq->tag, req->nvme_cmd.common.opcode);
> +
> +	if (ctrl->nctrl.state != NVME_CTRL_LIVE) {
> +		/*
> +		 * If we are resetting, connecting or deleting we should
> +		 * complete immediately because we may block controller
> +		 * teardown or setup sequence
> +		 * - ctrl disable/shutdown fabrics requests
> +		 * - connect requests
> +		 * - initialization admin requests
> +		 * - I/O requests that entered after unquiescing and
> +		 *   the controller stopped responding
> +		 *
> +		 * All other requests should be cancelled by the error
> +		 * recovery work, so it's fine that we fail it here.
> +		 */
> +		nvme_tcp_ofld_complete_timed_out(rq);
> +
> +		return BLK_EH_DONE;
> +	}

And this particular error code has been causing _so_ _many_ issues 
during testing, that I'd rather get rid of it altogether.
But probably not your fault, your just copying what tcp and rdma is doing.

> +
> +	nvme_tcp_ofld_error_recovery(&ctrl->nctrl);
> +
> +	return BLK_EH_RESET_TIMER;
> +}
> +
>   static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
>   	.queue_rq	= nvme_tcp_ofld_queue_rq,
>   	.commit_rqs     = nvme_tcp_ofld_commit_rqs,
> @@ -1031,6 +1112,7 @@ static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
>   	.init_request	= nvme_tcp_ofld_init_request,
>   	.exit_request	= nvme_tcp_ofld_exit_request,
>   	.init_hctx	= nvme_tcp_ofld_init_hctx,
> +	.timeout	= nvme_tcp_ofld_timeout,
>   	.map_queues	= nvme_tcp_ofld_map_queues,
>   	.poll		= nvme_tcp_ofld_poll,
>   };
> @@ -1041,6 +1123,7 @@ static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops = {
>   	.init_request	= nvme_tcp_ofld_init_request,
>   	.exit_request	= nvme_tcp_ofld_exit_request,
>   	.init_hctx	= nvme_tcp_ofld_init_admin_hctx,
> +	.timeout	= nvme_tcp_ofld_timeout,
>   };
>   
>   static const struct nvme_ctrl_ops nvme_tcp_ofld_ctrl_ops = {
> diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-offload.h
> index d82645fcf9da..275a7e2d9d8a 100644
> --- a/drivers/nvme/host/tcp-offload.h
> +++ b/drivers/nvme/host/tcp-offload.h
> @@ -110,6 +110,8 @@ struct nvme_tcp_ofld_ctrl {
>   	/* Connectivity params */
>   	struct nvme_tcp_ofld_ctrl_con_params conn_params;
>   
> +	struct nvme_tcp_ofld_req async_req;
> +
>   	/* Vendor specific driver context */
>   	void *private_data;
>   };
> 
So:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

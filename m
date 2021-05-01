Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9556D3707EB
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhEAQjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:39:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:40128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230195AbhEAQjq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 May 2021 12:39:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B55CAAFCF;
        Sat,  1 May 2021 16:38:55 +0000 (UTC)
Subject: Re: [RFC PATCH v4 14/27] nvme-tcp-offload: Add IO level
 implementation
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-15-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <bc7514a1-df4e-04b1-ecd2-ed4223bb4cd5@suse.de>
Date:   Sat, 1 May 2021 18:38:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-15-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
> From: Dean Balandin <dbalandin@marvell.com>
> 
> In this patch, we present the IO level functionality.
> The nvme-tcp-offload shall work on the IO-level, meaning the
> nvme-tcp-offload ULP module shall pass the request to the nvme-tcp-offload
> vendor driver and shall expect for the request compilation.

Request compilation? Not request completion?

> No additional handling is needed in between, this design will reduce the
> CPU utilization as we will describe below.
> 
> The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload ULP
> with the following IO-path ops:
>   - init_req
>   - send_req - in order to pass the request to the handling of the offload
>     driver that shall pass it to the vendor specific device
>   - poll_queue
> 
> The vendor driver will manage the context from which the request will be
> executed and the request aggregations.
> Once the IO completed, the nvme-tcp-offload vendor driver shall call
> command.done() that shall invoke the nvme-tcp-offload ULP layer for
> completing the request.
> 
> This patch also contains initial definition of nvme_tcp_ofld_queue_rq().
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/host/tcp-offload.c | 95 ++++++++++++++++++++++++++++++---
>   1 file changed, 87 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> index 8ddce2257100..0cdf5a432208 100644
> --- a/drivers/nvme/host/tcp-offload.c
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -127,7 +127,10 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
>   			    union nvme_result *result,
>   			    __le16 status)
>   {
> -	/* Placeholder - complete request with/without error */
> +	struct request *rq = blk_mq_rq_from_pdu(req);
> +
> +	if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), *result))
> +		nvme_complete_rq(rq);
>   }
>   
>   struct nvme_tcp_ofld_dev *
> @@ -686,6 +689,34 @@ static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
>   	kfree(ctrl);
>   }
>   
> +static void nvme_tcp_ofld_set_sg_null(struct nvme_command *c)
> +{
> +	struct nvme_sgl_desc *sg = &c->common.dptr.sgl;
> +
> +	sg->addr = 0;
> +	sg->length = 0;
> +	sg->type = (NVME_TRANSPORT_SGL_DATA_DESC << 4) | NVME_SGL_FMT_TRANSPORT_A;
> +}
> +
> +inline void nvme_tcp_ofld_set_sg_inline(struct nvme_tcp_ofld_queue *queue,
> +					struct nvme_command *c, u32 data_len)
> +{
> +	struct nvme_sgl_desc *sg = &c->common.dptr.sgl;
> +
> +	sg->addr = cpu_to_le64(queue->ctrl->nctrl.icdoff);
> +	sg->length = cpu_to_le32(data_len);
> +	sg->type = (NVME_SGL_FMT_DATA_DESC << 4) | NVME_SGL_FMT_OFFSET;
> +}
> +
> +void nvme_tcp_ofld_map_data(struct nvme_command *c, u32 data_len)
> +{
> +	struct nvme_sgl_desc *sg = &c->common.dptr.sgl;
> +
> +	sg->addr = 0;
> +	sg->length = cpu_to_le32(data_len);
> +	sg->type = (NVME_TRANSPORT_SGL_DATA_DESC << 4) | NVME_SGL_FMT_TRANSPORT_A;
> +}
> +
>   static void nvme_tcp_ofld_submit_async_event(struct nvme_ctrl *arg)
>   {
>   	/* Placeholder - submit_async_event */
> @@ -841,9 +872,11 @@ nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
>   {
>   	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(rq);
>   	struct nvme_tcp_ofld_ctrl *ctrl = set->driver_data;
> +	int qid;
>   
> -	/* Placeholder - init request */
> -
> +	qid = (set == &ctrl->tag_set) ? hctx_idx + 1 : 0;
> +	req->queue = &ctrl->queues[qid];
> +	nvme_req(rq)->ctrl = &ctrl->nctrl;
>   	req->done = nvme_tcp_ofld_req_done;
>   	ctrl->dev->ops->init_req(req);
>   
> @@ -858,16 +891,60 @@ EXPORT_SYMBOL_GPL(nvme_tcp_ofld_inline_data_size);
>   
>   static void nvme_tcp_ofld_commit_rqs(struct blk_mq_hw_ctx *hctx)
>   {
> -	/* Call ops->commit_rqs */
> +	struct nvme_tcp_ofld_queue *queue = hctx->driver_data;
> +	struct nvme_tcp_ofld_dev *dev = queue->dev;
> +	struct nvme_tcp_ofld_ops *ops = dev->ops;
> +
> +	ops->commit_rqs(queue);
>   }
>   
>   static blk_status_t
>   nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
>   		       const struct blk_mq_queue_data *bd)
>   {
> -	/* Call nvme_setup_cmd(...) */
> +	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(bd->rq);
> +	struct nvme_tcp_ofld_queue *queue = hctx->driver_data;
> +	struct nvme_tcp_ofld_ctrl *ctrl = queue->ctrl;
> +	struct nvme_ns *ns = hctx->queue->queuedata;
> +	struct nvme_tcp_ofld_dev *dev = queue->dev;
> +	struct nvme_tcp_ofld_ops *ops = dev->ops;
> +	struct nvme_command *nvme_cmd;
> +	struct request *rq;
> +	bool queue_ready;
> +	u32 data_len;
> +	int rc;
> +
> +	queue_ready = test_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags);
> +
> +	req->rq = bd->rq;
> +	req->async = false;
> +	rq = req->rq;
> +
> +	if (!nvmf_check_ready(&ctrl->nctrl, req->rq, queue_ready))
> +		return nvmf_fail_nonready_command(&ctrl->nctrl, req->rq);
> +
> +	rc = nvme_setup_cmd(ns, req->rq, &req->nvme_cmd);
> +	if (unlikely(rc))
> +		return rc;
>   
> -	/* Call ops->send_req(...) */
> +	blk_mq_start_request(req->rq);
> +	req->last = bd->last;
> +
> +	nvme_cmd = &req->nvme_cmd;
> +	nvme_cmd->common.flags |= NVME_CMD_SGL_METABUF;
> +
> +	data_len = blk_rq_nr_phys_segments(rq) ? blk_rq_payload_bytes(rq) : 0;
> +	if (!data_len)
> +		nvme_tcp_ofld_set_sg_null(&req->nvme_cmd);
> +	else if ((rq_data_dir(rq) == WRITE) &&
> +		 data_len <= nvme_tcp_ofld_inline_data_size(queue))
> +		nvme_tcp_ofld_set_sg_inline(queue, nvme_cmd, data_len);
> +	else
> +		nvme_tcp_ofld_map_data(nvme_cmd, data_len);
> +
> +	rc = ops->send_req(req);
> +	if (unlikely(rc))
> +		return rc;
>   
>   	return BLK_STS_OK;
>   }
> @@ -940,9 +1017,11 @@ static int nvme_tcp_ofld_map_queues(struct blk_mq_tag_set *set)
>   
>   static int nvme_tcp_ofld_poll(struct blk_mq_hw_ctx *hctx)
>   {
> -	/* Placeholder - Implement polling mechanism */
> +	struct nvme_tcp_ofld_queue *queue = hctx->driver_data;
> +	struct nvme_tcp_ofld_dev *dev = queue->dev;
> +	struct nvme_tcp_ofld_ops *ops = dev->ops;
>   
> -	return 0;
> +	return ops->poll_queue(queue);
>   }
>   
>   static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

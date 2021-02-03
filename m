Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2D530D59B
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 09:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhBCIwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 03:52:39 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:46526 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbhBCIwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 03:52:35 -0500
Received: by mail-wr1-f44.google.com with SMTP id q7so23187166wre.13
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 00:52:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3mDiD0JJR4/9Mgq5fzOCXTZgztSQAbNAzSUZFA9ppc4=;
        b=aVpveXa4gQAGalJbUUr9Z74t4KCG8hlxwGp1+vZ6PBrQ9IwVl2fjcGpzxmltpYKARJ
         IaZ9sg1tf6Nm6HulTykiuizTxjjNqqwkDIWPbFJwM7YAwJiNCn1WG6CFTX1m9iH5D/DD
         mRSlGSVr3BDb0KK5iKA3WFQXa6JE6sc3CaRVVRThdaknlX7+NglJyRGDFxE4IqtZYpIf
         YC8Kxaq8VkwwlPEXaRibOfD3PbAqLEVeUMACB6o/GAsrw3clFqeb7O5eK/d09LpvKFOV
         iQWB1IIz/dfmHBu0Bmcsm+yb8WLZIA50rsWRzRgiNhItMQ/RSBiUEc3j/bSAVq+NY1bL
         0v+w==
X-Gm-Message-State: AOAM530xGQAZzYX4Nc3lXiUSqIy7Vpt3KrF/0mY21Q/FRqplQxUycsZ+
        y2HQdVW6UyvyJSM4bkEhY9I=
X-Google-Smtp-Source: ABdhPJz/sXmbzXlifG2oC+cfB0KfIGBnEzSt3XadolhkJWhyOotfRp7ttmXDHGkeBWv3Nh3X9581Ww==
X-Received: by 2002:adf:d206:: with SMTP id j6mr2194966wrh.427.1612342312029;
        Wed, 03 Feb 2021 00:51:52 -0800 (PST)
Received: from ?IPv6:2601:647:4802:9070:819b:e1e8:19a6:9008? ([2601:647:4802:9070:819b:e1e8:19a6:9008])
        by smtp.gmail.com with ESMTPSA id i20sm1729359wmq.7.2021.02.03.00.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 00:51:51 -0800 (PST)
Subject: Re: [PATCH v3 net-next 07/21] nvme-tcp: Add DDP data-path
To:     Boris Pismenny <borisp@mellanox.com>, dsahern@gmail.com,
        kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
 <20210201100509.27351-8-borisp@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <9a8041aa-513f-09b9-63f4-3d12db19231c@grimberg.me>
Date:   Wed, 3 Feb 2021 00:51:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210201100509.27351-8-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/1/21 2:04 AM, Boris Pismenny wrote:
> Introduce the NVMe-TCP DDP data-path offload.
> Using this interface, the NIC hardware will scatter TCP payload directly
> to the BIO pages according to the command_id in the PDU.
> To maintain the correctness of the network stack, the driver is expected
> to construct SKBs that point to the BIO pages.
> 
> The data-path interface contains two routines: tcp_ddp_setup/teardown.
> The setup provides the mapping from command_id to the request buffers,
> while the teardown removes this mapping.
> 
> For efficiency, we introduce an asynchronous nvme completion, which is
> split between NVMe-TCP and the NIC driver as follows:
> NVMe-TCP performs the specific completion, while NIC driver performs the
> generic mq_blk completion.
> 
> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Yoray Zack <yorayz@mellanox.com>
> ---
>   drivers/nvme/host/tcp.c | 141 +++++++++++++++++++++++++++++++++++++---
>   1 file changed, 131 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
> index ea67caf9d326..5cb46deb56e0 100644
> --- a/drivers/nvme/host/tcp.c
> +++ b/drivers/nvme/host/tcp.c
> @@ -57,6 +57,11 @@ struct nvme_tcp_request {
>   	size_t			offset;
>   	size_t			data_sent;
>   	enum nvme_tcp_send_state state;
> +
> +	bool			offloaded;
> +	struct tcp_ddp_io	ddp;
> +	__le16			status;
> +	union nvme_result	result;
>   };
>   
>   enum nvme_tcp_queue_flags {
> @@ -232,10 +237,74 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
>   #ifdef CONFIG_TCP_DDP
>   
>   static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
> +static void nvme_tcp_ddp_teardown_done(void *ddp_ctx);
>   static const struct tcp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
>   	.resync_request		= nvme_tcp_resync_request,
> +	.ddp_teardown_done	= nvme_tcp_ddp_teardown_done,
>   };
>   
> +static
> +int nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
> +			  u16 command_id,
> +			  struct request *rq)
> +{
> +	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> +	struct net_device *netdev = queue->ctrl->offloading_netdev;
> +	int ret;
> +
> +	if (unlikely(!netdev)) {
> +		pr_info_ratelimited("%s: netdev not found\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	ret = netdev->tcp_ddp_ops->tcp_ddp_teardown(netdev, queue->sock->sk,
> +						    &req->ddp, rq);
> +	sg_free_table_chained(&req->ddp.sg_table, SG_CHUNK_SIZE);
> +	req->offloaded = false;

Why is the offloaded = false needed here? you also clear it when
you setup.

> +	return ret;
> +}
> +
> +static void nvme_tcp_ddp_teardown_done(void *ddp_ctx)
> +{
> +	struct request *rq = ddp_ctx;
> +	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> +
> +	if (!nvme_try_complete_req(rq, cpu_to_le16(req->status << 1), req->result))
> +		nvme_complete_rq(rq);

Why is the status shifted here? it was taken from the cqe as is..

> +}
> +
> +static
> +int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
> +		       u16 command_id,
> +		       struct request *rq)
> +{
> +	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> +	struct net_device *netdev = queue->ctrl->offloading_netdev;
> +	int ret;
> +
> +	req->offloaded = false;
> +
> +	if (unlikely(!netdev)) {
> +		pr_info_ratelimited("%s: netdev not found\n", __func__);

dev_info_ratelimited please.

> +		return -EINVAL;
> +	}
> +
> +	req->ddp.command_id = command_id;
> +	req->ddp.sg_table.sgl = req->ddp.first_sgl;
> +	ret = sg_alloc_table_chained(&req->ddp.sg_table, blk_rq_nr_phys_segments(rq),
> +				     req->ddp.sg_table.sgl, SG_CHUNK_SIZE);
> +	if (ret)
> +		return -ENOMEM;
> +	req->ddp.nents = blk_rq_map_sg(rq->q, rq, req->ddp.sg_table.sgl);
> +
> +	ret = netdev->tcp_ddp_ops->tcp_ddp_setup(netdev,
> +						 queue->sock->sk,
> +						 &req->ddp);
> +	if (!ret)
> +		req->offloaded = true;
> +	return ret;
> +}
> +
>   static
>   int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
>   {
> @@ -377,6 +446,25 @@ bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
>   
>   #else
>   
> +static
> +int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
> +		       u16 command_id,
> +		       struct request *rq)
> +{
> +	return -EINVAL;
> +}
> +
> +static
> +int nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
> +			  u16 command_id,
> +			  struct request *rq)
> +{
> +	return -EINVAL;
> +}
> +
> +static void nvme_tcp_ddp_teardown_done(void *ddp_ctx)
> +{}
> +
>   static
>   int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
>   {
> @@ -665,6 +753,7 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
>   static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
>   		struct nvme_completion *cqe)
>   {
> +	struct nvme_tcp_request *req;
>   	struct request *rq;
>   
>   	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), cqe->command_id);
> @@ -676,8 +765,15 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
>   		return -EINVAL;
>   	}
>   
> -	if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
> -		nvme_complete_rq(rq);
> +	req = blk_mq_rq_to_pdu(rq);
> +	if (req->offloaded) {
> +		req->status = cqe->status;
> +		req->result = cqe->result;
> +		nvme_tcp_teardown_ddp(queue, cqe->command_id, rq);
> +	} else {
> +		if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
> +			nvme_complete_rq(rq);
> +	}

Maybe move this to nvme_tcp_complete_request as it is called from two
code paths.

>   	queue->nr_cqe++;
>   
>   	return 0;
> @@ -871,9 +967,18 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>   static inline void nvme_tcp_end_request(struct request *rq, u16 status)
>   {
>   	union nvme_result res = {};
> +	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> +	struct nvme_tcp_queue *queue = req->queue;
> +	struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
>   
> -	if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
> -		nvme_complete_rq(rq);
> +	if (req->offloaded) {
> +		req->status = cpu_to_le16(status << 1);
> +		req->result = res;
> +		nvme_tcp_teardown_ddp(queue, pdu->command_id, rq);
> +	} else {
> +		if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
> +			nvme_complete_rq(rq);
> +	}
>   }
>   
>   static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
> @@ -920,12 +1025,22 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>   		recv_len = min_t(size_t, recv_len,
>   				iov_iter_count(&req->iter));
>   
> -		if (queue->data_digest)
> -			ret = skb_copy_and_hash_datagram_iter(skb, *offset,
> -				&req->iter, recv_len, queue->rcv_hash);
> -		else
> -			ret = skb_copy_datagram_iter(skb, *offset,
> -					&req->iter, recv_len);
> +		if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags)) {
> +			if (queue->data_digest)
> +				ret = skb_ddp_copy_and_hash_datagram_iter(skb, *offset,
> +						&req->iter, recv_len, queue->rcv_hash);
> +			else
> +				ret = skb_ddp_copy_datagram_iter(skb, *offset,
> +						&req->iter, recv_len);
> +		} else {
> +			if (queue->data_digest)
> +				ret = skb_copy_and_hash_datagram_iter(skb, *offset,
> +						&req->iter, recv_len, queue->rcv_hash);
> +			else
> +				ret = skb_copy_datagram_iter(skb, *offset,
> +						&req->iter, recv_len);
> +		}
> +

Maybe move this hunk to nvme_tcp_consume_skb or something?

>   		if (ret) {
>   			dev_err(queue->ctrl->ctrl.device,
>   				"queue %d failed to copy request %#x data",
> @@ -1149,6 +1264,7 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
>   	bool inline_data = nvme_tcp_has_inline_data(req);
>   	u8 hdgst = nvme_tcp_hdgst_len(queue);
>   	int len = sizeof(*pdu) + hdgst - req->offset;
> +	struct request *rq = blk_mq_rq_from_pdu(req);
>   	int flags = MSG_DONTWAIT;
>   	int ret;
>   
> @@ -1157,6 +1273,10 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
>   	else
>   		flags |= MSG_EOR;
>   
> +	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) &&
> +	    blk_rq_nr_phys_segments(rq) && rq_data_dir(rq) == READ)
> +		nvme_tcp_setup_ddp(queue, pdu->cmd.common.command_id, rq);
> +
>   	if (queue->hdr_digest && !req->offset)
>   		nvme_tcp_hdgst(queue->snd_hash, pdu, sizeof(*pdu));
>   
> @@ -2464,6 +2584,7 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
>   	req->data_len = blk_rq_nr_phys_segments(rq) ?
>   				blk_rq_payload_bytes(rq) : 0;
>   	req->curr_bio = rq->bio;
> +	req->offloaded = false;

offloaded is being cleared lots of times, and I'm not clear what are
the lifetime rules here.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D88A30D5E1
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbhBCJKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:10:18 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:34735 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbhBCJHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 04:07:43 -0500
Received: by mail-wr1-f42.google.com with SMTP id g10so23269466wrx.1
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 01:07:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g3fKcT/3fzsUqeyTRN+4L/vhOhFUdq1bKllMqkLEfFo=;
        b=NSzE/PwcCKJg3NDpE+LMg3wY5L76WSm+3aGZ8toBN2kLvQr9PtPF+Wyy6/dys6edC9
         Z3X0AGcZmhD2L+/pPrTDRh6juphwNjajyl6FMVTCsOLKKuMa/4XBgXoEeZaiwRDVt5vv
         x4NDtOMM9wCRPsr7WcLvpyyULNZ4X9NXryNlS9S+6oypJKNiTN48ySMPndYZrTxoHcRC
         EFK46qgJpjcxadtoh8gIcRju6S2R+5WsQSA1W4sClSlTvwINCVm1hqJu3iNVQtw4t8wp
         2XkuAPyy8mhq/lhoe4ZXdPUAzFT79pUG4GTW9/226jERK00U+OxRLK5EnFtqJTgUvR2s
         +Hdg==
X-Gm-Message-State: AOAM530S0rtELT2d9LfpSOut0w/CdSjslZrBQNtvADvnwbG+YfcSO94H
        5SxCAlEAlKTBeIqrwFgphew=
X-Google-Smtp-Source: ABdhPJw8Lr4Ml8OGBAA7KXvTQtu68lV0hL/jaaBz+hNNfrPBQyyfI6v8ZAv8PJR0Jsptp0kGWyO5iQ==
X-Received: by 2002:adf:d085:: with SMTP id y5mr2373359wrh.41.1612343219307;
        Wed, 03 Feb 2021 01:06:59 -0800 (PST)
Received: from ?IPv6:2601:647:4802:9070:819b:e1e8:19a6:9008? ([2601:647:4802:9070:819b:e1e8:19a6:9008])
        by smtp.gmail.com with ESMTPSA id q6sm2430150wrw.43.2021.02.03.01.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 01:06:58 -0800 (PST)
Subject: Re: [PATCH v3 net-next 08/21] nvme-tcp : Recalculate crc in the end
 of the capsule
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
 <20210201100509.27351-9-borisp@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <a104a5d1-b4cb-4275-6ced-b80f911b6f47@grimberg.me>
Date:   Wed, 3 Feb 2021 01:06:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210201100509.27351-9-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/1/21 2:04 AM, Boris Pismenny wrote:
> From: Ben Ben-ishay <benishay@nvidia.com>
> 
> crc offload of the nvme capsule. Check if all the skb bits
> are on, and if not recalculate the crc in SW and check it.
> 
> This patch reworks the receive-side crc calculation to always
> run at the end, so as to keep a single flow for both offload
> and non-offload. This change simplifies the code, but it may degrade
> performance for non-offload crc calculation.
> 
> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Yoray Zack <yorayz@mellanox.com>
> ---
>   drivers/nvme/host/tcp.c | 118 ++++++++++++++++++++++++++++++++--------
>   1 file changed, 95 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
> index 5cb46deb56e0..eb47cf6982d7 100644
> --- a/drivers/nvme/host/tcp.c
> +++ b/drivers/nvme/host/tcp.c
> @@ -69,6 +69,7 @@ enum nvme_tcp_queue_flags {
>   	NVME_TCP_Q_LIVE		= 1,
>   	NVME_TCP_Q_POLLING	= 2,
>   	NVME_TCP_Q_OFF_DDP	= 3,
> +	NVME_TCP_Q_OFF_DDGST_RX = 4,
>   };
>   
>   enum nvme_tcp_recv_state {
> @@ -96,6 +97,7 @@ struct nvme_tcp_queue {
>   	size_t			data_remaining;
>   	size_t			ddgst_remaining;
>   	unsigned int		nr_cqe;
> +	bool			ddgst_valid;
>   
>   	/* send state */
>   	struct nvme_tcp_request *request;
> @@ -234,7 +236,56 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
>   	return nvme_tcp_pdu_data_left(req) <= len;
>   }
>   
> -#ifdef CONFIG_TCP_DDP
> +static inline bool nvme_tcp_ddp_ddgst_ok(struct nvme_tcp_queue *queue)
> +{
> +	return queue->ddgst_valid;
> +}
> +
> +static inline void nvme_tcp_ddp_ddgst_update(struct nvme_tcp_queue *queue,
> +					     struct sk_buff *skb)
> +{
> +	if (queue->ddgst_valid)
> +#ifdef CONFIG_TCP_DDP_CRC
> +		queue->ddgst_valid = skb->ddp_crc;
> +#else
> +		queue->ddgst_valid = false;
> +#endif
> +}
> +
> +static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
> +{
> +	int ret;
> +
> +	req->ddp.sg_table.sgl = req->ddp.first_sgl;
> +	ret = sg_alloc_table_chained(&req->ddp.sg_table, blk_rq_nr_phys_segments(rq),
> +				     req->ddp.sg_table.sgl, SG_CHUNK_SIZE);
> +	if (ret)
> +		return -ENOMEM;
> +	req->ddp.nents = blk_rq_map_sg(rq->q, rq, req->ddp.sg_table.sgl);
> +	return 0;
> +}
> +
> +static void nvme_tcp_ddp_ddgst_recalc(struct ahash_request *hash,
> +				      struct request *rq)
> +{
> +	struct nvme_tcp_request *req;
> +
> +	if (!rq)
> +		return;
> +
> +	req = blk_mq_rq_to_pdu(rq);
> +
> +	if (!req->offloaded && nvme_tcp_req_map_sg(req, rq))
> +		return;
> +
> +	crypto_ahash_init(hash);
> +	req->ddp.sg_table.sgl = req->ddp.first_sgl;
> +	ahash_request_set_crypt(hash, req->ddp.sg_table.sgl, NULL,
> +				le32_to_cpu(req->data_len));
> +	crypto_ahash_update(hash);
> +}
> +
> +#if defined(CONFIG_TCP_DDP) || defined(CONFIG_TCP_DDP_CRC)
>   
>   static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
>   static void nvme_tcp_ddp_teardown_done(void *ddp_ctx);
> @@ -290,12 +341,9 @@ int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
>   	}
>   
>   	req->ddp.command_id = command_id;
> -	req->ddp.sg_table.sgl = req->ddp.first_sgl;
> -	ret = sg_alloc_table_chained(&req->ddp.sg_table, blk_rq_nr_phys_segments(rq),
> -				     req->ddp.sg_table.sgl, SG_CHUNK_SIZE);
> +	ret = nvme_tcp_req_map_sg(req, rq);

Why didn't you introduce nvme_tcp_req_map_sg in the first place?

>   	if (ret)
>   		return -ENOMEM;
> -	req->ddp.nents = blk_rq_map_sg(rq->q, rq, req->ddp.sg_table.sgl);
>   
>   	ret = netdev->tcp_ddp_ops->tcp_ddp_setup(netdev,
>   						 queue->sock->sk,
> @@ -317,7 +365,7 @@ int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
>   		return -ENODEV;
>   	}
>   
> -	if (!(netdev->features & NETIF_F_HW_TCP_DDP)) {
> +	if (!(netdev->features & (NETIF_F_HW_TCP_DDP | NETIF_F_HW_TCP_DDP_CRC_RX))) {
>   		dev_put(netdev);
>   		return -EOPNOTSUPP;
>   	}
> @@ -345,6 +393,9 @@ int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
>   	if (netdev->features & NETIF_F_HW_TCP_DDP)
>   		set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
>   
> +	if (netdev->features & NETIF_F_HW_TCP_DDP_CRC_RX)
> +		set_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
> +
>   	return ret;
>   }
>   
> @@ -376,7 +427,7 @@ int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue)
>   		return -ENODEV;
>   	}
>   
> -	if (netdev->features & NETIF_F_HW_TCP_DDP &&
> +	if ((netdev->features & (NETIF_F_HW_TCP_DDP | NETIF_F_HW_TCP_DDP_CRC_RX)) &&
>   	    netdev->tcp_ddp_ops &&
>   	    netdev->tcp_ddp_ops->tcp_ddp_limits)
>   		ret = netdev->tcp_ddp_ops->tcp_ddp_limits(netdev, &limits);
> @@ -739,6 +790,7 @@ static void nvme_tcp_init_recv_ctx(struct nvme_tcp_queue *queue)
>   	queue->pdu_offset = 0;
>   	queue->data_remaining = -1;
>   	queue->ddgst_remaining = 0;
> +	queue->ddgst_valid = true;
>   }
>   
>   static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
> @@ -919,7 +971,8 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>   
>   	u64 pdu_seq = TCP_SKB_CB(skb)->seq + *offset - queue->pdu_offset;
>   
> -	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
> +	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
> +	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
>   		nvme_tcp_resync_response(queue, pdu_seq);
>   
>   	ret = skb_copy_bits(skb, *offset,
> @@ -988,6 +1041,8 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>   	struct nvme_tcp_request *req;
>   	struct request *rq;
>   
> +	if (queue->data_digest && test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
> +		nvme_tcp_ddp_ddgst_update(queue, skb);
>   	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
>   	if (!rq) {
>   		dev_err(queue->ctrl->ctrl.device,
> @@ -1025,15 +1080,17 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>   		recv_len = min_t(size_t, recv_len,
>   				iov_iter_count(&req->iter));
>   
> -		if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags)) {
> -			if (queue->data_digest)
> +		if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags)) {
> +			if (queue->data_digest &&
> +			    !test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
>   				ret = skb_ddp_copy_and_hash_datagram_iter(skb, *offset,
>   						&req->iter, recv_len, queue->rcv_hash);
>   			else
>   				ret = skb_ddp_copy_datagram_iter(skb, *offset,
>   						&req->iter, recv_len);
>   		} else {
> -			if (queue->data_digest)
> +			if (queue->data_digest &&
> +			    !test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
>   				ret = skb_copy_and_hash_datagram_iter(skb, *offset,
>   						&req->iter, recv_len, queue->rcv_hash);
>   			else
> @@ -1055,7 +1112,6 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>   
>   	if (!queue->data_remaining) {
>   		if (queue->data_digest) {
> -			nvme_tcp_ddgst_final(queue->rcv_hash, &queue->exp_ddgst);
>   			queue->ddgst_remaining = NVME_TCP_DIGEST_LENGTH;
>   		} else {
>   			if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
> @@ -1076,8 +1132,12 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
>   	char *ddgst = (char *)&queue->recv_ddgst;
>   	size_t recv_len = min_t(size_t, *len, queue->ddgst_remaining);
>   	off_t off = NVME_TCP_DIGEST_LENGTH - queue->ddgst_remaining;
> +	bool offload_fail, offload_en;
> +	struct request *rq = NULL;
>   	int ret;
>   
> +	if (test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
> +		nvme_tcp_ddp_ddgst_update(queue, skb);
>   	ret = skb_copy_bits(skb, *offset, &ddgst[off], recv_len);
>   	if (unlikely(ret))
>   		return ret;
> @@ -1088,17 +1148,29 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
>   	if (queue->ddgst_remaining)
>   		return 0;
>   
> -	if (queue->recv_ddgst != queue->exp_ddgst) {
> -		dev_err(queue->ctrl->ctrl.device,
> -			"data digest error: recv %#x expected %#x\n",
> -			le32_to_cpu(queue->recv_ddgst),
> -			le32_to_cpu(queue->exp_ddgst));
> -		return -EIO;
> +	offload_fail = !nvme_tcp_ddp_ddgst_ok(queue);
> +	offload_en = test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
> +	if (!offload_en || offload_fail) {
> +		if (offload_en && offload_fail) { // software-fallback
> +			rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue),
> +					      pdu->command_id);
> +			nvme_tcp_ddp_ddgst_recalc(queue->rcv_hash, rq);
> +		}
> +
> +		nvme_tcp_ddgst_final(queue->rcv_hash, &queue->exp_ddgst);
> +		if (queue->recv_ddgst != queue->exp_ddgst) {
> +			dev_err(queue->ctrl->ctrl.device,
> +				"data digest error: recv %#x expected %#x\n",
> +				le32_to_cpu(queue->recv_ddgst),
> +				le32_to_cpu(queue->exp_ddgst));
> +			return -EIO;
> +		}

I still dislike this hunk. Can you split the recalc login to its
own ddp function at least? This is just a confusing piece of code.

>   	}
>   
>   	if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
> -		struct request *rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue),
> -						pdu->command_id);
> +		if (!rq)
> +			rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue),
> +					      pdu->command_id);

Why is this change needed? Maybe just move this assignment up?

>   
>   		nvme_tcp_end_request(rq, NVME_SC_SUCCESS);
>   		queue->nr_cqe++;
> @@ -1841,8 +1913,10 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
>   	nvme_tcp_restore_sock_calls(queue);
>   	cancel_work_sync(&queue->io_work);
>   
> -	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
> +	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
> +	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
>   		nvme_tcp_unoffload_socket(queue);
> +

extra newline

>   }
>   
>   static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
> @@ -1970,8 +2044,6 @@ static int nvme_tcp_alloc_admin_queue(struct nvme_ctrl *ctrl)
>   {
>   	int ret;
>   
> -	to_tcp_ctrl(ctrl)->offloading_netdev = NULL;
> -

Unclear what is the intent here.

>   	ret = nvme_tcp_alloc_queue(ctrl, 0, NVME_AQ_DEPTH);
>   	if (ret)
>   		return ret;
> 

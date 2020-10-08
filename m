Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598B3287EB2
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 00:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbgJHW3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 18:29:17 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38917 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgJHW3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 18:29:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id y12so2874350wrp.6
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 15:29:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ox+SLdn5ABEvjXy4FNIvlB0HuPx9UawCsH/gISwf+Sw=;
        b=LzJQAl6xgkJ0tuja765rz7nMyBrp+QmFzfEincB+GkNWCL2HJoHer9ss/u3+2huGWv
         oTws2Bm6oy8J1Hzbt02QLqTx/5xORIVu5C3rHrM1FWIPq0pf6hbKVK6LVtTDiaU3I4ZY
         wb0Gw1/LwBb48jDXJPMUrIuDoMEW3PKXSv1Rptl0R+bjR/yXTeyYVCU/yqBCKCxYfTNy
         fMVEuzAJxw0R8BJQ5TbWkNDS8gKGD3zUHqkP/QxgUskQwN/4joa077Gi7LfK7IaRQ/N2
         uWVELgoEUWl+9l/DeQ5ce1lFYRaV493KHive/8XCR+Ju0dydzUoveG8r6HSWAtIt/a9s
         K2Yw==
X-Gm-Message-State: AOAM532fYLgcL8pIFI2u7+vUHvemrZslf1Q5Jp1vYVb/PbIRmQc5xmu5
        m/61Penhd/cMLMvkU8A2gC4=
X-Google-Smtp-Source: ABdhPJyjtl4th6cFE65od/0j5xVs8hY/DF2C3jwkNEocZeRSMsDoE3kMhSGPzGskIfro6pC2Urcf2Q==
X-Received: by 2002:adf:9043:: with SMTP id h61mr11995933wrh.237.1602196154497;
        Thu, 08 Oct 2020 15:29:14 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:68d6:3fd5:5a8b:9959? ([2601:647:4802:9070:68d6:3fd5:5a8b:9959])
        by smtp.gmail.com with ESMTPSA id l3sm8532148wmh.27.2020.10.08.15.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 15:29:14 -0700 (PDT)
Subject: Re: [PATCH net-next RFC v1 06/10] nvme-tcp: Add DDP data-path
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-7-borisp@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <5a23d221-fd3e-5802-ce68-7edec55068bb@grimberg.me>
Date:   Thu, 8 Oct 2020 15:29:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200930162010.21610-7-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>   bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
> +void nvme_tcp_ddp_teardown_done(void *ddp_ctx);
>   const struct tcp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops __read_mostly = {
> +
>   	.resync_request		= nvme_tcp_resync_request,
> +	.ddp_teardown_done	= nvme_tcp_ddp_teardown_done,
>   };
>   
> +static
> +int nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
> +			  uint16_t command_id,
> +			  struct request *rq)
> +{
> +	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> +	struct net_device *netdev = queue->ctrl->offloading_netdev;
> +	int ret;
> +
> +	if (unlikely(!netdev)) {
> +		pr_info_ratelimited("%s: netdev not found\n", __func__);

dev_info_ratelimited

> +		return -EINVAL;
> +	}
> +
> +	ret = netdev->tcp_ddp_ops->tcp_ddp_teardown(netdev, queue->sock->sk,
> +						    &req->ddp, rq);
> +	sg_free_table_chained(&req->ddp.sg_table, SG_CHUNK_SIZE);
> +	req->offloaded = false;
> +	return ret;
> +}
> +
> +void nvme_tcp_ddp_teardown_done(void *ddp_ctx)
> +{
> +	struct request *rq = ddp_ctx;
> +	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> +
> +	if (!nvme_try_complete_req(rq, cpu_to_le16(req->status << 1), req->result))
> +		nvme_complete_rq(rq);
> +}
> +
> +static
> +int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
> +		       uint16_t command_id,
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
> +		return -EINVAL;
> +	}
> +
> +	req->ddp.command_id = command_id;
> +	req->ddp.sg_table.sgl = req->ddp.first_sgl;
> +	ret = sg_alloc_table_chained(&req->ddp.sg_table,
> +		blk_rq_nr_phys_segments(rq), req->ddp.sg_table.sgl,
> +		SG_CHUNK_SIZE);
> +	if (ret)
> +		return -ENOMEM;

newline here

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
>   int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue,
>   			    struct nvme_tcp_config *config)
> @@ -351,6 +422,25 @@ bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
>   
>   #else
>   
> +static
> +int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
> +		       uint16_t command_id,
> +		       struct request *rq)
> +{
> +	return -EINVAL;
> +}
> +
> +static
> +int nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
> +			  uint16_t command_id,
> +			  struct request *rq)
> +{
> +	return -EINVAL;
> +}
> +
> +void nvme_tcp_ddp_teardown_done(void *ddp_ctx)
> +{}
> +
>   static
>   int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue,
>   			    struct nvme_tcp_config *config)
> @@ -630,6 +720,7 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
>   static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
>   		struct nvme_completion *cqe)
>   {
> +	struct nvme_tcp_request *req;
>   	struct request *rq;
>   
>   	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), cqe->command_id);
> @@ -641,8 +732,15 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
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
>   	queue->nr_cqe++;
>   
>   	return 0;
> @@ -836,9 +934,18 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
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
> @@ -1115,6 +1222,7 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
>   	bool inline_data = nvme_tcp_has_inline_data(req);
>   	u8 hdgst = nvme_tcp_hdgst_len(queue);
>   	int len = sizeof(*pdu) + hdgst - req->offset;
> +	struct request *rq = blk_mq_rq_from_pdu(req);
>   	int flags = MSG_DONTWAIT;
>   	int ret;
>   
> @@ -1123,6 +1231,10 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
>   	else
>   		flags |= MSG_EOR;
>   
> +	if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags) &&
> +	    blk_rq_nr_phys_segments(rq) && rq_data_dir(rq) == READ)
> +		nvme_tcp_setup_ddp(queue, pdu->cmd.common.command_id, rq);

I'd assume that this is something we want to setup in
nvme_tcp_setup_cmd_pdu. Why do it here?

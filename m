Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF154287EC8
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 00:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbgJHWoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 18:44:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52933 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730566AbgJHWoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 18:44:18 -0400
Received: by mail-wm1-f65.google.com with SMTP id e23so950535wme.2
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 15:44:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QoGWFApjFmPwuVg12KwUBchVevUx69KKitnsFYiHYbc=;
        b=XijbzW5yypHVqzB4frDYal3/2qipFZT2VkIBFUBWd0hkMiqeoziF3bPNxejFqQPtP3
         tiE08nxPza+BCKNJt9khL5hfaGkZ5Pn0PMHD9WsykOTR7sHCs/UhPMeyHv1e6e4BK3IO
         7NHq1fpmDeNTfGP6p7VR5fmtvtk+it+JjOkRhJnoQEx2Gn268hY0/Gy22sPpLplKKsNW
         5K63EEnTlXlEODWNGd9J0LkYTKaERW2aFXVvdKzJxmH8aI6J7vsqm4UDhJHxWgLYL7sa
         ugE97tbBkZQgzCXgXaghxvJVMQIn6nQSonskzZvp2a+nLMVjpcuf5uAlA9g1s/KVvAr8
         4ocw==
X-Gm-Message-State: AOAM532F/3/eqQQ3UVi6oahagCuYNsT88OPUm9jC3vq90Z7nlhCoOW5M
        gKxMrrWWdrcCRvybvu1rT/Q=
X-Google-Smtp-Source: ABdhPJzgcX5y4mU2wOcsCl5+4e1DVM3ehj2OxfpvOLh3sIZTwoDl6cDzFfMQUx5uVXrz88K3ILsGfA==
X-Received: by 2002:a7b:c189:: with SMTP id y9mr10450864wmi.141.1602197053671;
        Thu, 08 Oct 2020 15:44:13 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:68d6:3fd5:5a8b:9959? ([2601:647:4802:9070:68d6:3fd5:5a8b:9959])
        by smtp.gmail.com with ESMTPSA id 40sm9600575wrc.46.2020.10.08.15.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 15:44:13 -0700 (PDT)
Subject: Re: [PATCH net-next RFC v1 07/10] nvme-tcp : Recalculate crc in the
 end of the capsule
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-8-borisp@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <a17cf1ca-4183-8f6c-8470-9d45febb755b@grimberg.me>
Date:   Thu, 8 Oct 2020 15:44:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200930162010.21610-8-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> crc offload of the nvme capsule. Check if all the skb bits
> are on, and if not recalculate the crc in SW and check it.

Can you clarify in the patch description that this is only
for pdu data digest and not header digest?

> 
> This patch reworks the receive-side crc calculation to always
> run at the end, so as to keep a single flow for both offload
> and non-offload. This change simplifies the code, but it may degrade
> performance for non-offload crc calculation.

??

 From my scan it doeesn't look like you do that.. Am I missing something?
Can you explain?

> 
> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Yoray Zack <yorayz@mellanox.com>
> ---
>   drivers/nvme/host/tcp.c | 66 ++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 58 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
> index 7bd97f856677..9a620d1dacb4 100644
> --- a/drivers/nvme/host/tcp.c
> +++ b/drivers/nvme/host/tcp.c
> @@ -94,6 +94,7 @@ struct nvme_tcp_queue {
>   	size_t			data_remaining;
>   	size_t			ddgst_remaining;
>   	unsigned int		nr_cqe;
> +	bool			crc_valid;
>   
>   	/* send state */
>   	struct nvme_tcp_request *request;
> @@ -233,6 +234,41 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
>   	return nvme_tcp_pdu_data_left(req) <= len;
>   }
>   
> +static inline bool nvme_tcp_device_ddgst_ok(struct nvme_tcp_queue *queue)

Maybe call it nvme_tcp_ddp_ddgst_ok?

> +{
> +	return queue->crc_valid;
> +}
> +
> +static inline void nvme_tcp_device_ddgst_update(struct nvme_tcp_queue *queue,
> +						struct sk_buff *skb)

Maybe call it nvme_tcp_ddp_ddgst_update?

> +{
> +	if (queue->crc_valid)
> +#ifdef CONFIG_TCP_DDP_CRC
> +		queue->crc_valid = skb->ddp_crc;
> +#else
> +		queue->crc_valid = false;
> +#endif
> +}
> +
> +static void nvme_tcp_crc_recalculate(struct nvme_tcp_queue *queue,
> +				     struct nvme_tcp_data_pdu *pdu)

Maybe call it nvme_tcp_ddp_ddgst_recalc?

> +{
> +	struct nvme_tcp_request *req;
> +	struct request *rq;
> +
> +	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
> +	if (!rq)
> +		return;
> +	req = blk_mq_rq_to_pdu(rq);
> +	crypto_ahash_init(queue->rcv_hash);
> +	req->ddp.sg_table.sgl = req->ddp.first_sgl;
> +	/* req->ddp.sg_table is allocated and filled in nvme_tcp_setup_ddp */
> +	ahash_request_set_crypt(queue->rcv_hash, req->ddp.sg_table.sgl, NULL,
> +				le32_to_cpu(pdu->data_length));
> +	crypto_ahash_update(queue->rcv_hash);
> +}
> +
> +
>   #ifdef CONFIG_TCP_DDP
>   
>   bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
> @@ -706,6 +742,7 @@ static void nvme_tcp_init_recv_ctx(struct nvme_tcp_queue *queue)
>   	queue->pdu_offset = 0;
>   	queue->data_remaining = -1;
>   	queue->ddgst_remaining = 0;
> +	queue->crc_valid = true;
>   }
>   
>   static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
> @@ -955,6 +992,8 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>   	struct nvme_tcp_request *req;
>   	struct request *rq;
>   
> +	if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags))
> +		nvme_tcp_device_ddgst_update(queue, skb);

Is the queue->data_digest condition missing here?

>   	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
>   	if (!rq) {
>   		dev_err(queue->ctrl->ctrl.device,
> @@ -992,7 +1031,7 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>   		recv_len = min_t(size_t, recv_len,
>   				iov_iter_count(&req->iter));
>   
> -		if (queue->data_digest)
> +		if (queue->data_digest && !test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags))
>   			ret = skb_copy_and_hash_datagram_iter(skb, *offset,
>   				&req->iter, recv_len, queue->rcv_hash);

This is the skb copy and hash, not clear why you say that you move this
to the end...

>   		else
> @@ -1012,7 +1051,6 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>   
>   	if (!queue->data_remaining) {
>   		if (queue->data_digest) {
> -			nvme_tcp_ddgst_final(queue->rcv_hash, &queue->exp_ddgst);

If I instead do:
			if (!test_bit(NVME_TCP_Q_OFFLOADS,
                                       &queue->flags))
				nvme_tcp_ddgst_final(queue->rcv_hash,
						     &queue->exp_ddgst);

Does that help the mess in nvme_tcp_recv_ddgst?

>   			queue->ddgst_remaining = NVME_TCP_DIGEST_LENGTH;
>   		} else {
>   			if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
> @@ -1033,8 +1071,11 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
>   	char *ddgst = (char *)&queue->recv_ddgst;
>   	size_t recv_len = min_t(size_t, *len, queue->ddgst_remaining);
>   	off_t off = NVME_TCP_DIGEST_LENGTH - queue->ddgst_remaining;
> +	bool ddgst_offload_fail;
>   	int ret;
>   
> +	if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags))
> +		nvme_tcp_device_ddgst_update(queue, skb);
>   	ret = skb_copy_bits(skb, *offset, &ddgst[off], recv_len);
>   	if (unlikely(ret))
>   		return ret;
> @@ -1045,12 +1086,21 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
>   	if (queue->ddgst_remaining)
>   		return 0;
>   
> -	if (queue->recv_ddgst != queue->exp_ddgst) {
> -		dev_err(queue->ctrl->ctrl.device,
> -			"data digest error: recv %#x expected %#x\n",
> -			le32_to_cpu(queue->recv_ddgst),
> -			le32_to_cpu(queue->exp_ddgst));
> -		return -EIO;
> +	ddgst_offload_fail = !nvme_tcp_device_ddgst_ok(queue);
> +	if (!test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags) ||
> +	    ddgst_offload_fail) {
> +		if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags) &&
> +		    ddgst_offload_fail)
> +			nvme_tcp_crc_recalculate(queue, pdu);
> +
> +		nvme_tcp_ddgst_final(queue->rcv_hash, &queue->exp_ddgst);
> +		if (queue->recv_ddgst != queue->exp_ddgst) {
> +			dev_err(queue->ctrl->ctrl.device,
> +				"data digest error: recv %#x expected %#x\n",
> +				le32_to_cpu(queue->recv_ddgst),
> +				le32_to_cpu(queue->exp_ddgst));
> +			return -EIO;

This gets convoluted here...

> +		}
>   	}
>   
>   	if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE526292D86
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 20:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbgJSS2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 14:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729369AbgJSS2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 14:28:10 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFF4C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 11:28:09 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id k21so543449wmi.1
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 11:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=00v4ZZnzoKGoUR6qFTEC/tPmhQSXR+48qmvO+cBP1uY=;
        b=p7abkTdERRX+6woQoBw8T95R9JLA06Zuuwq2snwgjRII3GG7p+jidSYGdVtVYmB188
         pFXoiDRYN+1CSxVo5bdXEeA/uwRaP3ESFjydx3bzwEdqJgsyL1Hj0Pu3oH2r3cFN2fSR
         oMuG0u5DBO+GC3HEGGqxLbcdhGybTn1EwT7oPhh9l7hTMMvqxVUYe46LTIAYoNuByYDr
         aacWjIQ9UNgRFv9qcz7QHVCxei/rkLwyeZPUkK58BKi6eJ+5LDxEgJzesMV4Vi16gOHI
         +K+nvnwVHa+MAF2Ou9G6kY+f0QJxucBjoPv2pEApAh9SNG5xnB8WbfJLfZy5ov6riZdB
         DoGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=00v4ZZnzoKGoUR6qFTEC/tPmhQSXR+48qmvO+cBP1uY=;
        b=nJcm2LXnz7YYM+T0lEeOICRx2mJbjBgAPFArDVgIMp+YAyo18yPZNKMh5T3scyfqy4
         BnsfS7L2uyprbc0JCHh8OCLAbShU23p7Rg/hSXtNKgCJaT8VTlA3mmrX8RI6z5cBVC+p
         ySI1KCJDhQny9CSxGikvhDN/vxRAhAuR+Q4eHQoEgYDYvd15N8lfPuW8gYLXeTzYxi0o
         ke/SO7W6G7cwD9QVcibNobMi81Hyf8icqugpnG7vzCw0QQeDtxH4FTHyKk5VH0Qjt8GJ
         u5pmcI9ruNz4MBlpdG12zroZF+5yC1XN/srf6VoB3TpchEJyTOJMuWwqknZ+ip61onBR
         3DaQ==
X-Gm-Message-State: AOAM532b7HgacVR4RA3cLmSgURm21ushJHQYA5rkV+dsiLstCKYbL/aF
        czuGtB1XXdAhuMWkTPPOaEI=
X-Google-Smtp-Source: ABdhPJyEEVX+kxTfnwWBjp3vzI1tGUGL9Gq97ff/gT7m/OGdz5i/01Z4T5kIaQlsvgT2m5pX4jAy5A==
X-Received: by 2002:a7b:c92c:: with SMTP id h12mr587020wml.134.1603132088369;
        Mon, 19 Oct 2020 11:28:08 -0700 (PDT)
Received: from [192.168.1.11] ([213.57.108.142])
        by smtp.gmail.com with ESMTPSA id a2sm644249wrs.55.2020.10.19.11.28.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 11:28:07 -0700 (PDT)
From:   Boris Pismenny <borispismenny@gmail.com>
Subject: Re: [PATCH net-next RFC v1 05/10] nvme-tcp: Add DDP offload control
 path
To:     Sagi Grimberg <sagi@grimberg.me>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-6-borisp@mellanox.com>
 <c6bb16cc-fdda-3c4e-41f6-9155911aa2c8@grimberg.me>
Message-ID: <4e31f3bf-ba79-079d-a181-d7f14c843a95@gmail.com>
Date:   Mon, 19 Oct 2020 21:28:03 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <c6bb16cc-fdda-3c4e-41f6-9155911aa2c8@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/10/2020 1:19, Sagi Grimberg wrote:
> On 9/30/20 9:20 AM, Boris Pismenny wrote:
>> This commit introduces direct data placement offload to NVME
>> TCP. There is a context per queue, which is established after the
>> handshake
>> using the tcp_ddp_sk_add/del NDOs.
>>
>> Additionally, a resynchronization routine is used to assist
>> hardware recovery from TCP OOO, and continue the offload.
>> Resynchronization operates as follows:
>> 1. TCP OOO causes the NIC HW to stop the offload
>> 2. NIC HW identifies a PDU header at some TCP sequence number,
>> and asks NVMe-TCP to confirm it.
>> This request is delivered from the NIC driver to NVMe-TCP by first
>> finding the socket for the packet that triggered the request, and
>> then fiding the nvme_tcp_queue that is used by this routine.
>> Finally, the request is recorded in the nvme_tcp_queue.
>> 3. When NVMe-TCP observes the requested TCP sequence, it will compare
>> it with the PDU header TCP sequence, and report the result to the
>> NIC driver (tcp_ddp_resync), which will update the HW,
>> and resume offload when all is successful.
>>
>> Furthermore, we let the offloading driver advertise what is the max hw
>> sectors/segments via tcp_ddp_limits.
>>
>> A follow-up patch introduces the data-path changes required for this
>> offload.
>>
>> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
>> Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
>> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
>> Signed-off-by: Yoray Zack <yorayz@mellanox.com>
>> ---
>>   drivers/nvme/host/tcp.c  | 188 +++++++++++++++++++++++++++++++++++++++
>>   include/linux/nvme-tcp.h |   2 +
>>   2 files changed, 190 insertions(+)
>>
>> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
>> index 8f4f29f18b8c..06711ac095f2 100644
>> --- a/drivers/nvme/host/tcp.c
>> +++ b/drivers/nvme/host/tcp.c
>> @@ -62,6 +62,7 @@ enum nvme_tcp_queue_flags {
>>   	NVME_TCP_Q_ALLOCATED	= 0,
>>   	NVME_TCP_Q_LIVE		= 1,
>>   	NVME_TCP_Q_POLLING	= 2,
>> +	NVME_TCP_Q_OFFLOADS     = 3,
>>   };
>>   
>>   enum nvme_tcp_recv_state {
>> @@ -110,6 +111,8 @@ struct nvme_tcp_queue {
>>   	void (*state_change)(struct sock *);
>>   	void (*data_ready)(struct sock *);
>>   	void (*write_space)(struct sock *);
>> +
>> +	atomic64_t  resync_req;
>>   };
>>   
>>   struct nvme_tcp_ctrl {
>> @@ -129,6 +132,8 @@ struct nvme_tcp_ctrl {
>>   	struct delayed_work	connect_work;
>>   	struct nvme_tcp_request async_req;
>>   	u32			io_queues[HCTX_MAX_TYPES];
>> +
>> +	struct net_device       *offloading_netdev;
>>   };
>>   
>>   static LIST_HEAD(nvme_tcp_ctrl_list);
>> @@ -223,6 +228,159 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
>>   	return nvme_tcp_pdu_data_left(req) <= len;
>>   }
>>   
>> +#ifdef CONFIG_TCP_DDP
>> +
>> +bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
>> +const struct tcp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops __read_mostly = {
>> +	.resync_request		= nvme_tcp_resync_request,
>> +};
>> +
>> +static
>> +int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue,
>> +			    struct nvme_tcp_config *config)
>> +{
>> +	struct net_device *netdev = get_netdev_for_sock(queue->sock->sk, true);
>> +	struct tcp_ddp_config *ddp_config = (struct tcp_ddp_config *)config;
>> +	int ret;
>> +
>> +	if (unlikely(!netdev)) {
> Let's remove unlikely from non datapath routines, its slightly
> confusing.
>
>> +		pr_info_ratelimited("%s: netdev not found\n", __func__);
> dev_info_ratelimited with queue->ctrl->ctrl.device ?
> Also, lets remove __func__. This usually is not very helpful.
>
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!(netdev->features & NETIF_F_HW_TCP_DDP)) {
>> +		dev_put(netdev);
>> +		return -EINVAL;
> EINVAL or ENODEV?
ENODEV seems more appropriate, we'll use it. Thanks
>> +	}
>> +
>> +	ret = netdev->tcp_ddp_ops->tcp_ddp_sk_add(netdev,
>> +						 queue->sock->sk,
>> +						 ddp_config);
>> +	if (!ret)
>> +		inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
>> +	else
>> +		dev_put(netdev);
>> +	return ret;
>> +}
>> +
>> +static
>> +void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
>> +{
>> +	struct net_device *netdev = queue->ctrl->offloading_netdev;
>> +
>> +	if (unlikely(!netdev)) {
>> +		pr_info_ratelimited("%s: netdev not found\n", __func__);
> Same here.
>
>> +		return;
>> +	}
>> +
>> +	netdev->tcp_ddp_ops->tcp_ddp_sk_del(netdev, queue->sock->sk);
>> +
>> +	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = NULL;
> Just a general question, why is this needed?
This assignment is symmetric with the nvme_tcp_offload_socket assignment. The idea was to ensure that the functions established during offload cannot be used from this moment.

>> +	dev_put(netdev); /* put the queue_init get_netdev_for_sock() */
>> +}
>> +
>> +static
>> +int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue,
>> +			    struct tcp_ddp_limits *limits)
>> +{
>> +	struct net_device *netdev = get_netdev_for_sock(queue->sock->sk, true);
>> +	int ret = 0;
>> +
>> +	if (unlikely(!netdev)) {
>> +		pr_info_ratelimited("%s: netdev not found\n", __func__);
>> +		return -EINVAL;
> Same here
>
>> +	}
>> +
>> +	if (netdev->features & NETIF_F_HW_TCP_DDP &&
>> +	    netdev->tcp_ddp_ops &&
>> +	    netdev->tcp_ddp_ops->tcp_ddp_limits)
>> +			ret = netdev->tcp_ddp_ops->tcp_ddp_limits(netdev, limits);
>> +	else
>> +			ret = -EOPNOTSUPP;
>> +
>> +	if (!ret) {
>> +		queue->ctrl->offloading_netdev = netdev;
>> +		pr_info("%s netdev %s offload limits: max_ddp_sgl_len %d\n",
>> +			__func__, netdev->name, limits->max_ddp_sgl_len);
> dev_info, and given that it per-queue, please make it dev_dbg.
>
>> +		queue->ctrl->ctrl.max_segments = limits->max_ddp_sgl_len;
>> +		queue->ctrl->ctrl.max_hw_sectors =
>> +			limits->max_ddp_sgl_len << (ilog2(SZ_4K) - 9);
>> +	} else {
>> +		queue->ctrl->offloading_netdev = NULL;
> Maybe nullify in the controller setup intead?
It is already set to zero after allocation (i.e., kzalloc). The goal here is to ensure it is zero in case there is a reset and it was non zero due to offload being used in the past. 

>> +	}
>> +
>> +	dev_put(netdev);
>> +
>> +	return ret;
>> +}
>> +
>> +static
>> +void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
>> +			      unsigned int pdu_seq)
>> +{
>> +	struct net_device *netdev = queue->ctrl->offloading_netdev;
>> +	u64 resync_val;
>> +	u32 resync_seq;
>> +
>> +	if (unlikely(!netdev)) {
>> +		pr_info_ratelimited("%s: netdev not found\n", __func__);
>> +		return;
> What happens now, fallback to SW? Maybe dev_warn then..
> will the SW keep seeing these responses after one failed?
As long as there is no resync response the system falls back to software, and this message is emitted. I'll move it to below to display it only when it is relevant and not every time this function is called.

>> +	}
>> +
>> +	resync_val = atomic64_read(&queue->resync_req);
>> +	if ((resync_val & TCP_DDP_RESYNC_REQ) == 0)
>> +		return;
>> +
>> +	resync_seq = resync_val >> 32;
>> +	if (before(pdu_seq, resync_seq))
>> +		return;
> I think it will be better to pass the skb to this func and keep the
> pdu_seq contained locally.

This requires passing the offset to obtain the sequence:
u64 pdu_seq = TCP_SKB_CB(skb)->seq + *offset - queue->pdu_offset;

It makes the interface a bit ugly, IMO.

>> +
>> +	if (atomic64_cmpxchg(&queue->resync_req, resync_val, (resync_val - 1)))
>> +		netdev->tcp_ddp_ops->tcp_ddp_resync(netdev, queue->sock->sk, pdu_seq);
> A small comment on this manipulation may help the reader.
>
>> +}
>> +
>> +bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
>> +{
>> +	struct nvme_tcp_queue *queue = sk->sk_user_data;
>> +
>> +	atomic64_set(&queue->resync_req,
>> +		     (((uint64_t)seq << 32) | flags));
>> +
>> +	return true;
>> +}
>> +
>> +#else
>> +
>> +static
>> +int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue,
>> +			    struct nvme_tcp_config *config)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +static
>> +void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
>> +{}
>> +
>> +static
>> +int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue,
>> +			    struct tcp_ddp_limits *limits)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +static
>> +void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
>> +			      unsigned int pdu_seq)
>> +{}
>> +
>> +bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
>> +{
>> +	return false;
>> +}
>> +
>> +#endif
>> +
>>   static void nvme_tcp_init_iter(struct nvme_tcp_request *req,
>>   		unsigned int dir)
>>   {
>> @@ -628,6 +786,11 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>>   	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
>>   	int ret;
>>   
>> +	u64 pdu_seq = TCP_SKB_CB(skb)->seq + *offset - queue->pdu_offset;
>> +
>> +	if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags))
>> +		nvme_tcp_resync_response(queue, pdu_seq);
> Here, just pass in (queue, skb)

Do you mean (queue, skb, offset)?
We need the offset for the pdu_seq calculation above.

>> +
>>   	ret = skb_copy_bits(skb, *offset,
>>   		&pdu[queue->pdu_offset], rcv_len);
>>   	if (unlikely(ret))
>> @@ -1370,6 +1533,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
>>   {
>>   	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
>>   	struct nvme_tcp_queue *queue = &ctrl->queues[qid];
>> +	struct nvme_tcp_config config;
>> +	struct tcp_ddp_limits limits;
>>   	int ret, rcv_pdu_size;
>>   
>>   	queue->ctrl = ctrl;
>> @@ -1487,6 +1652,26 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
>>   #endif
>>   	write_unlock_bh(&queue->sock->sk->sk_callback_lock);
>>   
>> +	if (nvme_tcp_queue_id(queue) != 0) {
> 	if (!nvme_tcp_admin_queue(queue)) {
>
>> +		config.cfg.type		= TCP_DDP_NVME;
>> +		config.pfv		= NVME_TCP_PFV_1_0;
>> +		config.cpda		= 0;
>> +		config.dgst		= queue->hdr_digest ?
>> +						NVME_TCP_HDR_DIGEST_ENABLE : 0;
>> +		config.dgst		|= queue->data_digest ?
>> +						NVME_TCP_DATA_DIGEST_ENABLE : 0;
>> +		config.queue_size	= queue->queue_size;
>> +		config.queue_id		= nvme_tcp_queue_id(queue);
>> +		config.io_cpu		= queue->io_cpu;
> Can the config initialization move to nvme_tcp_offload_socket?

Definitely. The original idea of placing it here was that the nvme-tcp handshake may influence the parameters. But, at this moment, I realize that it is orthogonal.

>> +
>> +		ret = nvme_tcp_offload_socket(queue, &config);
>> +		if (!ret)
>> +			set_bit(NVME_TCP_Q_OFFLOADS, &queue->flags);
>> +	} else {
>> +		ret = nvme_tcp_offload_limits(queue, &limits);
>> +	}
> I'm thinking that instead of this conditional, we want to place
> nvme nvme_tcp_alloc_admin_queue in nvme_tcp_alloc_admin_queue, and
> also move nvme_tcp_alloc_admin_queue to __nvme_tcp_alloc_io_queues
> loop.

We need to do it only after the socket is connected to obtain the 5-tuple and the appropriate netdev, and preferably after the protocol handshake, as there is nothing to offload there.

>> +	/* offload is opportunistic - failure is non-critical */
> Than make it void...
>
>> +
>>   	return 0;
>>   
>>   err_init_connect:
>> @@ -1519,6 +1704,9 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
>>   	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
>>   	nvme_tcp_restore_sock_calls(queue);
>>   	cancel_work_sync(&queue->io_work);
>> +
>> +	if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags))
>> +		nvme_tcp_unoffload_socket(queue);
> Why not in nvme_tcp_free_queue, symmetric to the alloc?

Sure. I've tried to keep it close to the socket disconnect, which isn't symmetrical for some reason, which suggests that these are interchangable?!

>>   }
>>   
>>   static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
>> diff --git a/include/linux/nvme-tcp.h b/include/linux/nvme-tcp.h
>> index 959e0bd9a913..65df64c34ecd 100644
>> --- a/include/linux/nvme-tcp.h
>> +++ b/include/linux/nvme-tcp.h
>> @@ -8,6 +8,8 @@
>>   #define _LINUX_NVME_TCP_H
>>   
>>   #include <linux/nvme.h>
>> +#include <net/sock.h>
>> +#include <net/tcp_ddp.h>
> Why is this needed? I think we want to place this in tcp.c no?
Not needed. It's probably leftover from previous iterations on the code. Removed for the next iteration of the patchset.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F612AABAC
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 15:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgKHOqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 09:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHOqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 09:46:50 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316F3C0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 06:46:50 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id t11so5992641edj.13
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 06:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=vnFceaW+8mscDH815HlhItngZTzRyIa8sj9BZAwWtU4=;
        b=NEe+aXTfKYtiWMOLmyxRfSnDiUe3M9HiVtbtSwYPZX9/U4BgK73c0jPQHdiH1lWduX
         q6IYYhwYvdtpeJohRkzD4c1v/3VPGL9j04Gcb0QU/g2HhxGF/sqZAjZIaZXOp6kuy7LE
         kfMCd6EzNwX+Ljpoz0KKdfds8MR/PQeeQeH+87BGnDqhMgnuZUpagMXa2YC6W/W/ZHT9
         1JgbjiIx0hPoADyDlMw8giXnGdjIqIbq+2k7KUfevO2daa+nOE2x5DgMd3GUDbkPTcKA
         tDuQ5yeuvpIP/LEd1KSCijmPw+jiVIwJ0FCK1fuXg4GjKHevQ6tVJbG7n2Hepr0e3ZaH
         Omjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vnFceaW+8mscDH815HlhItngZTzRyIa8sj9BZAwWtU4=;
        b=ma/7l8AqoYIGKD4Kv675hZWi+WJiPVkZ95F+/3xpbnAMshw9v/Bg2kZHXysjGTAfJm
         M0WiFEYHlbjROEJ5hDJtwt6V52yqAPLY4SgsIYpLm+br43gWwrvkpSc1BdKvBpTATeKT
         q8bFHq6SLqgXaPsWplLS4a00P5/xU6Aw3SoKXhJdp2QYf/tE6VdZLW2B+PrCZv22wMWe
         J7K7Nqy1SEnGvfew5JAaqGlZ1rtmxtDEpJLcrtnhDofotFJAxjayW4IWdJh/GrLe5x84
         E++nbJPkvZkA9PLvD2R3Cu9IEwO3ztY2POw3BKlU44HoxcLpazE8Kcwe/MM8JlBlPxP5
         do/A==
X-Gm-Message-State: AOAM530FqPEPTMAG6E+bVyXbCHkPoiH/sfuWaOm5vr8vWSOp/GFauCHK
        hMJvA5Lpq7zTureXf4RwH74=
X-Google-Smtp-Source: ABdhPJxE+C6ozFbnRWrF6XkNxbrPq9f0cFvseaXfeT9nhnfutGl6IR1ck7ZMXXn+1R+f9M/CX6lJUQ==
X-Received: by 2002:a50:be8f:: with SMTP id b15mr10870511edk.180.1604846808791;
        Sun, 08 Nov 2020 06:46:48 -0800 (PST)
Received: from [132.68.43.131] ([132.68.43.131])
        by smtp.gmail.com with ESMTPSA id o20sm6144212eja.34.2020.11.08.06.46.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 06:46:48 -0800 (PST)
Subject: Re: [PATCH net-next RFC v1 07/10] nvme-tcp : Recalculate crc in the
 end of the capsule
To:     Sagi Grimberg <sagi@grimberg.me>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-8-borisp@mellanox.com>
 <a17cf1ca-4183-8f6c-8470-9d45febb755b@grimberg.me>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <d080bd0c-ca1d-42a6-bee7-e6aa4bcb6896@gmail.com>
Date:   Sun, 8 Nov 2020 16:46:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <a17cf1ca-4183-8f6c-8470-9d45febb755b@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/10/2020 1:44, Sagi Grimberg wrote:
>> crc offload of the nvme capsule. Check if all the skb bits
>> are on, and if not recalculate the crc in SW and check it.
> Can you clarify in the patch description that this is only
> for pdu data digest and not header digest?

Will do

>
>> This patch reworks the receive-side crc calculation to always
>> run at the end, so as to keep a single flow for both offload
>> and non-offload. This change simplifies the code, but it may degrade
>> performance for non-offload crc calculation.
> ??
>
>  From my scan it doeesn't look like you do that.. Am I missing something?
> Can you explain?

The performance of CRC data digest in the offload's fallback path may be less good compared to CRC calculation with skb_copy_and_hash.
To be clear, the fallback path is occurs when `queue->data_digest && test_bit(NVME_TCP_Q_OFF_CRC_RX, &queue->flags)`, while we receive SKBs where `skb->ddp_crc = 0`

>
>>   	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
>>   	if (!rq) {
>>   		dev_err(queue->ctrl->ctrl.device,
>> @@ -992,7 +1031,7 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>>   		recv_len = min_t(size_t, recv_len,
>>   				iov_iter_count(&req->iter));
>>   
>> -		if (queue->data_digest)
>> +		if (queue->data_digest && !test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags))
>>   			ret = skb_copy_and_hash_datagram_iter(skb, *offset,
>>   				&req->iter, recv_len, queue->rcv_hash);
> This is the skb copy and hash, not clear why you say that you move this
> to the end...

See the offload fallback path below

>
>>   		else
>> @@ -1012,7 +1051,6 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>>   
>>   	if (!queue->data_remaining) {
>>   		if (queue->data_digest) {
>> -			nvme_tcp_ddgst_final(queue->rcv_hash, &queue->exp_ddgst);
> If I instead do:
> 			if (!test_bit(NVME_TCP_Q_OFFLOADS,
>                                        &queue->flags))
> 				nvme_tcp_ddgst_final(queue->rcv_hash,
> 						     &queue->exp_ddgst);
>
> Does that help the mess in nvme_tcp_recv_ddgst?

Not really, as the code path there takes care of the fallback path, i.e. offloaded requested, but didn't succeed.

>
>>   			queue->ddgst_remaining = NVME_TCP_DIGEST_LENGTH;
>>   		} else {
>>   			if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
>> @@ -1033,8 +1071,11 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
>>   	char *ddgst = (char *)&queue->recv_ddgst;
>>   	size_t recv_len = min_t(size_t, *len, queue->ddgst_remaining);
>>   	off_t off = NVME_TCP_DIGEST_LENGTH - queue->ddgst_remaining;
>> +	bool ddgst_offload_fail;
>>   	int ret;
>>   
>> +	if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags))
>> +		nvme_tcp_device_ddgst_update(queue, skb);
>>   	ret = skb_copy_bits(skb, *offset, &ddgst[off], recv_len);
>>   	if (unlikely(ret))
>>   		return ret;
>> @@ -1045,12 +1086,21 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
>>   	if (queue->ddgst_remaining)
>>   		return 0;
>>   
>> -	if (queue->recv_ddgst != queue->exp_ddgst) {
>> -		dev_err(queue->ctrl->ctrl.device,
>> -			"data digest error: recv %#x expected %#x\n",
>> -			le32_to_cpu(queue->recv_ddgst),
>> -			le32_to_cpu(queue->exp_ddgst));
>> -		return -EIO;
>> +	ddgst_offload_fail = !nvme_tcp_device_ddgst_ok(queue);
>> +	if (!test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags) ||
>> +	    ddgst_offload_fail) {
>> +		if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags) &&
>> +		    ddgst_offload_fail)
>> +			nvme_tcp_crc_recalculate(queue, pdu);
>> +
>> +		nvme_tcp_ddgst_final(queue->rcv_hash, &queue->exp_ddgst);
>> +		if (queue->recv_ddgst != queue->exp_ddgst) {
>> +			dev_err(queue->ctrl->ctrl.device,
>> +				"data digest error: recv %#x expected %#x\n",
>> +				le32_to_cpu(queue->recv_ddgst),
>> +				le32_to_cpu(queue->exp_ddgst));
>> +			return -EIO;
> This gets convoluted here...

Will try to simplify, the general idea is that there are 3 paths with common code:
1. non-offload
2. offload failed
3. offload success
(1) and (2) share the code for finalizing checking the data digest, while (3) skips this entirely.

In other words, how about this:
```
          offload_fail = !nvme_tcp_ddp_ddgst_ok(queue);                                               
          offload = test_bit(NVME_TCP_Q_OFF_CRC_RX, &queue->flags);                                   
          if (!offload || offload_fail) {                                                             
                  if (offload && offload_fail) // software-fallback                                   
                          nvme_tcp_ddp_ddgst_recalc(queue, pdu);                                      
                                                                                                      
                  nvme_tcp_ddgst_final(queue->rcv_hash, &queue->exp_ddgst);                           
                  if (queue->recv_ddgst != queue->exp_ddgst) {                                        
                          dev_err(queue->ctrl->ctrl.device,                                           
                                  "data digest error: recv %#x expected %#x\n",                       
                                  le32_to_cpu(queue->recv_ddgst),                                     
                                  le32_to_cpu(queue->exp_ddgst));                                     
                          return -EIO;                                                                
                  }                                                                                   
          } 
```

>
>> +		}
>>   	}
>>   
>>   	if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
>>


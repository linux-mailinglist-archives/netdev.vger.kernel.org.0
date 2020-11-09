Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4502AC935
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbgKIXSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:18:35 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39691 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730005AbgKIXSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 18:18:35 -0500
Received: by mail-wr1-f65.google.com with SMTP id o15so2819996wru.6
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 15:18:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0YUh8L7igoV3Pzcq684BHezCnL4xDkpIMR3kxjUfhDw=;
        b=HwVa2W13ZHy0wl6fVsRCaI/vQdjRCoGNIZDQ8AT9YAPT/6qNkeds6yVCygAiWAIicN
         MFTxjtErl9vLRLufJdVKh4WbMvS8POQW/Iu3E/XP//EcK91bAxxVmDgURQdChluRfM4W
         IC3OBWN3VzbDXgxqPaeu/u2sLktrvTdrIDSXXYRX3EnYJX77u60Z/iDm287btOLhhypI
         QfVC36LGRkx1dMtBYVdxI88jBNm8GmDfvGtyQSUUZ1qtvi8MzMnrW21Elgmm0LmXQike
         2BlS31LkDTL53k+0gixgXJDToQoNmhVX+qCFdf2Bs1D9bCNhzgo/MxPjUxrGTYVRzf8p
         NzLw==
X-Gm-Message-State: AOAM533PLJAteLBKVjKasBBVrgm/VGnL3soOpXisA8NfRbAXZAM13yAH
        UAfx3+em7oBYPsEu1snFYYk=
X-Google-Smtp-Source: ABdhPJwTJP+kcO34FQBhF84j4wYWYrX3gHu1JcY3IRtqd+adZxWOzZByr1bdZbEPgH8eCmoqU+QEZg==
X-Received: by 2002:adf:e3c2:: with SMTP id k2mr18037603wrm.82.1604963913736;
        Mon, 09 Nov 2020 15:18:33 -0800 (PST)
Received: from ?IPv6:2601:647:4802:9070:f26a:270b:f54c:37eb? ([2601:647:4802:9070:f26a:270b:f54c:37eb])
        by smtp.gmail.com with ESMTPSA id t5sm957612wmg.19.2020.11.09.15.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 15:18:32 -0800 (PST)
Subject: Re: [PATCH net-next RFC v1 06/10] nvme-tcp: Add DDP data-path
To:     Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-7-borisp@mellanox.com>
 <5a23d221-fd3e-5802-ce68-7edec55068bb@grimberg.me>
 <12692704-126a-4242-f0a9-f00db6071e40@gmail.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <37baeb0e-b6c5-7661-b871-6a51c1a2e804@grimberg.me>
Date:   Mon, 9 Nov 2020 15:18:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <12692704-126a-4242-f0a9-f00db6071e40@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>>    static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>>> @@ -1115,6 +1222,7 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
>>>    	bool inline_data = nvme_tcp_has_inline_data(req);
>>>    	u8 hdgst = nvme_tcp_hdgst_len(queue);
>>>    	int len = sizeof(*pdu) + hdgst - req->offset;
>>> +	struct request *rq = blk_mq_rq_from_pdu(req);
>>>    	int flags = MSG_DONTWAIT;
>>>    	int ret;
>>>    
>>> @@ -1123,6 +1231,10 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
>>>    	else
>>>    		flags |= MSG_EOR;
>>>    
>>> +	if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags) &&
>>> +	    blk_rq_nr_phys_segments(rq) && rq_data_dir(rq) == READ)
>>> +		nvme_tcp_setup_ddp(queue, pdu->cmd.common.command_id, rq);
>> I'd assume that this is something we want to setup in
>> nvme_tcp_setup_cmd_pdu. Why do it here?
> Our goal in placing it here is to keep both setup and teardown in the same thread.
> This enables drivers to avoid locking for per-queue operations.

I also think that it is cleaner when setting up the PDU. Do note that if
queues match 1x1 with cpu cores then any synchronization is pretty
lightweight, and if not, we have other synchronizations anyways...

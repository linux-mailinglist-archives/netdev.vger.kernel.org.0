Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283C1287EF2
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 01:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgJHXAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 19:00:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41507 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729973AbgJHXAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 19:00:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id w5so8296288wrp.8
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 16:00:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=38f/duVbixFUEajq4NL1BIVEfot3FVrKIDXch2dCmrg=;
        b=lWb2Ib3htGNqrDWhzE3C8KK0jkO1BFAmIfzE9ZCYa2qVgQEjv2YGtILfd9dSlLrhXD
         L8QLO+FhdenYupvWyv/XHTaiw1/Z2iOYGanL9SBfdRqmtF6VjmDDl0fK1kX4aFf6OW+c
         IB42ZYaZl52o9xncvs0LpkwDBTJCDAAItnbgvq2/PVdUAGIYCxqBLmI/HRhhLZHgbMYg
         X9lIhbR5RIjD6agdr4tGFp5fIubRm7PL5Ma2/qxTc3i/DlhOh/9SOH+8bjXQ6DdiOqK8
         z6GGZGBIU5mT3iCX6gaHI8EzCMQy2tbQ4CMIIJ9SHTMhYSWH0KYmZHP7QyfsLfomMOMB
         Ln0w==
X-Gm-Message-State: AOAM530IoU/wqtBV44rPYcYPkbiDlzmBMuJdZQl5Rrj0cMz0q8oU7BfB
        +Ab3wBC8hkXe0k899RfU6AY=
X-Google-Smtp-Source: ABdhPJyYQV8orChJxD9Awr46bhR7KBjokewpm63kTc6Qy9IJH68cZDl9tMp4Q06Mjtf4d/bmdvOl3g==
X-Received: by 2002:a05:6000:110f:: with SMTP id z15mr11170990wrw.87.1602198036164;
        Thu, 08 Oct 2020 16:00:36 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:68d6:3fd5:5a8b:9959? ([2601:647:4802:9070:68d6:3fd5:5a8b:9959])
        by smtp.gmail.com with ESMTPSA id c16sm9788515wrx.31.2020.10.08.16.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 16:00:35 -0700 (PDT)
Subject: Re: [PATCH net-next RFC v1 06/10] nvme-tcp: Add DDP data-path
From:   Sagi Grimberg <sagi@grimberg.me>
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-7-borisp@mellanox.com>
 <5a23d221-fd3e-5802-ce68-7edec55068bb@grimberg.me>
Message-ID: <24ea956e-40a2-8b7b-cf8a-b604e7cd5644@grimberg.me>
Date:   Thu, 8 Oct 2020 16:00:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5a23d221-fd3e-5802-ce68-7edec55068bb@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>   static
>>   int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue,
>>                   struct nvme_tcp_config *config)
>> @@ -630,6 +720,7 @@ static void nvme_tcp_error_recovery(struct 
>> nvme_ctrl *ctrl)
>>   static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
>>           struct nvme_completion *cqe)
>>   {
>> +    struct nvme_tcp_request *req;
>>       struct request *rq;
>>       rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), cqe->command_id);
>> @@ -641,8 +732,15 @@ static int nvme_tcp_process_nvme_cqe(struct 
>> nvme_tcp_queue *queue,
>>           return -EINVAL;
>>       }
>> -    if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
>> -        nvme_complete_rq(rq);
>> +    req = blk_mq_rq_to_pdu(rq);
>> +    if (req->offloaded) {
>> +        req->status = cqe->status;
>> +        req->result = cqe->result;
>> +        nvme_tcp_teardown_ddp(queue, cqe->command_id, rq);
>> +    } else {
>> +        if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
>> +            nvme_complete_rq(rq);
>> +    }

Oh forgot to ask,

We have places in the driver that we may complete (cancel) one
or more requests from the error recovery or timeout flow. We
first prevent future incoming RX on the socket such that we
can safely cancel requests. This may break with the deferred
completion in ddp_teardown_done.

If I have a request that is waiting for ddp_teardown_done do
I have a way to tell the HW to never call ddp_teardown_done
on a specific socket?

If so the place to is in nvme_tcp_stop_queue.

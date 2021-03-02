Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF3532A36D
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446351AbhCBI5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:57:00 -0500
Received: from mga06.intel.com ([134.134.136.31]:57818 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381544AbhCBIFJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 03:05:09 -0500
IronPort-SDR: hyhmsc4zGNJ+Fn6JkJR70aikt/B+udecgH643/wfA80JLtnJUPm7VodEleTOle3Us71ewMCR4k
 VTMkEg0FmcDA==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="248133484"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="248133484"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 00:04:24 -0800
IronPort-SDR: 7/BMllbf0SeMqe4vEt4uKehpWuloRQC3+IJfz0KXBLYfrdR1YrQwMeewI3BV+QKj35YlT5CY0Z
 0fYwlKvZ+CKg==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="398268019"
Received: from ilick-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.41.237])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 00:04:20 -0800
Subject: Re: [PATCH bpf-next 1/2] xsk: update rings for
 load-acquire/store-release semantics
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, paulmck@kernel.org
Cc:     magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, andrii@kernel.org
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
 <20210301104318.263262-2-bjorn.topel@gmail.com> <87mtvmx3ec.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <939aefb5-8f03-fc5a-9e8b-0b634aafd0a4@intel.com>
Date:   Tue, 2 Mar 2021 09:04:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <87mtvmx3ec.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On 2021-03-01 17:08, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@gmail.com> writes:
> 
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Currently, the AF_XDP rings uses smp_{r,w,}mb() fences on the
>> kernel-side. By updating the rings for load-acquire/store-release
>> semantics, the full barrier on the consumer side can be replaced with
>> improved performance as a nice side-effect.
>>
>> Note that this change does *not* require similar changes on the
>> libbpf/userland side, however it is recommended [1].
>>
>> On x86-64 systems, by removing the smp_mb() on the Rx and Tx side, the
>> l2fwd AF_XDP xdpsock sample performance increases by
>> 1%. Weakly-ordered platforms, such as ARM64 might benefit even more.
>>
>> [1] https://lore.kernel.org/bpf/20200316184423.GA14143@willie-the-truck/
>>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> ---
>>   net/xdp/xsk_queue.h | 27 +++++++++++----------------
>>   1 file changed, 11 insertions(+), 16 deletions(-)
>>
>> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
>> index 2823b7c3302d..e24279d8d845 100644
>> --- a/net/xdp/xsk_queue.h
>> +++ b/net/xdp/xsk_queue.h
>> @@ -47,19 +47,18 @@ struct xsk_queue {
>>   	u64 queue_empty_descs;
>>   };
>>   
>> -/* The structure of the shared state of the rings are the same as the
>> - * ring buffer in kernel/events/ring_buffer.c. For the Rx and completion
>> - * ring, the kernel is the producer and user space is the consumer. For
>> - * the Tx and fill rings, the kernel is the consumer and user space is
>> - * the producer.
>> +/* The structure of the shared state of the rings are a simple
>> + * circular buffer, as outlined in
>> + * Documentation/core-api/circular-buffers.rst. For the Rx and
>> + * completion ring, the kernel is the producer and user space is the
>> + * consumer. For the Tx and fill rings, the kernel is the consumer and
>> + * user space is the producer.
>>    *
>>    * producer                         consumer
>>    *
>> - * if (LOAD ->consumer) {           LOAD ->producer
>> - *                    (A)           smp_rmb()       (C)
>> + * if (LOAD ->consumer) {  (A)      LOAD.acq ->producer  (C)
> 
> Why is LOAD.acq not needed on the consumer side?
>

You mean why LOAD.acq is not needed on the *producer* side, i.e. the
->consumer? The ->consumer is a control dependency for the store, so
there is no ordering constraint for ->consumer at producer side. If
there's no space, no data is written. So, no barrier is needed there --
at least that has been my perspective.

This is very similar to the buffer in
Documentation/core-api/circular-buffers.rst. Roping in Paul for some
guidance.


Björn

> -Toke
> 

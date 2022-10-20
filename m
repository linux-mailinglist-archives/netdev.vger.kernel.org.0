Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F00606390
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiJTOwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiJTOwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:52:07 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E97F12A9F;
        Thu, 20 Oct 2022 07:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=TIWtRz+9TftHiP5YNKoMEajC+fw9pADpE4a9PQRMj20=; b=2mTVvwe0Dq+A/LFaLlTa0R0tCD
        divDO81T0MAUebLwqijSydP8S8OyUZFL1+U3DBsIpxvbzHkDOoUnpS6FjfE0kJits20VrgMnTZxtc
        7kdNeUSPqrTLBsVvorbE/9oP5LAG4wE9swUStE4luDaFFJxM+gxnm/bz4NEz4jg1qLvQiEK+qqYVP
        SWvjTQJ7AuAfJ3QY3sOvGQWlj06WadhFkBMThxS0g/IENDhhu/k2HNw1YikphQqoR+2q7Kue0dXq4
        nYgGq8sIdSY0d1iUqGjzHpav4ZtM0oyzkz8qbt9covfSfI4H7RZR4wpaRtd51HC1KE5Q/VjKO8CwE
        Qdl7vm5q2O7YkhSNem6Y7UpikhjKJH3ad1/xHD1RU8NN0irodjN02lAAo3kXG0tjo9dLN9Q3RZ97U
        bMdWl59flgX8Cse8Fbqphu0tuMuxprTJCsEavLj5Iai24s4kdYf4D/qo5bJL7KPzlYNBxUN9dg6Rk
        2Xp/hzsiIrY4cMYX2fq1VHPi;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olWtu-0051Pl-CE; Thu, 20 Oct 2022 14:52:03 +0000
Message-ID: <e87610a6-27a6-6175-1c66-a8dcdc4c14cb@samba.org>
Date:   Thu, 20 Oct 2022 16:51:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US, de-DE
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
 <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
 <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
 <acad81e4-c2ef-59cc-5f0c-33b99082d270@samba.org>
 <d05e9a24-c02b-5f0d-e206-9053a786179e@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: IORING_SEND_NOTIF_REPORT_USAGE (was Re: IORING_CQE_F_COPIED)
In-Reply-To: <d05e9a24-c02b-5f0d-e206-9053a786179e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

>> So far I came up with a IORING_SEND_NOTIF_REPORT_USAGE opt-in flag
>> and the reporting is done in cqe.res with IORING_NOTIF_USAGE_ZC_USED (0x00000001)
>> and/or IORING_NOTIF_USAGE_ZC_COPIED (0x8000000). So the caller is also
>> able to notice that some parts were able to use zero copy, while other
>> fragments were copied.
> 
> Are we really interested in multihoming and probably some very edge cases?
> I'd argue we're not and it should be a single bool hint indicating whether
> zc is viable or not. It can do more complex calculations _if_ needed, e.g.
> looking inside skb's and figure out how many bytes were copied but as for me
> it should better be turned into a single bool in the end. Could also be the
> number of bytes copied, but I don't think we can't have the accuracy for
> that (e.g. what we're going to return if some protocol duplicates an skb
> and sends to 2 different devices or is processing it in a pipeline?)
> 
> So the question is what is the use case for having 2 flags?

It's mostly for debugging.

> btw, now we've got another example why the report flag is a good idea,

I don't understand that line...

> we can't use cqe.res unconditionally because we want to have a "one CQE
> per request" mode, but it's fine if we make it and the report flag
> mutually exclusive.

You mean we can add an optimized case where SEND[MSG]_ZC would not
generate F_MORE and skips F_NOTIF, because we copied or the transmission
path was really fast?

Then I'd move to IORING_CQE_F_COPIED again...

>> I haven't tested it yet, but I want to post it early...
>>
>> What do you think?
> 
> Keeping in mind potential backporting let's make it as simple and
> short as possible first and then do optimisations on top.

ok.

>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index ab7458033ee3..751fc4eff8d1 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -296,10 +296,28 @@ enum io_uring_op {
>>    *
>>    * IORING_RECVSEND_FIXED_BUF    Use registered buffers, the index is stored in
>>    *                the buf_index field.
>> + *
>> + * IORING_SEND_NOTIF_REPORT_USAGE
>> + *                If SEND[MSG]_ZC should report
>> + *                the zerocopy usage in cqe.res
>> + *                for the IORING_CQE_F_NOTIF cqe.
>> + *                IORING_NOTIF_USAGE_ZC_USED if zero copy was used
>> + *                (at least partially).
>> + *                IORING_NOTIF_USAGE_ZC_COPIED if data was copied
>> + *                (at least partially).
>>    */
>>   #define IORING_RECVSEND_POLL_FIRST    (1U << 0)
>>   #define IORING_RECV_MULTISHOT        (1U << 1)
>>   #define IORING_RECVSEND_FIXED_BUF    (1U << 2)
>> +#define IORING_SEND_NOTIF_REPORT_USAGE    (1U << 3)
>> +
>> +/*
>> + * cqe.res for IORING_CQE_F_NOTIF if
>> + * IORING_SEND_NOTIF_REPORT_USAGE was requested
>> + */
>> +#define IORING_NOTIF_USAGE_ZC_USED    (1U << 0)
>> +#define IORING_NOTIF_USAGE_ZC_COPIED    (1U << 31)
>> +
>>
>>   /*
>>    * accept flags stored in sqe->ioprio
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 735eec545115..a79d7d349e19 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -946,9 +946,11 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>
>>       zc->flags = READ_ONCE(sqe->ioprio);
>>       if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
>> -              IORING_RECVSEND_FIXED_BUF))
>> +              IORING_RECVSEND_FIXED_BUF |
>> +              IORING_SEND_NOTIF_REPORT_USAGE))
>>           return -EINVAL;
>> -    notif = zc->notif = io_alloc_notif(ctx);
>> +    notif = zc->notif = io_alloc_notif(ctx,
>> +                       zc->flags & IORING_SEND_NOTIF_REPORT_USAGE);
>>       if (!notif)
>>           return -ENOMEM;
>>       notif->cqe.user_data = req->cqe.user_data;
>> diff --git a/io_uring/notif.c b/io_uring/notif.c
>> index e37c6569d82e..3844e3c8ad7e 100644
>> --- a/io_uring/notif.c
>> +++ b/io_uring/notif.c
>> @@ -3,13 +3,14 @@
>>   #include <linux/file.h>
>>   #include <linux/slab.h>
>>   #include <linux/net.h>
>> +#include <linux/errqueue.h>
> 
> Is it needed?

No

>>   #include <linux/io_uring.h>
>>
>>   #include "io_uring.h"
>>   #include "notif.h"
>>   #include "rsrc.h"
>>
>> -static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
>> +static inline void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
> 
> Let's remove this hunk with inlining and do it later
> 
>>   {
>>       struct io_notif_data *nd = io_notif_to_data(notif);
>>       struct io_ring_ctx *ctx = notif->ctx;
>> @@ -21,20 +22,46 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
>>       io_req_task_complete(notif, locked);
>>   }
>>
>> -static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
>> -                      struct ubuf_info *uarg,
>> -                      bool success)
>> +static inline void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
>> +                         struct ubuf_info *uarg,
>> +                         bool success)
> 
> This one as well.
> 
> 
>>   {
>>       struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
>>       struct io_kiocb *notif = cmd_to_io_kiocb(nd);
>>
>>       if (refcount_dec_and_test(&uarg->refcnt)) {
>> -        notif->io_task_work.func = __io_notif_complete_tw;
>>           io_req_task_work_add(notif);
>>       }
>>   }
>>
>> -struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>> +static void __io_notif_complete_tw_report_usage(struct io_kiocb *notif, bool *locked)
> 
> Just shove all that into __io_notif_complete_tw().

Ok, and then optimze later?

Otherwise we could have IORING_CQE_F_COPIED by default without opt-in
flag...

>> +static void io_uring_tx_zerocopy_callback_report_usage(struct sk_buff *skb,
>> +                            struct ubuf_info *uarg,
>> +                            bool success)
>> +{
>> +    struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
>> +
>> +    if (success && !nd->zc_used && skb)
>> +        nd->zc_used = true;
>> +    else if (unlikely(!success && !nd->zc_copied))
>> +        nd->zc_copied = true;
> 
> It's fine but racy, so let's WRITE_ONCE() to indicate it.

I don't see how this could be a problem, but I can add it.

>> diff --git a/io_uring/notif.h b/io_uring/notif.h
>> index 5b4d710c8ca5..5ac7a2745e52 100644
>> --- a/io_uring/notif.h
>> +++ b/io_uring/notif.h
>> @@ -13,10 +13,12 @@ struct io_notif_data {
>>       struct file        *file;
>>       struct ubuf_info    uarg;
>>       unsigned long        account_pages;
>> +    bool            zc_used;
>> +    bool            zc_copied;
> 
> IIRC io_notif_data is fully packed in 6.1, so placing zc_{used,copied}
> there might complicate backporting (if any). We can place them in io_kiocb
> directly and move in 6.2. Alternatively account_pages doesn't have to be
> long.

As far as I can see kernel-dk-block/io_uring-6.1 alread has your
shrink patches included...


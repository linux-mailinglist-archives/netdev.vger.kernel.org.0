Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567EF68E656
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 03:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjBHC6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 21:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjBHC6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 21:58:35 -0500
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473293D93A;
        Tue,  7 Feb 2023 18:58:30 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Vb9nfQH_1675825106;
Received: from 30.221.145.160(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Vb9nfQH_1675825106)
          by smtp.aliyun-inc.com;
          Wed, 08 Feb 2023 10:58:27 +0800
Message-ID: <eed8b91e-0236-edc8-f744-e30adfff229f@linux.alibaba.com>
Date:   Wed, 8 Feb 2023 10:58:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [net-next 1/2] net/smc: allow confirm/delete rkey response
 deliver multiplex
Content-Language: en-US
To:     Wenjia Zhang <wenjia@linux.ibm.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1675755374-107598-1-git-send-email-alibuda@linux.alibaba.com>
 <1675755374-107598-2-git-send-email-alibuda@linux.alibaba.com>
 <95e117f1-6f05-1c15-cddd-38be9cf7dd52@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <95e117f1-6f05-1c15-cddd-38be9cf7dd52@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/8/23 7:15 AM, Wenjia Zhang wrote:
> 
> 
> On 07.02.23 08:36, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> We know that all flows except confirm_rkey and delete_rkey are exclusive,
>> confirm/delete rkey flows can run concurrently (local and remote).
>>
>> Although the protocol allows, all flows are actually mutually exclusive
>> in implementation, dues to waiting for LLC messages is in serial.
>>
>> This aggravates the time for establishing or destroying a SMC-R
>> connections, connections have to be queued in smc_llc_wait.
>>
>> We use rtokens or rkey to correlate a confirm/delete rkey message
>> with its response.
>>
>> Before sending a message, we put context with rtokens or rkey into
>> wait queue. When a response message received, we wakeup the context
>> which with the same rtokens or rkey against the response message.
>>
>> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
>> ---
>>   net/smc/smc_llc.c | 174 +++++++++++++++++++++++++++++++++++++++++-------------
>>   net/smc/smc_wr.c  |  10 ----
>>   net/smc/smc_wr.h  |  10 ++++
>>   3 files changed, 143 insertions(+), 51 deletions(-)
>>
> 
> [...]
> 
>> +static int smc_llc_rkey_response_wake_function(struct wait_queue_entry *wq_entry,
>> +                           unsigned int mode, int sync, void *key)
>> +{
>> +    struct smc_llc_qentry *except, *incoming;
>> +    u8 except_llc_type;
>> +
>> +    /* not a rkey response */
>> +    if (!key)
>> +        return 0;
>> +
>> +    except = wq_entry->private;
>> +    incoming = key;
>> +
>> +    except_llc_type = except->msg.raw.hdr.common.llc_type;
>> +
>> +    /* except LLC MSG TYPE mismatch */
>> +    if (except_llc_type != incoming->msg.raw.hdr.common.llc_type)
>> +        return 0;
>> +
>> +    switch (except_llc_type) {
>> +    case SMC_LLC_CONFIRM_RKEY:
>> +        if (memcmp(except->msg.confirm_rkey.rtoken, incoming->msg.confirm_rkey.rtoken,
>> +               sizeof(struct smc_rmb_rtoken) *
>> +               except->msg.confirm_rkey.rtoken[0].num_rkeys))
>> +            return 0;
>> +        break;
>> +    case SMC_LLC_DELETE_RKEY:
>> +        if (memcmp(except->msg.delete_rkey.rkey, incoming->msg.delete_rkey.rkey,
>> +               sizeof(__be32) * except->msg.delete_rkey.num_rkeys))
>> +            return 0;
>> +        break;
>> +    default:
>> +        pr_warn("smc: invalid except llc msg %d.\n", except_llc_type);
>> +        return 0;
>> +    }
>> +
>> +    /* match, save hdr */
>> +    memcpy(&except->msg.raw.hdr, &incoming->msg.raw.hdr, sizeof(except->msg.raw.hdr));
>> +
>> +    wq_entry->private = except->private;
>> +    return woken_wake_function(wq_entry, mode, sync, NULL);
>> +}
>> +
> 
> s/except/expect/ ?
> Just kind of confusing
> 
> [...]

Hi, Wenjia

Except is what I want to express.
It means that only the confirm and delete rkey can be processed in parallel. :-)

Thanks
D. Wythe


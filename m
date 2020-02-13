Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D8A15B9D3
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 07:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbgBMGzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 01:55:41 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:38423 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgBMGzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 01:55:41 -0500
Received: from [10.193.187.42] (win-egq4kmmdjvo.asicdesigners.com [10.193.187.42] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 01D6taFa029051;
        Wed, 12 Feb 2020 22:55:37 -0800
Subject: Re: [net] net/tls: Fix to avoid gettig invalid tls record
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20200212071630.26650-1-rohitm@chelsio.com>
 <20200212200945.34460c3a@cakuba.hsd1.ca.comcast.net>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <6a47e7aa-c98a-ede5-f0d6-ce2bdc4875e8@chelsio.com>
Date:   Thu, 13 Feb 2020 12:25:36 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20200212200945.34460c3a@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13/02/20 9:39 AM, Jakub Kicinski wrote:
> On Wed, 12 Feb 2020 12:46:30 +0530, Rohit Maheshwari wrote:
>> Current code doesn't check if tcp sequence number is starting from (/after)
>> 1st record's start sequnce number. It only checks if seq number is before
>> 1st record's end sequnce number. This problem will always be a possibility
>> in re-transmit case. If a record which belongs to a requested seq number is
>> already deleted, tls_get_record will start looking into list and as per the
>> check it will look if seq number is before the end seq of 1st record, which
>> will always be true and will return 1st record always, it should in fact
>> return NULL.
> I think I see your point, do you observe this problem in practice
> or did you find this through code review?
I am seeing this issue while running stress test.
>> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
>> index cd91ad812291..2898517298bf 100644
>> --- a/net/tls/tls_device.c
>> +++ b/net/tls/tls_device.c
>> @@ -602,7 +602,8 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
>>   		 */
>>   		info = list_first_entry_or_null(&context->records_list,
>>   						struct tls_record_info, list);
>> -		if (!info)
>> +		/* return NULL if seq number even before the 1st entry. */
>> +		if (!info || before(seq, info->end_seq - info->len))
> Is it not more appropriate to use between() in the actual comparison
> below? I feel like with this patch we can get false negatives.

If we use between(), though record doesn't exist, we still go and 
compare each record,

which I think, should actually be avoided.

>>   			return NULL;
>>   		record_sn = context->unacked_record_sn;
>>   	}
> If you post a v2 please add a Fixes tag and CC maintainers of this code.

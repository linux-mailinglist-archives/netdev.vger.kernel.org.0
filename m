Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C455278A46
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 16:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgIYOCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 10:02:34 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:12704 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbgIYOCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 10:02:34 -0400
Received: from [10.193.177.198] (venkat-suman.asicdesigners.com [10.193.177.198] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 08PE2Od0028279;
        Fri, 25 Sep 2020 07:02:25 -0700
Subject: Re: FW: [PATCH net] net/tls: sendfile fails with ktls offload
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200924075025.11626-1-rohitm@chelsio.com>
 <20200924145714.761f7c6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB40041504C9BB0C49546C9CE6EE360@BY5PR12MB4004.namprd12.prod.outlook.com>
Cc:     vakul.garg@nxp.com, secdev <secdev@chelsio.com>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <d0ff72b0-6d1f-d71e-5fe6-3b145fefacc5@chelsio.com>
Date:   Fri, 25 Sep 2020 19:32:23 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB40041504C9BB0C49546C9CE6EE360@BY5PR12MB4004.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, September 25, 2020 3:27 AM
> To: Rohit Maheshwari <rohitm@chelsio.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; vakul.garg@nxp.com; secdev <secdev@chelsio.com>
> Subject: Re: [PATCH net] net/tls: sendfile fails with ktls offload
>
> On Thu, 24 Sep 2020 13:20:25 +0530 Rohit Maheshwari wrote:
>> At first when sendpage gets called, if there is more data, 'more' in
>> tls_push_data() gets set which later sets pending_open_record_frags,
>> but when there is no more data in file left, and last time
>> tls_push_data() gets called, pending_open_record_frags doesn't get
>> reset. And later when
>> 2 bytes of encrypted alert comes as sendmsg, it first checks for
>> pending_open_record_frags, and since this is set, it creates a record
>> with
>> 0 data bytes to encrypt, meaning record length is prepend_size +
>> tag_size only, which causes problem.
> Agreed, looks like the value in pending_open_record_frags may be stale.
>
>>   We should set/reset pending_open_record_frags based on more bit.
> I think you implementation happens to work because there is always left over data when more is set, but I don't think that has to be the case.
Yes, with small file size, more bit won't be set, and so the existing code
works there. If more is not set, which means this should be the overall
record and so, we can continue putting header and TAG to make it a
complete record.
>
> Also shouldn't we update this field or destroy the record before the break on line 478?
If more is set, and payload is lesser than the max size, then we need to
hold on to get next sendpage and continue adding frags in the same record.
So I don't think we need to do any update or destroy the record. Please
correct me if I am wrong here.
>> Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
>> ---
>>   net/tls/tls_device.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c index
>> b74e2741f74f..a02aadefd86e 100644
>> --- a/net/tls/tls_device.c
>> +++ b/net/tls/tls_device.c
>> @@ -492,11 +492,11 @@ static int tls_push_data(struct sock *sk,
>>   		if (!size) {
>>   last_record:
>>   			tls_push_record_flags = flags;
>> -			if (more) {
>> -				tls_ctx->pending_open_record_frags =
>> -						!!record->num_frags;
>> +			/* set/clear pending_open_record_frags based on more */
>> +			tls_ctx->pending_open_record_frags = !!more;
>> +
>> +			if (more)
>>   				break;
>> -			}
>>   
>>   			done = true;
>>   		}

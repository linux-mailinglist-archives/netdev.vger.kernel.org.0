Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A164D6469A9
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 08:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiLHHVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 02:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLHHVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 02:21:15 -0500
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED79429B0;
        Wed,  7 Dec 2022 23:21:12 -0800 (PST)
Received: from sas1-7470331623bb.qloud-c.yandex.net (sas1-7470331623bb.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd1e:0:640:7470:3316])
        by forwardcorp1c.mail.yandex.net (Yandex) with ESMTP id DC6CD5EA31;
        Thu,  8 Dec 2022 10:21:10 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b508::1:9] (unknown [2a02:6b8:b081:b508::1:9])
        by sas1-7470331623bb.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 9LTVHD0Q1uQ1-9HwNS8bl;
        Thu, 08 Dec 2022 10:21:10 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1670484070; bh=PFKUye++mZH6wL0b2UDNrP0wC14IIRxlwdFXpy4yqQE=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=lh8v9eF2fLkc1yBcbAW4xC06fyz5scS8E4GH9TFQwEKA75PinjIvg5gX+1WrPLMov
         CzAcBPiEK52KxNFOe66sniwwxdOeUIVpbInnNBKPnL0jvo4CAevApzi5raRDUPlf1/
         1TYqcKKXJKJy/B8VH56WnWrh6sJoo8YQ31UmN4uY=
Authentication-Results: sas1-7470331623bb.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <bc387a08-e5ad-7a6b-2af4-61f79090277b@yandex-team.ru>
Date:   Thu, 8 Dec 2022 10:21:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v1] drivers/vhost/vhost: fix overflow checks in
 vhost_overflow
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221207134631.907221-1-d-tatianin@yandex-team.ru>
 <20221207100028-mutt-send-email-mst@kernel.org>
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
In-Reply-To: <20221207100028-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/22 6:01 PM, Michael S. Tsirkin wrote:
> On Wed, Dec 07, 2022 at 04:46:31PM +0300, Daniil Tatianin wrote:
>> The if statement would erroneously check for > ULONG_MAX, which could
>> never evaluate to true. Check for equality instead.
>>
>> Found by Linux Verification Center (linuxtesting.org) with the SVACE
>> static analysis tool.
>>
>> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> 
> It can trigger on a 32 bit system. I'd also expect more analysis
> of the code flow than "this can not trigger switch to a condition
> that can" to accompany a patch.

Oops, my bad. It can trigger on 32 bit indeed. Sorry, completely 
overlooked that.

Thanks

>> ---
>>   drivers/vhost/vhost.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 40097826cff0..8df706e7bc6c 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -730,7 +730,7 @@ static bool log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
>>   /* Make sure 64 bit math will not overflow. */
>>   static bool vhost_overflow(u64 uaddr, u64 size)
>>   {
>> -	if (uaddr > ULONG_MAX || size > ULONG_MAX)
>> +	if (uaddr == ULONG_MAX || size == ULONG_MAX)
>>   		return true;
>>   
>>   	if (!size)
>> -- 
>> 2.25.1
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB2B2B55D5
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731528AbgKQApU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:45:20 -0500
Received: from novek.ru ([213.148.174.62]:34054 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729748AbgKQApT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 19:45:19 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 09F9F501633;
        Tue, 17 Nov 2020 03:45:22 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 09F9F501633
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1605573924; bh=5Q4YE6aP0NZRkEB5N0FFOoWKgU7jPq3mr/xplvjUR80=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=zRYDqT3LGw6AkSv0wFU8kERIShHHqdp15Xtdbyx7Q8ALGGGJIbfWUYnl4WQc3Uijr
         j+iQGX73f/g255kV+p9WjbzlYBHWuGK8RXrzXTenP+kyqVw+N4VKNjBugIOuX4nKlz
         0WljwUK0LLK58OyaswYHBmXGYGl7K66C8s0h/1Oo=
Subject: Re: [net v2] net/tls: fix corrupted data in recvmsg
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
References: <1605413760-21153-1-git-send-email-vfedorenko@novek.ru>
 <20201116162608.2c54953e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <cd2f4bfe-8fff-ddab-d271-08f0917a5b48@novek.ru>
Date:   Tue, 17 Nov 2020 00:45:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201116162608.2c54953e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17.11.2020 00:26, Jakub Kicinski wrote:
> On Sun, 15 Nov 2020 07:16:00 +0300 Vadim Fedorenko wrote:
>> If tcp socket has more data than Encrypted Handshake Message then
>> tls_sw_recvmsg will try to decrypt next record instead of returning
>> full control message to userspace as mentioned in comment. The next
>> message - usually Application Data - gets corrupted because it uses
>> zero copy for decryption that's why the data is not stored in skb
>> for next iteration. Revert check to not decrypt next record if
>> current is not Application Data.
>>
>> Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
>> ---
>>   net/tls/tls_sw.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
>> index 95ab5545..2fe9e2c 100644
>> --- a/net/tls/tls_sw.c
>> +++ b/net/tls/tls_sw.c
>> @@ -1913,7 +1913,7 @@ int tls_sw_recvmsg(struct sock *sk,
>>   			 * another message type
>>   			 */
>>   			msg->msg_flags |= MSG_EOR;
>> -			if (ctx->control != TLS_RECORD_TYPE_DATA)
>> +			if (control != TLS_RECORD_TYPE_DATA)
> Sorry I wasn't clear enough, should this be:
>
> 	if (ctx->control != control)
>
> ? Otherwise if we get a control record first and then data record
> the code will collapse them, which isn't correct, right?
>
>>   				goto recv_end;
>>   		} else {
>>   			break;
I think you mean when ctx->control is control record and control is
data record. In this case control message will be decrypted without
zero copy and will be stored in skb for the next recvmsg, but will
not be returned together with data message. This behavior is the same
as for TLSv1.3 when record type is known only after decrypting.
But if we want completely different flow for TLSv1.2 and TLSv1.3
then changing to check difference in message types makes sense.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A8A426542
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 09:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhJHHdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 03:33:36 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:40652
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhJHHde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 03:33:34 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 28BC03FFEC;
        Fri,  8 Oct 2021 07:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633678297;
        bh=HYKDYRv4ACCCCRFZVdX5tbCCNp3GSohCdohT0QXL328=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=s4onm8XfYrZ5gczSWi5UzSKNlcrQuR/vkuTRL9cM92IvQP2dNsFMrd6223v9QfyEi
         Wz4CXNiSnjTSrBmXJQN7i3y99uJsYM9ctegjhtHGskd/pJo4XzMYDL/vsLfTvMSDcL
         wJzGVLcZy3QEwaYH3z1ZVYiRL0/8mieS6W64Fn9J0IkqOt8Dkx9i2n32zkyVu3BCxy
         1l/wAUthAEnjMob8dUwdotWp9f7upbyMvs/9zfzNoQYbdG9KPcTaYKjr3SIoJc6zbC
         ptmDamcGNFOTKsXhx3mJK0gYGKOPHrPuu6rGQQ3pJVYUf058Cb9+/I+4SDZj75Ox+8
         2IcYXQUVF+cAg==
Message-ID: <382b719f-f14e-2963-284d-c0b38dedc4ae@canonical.com>
Date:   Fri, 8 Oct 2021 08:31:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH] carl9170: Fix error return -EAGAIN if not started
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211008001558.32416-1-colin.king@canonical.com>
 <20211008055854.GE2048@kadam>
From:   Colin Ian King <colin.king@canonical.com>
In-Reply-To: <20211008055854.GE2048@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/10/2021 06:58, Dan Carpenter wrote:
> On Fri, Oct 08, 2021 at 01:15:58AM +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> There is an error return path where the error return is being
>> assigned to err rather than count and the error exit path does
>> not return -EAGAIN as expected. Fix this by setting the error
>> return to variable count as this is the value that is returned
>> at the end of the function.
>>
>> Addresses-Coverity: ("Unused value")
>> Fixes: 00c4da27a421 ("carl9170: firmware parser and debugfs code")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>   drivers/net/wireless/ath/carl9170/debug.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
>> index bb40889d7c72..f163c6bdac8f 100644
>> --- a/drivers/net/wireless/ath/carl9170/debug.c
>> +++ b/drivers/net/wireless/ath/carl9170/debug.c
>> @@ -628,7 +628,7 @@ static ssize_t carl9170_debugfs_bug_write(struct ar9170 *ar, const char *buf,
>>   
>>   	case 'R':
>>   		if (!IS_STARTED(ar)) {
>> -			err = -EAGAIN;
>> +			count = -EAGAIN;
>>   			goto out;
> 
> This is ugly.  The bug wouldn't have happened with a direct return, it's
> only the goto out which causes it.  Better to replace all the error
> paths with direct returns.  There are two other direct returns so it's
> not like a new thing...

Yep, I agree it was ugly, I was trying to keep to the coding style and 
reduce the patch delta size. I can do a V2 if the maintainers deem it's 
a cleaner solution.

> 
> Goto out on the success path is fine here, though.

Yep. I believe that a goto to one exit return point (may possibly?) make 
the code smaller rather than a sprinkling of returns in a function, so 
I'm never sure if this is a win or not with these kind of cases.

Colin
> 
> regards,
> dan carpenter
> 


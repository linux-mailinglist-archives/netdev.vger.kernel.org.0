Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CE82D1AE4
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgLGUo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:44:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47437 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgLGUoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 15:44:55 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kmNMg-0004h9-5f; Mon, 07 Dec 2020 20:44:10 +0000
Subject: Re: [PATCH][next] seg6: fix unintentional integer overflow on left
 shift
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20201207144503.169679-1-colin.king@canonical.com>
 <20201207205926.6222eca38744c43632248a41@uniroma2.it>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <b969c10e-d5eb-6056-ddcd-9ae70846eb4a@canonical.com>
Date:   Mon, 7 Dec 2020 20:44:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201207205926.6222eca38744c43632248a41@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/12/2020 19:59, Andrea Mayer wrote:
> On Mon,  7 Dec 2020 14:45:03 +0000
> Colin King <colin.king@canonical.com> wrote:
> 
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Shifting the integer value 1 is evaluated using 32-bit arithmetic
>> and then used in an expression that expects a unsigned long value
>> leads to a potential integer overflow. Fix this by using the BIT
>> macro to perform the shift to avoid the overflow.
>>
>> Addresses-Coverity: ("Uninitentional integer overflow")
>> Fixes: 964adce526a4 ("seg6: improve management of behavior attributes")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  net/ipv6/seg6_local.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
>> index b07f7c1c82a4..d68de8cd1207 100644
>> --- a/net/ipv6/seg6_local.c
>> +++ b/net/ipv6/seg6_local.c
>> @@ -1366,7 +1366,7 @@ static void __destroy_attrs(unsigned long parsed_attrs, int max_parsed,
>>  	 * attribute; otherwise, we call the destroy() callback.
>>  	 */
>>  	for (i = 0; i < max_parsed; ++i) {
>> -		if (!(parsed_attrs & (1 << i)))
>> +		if (!(parsed_attrs & BIT(i)))
>>  			continue;
>>  
>>  		param = &seg6_action_params[i];
>> -- 
>> 2.29.2
>>
> 
> Hi Colin,
> thanks for the fix. I've just given a look a the whole seg6_local.c code and I
> found that such issues is present in other parts of the code.
> 
> If we agree, I can make a fix which explicitly eliminates the several (1 << i)
> in favor of BIT(i).

Sounds good to me.

Colin

> 
> Andrea
> 


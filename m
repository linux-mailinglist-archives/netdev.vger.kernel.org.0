Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E5C67172A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 10:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjARJMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 04:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjARJLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 04:11:06 -0500
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:df01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379C16B982;
        Wed, 18 Jan 2023 00:29:38 -0800 (PST)
Received: from myt6-23a5e62c0090.qloud-c.yandex.net (myt6-23a5e62c0090.qloud-c.yandex.net [IPv6:2a02:6b8:c12:1da3:0:640:23a5:e62c])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id 4626E5FC94;
        Wed, 18 Jan 2023 11:29:21 +0300 (MSK)
Received: from [IPV6:2a02:6b8:0:107:fa75:a4ff:fe7d:8480] (unknown [2a02:6b8:0:107:fa75:a4ff:fe7d:8480])
        by myt6-23a5e62c0090.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id JTga380WqSw1-B9XH7fYV;
        Wed, 18 Jan 2023 11:29:20 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1674030560; bh=yiD1Vkbj+kmxhrQkFdbJH/d7ECbVLT1jRqOPP0wH7qE=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=WQp0q1LTwLsMsxK48WwAhSG6iTAxv4yASez4MLIZMGQs3MpWiZnCvDSp+FPfTVUAU
         4RWkdcWEWI/mNb14L4v3+/w2alBE2EpaWNXA+n2A/xoFt5biSwGlC8Z8c8SY1hrqAu
         BDoDCgAiTJKU+NN+TwTWj1Ogxji93ML14FvdFP6Y=
Authentication-Results: myt6-23a5e62c0090.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <e246efa2-7bc1-5413-32d0-c2927ebb001e@yandex-team.ru>
Date:   Wed, 18 Jan 2023 11:29:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net 1/2] net/ethernet/chelsio: fix cxgb4_getpgtccfg wrong
 memory access
To:     Leon Romanovsky <leon@kernel.org>
Cc:     rajur@chelsio.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, anish@chelsio.com,
        hariprasad@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230116152100.30094-1-davydov-max@yandex-team.ru>
 <20230116152100.30094-2-davydov-max@yandex-team.ru> <Y8ZonuQJn8gO9GX5@unreal>
Content-Language: en-US
From:   Maksim Davydov <davydov-max@yandex-team.ru>
In-Reply-To: <Y8ZonuQJn8gO9GX5@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/17/23 12:21, Leon Romanovsky wrote:
> On Mon, Jan 16, 2023 at 06:20:59PM +0300, Maksim Davydov wrote:
>> *pgid can be in range 0 to 0xF (bitmask 0xF) but valid values for PGID
>> are between 0 and 7. Also the size of pgrate is 8. Thus, we are needed
>> additional check to make sure that this code doesn't have access to tsa.
>>
>> Found by Linux Verification Center (linuxtesting.org) with the SVACE
>> static analysis tool.
>>
>> Fixes: 76bcb31efc06 ("cxgb4 : Add DCBx support codebase and dcbnl_ops")
>> Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
>> ---
>>   drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
>> index 7d5204834ee2..3aa65f0f335e 100644
>> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
>> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
>> @@ -471,7 +471,10 @@ static void cxgb4_getpgtccfg(struct net_device *dev, int tc,
>>   		return;
>>   	}
>>   
>> -	*bw_per = pcmd.u.dcb.pgrate.pgrate[*pgid];
>> +	/* Valid values are: 0-7 */
> How do you see it?
>
> There are lines below that assume something different.
>     477         /* prio_type is link strict */
>     478         if (*pgid != 0xF)
>     479                 *prio_type = 0x2;
>
But if *pgid == 0xF we get value for *bw_per from pgrate.tsa, it seems 
not correct

Thanks for reviewing,
Maksim Davydov
>> +	if (*pgid <= 7)
>> +		*bw_per = pcmd.u.dcb.pgrate.pgrate[*pgid];
> Why do you think that it is valid simply do not set *bw_per?
>
> Thanks

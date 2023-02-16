Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2DC698D41
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 07:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjBPGm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 01:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBPGmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 01:42:24 -0500
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADC330E7;
        Wed, 15 Feb 2023 22:42:20 -0800 (PST)
Received: from vla5-b2806cb321eb.qloud-c.yandex.net (vla5-b2806cb321eb.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3e0d:0:640:b280:6cb3])
        by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id 279116001E;
        Thu, 16 Feb 2023 09:42:16 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:25::1:28] (unknown [2a02:6b8:b081:25::1:28])
        by vla5-b2806cb321eb.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id EgeejE0U1Sw1-gPhMlrWj;
        Thu, 16 Feb 2023 09:42:15 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1676529735; bh=GFlJAGh3Dufn1HboTtDqEeBNoAFfC6Ss/IJ+tAI7dGo=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=L1nhKOHLgrZfZSxOt9TaNMKeiy+0vGmb5zoh8ItZfa9VbUt+F6XUFUqi0yByiGQ/x
         VqB7KA7peV3rQZphI7sbyB99XORc43eCeH2VAQMxoqcd3xbGcaVnaF/ALQUrWn54ID
         cmil7CQNWUAJMyR160zq3PaaE5In+MaC50CEyAmI=
Authentication-Results: vla5-b2806cb321eb.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <d3fe83e4-db71-6180-40e8-e0cfaf52be34@yandex-team.ru>
Date:   Thu, 16 Feb 2023 09:42:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [EXT] Re: [PATCH v0] qed/qed_dev: guard against a possible
 division by zero
Content-Language: en-US
To:     Manish Chopra <manishc@marvell.com>,
        Simon Horman <simon.horman@corigine.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yuval Mintz <Yuval.Mintz@qlogic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230209103813.2500486-1-d-tatianin@yandex-team.ru>
 <Y+TVVuLgF+V7iTO1@corigine.com>
 <b39e6122-ba7b-60dd-a70c-d3915b203ff0@yandex-team.ru>
 <BY3PR18MB4612FC497A8B12889548FF82ABA39@BY3PR18MB4612.namprd18.prod.outlook.com>
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
In-Reply-To: <BY3PR18MB4612FC497A8B12889548FF82ABA39@BY3PR18MB4612.namprd18.prod.outlook.com>
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

On 2/16/23 12:20 AM, Manish Chopra wrote:
>> -----Original Message-----
>> From: Daniil Tatianin <d-tatianin@yandex-team.ru>
>> Sent: Tuesday, February 14, 2023 12:53 PM
>> To: Simon Horman <simon.horman@corigine.com>
>> Cc: Ariel Elior <aelior@marvell.com>; Manish Chopra
>> <manishc@marvell.com>; David S. Miller <davem@davemloft.net>; Eric
>> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
>> Abeni <pabeni@redhat.com>; Yuval Mintz <Yuval.Mintz@qlogic.com>;
>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: [EXT] Re: [PATCH v0] qed/qed_dev: guard against a possible division
>> by zero
>>
>> External Email
>>
>> ----------------------------------------------------------------------
>>
>>
>> On 2/9/23 2:13 PM, Simon Horman wrote:
>>> On Thu, Feb 09, 2023 at 01:38:13PM +0300, Daniil Tatianin wrote:
>>>> Previously we would divide total_left_rate by zero if num_vports
>>>> happened to be 1 because non_requested_count is calculated as
>>>> num_vports - req_count. Guard against this by explicitly checking for
>>>> zero when doing the division.
>>>>
>>>> Found by Linux Verification Center (linuxtesting.org) with the SVACE
>>>> static analysis tool.
>>>>
>>>> Fixes: bcd197c81f63 ("qed: Add vport WFQ configuration APIs")
>>>> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
>>>> ---
>>>>    drivers/net/ethernet/qlogic/qed/qed_dev.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c
>>>> b/drivers/net/ethernet/qlogic/qed/qed_dev.c
>>>> index d61cd32ec3b6..90927f68c459 100644
>>>> --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
>>>> +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
>>>> @@ -5123,7 +5123,7 @@ static int qed_init_wfq_param(struct qed_hwfn
>>>> *p_hwfn,
>>>>
>>>>    	total_left_rate	= min_pf_rate - total_req_min_rate;
>>>>
>>>> -	left_rate_per_vp = total_left_rate / non_requested_count;
>>>> +	left_rate_per_vp = total_left_rate / (non_requested_count ?: 1);
>>>
>>> I don't know if num_vports can be 1.
>>> But if it is then I agree that the above will be a divide by zero.
>>>
>>> I do, however, wonder if it would be better to either:
>>>
>>> * Treat this case as invalid and return with -EINVAL if num_vports is
>>> 1; or
>> I think that's a good idea considering num_vports == 1 is indeed an invalid
>> value.
>> I'd like to hear a maintainer's opinion on this.
>   
> Practically, this flow will only hit with presence of SR-IOV VFs. In that case it's
> always expected to have num_vports > 1.

In that case, should we add a check and return with -EINVAL otherwise?
Thank you!

>>> * Skip both the calculation immediately above and the code
>>>     in the if condition below, which is the only place where
>>>     the calculated value is used, if num_vports is 1.
>>>     I don't think the if clause makes much sense if num_vports is
>>> one.left_rate_per_vp is also used below the if clause, it is assigned
>>> to
>> .min_speed in a for loop. Looking at that code division by 1 seems to make
>> sense to me in this case.
>>>
>>>>    	if (left_rate_per_vp <  min_pf_rate / QED_WFQ_UNIT) {
>>>>    		DP_VERBOSE(p_hwfn, NETIF_MSG_LINK,
>>>>    			   "Non WFQ configured vports rate [%d Mbps] is less
>> than one
>>>> percent of configured PF min rate[%d Mbps]\n",
>>>> --
>>>> 2.25.1
>>>>

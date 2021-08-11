Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339343E8BE3
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbhHKIgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbhHKIgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:36:05 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C94C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 01:35:41 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id z2so4104896lft.1
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 01:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uk26eHgRFzDQjK0XscQLq5FIsdCL1Aihc5SdVj8A9k0=;
        b=okdujYeoHZoVolENq8JZoT5jEmZ9O5XK913QTkcH8Z0i3KrkPO8cjTZ7m7L1tR6Ms0
         ks72qYPB+E5MgKD5A8gQsyeOyGHzv1K5m7AQNue8pFwgJfRbvynpGqLXm6DyUJQ5VXpU
         H/XVXUCvaW9UN7jWBE5+mzuzzkKqmhKFe3XfsCd9AF32up4OjC2CCw0zzaZWd1afGKHR
         W8aYSxDV+szGLHd0PnO8Ik4wbYGUI4l8ffpAgq66jp3kyzLdNrxu3aV7cpK65KS4J5BP
         +KYEJwslnV2msqDtPqTy7tD5eadAvRT8o4HOT14G9B9+s6q38yqK2GHV/PKzM/Aiov5K
         Tq1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uk26eHgRFzDQjK0XscQLq5FIsdCL1Aihc5SdVj8A9k0=;
        b=nXU54snrlsxGD+PX41lcklbWcljWXSdCcFwcGbge8UlQAveWHpCD/8Ztl+GU/cU0IT
         cy8lDy//IF+1FQI/03W1JDjfqRxdjE5jIxD6LDJRo5RlchGe2X5pRTtbECEdoyhwrdi7
         LxUO7q8hmcgOX9PUUlqnt4t6rg767g4InIG8PmghvxwyedibK70XaeuV+c4+S+aso1Lx
         liMe6DWeoK/THmCIi0uqn6ChN3C8QwQI4P1u5RJlGeAp1PrwincligpFcFRkTIugELmL
         0xs+MCW2GYefs7FNt0xfJzKcorKYQYMCI6lPhiElejmXlbPzBNFKxWpeC3oe5R77Bzg7
         RFFw==
X-Gm-Message-State: AOAM530iDIOgS0q4CnX5I/HPR2PaCtg2AFBrvnrio/tLQjPcBThDarxC
        cQWIGK0CXLzjq/ZTL6uGFUA=
X-Google-Smtp-Source: ABdhPJxSo7VtDGkZ5xRsG0C+El9TnwMK5QINveWti0j8ATbcCBgHCswlOh6ycdQKU/uw3PT1PbyQxQ==
X-Received: by 2002:a19:ad44:: with SMTP id s4mr24267963lfd.206.1628670939953;
        Wed, 11 Aug 2021 01:35:39 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id w11sm1230966ljh.117.2021.08.11.01.35.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 01:35:39 -0700 (PDT)
Subject: Re: [PATCH] net:sched fix array-index-out-of-bounds in taprio_change
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, tcs.kernel@gmail.com,
        vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
References: <1628658609-1208-1-git-send-email-tcs_kernel@tencent.com>
 <303b095e-3342-9461-16ae-86d0923b7dc7@gmail.com>
 <1852afdd-7c93-fdbc-404f-a5c76b9bc5d7@gmail.com>
Message-ID: <9c3e8561-bced-fe61-e7ac-e7635a3f9a7c@gmail.com>
Date:   Wed, 11 Aug 2021 11:35:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1852afdd-7c93-fdbc-404f-a5c76b9bc5d7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/21 11:30 AM, Pavel Skripkin wrote:
> On 8/11/21 10:44 AM, Eric Dumazet wrote:
>> 
>> 
>> On 8/11/21 7:10 AM, tcs.kernel@gmail.com wrote:
>>> From: Haimin Zhang <tcs_kernel@tencent.com>
>>> 
>>> syzbot report an array-index-out-of-bounds in taprio_change
>>> index 16 is out of range for type '__u16 [16]'
>>> that's because mqprio->num_tc is lager than TC_MAX_QUEUE,so we check
>>> the return value of netdev_set_num_tc.
>>> 
>>> Reported-by: syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com
>>> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
>>> ---
>>>  net/sched/sch_taprio.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>> 
>>> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>>> index 9c79374..1ab2fc9 100644
>>> --- a/net/sched/sch_taprio.c
>>> +++ b/net/sched/sch_taprio.c
>>> @@ -1513,7 +1513,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>>>  	taprio_set_picos_per_byte(dev, q);
>>>  
>>>  	if (mqprio) {
>>> -		netdev_set_num_tc(dev, mqprio->num_tc);
>>> +		err = netdev_set_num_tc(dev, mqprio->num_tc);
>>> +		if (err)
>>> +			goto free_sched;
>>>  		for (i = 0; i < mqprio->num_tc; i++)
>>>  			netdev_set_tc_queue(dev, i,
>>>  					    mqprio->count[i],
>>> 
>> 
>> When was the bug added ?
>> 
>> Hint: Please provide a Fixes: tag
>> 
>> taprio_parse_mqprio_opt() already checks :
>> 
>> /* Verify num_tc is not out of max range */
>> if (qopt->num_tc > TC_MAX_QUEUE) {
>>      NL_SET_ERR_MSG(extack, "Number of traffic classes is outside valid range");
>>      return -EINVAL;
>> }
>> 
>> So what is happening exactly ?
>> 
>> 
> 
> Hi, Eric!
> 
> I've looked into this bug, but I decided to write a reproducer for it
> first. Unfortunately, I didn't finish it yesterday, but I have an idea
> about what happened:
> 
> taprio_parse_mqprio_opt() may return 0 before qopt->num_tc check:
> 
> 	/* If num_tc is already set, it means that the user already
> 	 * configured the mqprio part
> 	 */
> 	if (dev->num_tc)
> 		return 0;
> 
> Then taprio_mqprio_cmp() fails here:
> 
> 	if (!mqprio || mqprio->num_tc != dev->num_tc)
> 		return -1;
> 
> That's why we won't get shift-out-of-bound in taprio_mqprio_cmp().

			  ^^^^^^^^^^^^^^^^^

			array-index-out-of-bounds

Sorry for confusion



With regards,
Pavel Skripkin

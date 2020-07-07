Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249E32175D1
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 20:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgGGSEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 14:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGGSEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 14:04:30 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCFDC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 11:04:30 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id cm21so15245pjb.3
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 11:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=UW4KUeO0Ixubr71KNNhQzYjeGx0xn9CkwEmd2jwKAdE=;
        b=rq0StDg7LVsLvPAq2WD8mPel2ynfyfmit2rbcr9vQaWSJsNnicPfJspWUoMl/HruxR
         C0pYGGiTXSL25AL4qgOcMSxuDk9yFnpk59fcmUZkZhe3Kb1ElZiK7gsMKjeaTGh9fNtz
         0zpgm4gZQ7kCqGwZy8WJOSshaVJKT9dX3UlIVbwBBceutQzQFLfdIhHwy3l+FOz79RZi
         AIU8CQBxt3sMRVol3EBEMBzekmcWRCEc1tNo5d3Um9XwY03cCA4cqPHarryNT0RlmaZ9
         vuG07Dq0hQmcBqWiVi2jo4wGiiQT+cCAdxq8eyI9b1j4XnhPjih8T8hQlIhMivorWbAE
         jwDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UW4KUeO0Ixubr71KNNhQzYjeGx0xn9CkwEmd2jwKAdE=;
        b=Jt2PKZ/UB8rxW6EqU6DthKjF2c5B7HQS+KQJpUvaYRlqwMm2H/WRxoD0LVyKc0KCAc
         aFv1dDqoxliGxvzk/RtlpVXkaLqtgqRW1Cosh+MM9TciAahGjFxzj+CfawEV86FakEHB
         PS51lf6xuDQgnsD48riCZQoru9VllLg/JPHeweGsI1kwYiyMHKtLOjjLuiQwSQVlqOoP
         p4kZGSMuV+ZA/RJJ6msSgBFPebQqKxhFdvrPz8pXIxplCRdo9G8IuCz0ZVKA4KAA2Whv
         cCMvLpE39/jBfaCbaSER2XRI503CwPXMHkpXYnQhdzJeYBW5HwoL93rzEK5wTFxnBQ5J
         3ETw==
X-Gm-Message-State: AOAM532cGf7siyGGEjEcjQKXzfeahwRNuXW2WPcWEDJpkK7juxcx3HMC
        fggo4DqBtxNwJVVDyuXb0SKjyA==
X-Google-Smtp-Source: ABdhPJxHPN08PpNLakGHu0XTF5tJBVqPmZB6DKZAnsf5WDwEk7bJq4/LCeZIDj0ih7ikPgKCwYwLgQ==
X-Received: by 2002:a17:90a:1f87:: with SMTP id x7mr5629031pja.101.1594145069581;
        Tue, 07 Jul 2020 11:04:29 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id z9sm1582438pgh.94.2020.07.07.11.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 11:04:28 -0700 (PDT)
Subject: Re: [PATCH net] ionic: centralize queue reset code
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200702233917.35166-1-snelson@pensando.io>
 <20200706103305.182bd727@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <fcb67ff8-2ef8-e5de-1609-2abb4a59a2d2@pensando.io>
 <20200707094643.66f18862@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <89540e44-8054-6362-8e24-8db2cd7745af@pensando.io>
Date:   Tue, 7 Jul 2020 11:04:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200707094643.66f18862@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/20 9:46 AM, Jakub Kicinski wrote:
> On Tue, 7 Jul 2020 09:10:38 -0700 Shannon Nelson wrote:
>> On 7/6/20 10:33 AM, Jakub Kicinski wrote:
>>> On Thu,  2 Jul 2020 16:39:17 -0700 Shannon Nelson wrote:
>>>> The queue reset pattern is used in a couple different places,
>>>> only slightly different from each other, and could cause
>>>> issues if one gets changed and the other didn't.  This puts
>>>> them together so that only one version is needed, yet each
>>>> can have slighty different effects by passing in a pointer
>>>> to a work function to do whatever configuration twiddling is
>>>> needed in the middle of the reset.
>>>>
>>>> Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
>>>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>>> Is this fixing anything?
>> Yes, this fixes issues seen similar to what was fixed with b59eabd23ee5
>> ("ionic: tame the watchdog timer on reconfig") where under loops of
>> changing parameters we could occasionally bump into the netdev watchdog.
> User-visible bug should always be part of the commit message for a fix,
> please amend.

Sure, I'll follow up later today.

>
>>> I think the pattern of having a separate structure describing all the
>>> parameters and passing that into reconfig is a better path forward,
>>> because it's easier to take that forward in the correct direction of
>>> allocating new resources before old ones are freed. IOW not doing a
>>> full close/open.
>>>
>>> E.g. nfp_net_set_ring_size().
>> This has been suggested before and looks great when you know you've got
>> the resources for dual allocations.  In our case this code is also used
>> inside our device where memory is tight: we are much more likely to have
>> allocation issues if we try to allocate everything without first
>> releasing what we already have.
> Are you saying that inside the device the memory allocated for the
> rings is close to the amount of max free memory? I find that hard to
> believe.
>
I was a bit surprised as well, but there is a lot going on inside the 
device and it turns out there are one or two specific use cases where 
this is an issue.

sln


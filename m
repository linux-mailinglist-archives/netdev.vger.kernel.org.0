Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E9831895C
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhBKLYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:24:46 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:41710 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231359AbhBKLVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:21:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613042471; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=ZMVEw+T1+2jFNHRLIczmtfsy/CV7EDResuKLWZr1Ipo=; b=c89YI2zezVEzxzFv444eqeHivSfvRO8u1lSiBkelKygXcczSGKxKySS1KPNHXQbN3rt0klX4
 O4+gX96G/TTcarqlJ+9/HNZ95GzEraJ9bx9DSCgOjX1tjaqeQHnAOx8R0UyODp8y7Xo+bun+
 +H++l7S+Qcc0Bxdfu3DxZU3GOf8=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 602512ff34db06ef79059423 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 11 Feb 2021 11:20:31
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 30EC9C43463; Thu, 11 Feb 2021 11:20:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B87A5C433ED;
        Thu, 11 Feb 2021 11:20:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B87A5C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH 4/5] ath10k: detect conf_mutex held ath10k_drain_tx() calls
References: <cover.1612915444.git.skhan@linuxfoundation.org>
        <a980abfb143f5240375f3f1046f0f26971c695e6.1612915444.git.skhan@linuxfoundation.org>
        <87lfbwtjls.fsf@codeaurora.org>
        <d6d8c7b8-f69d-01ef-6d66-8a33ea98920f@linuxfoundation.org>
Date:   Thu, 11 Feb 2021 13:20:26 +0200
In-Reply-To: <d6d8c7b8-f69d-01ef-6d66-8a33ea98920f@linuxfoundation.org> (Shuah
        Khan's message of "Wed, 10 Feb 2021 08:57:04 -0700")
Message-ID: <871rdmu9z9.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shuah Khan <skhan@linuxfoundation.org> writes:

> On 2/10/21 1:25 AM, Kalle Valo wrote:
>> Shuah Khan <skhan@linuxfoundation.org> writes:
>>
>>> ath10k_drain_tx() must not be called with conf_mutex held as workers can
>>> use that also. Add check to detect conf_mutex held calls.
>>>
>>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>>
>> The commit log does not answer to "Why?". How did you find this? What
>> actual problem are you trying to solve?
>>
>
> I came across the comment block above the ath10k_drain_tx() as I was
> reviewing at conf_mutex holds while I was debugging the conf_mutex
> lock assert in ath10k_debug_fw_stats_request().
>
> My reasoning is that having this will help detect incorrect usages
> of ath10k_drain_tx() while holding conf_mutex which could lead to
> locking problems when async worker routines try to call this routine.

Ok, makes sense. I prefer having this background info in the commit log,
for example "found by code review" or something like that. Or just copy
what you wrote above :)

>>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>>> @@ -4566,6 +4566,7 @@ static void
>>> ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
>>>   /* Must not be called with conf_mutex held as workers can use that also. */
>>>   void ath10k_drain_tx(struct ath10k *ar)
>>>   {
>>> +	WARN_ON(lockdep_is_held(&ar->conf_mutex));
>>
>> Empty line after WARN_ON().
>>
>
> Will do.
>
>> Shouldn't this check debug_locks similarly lockdep_assert_held() does?
>>
>> #define lockdep_assert_held(l)	do {				\
>> 		WARN_ON(debug_locks && !lockdep_is_held(l));	\
>> 	} while (0)
>>
>> And I suspect you need #ifdef CONFIG_LOCKDEP which should fix the kbuild
>> bot error.
>>
>
> Yes.
>
>> But honestly I would prefer to have lockdep_assert_not_held() in
>> include/linux/lockdep.h, much cleaner that way. Also
>> i915_gem_object_lookup_rcu() could then use the same macro.
>>
>
> Right. This is the right way to go. That was first instinct and
> decided to have the discussion evolve in that direction. Now that
> it has, I will combine this change with
> include/linux/lockdep.h and add lockdep_assert_not_held()
>
> I think we might have other places in the kernel that could use
> lockdep_assert_not_held() in addition to i915_gem_object_lookup_rcu()

Great, thank you. The only problem is that lockdep.h changes have to go
via some other tree, I just don't know which :) I think it would be
easiest if also the ath10k patch goes via that other tree, I can ack the
ath10k changes.

Another option is that I'll apply the ath10k patch after the lockdep.h
change has trickled down to my tree, but that usually happens only after
the merge window and means weeks of waiting. Either is fine for me.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0C831D5B2
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 08:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhBQHbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 02:31:50 -0500
Received: from z11.mailgun.us ([104.130.96.11]:29251 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229619AbhBQHbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 02:31:48 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613547088; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=VdTuFW1eZ3KIE8WTPHjDwu+M4861ybBJaxdd7BYbVgs=; b=MHpo29vo6iwPIrYkXYcRQQMpI5mQgngvsCZihVPeRr+MkPi/Q4Oeaaj/5dvZEQ1eXmcYIKl+
 gkvhDULxIwJNcW9fUDxflRK9ULJLGktjjdlU9ki1FT0uRW0hfJfGzV63iDupXXx+A/87lBBT
 osGD1+xRXcoLdQQcs5kkiH63zPs=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 602cc6350b8eba4b52b50f21 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Feb 2021 07:31:01
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C6E75C43465; Wed, 17 Feb 2021 07:31:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B0331C433CA;
        Wed, 17 Feb 2021 07:30:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B0331C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Felix Fietkau <nbd@nbd.name>, davem@davemloft.net, kuba@kernel.org,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k: fix ath_tx_process_buffer() potential null ptr dereference
References: <43ed9abb9e8d7112f3cc168c2f8c489e253635ba.1613090339.git.skhan@linuxfoundation.org>
        <20210216070336.D138BC43463@smtp.codeaurora.org>
        <0fd9a538-e269-e10e-a7f9-02d4c5848420@nbd.name>
        <caac2b21-d5de-32ac-0fe0-75af8fb80bbb@linuxfoundation.org>
Date:   Wed, 17 Feb 2021 09:30:55 +0200
In-Reply-To: <caac2b21-d5de-32ac-0fe0-75af8fb80bbb@linuxfoundation.org> (Shuah
        Khan's message of "Tue, 16 Feb 2021 08:22:07 -0700")
Message-ID: <878s7nqhg0.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shuah Khan <skhan@linuxfoundation.org> writes:

> On 2/16/21 12:53 AM, Felix Fietkau wrote:
>>
>> On 2021-02-16 08:03, Kalle Valo wrote:
>>> Shuah Khan <skhan@linuxfoundation.org> wrote:
>>>
>>>> ath_tx_process_buffer() references ieee80211_find_sta_by_ifaddr()
>>>> return pointer (sta) outside null check. Fix it by moving the code
>>>> block under the null check.
>>>>
>>>> This problem was found while reviewing code to debug RCU warn from
>>>> ath10k_wmi_tlv_parse_peer_stats_info() and a subsequent manual audit
>>>> of other callers of ieee80211_find_sta_by_ifaddr() that don't hold
>>>> RCU read lock.
>>>>
>>>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>>>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>>
>>> Patch applied to ath-next branch of ath.git, thanks.
>>>
>>> a56c14bb21b2 ath9k: fix ath_tx_process_buffer() potential null ptr dereference
>> I just took another look at this patch, and it is completely bogus.
>> Not only does the stated reason not make any sense (sta is simply passed
>> to other functions, not dereferenced without checks), but this also
>> introduces a horrible memory leak by skipping buffer completion if sta
>> is NULL.
>> Please drop it, the code is fine as-is.
>
> A comment describing what you said here might be a good addition to this
> comment block though.

Shuah, can you send a followup patch which reverts your change and adds
the comment? I try to avoid rebasing my trees.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

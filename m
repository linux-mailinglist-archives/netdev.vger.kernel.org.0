Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E7231AF6E
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 07:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhBNGPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 01:15:18 -0500
Received: from z11.mailgun.us ([104.130.96.11]:36909 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhBNGPP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Feb 2021 01:15:15 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613283289; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=e3eec5zLeqEMGut+FCmYCRWQIFaz4ukcUuaM5KHUywY=; b=M5mtZc8G/18NCU9a6BuUYas0ruZIwedEnPO7CGpvIP8fAcSsP6cMH9W5ia//fp1N4NuKVFsk
 ODDNbrP+bJjvRliepYn+kbt6noRqggf3LHG5kq1bJ57NksIgARj5AdVOJN3BSaOA9h31lUfW
 2Tzk21SQ2KjT8oV+UmNVkWJO+5k=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 6028be5b4bd23a05aea78c37 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 14 Feb 2021 06:08:27
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5F610C43461; Sun, 14 Feb 2021 06:08:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 28C69C433C6;
        Sun, 14 Feb 2021 06:08:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 28C69C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: detect conf_mutex held ath10k_drain_tx() calls
References: <cover.1613171185.git.skhan@linuxfoundation.org>
        <0686097db95ae32ce6805e5163798d912b394f37.1613171185.git.skhan@linuxfoundation.org>
Date:   Sun, 14 Feb 2021 08:08:21 +0200
In-Reply-To: <0686097db95ae32ce6805e5163798d912b394f37.1613171185.git.skhan@linuxfoundation.org>
        (Shuah Khan's message of "Fri, 12 Feb 2021 16:28:43 -0700")
Message-ID: <877dnbrxka.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shuah Khan <skhan@linuxfoundation.org> writes:

> ath10k_drain_tx() must not be called with conf_mutex held as workers can
> use that also. Add call to lockdep_assert_not_held() on conf_mutex to
> detect if conf_mutex is held by the caller.
>
> The idea for this patch stemmed from coming across the comment block
> above the ath10k_drain_tx() while reviewing the conf_mutex holds during
> to debug the conf_mutex lock assert in ath10k_debug_fw_stats_request().
>
> Adding detection to assert on conf_mutex hold will help detect incorrect
> usages that could lead to locking problems when async worker routines try
> to call this routine.
>
> Link: https://lore.kernel.org/linux-wireless/871rdmu9z9.fsf@codeaurora.org/
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>

This can go via the same tree as patch 1:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

But I can also take this to my ath tree, once patch 1 has reached it.
Just let me know what is preferred.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

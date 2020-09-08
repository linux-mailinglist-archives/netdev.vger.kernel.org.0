Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FC1260A46
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 07:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgIHFpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 01:45:05 -0400
Received: from a27-186.smtp-out.us-west-2.amazonses.com ([54.240.27.186]:41064
        "EHLO a27-186.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbgIHFpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 01:45:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599543899;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=ImcKZNGZhT2VPva+AhpxhJiRLLMhIKVbY5swSQnUfa8=;
        b=fEAMzW1sM7/TIXzzekdscfENz0Ron6+YsIKIJ1LZWE8g3P9m35o9l/zrSIgSZpCc
        CydNzFap+sAACK+mmd85unUvSOTbO6qRCNqcJUL2HOQUoMcL+7atM6jrkIcIMOJ9ebR
        f9cdbI9xdTCVT+kASIgbPA6MV8l9yLkLDQJvu8gs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599543899;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=ImcKZNGZhT2VPva+AhpxhJiRLLMhIKVbY5swSQnUfa8=;
        b=e+NSInE4kRn2pnT8uPPBGIDimedBygpktFVgNre2miGJZBc5gHeUIpprqVyj1CoS
        f54RQP+5aFdT/ynD4xlKEbd8Evc6VmMsBRco9CnVHNtCPwzEIaxeL2Jv2CV9qXnr/Ds
        pWE0w3pC/Pi+dkuQm8F5iyeFaULKV0RPKhF8suXQ=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0635AC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: fix a double free and a memory leak
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200906212625.17059-1-trix@redhat.com>
References: <20200906212625.17059-1-trix@redhat.com>
To:     trix@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, mkenna@codeaurora.org,
        vnaralas@codeaurora.org, rmanohar@codeaurora.org, john@phrozen.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <010101746c3ef483-c70d07ff-655d-4d78-867e-66ed6eea1c82-000000@us-west-2.amazonses.com>
Date:   Tue, 8 Sep 2020 05:44:59 +0000
X-SES-Outgoing: 2020.09.08-54.240.27.186
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trix@redhat.com wrote:

> clang static analyzer reports this problem
> 
> mac.c:6204:2: warning: Attempt to free released memory
>         kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The channels pointer is allocated in ath11k_mac_setup_channels_rates()
> When it fails midway, it cleans up the memory it has already allocated.
> So the error handling needs to skip freeing the memory.
> 
> There is a second problem.
> ath11k_mac_setup_channels_rates(), allocates 3 channels. err_free
> misses releasing ar->mac.sbands[NL80211_BAND_6GHZ].channels
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Tom Rix <trix@redhat.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

7e8453e35e40 ath11k: fix a double free and a memory leak

-- 
https://patchwork.kernel.org/patch/11759745/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


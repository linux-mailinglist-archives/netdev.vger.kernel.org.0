Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 034A61591CC
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 15:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgBKOYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 09:24:37 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:27804 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729268AbgBKOYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 09:24:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581431076; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=q1NnbfY5scviQ81WhVjeiiyH3xhw4C/A+lxpopfw2dM=;
 b=bjYj1LpLfJuMWFJLA7nlLRQ+rF/a3xlz2ZnLZsrZskAk6l2cYax2uWxqWfvOGmxh5BvCrhXA
 kU9+iIeAe+q20UHhYFNjz6kZDud74illPLgJNCTLR35CYoBonRS9ffrB6B02Tmp78Ef4F/iQ
 QcH903u4GpDVR80E9Qv9/LxNF3o=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e42b91f.7f1e67052298-smtp-out-n03;
 Tue, 11 Feb 2020 14:24:31 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2B510C4479D; Tue, 11 Feb 2020 14:24:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E7677C43383;
        Tue, 11 Feb 2020 14:24:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E7677C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Silence clang -Wsometimes-uninitialized in
 ath11k_update_per_peer_stats_from_txcompl
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200130015905.18610-1-natechancellor@gmail.com>
References: <20200130015905.18610-1-natechancellor@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        ci_notify@linaro.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200211142431.2B510C4479D@smtp.codeaurora.org>
Date:   Tue, 11 Feb 2020 14:24:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> wrote:

> Clang warns a few times (trimmed for brevity):
> 
> ../drivers/net/wireless/ath/ath11k/debugfs_sta.c:185:7: warning:
> variable 'rate_idx' is used uninitialized whenever 'if' condition is
> false [-Wsometimes-uninitialized]
> 
> It is not wrong, rate_idx is only initialized in the first if block.
> However, this is not necessarily an issue in practice because rate_idx
> will only be used when initialized because
> ath11k_accumulate_per_peer_tx_stats only uses rate_idx when flags is not
> set to RATE_INFO_FLAGS_HE_MCS, RATE_INFO_FLAGS_VHT_MCS, or
> RATE_INFO_FLAGS_MCS. Still, it is not good to stick uninitialized values
> into another function so initialize it to zero to prevent any issues
> down the line.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Link: https://github.com/ClangBuiltLinux/linux/issues/832
> Reported-by: ci_notify@linaro.org
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

df57acc415b1 ath11k: Silence clang -Wsometimes-uninitialized in ath11k_update_per_peer_stats_from_txcompl

-- 
https://patchwork.kernel.org/patch/11357331/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

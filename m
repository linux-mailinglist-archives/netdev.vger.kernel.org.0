Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA8A31E658
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 07:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhBRG1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 01:27:24 -0500
Received: from z11.mailgun.us ([104.130.96.11]:60381 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230254AbhBRGYi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 01:24:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613629453; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=kjnSg/kugYVk+PZm6eRtfipOjR0yNO2Df/RdfiFIMfg=;
 b=rmrfu96JlU9cqMGSVp3OURx0iQuzY1CQsVKZyzRUP2nHxKVTvPlHJXIPOwvv+6Ypf4mxuJKx
 g1QW6oPbpF6HfSamJZO9TUQufyUSdn/62p5ALk6r8uqSBkCwstY5Cgr+0ldXp/mZ/9aeaQo5
 Kv7XJTiGHWABiEFUYqSek5UXdlA=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 602e07e666a058a0ec7e2458 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 18 Feb 2021 06:23:34
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4368FC43464; Thu, 18 Feb 2021 06:23:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 72226C433CA;
        Thu, 18 Feb 2021 06:23:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 72226C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] Revert "ath9k: fix ath_tx_process_buffer() potential null
 ptr
 dereference"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210217211801.22540-1-skhan@linuxfoundation.org>
References: <20210217211801.22540-1-skhan@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org, nbd@nbd.name,
        Shuah Khan <skhan@linuxfoundation.org>,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210218062333.4368FC43464@smtp.codeaurora.org>
Date:   Thu, 18 Feb 2021 06:23:33 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shuah Khan <skhan@linuxfoundation.org> wrote:

> This reverts commit a56c14bb21b296fb6d395164ab62ef2e419e5069.
> 
> ath_tx_process_buffer() doesn't dereference or check sta and passes it
> to ath_tx_complete_aggr() and ath_tx_complete_buf().
> 
> ath_tx_complete_aggr() checks the pointer before use. No problem here.
> 
> ath_tx_complete_buf() doesn't check or dereference sta and passes it on
> to ath_tx_complete(). ath_tx_complete() doesn't check or dereference sta,
> but assigns it to tx_info->status.status_driver_data[0]
> 
> ath_tx_complete_buf() is called from ath_tx_complete_aggr() passing
> null ieee80211_sta pointer.
> 
> There is a potential for dereference later on, if and when the
> tx_info->status.status_driver_data[0]is referenced. In addition, the
> rcu read lock might be released before referencing the contents.
> 
> ath_tx_complete_buf() should be fixed to check sta perhaps? Worth
> looking into.
> 
> Reverting this patch because it doesn't solve the problem and introduces
> memory leak by skipping buffer completion if the pointer (sta) is NULL.
> 
> Fixes: a56c14bb21b2 ("ath9k: fix ath_tx_process_buffer() potential null ptr dereference")
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Thanks. I added the commit id and Fixes tag to the commit log, see the new version above.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210217211801.22540-1-skhan@linuxfoundation.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


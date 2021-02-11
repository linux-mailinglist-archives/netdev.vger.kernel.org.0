Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661DE31923E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 19:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhBKS3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 13:29:12 -0500
Received: from so15.mailgun.net ([198.61.254.15]:46776 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232735AbhBKS1l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 13:27:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613068044; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=XQMYp79ftc2CD2w0g/sVHwqX5MSlVZ7BvVff5QTyZow=;
 b=gG6YE761Xza+JRIp3WykNBjiY+f30m7fCovm64w6MV6l1yV5yBz7UBg4eV7r6yhDPplSoH/r
 vBqH9rr67gze/YGahwUJv7fZs6XD9gz5Se8x1A2hdNl7lwLxLn/d+8lewA7tRNwEB31+i2UU
 EsLBvB1JcgE/m+ZsWOaHSWQ3nck=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 602576eb830f898bac351cf7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 11 Feb 2021 18:26:51
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B6B85C433ED; Thu, 11 Feb 2021 18:26:50 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08C17C433C6;
        Thu, 11 Feb 2021 18:26:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 08C17C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: hold RCU lock when calling
 ieee80211_find_sta_by_ifaddr()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210210212107.40373-1-skhan@linuxfoundation.org>
References: <20210210212107.40373-1-skhan@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210211182650.B6B85C433ED@smtp.codeaurora.org>
Date:   Thu, 11 Feb 2021 18:26:50 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shuah Khan <skhan@linuxfoundation.org> wrote:

> ieee80211_find_sta_by_ifaddr() must be called under the RCU lock and
> the resulting pointer is only valid under RCU lock as well.
> 
> Fix ath10k_wmi_tlv_op_pull_peer_stats_info() to hold RCU lock before it
> calls ieee80211_find_sta_by_ifaddr() and release it when the resulting
> pointer is no longer needed.
> 
> This problem was found while reviewing code to debug RCU warn from
> ath10k_wmi_tlv_parse_peer_stats_info().
> 
> Link: https://lore.kernel.org/linux-wireless/7230c9e5-2632-b77e-c4f9-10eca557a5bb@linuxfoundation.org/
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

09078368d516 ath10k: hold RCU lock when calling ieee80211_find_sta_by_ifaddr()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210210212107.40373-1-skhan@linuxfoundation.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


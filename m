Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AAD36342F
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 08:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhDRGzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 02:55:38 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:64157 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhDRGzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 02:55:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618728910; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=Utc3RPK8eY1uRcKm9lChhTtO6d9Pq8zc08SGUU+2IoQ=; b=H2oGeeftZPZVufuFFf0frEGlwgu3blQQVkzIeoUQQWCyxhLSHoEGXy7C2wBICmjZJV+Z0cOd
 DY0F7X/HwUC1VkI9VhY72Q4gFEGm4B/9SQsfPHKdBL76c3ac+5V4F6fAmBNRlTwgRoqAm5L7
 aCkf7G6/AYNUVHVSMXLzrj2aW9c=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 607bd7c5f34440a9d43becee (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 18 Apr 2021 06:55:01
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 883ACC4323A; Sun, 18 Apr 2021 06:55:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 40CE2C433D3;
        Sun, 18 Apr 2021 06:54:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 40CE2C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lee Gibson <leegib@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wl1251: Fix possible buffer overflow in wl1251_cmd_scan
References: <20210317121807.389169-1-leegib@gmail.com>
Date:   Sun, 18 Apr 2021 09:54:57 +0300
In-Reply-To: <20210317121807.389169-1-leegib@gmail.com> (Lee Gibson's message
        of "Wed, 17 Mar 2021 12:18:07 +0000")
Message-ID: <87wnt0jd4u.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Gibson <leegib@gmail.com> writes:

> Function wl1251_cmd_scan calls memcpy without checking the length.
> A user could control that length and trigger a buffer overflow.
> Fix by checking the length is within the maximum allowed size.
>
> Signed-off-by: Lee Gibson <leegib@gmail.com>

Please fix the commit log, the user cannot control this length as
cfg80211 checks it before handling it to wl1251. Unless I'm missing
something.

> ---
>  drivers/net/wireless/ti/wl1251/cmd.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
> index 498c8db2eb48..e4d028a53d91 100644
> --- a/drivers/net/wireless/ti/wl1251/cmd.c
> +++ b/drivers/net/wireless/ti/wl1251/cmd.c
> @@ -455,8 +455,11 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
>  	}
>  
>  	cmd->params.ssid_len = ssid_len;

If you are checking the length, you should also check ssid_len here.

> -	if (ssid)
> -		memcpy(cmd->params.ssid, ssid, ssid_len);
> +	if (ssid) {
> +		int len = min_t(int, ssid_len, IEEE80211_MAX_SSID_LEN);
> +
> +		memcpy(cmd->params.ssid, ssid, len);
> +	}

Please use clamp_val().

Also another (and IMHO better) way to cleanup this is to provide a
pointer to struct cfg80211_ssid, which makes it clear that the length
can be trusted and not length checking is not needed. So something like
this:

int wl1251_cmd_scan(struct wl1251 *wl, const struct cfg80211_ssid *ssid,
		    struct ieee80211_channel *channels[],
		    unsigned int n_channels, unsigned int n_probes)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

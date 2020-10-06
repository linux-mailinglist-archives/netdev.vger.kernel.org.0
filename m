Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490F5284718
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 09:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbgJFH0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 03:26:34 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:20045 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgJFH0e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 03:26:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601969193; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=iW2DFmmCUNMCi9XnrrPNlbTQzrZkhy2zOuOXnyMaLXk=; b=wSy8KpPzGGER3kVpm6y6VuoNBtyjKR69t8WHayiuTDhkWE1Hv6XCDs45jWTAHZJyjfRJ8VW8
 0G6usyF5bJdnt0gliZsOWV9RP0I6VpJn7gKSqh2rY2RbqG1dOb6UFP+S1QFP20hrX4fMUMr7
 j+aHwRz2h3Muov8nmaS22+3rCZM=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f7c1c2942f9861fb17c9ad2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 06 Oct 2020 07:26:33
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 44B86C433FF; Tue,  6 Oct 2020 07:26:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A1FD9C433CB;
        Tue,  6 Oct 2020 07:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A1FD9C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Carl Huang <cjhuang@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath11k: Handle errors if peer creation fails
References: <20201004100218.311653-1-alex.dewar90@gmail.com>
Date:   Tue, 06 Oct 2020 10:26:28 +0300
In-Reply-To: <20201004100218.311653-1-alex.dewar90@gmail.com> (Alex Dewar's
        message of "Sun, 4 Oct 2020 11:02:17 +0100")
Message-ID: <87blhfbysb.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alex Dewar <alex.dewar90@gmail.com> writes:

> ath11k_peer_create() is called without its return value being checked,
> meaning errors will be unhandled. Add missing check and, as the mutex is
> unconditionally unlocked on leaving this function, simplify the exit
> path.
>
> Addresses-Coverity-ID: 1497531 ("Code maintainability issues")
> Fixes: 701e48a43e15 ("ath11k: add packet log support for QCA6390")
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> ---
>  drivers/net/wireless/ath/ath11k/mac.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> index 7f8dd47d2333..58db1b57b941 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -5211,7 +5211,7 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
>  	struct ath11k *ar = hw->priv;
>  	struct ath11k_base *ab = ar->ab;
>  	struct ath11k_vif *arvif = (void *)vif->drv_priv;
> -	int ret;
> +	int ret = 0;

I prefer not to initialise the ret variable.

>  	arvif->is_started = true;
>  
>  	/* TODO: Setup ps and cts/rts protection */
>  
> -	mutex_unlock(&ar->conf_mutex);
> -
> -	return 0;
> -
> -err:
> +unlock:
>  	mutex_unlock(&ar->conf_mutex);
>  
>  	return ret;

So in the pending branch I changed this to:

	ret = 0;

out:
	mutex_unlock(&ar->conf_mutex);

	return ret;

Please check.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

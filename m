Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06652DFF81
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgLUSQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:16:41 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:50153 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgLUSQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 13:16:40 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608574584; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=advVr5rSg5zOOn4yjOEJUBXVBEt3L/mvo2faQIC58Bc=; b=bKkNriUjWnUrWoMflfY7dvcOiaZd+47FNYlwSh7EJv9rwskyMFgMb4y6K8qLjR21BGMnSnHJ
 3/koP8G8LWQGPXGv/rKZQ1SG/f/UvCNq0khOtsUOOf3tTfGzu0ViLWp/XUDx2l+sV8jl/RH9
 XYSh+GROXYRVWDYaGSADr08D0VY=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5fe0e63fda4719818836360d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 21 Dec 2020 18:15:27
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4CE6DC43464; Mon, 21 Dec 2020 18:15:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E500AC433ED;
        Mon, 21 Dec 2020 18:15:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E500AC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: ath10k: santity check for ep connectivity
References: <20200622022055.16028-1-bruceshenzk@gmail.com>
Date:   Mon, 21 Dec 2020 20:15:22 +0200
In-Reply-To: <20200622022055.16028-1-bruceshenzk@gmail.com> (Zekun Shen's
        message of "Sun, 21 Jun 2020 22:20:54 -0400")
Message-ID: <87sg7znhz9.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> writes:

> Function ep_rx_complete is being called without NULL checking
> in ath10k_htc_rx_completion_handler. Without such check, mal-
> formed packet is able to cause jump to NULL.
>
> ep->service_id seems a good candidate for sanity check as it is
> used in usb.c.
>
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/htc.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
> index 31df6dd04..e00794d97 100644
> --- a/drivers/net/wireless/ath/ath10k/htc.c
> +++ b/drivers/net/wireless/ath/ath10k/htc.c
> @@ -450,6 +450,11 @@ void ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
>  
>  	ep = &htc->endpoint[eid];
>  
> +	if (ep->service_id == 0) {
> +		ath10k_warn(ar, "HTC Rx: ep %d is not connect\n", eid);
> +		goto out;
> +	}

I think using ATH10K_HTC_SVC_ID_UNUSED is more descriptive than zero, as
ath10k_htc_reset_endpoint_states() uses it. I fixed in the pending
branch.

I think also ath10k_htc_process_credit_report() might have a similar
problem, can you take a look?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

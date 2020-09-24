Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3962776C5
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 18:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgIXQbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 12:31:09 -0400
Received: from z5.mailgun.us ([104.130.96.5]:36026 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgIXQbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 12:31:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600965068; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=7yLmKI/5vET6oVISCZDrM5SQf3FU2iPOM2oBQ/UT4Go=; b=GtrnXkaQvXUEuF2J9Gf0LqGucj0hbexV5fLH6+2rO9baC1w0Tl4XoOZbOYaidnYXE0dPJVa9
 jFPMNW4LkFSZM/TPHFttQb9v7y0wQxpePJPCLQboN1Npaf2RTpxDXYhoImah6uDMUQOXqJHC
 YF1wwA86DVMDFGY831OM2BBj7vU=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f6cc9cbe051fb32a009b853 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Sep 2020 16:31:07
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 80D57C433CA; Thu, 24 Sep 2020 16:31:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5C272C433CB;
        Thu, 24 Sep 2020 16:31:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5C272C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Konrad Dybcio <konradybcio@gmail.com>,
        ath10k@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH] ath10k: qmi: Skip host capability request for Xiaomi Poco F1
References: <1600328501-8832-1-git-send-email-amit.pundir@linaro.org>
Date:   Thu, 24 Sep 2020 19:31:02 +0300
In-Reply-To: <1600328501-8832-1-git-send-email-amit.pundir@linaro.org> (Amit
        Pundir's message of "Thu, 17 Sep 2020 13:11:41 +0530")
Message-ID: <87d02bnnll.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amit Pundir <amit.pundir@linaro.org> writes:

> Workaround to get WiFi working on Xiaomi Poco F1 (sdm845)
> phone. We get a non-fatal QMI_ERR_MALFORMED_MSG_V01 error
> message in ath10k_qmi_host_cap_send_sync(), but we can still
> bring up WiFi services successfully on AOSP if we ignore it.
>
> We suspect either the host cap is not implemented or there
> may be firmware specific issues. Firmware version is
> QC_IMAGE_VERSION_STRING=WLAN.HL.2.0.c3-00257-QCAHLSWMTPLZ-1
>
> qcom,snoc-host-cap-8bit-quirk didn't help. If I use this
> quirk, then the host capability request does get accepted,
> but we run into fatal "msa info req rejected" error and
> WiFi interface doesn't come up.
>
> Attempts are being made to debug the failure reasons but no
> luck so far. Hence this device specific workaround instead
> of checking for QMI_ERR_MALFORMED_MSG_V01 error message.
> Tried ath10k/WCN3990/hw1.0/wlanmdsp.mbn from the upstream
> linux-firmware project but it didn't help and neither did
> building board-2.bin file from stock bdwlan* files.
>
> This workaround will be removed once we have a viable fix.
> Thanks to postmarketOS guys for catching this.
>
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>

Bjorn, is this ok to take?

> --- a/drivers/net/wireless/ath/ath10k/qmi.c
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -651,7 +651,8 @@ static int ath10k_qmi_host_cap_send_sync(struct ath10k_qmi *qmi)
>  
>  	/* older FW didn't support this request, which is not fatal */
>  	if (resp.resp.result != QMI_RESULT_SUCCESS_V01 &&
> -	    resp.resp.error != QMI_ERR_NOT_SUPPORTED_V01) {
> +	    resp.resp.error != QMI_ERR_NOT_SUPPORTED_V01 &&
> +	    !of_machine_is_compatible("xiaomi,beryllium")) { /* Xiaomi Poco F1 workaround */
>  		ath10k_err(ar, "host capability request rejected: %d\n", resp.resp.error);

ath10k-check complained about a too long line, so in the pending branch
I moved the comment before the if statement.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

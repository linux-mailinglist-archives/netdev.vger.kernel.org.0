Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530241F340D
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 08:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgFIGXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 02:23:40 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:37443 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726886AbgFIGXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 02:23:39 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1591683818; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=4+aCPVmw8jrDJQlSPv04BpPt31w8OcaqeOyj/nVXCVU=;
 b=FRHRoixSKeYKS7HJcB+ZXe4ccNlsdS+GT9H61QOdmpQsbHSvwXGcRAWp8RktW6Qn1xisH3c8
 Q+EW+rG1thbmoYyOfv4KzRxXKmzNqvcJlo13TUkkoTLqLMC0MpADM9UyaougN74QmFKYBrhM
 tRHFBTuQmkYa6dZqA/NEea6LbT0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n11.prod.us-east-1.postgun.com with SMTP id
 5edf2ae98bec50776860c72d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 09 Jun 2020 06:23:37
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 46ABEC433C6; Tue,  9 Jun 2020 06:23:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 31652C433C6;
        Tue,  9 Jun 2020 06:23:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 31652C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Acquire tx_lock in tx error paths
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200604105901.1.I5b8b0c7ee0d3e51a73248975a9da61401b8f3900@changeid>
References: <20200604105901.1.I5b8b0c7ee0d3e51a73248975a9da61401b8f3900@changeid>
To:     Evan Green <evgreen@chromium.org>
Cc:     kuabhs@google.com.org, sujitka@chromium.org,
        Evan Green <evgreen@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Govind Singh <govinds@qti.qualcomm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kazior <michal.kazior@tieto.com>,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200609062336.46ABEC433C6@smtp.codeaurora.org>
Date:   Tue,  9 Jun 2020 06:23:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Evan Green <evgreen@chromium.org> wrote:

> ath10k_htt_tx_free_msdu_id() has a lockdep assertion that htt->tx_lock
> is held. Acquire the lock in a couple of error paths when calling that
> function to ensure this condition is met.
> 
> Fixes: 6421969f248fd ("ath10k: refactor tx pending management")
> Fixes: e62ee5c381c59 ("ath10k: Add support for htt_data_tx_desc_64 descriptor")
> Signed-off-by: Evan Green <evgreen@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

a738e766e3ed ath10k: Acquire tx_lock in tx error paths

-- 
https://patchwork.kernel.org/patch/11588229/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


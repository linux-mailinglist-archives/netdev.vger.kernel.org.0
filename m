Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906113B090E
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhFVPbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:31:23 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:11757 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbhFVPbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 11:31:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624375742; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=2MYYVM3Za+tUpGkmkno2Ut0CaeSuF4HzPOvfT7sLpL8=;
 b=M6mFGDJi5ycwfA2ODt/Meo9ENjdUpQOvQkqUIeFt0snYJ3/GvoCYisG6MDOHXleDKs3YMOlF
 okAvkKwNNi9W+rnpMdmrjHmyNHWh8C7QpFbTxthEhp9mH7j4nW7qSJjOq2RR2KmdmtkG13LH
 R05pD5BDieYcfa9V7CYBNpmOfyU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 60d2018e32b73d6b282ba698 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Jun 2021 15:28:14
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1343DC433D3; Tue, 22 Jun 2021 15:28:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 97538C4338A;
        Tue, 22 Jun 2021 15:28:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 97538C4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Avoid memcpy() over-reading of he_cap
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210616195410.1232119-1-keescook@chromium.org>
References: <20210616195410.1232119-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     netdev@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210622152814.1343DC433D3@smtp.codeaurora.org>
Date:   Tue, 22 Jun 2021 15:28:14 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring array fields.
> 
> Since peer_he_cap_{mac,phy}info and he_cap_elem.{mac,phy}_cap_info are not
> the same sizes, memcpy() was reading beyond field boundaries. Instead,
> correctly cap the copy length and pad out any difference in size
> (peer_he_cap_macinfo is 8 bytes whereas mac_cap_info is 6, and
> peer_he_cap_phyinfo is 12 bytes whereas phy_cap_info is 11).
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

c8bcd82a4efd ath11k: Avoid memcpy() over-reading of he_cap

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210616195410.1232119-1-keescook@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


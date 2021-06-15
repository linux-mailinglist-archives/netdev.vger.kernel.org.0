Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57B63A8126
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhFONpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:45:46 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:34828 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhFONo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:44:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623764571; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=fBg3Q6qMpWy0ix/BOTxexwlZllzXH0IwcYdedtXwM6A=;
 b=V/eNbbLvBYJein4800vDygmU2bMT49qa6k9OcSN+vkTawKuaDjjvJrIIIokMyAUYou0EMyws
 HbrIYNb+YRVTdXIslJcQooTNPup8VzYn+ZMLrSesJr+Zv16FSWXRbPYkF7JWfTk8pVQMh28G
 /r2MKWZTxHy97X3IJesMobmkdt8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60c8ae45f726fa4188a40307 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 13:42:29
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7A50BC43460; Tue, 15 Jun 2021 13:42:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D3F5DC433F1;
        Tue, 15 Jun 2021 13:42:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D3F5DC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V2] rsi: fix AP mode with WPA failure due to encrypted
 EAPOL
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1622564459-24430-1-git-send-email-martin.fuzzey@flowbird.group>
References: <1622564459-24430-1-git-send-email-martin.fuzzey@flowbird.group>
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>, stable@vger.kernel.org,
        Siva Rebbagondla <siva8118@gmail.com>,
        Marek Vasut <marex@denx.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615134228.7A50BC43460@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 13:42:28 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Fuzzey <martin.fuzzey@flowbird.group> wrote:

> In AP mode WPA2-PSK connections were not established.
> 
> The reason was that the AP was sending the first message
> of the 4 way handshake encrypted, even though no pairwise
> key had (correctly) yet been set.
> 
> Encryption was enabled if the "security_enable" driver flag
> was set and encryption was not explicitly disabled by
> IEEE80211_TX_INTFL_DONT_ENCRYPT.
> 
> However security_enable was set when *any* key, including
> the AP GTK key, had been set which was causing unwanted
> encryption even if no key was avaialble for the unicast
> packet to be sent.
> 
> Fix this by adding a check that we have a key and drop
> the old security_enable driver flag which is insufficient
> and redundant.
> 
> The Redpine downstream out of tree driver does it this way too.
> 
> Regarding the Fixes tag the actual code being modified was
> introduced earlier, with the original driver submission, in
> dad0d04fa7ba ("rsi: Add RS9113 wireless driver"), however
> at that time AP mode was not yet supported so there was
> no bug at that point.
> 
> So I have tagged the introduction of AP support instead
> which was part of the patch set "rsi: support for AP mode" [1]
> 
> It is not clear whether AP WPA has ever worked, I can see nothing
> on the kernel side that broke it afterwards yet the AP support
> patch series says "Tests are performed to confirm aggregation,
> connections in WEP and WPA/WPA2 security."
> 
> One possibility is that the initial tests were done with a modified
> userspace (hostapd).
> 
> [1] https://www.spinics.net/lists/linux-wireless/msg165302.html
> 
> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
> Fixes: 38ef62353acb ("rsi: security enhancements for AP mode")
> CC: stable@vger.kernel.org

Patch applied to wireless-drivers-next.git, thanks.

314538041b56 rsi: fix AP mode with WPA failure due to encrypted EAPOL

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1622564459-24430-1-git-send-email-martin.fuzzey@flowbird.group/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


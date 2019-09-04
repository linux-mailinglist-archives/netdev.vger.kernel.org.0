Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE560A7B21
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 08:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbfIDGFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 02:05:46 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51536 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfIDGFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 02:05:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C65D96115D; Wed,  4 Sep 2019 06:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567577144;
        bh=aShqyN0Qd6KXTO9xyxybPT3f0jnGflZlYOUa5dN9MtI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=STRjU44NdPfHLvhvJf59rfO2e+otP8z8kz7owHCPYKbhNJD6kNnp2DrfGWorpSh1t
         I1JiwOMCTQBW98xr/+B/SExCmicLYymGmvUS6Nk8XZWy5+GcT/VJP37gyEtPoXOtrd
         W6yLQol5a4whNtPxMs2CZmDuDnDRQYlhs6UOsD0Q=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3BFF160863;
        Wed,  4 Sep 2019 06:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567577144;
        bh=aShqyN0Qd6KXTO9xyxybPT3f0jnGflZlYOUa5dN9MtI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=W9orP2b1CDYEo1ik0R2sfFMCtfiUjF4z+YuTqKHcozs+wahtDFaobbukAxKr3uHWu
         wHcl/fCHKSkMxy39qXSlncnhtPFbWu54g5NvLTJbrgIHb0gaMeSc6cXPSSXQ2eJ5ok
         kddufNvugFu6k6heCmNPZBF5Wos26rzTvyuy6uW8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3BFF160863
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] wil6210: fix wil_cid_valid with negative cid values
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190702144026.13013-1-colin.king@canonical.com>
References: <20190702144026.13013-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Maya Erez <merez@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190904060544.C65D96115D@smtp.codeaurora.org>
Date:   Wed,  4 Sep 2019 06:05:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> There are several occasions where a negative cid value is passed
> into wil_cid_valid and this is converted into a u8 causing the
> range check of cid >= 0 to always succeed.  Fix this by making
> the cid argument an int to handle any -ve error value of cid.
> 
> An example of this behaviour is in wil_cfg80211_dump_station,
> where cid is assigned -ENOENT if the call to wil_find_cid_by_idx
> fails, and this -ve value is passed to wil_cid_valid.  I believe
> that the conversion of -ENOENT to the u8 value 254 which is
> greater than wil->max_assoc_sta causes wil_find_cid_by_idx to
> currently work fine, but I think is by luck and not the
> intended behaviour.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

23bb9f692b66 wil6210: fix wil_cid_valid with negative cid values

-- 
https://patchwork.kernel.org/patch/11027989/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


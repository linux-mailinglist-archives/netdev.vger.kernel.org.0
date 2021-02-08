Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A984313099
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhBHLVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:21:08 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:53760 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232845AbhBHLSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:18:40 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612783108; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=GnP7gb++/6w5lU2/p5nClLbXwZ1oNgEsKzt5O6dPGMk=;
 b=b0e2DStvFfzsNtOEsfRtBua7MRXDDYmw0RzpMKsx1Ny9plyC7yOqzINKGUEPd5py406vOWKj
 kVumt6Nfoz7j5g9VgpwefcXuVknvJJpbvPAR5ZuSVUlRd9q8nvIdKeHJjRO9Na3BSxzTPeb7
 F4/5BMAKq6f1XN+Wjw/xXejK71w=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60211dd84bd23a05aecf390a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 11:17:44
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0C28AC433C6; Mon,  8 Feb 2021 11:17:44 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E7B4FC433CA;
        Mon,  8 Feb 2021 11:17:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E7B4FC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: Report connected BSS with cfg80211_connect_bss()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210201070649.1667209-1-yenlinlai@chromium.org>
References: <20210201070649.1667209-1-yenlinlai@chromium.org>
To:     Yen-lin Lai <yenlinlai@chromium.org>
Cc:     linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>,
        Yen-lin Lai <yenlinlai@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210208111744.0C28AC433C6@smtp.codeaurora.org>
Date:   Mon,  8 Feb 2021 11:17:44 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yen-lin Lai <yenlinlai@chromium.org> wrote:

> When a network is moved or reconfigured on the different channel, there
> can be multiple BSSes with the same BSSID and SSID in scan result
> before the old one expires. Then, it can cause cfg80211_connect_result
> to map current_bss to a bss with the wrong channel.
> 
> Let mwifiex_cfg80211_assoc return the selected BSS and then the caller
> can report it cfg80211_connect_bss.
> 
> Signed-off-by: Yen-lin Lai <yenlinlai@chromium.org>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

b7fd26c913f1 mwifiex: Report connected BSS with cfg80211_connect_bss()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210201070649.1667209-1-yenlinlai@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


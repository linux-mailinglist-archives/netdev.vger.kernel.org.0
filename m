Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770BF1A7B2B
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 14:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502215AbgDNMtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 08:49:36 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:46983 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728803AbgDNMtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 08:49:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586868572; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=FEC6UXkgrlVz/1ReSPT9a5+LzjnDG2h4x4E5PpkB6Xk=;
 b=fLwZlNAPr8rC/RQUePxqUdl4jxmw0poTJj4WTp+S8UHSVuWHUQL0LPDeU67Z5M3D5CyxnPuL
 LiNCAGuIV011RkTLkeTNei8y65pecazZ4n+JsP8Wyn/lXNPq80VPK3b8CyEjt/zESZe2hP3Z
 X09RoK6aY8WWK+DzFzUf19gJMnY=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e95b157.7fc2ff541500-smtp-out-n04;
 Tue, 14 Apr 2020 12:49:27 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 25401C44788; Tue, 14 Apr 2020 12:49:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 265FEC433CB;
        Tue, 14 Apr 2020 12:49:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 265FEC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: avoid unused function warnings
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200408185413.218643-1-arnd@arndb.de>
References: <20200408185413.218643-1-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Chin-Yen Lee <timlee@realtek.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Brian Norris <briannorris@chromium.org>,
        Chris Chiu <chiu@endlessm.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200414124927.25401C44788@smtp.codeaurora.org>
Date:   Tue, 14 Apr 2020 12:49:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> The rtw88 driver defines emtpy functions with multiple indirections
> but gets one of these wrong:
> 
> drivers/net/wireless/realtek/rtw88/pci.c:1347:12: error: 'rtw_pci_resume' defined but not used [-Werror=unused-function]
>  1347 | static int rtw_pci_resume(struct device *dev)
>       |            ^~~~~~~~~~~~~~
> drivers/net/wireless/realtek/rtw88/pci.c:1342:12: error: 'rtw_pci_suspend' defined but not used [-Werror=unused-function]
>  1342 | static int rtw_pci_suspend(struct device *dev)
> 
> Better simplify it to rely on the conditional reference in
> SIMPLE_DEV_PM_OPS(), and mark the functions as __maybe_unused to avoid
> warning about it.
> 
> I'm not sure if these are needed at all given that the functions
> don't do anything, but they were only recently added.
> 
> Fixes: 44bc17f7f5b3 ("rtw88: support wowlan feature for 8822c")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers.git, thanks.

7dc7c41607d1 rtw88: avoid unused function warnings

-- 
https://patchwork.kernel.org/patch/11480657/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

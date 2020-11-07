Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D432AA66C
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 16:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgKGPuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 10:50:17 -0500
Received: from z5.mailgun.us ([104.130.96.5]:56493 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgKGPuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 10:50:16 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604764216; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=LRa7oFxHhmt/YZPbV36qQfXGNCgZrWJaidrJZ+VME6k=;
 b=BWYOyPS2KIpiY/y62xD2/FUBXZxyJlOiu0Zn/c9huFrVf2sJSv758QB/alvmoC/2RetlRy98
 YHguN50D1S1ZXCV0pr2/yJGPj+elKjOHyJpmZi7JayNjLGCPavikThL31EWE2fDVfFRCjSTm
 4CViDzVv7mk6IL8dBzbO0MSZ0N4=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5fa6c237c6df09e2f2a1b695 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 15:50:15
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 27800C433C9; Sat,  7 Nov 2020 15:50:15 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C0767C433C6;
        Sat,  7 Nov 2020 15:50:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C0767C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: Fix non-canonical address access issues
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1603768580-2798-1-git-send-email-WeitaoWang-oc@zhaoxin.com>
References: <1603768580-2798-1-git-send-email-WeitaoWang-oc@zhaoxin.com>
To:     WeitaoWangoc <WeitaoWang-oc@zhaoxin.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tonywwang@zhaoxin.com>,
        <weitaowang@zhaoxin.com>, <CobeChen@zhaoxin.com>,
        <TimGuo@zhaoxin.com>, <wwt8723@163.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107155015.27800C433C9@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 15:50:15 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WeitaoWangoc <WeitaoWang-oc@zhaoxin.com> wrote:

> During realtek USB wireless NIC initialization, it's unexpected
> disconnection will cause urb sumbmit fail. On the one hand,
> _rtl_usb_cleanup_rx will be called to clean up rx stuff, especially for
> rtl_wq. On the other hand, disconnection will cause rtl_usb_disconnect
> and _rtl_usb_cleanup_rx to be called. So, rtl_wq will be flush/destroy
> twice, which will cause non-canonical address 0xdead000000000122 access
> and general protection fault.
> 
> Fixed this issue by remove _rtl_usb_cleanup_rx when urb sumbmit fail.
> 
> Signed-off-by: WeitaoWangoc <WeitaoWang-oc@zhaoxin.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

c521d7e0ff05 rtlwifi: Fix non-canonical address access issues

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1603768580-2798-1-git-send-email-WeitaoWang-oc@zhaoxin.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D674243DC1F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhJ1HhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:37:06 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:35864 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229921AbhJ1HhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 03:37:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635406478; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=wl1qlC5fvtysxEaHVIlbpR7cMqu7C52Vm/4PxNdMmFc=;
 b=ip3r4IefZPCccFmt/AYSqt6F8Qz16Q6nQHvB2j80+oEK8V3l57ZemHQYAOdPrYp/ec70XjaA
 luDdKHgHCHJx7dswX70br/cTat/yAn1pUl8uki4Maivc5XUudA/xbIPcGH6CIS9Uj8ZURfm1
 /EZm6QwVp39Kvtu/YWuR/REcmls=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 617a5287ff3eb667a7991461 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 Oct 2021 07:34:31
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id ADB3AC4338F; Thu, 28 Oct 2021 07:34:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3700AC4338F;
        Thu, 28 Oct 2021 07:34:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 3700AC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/3] ath10k: fix division by zero in send path
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211027080819.6675-2-johan@kernel.org>
References: <20211027080819.6675-2-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Erik Stromdahl <erik.stromdahl@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163540646648.24978.9801837945005945514.kvalo@codeaurora.org>
Date:   Thu, 28 Oct 2021 07:34:31 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan@kernel.org> wrote:

> Add the missing endpoint max-packet sanity check to probe() to avoid
> division by zero in ath10k_usb_hif_tx_sg() in case a malicious device
> has broken descriptors (or when doing descriptor fuzz testing).
> 
> Note that USB core will reject URBs submitted for endpoints with zero
> wMaxPacketSize but that drivers doing packet-size calculations still
> need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
> endpoint descriptors with maxpacket=0")).
> 
> Fixes: 4db66499df91 ("ath10k: add initial USB support")
> Cc: stable@vger.kernel.org      # 4.14
> Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

a006acb93131 ath10k: fix division by zero in send path
c1b9ca365dea ath6kl: fix division by zero in send path

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211027080819.6675-2-johan@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3389B4FD5
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 16:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfIQODo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 10:03:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45750 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfIQODo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 10:03:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D11AF61576; Tue, 17 Sep 2019 14:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568729023;
        bh=z5NkcZ1ALVg0VMSVQaQZtgQ5NF7xi3wRIZFmstI/iR0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lHZdxjg2FqLYr6alImg+/DyYa6PRazOBXVd/8JUhbltu+hxDRZIDzy/L5XXjqo97I
         ehmzC1bvtwQkd6m6qlTre41CXB2Fa87HR+abQI40+FYNnQMnMUp1ROdsAtqcBnH+Ye
         uEoHvOjy5PO5xAHcDNrJm38qrDsYnLb/3yHzVIEA=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1075061544;
        Tue, 17 Sep 2019 14:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568729020;
        bh=z5NkcZ1ALVg0VMSVQaQZtgQ5NF7xi3wRIZFmstI/iR0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=jeJJCXHihlrr3GhJk2NSJZIDcKcDp/aKDu/n/iGSyjRoQBvdz5fOMU5maZZ+Muqdd
         jwWtd3qtswR3UwRjeSWJaFTM/inXnIsU5ssyiVPHpn3dFcIOi8BBaROieQMr4fPxi6
         qlI1rSaOgDVs04aGiRmipWdauCiGkPTHZsIYggC8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1075061544
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix HOST capability QMI incompatibility
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190725063108.15790-1-bjorn.andersson@linaro.org>
References: <20190725063108.15790-1-bjorn.andersson@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190917140342.D11AF61576@smtp.codeaurora.org>
Date:   Tue, 17 Sep 2019 14:03:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:

> The introduction of 768ec4c012ac ("ath10k: update HOST capability QMI
> message") served the purpose of supporting the new and extended HOST
> capability QMI message.
> 
> But while the new message adds a slew of optional members it changes the
> data type of the "daemon_support" member, which means that older
> versions of the firmware will fail to decode the incoming request
> message.
> 
> There is no way to detect this breakage from Linux and there's no way to
> recover from sending the wrong message (i.e. we can't just try one
> format and then fallback to the other), so a quirk is introduced in
> DeviceTree to indicate to the driver that the firmware requires the 8bit
> version of this message.
> 
> Cc: stable@vger.kernel.org
> Fixes: 768ec4c012ac ("ath10k: update HOST capability qmi message")
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Acked-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

7165ef890a4c ath10k: Fix HOST capability QMI incompatibility

-- 
https://patchwork.kernel.org/patch/11058005/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A31363410
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 08:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbhDRGcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 02:32:51 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:32964 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231347AbhDRGcv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 02:32:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618727543; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Vid4DEVRWQ6zvrf5fFbXUGrzD4z18nv5hzKHHNc29uM=;
 b=TRYlNAFNzqzd66jBk3JebENZoAC98Z4vzc+UzUo5TxnCnJKtNHCBIdP/m7EvqThFwSCJa0GB
 ogzY4leeOU3C1Y+2IJnv2udrOsuhma3IblilnyS5/TyIzK6gucQeyykB2xWorjtkeLug3aGm
 r7tvxt9nk2YawRBVhSkPfuSSQlc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 607bd277a817abd39ad32ef7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 18 Apr 2021 06:32:23
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 710BBC43217; Sun, 18 Apr 2021 06:32:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 64A6EC433F1;
        Sun, 18 Apr 2021 06:32:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 64A6EC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: Use resume_noirq for SDIO
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210327235932.175896-1-marex@denx.de>
References: <20210327235932.175896-1-marex@denx.de>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Karun Eagalapati <karun256@gmail.com>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210418063222.710BBC43217@smtp.codeaurora.org>
Date:   Sun, 18 Apr 2021 06:32:22 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek Vasut <marex@denx.de> wrote:

> The rsi_resume() does access the bus to enable interrupts on the RSI
> SDIO WiFi card, however when calling sdio_claim_host() in the resume
> path, it is possible the bus is already claimed and sdio_claim_host()
> spins indefinitelly. Enable the SDIO card interrupts in resume_noirq
> instead to prevent anything else from claiming the SDIO bus first.
> 
> Fixes: 20db07332736 ("rsi: sdio suspend and resume support")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> Cc: Angus Ainslie <angus@akkea.ca>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Karun Eagalapati <karun256@gmail.com>
> Cc: Martin Kepplinger <martink@posteo.de>
> Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> Cc: Siva Rebbagondla <siva8118@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: stable@vger.kernel.org

Patch applied to wireless-drivers-next.git, thanks.

c434e5e48dc4 rsi: Use resume_noirq for SDIO

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210327235932.175896-1-marex@denx.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


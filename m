Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF70149B84
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 16:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgAZPll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 10:41:41 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:61852 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726240AbgAZPll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 10:41:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580053300; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=4oNgHEj5QFbNpu267rvGYVEB/8nFuoK3Pr+1T8Kx9y8=;
 b=m1leRY3sVlOjI78N+eJugC4t6wqaqJCySnHyU2RGbd0LnQVRR9SmIcAuKhbhub7TEVmc9F4s
 RsVhaGnmggFEfnComV5sIXuoe3P3fTw2U0aQU3Z/YbbIOL2diToHR/511asXeA3LHokukKWN
 fB1qO6lxHAMFU5C5i+D+lEU06lc=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2db331.7f733e56ef48-smtp-out-n02;
 Sun, 26 Jan 2020 15:41:37 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4F504C43383; Sun, 26 Jan 2020 15:41:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 100FDC433CB;
        Sun, 26 Jan 2020 15:41:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 100FDC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: sdio: Fix OOB interrupt initialization on
 brcm43362
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191226092033.12600-1-jean-philippe@linaro.org>
References: <20191226092033.12600-1-jean-philippe@linaro.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        arend.vanspriel@broadcom.com, hdegoede@redhat.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        davem@davemloft.net
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126154137.4F504C43383@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 15:41:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jean-Philippe Brucker <jean-philippe@linaro.org> wrote:

> Commit 262f2b53f679 ("brcmfmac: call brcmf_attach() just before calling
> brcmf_bus_started()") changed the initialization order of the brcmfmac
> SDIO driver. Unfortunately since brcmf_sdiod_intr_register() is now
> called before the sdiodev->bus_if initialization, it reads the wrong
> chip ID and fails to initialize the GPIO on brcm43362. Thus the chip
> cannot send interrupts and fails to probe:
> 
> [   12.517023] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> [   12.531214] ieee80211 phy0: brcmf_bus_started: failed: -110
> [   12.536976] ieee80211 phy0: brcmf_attach: dongle is not responding: err=-110
> [   12.566467] brcmfmac: brcmf_sdio_firmware_callback: brcmf_attach failed
> 
> Initialize the bus interface earlier to ensure that
> brcmf_sdiod_intr_register() properly sets up the OOB interrupt.
> 
> BugLink: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908438
> Fixes: 262f2b53f679 ("brcmfmac: call brcmf_attach() just before calling brcmf_bus_started()")
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

8c8e60fb86a9 brcmfmac: sdio: Fix OOB interrupt initialization on brcm43362

-- 
https://patchwork.kernel.org/patch/11310417/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

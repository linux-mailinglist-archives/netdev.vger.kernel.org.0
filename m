Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A989715AD43
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 17:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBLQXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 11:23:12 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:63748 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727361AbgBLQXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 11:23:11 -0500
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 11:21:35 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581524591; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=8s1WzLOWb+AoZJksEERSbSfmDvAs4ADMWJjK4sRp03g=;
 b=MTxmFKqs8H2xL8H5MCM/Iiql5RaugWhzvJD5/oHXOPdYFQKgDl9MRKLodB1MttpMCxE2hyJ2
 tI9xAwtENCFNpxhlqZ4d9NTDOGlWOkHAD1Z+yC8lHqwtbm25vSKUvfHmM48iqI2/0Lax1CgT
 esIZxO+PrHHJbAvNMi6hw4nhkN4=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e44253d.7fbef56473e8-smtp-out-n01;
 Wed, 12 Feb 2020 16:18:05 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1909DC43383; Wed, 12 Feb 2020 16:18:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 14222C43383;
        Wed, 12 Feb 2020 16:17:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 14222C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: abort and release host after error
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200128221457.12467-1-linux@roeck-us.net>
References: <20200128221457.12467-1-linux@roeck-us.net>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Matthias Kaehlcke <mka@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Douglas Anderson <dianders@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200212161804.1909DC43383@smtp.codeaurora.org>
Date:   Wed, 12 Feb 2020 16:18:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> wrote:

> With commit 216b44000ada ("brcmfmac: Fix use after free in
> brcmf_sdio_readframes()") applied, we see locking timeouts in
> brcmf_sdio_watchdog_thread().
> 
> brcmfmac: brcmf_escan_timeout: timer expired
> INFO: task brcmf_wdog/mmc1:621 blocked for more than 120 seconds.
> Not tainted 4.19.94-07984-g24ff99a0f713 #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> brcmf_wdog/mmc1 D    0   621      2 0x00000000 last_sleep: 2440793077.  last_runnable: 2440766827
> [<c0aa1e60>] (__schedule) from [<c0aa2100>] (schedule+0x98/0xc4)
> [<c0aa2100>] (schedule) from [<c0853830>] (__mmc_claim_host+0x154/0x274)
> [<c0853830>] (__mmc_claim_host) from [<bf10c5b8>] (brcmf_sdio_watchdog_thread+0x1b0/0x1f8 [brcmfmac])
> [<bf10c5b8>] (brcmf_sdio_watchdog_thread [brcmfmac]) from [<c02570b8>] (kthread+0x178/0x180)
> 
> In addition to restarting or exiting the loop, it is also necessary to
> abort the command and to release the host.
> 
> Fixes: 216b44000ada ("brcmfmac: Fix use after free in brcmf_sdio_readframes()")
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Matthias Kaehlcke <mka@chromium.org>
> Cc: Brian Norris <briannorris@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
> Acked-by: franky.lin@broadcom.com
> Acked-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied to wireless-drivers-next.git, thanks.

863844ee3bd3 brcmfmac: abort and release host after error

-- 
https://patchwork.kernel.org/patch/11355277/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

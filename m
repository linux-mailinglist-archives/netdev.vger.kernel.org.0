Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2C772DB7
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfGXLfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:35:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40870 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbfGXLfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:35:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CD35360388; Wed, 24 Jul 2019 11:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968108;
        bh=PKsdsPRKMo4ZtbQ7Rcm2MFURdgVd1dXIYdcVeyVHotc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=bC3UndZkqc+u4v2XFJ7YL3IwOYqPiMYHKgQuOP7R4kPBEdcHeBfN52OYvnz7Bm2fs
         0QEMG/P0HnIYso6zY8V/DQf0kxxBE3YO4j2IIlK4Id0+HRXsdpHHgTCDBaXDtiti9r
         WXGP0+znOw5nW9r73fqoDL2yQmaxADDcyO0aKvTU=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2C2D060388;
        Wed, 24 Jul 2019 11:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968107;
        bh=PKsdsPRKMo4ZtbQ7Rcm2MFURdgVd1dXIYdcVeyVHotc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=VW56ttPu5ecy3DbKzYVN2m9H6Ds5rU81iJ5LRsA0SbMIR3Zu4oiMBXzoieih/B3HA
         b8jFymaNIe9Rb76bymHkxaEjfDiK0rVqzshUWmn07Rh+V6+BzSeYQrDXU2AZm4bjJU
         XETW08GgbpfVwI8pJ9rjTsAMQisVs1zWmkqA7epg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2C2D060388
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/2] mwifiex: Make use of the new sdio_trigger_replug()
 API to reset
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190722193939.125578-3-dianders@chromium.org>
References: <20190722193939.125578-3-dianders@chromium.org>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless@vger.kernel.org,
        Andreas Fenkart <afenkart@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        linux-mmc@vger.kernel.org, davem@davemloft.net,
        Xinming Hu <huxinming820@gmail.com>,
        Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724113508.CD35360388@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:35:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Douglas Anderson <dianders@chromium.org> wrote:

> As described in the patch ("mmc: core: Add sdio_trigger_replug()
> API"), the current mwifiex_sdio_card_reset() is broken in the cases
> where we're running Bluetooth on a second SDIO func on the same card
> as WiFi.  The problem goes away if we just use the
> sdio_trigger_replug() API call.
> 
> NOTE: Even though with this new solution there is less of a reason to
> do our work from a workqueue (the unplug / plug mechanism we're using
> is possible for a human to perform at any time so the stack is
> supposed to handle it without it needing to be called from a special
> context), we still need a workqueue because the Marvell reset function
> could called from a context where sleeping is invalid and thus we
> can't claim the host.  One example is Marvell's wakeup_timer_fn().
> 
> Cc: Andreas Fenkart <afenkart@gmail.com>
> Cc: Brian Norris <briannorris@chromium.org>
> Fixes: b4336a282db8 ("mwifiex: sdio: reset adapter using mmc_hw_reset")
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

I assume this is going via some other tree so I'm dropping this from my
queue. If I should apply this please resend once the dependency is in
wireless-drivers-next.

Patch set to Not Applicable.

-- 
https://patchwork.kernel.org/patch/11053351/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC99B2ADEDC
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgKJSz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:55:59 -0500
Received: from z5.mailgun.us ([104.130.96.5]:27992 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730382AbgKJSz5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 13:55:57 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605034557; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=2kmNg+DcYCP30cdie56V5OYbK+DXzLqPEuc1mLQCzB0=;
 b=PxJyimNxrB0su2USWIRdx++NWe4ZfI35/gb+Gpjaw1Tp8Wge8a9uKwg3eHnyupTajhA4xyL+
 brCOc1MnKun7hf/5gvnhPu9gO+1KmQwERFu7uaK0l+O0H9fKLV4FuAMuIOBdTdSiJ+avHIO9
 IQsWddQ+MpQhusFYFML3dVEGaOA=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5faae22734c4908d191fedc4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 10 Nov 2020 18:55:35
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 12EA1C4339C; Tue, 10 Nov 2020 18:55:34 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EF0E1C433C6;
        Tue, 10 Nov 2020 18:55:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EF0E1C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] rsi: Move card interrupt handling to RX thread
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201103180941.443528-1-marex@denx.de>
References: <20201103180941.443528-1-marex@denx.de>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201110185534.12EA1C4339C@smtp.codeaurora.org>
Date:   Tue, 10 Nov 2020 18:55:34 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek Vasut <marex@denx.de> wrote:

> The interrupt handling of the RS911x is particularly heavy. For each RX
> packet, the card does three SDIO transactions, one to read interrupt
> status register, one to RX buffer length, one to read the RX packet(s).
> This translates to ~330 uS per one cycle of interrupt handler. In case
> there is more incoming traffic, this will be more.
> 
> The drivers/mmc/core/sdio_irq.c has the following comment, quote "Just
> like traditional hard IRQ handlers, we expect SDIO IRQ handlers to be
> quick and to the point, so that the holding of the host lock does not
> cover too much work that doesn't require that lock to be held."
> 
> The RS911x interrupt handler does not fit that. This patch therefore
> changes it such that the entire IRQ handler is moved to the RX thread
> instead, and the interrupt handler only wakes the RX thread.
> 
> This is OK, because the interrupt handler only does things which can
> also be done in the RX thread, that is, it checks for firmware loading
> error(s), it checks buffer status, it checks whether a packet arrived
> and if so, reads out the packet and passes it to network stack.
> 
> Moreover, this change permits removal of a code which allocated an
> skbuff only to get 4-byte-aligned buffer, read up to 8kiB of data
> into the skbuff, queue this skbuff into local private queue, then in
> RX thread, this buffer is dequeued, the data in the skbuff as passed
> to the RSI driver core, and the skbuff is deallocated. All this is
> replaced by directly calling the RSI driver core with local buffer.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Angus Ainslie <angus@akkea.ca>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Martin Kepplinger <martink@posteo.de>
> Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> Cc: Siva Rebbagondla <siva8118@gmail.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>

2 patches applied to wireless-drivers-next.git, thanks.

287431463e78 rsi: Move card interrupt handling to RX thread
abd131a19f6b rsi: Clean up loop in the interrupt handler

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201103180941.443528-1-marex@denx.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


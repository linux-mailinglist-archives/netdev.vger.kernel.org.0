Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A414378303
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 12:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhEJKl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 06:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232592AbhEJKju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 06:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FBD1616EB;
        Mon, 10 May 2021 10:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642642;
        bh=p0/9GNzb2Z1L70sg3pa0/wbT0izlpUcsgxaub4LvsEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jugv8VemxV6o8vzQ8lMmVVnhbqebyv6zKdyjxelrkrXw4bm3cS2d7w9Q/TYEi7qfr
         To43kiM/HYTOa0zJvisBYzGkUBFF9FyWZ05FJ3FqcVbkF/TELW15jCWhIoIOt9md1y
         OckJYHHTX51SB7d5fmHIbPkxYfv03H4YIebGDwH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Karun Eagalapati <karun256@gmail.com>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 5.4 178/184] rsi: Use resume_noirq for SDIO
Date:   Mon, 10 May 2021 12:21:12 +0200
Message-Id: <20210510101955.950375595@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit c434e5e48dc4e626364491455f97e2db0aa137b1 upstream.

The rsi_resume() does access the bus to enable interrupts on the RSI
SDIO WiFi card, however when calling sdio_claim_host() in the resume
path, it is possible the bus is already claimed and sdio_claim_host()
spins indefinitelly. Enable the SDIO card interrupts in resume_noirq
instead to prevent anything else from claiming the SDIO bus first.

Fixes: 20db07332736 ("rsi: sdio suspend and resume support")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Cc: Angus Ainslie <angus@akkea.ca>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Karun Eagalapati <karun256@gmail.com>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210327235932.175896-1-marex@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1511,7 +1511,7 @@ static int rsi_restore(struct device *de
 }
 static const struct dev_pm_ops rsi_pm_ops = {
 	.suspend = rsi_suspend,
-	.resume = rsi_resume,
+	.resume_noirq = rsi_resume,
 	.freeze = rsi_freeze,
 	.thaw = rsi_thaw,
 	.restore = rsi_restore,



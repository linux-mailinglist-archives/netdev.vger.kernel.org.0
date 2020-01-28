Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB4414C2BB
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 23:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgA1WPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 17:15:18 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:42141 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgA1WPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 17:15:17 -0500
Received: by mail-yb1-f193.google.com with SMTP id z125so5585242ybf.9;
        Tue, 28 Jan 2020 14:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=WO/nRS9efA2jaU/WklByd7JTyruIx9K7cCmh5g/56w8=;
        b=clbGC1USnyA8dsclFpIk3x+1zjO8ld+M52BNjyllqE7oNRzkLUCLUREUZdq1bSC2C+
         43XzQpCcS04+ctxTdiLMAQ/rToX5HBnX3iIS1HywHynDq4QbLkAiRZbwfFx9orpmHbic
         NTTk2pbeW7BkfGXnlvjZO/uR7Kp21wmyM9Hz5B8D9WUMVj24gMcpoXV2zBtPGGRVASce
         B3wgGc8HAc5kkV3iPSdIYb5c+TvQCkaptkN1sgQirtzq8c/reKxKmEUnmNxysXhfIK+7
         VL9e2oUZa352CS9yIQIu/OznwLkPLssfrUy+taYQp7DCnUVC/lC+n906DRXtK7Su44U1
         eYRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=WO/nRS9efA2jaU/WklByd7JTyruIx9K7cCmh5g/56w8=;
        b=OTaXvbrTVuL0MmJryN4o8PUQqIr7G6Yi8kEtWidYwnRR4BLzV0RcELZ3TVpg8CC6Mj
         GTDvPFTGqLWsAJy819A1g9yylZUV8RR591mVGVpmrIyGJ7MIxokNLylGC7h+fM0R2SUE
         F2ytsjlwNLm4zp6IVxff/ndQRU9UyS9BjPlo6UMJICYo6qmRuBzrV1Kn4Nn0TIE04mdR
         EKJ85wiKRkheN2Qw6wvR861HedDSZq4j4PY/ddNPL7pZZjFNxHTM2MdJBjAXLFVfyDwp
         OMayDHJk+UkmXJY2cVoLEn5R6+p8iS2bPArt8D+9MDmdri/24Qj/DNqITnqvKUL3Xuzc
         K54w==
X-Gm-Message-State: APjAAAUsaPNzMe9yzho7vyE/o467pKO2gtBnB1UwexZafIxnns8OwJPU
        cyqECU10IdOHw2Mu+1PKbyM=
X-Google-Smtp-Source: APXvYqwfpQ/wP6r1KP5a33g8F0cBdliNI0SCjYSrisRyCh/wAQneJm9e9B/vLJjhHeAbSd6n5CGolw==
X-Received: by 2002:a25:d055:: with SMTP id h82mr18932492ybg.418.1580249716373;
        Tue, 28 Jan 2020 14:15:16 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l37sm64830ywa.103.2020.01.28.14.15.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jan 2020 14:15:15 -0800 (PST)
From:   Guenter Roeck <linux@roeck-us.net>
To:     Kalle Valo <kvalo@codeaurora.org>
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
Subject: [PATCH] brcmfmac: abort and release host after error
Date:   Tue, 28 Jan 2020 14:14:57 -0800
Message-Id: <20200128221457.12467-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit 216b44000ada ("brcmfmac: Fix use after free in
brcmf_sdio_readframes()") applied, we see locking timeouts in
brcmf_sdio_watchdog_thread().

brcmfmac: brcmf_escan_timeout: timer expired
INFO: task brcmf_wdog/mmc1:621 blocked for more than 120 seconds.
Not tainted 4.19.94-07984-g24ff99a0f713 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
brcmf_wdog/mmc1 D    0   621      2 0x00000000 last_sleep: 2440793077.  last_runnable: 2440766827
[<c0aa1e60>] (__schedule) from [<c0aa2100>] (schedule+0x98/0xc4)
[<c0aa2100>] (schedule) from [<c0853830>] (__mmc_claim_host+0x154/0x274)
[<c0853830>] (__mmc_claim_host) from [<bf10c5b8>] (brcmf_sdio_watchdog_thread+0x1b0/0x1f8 [brcmfmac])
[<bf10c5b8>] (brcmf_sdio_watchdog_thread [brcmfmac]) from [<c02570b8>] (kthread+0x178/0x180)

In addition to restarting or exiting the loop, it is also necessary to
abort the command and to release the host.

Fixes: 216b44000ada ("brcmfmac: Fix use after free in brcmf_sdio_readframes()")
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index f9df95bc7fa1..2e1c23c7269d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1938,6 +1938,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			if (brcmf_sdio_hdparse(bus, bus->rxhdr, &rd_new,
 					       BRCMF_SDIO_FT_NORMAL)) {
 				rd->len = 0;
+				brcmf_sdio_rxfail(bus, true, true);
+				sdio_release_host(bus->sdiodev->func1);
 				brcmu_pkt_buf_free_skb(pkt);
 				continue;
 			}
-- 
2.17.1


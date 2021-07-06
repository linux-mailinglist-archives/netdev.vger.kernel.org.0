Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF593BCCAD
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhGFLT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232852AbhGFLTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68EC461C65;
        Tue,  6 Jul 2021 11:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570193;
        bh=NQy8nTnLvXU/vhv4B5FMdCwgkqRgd+S+GC6IS4N4NfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9NQ4sA9u0tdenBOwMxPz1bi6UWsSd/wTTPmLnERpMIJD1ypRyfP9+C3k/h3Mu8td
         uAHDW8avC+L84MCUkqXBFrPGYqbp9kVIEj4DKvkTNb3ZUO86BEAt3/zpureHvtxNHR
         M6vl46EwqFB6AsOKgtCQPE92t6ggOZG4taLwHKQx3AXh9dnP4egZ2aYWsQfSNnVCZm
         xdvY1MmSM+DsKRfFRv7rFKk+DYrspYiqqbmr7wEE9zxc7mrG9nTSfDE3TyFEU0RxcJ
         FNb0KzuKDJNP/rmhrU1q8Ksol5VoCdBs/uXi6bxci9uwAYWIf0Kut0G82G5TJXJ60q
         VDaZMmI5FWXmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Carl Philipp Klemm <philipp@uvos.xyz>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 107/189] wlcore/wl12xx: Fix wl12xx get_mac error if device is in ELP
Date:   Tue,  6 Jul 2021 07:12:47 -0400
Message-Id: <20210706111409.2058071-107-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 11ef6bc846dcdce838f0b00c5f6a562c57e5d43b ]

At least on wl12xx, reading the MAC after boot can fail with a warning
at drivers/net/wireless/ti/wlcore/sdio.c:78 wl12xx_sdio_raw_read.
The failed call comes from wl12xx_get_mac() that wlcore_nvs_cb() calls
after request_firmware_work_func().

After the error, no wireless interface is created. Reloading the wl12xx
module makes the interface work.

Turns out the wlan controller can be in a low-power ELP state after the
boot from the bootloader or kexec, and needs to be woken up first.

Let's wake the hardware and add a sleep after that similar to
wl12xx_pre_boot() is already doing.

Note that a similar issue could exist for wl18xx, but I have not seen it
so far. And a search for wl18xx_get_mac and wl12xx_sdio_raw_read did not
produce similar errors.

Cc: Carl Philipp Klemm <philipp@uvos.xyz>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210603062814.19464-1-tony@atomide.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl12xx/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 9d7dbfe7fe0c..c6da0cfb4afb 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1503,6 +1503,13 @@ static int wl12xx_get_fuse_mac(struct wl1271 *wl)
 	u32 mac1, mac2;
 	int ret;
 
+	/* Device may be in ELP from the bootloader or kexec */
+	ret = wlcore_write32(wl, WL12XX_WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
+	if (ret < 0)
+		goto out;
+
+	usleep_range(500000, 700000);
+
 	ret = wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
 	if (ret < 0)
 		goto out;
-- 
2.30.2


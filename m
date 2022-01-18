Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C935491BAA
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352072AbiARDIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245299AbiARC46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:56:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F07C0613AC;
        Mon, 17 Jan 2022 18:44:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE293B8125F;
        Tue, 18 Jan 2022 02:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DF1C36AE3;
        Tue, 18 Jan 2022 02:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473881;
        bh=dR6pZiRW7TNa1iTDp9N7qtUKzFnTqgXitlsxGEtbyDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mj4eQsOc+t4pPzzfbrbSMnp9+guFX0Kvx1FRQU7JprPFrq9syJ5PoPDh67X/P/CXb
         5XoWJYXoOhc9VjUiHA3kkxcFlAVVXVuoPMmSr+S3C/0jgMGevYZNxHn4eVhRzHdbqR
         Luoob0n2JutUKM64kXFGLH5LIj7jRjhZ5cJJDkSg+g7qzuwIGmckNjAAuxsscF551r
         /thFpl+cBI5s08Fkat1fkkHVewpcA/P7z7ya3p/ANqZxyzpJkqJm7dUj97X//Eb+W3
         oIH79y0nwjcgsxSVuwY1OYczR0vnaMH5oO9L//iRRhfgGracyQ3/YmhfgGsvxF1bjs
         1cDsMxRivYwlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, pontus.fuchs@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/73] ar5523: Fix null-ptr-deref with unexpected WDCMSG_TARGET_START reply
Date:   Mon, 17 Jan 2022 21:43:24 -0500
Message-Id: <20220118024432.1952028-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit ae80b6033834342601e99f74f6a62ff5092b1cee ]

Unexpected WDCMSG_TARGET_START replay can lead to null-ptr-deref
when ar->tx_cmd->odata is NULL. The patch adds a null check to
prevent such case.

KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 ar5523_cmd+0x46a/0x581 [ar5523]
 ar5523_probe.cold+0x1b7/0x18da [ar5523]
 ? ar5523_cmd_rx_cb+0x7a0/0x7a0 [ar5523]
 ? __pm_runtime_set_status+0x54a/0x8f0
 ? _raw_spin_trylock_bh+0x120/0x120
 ? pm_runtime_barrier+0x220/0x220
 ? __pm_runtime_resume+0xb1/0xf0
 usb_probe_interface+0x25b/0x710
 really_probe+0x209/0x5d0
 driver_probe_device+0xc6/0x1b0
 device_driver_attach+0xe2/0x120

I found the bug using a custome USBFuzz port. It's a research work
to fuzz USB stack/drivers. I modified it to fuzz ath9k driver only,
providing hand-crafted usb descriptors to QEMU.

After fixing the code (fourth byte in usb packet) to WDCMSG_TARGET_START,
I got the null-ptr-deref bug. I believe the bug is triggerable whenever
cmd->odata is NULL. After patching, I tested with the same input and no
longer see the KASAN report.

This was NOT tested on a real device.

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/YXsmPQ3awHFLuAj2@10-18-43-117.dynapool.wireless.nyu.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 4c57e79e5779a..58e189ec672f9 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -153,6 +153,10 @@ static void ar5523_cmd_rx_cb(struct urb *urb)
 			ar5523_err(ar, "Invalid reply to WDCMSG_TARGET_START");
 			return;
 		}
+		if (!cmd->odata) {
+			ar5523_err(ar, "Unexpected WDCMSG_TARGET_START reply");
+			return;
+		}
 		memcpy(cmd->odata, hdr + 1, sizeof(u32));
 		cmd->olen = sizeof(u32);
 		cmd->res = 0;
-- 
2.34.1


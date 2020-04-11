Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F581A568B
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbgDKXQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729577AbgDKXOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:14:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E8CD21D7A;
        Sat, 11 Apr 2020 23:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646878;
        bh=kYkhjG0AGoYc0DOr12jKqAZr7EiG3+2d+ZUkMBZ5aw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q35wEW3H7EO2G1+KKtBPTd8toKf6UxoDrAXvbuyM3prGZ9qTRBccUDx8NXRQLUI8p
         6mKhCaznd6Jh0AYCdzwICTDEybgyo1RH5BubnKfrk3DOX9iLgpRV+clOpIYxosm1BY
         U63FA+OryHSzF+kdK5chO/Nld6x6fStiJ4qkdAr0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raveendran Somu <raveendran.somu@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 20/26] brcmfmac: Fix driver crash on USB control transfer timeout
Date:   Sat, 11 Apr 2020 19:14:07 -0400
Message-Id: <20200411231413.26911-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231413.26911-1-sashal@kernel.org>
References: <20200411231413.26911-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raveendran Somu <raveendran.somu@cypress.com>

[ Upstream commit 93a5bfbc7cad8bf3dea81c9bc07761c1226a0860 ]

When the control transfer gets timed out, the error status
was returned without killing that urb, this leads to using
the same urb. This issue causes the kernel crash as the same
urb is sumbitted multiple times. The fix is to kill the
urb for timeout transfer before returning error

Signed-off-by: Raveendran Somu <raveendran.somu@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1585124429-97371-2-git-send-email-chi-hsien.lin@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 31727f34381fe..6a87681b52abf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -336,11 +336,12 @@ static int brcmf_usb_tx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 		return err;
 	}
 	timeout = brcmf_usb_ioctl_resp_wait(devinfo);
-	clear_bit(0, &devinfo->ctl_op);
 	if (!timeout) {
 		brcmf_err("Txctl wait timed out\n");
+		usb_kill_urb(devinfo->ctl_urb);
 		err = -EIO;
 	}
+	clear_bit(0, &devinfo->ctl_op);
 	return err;
 }
 
@@ -366,11 +367,12 @@ static int brcmf_usb_rx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	}
 	timeout = brcmf_usb_ioctl_resp_wait(devinfo);
 	err = devinfo->ctl_urb_status;
-	clear_bit(0, &devinfo->ctl_op);
 	if (!timeout) {
 		brcmf_err("rxctl wait timed out\n");
+		usb_kill_urb(devinfo->ctl_urb);
 		err = -EIO;
 	}
+	clear_bit(0, &devinfo->ctl_op);
 	if (!err)
 		return devinfo->ctl_urb_actual_length;
 	else
-- 
2.20.1


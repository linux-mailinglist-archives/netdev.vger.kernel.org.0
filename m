Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7294E5CED
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfJZNd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727531AbfJZNRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:17:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F60A21D80;
        Sat, 26 Oct 2019 13:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095871;
        bh=Nw/PIM1BjEYj1uKwxNWpIozPv3bYm3XR3iJqsJno1EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vPu2tHzAruBId00QFJyMfZiEDGO6cPuhHnskQ3wISjBaEULY81dz9QJ6eeB1D/a3
         +lXSfA27tKgPNGSwEt34fnL+deJK7il+gakcO9EvtAO4OzcCWiQd1s8CbF4JwX4nWE
         XohtOPLhsAFZ2Eu94IntoSPN0hC/8GDP+fMUmhhs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 60/99] ath10k: fix latency issue for QCA988x
Date:   Sat, 26 Oct 2019 09:15:21 -0400
Message-Id: <20191026131600.2507-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit d79749f7716d9dc32fa2d5075f6ec29aac63c76d ]

(kvalo: cherry picked from commit 1340cc631bd00431e2f174525c971f119df9efa1 in
wireless-drivers-next to wireless-drivers as this a frequently reported
regression)

Bad latency is found on QCA988x, the issue was introduced by
commit 4504f0e5b571 ("ath10k: sdio: workaround firmware UART
pin configuration bug"). If uart_pin_workaround is false, this
change will set uart pin even if uart_print is false.

Tested HW: QCA9880
Tested FW: 10.2.4-1.0-00037

Fixes: 4504f0e5b571 ("ath10k: sdio: workaround firmware UART pin configuration bug")
Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index dc45d16e8d214..383d4fa555a88 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2118,12 +2118,15 @@ static int ath10k_init_uart(struct ath10k *ar)
 		return ret;
 	}
 
-	if (!uart_print && ar->hw_params.uart_pin_workaround) {
-		ret = ath10k_bmi_write32(ar, hi_dbg_uart_txpin,
-					 ar->hw_params.uart_pin);
-		if (ret) {
-			ath10k_warn(ar, "failed to set UART TX pin: %d", ret);
-			return ret;
+	if (!uart_print) {
+		if (ar->hw_params.uart_pin_workaround) {
+			ret = ath10k_bmi_write32(ar, hi_dbg_uart_txpin,
+						 ar->hw_params.uart_pin);
+			if (ret) {
+				ath10k_warn(ar, "failed to set UART TX pin: %d",
+					    ret);
+				return ret;
+			}
 		}
 
 		return 0;
-- 
2.20.1


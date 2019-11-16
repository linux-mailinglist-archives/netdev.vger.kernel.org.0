Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCA6FEDBC
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfKPPqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:46:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbfKPPqb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:31 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B52C820833;
        Sat, 16 Nov 2019 15:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919191;
        bh=YRIoyCqFbllyk9Rbao0HAflYjxyFvS7VSLfoVAW4XKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ut1MxyLUNChfpP4BvrP2Xvxu5N7SydHrf6lLioKOmoSsG0n6lIdhUDsTulS7RSZkZ
         TGUeJmKR6EDHpWpypHG8bSgAuu3vp+6bYTBhlOYW144KeFUI7Ktb3ipECW0Z3ajGtY
         Tsp9mB+x48+7Wu1EyUEC0tIZU8vSl5ek/QrflQ5M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Norris <briannorris@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 200/237] ath10k: snoc: fix unbalanced clock error handling
Date:   Sat, 16 Nov 2019 10:40:35 -0500
Message-Id: <20191116154113.7417-200-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 82e60d920e8ad70cd9a280ab156566755f1fe4aa ]

Similar to regulator error handling, we should only start tearing down
the 'i - 1' clock when clock 'i' fails to enable. Otherwise, we might
end up with an unbalanced clock, where we never successfully enabled the
clock, but we try to disable it anyway.

Fixes: a6a793f98786 ("ath10k: vote for hardware resources for WCN3990")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index fa1843a7e0fda..e2d78f77edb70 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1190,7 +1190,7 @@ static int ath10k_wcn3990_clk_init(struct ath10k *ar)
 	return 0;
 
 err_clock_config:
-	for (; i >= 0; i--) {
+	for (i = i - 1; i >= 0; i--) {
 		clk_info = &ar_snoc->clk[i];
 
 		if (!clk_info->handle)
-- 
2.20.1


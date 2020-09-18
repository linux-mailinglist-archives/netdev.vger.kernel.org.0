Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6440526F48F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbgIRDPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbgIRCB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C8AF21D40;
        Fri, 18 Sep 2020 02:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394486;
        bh=H8WaB6BrPJvOK0/+mDoNVBymGhqmdOHaFv38C5S0Xow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzCm7hv8XcKg1CxHjHJSHazN685HAqZZvNrpSg74aL9ffiCCJWFi1FMk+/srpwrN1
         ASDK2F0K2/niRsWPN9FLrlyjCvXnEFawAygmDwaUKI3V3cUZWrYcs9jjx0sjX5aP1L
         HsmeLbQPM21wzaiDTbj9PEnFB9ixkM6+LSLsdDhE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 012/330] ath10k: fix memory leak for tpc_stats_final
Date:   Thu, 17 Sep 2020 21:55:52 -0400
Message-Id: <20200918020110.2063155-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit 486a8849843455298d49e694cca9968336ce2327 ]

The memory of ar->debug.tpc_stats_final is reallocated every debugfs
reading, it should be freed in ath10k_debug_destroy() for the last
allocation.

Tested HW: QCA9984
Tested FW: 10.4-3.9.0.2-00035

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 40baf25ac99f3..04c50a26a4f47 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2532,6 +2532,7 @@ void ath10k_debug_destroy(struct ath10k *ar)
 	ath10k_debug_fw_stats_reset(ar);
 
 	kfree(ar->debug.tpc_stats);
+	kfree(ar->debug.tpc_stats_final);
 }
 
 int ath10k_debug_register(struct ath10k *ar)
-- 
2.25.1


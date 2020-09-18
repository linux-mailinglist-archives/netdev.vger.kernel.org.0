Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A9A26EBD1
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgIRCHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:07:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727908AbgIRCHX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 082AE2389E;
        Fri, 18 Sep 2020 02:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394842;
        bh=fO15eBwbnxmL4fI+RPHnRPQiHTZvIx9WsiBnsp2ccqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJm6zfo+AWKQXj10w2uqpKDocRzvMtguDGmTzo1I6N91pUOla+xZWYM0mGNRm66Zj
         xO7GzWTR+PFPpM66Oi87wY0xQOVUnhfuFQuDMKsSIUtpPjDANlV81ukgvziX33hp/h
         eexNOGryNDk/+BVeLzJJNx91bQR3LvHprJnUSL+I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 300/330] wlcore: fix runtime pm imbalance in wl1271_tx_work
Date:   Thu, 17 Sep 2020 22:00:40 -0400
Message-Id: <20200918020110.2063155-300-sashal@kernel.org>
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

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 9604617e998b49f7695fea1479ed82421ef8c9f0 ]

There are two error handling paths in this functon. When
wlcore_tx_work_locked() returns an error code, we should
decrease the runtime PM usage counter the same way as the
error handling path beginning from pm_runtime_get_sync().

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200520124241.9931-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 90e56d4c3df3b..e20e18cd04aed 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -863,6 +863,7 @@ void wl1271_tx_work(struct work_struct *work)
 
 	ret = wlcore_tx_work_locked(wl);
 	if (ret < 0) {
+		pm_runtime_put_noidle(wl->dev);
 		wl12xx_queue_recovery_work(wl);
 		goto out;
 	}
-- 
2.25.1


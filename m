Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A66026F1E2
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgIRCyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727913AbgIRCHY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 484BA23977;
        Fri, 18 Sep 2020 02:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394844;
        bh=eoF0dWdcNrs2Y2ahm54PqBUOZIWXLcODEYHV/h1kc8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5sBSxkpPUNwqfAlq9xdRzDSGUhO1n4sCUnRoq8Vf4Yl/3M2oDqX/j4HketttmrrF
         /lsLzurWzw6Y4EB7PfhY/xKdybH/sCs+SuY1smHnExZBjlgQcMQ6Q9pE7neKkxCORR
         GY/6AMWdOtE04Zvw8HcAVljYxQAiGh3q14+z4COE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 301/330] wlcore: fix runtime pm imbalance in wlcore_regdomain_config
Date:   Thu, 17 Sep 2020 22:00:41 -0400
Message-Id: <20200918020110.2063155-301-sashal@kernel.org>
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

[ Upstream commit 282a04bf1d8029eb98585cb5db3fd70fe8bc91f7 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
the call returns an error code. Thus a pairing decrement is needed
on the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200520124649.10848-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 547ad538d8b66..5f74cf821068d 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3658,8 +3658,10 @@ void wlcore_regdomain_config(struct wl1271 *wl)
 		goto out;
 
 	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(wl->dev);
 		goto out;
+	}
 
 	ret = wlcore_cmd_regdomain_config_locked(wl);
 	if (ret < 0) {
-- 
2.25.1


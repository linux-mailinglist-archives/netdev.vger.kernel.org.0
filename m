Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119833BD5E6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbhGFMZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237172AbhGFLf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7228961EB7;
        Tue,  6 Jul 2021 11:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570752;
        bh=5tDp/ZueAwz4bjmm/8YY1xZ7y9gXCB+4EX/TPbZVNk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AY4yKzukE8h/dLQteHUOUUZspIAy7nlqrAAf05bwDkSrT/Zp/4I7CxFjy0h3qSSj0
         5V2jFYIigC3Qw7SiuVEwks0joiWyAY6kvSPCvZVlw6YDZp0z9nkbsSi0mGIuWpk6Vd
         9msgG1AglgNorW7aluf3dCoTtuIp815cLvSRhxFfQ/SRkrqUejYYzxI6nKTonlLaVi
         wBoKI0vxhmNbwLqQUTuOFVHQSMEsNtMrBGHpFDEmGtEYUwS4ULBhHKDGFscZJ3Ijed
         sZHmso5IO3wozXGsMtJ7z0vj0uHByDyLYsUROrpkJjqlM3AFHwWJcTM+ePAauFampk
         ZogTiEefxi7qA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 39/74] fjes: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:24:27 -0400
Message-Id: <20210706112502.2064236-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f18c11812c949553d2b2481ecaa274dd51bed1e7 ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/fjes/fjes_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 91a1059517f5..b89b4a3800a4 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1262,6 +1262,10 @@ static int fjes_probe(struct platform_device *plat_dev)
 	adapter->interrupt_watch_enable = false;
 
 	res = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -EINVAL;
+		goto err_free_control_wq;
+	}
 	hw->hw_res.start = res->start;
 	hw->hw_res.size = resource_size(res);
 	hw->hw_res.irq = platform_get_irq(plat_dev, 0);
-- 
2.30.2


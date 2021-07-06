Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5C03BD2BA
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239687AbhGFLo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232366AbhGFLgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B1F161F0C;
        Tue,  6 Jul 2021 11:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570950;
        bh=ewg361im44F8sFW1ZFkaddSWziBwf+YTsPrcJ9kXGLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSDb2niVS7GUcMCt1Y3ngCUSi3UOLgCTtCdcIoZPZUPXK0bgbOo3DZGQKou5gE0HD
         mMnf/BQAThHHVKXTKxcpBUUnk8OUDQ+W5cKOV7UvfVkGD2UWZCXO57Uag4l4vGHLO+
         XJjaOFcSJy40iD+v8/S7qQEGKx9h8qB9wcwTsHc6Njz19vhi4Ylw4UWkKmgp3eDGt1
         4qy76lJfhrsrvGJtcgkYkEhNenU4vC8+HHJF4gVIegWXpxWT4lr4jEKUi0J0dt8fv+
         vmStfNbcDsYqnP1GoKzQbatC30CyzYEEIXrxeZG4WO0uOyDyJ/Wa26/rUg2fWf0FDg
         wTq3C6T4L3RAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 18/35] fjes: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:28:30 -0400
Message-Id: <20210706112848.2066036-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112848.2066036-1-sashal@kernel.org>
References: <20210706112848.2066036-1-sashal@kernel.org>
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
index 3511d40ba3f1..440047a239f5 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1212,6 +1212,10 @@ static int fjes_probe(struct platform_device *plat_dev)
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F833BD101
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237965AbhGFLhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236563AbhGFLfb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B357161E2D;
        Tue,  6 Jul 2021 11:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570622;
        bh=KZaRLMtRE0FWoJ0aN/q7uQVN7VWE0e1ynuofh4g/AEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sy8WMAyi6SVVcgecra5AW7LnefB7oZRilIBz+lB6NOhKujCpnfyLk7JUmzOIfaEzr
         teXea5GImTIsbbL71KqJtQSJQ6tA5F3j5F80NONZVYEe4LtWc5xJgH5hPSy6wG9V+E
         wsAVk/Pnl0I7Ro/+6Sgsk3ZQLGpkDDHYBqdXt1WnX/ttaKSYASuPR/V1fXuHCqzIqY
         8qHHcZQhyNCTl56c24JiG2/No89U7UcOBPfNh8pn3T0zRlTfdT0rdbWlcUgejUcxKZ
         b1pR++fzV3/APPoVfxZem5GJ4d7AYmS8JIY6LHCqSfK34biSe+M27UIhUkWx8/yxbR
         E+hr97bmYYxTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 076/137] fjes: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:21:02 -0400
Message-Id: <20210706112203.2062605-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index 466622664424..e449d9466122 100644
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


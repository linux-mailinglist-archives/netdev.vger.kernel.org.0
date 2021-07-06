Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4BA3BD1AB
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238721AbhGFLkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237532AbhGFLgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 912AA61F20;
        Tue,  6 Jul 2021 11:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570901;
        bh=u1PpIDPS7NFiht1LIP/tao01czv2fiehmhzB/rd0p+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtenzghXfgs32XcvPo1CwQzaJn3/sWxZp1k9Fa+NkVQgAvKRHzm1+1HNOZNMrfALE
         QOqYo1SdoZZau3I6en3ofESGEYoehnsDJ88HB7H+t4oI1Uqi16cBg8RelcM0S2bqWj
         ta5YTOWus2TouHsOdVfzNJYHb1WXGKQ9zWO9J003a+LB8LT0gILyBDOrJaJ1NNe9Rq
         DbqmBvhGAe/bg6dR+It6in+QrcQitCrKDaYiQYxsTTe5th4AGQpZ2qkKKOwUFV17Z8
         sID29YeBD41B9F7Jvij2a4tffUvgAypHVq1KVbEblopaBQOlG6bfhAY97xB0J3V+Gq
         PUTYlHXbY7iCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 25/45] fjes: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:27:29 -0400
Message-Id: <20210706112749.2065541-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112749.2065541-1-sashal@kernel.org>
References: <20210706112749.2065541-1-sashal@kernel.org>
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
index 314e3eac09b9..26d3051591da 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1277,6 +1277,10 @@ static int fjes_probe(struct platform_device *plat_dev)
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


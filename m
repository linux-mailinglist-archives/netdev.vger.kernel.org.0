Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91F31F3173
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 03:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388176AbgFIBJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 21:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbgFHXGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 822692078C;
        Mon,  8 Jun 2020 23:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657594;
        bh=rza3GijJEHiYQS6naUd/LTVSyFhudYeYmLttrcZ8jOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5eG3ktZYMifgzMt7m0OJalm0RkBxpin3ruCipnjkVYysg0fCbvAi2VkClacudXeL
         dQBuC5nVZPrtyTWSZu66XrHe6ElomP9UtCc3h7qwheqiU/cLXWuLfLN93hVyGDhQnS
         wxi7uXBGm9H7trsXE7Jupq0EEZSyUXlpHR2IdxnA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 021/274] net: ethernet: ti: fix return value check in k3_cppi_desc_pool_create_name()
Date:   Mon,  8 Jun 2020 19:01:54 -0400
Message-Id: <20200608230607.3361041-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 2ac757e4152e3322a04a6dfb3d1fa010d3521abf ]

In case of error, the function gen_pool_create() returns NULL pointer
not ERR_PTR(). The IS_ERR() test in the return value check should be
replaced with NULL test.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/k3-cppi-desc-pool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/k3-cppi-desc-pool.c b/drivers/net/ethernet/ti/k3-cppi-desc-pool.c
index ad7cfc1316ce..38cc12f9f133 100644
--- a/drivers/net/ethernet/ti/k3-cppi-desc-pool.c
+++ b/drivers/net/ethernet/ti/k3-cppi-desc-pool.c
@@ -64,8 +64,8 @@ k3_cppi_desc_pool_create_name(struct device *dev, size_t size,
 		return ERR_PTR(-ENOMEM);
 
 	pool->gen_pool = gen_pool_create(ilog2(pool->desc_size), -1);
-	if (IS_ERR(pool->gen_pool)) {
-		ret = PTR_ERR(pool->gen_pool);
+	if (!pool->gen_pool) {
+		ret = -ENOMEM;
 		dev_err(pool->dev, "pool create failed %d\n", ret);
 		kfree_const(pool_name);
 		goto gen_pool_create_fail;
-- 
2.25.1


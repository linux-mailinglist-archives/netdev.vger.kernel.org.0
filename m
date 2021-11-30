Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB026463907
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245251AbhK3PHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244552AbhK3PCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:02:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC02C0619F1;
        Tue, 30 Nov 2021 06:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67E23B81A68;
        Tue, 30 Nov 2021 14:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B101C53FC1;
        Tue, 30 Nov 2021 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284013;
        bh=hHgPqXolaheT9JuEhi4sUzMucUnEutrG6XsRGnG2b58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWimAurznyO4xVnJjBL3jAjQUWkuKs7v/tVNfqPEtAQQh5vIvqIcvLJ+31pRQOgEP
         0zDu6w0lotcAUNW2orqrp/bO2+xb5cQpyr4hTfmlBQM+48sfFvB9v28/d38n0JNALw
         zdfAOXiJqSwNDnFtFhJ0yHMLgG56s5aA0SLHWtRcCczmFksTpveTRR/ZnQmIGCAZIA
         j3fo0tBaXgdoyEjwVDut7OIekxD4A9eU7unOEi9X6YVGIp2i5WQryioE6LVE9HETEJ
         RSqbSI8dqK8DzAsNvXjRESlkakKtdKi7nS7Zd9YXmucALvB+7iVzFtMxFj9HzEWqw5
         39K1UsSFUeNKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, rajur@chelsio.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/14] net: chelsio: cxgb4vf: Fix an error code in cxgb4vf_pci_probe()
Date:   Tue, 30 Nov 2021 09:53:10 -0500
Message-Id: <20211130145317.946676-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145317.946676-1-sashal@kernel.org>
References: <20211130145317.946676-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit b82d71c0f84a2e5ccaaa7571dfd5c69e0e2cfb4a ]

During the process of driver probing, probe function should return < 0
for failure, otherwise kernel will treat value == 0 as success.

Therefore, we should set err to -EINVAL when
adapter->registered_device_map is NULL. Otherwise kernel will assume
that driver has been successfully probed and will cause unexpected
errors.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index fa116f0a107db..8ebc0398de767 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -3100,6 +3100,7 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 	}
 	if (adapter->registered_device_map == 0) {
 		dev_err(&pdev->dev, "could not register any net devices\n");
+		err = -EINVAL;
 		goto err_disable_interrupts;
 	}
 
-- 
2.33.0


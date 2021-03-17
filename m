Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCABB33E54B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhCQBCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231269AbhCQA74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A218C64F9F;
        Wed, 17 Mar 2021 00:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942796;
        bh=NCREDiYkF9t8YSmZJjZdwMr96woroBhFxbt91BlFNaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1XXJdiu3xzCu+Sb0vBAvIXEW7UJLcFm5X+lFdVLkFq9gAA1lCnd5pMbsc+BLMdL7
         oDOIK2nijTbcD/t+53h0T5/Vw8DUmWCFt5iEOMNHLbrfoQtP4VOY/tktlOw5FGiW80
         P3lDNtNmgVVnhWAQDo7fcP723Si76oB9HJi7bn0rRKokOZTPrD+eQuhdHvpZSA2u10
         2UmKU5saTog9CtBJ3O7J82rM7vuV/wBlX6C5IZsHK2W9sqBCM5EeQCsTKtJ9kStVIQ
         2VWRkYCz7hV1+RrlPr6IYDcUoNARsLnRd9TyWILj6ZgOQYDOYoNmxIOfea9zQKnILA
         Rx0Vpzd4csBmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/16] net: tehuti: fix error return code in bdx_probe()
Date:   Tue, 16 Mar 2021 20:59:37 -0400
Message-Id: <20210317005948.727250-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005948.727250-1-sashal@kernel.org>
References: <20210317005948.727250-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 38c26ff3048af50eee3fcd591921357ee5bfd9ee ]

When bdx_read_mac() fails, no error return code of bdx_probe()
is assigned.
To fix this bug, err is assigned with -EFAULT as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/tehuti/tehuti.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 7108c68f16d3..6ee7f8d2f2d1 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2062,6 +2062,7 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/*bdx_hw_reset(priv); */
 		if (bdx_read_mac(priv)) {
 			pr_err("load MAC address failed\n");
+			err = -EFAULT;
 			goto err_out_iomap;
 		}
 		SET_NETDEV_DEV(ndev, &pdev->dev);
-- 
2.30.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF75E3BCBF0
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhGFLR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232131AbhGFLRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2532B61C28;
        Tue,  6 Jul 2021 11:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570100;
        bh=LexBJeL7GOk299JLac4Qe7GO0C5Z6j22bpkz07vVgj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9Q8jRt01FEEcwF7UF7T+NgkSG6zSWYBb4rDyHd6e/5JAngkrN5k/cQakdaMDEeas
         no34A3EaMVjbJJBv9M3X3bvn3pfyymTI3NnznghmgGTOi2ZilggTaauR8QA0QGD7FR
         riM/EKWipw2S2i6Vlb8QXBqc3TOX2CqFxbwBm7tRpXerIW026itlf2yfDe3LPxQpk/
         YgyYzYgoRvpujsahkpQMYFRLQCDy6Pjnferb8eMG2gZN1p6ixFugnSmn93QUtdca9y
         zrB6YOaeesUuBaM48l9S3VpQC8Q2qFzocReNWbimNyXs1ESProV1fA+8Q9/eE1EGaO
         HFcuaLZogQviw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 035/189] net: ethernet: ixp4xx: Fix return value check in ixp4xx_eth_probe()
Date:   Tue,  6 Jul 2021 07:11:35 -0400
Message-Id: <20210706111409.2058071-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 20e76d3d044d936998617f8acd7e77bebd9ca703 ]

In case of error, the function mdiobus_get_phy() returns NULL
pointer not ERR_PTR(). The IS_ERR() test in the return value
check should be replaced with NULL test.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index cb89323855d8..1ecceeb9700d 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1531,8 +1531,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 		phydev = of_phy_get_and_connect(ndev, np, ixp4xx_adjust_link);
 	} else {
 		phydev = mdiobus_get_phy(mdio_bus, plat->phy);
-		if (IS_ERR(phydev)) {
-			err = PTR_ERR(phydev);
+		if (!phydev) {
+			err = -ENODEV;
 			dev_err(dev, "could not connect phydev (%d)\n", err);
 			goto err_free_mem;
 		}
-- 
2.30.2


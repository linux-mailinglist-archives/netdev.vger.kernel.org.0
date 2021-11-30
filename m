Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6D7463790
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243198AbhK3Oyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242909AbhK3Ox1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:53:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D0BC061396;
        Tue, 30 Nov 2021 06:48:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DBECB81A1C;
        Tue, 30 Nov 2021 14:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D20C53FCF;
        Tue, 30 Nov 2021 14:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283729;
        bh=5RbvXI9M6kcP7CDydmm0QlTa4fNClhKpVcRGGt1zBjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffNer+3UUocJvGKvK9lSo11Sy6aphGjGIwONwy5YkGGdtL1RYHNooTUll1VARp2pA
         nMxUAfw2L2DqXXHoUn2SdhgFyMtXAVqH5DeNX21hg82Yq5ZkdvotzqWMRY5s8Mc7d/
         +p9z57s1JvWtk5sPqxzAvv8d3juOgbQF06/2XKlfH2nvf6S7CmMvC5Qg9rbLgYDy84
         kj4Yb8RVr1HWWmADiVqBDesLmKOjM+d0d0tAMwPSvB3RKNftgdXpocobftlhMMhkZv
         Mk6YgBDFcvYZURtjZakpg0bXCYfaJdFfY6sSVqP+6oZH3TFGKM3FjDlDlAKG6Oe/8d
         +frUnbvZJd/SQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, rajur@chelsio.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 37/68] net: chelsio: cxgb4vf: Fix an error code in cxgb4vf_pci_probe()
Date:   Tue, 30 Nov 2021 09:46:33 -0500
Message-Id: <20211130144707.944580-37-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
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
index 49b76fd47daa0..ff4c0d3fde861 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -3198,6 +3198,7 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 	}
 	if (adapter->registered_device_map == 0) {
 		dev_err(&pdev->dev, "could not register any net devices\n");
+		err = -EINVAL;
 		goto err_disable_interrupts;
 	}
 
-- 
2.33.0

